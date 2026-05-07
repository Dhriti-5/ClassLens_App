# ClassLens

ClassLens is a comprehensive Flutter application designed to streamline classroom management for teachers. It provides tools for tracking attendance, managing class sessions, and viewing student and subject details.

## 📱 Features

- **Teacher Dashboard**: View profile, assigned subjects, and departments.
- **Attendance Management**: Easily mark and track student attendance (Present/Absent).
- **Class Sessions**: Manage class session data effectively.
- **Notifications**: Stay updated with local notifications.
- **Offline Support**: Uses Hive for local data persistence.
- **Interactive UI**: Smooth animations with Lottie and a modern design using Google Fonts.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/) & [Provider](https://pub.dev/packages/provider)
- **Local Storage**: [Hive](https://docs.hivedb.dev/) & [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Networking**: [http](https://pub.dev/packages/http)
- **UI/UX**: [Lottie](https://pub.dev/packages/lottie), [Google Fonts](https://pub.dev/packages/google_fonts), [Dotted Border](https://pub.dev/packages/dotted_border)
- **Utilities**: [Intl](https://pub.dev/packages/intl) (Date formatting), [Permission Handler](https://pub.dev/packages/permission_handler)

## 🚀 Getting Started

> **📚 New to Flutter or need detailed setup instructions?**  
> Check out our comprehensive [**Setup Guide for Beginners**](SETUP.md) with step-by-step instructions!

### Quick Start (For Experienced Developers)

#### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.8.0 or higher) installed on your machine.
- An IDE (VS Code or Android Studio) with Flutter plugins.
- Backend API server running (see [SETUP.md](SETUP.md) for details).

#### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/Dhriti-5/ClassLens_App.git
    cd ClassLens_App
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Generate required code:**

    ```bash
    dart run build_runner build
    ```

4.  **Configure environment:**
    
    Update `.env.dev` or `.env.prod` with your backend API URL.

5.  **Run the application:**

    ```bash
    flutter run
    ```

### Code Generation

This project uses `build_runner` for generating Hive adapters. If you make changes to Hive models, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📂 Project Structure

```
lib/
├── api/            # API services and networking logic
├── data_models/    # Data models (Student, Teacher, Class, etc.)
├── global/         # Global widgets and constants
├── home/           # Home screen and dashboard logic
├── login/          # Authentication screens and logic
├── page_animations/# Custom page transition animations
└── main.dart       # Application entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
