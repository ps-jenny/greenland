import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenland/WelcomePage.dart';

void main() {
  testWidgets('WelcomePage displays welcome text and slogan', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: WelcomePage(),
    ));

    
    expect(find.text('Welcome to Greenland'), findsOneWidget);


    expect(find.text('Harvesting Health, Cultivating Taste – Your Organic Oasis for Vibrant Vegetables!'), findsOneWidget);

 
    expect(find.text('Get Started'), findsOneWidget);


    expect(find.byType(ElevatedButton),findsOneWidget);

  });
}
