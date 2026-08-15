import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de',
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: MunusColors.textMain,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'MUNUS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: MunusFonts.display,
                  fontSize: 40,
                  fontWeight: FontWeight.w200,
                  color: MunusColors.textMain,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.data?.version ?? '';
                  return Text(
                    version.isNotEmpty ? 'Versión $version' : '',
                    style: MunusTextStyles.reference(14),
                  );
                },
              ),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: MunusTextStyles.bodyText(16),
                  children: [
                    const TextSpan(
                        text: 'Munus nace para acompañar al sacerdote en el ejercicio del '),
                    TextSpan(
                        text: 'munus sanctificandi',
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    const TextSpan(
                        text: ', brindando un acceso rápido y personalizable a los rituales de uso frecuente para colaborar en la acción pastoral cotidiana.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}