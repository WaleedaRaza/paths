# ⚡ QUICK START - GET RUNNING IN 15 MINUTES

## 🎯 Goal: See the app window open with dark theme + navigation

---

## Step 1: Install Flutter (5-10 min)

### Option A: Winget (Fastest)
```powershell
winget install --id=Google.Flutter -e
```

### Option B: Manual
1. Download: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`

---

## Step 2: Verify (1 min)
```powershell
flutter doctor
```

**Look for:**
- ✅ Flutter
- ✅ Windows Version
- ✅ Visual Studio (if missing, install VS 2022 Community)

---

## Step 3: Run App (2 min)
```powershell
cd C:\Users\Waleed\Desktop\pathway\lifeline_os
flutter pub get
flutter run -d windows
```

---

## ✅ Success!

You should see:
- Dark window (1400x900)
- Sidebar with orange accents
- "Today" page with formatted date
- Can click between pages

---

## 📞 What to Say Next

**If it works:**
```
"Phase 0 complete, start Phase 1"
```

**If error:**
```
"Getting error: [paste error message]"
```

---

## 🚨 Common Issues

### "Visual Studio not found"
```powershell
# Install VS 2022 Community (free)
# Include "Desktop development with C++" workload
```

### "No devices"
```powershell
flutter config --enable-windows-desktop
```

### "Package errors"
```powershell
flutter clean
flutter pub get
```

---

**THAT'S IT! 🔥**

