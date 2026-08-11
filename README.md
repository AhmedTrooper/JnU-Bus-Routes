# 🚌 JnU Bus Routes

> **Real-time bus tracking and route explorer for Jagannath University, Dhaka.**

A production-grade Flutter application that lets students, teachers, and staff of Jagannath University explore all campus bus routes, view live stoppage tracking on an interactive map, and manage their daily commute — all offline-first with zero backend dependency.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🗺️ **Live Map Tracking** | Interactive OpenStreetMap-based route visualization with real-time user location tracking against bus stoppages |
| 🔄 **Morning / Afternoon Toggle** | Global direction switch — see "To Campus" routes in the morning and "Return Home" routes in the afternoon |
| ⭐ **Favorites & Daily Commute** | Pin your primary bus for 1-tap live tracking from the home screen |
| 🔍 **Instant Search** | Full-text search across bus names, stoppages, and terminals with recent search history |
| 🤖 **Smart Recommendations** | AI-powered bus suggestions based on your favorites, search patterns, and time of day |
| 🌙 **Dark / Light Theme** | Premium Shadcn-inspired design system with system-aware theming and manual toggle |
| 📱 **Responsive UI** | Adapts from small phones to tablets with grid layouts, verified across 100px–1200px+ screen widths |
| 🔋 **Battery Optimized** | Location polling with 15m distance filter and 5-second intervals to minimize battery drain |
| 📦 **Offline-First** | All route data bundled in a local SQLite database — works without internet |

---

## 🏗️ Architecture

The app follows **Clean Architecture** principles with a feature-first directory structure:

```
lib/
├── core/                          # Shared infrastructure
│   ├── config/                    # Environment configuration
│   ├── constants/                 # Colors, themes, DB constants
│   ├── database/                  # SQLite (AppDatabase) + Hive (preferences)
│   ├── router/                    # GoRouter navigation
│   ├── services/                  # Location service
│   ├── utils/                     # URL parser, location helper, recommendations
│   └── widgets/                   # Reusable Shadcn-style components
├── features/
│   ├── bus_routes/                # Bus listing, detail, filtering
│   │   ├── data/                  # Models, repositories
│   │   ├── domain/                # Enums, route stoppage models
│   │   └── presentation/         # Screens, widgets, Riverpod providers
│   ├── tracking_map/             # Live GPS tracking on map
│   ├── search/                   # Full-text search with history
│   └── settings/                 # App preferences
└── main.dart                      # Entry point
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.24+ (Dart 3.12+) |
| **State Management** | Riverpod 2.x |
| **Navigation** | GoRouter |
| **Database** | SQLite (sqflite) — bundled `jnu.db` asset |
| **Local Storage** | Hive — favorites, theme, recent searches |
| **Maps** | flutter_map + OpenStreetMap tiles |
| **Location** | Geolocator |
| **Animations** | flutter_animate |
| **Design System** | Custom Shadcn-inspired components |
| **CI/CD** | GitHub Actions — automated release builds |

---

## 📸 Screens

| Home (Bus List) | Live Map Tracking | Bus Detail |
|:---:|:---:|:---:|
| Draggable bottom sheet with sticky filters, morning/afternoon toggle, and smart recommendations | Real-time GPS position against route polyline with passed/upcoming stoppage indicators | Full route breakdown with all stoppages and schedule times |

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/AhmedTrooper/JnU-Bus-Routes.git
cd JnU-Bus-Routes

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

> For detailed build instructions (APK signing, CI/CD setup, etc.), see **[DEVELOPER.md](DEVELOPER.md)**.

---

## 📄 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

**Copyright © 2025 Md. Ramjan Miah**
