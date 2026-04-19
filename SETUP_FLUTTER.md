# 🚀 FLUTTER SETUP - WINDOWS (FASTEST PATH)

## Option 1: Winget (Recommended - 5 minutes)

```powershell
# Install Flutter via Windows Package Manager
winget install --id=Google.Flutter -e

# Restart terminal or add to PATH manually
$env:Path += ";C:\Users\$env:USERNAME\AppData\Local\flutter\bin"

# Verify
flutter doctor
```

## Option 2: Manual Install (10 minutes)

### Step 1: Download
Go to: https://docs.flutter.dev/get-started/install/windows
Download: **Flutter SDK** (latest stable)

### Step 2: Extract
- Extract ZIP to `C:\src\flutter` (or anywhere, avoid spaces/special chars)

### Step 3: Add to PATH
```powershell
# Temporary (current session)
$env:Path += ";C:\src\flutter\bin"

# Permanent (use System Properties → Environment Variables)
# Add: C:\src\flutter\bin to User PATH
```

### Step 4: Verify
```powershell
flutter doctor
```

## Step 5: Accept Android Licenses (Required)
```powershell
flutter doctor --android-licenses
# Press 'y' to accept all
```

## Step 6: Enable Windows Desktop
```powershell
flutter config --enable-windows-desktop
```

## Step 7: Final Check
```powershell
flutter doctor -v
```

**Expected Output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.16.x)
[✓] Windows Version (Installed version of Windows is 10+)
[✓] Visual Studio (version 2022)
[✓] VS Code (version 1.x.x)
[✓] Connected device (2 available)
[✓] Network resources
```

---

## Required Dependencies

### 1. Visual Studio 2022 (C++ Build Tools)
**CRITICAL for Windows desktop builds**

Download: https://visualstudio.microsoft.com/downloads/

**Install these workloads:**
- ✅ Desktop development with C++
- ✅ C++ CMake tools for Windows

**Minimum install:** ~5 GB
**Full install:** ~10 GB

### 2. Git (if not already installed)
```powershell
winget install --id Git.Git -e
```

---

## Troubleshooting

### "cmdlet not recognized"
- Flutter not in PATH. Restart terminal after install.
- Or manually add to PATH (see Step 3 above)

### "Android licenses not accepted"
```powershell
flutter doctor --android-licenses
```

### "Visual Studio not found"
- Install Visual Studio 2022 Community (free)
- Must include C++ desktop development workload

### "Network error"
- Check firewall/proxy
- Or download Flutter SDK manually (Option 2)

---

## Post-Install Commands (Run These)

```powershell
# 1. Set Flutter to stable channel
flutter channel stable
flutter upgrade

# 2. Enable Windows desktop
flutter config --enable-windows-desktop

# 3. Enable Web
flutter config --enable-web

# 4. Verify everything
flutter doctor -v

# 5. Create test project to verify
flutter create test_app --platforms=windows
cd test_app
flutter run -d windows
# Should open a window with Flutter demo
```

---

## Once Flutter is Ready

Return to this project folder and run:
```powershell
cd C:\Users\Waleed\Desktop\pathway
# Then say "Flutter is ready, let's build"
```

I'll create the entire project structure in one shot.

---

**Estimated Install Time:** 15-30 minutes (depending on download speed)
**Disk Space Needed:** ~2 GB (Flutter) + ~10 GB (Visual Studio)

---

**GO INSTALL, THEN WE CHARGE! 🔥**

