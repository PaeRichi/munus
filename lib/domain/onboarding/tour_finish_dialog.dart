import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Diálogo de cierre breve, mostrado al terminar un tour (general o de
/// celebración). Estilo consistente con TourStepContent pero sin apuntar
/// a ningún elemento de la pantalla -- va centrado.
Future<void> showTourFinishDialog(
  BuildContext context, {
  required String message,
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => Dialog(
      backgroundColor: MunusColors.background,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MunusFonts.display,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: MunusColors.textMain,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: MunusColors.textRubric,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Comenzar',
                  style: TextStyle(
                    fontFamily: MunusFonts.ui,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MunusColors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
