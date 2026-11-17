# Implementation Plan - Profile Setup and Dashboard Screens

I will implement the "Set Up Profile" and "Home/Dashboard" screens based on the provided screenshots.

## User Review Required

> [!IMPORTANT]
> The "Home Screen" will replace the current `PlaceholderScreen` as the main landing page after onboarding.
> I will use the `fl_chart` library (already in your `pubspec.yaml`) for the Weekly Progress chart.

## Proposed Changes

### Screens

#### [NEW] [profile_setup_screen.dart](file:///C:/Users/Varun%20teja/Downloads/aeccde_app/aeccde_app/lib/screens/profile_setup_screen.dart)
- **Avatar**: Glassmorphic profile picture section with camera overlay.
- **Form**:
    - Custom styled `TextField` for Full Name.
    - Custom styled `DropdownButtonFormField` for Age Range, Education, and Language.
    - Custom `ToggleButtons` or `Row` of styled containers for "Communication Level".
- **Navigation**: Transitions to the new `HomeScreen`.

#### [NEW] [home_screen.dart](file:///C:/Users/Varun%20teja/Downloads/aeccde_app/aeccde_app/lib/screens/home_screen.dart)
- **Custom Header**: Greeting text and action icons (Notifications, Profile).
- **Main Score Card**:
    - Circular indicator showing overall score.
    - Improvement badge (+7 pts).
    - Animated waveform visualizer.
- **Action Grid**: Two prominent cards for Evaluation and Practice.
- **Score Breakdown**: Staggered horizontal list of category metric tiles.
- **Analytics**: Weekly progress line chart using `fl_chart`.

### Navigation Flow

#### [MODIFY] [set_goals_screen.dart](file:///C:/Users/Varun%20teja/Downloads/aeccde_app/aeccde_app/lib/screens/set_goals_screen.dart)
- Update "Continue" button to navigate to `ProfileSetupScreen`.

## Verification Plan

### Manual Verification
- Verify the "Communication Level" selector works correctly.
- Ensure the `fl_chart` renders correctly on different screen sizes.
- Test the full onboarding flow: Splash -> Onboarding -> Welcome -> Language -> Goals -> Profile Setup -> Home.
