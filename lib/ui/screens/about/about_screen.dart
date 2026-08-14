import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/preferences/regional_variant_service.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(regionalVariantProvider);
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
              const SizedBox(height: 28),
              Text(
                'VARIANTE REGIONAL',
                style: MunusTextStyles.sectionTitle(18),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: MunusColors.textRubric, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _VariantOption(
                      label: 'España',
                      selected: variant == RegionalVariant.espana,
                      onTap: () => ref
                          .read(regionalVariantProvider.notifier)
                          .setVariant(RegionalVariant.espana),
                    ),
                    _VariantOption(
                      label: 'Argentina',
                      selected: variant == RegionalVariant.argentina,
                      onTap: () => ref
                          .read(regionalVariantProvider.notifier)
                          .setVariant(RegionalVariant.argentina),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aplica a los rituales que ya tengan versión argentina disponible. El resto se muestra en español.',
                textAlign: TextAlign.center,
                style: MunusTextStyles.reference(13),
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

class _VariantOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _VariantOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? MunusColors.textRubric : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: MunusFonts.ui,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? MunusColors.background : MunusColors.textMain,
          ),
        ),
      ),
    );
  }
}