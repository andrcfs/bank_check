import 'package:bank_check/src/utils/constants.dart'; // Added import
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FilePickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String filePath;
  final VoidCallback onPressed;

  const FilePickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.filePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center, // Added
          backgroundColor: secondaryColor, // Changed
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 16), // Changed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            SizedBox(
              height: filePath.isNotEmpty
                  ? 28
                  : 0, // To accommodate two lines of text or provide spacing
              child: filePath.isNotEmpty
                  ? Text(
                      basename(filePath).replaceAll('.xlsx', ''),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    )
                  : Container(), // Empty container to maintain space
            )
          ],
        ),
      ),
    );
  }
}

class GenerateReportButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData iconData;

  const GenerateReportButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Changed
          children: [
            Text(label),
            const SizedBox(width: 8),
            Icon(iconData, size: 18),
          ],
        ),
      ),
    );
  }
}
