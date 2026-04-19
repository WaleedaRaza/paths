import { AppShell } from './components/AppShell';
import PracticalTodayPage from './pages/PracticalTodayPage';
import TasksPage from './pages/TasksPage';
import GoalsPage from './pages/GoalsPage';
import CalendarPage from './pages/CalendarPage';
import ReflectionsPage from './pages/ReflectionsPage';
import SavedPostsPage from './pages/SavedPostsPage';
import SettingsPage from './pages/SettingsPage';
import { useAppStore } from './store';
import { useEffect, useState } from 'react';
import { dataInitializer } from './services/dataInitializer';
import { desktopService } from './services/desktop';

function App() {
  const { ui } = useAppStore();
  const [isDataLoaded, setIsDataLoaded] = useState(false);
  const [loadingError, setLoadingError] = useState<string | null>(null);

  // Initialize data persistence and desktop integration on app start
  useEffect(() => {
    const initializeApp = async () => {
      try {
        console.log('🚀 Initializing Lifeline OS...');
        
        // Initialize data persistence first
        await dataInitializer.initializeAppData();
        console.log('✅ Data persistence initialized');
        
        // Then initialize desktop integration
        await desktopService.initialize();
        console.log('✅ Desktop integration initialized');
        
        setIsDataLoaded(true);
      } catch (error) {
        console.error('❌ Failed to initialize app:', error);
        setLoadingError(error instanceof Error ? error.message : 'Unknown error');
        setIsDataLoaded(true); // Allow app to continue with fallback state
      }
    };

    initializeApp();
  }, []);

  // Show loading screen while initializing
  if (!isDataLoaded) {
    return (
      <div className="min-h-screen bg-zinc-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin w-8 h-8 border-2 border-blue-500 border-t-transparent rounded-full mx-auto mb-4"></div>
          <div className="text-white text-lg font-medium">Loading Lifeline OS...</div>
          <div className="text-zinc-400 text-sm mt-2">Initializing data persistence</div>
        </div>
      </div>
    );
  }

  // Show error if initialization failed
  if (loadingError) {
    return (
      <div className="min-h-screen bg-zinc-900 flex items-center justify-center">
        <div className="text-center max-w-md">
          <div className="text-red-400 text-lg font-medium mb-2">Initialization Error</div>
          <div className="text-zinc-400 text-sm mb-4">{loadingError}</div>
          <button 
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  const renderPage = () => {
    switch (ui.currentPage) {
      case 'today':
        return <PracticalTodayPage />;
      case 'tasks':
        return <TasksPage />;
      case 'goals':
        return <GoalsPage />;
      case 'calendar':
        return <CalendarPage />;
      case 'reflections':
        return <ReflectionsPage />;
      case 'saved':
        return <SavedPostsPage />;
      case 'settings':
        return <SettingsPage />;
      default:
        return <PracticalTodayPage />;
    }
  };

  return (
    <AppShell>
      {renderPage()}
    </AppShell>
  );
}

export default App