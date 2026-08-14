import '../../models/category.dart';

const List<Category> initialCategories = [
  Category(
    id: 'bendiciones',
    title: 'Bendiciones',
    order: 1,
  ),
  Category(
    id: 'enfermos_y_difuntos',
    title: 'Enfermos y difuntos',
    order: 2,
  ),
  Category(
    id: 'adoracion',
    title: 'Adoración',
    order: 3,
  ),
  Category(
    id: 'vesticion',
    title: 'Vestición',
    order: 4,
  ),
];

const Map<String, List<Map<String, String>>> celebrationsByCategory = {
  'bendiciones': [
    {
      'id': 'bendicion_del_agua_fuera_de_la_misa',
      'title': 'Bendición del agua',
      'assetPath': 'assets/rituals/bendiciones/bendicion_del_agua_fuera_de_la_misa.yaml',
    },
    {
      'id': 'bendicion_objetos_piadosos',
      'title': 'Bendición de objetos piadosos',
      'assetPath': 'assets/rituals/bendiciones/bendicion_objetos_piadosos.yaml',
    },
    {
      'id': 'bendicion_de_una_nueva_casa',
      'title': 'Bendición de una nueva casa',
      'assetPath': 'assets/rituals/bendiciones/bendicion_de_una_nueva_casa.yaml',
    },
    {
      'id': 'bendicion_laboratorio_taller_tienda',
      'title': 'Bendición de laboratorio, taller o tienda',
      'assetPath': 'assets/rituals/bendiciones/bendicion_laboratorio_taller_tienda.yaml',
    },
    {
      'id': 'bendicion_vehiculo_y_barca',
      'title': 'Bendición de vehículo o barca',
      'assetPath': 'assets/rituals/bendiciones/bendicion_vehiculo_y_barca.yaml',
    },
    {
      'id': 'bendicion_medalla_san_benito',
      'title': 'Bendición de la medalla de San Benito',
      'assetPath': 'assets/rituals/bendiciones/bendicion_medalla_san_benito.yaml',
    },
    {
      'id': 'exorcismo_bendicion_sal_y_agua',
      'title': 'Exorcismo y bendición de sal y agua',
      'assetPath': 'assets/rituals/bendiciones/exorcismo_bendicion_sal_y_agua.yaml',
    },
    {
      'id': 'bendicion_e_imposicion_del_escapulario',
      'title': 'Bendición e imposición del escapulario',
      'assetPath': 'assets/rituals/bendiciones/bendicion_e_imposicion_del_escapulario.yaml',
    },
  ],
  'enfermos_y_difuntos': [
    {
      'id': 'uncion_cap2_rito_ordinario',
      'title': 'Unción de los enfermos',
      'assetPath': 'assets/rituals/sacramentos/uncion_cap2_rito_ordinario.yaml',
    },
    {
      'id': 'indulgencia_plenaria_in_articulo_mortis',
      'title': 'Indulgencia plenaria in articulo mortis',
      'assetPath': 'assets/rituals/sacramentos/indulgencia_plenaria_articulo_mortis.yaml',
    },
    {
      'id': 'responso_por_los_difuntos_iii',
      'title': 'Responso por los difuntos',
      'assetPath': 'assets/rituals/difuntos/responso_por_los_difuntos_iii.yaml',
    },
    {
      'id': 'ultimo_adios_al_cuerpo_del_difunto',
      'title': 'Último adiós al cuerpo del difunto',
      'assetPath': 'assets/rituals/difuntos/ultimo_adios_al_cuerpo_del_difunto.yaml',
    },
  ],
  'adoracion': [
    {
      'id': 'letanias_de_desagravio',
      'title': 'Letanías de desagravio',
      'assetPath': 'assets/rituals/adoracion/letanias_de_desagravio.yaml',
    },
    {
      'id': 'oracion_antes_de_la_bendicion_eucaristica',
      'title': 'Oración antes de la bendición eucarística',
      'assetPath': 'assets/rituals/adoracion/oracion_antes_de_la_bendicion_eucaristica.yaml',
    },
  ],
  'vesticion': [
    {
      'id': 'oraciones_de_vesticion',
      'title': 'Oraciones de vestición',
      'assetPath': 'assets/rituals/vesticion/oraciones_de_vesticion.yaml',
    },
  ],
};