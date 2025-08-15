# Flutter Blog App Using BLoC with Clean Architecture

This is a Flutter blog application built using the BLoC pattern and Clean Architecture. The app includes features such as login, signup, displaying blogs, and adding new blogs. It uses Supabase for backend services. FpDart functional programming and GetIt is used for dependency injection.

## Features

- User Authentication (Login & Signup)
- Display Blogs
- Add New Blog (with abuse detection)
- Offline Storage with Hive
- save draft
- Like and comment on blogs
- view and edit profile
- 

## UI of App
### Sign In


### Sign Up


### Display BLogs


### Add Blogs


### Preview Blog Details

### Edit Profile

### Discover Users


## Architecture Overview

The app follows the Clean Architecture principles and is divided into three main layers:

1. **Presentation Layer**: Contains the UI and the state management logic.
2. **Domain Layer**: Contains the business logic and entities.
3. **Data Layer**: Contains the data sources, repositories, and models.

### Call Flow Diagram

![Clean Architecture Call Flow](https://github.com/aliasar1/Blog-App-BLoC-Flutter/blob/main/app_images/clean_architecture.png)

## Folder Structure

```
lib
├── core
│   ├── constants
│   └── widgets
├── features
│   ├── auth
│   │   ├── data
│   │   │   ├── models
│   │   │   ├── repositories
│   │   │   └── datasources
│   │   ├── domain
│   │   │   └── repository
│   │   │   ├── entities
│   │   │   └── usecases
│   │   └── presentation
│   │       ├── blocs
│   │       └── screens
│   │       ├── widgets
│   ├── blog
│   │   ├── data
│   │   │   ├── models
│   │   │   ├── repositories
│   │   │   └── datasources
│   │   ├── domain
│   │   │   └── repository
│   │   │   ├── entities
│   │   │   └── usecases
│   │   └── presentation
│   │       ├── blocs
│   │       └── screens
│   │       ├── widgets
└── init_dependencies.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK
- Supabase account



## Dependencies

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [equatable](https://pub.dev/packages/equatable)
- [hive](https://pub.dev/packages/hive)
- [hive_flutter](https://pub.dev/packages/hive_flutter)
- [supabase](https://pub.dev/packages/supabase)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
