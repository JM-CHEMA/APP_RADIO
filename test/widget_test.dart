import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio_app/helpers/constants.dart';
import 'package:radio_app/widgets/station_card.dart';

void main() {
  testWidgets('StationCard muestra el modelo y responde al toque', (
    tester,
  ) async {
    var selected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StationCard(
            // Nightride usa una carátula local de reserva
            station: DemoData.stations.last,
            isActive: false,
            onTap: () => selected = true,
          ),
        ),
      ),
    );
    expect(find.text('Nightride FM'), findsOneWidget);
    // El acrónimo aparece en la tarjeta y también en la carátula de reserva.
    expect(find.text('NRFM'), findsWidgets);
    await tester.tap(find.text('Nightride FM'));
    expect(selected, isTrue);
  });
}
