## About Ch'ti Face Book

This project is an academic mobile social network application developed using Flutter and Firebase. The app allows users to connect, share posts, comment on posts, and interact with each other in a social environment. It is designed to demonstrate the capabilities of Flutter for cross-platform mobile development and Firebase for backend services.

## 🛠️  Tech stack

---

<div id="tools">

  <img src="https://raw.githubusercontent.com/devicons/devicon/ca28c779441053191ff11710fe24a9e6c23690d6/icons/firebase/firebase-original.svg" title="Firebase" alt="Firebase" width="40" height="40"/>
  <img src="https://raw.githubusercontent.com/devicons/devicon/ca28c779441053191ff11710fe24a9e6c23690d6/icons/flutter/flutter-original.svg" title="Flutter" alt="Flutter" width="40" height="40"/>
</div>

---

## Project Structure
```
ch'ti face book/
│
├── android/                                # Android-specific files
│   ├── app/
│   ├── gradle/
│   ├── build.gradle
│   ├── settings.gradle
│   └── ...
│
├── ios/                                    # iOS-specific files
│   ├── Runner/
│   ├── Podfile
│   ├── Podfile.lock
│   └── ...
│
├── lib/                                    # Main Dart code
│   ├── main.dart                           # Main entry point of the application
│   ├── models/                             # Data models
│   │   ├── post.dart
│   │   ├── commentaire.dart
│   │   └── membre.dart
│   │   └── notification.dart
│   ├── services_firebase/                  # Service classes
│   │   ├── service_authentification.dart
│   │   ├── service_firestore.dart
│   │   └── service_storage.dart
│   ├── widgets/                            # Reusable widgets
│   │   ├── avatat.dart
│   │   ├── post_widget.dart
│   │   └── ...
│   ├── pages/                              # Screen widgets
│   │   ├── home_screen.dart
│   │   ├── profile_screen.dart
│   │   └── comment_screen.dart
│   └── utils/                              # Utility classes and functions
│       ├── constants.dart
│       └── formatage_date.dart
├── assets/                                 # Static files like images, fonts, etc.
│   ├── images/
│   ├── fonts/
│   └── ...
│
├── pubspec.yaml                            # Project dependencies and assets
├── pubspec.lock                            # Lock file for dependencies
├── README.md                               # Project documentation
```

## Authors
- [@ENDIGNOUS_Arnaud](https://github.com/Piryth)
