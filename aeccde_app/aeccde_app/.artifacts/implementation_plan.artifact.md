# Implementation Plan: Fix GitHub Actions Workflows, 5 Test Categories & Excel Reports

Comprehensive analysis and remediation plan to make all GitHub Actions workflows (`all-tests-and-reports.yml`, `security-review.yml`) pass successfully, ensure all 5 test categories execute without errors, and generate styled Excel reports.

## User Review Required

> [!IMPORTANT]
> This plan addresses root causes of CI failures across:
> 1. **Test 1 (Selenium Web E2E):** Headless Chrome WebDriver setup, server readiness check, and robust locators.
> 2. **Test 2 (Appium Mobile E2E):** Appium server initialization (`appium server --port 4723 &`), WebDriverIO configuration, and mobile test execution.
> 3. **Test 3 (Security SAST/DAST):** Ensuring SAST tools (Semgrep), DAST API security probes, and report generation scripts run smoothly.
> 4. **Test 4 (Baseline Load Test k6):** k6 installation, robust test script execution, and performance report generation.
> 5. **Test 5 (Flutter / Backend API Unit & Integration Tests):** Ensuring backend Express server health and Flutter test suites execute successfully.
> 6. **CI Workflows & DevSecOps Gate:** Fixing workflow step ordering, dependency caching, timeout handling, and quality gate logic.

## Open Questions

None. All technical blockers identified in workflows and test suites are accounted for.

## Proposed Changes

### GitHub Actions Workflows (`.github/workflows/`)

#### [MODIFY] [all-tests-and-reports.yml](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/.github/workflows/all-tests-and-reports.yml)
- Fix Test 2 Appium execution step by installing Appium and Appium drivers (`appium driver install uiautomator2`), starting the Appium server in background, and executing mobile E2E tests instead of dry-run `node -c`.
- Ensure robust database seeding and server health checks (`curl http://localhost:3000/api/active-user`) prior to running Selenium, Appium, DAST, and k6 tests.
- Verify path resolutions for generating and copying all 4 Excel test reports into `All-Test-Excel-Reports/`.

#### [MODIFY] [security-review.yml](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/.github/workflows/security-review.yml)
- Ensure Python security scanner scripts and Node.js backend dependencies are correctly installed and executed.
- Refine the DevSecOps Quality Gate evaluation logic to correctly parse vulnerability executive summaries and report findings.

### Test Suites & Automation Scripts (`AECCDE web application/`, `tools/`)

#### [MODIFY] [appium-tests.js](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/AECCDE%20web%20application/appium-tests/appium-tests.js)
- Update Appium test initialization to connect to local Appium server port 4723 with appropriate capabilities for headless/automated CI execution and generate `AECCDE_Appium_Mobile_E2E_Test_Report.xlsx`.

#### [MODIFY] [generate_appium_excel_report.py](file:///C:/Users/Varun%20teja/OneDrive/Desktop/Communication%20Project%20-%20PDD/AECCDE%20web%20application/generate_appium_excel_report.py)
- Ensure robust Excel workbook creation (using `exceljs` or `openpyxl`) for mobile E2E tests with status pass/fail tracking.

## Verification Plan

### Automated Tests
- Run local validation checks for all test scripts and report generators using `python` and `node`.
- Verify YAML linting on GitHub Actions workflow files.
- Ensure Excel generation scripts produce valid `.xlsx` workbooks.

### Manual Verification
- Verify GitHub Actions workflow runs show green success status (`✅ PASSED`) across all jobs.
