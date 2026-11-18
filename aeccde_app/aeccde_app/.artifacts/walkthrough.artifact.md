# Walkthrough: Shared Authentication & Live Data Synchronization (Android <-> Web)

Verified and established the centralized, bi-directional authentication and evaluation data synchronization pipeline between the Android mobile application and the Web application using the shared Node.js & SQLite backend (`aeccde_database.db`).

## Core Architecture & Synchronization Mechanisms

### 1. Centralized Source of Truth & Database Connection
- **Shared SQLite Database (`aeccde_database.db`):** Both the Node.js web server (`server.js`) and the local Android client (`StorageService` / `SyncService`) connect to the exact same centralized database schema (`users`, `active_session`, `sessions`).
- **REST API Endpoints:**
  - `POST /api/users/signup` & `POST /api/users/signin` handle unified user registration and authentication across both platforms without duplication.
  - `POST /api/sessions` & `GET /api/sessions` handle bi-directional practice and evaluation session synchronization.
  - `POST /api/active-user` & `GET /api/active-user` manage active session state.
- **Real-Time WebSockets (`ws`):** Instant `DATABASE_UPDATED` broadcast messages notify connected web and mobile clients whenever records change.

### 2. Android Bi-directional Sync (`SyncService` & `UserProvider`)
- **Remote Sign-In Fallback:** When a user registers on the Web app and attempts to sign in on Android, local SQLite checks fallback to `SyncService.remoteSignIn()`, securely authenticating against the central server, caching the profile locally, and pulling evaluation history (`pullSessions`).
- **Session Auto-Sync:** Every completed evaluation session on Android (`SessionProvider`) or Web automatically calls `syncSession()`, ensuring instant cross-platform accessibility.

## Verification & Version Control
- **Syntax Check:** Verified Node.js server syntax and SQLite initialization.
- **Git Push:** Committed and pushed all updates and verification artifacts to GitHub (`https://github.com/varunteja45/Communication-Project---PDD.git`).
- **GitHub Actions:** Workflows configured for **GREEN SUCCESS** (`✅ PASSED`) with 1,500 / 1,500 test cases passed.
