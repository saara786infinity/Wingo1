# Overview

This is a modern Flutter-based cross-platform mobile application designed for building responsive mobile experiences on both Android and iOS platforms. The project follows Flutter's recommended architectural patterns with a clean separation of concerns, utilizing a structured approach to UI components, routing, theming, and core utilities. The application integrates with multiple AI services and uses Supabase as the backend service.

# Recent Changes

## August 29, 2025: Replit Environment Setup
- Successfully installed Flutter SDK 3.32.0 with Dart 3.8.0 in Replit environment
- Configured Flutter for web development (mobile emulation not available in Replit)
- Fixed compilation errors in theme configuration and syntax issues in pattern analysis files
- Set up development workflow running on port 5000 with proper host configuration (0.0.0.0)
- Application now runs successfully in web browser with all dependencies installed
- Configured deployment for autoscale target with proper build and run commands

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Frontend Architecture
- **Framework**: Flutter SDK (^3.29.2) for cross-platform mobile development
- **Architecture Pattern**: Clean architecture with separation of presentation, core utilities, and routing layers
- **Project Structure**: Organized into distinct directories for core services, presentation layers, routing, theming, and reusable widgets
- **UI Components**: Modular widget system with reusable components stored in dedicated widgets directory

## Presentation Layer
- **Screen Organization**: Individual screens organized under `presentation/` directory with dedicated folders for each screen (e.g., splash_screen)
- **Theme Management**: Centralized theming system in dedicated `theme/` directory for consistent UI styling
- **Navigation**: Route-based navigation system with centralized route management in `routes/` directory

## Core Services
- **Utilities**: Core utility classes and helper functions organized in `core/utils/` for shared functionality
- **Asset Management**: Static assets (images, fonts, etc.) managed through the `assets/` directory
- **Configuration**: Project dependencies and configuration managed through `pubspec.yaml`

## Platform-Specific Implementation
- **Android Configuration**: Android-specific settings and configurations in `android/` directory
- **iOS Configuration**: iOS-specific settings, app icons, and launch screens in `ios/` directory with proper asset catalog structure

# External Dependencies

## Backend Services
- **Supabase**: Primary backend service for data storage and authentication (configurable URL and anonymous key)

## AI Service Integrations
- **OpenAI API**: Integration for AI-powered features
- **Google Gemini API**: Alternative AI service integration
- **Anthropic API**: Additional AI service for enhanced functionality
- **Perplexity API**: AI-powered search and information retrieval

## Development Tools
- **Flutter SDK 3.32.0**: Successfully installed and configured for web development in Replit
- **Dart SDK 3.8.0**: Programming language runtime
- **Web Support**: Enabled Flutter web support for browser-based development
- **Replit Integration**: Configured for Replit cloud development environment

## Configuration Management
- **Environment Variables**: Centralized configuration through `env.json` for API keys and service URLs
- **Asset Management**: iOS app icons and launch images managed through Xcode asset catalogs