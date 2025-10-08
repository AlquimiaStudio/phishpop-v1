import 'package:flutter_test/flutter_test.dart';
import 'package:phishpop/models/url_response_model.dart';
import '../../fixtures/test_data.dart';

void main() {
  group('IUrlResponse Model', () {
    group('fromJson', () {
      test('should create valid model from JSON with all fields', () {
        final model = IUrlResponse.fromJson(mockUrlResponseJson);

        expect(model.id, equals('test-123'));
        expect(model.url, equals('https://example.com'));
        expect(model.scanType, equals('url'));
        expect(model.result, equals('Safe content detected'));
        expect(model.riskLevel, equals('Safe'));
        expect(model.classification, equals('Safe Content'));
        expect(model.confidenceScore, equals(95.5));
        expect(model.urlAnalysisScore, equals(92.0));
        expect(model.flaggedIssues, equals(['No issues found']));
        expect(model.timestamp, equals('2024-01-01T12:00:00Z'));
        expect(model.processingTime, equals(1500));
        expect(model.cached, isFalse);
        expect(model.expireTime, equals('2024-01-01T13:00:00Z'));
      });

      test('should create model from JSON for phishing URL', () {
        final model = IUrlResponse.fromJson(mockPhishingUrlResponseJson);

        expect(model.riskLevel, equals('Threat'));
        expect(model.classification, equals('Phishing'));
        expect(model.confidenceScore, equals(15.5));
        expect(model.flaggedIssues, hasLength(3));
        expect(model.flaggedIssues[0], equals('Suspicious domain'));
        expect(model.cached, isTrue);
        expect(model.expireTime, isNull);
      });

      test('should handle null expireTime', () {
        final jsonWithoutExpire = Map<String, dynamic>.from(mockUrlResponseJson);
        jsonWithoutExpire['expire_time'] = null;

        final model = IUrlResponse.fromJson(jsonWithoutExpire);

        expect(model.expireTime, isNull);
      });

      test('should handle empty flagged issues list', () {
        final jsonWithEmptyIssues = Map<String, dynamic>.from(mockUrlResponseJson);
        jsonWithEmptyIssues['flagged_issues'] = [];

        final model = IUrlResponse.fromJson(jsonWithEmptyIssues);

        expect(model.flaggedIssues, isEmpty);
      });

      test('should handle integer confidence scores', () {
        final jsonWithIntScore = Map<String, dynamic>.from(mockUrlResponseJson);
        jsonWithIntScore['confidence_score'] = 95;
        jsonWithIntScore['url_analysis_score'] = 90;

        final model = IUrlResponse.fromJson(jsonWithIntScore);

        expect(model.confidenceScore, equals(95.0));
        expect(model.urlAnalysisScore, equals(90.0));
      });
    });

    group('toJson', () {
      test('should convert model to JSON correctly', () {
        final model = IUrlResponse.fromJson(mockUrlResponseJson);
        final json = model.toJson();

        expect(json['id'], equals('test-123'));
        expect(json['url'], equals('https://example.com'));
        expect(json['scan_type'], equals('url'));
        expect(json['result'], equals('Safe content detected'));
        expect(json['risk_level'], equals('Safe'));
        expect(json['classification'], equals('Safe Content'));
        expect(json['confidence_score'], equals(95.5));
        expect(json['url_analysis_score'], equals(92.0));
        expect(json['flagged_issues'], equals(['No issues found']));
        expect(json['timestamp'], equals('2024-01-01T12:00:00Z'));
        expect(json['processing_time'], equals(1500));
        expect(json['cached'], isFalse);
        expect(json['expire_time'], equals('2024-01-01T13:00:00Z'));
      });

      test('should preserve null expireTime in JSON', () {
        final model = IUrlResponse.fromJson(mockPhishingUrlResponseJson);
        final json = model.toJson();

        expect(json['expire_time'], isNull);
      });
    });

    group('JSON Serialization Round Trip', () {
      test('should maintain data integrity through fromJson -> toJson cycle', () {
        final originalModel = IUrlResponse.fromJson(mockUrlResponseJson);
        final json = originalModel.toJson();
        final reconstructedModel = IUrlResponse.fromJson(json);

        expect(reconstructedModel.id, equals(originalModel.id));
        expect(reconstructedModel.url, equals(originalModel.url));
        expect(reconstructedModel.confidenceScore, equals(originalModel.confidenceScore));
        expect(reconstructedModel.flaggedIssues, equals(originalModel.flaggedIssues));
        expect(reconstructedModel.cached, equals(originalModel.cached));
      });
    });

    group('Model Construction', () {
      test('should create model with const constructor', () {
        const model = IUrlResponse(
          id: 'test',
          url: 'https://test.com',
          scanType: 'url',
          result: 'Safe',
          riskLevel: 'Safe',
          classification: 'Safe Content',
          confidenceScore: 90.0,
          urlAnalysisScore: 88.0,
          flaggedIssues: [],
          timestamp: '2024-01-01T00:00:00Z',
          processingTime: 1000,
          cached: false,
        );

        expect(model.id, equals('test'));
        expect(model.expireTime, isNull);
      });
    });
  });
}
