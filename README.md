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

## Screenshots

![sign-up](https://github.com/user-attachments/assets/cb84794c-76a4-4791-89c6-9ba1df503894)
![blog-list](https://github.com/user-attachments/assets/7b9be13f-e884-40f3-9932-f84fb29f9bdb)
![temporary block](https://github.com/user-attachments/assets/57559ea8-4288-4847-86e7-8105121a6194)
![view blog](https://github.com/user-attachments/assets/8fb91b19-ec1c-461f-bf83-27e9272d274e)
![missing-field](https://github.com/user-attachments/assets/3f9054d3-e3de-40a8-818f-dc0d324ef222)
![editProfile](https://github.com/user-attachments/assets/126922ec-2431-4163-a103-a725c879dcdb)




