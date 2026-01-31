# 📚 ClassLens App - Complete Setup Guide for Beginners

Welcome! This guide will help you set up the ClassLens App on your PC step by step. Don't worry if you're a beginner - we'll walk through everything you need.

## 📋 Table of Contents
1. [System Requirements](#system-requirements)
2. [Installing Prerequisites](#installing-prerequisites)
3. [Setting Up the Project](#setting-up-the-project)
4. [Backend API Setup](#backend-api-setup)
5. [Firebase Configuration](#firebase-configuration)
6. [Running the Application](#running-the-application)
7. [Common Issues and Troubleshooting](#common-issues-and-troubleshooting)

---

## 🖥️ System Requirements

Before you start, make sure your PC meets these requirements:

- **Operating System**: Windows 10/11, macOS, or Linux (Ubuntu 20.04 or later)
- **RAM**: At least 8GB (16GB recommended)
- **Storage**: 10GB free space
- **Internet Connection**: Required for downloading dependencies

---

## 🔧 Installing Prerequisites

### Step 1: Install Flutter SDK

Flutter is the framework used to build this app. Here's how to install it:

#### For Windows:

1. **Download Flutter:**
   - Go to [Flutter's official website](https://docs.flutter.dev/get-started/install/windows)
   - Download the latest stable Flutter SDK
   - Extract the zip file to a location like `C:\src\flutter` (avoid paths with spaces)

2. **Add Flutter to PATH:**
   - Search for "Environment Variables" in Windows Start menu
   - Click "Edit the system environment variables"
   - Click "Environment Variables" button
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add `C:\src\flutter\bin` (or wherever you extracted Flutter)
   - Click "OK" on all windows

3. **Verify Installation:**
   ```bash
   flutter --version
   flutter doctor
   ```

#### For macOS:

1. **Download Flutter:**
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_stable.zip
   unzip flutter_macos_arm64_stable.zip
   ```

2. **Add Flutter to PATH:**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify Installation:**
   ```bash
   flutter --version
   flutter doctor
   ```

#### For Linux:

1. **Download Flutter:**
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_stable.tar.xz
   tar xf flutter_linux_stable.tar.xz
   ```

2. **Add Flutter to PATH:**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Verify Installation:**
   ```bash
   flutter --version
   flutter doctor
   ```

### Step 2: Install an IDE

You need a code editor. Choose one:

#### Option A: Visual Studio Code (Recommended for Beginners)

1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Install VS Code
3. Open VS Code and go to Extensions (Ctrl+Shift+X)
4. Search and install these extensions:
   - **Flutter** (by Dart Code)
   - **Dart** (by Dart Code)

#### Option B: Android Studio

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Install Android Studio
3. Open Android Studio
4. Go to File → Settings → Plugins
5. Search and install:
   - **Flutter plugin**
   - **Dart plugin**

### Step 3: Set Up Android Development (For Android Devices/Emulator)

1. **Install Android Studio** (if not already installed)
2. **Accept Android Licenses:**
   ```bash
   flutter doctor --android-licenses
   ```
   Press 'y' to accept all licenses

3. **Create an Android Emulator:**
   - Open Android Studio
   - Go to Tools → Device Manager
   - Click "Create Device"
   - Select a device (e.g., Pixel 6)
   - Download a system image (e.g., Android 13)
   - Click "Finish"

### Step 4: Set Up for Other Platforms (Optional)

#### For iOS Development (macOS only):
```bash
# Install Xcode from Mac App Store
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

#### For Windows Desktop:
- Already supported with Flutter 3.8+
- No additional setup needed

#### For Linux Desktop:
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

---

## 📦 Setting Up the Project

### Step 1: Clone the Repository

1. **Install Git** (if not already installed):
   - Windows: Download from [git-scm.com](https://git-scm.com/)
   - macOS: `brew install git`
   - Linux: `sudo apt-get install git`

2. **Clone the ClassLens repository:**
   ```bash
   git clone https://github.com/Dhriti-5/ClassLens_App.git
   cd ClassLens_App
   ```

### Step 2: Install Project Dependencies

1. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```
   
   This will download all the necessary packages defined in `pubspec.yaml`.

2. **Generate Hive adapters:**
   ```bash
   dart run build_runner build
   ```
   
   This generates code for Hive database adapters. If you get conflicts, use:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Step 3: Configure Environment Variables

The app uses environment files to connect to the backend API.

1. **For Development (Local Backend):**
   
   The `.env.dev` file is already configured for local development:
   ```
   BASE_URL=http://127.0.0.1:8000/api
   ```
   
   If using Android Emulator, you might need:
   ```
   BASE_URL=http://10.0.2.2:8000/api
   ```

2. **For Production:**
   
   Edit `.env.prod` file with your production backend URL:
   ```
   BASE_URL=http://your-server-ip:8000/api
   ```

---

## 🔌 Backend API Setup

ClassLens App requires a backend API to function. The backend is typically built with Django or similar framework.

### Setting Up the Backend Locally:

1. **Prerequisites:**
   - Python 3.8+ installed
   - pip (Python package manager)

2. **Get the Backend Code:**
   
   Contact the repository owner or check if there's a separate backend repository.

3. **Install Backend Dependencies:**
   ```bash
   # Navigate to backend directory
   cd path/to/backend
   
   # Install dependencies
   pip install -r requirements.txt
   ```

4. **Run Database Migrations:**
   ```bash
   python manage.py migrate
   ```

5. **Create a Superuser (Admin):**
   ```bash
   python manage.py createsuperuser
   ```

6. **Start the Backend Server:**
   ```bash
   python manage.py runserver
   ```
   
   The backend will run at `http://127.0.0.1:8000`

---

## 🔥 Firebase Configuration

ClassLens uses Firebase for push notifications. Here's how to set it up:

### Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Make sure the pub-cache bin directory is in your PATH:
- Windows: `C:\Users\YourUsername\AppData\Local\Pub\Cache\bin`
- macOS/Linux: `$HOME/.pub-cache/bin`

### Step 2: Configure Firebase for Your Project

If you're using the existing Firebase project (claens-f7490):

1. The app is already configured with Firebase
2. The `firebase_options.dart` file is already generated
3. You just need to ensure Firebase is working

### Step 3: (Optional) Set Up Your Own Firebase Project

If you want to use your own Firebase project:

1. **Create Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project"
   - Enter project name and follow the steps

2. **Configure FlutterFire:**
   ```bash
   flutterfire configure
   ```
   
   This will:
   - Show you a list of your Firebase projects
   - Let you select which platforms to configure
   - Automatically generate configuration files

3. **Enable Firebase Cloud Messaging:**
   - In Firebase Console, go to Project Settings
   - Go to Cloud Messaging tab
   - Note down the Server Key (for backend)

---

## 🚀 Running the Application

### Step 1: Check Everything is Set Up

Run Flutter doctor to check your setup:
```bash
flutter doctor -v
```

Fix any issues shown (denoted by ❌). Green checkmarks (✓) mean everything is good!

### Step 2: Choose Your Platform

#### Option 1: Run on Android Emulator

1. **Start the Android Emulator:**
   - Open Android Studio → Device Manager → Start emulator
   OR
   ```bash
   flutter emulators --launch <emulator_id>
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

#### Option 2: Run on Physical Android Device

1. **Enable Developer Options on your phone:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect your phone via USB**

3. **Verify device is connected:**
   ```bash
   flutter devices
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

#### Option 3: Run on Chrome (Web)

```bash
flutter run -d chrome
```

#### Option 4: Run on Windows Desktop

```bash
flutter run -d windows
```

#### Option 5: Run on macOS Desktop

```bash
flutter run -d macos
```

### Step 3: Hot Reload While Developing

While the app is running:
- Press `r` to hot reload (update UI instantly)
- Press `R` to hot restart (restart app completely)
- Press `q` to quit

---

## 🔧 Common Issues and Troubleshooting

### Issue 1: "flutter: command not found"

**Solution:**
- Make sure Flutter is added to your PATH (see Step 1 above)
- Restart your terminal/command prompt
- Verify with: `flutter --version`

### Issue 2: "Unable to locate Android SDK"

**Solution:**
```bash
flutter config --android-sdk /path/to/android/sdk
```

For Windows: Usually `C:\Users\YourName\AppData\Local\Android\Sdk`

### Issue 3: "Gradle build failed"

**Solution:**
1. Update Gradle:
   - Open `android/gradle/wrapper/gradle-wrapper.properties`
   - Update to latest version
2. Clean and rebuild:
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   flutter run
   ```

### Issue 4: "Connection refused" or "Network error"

**Solution:**
- Make sure the backend server is running
- Check if the BASE_URL in `.env.dev` is correct
- For Android emulator, use `http://10.0.2.2:8000/api` instead of `http://127.0.0.1:8000/api`
- Check your firewall settings

### Issue 5: "MissingPluginException"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

If that doesn't work, try:
```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Issue 6: Build runner conflicts

**Solution:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue 7: "Unsupported class file major version"

**Solution:**
- Update Java to version 17 or later
- Set JAVA_HOME environment variable to point to Java 17+

### Issue 8: iOS build fails (macOS only)

**Solution:**
```bash
cd ios
pod install
cd ..
flutter run
```

---

## 🎯 Quick Start Commands

Once everything is set up, these are the main commands you'll use:

```bash
# Get project dependencies
flutter pub get

# Generate code (Hive adapters)
dart run build_runner build

# Run the app
flutter run

# Run on specific device
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d <device-id>     # Specific device

# Check available devices
flutter devices

# Clean build files (if you have issues)
flutter clean

# Analyze code for issues
flutter analyze

# Format code
flutter format .
```

---

## 📖 Additional Resources

- **Flutter Documentation**: [docs.flutter.dev](https://docs.flutter.dev/)
- **Dart Language Tour**: [dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour)
- **Flutter YouTube Channel**: [youtube.com/flutterdev](https://youtube.com/flutterdev)
- **Flutter Community**: [flutter.dev/community](https://flutter.dev/community)

---

## 🆘 Need More Help?

If you're still stuck:

1. Check the main [README.md](README.md) file
2. Run `flutter doctor` and fix any issues it reports
3. Search for your error message on [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)
4. Check Flutter's [GitHub Issues](https://github.com/flutter/flutter/issues)
5. Open an issue in this repository

---

## 🎉 You're All Set!

Congratulations! You've successfully set up ClassLens App on your PC. Start exploring the code and happy developing!

**Pro Tips for Beginners:**
- Use hot reload (`r` key) frequently while developing - it's Flutter's superpower!
- Read error messages carefully - they usually tell you exactly what's wrong
- Use `flutter doctor` regularly to check your setup
- Join Flutter communities to learn from others
- Don't be afraid to experiment - you can always clone the repo again!

---

*Last Updated: January 2026*
