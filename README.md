# 🛡️ PhishPop

[![Flutter Version](https://img.shields.io/badge/Flutter-3.9.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red)]()

**PhishPop** is a comprehensive mobile security application built with Flutter that helps users detect and analyze phishing threats, malicious URLs, suspicious messages, and unsafe QR codes. With a family-focused approach, it provides tools to protect vulnerable users from digital scams and fraud.

---

## ✨ Features

### 🔍 Multi-Type Threat Analysis
- **Text Analysis** - Scan suspicious messages and emails for phishing indicators
- **URL Analysis** - Check links for malware, phishing, and security threats
- **QR Code Scanner** - Analyze QR codes for hidden malicious URLs
- **WiFi Network Analysis** - Evaluate WiFi network security from QR codes

### 📊 Advanced Analytics
- Comprehensive scan history with detailed reports
- Real-time threat statistics and visualizations
- Risk level classification (Safe, Warning, Threat)
- Confidence scoring for each analysis
- Interactive charts powered by FL Chart

### 👨‍👩‍👧‍👦 Safe Parent Mode
- **Family Mode** - Manage up to 3 trusted contacts
- **Emergency "Call Me" Button** - Quick SMS to trusted contacts
- **Scam Library** - Educational database of common scams with:
  - Red flags to watch for
  - Safe response templates
  - Official contact numbers
  - Reporting guidelines
- **Decision Helper** - Guided assistance for suspicious situations
- **Quick Report** - Fast incident reporting

### 🔐 Secure Authentication
- Email/Password authentication
- Google Sign-In integration
- Apple Sign-In support
- GitHub OAuth authentication
- Password reset functionality
- Account deletion with complete data cleanup

### 💎 Premium Features
- Subscription management via RevenueCat
- Monthly and annual plans
- Launch special packages
- Cross-platform purchase restoration

---

## 🏗️ Architecture

PhishPop follows a clean, modular architecture using the **Provider** pattern for state management:

```
lib/
├── main.dart                 # Application entry point
├── helpers/                  # Utility helpers (11 files)
│   ├── validators.dart       # Input validation
│   ├── firebase_helpers.dart # Firebase utilities
│   ├── wifi.dart            # WiFi analysis helpers
│   └── ...
├── models/                   # Data models (8 models)
│   ├── url_response_model.dart
│   ├── text_response_model.dart
│   ├── scan_history_model.dart
│   └── ...
├── providers/                # State management (8 providers)
│   ├── app_auth_provider.dart
│   ├── history_provider.dart
│   ├── stats_provider.dart
│   └── ...
├── screens/                  # UI screens (21+ screens)
│   ├── main/                # Main app screens
│   ├── safe_parent/         # Family protection screens
│   ├── settings/            # Configuration screens
│   └── summary/             # Analysis result screens
├── services/                 # Business logic (15 services)
│   ├── url_analysis_service.dart
│   ├── text_analysis_service.dart
│   ├── firebase_auth_service.dart
│   ├── scan_database_service.dart
│   └── ...
├── theme/                    # Design system
│   ├── app_theme.dart
│   ├── app_colors.dart
│   └── app_components.dart
├── utils/                    # Utilities
└── widgets/                  # Reusable widgets (142 widgets)
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `^3.9.0`
- Dart SDK: `^3.0`
- Firebase project configured
- Backend API running (see Backend section)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd phishpop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**

   Create a `.env` file in the root directory:
   ```env
   API_BASE_URL=https://your-backend-url.com
   ENVIRONMENT=production
   ```

4. **Configure Firebase**

   - Download `google-services.json` (Android)
   - Download `GoogleService-Info.plist` (iOS)
   - Place them in respective platform directories

5. **Configure RevenueCat** (Optional - for monetization)

   Update API keys in `lib/services/revenue_cat_service.dart`:
   ```dart
   static const String _androidApiKey = 'your_android_key';
   static const String _iosApiKey = 'your_ios_key';
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔧 Configuration

### Backend API

PhishPop requires a backend API for threat analysis. **Current backend**: Deployed on Vercel (Express.js)

**Base URL**: `https://phish-pop-express-backend.vercel.app`

---

#### **1. URL Analysis**

Analyzes URLs for phishing, malware, and security threats.

**Endpoint**: `GET /api/v1/url-analysis`

**Query Parameters**:
- `url` (string, required) - The URL to analyze

**Example Request**:
```bash
GET /api/v1/url-analysis?url=https://example.com
```

**Success Response** (200 OK):
```json
{
  "id": "abc123",
  "url": "https://example.com",
  "scan_type": "url",
  "result": "Safe content detected",
  "risk_level": "Safe",
  "classification": "Safe Content",
  "confidence_score": 95.5,
  "url_analysis_score": 92.0,
  "flagged_issues": ["No issues found"],
  "timestamp": "2024-01-01T12:00:00Z",
  "processing_time": 1500,
  "cached": false,
  "expire_time": "2024-01-01T13:00:00Z"
}
```

**Response Fields**:
- `id` (string) - Unique scan identifier
- `url` (string) - Analyzed URL
- `scan_type` (string) - Always "url"
- `result` (string) - Human-readable analysis result
- `risk_level` (string) - "Safe" | "Warning" | "Threat"
- `classification` (string) - Threat category
- `confidence_score` (number) - AI confidence (0-100)
- `url_analysis_score` (number) - URL-specific score (0-100)
- `flagged_issues` (array) - List of detected problems
- `timestamp` (string) - ISO 8601 timestamp
- `processing_time` (number) - Analysis duration in milliseconds
- `cached` (boolean) - Whether result was cached
- `expire_time` (string|null) - Cache expiration time

**Classification Types**:
- `Safe Content` - Legitimate, safe website
- `Phishing` - Credential harvesting attempt
- `Malware Link` - Contains malicious software
- `Suspicious Content` - Potentially dangerous
- `Spam` - Unsolicited content
- `Official Communication` - Verified legitimate source

---

#### **2. Text Analysis**

Analyzes text messages and emails for phishing indicators.

**Endpoint**: `POST /api/v1/text-analysis`

**Request Body**:
```json
{
  "text": "Your message content here"
}
```

**Example Request**:
```bash
POST /api/v1/text-analysis
Content-Type: application/json

{
  "text": "Congratulations! You've won $1,000,000. Click here to claim your prize."
}
```

**Success Response** (200 OK):
```json
{
  "id": "xyz789",
  "scan_type": "text",
  "text": "Congratulations! You've won $1,000,000...",
  "result": "Phishing attempt detected",
  "risk_level": "Threat",
  "classification": "Phishing",
  "confidence_score": 15.5,
  "text_analysis_score": 12.0,
  "normalized_score": 0.12,
  "flagged_issues": [
    "Urgency tactics detected",
    "Suspicious prize claim",
    "Generic greeting",
    "Request for personal information"
  ],
  "timestamp": "2024-01-01T12:00:00Z",
  "processing_time": 800,
  "cached": false
}
```

**Response Fields**:
- `id` (string) - Unique scan identifier
- `scan_type` (string) - Always "text"
- `text` (string) - Analyzed text content
- `result` (string) - Human-readable analysis result
- `risk_level` (string) - "Safe" | "Warning" | "Threat"
- `classification` (string) - Threat category
- `confidence_score` (number) - AI confidence (0-100)
- `text_analysis_score` (number) - Text-specific score (0-100)
- `normalized_score` (number|null) - Normalized score (0-1)
- `flagged_issues` (array) - List of detected problems
- `timestamp` (string) - ISO 8601 timestamp
- `processing_time` (number) - Analysis duration in milliseconds
- `cached` (boolean) - Whether result was cached

---

#### **Error Responses**

**400 Bad Request**:
```json
{
  "error": "Missing required parameter: url"
}
```

**500 Internal Server Error**:
```json
{
  "error": "Analysis service temporarily unavailable"
}
```

---

#### **Rate Limiting**

- No official rate limits currently enforced
- Backend deployed on Vercel free tier
- Best practice: Implement client-side throttling

---

#### **Risk Level Thresholds**

```
Safe:    confidence_score >= 80
Warning: confidence_score 40-79
Threat:  confidence_score < 40
```

### Firebase Setup

Required Firebase services:
- **Authentication** (Email, Google, Apple, GitHub)
- **Firestore** (Optional - for cloud sync)

### Supported Platforms

- ✅ Android
- ✅ iOS

**Note**: App requires active internet connection for threat analysis.

---

## 📱 App Icon & Splash Screen

### App Icon Status

**iOS** ✅ **Configured**
- All required icon sizes present (20pt to 1024pt)
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Includes:
  - 1024x1024 (App Store)
  - iPhone icons: 180, 120, 114, 87, 80, 76, 60, 58, 57, 40, 29, 20 (various scales)
  - iPad icons: 152, 144, 100, 80, 76, 72, 58, 50, 40, 29, 20 (various scales)
  - iPad Pro: 167x167

**Android** ✅ **Configured**
- All density buckets covered
- Location: `android/app/src/main/res/mipmap-*/`
- Densities:
  - mdpi: 48x48
  - hdpi: 72x72
  - xhdpi: 96x96
  - xxhdpi: 144x144
  - xxxhdpi: 192x192

### Splash Screen Status

**iOS** ⚠️ **Placeholder Only**
- Uses 1x1 transparent PNG placeholder
- Location: `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- Files: LaunchImage.png, LaunchImage@2x.png, LaunchImage@3x.png
- **Recommendation**: Replace with branded splash screen

**Android** ⚠️ **Basic Configuration**
- Uses white background only
- Location: `android/app/src/main/res/drawable/launch_background.xml`
- No custom logo/branding displayed
- **Recommendation**: Add centered logo to splash screen

### Logo Asset

**Available**:
- `assets/images/logo.png` (75KB)
- Can be used for splash screen branding

### Recommended Updates

To improve splash screen experience:

1. **iOS Splash Screen**:
   ```
   - Replace LaunchImage.png (1x) with 1242x2688 branded image
   - Replace LaunchImage@2x.png (2x) with same image
   - Replace LaunchImage@3x.png (3x) with same image
   ```

2. **Android Splash Screen**:
   Edit `android/app/src/main/res/drawable/launch_background.xml`:
   ```xml
   <item>
     <bitmap
       android:gravity="center"
       android:src="@drawable/splash_logo" />
   </item>
   ```
   Then add splash_logo.png to drawable folders

---

## 📦 Dependencies

### Core Dependencies
```yaml
flutter: SDK
provider: ^6.1.5+1          # State management
```

### Firebase
```yaml
firebase_core: ^3.15.2
firebase_auth: ^5.7.0
```

### UI/UX
```yaml
google_fonts: ^6.3.1
font_awesome_flutter: ^10.10.0
fl_chart: ^0.68.0           # Charts and graphs
flutter_animate: ^4.5.2     # Animations
```

### Networking
```yaml
dio: ^5.9.0                 # HTTP client
connectivity_plus: ^6.0.2   # Network detection
```

### Storage
```yaml
sqflite: ^2.3.0            # Local database
shared_preferences: ^2.3.2  # Key-value storage
```

### Authentication
```yaml
google_sign_in: ^6.3.0
sign_in_with_apple: ^6.1.2
```

### Features
```yaml
mobile_scanner: ^7.0.1      # QR code scanning
image_picker: ^1.2.0        # Gallery access
url_launcher: ^6.3.0        # Open external links
purchases_flutter: ^8.3.0   # RevenueCat monetization
share_handler: ^0.0.19      # Shared content detection
crypto: ^3.0.6              # Encryption utilities
flutter_dotenv: ^5.1.0      # Environment variables
```

---

## 🎨 Design System

PhishPop uses **Material Design 3** with a custom theme system:

### Color Palette
- **Primary Color**: Custom blue
- **Secondary Color**: Complementary accent
- **Semantic Colors**: Success, Warning, Danger
- **Background**: Light mode only

### Components
- Custom AppBar with gradient backgrounds
- Themed buttons (Elevated, Text, Outlined)
- Custom input decorations
- Card components with shadows
- Bottom navigation bar
- Floating action buttons
- Chips, Dialogs, and Snackbars

### Typography
- Google Fonts integration
- Responsive text styles
- Light theme optimized

---

## 💾 Data Management

### Local Database (SQLite)

**Table**: `scan_history`
```sql
CREATE TABLE scan_history (
  id TEXT PRIMARY KEY,
  scan_type TEXT NOT NULL,
  title TEXT NOT NULL,
  date TEXT NOT NULL,
  status TEXT NOT NULL,
  score REAL NOT NULL,
  timestamp TEXT NOT NULL,
  details TEXT,              -- JSON
  flagged_issues TEXT,       -- JSON array
  created_at INTEGER NOT NULL
);

CREATE INDEX idx_timestamp ON scan_history(created_at DESC);
```

**Features**:
- Auto-cleanup (maintains last 50 records)
- CRUD operations
- Singleton pattern implementation

### Shared Preferences

Stores:
- Trusted contacts (Family Mode)
- User preferences
- App settings

---

## 🔐 Security Features

### Data Protection
- ✅ SHA-256 hashing for sensitive operations
- ✅ Firebase Auth tokens
- ✅ Input validation and sanitization
- ✅ SQL injection prevention (parameterized queries)

### Privacy
- ✅ Local data storage
- ✅ Complete data deletion on account removal
- ✅ No tracking without consent
- ✅ Privacy & Security settings screen

### Validation
- Email format validation
- Password strength requirements
- Phone number validation
- URL sanitization

---

## 📱 Main Screens

### 1. **Scan Screen**
   - Text input for message analysis
   - URL input for link checking
   - QR code scanner button

### 2. **History Screen**
   - Chronological list of all scans
   - Filter by type and status
   - Detailed scan reports

### 3. **Stats Screen**
   - Total scans counter
   - Threats detected percentage
   - Protection level indicator
   - Distribution charts
   - Top threats list

### 4. **Safe Parent Screen**
   - Family Mode access
   - Scam Library
   - Decision Helper
   - Quick Report

### 5. **Settings Screen**
   - Account management
   - Privacy & Security
   - Subscription management
   - About & Help

---

## 🧪 Analysis System

### Threat Classification

```dart
Risk Levels:
- Safe:    80-100 confidence score
- Warning: 40-79  confidence score
- Threat:  0-39   confidence score

Classifications:
- Phishing
- Spam
- Malware Link
- Suspicious Content
- Safe Content
- Official Communication
```

### Analysis Metrics
- **Confidence Score**: AI-based certainty percentage
- **Risk Level**: Safe/Warning/Threat classification
- **Flagged Issues**: List of detected problems
- **Processing Time**: Analysis duration in ms
- **Cached**: Whether result was cached

### WiFi Security Analysis

Evaluates:
- Security type (WPA3 > WPA2 > WPA > WEP > Open)
- Password strength
- SSID suspicious patterns
- Network classification

---


## 🚦 State Management

Uses **Provider** pattern with 8 providers:

1. `AppAuthProvider` - Authentication state
2. `HistoryProvider` - Scan history management
3. `StatsProvider` - Statistics calculations
4. `UrlProvider` - URL analysis state
5. `TextProvider` - Text analysis state
6. `QrProvider` - QR scanning state
7. `QrUrlProvider` - QR URL analysis
8. `QrWifiProvider` - WiFi QR analysis
9. `SharedContentProvider` - Shared content handling

---

## 🔄 App Flow

```
Launch App
    ↓
Splash Screen
    ↓
Auth Check
    ↓
┌─────────────────┬─────────────────┐
│  Authenticated  │ Not Authenticated│
└────────┬────────┴────────┬─────────┘
         ↓                 ↓
    Home Screen      Auth Screen
         │           (Login/Register)
         │                 │
         └─────────┬───────┘
                   ↓
         ┌─────────────────┐
         │   Main Tabs     │
         ├─────────────────┤
         │ Scan            │
         │ History         │
         │ Stats           │
         │ Safe Parent     │
         └─────────────────┘
```

---

## 📄 License

Private project. All rights reserved.

---

## 👥 Contributing

This is a private project. Contributions are managed internally.

---

## 🐛 Issues & Support

For bug reports and feature requests, please contact the development team.

---

## 📞 Contact

**Development Team**: Alquimia Studio

---

## 🗺️ Roadmap

### Current Version: 0.1.0

### Planned Features
- [ ] Machine learning model integration
- [ ] Firebase Analytics integration
- [ ] Crashlytics error reporting
- [x] Unit tests (68 passing tests)
- [ ] Rate limiting protection
- [ ] Export scan history (PDF/CSV)

---

## 🧪 Testing

PhishPop includes comprehensive test coverage across unit, widget, and integration tests.

### Running Tests

**Run all tests:**
```bash
flutter test
```

**Run tests with coverage:**
```bash
flutter test --coverage
flutter pub global activate coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # View coverage report
```

**Run specific test files:**
```bash
# Unit tests
flutter test test/unit/helpers/validators_test.dart
flutter test test/unit/models/url_response_model_test.dart
flutter test test/unit/services/wifi_risk_analyzer_test.dart
```

### Test Structure

```
test/
├── unit/                    # Unit tests for business logic
│   ├── helpers/            # Validator tests (24 tests)
│   ├── models/             # Model serialization tests (9 tests)
│   └── services/           # Service logic tests (35 tests)
└── fixtures/                # Test data and fixtures
```

### Test Coverage (68 passing tests)

- **Validators**: Email, password, phone, name validation
- **Models**: JSON serialization/deserialization
- **Services**: WiFi risk analysis, threat detection

### Adding New Tests

1. Create test file in appropriate directory
2. Import test dependencies:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   ```
3. Use fixtures from `test/fixtures/test_data.dart`
4. Follow existing test patterns

---

## 🔨 Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### macOS
```bash
flutter build macos --release
```

---

## ⚙️ Environment Variables

Required `.env` configuration:

```env
# Backend API
API_BASE_URL=https://phish-pop-express-backend.vercel.app
ENVIRONMENT=production

# RevenueCat API Keys
REVENUECAT_ANDROID_API_KEY=your_android_api_key_here
REVENUECAT_IOS_API_KEY=your_ios_api_key_here
```

---

## 🧩 Code Statistics

- **Total Lines of Code**: ~19,225 lines of Dart
- **Custom Widgets**: 142 reusable components
- **Services**: 15 business logic services
- **Models**: 8 data models
- **Screens**: 21+ screens
- **Helpers**: 11 utility files

---

## 🎯 Target Audience

- Non-technical users concerned about digital security
- Parents protecting their families from scams
- Elderly users vulnerable to fraud
- Anyone receiving suspicious messages or links

---

## 💡 Key Differentiators

1. **Family-Focused**: Unique Safe Parent mode with emergency contacts
2. **Educational**: Scam library with practical guidance
3. **Multi-Type Analysis**: Text, URL, QR codes, and WiFi networks
4. **Cross-Platform**: Available on iOS and Android
5. **Privacy-First**: Local data storage, complete deletion option
6. **USA/Canada Only**: Optimized for North American markets

---

## 🛠️ Development

### Debug Mode
```bash
flutter run --debug
```

### Profile Mode
```bash
flutter run --profile
```

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
dart format lib/
```

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [RevenueCat Documentation](https://docs.revenuecat.com/)
- [Material Design 3](https://m3.material.io/)

---

**Built with ❤️ by Alquimia Studio**
