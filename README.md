Pocket Tasks

A clean, modular Flutter app for task management using Riverpod for state management and Hive for local data persistence.

Features

1. Task list screen showing all tasks
2. Add, edit, delete, and mark tasks complete/incomplete
3. Filter tasks: All, Active, Completed
4. Sort tasks by due date or creation date
5. Responsive UI with light and dark theme support
6. Basic animations for task updates

How to Run the App
1. Flutter SDK >=3.0.0
2. Dart SDK >=3.0.0
3. Android SDK with NDK version 27.0.12077973

Setup and Run
1. Clone the repository:
   git clone https://github.com/Richdadbtc/pockettasks.git
   
2. Navigate to the project directory:
   cd pocket-tasks
  
3. Install dependencies:
   flutter pub get
   
4. Run the app:
   flutter run

State Management Approach
I used Riverpod (flutter_riverpod 2.4.9) for state management with the following components:

1. Providers: Defined in task_providers.dart to manage the app's state
2. Notifiers: TaskNotifier extends AsyncNotifier to handle asynchronous state operations
3. Repository Pattern: State management is connected to data sources through repositories
4. Code Generation: Uses riverpod_annotation for generating boilerplate code
Key benefits of this approach:
- Separation of concerns
- Testability through provider overrides
- Type safety with code generation
- Efficient rebuilds
- Code readability and maintainability


Persistence
The app uses Hive for local data persistence:
- Type adapters for serialization/deserialization
- Boxes for storing collections of objects
- Path provider for determining storage location

Architecture
This project follows clean architecture principles with the following layers:
Data: Handles data operations and external services
  - Repositories: Implement data access logic
  - Data Sources: Provide data from local storage (Hive)

Domain: Contains business logic and entities
  - Models: Define the data structures
  - Repositories (interfaces): Define contracts for data operations

Presentation: Handles UI and user interactions
  - Providers: Manage state using Riverpod
  - Screens: Display UI to the user
  - Widgets: Reusable UI components

Built APK:
  app\outputs\flutter-apk\app-release.apk (20.8MB)

  WhatsApp Video 2025-06-29 at 09.09.43_e0936823.mp4
