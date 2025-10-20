# JnU Bus Routes 🚌

A Flutter mobile application designed to help Jagannath University (JnU) students navigate the local bus system. This app provides comprehensive information about bus routes, schedules, and destinations around the university area.

**Your Campus Travel Guide** - Find the right bus for your destination with ease!

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features & Implementation](#features--implementation)
- [Architecture & Code Structure](#architecture--code-structure)
- [Database System](#database-system)
- [State Management](#state-management)
- [UI Components](#ui-components)
- [Navigation System](#navigation-system)
- [Theme & Customization](#theme--customization)
- [Development Team](#development-team)
- [Technical Dependencies](#technical-dependencies)
- [Getting Started](#getting-started)

## 🎯 Project Overview

This application serves as a digital bus guide for JnU students, providing real-time access to bus route information, schedules, and destination details. The app is built with a focus on usability, performance, and offline functionality through a local SQLite database.

**Target Users**: JnU students and commuters  
**Platform**: Android/iOS (Flutter cross-platform)  
**Package Name**: com.sutsoa.jnu_bus_routes  
**Database**: SQLite with pre-populated bus route data

## 🚀 Features & Implementation

### 1. Welcome & Onboarding System
**File**: `lib/screens/welcome_screen.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

The welcome screen serves as the app's entry point with user agreement functionality:

```dart
Future<void> _onAgreePressed() async {
  await SharedPreferencesHelper.setAgreementStatus(true);
  if (mounted) {
    context.go('/');
  }
}
```

**Key Features**:
- User agreement tracking via SharedPreferences
- Background image integration (JnU campus)
- Custom "Agree" button with proper styling (30px bold font)
- Welcome message: "JnU Bus Routes - Your Campus Travel Guide"
- Smooth navigation to main app using GoRouter
- Customizable theme color integration

### 2. Home Tab - Smart Bus Discovery ("Where to?")
**File**: `lib/tabs/home.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

The core functionality that allows users to find buses based on their destination with an intuitive "Where to?" interface:

```dart
// Real-time place search with filtering
onChanged: (value) {
  final filteredList = placeListArr
      .where((place) => place
          .trim()
          .toLowerCase()
          .contains(value.trim().toLowerCase()))
      .toList();
  ref.read(filteredPlaceListProvider.notifier).state = filteredList;
}

// Dynamic bus suggestion based on selected destination
onPressed: () async {
  SharedPreferencesHelper.setDestOrSource(placeName);
  ref.read(destinationProvider.notifier).state = placeName;
  ref.read(busListForDestinationProvider.notifier).state =
      await DatabaseHelper().getBusInfo(placeName: placeName);
}
```

**Key Features**:
- Intuitive "Where to?" search interface
- Live search functionality for destinations
- Horizontal scrollable place selector
- Dynamic bus suggestions based on selected destination  
- Bus route visualization with up/down direction toggle
- Persistent user selections via SharedPreferences

### 3. Place Management System
**File**: `lib/tabs/place.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Advanced place browsing with alphabetical filtering:

```dart
// Alphabet-based filtering system
void _filterPlaceName(String filterLetter) async {
  final dbHelper = DatabaseHelper();
  final placeNames = await dbHelper.getFilteredPlaceList(filterLetter);
  setState(() {
    _filteredPlaceNames = placeNames;
  });
}

// Database query for filtered results
Future<List<String>> getFilteredPlaceList(String filterLetter) async {
  const query = '''
    SELECT DISTINCT place.place_name
    FROM relation
    JOIN place ON relation.place_id = place.id
    WHERE relation.up_or_down = 1
    AND LOWER(place.place_name) LIKE ?
    ORDER BY place.place_name ASC;
  ''';
  final List<Map<String, dynamic>> result =
      await db.rawQuery(query, ['$filterLetter%']);
  return result.map((row) => row['place_name'] as String).toList();
}
```

**Key Features**:
- A-Z alphabet filter buttons
- Efficient database querying with SQL LIKE operations
- Clear filter functionality
- Horizontal scrollable alphabet navigation bar

### 4. Bus Catalog & Information
**File**: `lib/tabs/bus.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Complete bus listing with detailed information display and alphabet-based filtering:

```dart
Future<void> _loadBusNames() async {
  try {
    final dbHelper = DatabaseHelper();
    final busNames = await dbHelper.getBusInfo();
    setState(() {
      _busNames = busNames;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
  }
}

// Alphabet-based filtering for buses
void _filterBusName(String filterLetter) async {
  final dbHelper = DatabaseHelper();
  final busNames = await dbHelper.getFilteredBusList(filterLetter);
  setState(() {
    _filteredBusNames = busNames;
  });
}
```

**Key Features**:
- Complete bus directory
- A-Z alphabet filter buttons (matching Places tab functionality)
- Clear filter functionality
- Horizontal scrollable alphabet navigation bar
- Bus timing information (up_time, down_time)
- Last stoppage details
- Bus selection and bookmarking functionality

### 5. Database Management System
**File**: `lib/database/database_helper.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Sophisticated SQLite database operations with relationship management:

```dart
// Singleton pattern for database instance
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  factory DatabaseHelper() {
    return _instance;
  }
  
  // Complex JOIN query for place details
  Future<List<Map<String, dynamic>>> getPlaceDetails({
    required String? placeName,
  }) async {
    const placeDetailsQuery = '''
      SELECT 
          bus.bus_name,
          bus_type, 
          last_stoppage, 
          up_time, 
          down_time
      FROM 
          relation
      JOIN 
          bus ON relation.bus_id = bus.id
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          place.place_name = ? AND relation.up_or_down = 1;
    ''';
    final List<Map<String, dynamic>> result =
        await db.rawQuery(placeDetailsQuery, [placeName]);
    return result;
  }
  
  // Filtered bus list query for alphabet filtering
  Future<List<Map<String, dynamic>>> getFilteredBusList(String filterLetter) async {
    const query = '''
      SELECT DISTINCT bus.bus_name, bus.bus_type, bus.last_stoppage, bus.up_time, bus.down_time
      FROM bus
      WHERE LOWER(bus.bus_name) LIKE ?
      ORDER BY bus.bus_name ASC;
    ''';
    final List<Map<String, dynamic>> result =
        await db.rawQuery(query, ['$filterLetter%']);
    return result;
  }
}
```

**Key Database Features**:
- Asset-based database initialization
- Complex relational queries with JOINs
- Alphabet-based filtering for both buses and places
- Multiple query methods for different use cases
- Error handling and exception management
- Efficient data retrieval with proper indexing

### 6. State Management with Riverpod
**Files**: `lib/providers/*.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Modern state management using Flutter Riverpod:

```dart
// Theme management
final isDarkTheme = StateProvider<bool>((ref) => true);
final backgroundColor = StateProvider<Color>((ref) => const Color(0xfff50057));

// Bus-related state
final busNameProvider = StateProvider<String?>((ref) => null);
final busListForDestinationProvider = 
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Place-related state  
final placeListProvider = StateProvider<List<String>>((ref) => []);
final filteredPlaceListProvider = StateProvider<List<String>>((ref) => []);
```

**State Management Features**:
- Reactive state updates across widgets
- Persistent state through app lifecycle
- Provider overrides for initialization
- Clean separation of concerns

### 7. Advanced Settings & Customization
**File**: `lib/tabs/setting.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Comprehensive theme and preference management:

```dart
// Dynamic color selection from extensive color palette
DropdownButton<Color>(
  value: _selectedColor,
  items: backgroundColorList.map((color) {
    return DropdownMenuItem<Color>(
      value: color,
      child: Container(
        width: 200,
        height: 40,
        color: color,
      ),
    );
  }).toList(),
  onChanged: (Color? newValue) {
    setState(() {
      _selectedColor = newValue!;
      ref.read(backgroundColor.notifier).state = newValue;
      SharedPreferencesHelper.setBgColor(newValue);
    });
  },
)

// Theme toggle with persistence
onPressed: () {
  ref.read(isDarkTheme.notifier).state = !isDarkModeStatus;
  SharedPreferencesHelper.setThemeStatus(!isDarkModeStatus);
}
```

**Customization Features**:
- 200+ color options for theme customization
- Dark/Light mode toggle
- Color reset functionality
- Persistent preference storage

### 8. Navigation & Routing System
**File**: `lib/routes/app_router.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Type-safe navigation using GoRouter:

```dart
class AppRouter {
  late final GoRouter router;
  
  AppRouter({required String initialLocation}) {
    router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/bus/:busName/:upOrDown',
          builder: (context, state) {
            final String busName = state.pathParameters['busName']!;
            final int upOrDown = int.tryParse(state.pathParameters['upOrDown']!) ?? 1;
            return BusDetailsScreen(busName: busName, upOrDown: upOrDown);
          },
        ),
        // Additional routes...
      ],
    );
  }
}
```

**Navigation Features**:
- Parameterized route handling
- Type-safe parameter extraction
- Conditional initial route based on user agreement status
- Clean URL-like navigation structure

### 9. Shared Preferences System
**File**: `lib/utils/shared_preferences_helper.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Persistent storage management for user preferences:

```dart
class SharedPreferencesHelper {
  static const String _keyHasAgreed = 'hasAgreed';
  static const String _busName = 'busName';
  static const String _isDarkMode = 'isDarkMode';
  static const String _bgColor = 'bgColor';
  
  static Future<Color> getBgColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Color(prefs.getInt(_bgColor) ?? const Color(0xfff50057).value);
  }
  
  static Future<void> setBgColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgColor, color.value);
  }
}
```

### 10. Custom UI Components
**Files**: `lib/widgets/*.dart`  
**Implemented by**: Md. Ramjan Miah (AhmedTrooper)

Reusable, themed UI components:

```dart
// Bus List Component with interactive features
class BusList extends ConsumerStatefulWidget {
  // Animation controller for smooth transitions
  late AnimationController _controller;
  
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }
  
  // Bus selection with state updates and toast notifications
  onPressed: () async => {
    SharedPreferencesHelper.setBusName(busName['bus_name']),
    ref.read(busNameProvider.notifier).state = busName['bus_name'],
    ref.read(routeListProvider.notifier).state = 
        await DatabaseHelper().getBusInfo(busName: busName['bus_name'], busType: 1),
    ShadToaster.of(context).show(ShadToast(
      title: const Text('Selected'),
      description: Text('${busName['bus_name']} has been selected as your bus'),
    ))
  }
}
```

## 🏗️ Architecture & Code Structure

The project follows a clean, modular architecture:

```
lib/
├── main.dart                 # App entry point with provider setup
├── constants/                # Static data and configurations
├── database/                 # SQLite database management
├── models/                   # Data models and structures
├── providers/                # Riverpod state management
├── routes/                   # Navigation and routing
├── screens/                  # Full-screen pages
├── tabs/                     # Tab-based UI components
├── utils/                    # Utility classes and helpers
└── widgets/                  # Reusable UI components
```

**Design Patterns Used**:
- Singleton (DatabaseHelper)
- Provider Pattern (Riverpod)
- Repository Pattern (Database operations)
- Factory Pattern (Model constructors)

## 🗄️ Database System

The app uses a pre-populated SQLite database (`assets/database/jnu.db`) with the following structure:

**Tables**:
- `bus` - Bus information (name, timings, routes)
- `place` - Destination/stoppage information
- `relation` - Many-to-many relationship between buses and places

**Key Relationships**:
- Each bus can visit multiple places
- Each place can be served by multiple buses
- Direction tracking (up/down) for route management

## 📱 UI Components

**Custom Widgets Created**:
- `BusList` - Animated bus cards with selection functionality
- `PlaceList` - Scrollable place selection interface  
- `RouteList` - Route visualization component
- `RouteTile` - Individual route stop representation
- `HomeScreenTabBar` - Custom bottom navigation

**Design Philosophy**:
- Material Design 3 principles
- ShadCN UI component library integration
- Dark mode by default with theme persistence
- Responsive layouts with CustomScrollView
- Smooth animations and transitions
- Consistent icon colors across light/dark themes

## 🎨 Theme & Customization

**Theme System Features**:
- Dynamic color theming (200+ colors available)
- Dark mode by default with toggle support
- Light/Dark mode with persistent preferences
- Consistent icon colors (black54 for light, white70 for dark)
- Google Fonts integration (Poppins)
- Custom color palette defined in `constants/color_list.dart`
- Unpinned headers for smooth scrolling experience

## 👥 Development Team

### **Md. Ramjan Miah** (Lead Developer)
- **GitHub**: [@AhmedTrooper](https://github.com/AhmedTrooper)
- **Role**: Primary Flutter developer and architect
- **Contributions**: Complete app development, UI/UX design, state management implementation, database design, and system architecture

### **Mehrab Hosen Mahi** (Data Contributor)
- **Facebook**: [Mehrab Hosen Mahi](https://www.facebook.com/mehrabhosen.mahi)
- **Role**: Bus data collector and researcher
- **Contributions**: Comprehensive bus route data collection, schedule verification, and local area research

### **MT Asfi** (Project Collaborator)
- **Facebook**: [MT Asfi](https://www.facebook.com/asfi.sultan)
- **Role**: App collaborator and version manager
- **Contributions**: Project coordination, app console management, and version control assistance

## 🔧 Technical Dependencies

### Flutter & Dart
- **Flutter SDK**: 3.35.6
- **Dart SDK**: 3.9.2

### Core Dependencies
- `flutter_riverpod: ^2.6.1` - State management
- `go_router: ^16.2.5` - Navigation and routing
- `sqflite: ^2.3.3+2` - SQLite database operations
- `shared_preferences: ^2.3.3` - Local data persistence

### UI & Design
- `shadcn_ui: ^0.38.1` - Modern UI components
- `google_fonts: ^6.2.1` - Typography (Poppins font)
- `lucide_icons: ^0.469.0` - Icon library

### Utilities
- `path_provider: ^2.1.5` - File system access
- `url_launcher: ^6.3.1` - External link handling

### Development Tools
- `flutter_lints: ^5.0.0` - Code quality and standards

### Android Configuration
- **Compile SDK**: 36
- **Target SDK**: 36
- **Min SDK**: 23
- **NDK Version**: 27.0.12077973
- **Gradle**: 8.11.1
- **Kotlin**: 2.1.0
- **Android Gradle Plugin**: 8.7.3
- **Java**: 17

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.35.6 or compatible)
- Dart SDK (3.9.2 or compatible)
- Android Studio or VS Code with Flutter extensions
- For Android builds: Java 17, Android SDK 36, NDK 27.0.12077973

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AhmedTrooper/JnU-Bus-Routes.git
   cd JnU-Bus-Routes
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Clean and rebuild** (recommended):
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

5. **Build release APK**:
   ```bash
   flutter build apk --release
   ```
   The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Database Setup
The SQLite database (`jnu.db`) is included in the assets and will be automatically copied to the device on first launch.

### Development Mode
To skip the welcome screen during development, uncomment the development section in `main.dart`:

```dart
// For development time...
child: const MyApp(initialLocation: "/"),
```

## 🤝 Contributing

This project was developed as a collaborative effort to help JnU students. While the core development is complete, contributions for improvements, bug fixes, or additional features are welcome.

**Areas for Contribution**:
- Additional bus route data
- UI/UX improvements
- Performance optimizations  
- Feature enhancements
- Testing and quality assurance

## 📄 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

---

**Note**: This README reflects the actual implementation and development process of the JnU Bus Routes application. All code snippets and technical details are based on the current codebase and represent the genuine development approach taken by the team.
