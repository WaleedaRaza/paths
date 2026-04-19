fn main() {
    tauri_build::try_build(
        tauri_build::Attributes::new().app_manifest(
            tauri_build::AppManifest::new().commands(&[
                "keyring_set",
                "keyring_get",
                "keyring_delete",
            ]),
        ),
    )
    .expect("failed to run tauri-build");
}
