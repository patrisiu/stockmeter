# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-01-29

### Changed

- Restored GoogleSignIn for user login.

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
