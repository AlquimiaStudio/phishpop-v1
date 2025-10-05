import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../theme/theme.dart';

class QrWifiConnectionButton extends StatefulWidget {
  final QrWifiResponse result;

  const QrWifiConnectionButton({super.key, required this.result});

  @override
  State<QrWifiConnectionButton> createState() => _QrWifiConnectionButtonState();
}

class _QrWifiConnectionButtonState extends State<QrWifiConnectionButton> {
  bool _isConnecting = false;

  Future<void> _connectToWifi() async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
    });

    try {
      // Use widget.result directly instead of provider
      final qrWifiService = QrWifiAnalysisService();
      qrWifiService.showWifiConnectionDialog(context, widget.result);
    } catch (e) {
      if (mounted) {
        _showConnectionDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  void _showConnectionDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.wifi, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text('WiFi Connection'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              if (Platform.isIOS) ...[
                Text(
                  'Network Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('SSID: ${widget.result.ssid}'),
                Text(
                  'Security: ${QrWifiResponse.securityTypeToString(widget.result.securityType).toUpperCase()}',
                ),
              ],
            ],
          ),
          actions: [
            if (Platform.isIOS)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Open Settings'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _getButtonContent() {
    if (_isConnecting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text('Connecting...'),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.wifi, size: 18),
        const SizedBox(width: 8),
        Text('Connect to WiFi Network'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: _isConnecting ? null : _connectToWifi,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _getButtonContent(),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }
}
