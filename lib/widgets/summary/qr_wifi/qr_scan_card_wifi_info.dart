import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';

class QrScanCardWifiInfo extends StatelessWidget {
  final String ssid;
  final String securityType;
  final int? signalStrength;

  const QrScanCardWifiInfo({
    super.key,
    required this.ssid,
    required this.securityType,
    this.signalStrength,
  });

  void copyToClipboard(BuildContext context, String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String label,
    required String value,
    required String copyType,
    required IconData icon,
    bool showCopy = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.mediumText),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.mediumText,
              ),
            ),
            const Spacer(),
            if (showCopy)
              IconButton(
                onPressed: () => copyToClipboard(context, value, copyType),
                icon: Icon(Icons.copy, size: 18, color: AppColors.primaryColor),
                tooltip: 'Copy $copyType',
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getSignalStrengthText() {
    if (signalStrength == null) return 'Unknown';
    
    if (signalStrength! >= -30) return 'Excellent (${signalStrength}dBm)';
    if (signalStrength! >= -50) return 'Good (${signalStrength}dBm)';
    if (signalStrength! >= -60) return 'Fair (${signalStrength}dBm)';
    if (signalStrength! >= -70) return 'Weak (${signalStrength}dBm)';
    return 'Very Weak (${signalStrength}dBm)';
  }

  IconData _getSignalIcon() {
    if (signalStrength == null) return Icons.signal_wifi_off;
    
    if (signalStrength! >= -50) return Icons.wifi;
    if (signalStrength! >= -60) return Icons.wifi;
    if (signalStrength! >= -70) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection(
          context: context,
          label: 'Network Name (SSID)',
          value: ssid,
          copyType: 'SSID',
          icon: Icons.wifi,
        ),
        const SizedBox(height: 16),
        _buildInfoSection(
          context: context,
          label: 'Security Type',
          value: securityType.toUpperCase(),
          copyType: 'Security Type',
          icon: Icons.security,
          showCopy: false,
        ),
        if (signalStrength != null) ...[
          const SizedBox(height: 16),
          _buildInfoSection(
            context: context,
            label: 'Signal Strength',
            value: _getSignalStrengthText(),
            copyType: 'Signal Strength',
            icon: _getSignalIcon(),
            showCopy: false,
          ),
        ],
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}