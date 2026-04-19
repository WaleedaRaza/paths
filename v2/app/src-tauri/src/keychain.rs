//! OS keychain storage for API keys (Secret Service on Linux, Keychain on macOS, Credential Manager on Windows).

use keyring::{Entry, Error as KeyringError};

const SERVICE: &str = "dev.paths.hub";

fn entry(provider: &str) -> Result<Entry, String> {
    let user = format!("api-key.{provider}");
    Entry::new(SERVICE, &user).map_err(|e| e.to_string())
}

#[tauri::command]
pub fn keyring_set(provider: String, secret: String) -> Result<(), String> {
    entry(&provider)?
        .set_password(&secret)
        .map_err(|e| e.to_string())
}

#[tauri::command]
pub fn keyring_get(provider: String) -> Result<Option<String>, String> {
    match entry(&provider)?.get_password() {
        Ok(s) => Ok(Some(s)),
        Err(KeyringError::NoEntry) => Ok(None),
        Err(e) => Err(e.to_string()),
    }
}

#[tauri::command]
pub fn keyring_delete(provider: String) -> Result<(), String> {
    match entry(&provider)?.delete_credential() {
        Ok(()) => Ok(()),
        Err(KeyringError::NoEntry) => Ok(()),
        Err(e) => Err(e.to_string()),
    }
}
