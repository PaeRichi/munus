enum LiturgicalElementType {
  greeting,
  monition,
  rubric,
  title,
  reading,
  psalm,
  intercessions,
  litany,
  prayer,
  gesture,
  response,
  blessing,
  conclusion,
}

enum LiturgicalRole {
  celebrant,
  lector,
  assembly,
  all,
}

class LiturgicalOption {
  final String id;
  final String? reference;
  final String? text;
  final String? displayName;
  final String? heading;
  final List<LiturgicalElement> elements;

  const LiturgicalOption({
    required this.id,
    this.reference,
    this.text,
    this.displayName,
    this.heading,
    this.elements = const [],
  });
}

class LiturgicalInvocation {
  final String invocation;
  final String response;

  const LiturgicalInvocation({
    required this.invocation,
    required this.response,
  });
}

class LiturgicalElement {
  final String id;
  final LiturgicalElementType type;
  final LiturgicalRole role;
  final bool isRequired;

  final String? text;
  final String? reference;
  final String? heading;
  final String? response;
  final List<LiturgicalOption> options;
  final List<LiturgicalInvocation> invocations;
  final String? invitation;
  final String? fixedResponse;
  final String? refrain;
  final List<String> strophes;

  const LiturgicalElement({
    required this.id,
    required this.type,
    required this.role,
    required this.isRequired,
    this.text,
    this.reference,
    this.heading,
    this.response,
    this.options = const [],
    this.invocations = const [],
    this.invitation,
    this.fixedResponse,
    this.refrain,
    this.strophes = const [],
  });
}