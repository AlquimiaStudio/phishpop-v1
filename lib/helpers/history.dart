import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

ScanHistoryModel createWifiHistoryEntry(dynamic wifiResponse) {
  final now = DateTime.now();
  return ScanHistoryModel(
    id: wifiResponse.id,
    scanType: 'wifi',
    title: wifiResponse.ssid,
    date: formatHistoryTimestamp(now),
    status: _getWifiClassificationString(wifiResponse.classification),
    score: wifiResponse.securityScore * 100,
    timestamp: now,
    details: wifiResponse.toJson(),
    flaggedIssues: wifiResponse.flaggedIssues,
  );
}

String formatHistoryTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
  if (difference.inHours < 24) return '${difference.inHours} hours ago';
  if (difference.inDays < 7) return '${difference.inDays} days ago';

  return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
}

ScanHistoryModel createQrUrlHistoryEntry(QRUrlResponseModel qrUrlResponse) {
  final now = DateTime.now();
  return ScanHistoryModel(
    id: qrUrlResponse.id,
    scanType: 'qr_url',
    title: qrUrlResponse.url,
    date: formatHistoryTimestamp(now),
    status: mapUrlClassificationToStatus(qrUrlResponse.classification.name),
    score: qrUrlResponse.urlAnalysisScore * 100,
    timestamp: now,
    details: qrUrlResponse.toJson(),
    flaggedIssues: qrUrlResponse.flaggedIssues,
  );
}

ScanHistoryModel createTextHistoryEntry(ITextResponse textResponse) {
  final now = DateTime.now();
  return ScanHistoryModel(
    id: textResponse.id,
    scanType: 'text',
    title: _truncateText(textResponse.text, 50),
    date: formatHistoryTimestamp(now),
    status: mapGenericClassificationToStatus(textResponse.classification),
    score: textResponse.textAnalysisScore * 100,
    timestamp: now,
    details: textResponse.toJson(),
    flaggedIssues: textResponse.flaggedIssues,
  );
}

ScanHistoryModel createUrlHistoryEntry(IUrlResponse urlResponse) {
  final now = DateTime.now();
  return ScanHistoryModel(
    id: urlResponse.id,
    scanType: 'url',
    title: urlResponse.url,
    date: formatHistoryTimestamp(now),
    status: mapGenericClassificationToStatus(urlResponse.classification),
    score: urlResponse.urlAnalysisScore * 100,
    timestamp: now,
    details: urlResponse.toJson(),
    flaggedIssues: urlResponse.flaggedIssues,
  );
}

String mapWifiClassificationToStatus(String classification) {
  switch (classification) {
    case 'safe':
      return 'safe';
    case 'suspicious':
      return 'warning';
    case 'unsafe':
      return 'threat';
    default:
      return 'safe';
  }
}

String mapUrlClassificationToStatus(String classification) {
  switch (classification) {
    case 'safe':
      return 'safe';
    case 'malware':
      return 'threat';
    case 'phishing':
      return 'threat';
    case 'suspicious':
      return 'warning';
    case 'blocked':
      return 'threat';
    default:
      return 'safe';
  }
}

String mapGenericClassificationToStatus(String classification) {
  switch (classification.toLowerCase()) {
    case 'safe':
      return 'safe';
    case 'low':
      return 'safe';
    case 'medium':
      return 'warning';
    case 'warning':
      return 'warning';
    case 'suspicious':
      return 'warning';
    case 'high':
      return 'threat';
    case 'critical':
      return 'threat';
    case 'threat':
      return 'threat';
    case 'malware':
      return 'threat';
    case 'phishing':
      return 'threat';
    case 'scam':
      return 'threat';
    case 'unsafe':
      return 'threat';
    default:
      return 'safe';
  }
}

String _truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

dynamic reconstructResponseFromHistory(ScanHistoryModel historyItem) {
  switch (historyItem.scanType) {
    case 'wifi':
      return QrWifiResponse.fromJson(historyItem.details!);
    case 'qr_url':
      return QRUrlResponseModel.fromJson(historyItem.details!);
    case 'text':
      return ITextResponse.fromJson(historyItem.details!);
    case 'url':
      return IUrlResponse.fromJson(historyItem.details!);
    default:
      throw Exception('Unknown scan type: ${historyItem.scanType}');
  }
}

void navigateToScanDetail(BuildContext context, ScanHistoryModel historyItem) {
  try {
    final originalResponse = reconstructResponseFromHistory(historyItem);

    switch (historyItem.scanType) {
      case 'wifi':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrWifiSummaryScreen(
              wifiContent:
                  'WIFI:T:${QrWifiResponse.securityTypeToString(originalResponse.securityType)};S:${originalResponse.ssid};P:${originalResponse.password};;',
              analysisResult: originalResponse,
              isCached: true,
            ),
          ),
        );
        break;
      case 'qr_url':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrUrlSummaryScreen(
              urlToAnalyze: originalResponse.url,
              analysisResult: originalResponse,
              isCached: true,
            ),
          ),
        );
        break;
      case 'text':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextSummaryScreen(
              textToAnalyze: originalResponse.text,
              analysisResult: originalResponse,
              isCached: true,
            ),
          ),
        );
        break;
      case 'url':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrlSummaryScreen(
              urlToAnalyze: originalResponse.url,
              analysisResult: originalResponse,
              isCached: true,
            ),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown scan type: ${historyItem.scanType}'),
            backgroundColor: Colors.red,
          ),
        );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error opening scan details: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

String _getWifiClassificationString(WifiClassification classification) {
  switch (classification) {
    case WifiClassification.safe:
      return mapWifiClassificationToStatus('safe');
    case WifiClassification.unsafe:
      return mapWifiClassificationToStatus('unsafe');
    case WifiClassification.suspicious:
      return mapWifiClassificationToStatus('suspicious');
  }
}
