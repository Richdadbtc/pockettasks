# Pocket Tasks

A clean, modular Flutter app for task management using Riverpod for state management and Hive for local data persistence.

## Features

- Task list screen showing all tasks
- Add, edit, delete, and mark tasks complete/incomplete
- Filter tasks: All, Active, Completed
- Sort tasks by due date or creation date
- Responsive UI with light and dark theme support
- Basic animations for task updates

## Architecture

This project follows clean architecture principles with the following layers:

- **Data Layer**: Handles data operations and external services
  - Repositories: Implement data access logic
  - Data Sources: Provide data from local storage (Hive)

- **Domain Layer**: Contains business logic and entities
  - Models: Define the data structures
  - Repositories (interfaces): Define contracts for data operations

- **Presentation Layer**: Handles UI and user interactions
  - Providers: Manage state using Riverpod
  - Screens: Display UI to the user
  - Widgets: Reusable UI components

## Project Structure
