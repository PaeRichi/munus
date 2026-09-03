import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';

/// Muestra el QR para la asamblea como modal (bottom sheet), en vez de
/// navegar a una pantalla nueva -- mismo lenguaje visual que el modal de
/// "Elegir fórmula" (showModalBottomSheet).
///
/// Dos decisiones a propósito, pensando en cómo se usa esto en una
/// celebración real:
/// - `isScrollControlled: true` + casi toda la altura de la pantalla:
///   un QR necesita tamaño y contraste para escanearse bien a distancia,
///   así que no lo achicamos a un cuarto de pantalla como el de opciones.
/// - `enableDrag: false`: el QR se supone que queda activo un rato
///   mientras la asamblea lo escanea, así que no debería cerrarse con un
///   deslizón accidental. Se cierra con la X o tocando afuera.
void showAssemblyQrSheet(
  BuildContext context, {
  required String url,
  required String celebrationTitle,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MunusColors.background,
    isScrollControlled: true,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: MunusColors.textDiscrete),
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ),
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
              const SizedBox(height: 32),
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
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
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
      );
    },
  );
}
