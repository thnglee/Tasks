# Flutter Todo App with Supabase

A modern, feature-rich Todo application built with Flutter and Supabase. This app demonstrates best practices in Flutter development, including offline-first architecture, cloud synchronization, and a clean, maintainable codebase.

## 📱 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/bdfba7d1-0d5d-4529-affe-9ff9def0eb4e" alt="iPhone Screenshot" width="300"/><br/>
      <sub>📱 iPhone</sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/1d8d6638-8849-46c0-9ecd-3af5910b2dc4" alt="iPad Screenshot" width="500"/><br/>
      <sub>💻 iPad</sub>
    </td>
  </tr>
</table>


---

## Features

- ✨ Clean and intuitive user interface
- 🌓 Dark/Light theme support
- 💾 Offline-first with local storage using Hive
- ☁️ Cloud synchronization with Supabase backend
- 🔄 Automatic background syncing
- 📱 Cross-platform support (iOS, Android, Web)
- 📝 CRUD operations for todo items
- 🔍 Real-time updates
- 📊 Task completion tracking

## Tech Stack

- **Frontend Framework**: Flutter (SDK ^3.7.2)
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Backend Service**: Supabase
- **Additional Packages**:
  - `flutter_riverpod`: State management
  - `google_fonts`: Custom typography
  - `floating_bottom_navigation_bar`: Navigation UI
  - `connectivity_plus`: Network status monitoring
  - `logging`: Debug logging
  - `flutter_dotenv`: Environment configuration

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- A Supabase account and project
- Your preferred IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   Create a `.env` file in the project root with your Supabase credentials:
   ```
   SUPABASE_URL=your-supabase-url
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```
   **Important**: Do not commit your `.env` file to version control.

4. Run the app:
   ```bash
   flutter run
   ```

### Supabase Setup

1. Create a new Supabase project
2. Set up the following table:
   ```sql
   create table todos (
     id uuid primary key,
     title text not null,
     is_done boolean default false,
     created_at timestamp with time zone default timezone('utc'::text, now()) not null,
     updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
     deleted boolean default false
   );
   ```

## Project Structure

```
lib/
├── main.dart           # App entry point
├── models/            
│   └── todo_model.dart # Data models
├── pages/              # Screen UI
├── providers/          # State management
├── services/           # Business logic
│   ├── app_service.dart
│   ├── hive_service.dart
│   ├── supabase_service.dart
│   └── sync_service.dart
├── theme/             # App theming
└── widgets/           # Reusable components
```

## Features in Detail

### Offline-First Architecture
- The app stores all data locally using Hive
- Changes are synchronized with Supabase when online
- Automatic conflict resolution

### State Management
- Uses Riverpod for predictable state management
- Separate providers for different features
- Clean separation of concerns

### Synchronization
- Automatic background syncing
- Network status monitoring
- Conflict resolution strategy
- First launch detection and initial sync

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the excellent framework
- Supabase team for the backend service
- All package authors that made this project possible
