// Storage service that works in both browser and Tauri environments
const isTauri = typeof window !== 'undefined' && '__TAURI__' in window;

// Browser-compatible storage for development
class BrowserStorage {
  async writeTextFile(path: string, content: string): Promise<void> {
    localStorage.setItem(path, content);
  }

  async readTextFile(path: string): Promise<string> {
    const content = localStorage.getItem(path);
    if (content === null) throw new Error('File not found');
    return content;
  }

  async exists(path: string): Promise<boolean> {
    return localStorage.getItem(path) !== null;
  }

  async createDir(path: string, options?: any): Promise<void> {
    // No-op for browser storage
  }

  async join(...paths: string[]): Promise<string> {
    return paths.join('/');
  }

  async appDataDir(): Promise<string> {
    return 'lifeline-os-data';
  }
}

const browserStorage = new BrowserStorage();

// Tauri API wrappers that completely avoid imports in browser
class TauriAPIs {
  private _path: any = null;
  private _fs: any = null;

  async getPath() {
    if (!this._path && isTauri) {
      try {
        // Use string concatenation to avoid Vite's import analysis
        const moduleName = '@tauri-apps/api/' + 'path';
        this._path = await import(/* @vite-ignore */ moduleName);
      } catch (error) {
        console.warn('Tauri path API not available:', error);
      }
    }
    return this._path;
  }

  async getFs() {
    if (!this._fs && isTauri) {
      try {
        // Use string concatenation to avoid Vite's import analysis
        const moduleName = '@tauri-apps/api/' + 'fs';
        this._fs = await import(/* @vite-ignore */ moduleName);
      } catch (error) {
        console.warn('Tauri fs API not available:', error);
      }
    }
    return this._fs;
  }
}

const tauriAPIs = new TauriAPIs();

export interface AppData {
  tasks: any[];
  goals: any[];
  sessions: any[];
  reflections: any[];
  settings: any;
  ui: any;
  lastSync: string;
}

class StorageService {
  private dataPath: string | null = null;
  private isInitialized = false;

  // Initialize storage system
  async initialize(): Promise<void> {
    try {
      const pathAPI = await tauriAPIs.getPath();
      const fsAPI = await tauriAPIs.getFs();
      
      if (pathAPI && fsAPI) {
        // Use actual Tauri APIs when running as desktop app
        const appDir = await pathAPI.appDataDir();
        this.dataPath = await pathAPI.join(appDir, 'lifeline-os');
        
        // Ensure data directory exists
        if (!await fsAPI.exists(this.dataPath)) {
          await fsAPI.createDir(this.dataPath, { recursive: true });
        }
      } else {
        // Use browser storage for development
        this.dataPath = await browserStorage.appDataDir();
      }

      this.isInitialized = true;
      console.log('Storage service initialized');
    } catch (err) {
      console.error(`Failed to initialize storage: ${err}`);
      throw err;
    }
  }

  // Validate app data before saving
  private validateAppData(data: AppData): AppData {
    // Ensure required fields exist
    const validatedData = {
      tasks: data.tasks || [],
      goals: data.goals || [],
      sessions: data.sessions || [],
      reflections: data.reflections || [],
      settings: data.settings || {},
      ui: data.ui || {},
      lastSync: data.lastSync || new Date().toISOString()
    };

    // Validate tasks array
    validatedData.tasks = validatedData.tasks.filter(task => {
      return task && 
             typeof task.id === 'string' && 
             typeof task.title === 'string' && 
             task.area && 
             task.status;
    });

    // Validate goals array
    validatedData.goals = validatedData.goals.filter(goal => {
      return goal && 
             typeof goal.id === 'string' && 
             typeof goal.title === 'string';
    });

    console.log(`✅ Data validated: ${validatedData.tasks.length} tasks, ${validatedData.goals.length} goals`);
    return validatedData;
  }

  // Save complete app state
  async saveAppData(data: AppData): Promise<void> {
    if (!this.isInitialized || !this.dataPath) {
      throw new Error('Storage not initialized');
    }

    try {
      const validatedData = this.validateAppData(data);
      const dataWithTimestamp = {
        ...validatedData,
        lastSync: new Date().toISOString()
      };

      const pathAPI = await tauriAPIs.getPath();
      const fsAPI = await tauriAPIs.getFs();
      
      if (pathAPI && fsAPI) {
        const filePath = await pathAPI.join(this.dataPath, 'app-data.json');
        await fsAPI.writeTextFile(filePath, JSON.stringify(dataWithTimestamp, null, 2));
        
        // Also create a backup
        const backupPath = await pathAPI.join(this.dataPath, `backup-${Date.now()}.json`);
        await fsAPI.writeTextFile(backupPath, JSON.stringify(dataWithTimestamp, null, 2));
        
        // Keep only last 5 backups
        await this.cleanupBackups();
      } else {
        // Use browser storage
        const filePath = await browserStorage.join(this.dataPath, 'app-data.json');
        await browserStorage.writeTextFile(filePath, JSON.stringify(dataWithTimestamp, null, 2));
      }
      
      console.log('App data saved successfully');
    } catch (err) {
      console.error(`Failed to save app data: ${err}`);
      throw err;
    }
  }

  // Load complete app state
  async loadAppData(): Promise<AppData | null> {
    if (!this.isInitialized || !this.dataPath) {
      await this.initialize();
    }

    try {
      let filePath: string;
      let content: string;
      
      const pathAPI = await tauriAPIs.getPath();
      const fsAPI = await tauriAPIs.getFs();
      
      if (pathAPI && fsAPI) {
        filePath = await pathAPI.join(this.dataPath!, 'app-data.json');
        
        if (!await fsAPI.exists(filePath)) {
          console.log('No saved data found, starting fresh');
          return null;
        }

        content = await fsAPI.readTextFile(filePath);
      } else {
        filePath = await browserStorage.join(this.dataPath!, 'app-data.json');
        
        if (!await browserStorage.exists(filePath)) {
          console.log('No saved data found, starting fresh');
          return null;
        }

        content = await browserStorage.readTextFile(filePath);
      }
      
      const data = JSON.parse(content) as AppData;
      console.log('App data loaded successfully');
      return data;
    } catch (err) {
      console.error(`Failed to load app data: ${err}`);
      
      // Try to load from backup
      try {
        const backupData = await this.loadFromBackup();
        if (backupData) {
          console.log('Loaded from backup successfully');
          return backupData;
        }
      } catch (backupErr) {
        console.error(`Backup recovery also failed: ${backupErr}`);
      }
      
      return null;
    }
  }

  // Export data for backup or transfer
  async exportData(): Promise<string> {
    if (!this.isInitialized || !this.dataPath) {
      throw new Error('Storage not initialized');
    }

    try {
      const filePath = await join(this.dataPath, 'app-data.json');
      
      if (!await exists(filePath)) {
        throw new Error('No data to export');
      }

      const content = await readTextFile(filePath);
      return content;
    } catch (err) {
      console.error(`Failed to export data: ${err}`);
      throw err;
    }
  }

  // Import data from backup or transfer
  async importData(jsonData: string): Promise<void> {
    if (!this.isInitialized || !this.dataPath) {
      throw new Error('Storage not initialized');
    }

    try {
      // Validate JSON
      const data = JSON.parse(jsonData) as AppData;
      
      // Create backup of current data before import
      const currentData = await this.loadAppData();
      if (currentData) {
        const backupPath = await join(this.dataPath, `pre-import-backup-${Date.now()}.json`);
        await writeTextFile(backupPath, JSON.stringify(currentData, null, 2));
      }

      // Save imported data
      await this.saveAppData(data);
      console.log('Data imported successfully');
    } catch (err) {
      console.error(`Failed to import data: ${err}`);
      throw err;
    }
  }

  // Save user preferences and settings
  async saveSettings(settings: any): Promise<void> {
    if (!this.isInitialized || !this.dataPath) {
      throw new Error('Storage not initialized');
    }

    try {
      const filePath = await join(this.dataPath, 'settings.json');
      await writeTextFile(filePath, JSON.stringify(settings, null, 2));
      console.log('Settings saved successfully');
    } catch (err) {
      console.error(`Failed to save settings: ${err}`);
      throw err;
    }
  }

  // Load user preferences and settings
  async loadSettings(): Promise<any> {
    if (!this.isInitialized || !this.dataPath) {
      await this.initialize();
    }

    try {
      const filePath = await join(this.dataPath!, 'settings.json');
      
      if (!await exists(filePath)) {
        return this.getDefaultSettings();
      }

      const content = await readTextFile(filePath);
      return JSON.parse(content);
    } catch (err) {
      console.error(`Failed to load settings: ${err}`);
      return this.getDefaultSettings();
    }
  }

  // Save session logs for analytics
  async saveSessionLog(session: any): Promise<void> {
    if (!this.isInitialized || !this.dataPath) {
      return; // Don't fail if storage isn't ready
    }

    try {
      const logsDir = await join(this.dataPath, 'logs');
      if (!await exists(logsDir)) {
        await createDir(logsDir, { recursive: true });
      }

      const today = new Date().toISOString().split('T')[0];
      const logFile = await join(logsDir, `sessions-${today}.json`);
      
      let sessions = [];
      if (await exists(logFile)) {
        const content = await readTextFile(logFile);
        sessions = JSON.parse(content);
      }

      sessions.push({
        ...session,
        timestamp: new Date().toISOString()
      });

      await writeTextFile(logFile, JSON.stringify(sessions, null, 2));
    } catch (err) {
      console.error(`Failed to save session log: ${err}`);
      // Don't throw - session logging is not critical
    }
  }

  // Get analytics data
  async getAnalytics(days: number = 30): Promise<any> {
    if (!this.isInitialized || !this.dataPath) {
      return null;
    }

    try {
      const logsDir = await join(this.dataPath, 'logs');
      const analytics = {
        totalSessions: 0,
        totalMinutes: 0,
        averageSession: 0,
        completionRate: 0,
        dailyBreakdown: []
      };

      // Read session logs for the last N days
      const today = new Date();
      for (let i = 0; i < days; i++) {
        const date = new Date(today);
        date.setDate(date.getDate() - i);
        const dateStr = date.toISOString().split('T')[0];
        
        const logFile = await join(logsDir, `sessions-${dateStr}.json`);
        if (await exists(logFile)) {
          const content = await readTextFile(logFile);
          const sessions = JSON.parse(content);
          
          const dayMinutes = sessions.reduce((total: number, s: any) => total + s.actualMin, 0);
          const completedSessions = sessions.filter((s: any) => s.outcome === 'completed').length;
          
          analytics.totalSessions += sessions.length;
          analytics.totalMinutes += dayMinutes;
          analytics.dailyBreakdown.push({
            date: dateStr,
            sessions: sessions.length,
            minutes: dayMinutes,
            completionRate: sessions.length > 0 ? completedSessions / sessions.length : 0
          });
        }
      }

      analytics.averageSession = analytics.totalSessions > 0 ? analytics.totalMinutes / analytics.totalSessions : 0;
      analytics.completionRate = analytics.totalSessions > 0 ? 
        analytics.dailyBreakdown.reduce((sum, day) => sum + day.completionRate, 0) / analytics.dailyBreakdown.length : 0;

      return analytics;
    } catch (err) {
      console.error(`Failed to get analytics: ${err}`);
      return null;
    }
  }

  // Private helper methods
  private async loadFromBackup(): Promise<AppData | null> {
    if (!this.dataPath) return null;

    try {
      // Find the most recent backup file
      const backupFiles = await invoke('list_files', { 
        path: this.dataPath, 
        pattern: 'backup-*.json' 
      }) as string[];
      
      if (backupFiles.length === 0) return null;

      // Sort by creation time (newest first)
      backupFiles.sort((a, b) => {
        const timeA = parseInt(a.match(/backup-(\d+)\.json$/)?.[1] || '0');
        const timeB = parseInt(b.match(/backup-(\d+)\.json$/)?.[1] || '0');
        return timeB - timeA;
      });

      const latestBackup = await join(this.dataPath, backupFiles[0]);
      const content = await readTextFile(latestBackup);
      return JSON.parse(content) as AppData;
    } catch (err) {
      console.error(`Failed to load from backup: ${err}`);
      return null;
    }
  }

  private async cleanupBackups(): Promise<void> {
    if (!this.dataPath) return;

    try {
      const backupFiles = await invoke('list_files', { 
        path: this.dataPath, 
        pattern: 'backup-*.json' 
      }) as string[];

      if (backupFiles.length <= 5) return;

      // Sort by creation time (oldest first for deletion)
      backupFiles.sort((a, b) => {
        const timeA = parseInt(a.match(/backup-(\d+)\.json$/)?.[1] || '0');
        const timeB = parseInt(b.match(/backup-(\d+)\.json$/)?.[1] || '0');
        return timeA - timeB;
      });

      // Delete oldest backups, keep only 5 most recent
      const toDelete = backupFiles.slice(0, backupFiles.length - 5);
      for (const file of toDelete) {
        await invoke('delete_file', { path: await join(this.dataPath, file) });
      }
    } catch (err) {
      console.error(`Failed to cleanup backups: ${err}`);
      // Don't throw - cleanup failure isn't critical
    }
  }

  private getDefaultSettings(): any {
    return {
      theme: 'dark',
      notifications: true,
      autoSave: true,
      autoSaveInterval: 30000, // 30 seconds
      focusBlockMin: 50,
      breakMin: 10,
      dailyMustWins: 3,
      greDailyVocab: 5,
      ai: {
        enabled: true,
        model: 'llama3.2',
        insightsFrequency: 'daily'
      },
      keyboard: {
        globalShortcuts: true,
        quickCapture: 'Ctrl+Shift+Q'
      }
    };
  }
}

// Export singleton instance
export const storageService = new StorageService();
export default storageService;
