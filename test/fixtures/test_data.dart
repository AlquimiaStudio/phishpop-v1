/// Test fixtures and mock data for PhishPop tests
library;

// URL Response Mock Data
final Map<String, dynamic> mockUrlResponseJson = {
  'id': 'test-123',
  'url': 'https://example.com',
  'scan_type': 'url',
  'result': 'Safe content detected',
  'risk_level': 'Safe',
  'classification': 'Safe Content',
  'confidence_score': 95.5,
  'url_analysis_score': 92.0,
  'flagged_issues': ['No issues found'],
  'timestamp': '2024-01-01T12:00:00Z',
  'processing_time': 1500,
  'cached': false,
  'expire_time': '2024-01-01T13:00:00Z',
};

final Map<String, dynamic> mockPhishingUrlResponseJson = {
  'id': 'test-456',
  'url': 'https://suspicious-phishing-site.com',
  'scan_type': 'url',
  'result': 'Phishing attempt detected',
  'risk_level': 'Threat',
  'classification': 'Phishing',
  'confidence_score': 15.5,
  'url_analysis_score': 10.0,
  'flagged_issues': [
    'Suspicious domain',
    'Known phishing pattern',
    'Credential harvesting detected'
  ],
  'timestamp': '2024-01-01T12:00:00Z',
  'processing_time': 2000,
  'cached': true,
  'expire_time': null,
};

// Text Response Mock Data
final Map<String, dynamic> mockTextResponseJson = {
  'id': 'text-789',
  'content': 'Hello, this is a legitimate message',
  'scan_type': 'text',
  'result': 'Safe content',
  'risk_level': 'Safe',
  'classification': 'Safe Content',
  'confidence_score': 88.0,
  'flagged_issues': [],
  'timestamp': '2024-01-01T12:00:00Z',
  'processing_time': 800,
  'cached': false,
};

// Scan History Mock Data
final Map<String, dynamic> mockScanHistoryJson = {
  'id': 'scan-001',
  'scan_type': 'url',
  'title': 'https://example.com',
  'date': '2024-01-01',
  'status': 'Safe',
  'score': 95.5,
  'timestamp': '2024-01-01T12:00:00Z',
  'details': mockUrlResponseJson,
  'flagged_issues': ['No issues found'],
  'created_at': 1704110400000,
};

// WiFi Network Mock Data
const String mockWifiQrCodeSecure = 'WIFI:T:WPA2;S:MySecureNetwork;P:StrongPassword123!;;';
const String mockWifiQrCodeOpen = 'WIFI:T:nopass;S:PublicWiFi;P:;;';
const String mockWifiQrCodeWep = 'WIFI:T:WEP;S:OldNetwork;P:12345;;';

// Valid Test Emails
const List<String> validEmails = [
  'test@example.com',
  'user.name@domain.co.uk',
  'test_user@sub.domain.com',
];

// Invalid Test Emails
const List<String> invalidEmails = [
  'invalid.email',
  '@example.com',
  'test@',
  'test @example.com',
  'test@.com',
];

// Valid Passwords
const List<String> validPasswords = [
  'Password123',
  'SecureP@ss1',
  'Test1234A',
  'MyP4ssword',
];

// Invalid Passwords
const List<String> invalidPasswords = [
  'short',
  'nouppercase123',
  'NOLOWERCASE123',
  'NoNumbers',
  'Pass1',
];

// Valid Phone Numbers
const List<String> validPhoneNumbers = [
  '+1234567890',
  '+447911123456',
  '1234567890',
  '+34612345678',
];

// Invalid Phone Numbers
const List<String> invalidPhoneNumbers = [
  'abc123456',
  '+0000000000',
  '12-345-6789',
];

// Test URLs
const String safeUrl = 'https://google.com';
const String suspiciousUrl = 'http://bit.ly/xyz123';
const String maliciousUrl = 'https://phishing-site-example.com';
