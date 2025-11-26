import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_colors.dart';
import '../../config/branding_config.dart';
import '../../constants/api_url.dart';

class ReportContentDialog extends StatefulWidget {
  final String itemId;
  final String module; // 'bolo', 'suno', 'likho', 'dekho'
  
  const ReportContentDialog({
    Key? key,
    required this.itemId,
    required this.module,
  }) : super(key: key);

  @override
  State<ReportContentDialog> createState() => _ReportContentDialogState();
}

class _ReportContentDialogState extends State<ReportContentDialog> {
  String? selectedReason;
  final TextEditingController _reasonController = TextEditingController();
  final int maxCharacters = 100;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final String reportUrl = '${ApiUrl.baseUrl}/${widget.module}/report';
      
      final response = await http.post(
        Uri.parse(reportUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': widget.itemId,
          'report_type': selectedReason,
          'description': _reasonController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Failed to submit report');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit report. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  'Report Content',
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greys87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Subtitle
            Center(
              child: Text(
                "Help us to understand what's wrong with the recording",
                textAlign: TextAlign.center,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 13,
                  color: AppColors.greys60,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Offensive option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedReason = 'offensive';
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.orange,
                        width: 2,
                      ),
                      color: AppColors.backgroundColor,
                    ),
                    child: selectedReason == 'offensive'
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offensive',
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greys87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hateful/ Discriminatory/ Vulgar language, drugs promotion etc.',
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 13,
                            color: AppColors.greys60,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Others option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedReason = 'others';
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.orange,
                        width: 2,
                      ),
                      color: AppColors.backgroundColor,
                    ),
                    child: selectedReason == 'others'
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Others',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greys87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Text field
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightGreen4.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _reasonController,
                maxLength: maxCharacters,
                maxLines: 4,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 14,
                  color: AppColors.greys87,
                ),
                decoration: InputDecoration(
                  hintText: 'Please Specify the reason ( Optional)',
                  hintStyle: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 14,
                    color: AppColors.grey40,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),
            // Character counter
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Only $maxCharacters characters allowed !',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 11,
                  color: AppColors.negativeLight,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () async {
                  if (selectedReason != null) {
                    await _submitReport();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit',
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
