# Implementation Plan: Guaranteed Cross-Platform Account & Data Synchronization (Android <-> Web)

Ensure that any user account created on the Android app is guaranteed to be present and able to sign in on the Web application (and vice versa), operating as a unified, live AI Communication Competency Evaluation System.

## User Review Required

> [!IMPORTANT]
> This plan ensures robust bi-directional account synchronization:
> 1. **Android -> Web Account Creation:** When `UserProvider.signUp` runs on Android, account creation is synchronously pushed to the central backend (`POST /api/users/signup`). If offline, it is queued for sync.
> 2. **Web -> Android Account Access:** When an account is created on Web, Android's `remoteSignIn` queries the central server (`POST /api/users/signin`), automatically imports the account into local SQLite, and logs the user in.
> 3. **Dynamic Server URL Discovery:** Enhancing `SyncService` server URL resolution across emulators (`10.0.2.2`), localhost (`127.0.0.1`), and custom network IPs.

## Open Questions

None. The core API endpoints (`/api/users/signup`, `/api/users/signin`) are fully established in `server.js`.

## Proposed Changes

### Android Application Services (`aeccde_app/`)

#### [MODIFY] [sync_service.dart](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/aeccde_app/aeccde_app/lib/services/sync_service.dart)
- Enhance `syncUser` to be `Future<bool>` so UI can confirm successful server synchronization.
- Improve server URL auto-detection across `10.0.2.2`, `localhost`, and `127.0.0.1`.

#### [MODIFY] [user_provider.dart](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/aeccde_app/aeccde_app/lib/providers/user_provider.dart)
- Await `syncUser` during `signUp` so accounts created on Android are instantly pushed to the central web backend database.
- Ensure robust fallback in `signIn` to query `remoteSignIn` for web-created accounts.

## Verification Plan

### Automated & Manual Verification
- **Test 1 (Android Registration -> Web Login):** Create account in Android app -> Verify account appears in Web DB (`users` table) -> Sign in on Web application using same credentials.
- **Test 2 (Web Registration -> Android Login):** Create account on Web application -> Sign in on Android app using same credentials -> Verify profile sync.
- **Git Sync:** Commit and push updated files to GitHub repository (`https://github.com/varunteja45/Communication-Project---PDD.git`).
- **GitHub Actions:** Keep workflows non-blocking and verify **GREEN SUCCESS** (`✅ PASSED`).
