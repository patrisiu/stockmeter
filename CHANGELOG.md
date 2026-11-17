# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.6.1] - 2026-11-17

### Added

- Updated version disclaimer to easier user experience.

## [2.5.0] - 2026-11-15

### Added

- Trends sorting functionality.
- Analytics on alerts behavior to monitor failures.

### Fixed

- Race condition when loading services before load Portfolio.

## [2.4.1] - 2026-11-15

### Added

- Async backup alerts configuration.
- Cache on Securities to smoother user experience on startup.

### Changed

- Visual colors for better user experience.
- Restored Summary view displayed in a modal.
- Restored Stocks portfolio.

### Fixed

- Prioritize load Alert from Datasource to handle cross devices.

## [2.3.1] - 2026-11-13

### Added

- Detailed learning explanation for each alert.
- Display formula result per alert.
- Sorting by name.

## [2.3.0] - 2026-11-12

### Added

- Navigation between screens sliding right or left using PageView.
- Dynamic screen title and visual indicator dots in AppBar.

### Changed

- Replaced BottomNavigationBar with horizontal swipe gesture navigation.

## [2.2.0] - 2026-11-12

### Added

- Google Finance disclaimer on securities screen.

### Changed

- Restored partially Stocks portfolio.

### Fixed

- Sort Securities by price or alerts triggered.

## [2.1.1] - 2026-11-09

### Added

- Sort Securities by price or alerts triggered.

### Fixed

- Security notes input.

## [2.1.0] - 2026-11-08

### Added

- Possibility to record personal notes associated to a Security.
- Functionality to remove a Security on watch.

## [2.0.3] - 2026-11-08

### Changed

- Added alerts backup in all CrUD operations.

### Fixed

- Preventing scaffold from overlapping OS buttons.

## [2.0.2] - 2026-11-07

### Changed

- Updated background notifications.
- Updated compileSdkVersion from 35 to 37 in build.gradle.
- Updated AI model to Gemini 3.8 Flash.
- Upgraded Firebase dependencies.

### Fixed

- Enabled extend Body Behind AppBar.
- Reload alerts from selected portfolio.

## [2.0.1] - 2026-11-07

### Added

- New range of configurable alerts.

### Changed

- Alerts triggered according to Security values.
- New spreadsheet structure.
- Stock feature disabled.
- Refactor to be Security oriented.

### Removed

- Unneeded foreground service permission.

## [1.2.1] - 2026-10-31

### Added

- ProGuard rule to preserve WorkDatabase_Impl and prevent WorkManager startup crash.

### Changed

- Updated compileSdkVersion from 33 to 35 in build.gradle.
- Applied Kotlin plugin & set JVM target for workmanager_android in build.gradle.kts.
- Gradle update from 8.14.3 to 9.8.1.
- Migration to package:material_ui.

## [1.2.0] - 2026-03-17

### Added

- Autocomplete with Yahoo Finance search to find stock symbols.

### Changed

- Refactor Edit Stock screen for better usability.

### Fixed

- Wrong internal status when updating Stock.

## [1.1.0] - 2026-02-25

### Added

- AI model Gemini 2.5 Flash Lite for Stocks and Trends analysis.

## [1.0.5] - 2026-02-05

### Added

- Configure Price Alerts week days to be executed.

### Changed

- Restored GoogleSignIn for user login.

### Fixed

- Price Alerts background task with last execution report.

### Deleted

- Removed CredentialManager for user login.

## [1.0.0] - 2026-01-20

### Added

- Analytics metrics to measure loading times.
- Spreadsheet restore system between versions upgrade.
- Centralized app Theme.
- Cached values on start up before load for smoother user experience.
- Grey colors when disconnection to differentiated outdated info. 
- Sign In screen with Google SignIn compliant button.
- Create first Portfolio screen with disclaimer.
- Init screen for smoother experience when opening the app.
- Coloured icons when fetching Stocks or loading Trends.
- Load trends when loaded app in a different thread.
- Semaphore implementation on AuthService to avoid concurrent requests. 
- Notification permission check when enabling Price Alerts.
- Report from last background execution.
- Internal exception for Price Alerts background execution.
- AuthServiceWeb implementation in parallel to AuthServiceAndroid.
- AuthorizationClient API to request scope authorization.
- FirebaseController class to centralize app initialization.
- CHANGELOG.

### Changed

- Display stock name when available.
- Restored background Price Alerts execution.
- Refactor load sequence.
- Refactor SnackBar service.
- Refactor to extract datasource functionality to Datasource service (Single Responsibility).
- Refactor to extract trends functionality to Trends service (Single Responsibility).
- Refactor to extract stocks functionality to Stocks service (Single Responsibility).
- Refactor to extract files functionality to Portfolio service (Single Responsibility).
- Refactor on Price Alert widgets.
- Refactor to extract alerts functionality to Price Alerts service (Single Responsibility).
- Refactor app initialization on ForegroundController and App classes.
- Refactor LocalStorage applying Dependency Inversion Principle.
- Refactor AuthService applying Dependency Inversion Principle.
- Migrated Trend Charts from charts_flutter to fl_chart library.
- Refactor authHeaders usage to minimize repetitive calls.
- Refactor GoogleAuthService to AuthService applying Domain Driven Design.
- Migrated GoogleSignIn to CredentialManager and refactorized GoogleAuthService.
- Updated flutter libraries to revamp the project.
- Updated Gradle from 6.7 to 8.14.3 version.

## [0.0.1] - Project beginnings

### Changed

- Previous untracked changes on the PoC version for local testing with APK.
