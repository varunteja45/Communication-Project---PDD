# Implementation Plan: Shared Authentication & Live Data Synchronization (Android <-> Web)

Ensure seamless, bi-directional, real-time shared authentication and evaluation data synchronization between the Android mobile application (`aeccde_app`) and the Web application (`AECCDE web application`) using the centralized Node.js & SQLite backend.

## User Review Required

> [!IMPORTANT]
> This plan formalizes and guarantees the shared authentication and synchronization pipeline:
> 1. **Centralized Authentication:** Android and Web both authenticate against the central Node.js server (`/api/users/signup`, `/api/users/signin`, `/api/active-user`).
> 2. **Cross-Platform Sign-Up & Sign-In:** Accounts registered on Web are instantly accessible on Android via remote sign-in and local caching; accounts registered on Android are synced to the server instantly.
> 3. **AI Evaluation Data Synchronization:** Completed assessment sessions, scores, transcripts, strengths, improvements, and question evaluations are pushed to the central SQLite database (`/api/sessions`) and pulled bi-directionally.
> 4. **Live Scenario Ready:** WebSocket broadcasting (`DATABASE_UPDATED`) and HTTP sync endpoints operate seamlessly for live cross-platform workflows.

## Open Questions

None. The core backend and synchronization services are aligned and fully compatible.

## Proposed Changes

### Backend & Database (`AECCDE web application/`)

#### [VERIFY] [server.js](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/AECCDE%20web%20application/server.js)
- Ensure robust SQLite schema creation (`users`, `active_session`, `sessions`).
- Verify REST API endpoints (`/api/users/signup`, `/api/users/signin`, `/api/sessions`, `/api/active-user`, `/api/analytics`) handle user ID mapping, score calculations, and JSON serialization correctly.
- Verify WebSocket broadcasting (`DATABASE_UPDATED`) notifies connected clients instantly.

### Android Application Services (`aeccde_app/`)

#### [VERIFY] [sync_service.dart](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/aeccde_app/aeccde_app/lib/services/sync_service.dart)
- Verify `syncUser`, `remoteSignIn`, `syncSession`, and `pullSessions` handle endpoint communication with the central Node.js server (`http://localhost:3000` / `10.0.2.2:3000`).

#### [VERIFY] [user_provider.dart](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/aeccde_app/aeccde_app/lib/providers/user_provider.dart)
- Verify local SQLite + remote server sign-in fallback (`remoteSignIn`) successfully downloads remote user accounts and pulls evaluation history.

## Verification Plan

### Automated & Manual Verification
- **Scenario 1 (Android -> Web):** Register on Android -> Verify login on Web -> Complete evaluation on Android -> Verify results on Web.
- **Scenario 2 (Web -> Android):** Register on Web -> Verify login on Android -> Complete evaluation on Web -> Verify results on Android.
- **Git Sync:** Commit and push all updated files to GitHub repository (`https://github.com/varunteja45/Communication-Project---PDD.git`).
- **GitHub Actions:** Ensure workflows run and show **GREEN SUCCESS** (`✅ PASSED`).
