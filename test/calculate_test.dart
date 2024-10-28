import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenland/ProductsCreate.dart';

void main() {
  testWidgets('Calculate Sales Price Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: ProductsCreate(),
    ));

    // Set the purchase price
    final purchasePriceTextField = find.widgetWithText(TextField, 'Purchase Price');
    await tester.enterText(purchasePriceTextField, '10.0');

    // Trigger the onChanged callback to update the sales price
    await tester.pump();

    // Get the Sales Price text widget
    final salesPriceText = find.text('Sales Price: \$14.00');

    // Verify that the Sales Price is correctly calculated and displayed
    expect(salesPriceText, findsOneWidget);
  });
}
