import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenland/models/colors.dart';

class ProductsCreate extends StatefulWidget {
  @override
  
  _ProductsCreatePageState createState() => _ProductsCreatePageState();
  
}

class _ProductsCreatePageState extends State<ProductsCreate> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController itemTypeController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();

  double calculatedSalesPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
        backgroundColor: Color(0xFF7abd87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              green_pastel,
              Light_green_pastel, 
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(44.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('Product Name', productNameController),
              _buildTextField('Product ID', productIdController),
              _buildTextField('Purchase Price', purchasePriceController),
              _buildTextField('Quantity', quantityController),
              _buildTextField('Item Type', itemTypeController),
              _buildTextField('Item Description', itemDescriptionController),
              SizedBox(height: 20),
              Text(
                'Sales Price: \$${calculatedSalesPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  _addProduct();
                },
                style: ElevatedButton.styleFrom(
                 backgroundColor: green_tea,
                 padding: EdgeInsets.all(20),
                ),
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (label == 'Purchase Price') {
            updateSalesPrice();
          }
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: turquoise,
        ),
      ),
    );
  }

  void updateSalesPrice() {
  double purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;
  setState(() {
    calculatedSalesPrice = purchasePrice * 0.4 + purchasePrice;
  });
}

  void _addProduct() async {
    String productName = productNameController.text;
    String productId = productIdController.text;
    double purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;
    double salesPrice = calculatedSalesPrice;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    String itemType = itemTypeController.text;
    String itemDescription = itemDescriptionController.text;

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'productName': productName.toLowerCase(),
        'productId': productId,
        'purchasePrice': purchasePrice,
        'salesPrice': salesPrice,
        'quantity': quantity,
        'itemType': itemType,
        'itemDescription': itemDescription,
      });

      productNameController.clear();
      productIdController.clear();
      purchasePriceController.clear();
      quantityController.clear();
      itemTypeController.clear();
      itemDescriptionController.clear();

      // You can add further logic here, e.g., show a success message
    } catch (e) {
      print('Error adding product: $e');
      // Handle error, show an error message, etc.
    }
  }
}
