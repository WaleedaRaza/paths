import { load, type Store } from '@tauri-apps/plugin-store'

const FILE = 'paths.store'
const LS_PREFIX = 'paths:'

export const isTauri =
  typeof window !== 'undefined' && '__TAURI_INTERNALS__' in window

let storePromise: Promise<Store> | null = null
function tauriStore(): Promise<Store> {
  if (!storePromise) storePromise = load(FILE, { autoSave: true, defaults: {} })
  return storePromise
}

export async function getConfig<T>(key: string): Promise<T | undefined> {
  if (isTauri) {
    const s = await tauriStore()
    return (await s.get<T>(key)) ?? undefined
  }
  const raw = localStorage.getItem(LS_PREFIX + key)
  return raw == null ? undefined : (JSON.parse(raw) as T)
}

export async function setConfig<T>(key: string, value: T): Promise<void> {
  if (isTauri) {
    const s = await tauriStore()
    await s.set(key, value)
    return
  }
  localStorage.setItem(LS_PREFIX + key, JSON.stringify(value))
}

export async function pickVaultFolder(): Promise<string | null> {
  if (!isTauri) {
    alert('Folder picker requires the desktop app. Paste a path manually in browser dev.')
    return null
  }
  const { open } = await import('@tauri-apps/plugin-dialog')
  const chosen = await open({ directory: true, multiple: false })
  return typeof chosen === 'string' ? chosen : null
}
