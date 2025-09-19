import '../models/models.dart';

List<ScanHistoryModel> getScanHistoryData() {
  return [
    ScanHistoryModel(
      scanType: 'url',
      title: 'paypal-security-update.com',
      date: '2 minutes ago',
      status: 'threat',
      score: 95.0,
    ),
    ScanHistoryModel(
      scanType: 'text',
      title: 'Suspicious WhatsApp message',
      date: '15 minutes ago',
      status: 'warning',
      score: 70.0,
    ),
    ScanHistoryModel(
      scanType: 'webpage',
      title: 'amazon-prize-winner.net',
      date: '1 hour ago',
      status: 'threat',
      score: 88.0,
    ),
    ScanHistoryModel(
      scanType: 'url',
      title: 'https://google.com',
      date: '2 hours ago',
      status: 'safe',
      score: 5.0,
    ),
    ScanHistoryModel(
      scanType: 'text',
      title: 'Netflix promotional email',
      date: '3 hours ago',
      status: 'warning',
      score: 45.0,
    ),
    ScanHistoryModel(
      scanType: 'wifi',
      title: 'FREE_WIFI_MALL',
      date: '5 hours ago',
      status: 'threat',
      score: 82.0,
    ),
    ScanHistoryModel(
      scanType: 'webpage',
      title: 'microsoft-support-alert.com',
      date: '1 day ago',
      status: 'threat',
      score: 92.0,
    ),
    ScanHistoryModel(
      scanType: 'url',
      title: 'https://github.com',
      date: '1 day ago',
      status: 'safe',
      score: 8.0,
    ),
    ScanHistoryModel(
      scanType: 'text',
      title: 'SMS: You won \$1000 prize',
      date: '2 days ago',
      status: 'threat',
      score: 97.0,
    ),
    ScanHistoryModel(
      scanType: 'webpage',
      title: 'facebook.com',
      date: '3 days ago',
      status: 'safe',
      score: 12.0,
    ),
  ];
}
