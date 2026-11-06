import 'package:flutter_test/flutter_test.dart';
import 'package:radio_app/helpers/constants.dart';

void main() {
  test('El catálogo tiene las cuatro estaciones de Freepi', () {
    expect(DemoData.stations.length, 4);
    expect(
      DemoData.stations.map((s) => s.acronym),
      containsAll(<String>['GSL', 'SAG', 'IPR', 'NRFM']),
    );
    expect(
      DemoData.stations.every((s) => s.streamUrl.startsWith('https://')),
      isTrue,
    );
  });

  test('El carrusel filtra los programas por emisora', () {
    final programs = DemoData.programsFor('nrfm');
    expect(programs, isNotEmpty);
    expect(programs.every((p) => p.stationId == 'nrfm'), isTrue);
  });
}
