import 'package:flutter/material.dart';

/// Escrollea gradualmente [controller] hasta que el widget con [key] se
/// monte y quede efectivamente visible, y ahí lo centra prolijamente en
/// el viewport.
///
/// Hace falta ir "a los tumbos" (de a tramos, no directo a un offset) en
/// vez de calcular la posición e ir directo: en un ListView los ítems
/// fuera del viewport + cacheExtent ni siquiera están montados todavía --
/// no existe su posición en pantalla hasta que se scrollea lo bastante
/// cerca como para que Flutter los construya. Por eso primero hay que
/// "acercarse" y recién ahí centrar con precisión.
Future<void> scrollKeyIntoView(
  GlobalKey key,
  ScrollController controller, {
  double chunk = 400,
  int maxAttempts = 40,
}) async {
  if (key.currentContext != null) {
    await _center(key);
    return;
  }
  if (!controller.hasClients) return;

  var attempts = 0;
  while (key.currentContext == null && attempts < maxAttempts) {
    if (!controller.hasClients) return;
    final max = controller.position.maxScrollExtent;
    final next = (controller.offset + chunk).clamp(0.0, max);
    await controller.animateTo(
      next,
      duration: const Duration(milliseconds: 30),
      curve: Curves.linear,
    );
    // Le da un respiro al frame para que Flutter monte lo que quedó
    // recién dentro del viewport/cacheExtent tras ese tramo de scroll.
    await Future.delayed(const Duration(milliseconds: 16));
    attempts++;
    if (next >= max) break;
  }

  if (key.currentContext != null) {
    await _center(key);
  }
}

Future<void> _center(GlobalKey key) {
  final context = key.currentContext;
  if (context == null) return Future.value();
  return Scrollable.ensureVisible(
    context,
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOut,
    alignment: 0.3,
  );
}
