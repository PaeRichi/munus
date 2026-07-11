import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';

class AssemblyQrScreen extends StatelessWidget {
  final String url;
  final String celebrationTitle;

  const AssemblyQrScreen({
    super.key,
    required this.url,
    required this.celebrationTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MunusColors.background,
      appBar: AppBar(
        title: const Text('Para la asamblea'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  celebrationTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MunusFonts.display,
                    fontSize: 24,
                    color: MunusColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Los fieles pueden escanear este código',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MunusFonts.ui,
                    fontSize: 13,
                    color: MunusColors.textDiscrete,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: QrImageView(
                    data: url,
                    version: QrVersions.auto,
                    size: 260,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copiada')),
                    );
                  },
                  child: Text(
                    'Copiar URL',
                    style: TextStyle(
                      fontFamily: MunusFonts.ui,
                      color: MunusColors.textDiscrete,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}