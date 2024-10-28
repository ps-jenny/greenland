import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenland/models/colors.dart';

abstract class Product {
  String get productName;
  double get salesPrice;
  int get quantity;
  String get itemDescription;
  List<String> get searchKeywords;
}

class FirestoreProduct implements Product {
  final String productName;
  final double salesPrice;
  final int quantity;
  final String itemDescription;
  final List<String> searchKeywords;

  FirestoreProduct({
    required this.productName,
    required this.salesPrice,
    required this.quantity,
    required this.itemDescription,
    required this.searchKeywords,
  });
}

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  late TextEditingController searchController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery(String searchQuery) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    if (searchQuery.isEmpty) {
      return products.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    } else {
      return products
          .where('productName', isGreaterThanOrEqualTo: searchQuery)
          .where('productName', isLessThan: searchQuery + 'z')
          .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    }
  }

  void _performSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _navigateToEditProduct(String? documentId, BuildContext context) {
    if (documentId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsEdit(documentId: documentId),
        ),
      );
    } else {
      print('Document ID is null');
    }
  }

  void _deleteProduct(String? documentId) async {
    if (documentId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(documentId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error deleting product: $e');
      }
    } else {
      print('Document ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
        backgroundColor: green_tea,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search product by name...',
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _buildQuery(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  var products = snapshot.data?.docs;

                  return ListView.builder(
                    itemCount: products?.length,
                    itemBuilder: (context, index) {
                      var product =
                          products?[index].data() as Map<String, dynamic>?;

                      if (product != null) {
                        return ProductTile(
                          product: FirestoreProduct(
                            productName: product['productName'],
                            salesPrice: product['salesPrice'],
                            quantity: product['quantity'],
                            itemDescription: product['itemDescription'],
                            searchKeywords:
                                List<String>.from(product['searchKeywords'] ?? []),
                          ),
                          onEditPressed: () {
                            _navigateToEditProduct(products?[index].id, context);
                          },
                          onDeletePressed: () {
                            _deleteProduct(products?[index].id);
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  ProductTile({
    required this.product,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      color: seafoam,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          product.productName,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Sales Price: \$${product.salesPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: pickle,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Quantity: ${product.quantity}'),
            Text(
              'Description: ${product.itemDescription}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onEditPressed,
                  child: Text('Edit'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: onDeletePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsEdit extends StatefulWidget {
  final String documentId;

  const ProductsEdit({Key? key, required this.documentId}) : super(key: key);

  @override
  _ProductsEditState createState() => _ProductsEditState();
}

class _ProductsEditState extends State<ProductsEdit> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController salesPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController itemTypeController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  void _fetchProductDetails() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.documentId)
          .get();

      if (productSnapshot.exists) {
        Map<String, dynamic>? productData =
            productSnapshot.data() as Map<String, dynamic>?;

        if (productData != null) {
          productNameController.text = productData['productName'] ?? '';
          productIdController.text = productData['productId'] ?? '';
          purchasePriceController.text = productData['purchasePrice'].toString();
          salesPriceController.text = productData['salesPrice'].toString();
          quantityController.text = productData['quantity'].toString();
          itemTypeController.text = productData['itemType'] ?? '';
          itemDescriptionController.text = productData['itemDescription'] ?? '';
        } else {
          print('Product data is null for documentId: ${widget.documentId}');
        }
      } else {
        print('Product not found for documentId: ${widget.documentId}');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  void _saveProductChanges() async {
    try {
      String updatedProductName = productNameController.text;
      String updatedProductId = productIdController.text;
      double updatedPurchasePrice = double.parse(purchasePriceController.text);
      double updatedSalesPrice = double.parse(salesPriceController.text);
      int updatedQuantity = int.parse(quantityController.text);
      String updatedItemType = itemTypeController.text;
      String updatedItemDescription = itemDescriptionController.text;

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.documentId)
          .update({
        'productName': updatedProductName,
        'productId': updatedProductId,
        'purchasePrice': updatedPurchasePrice,
        'salesPrice': updatedSalesPrice,
        'quantity': updatedQuantity,
        'itemType': updatedItemType,
        'itemDescription': updatedItemDescription,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: green_tea,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Product Name', productNameController),
            _buildTextField('Product ID', productIdController),
            _buildTextField('Purchase Price', purchasePriceController),
            _buildTextField('Sales Price', salesPriceController),
            _buildTextField('Quantity', quantityController),
            _buildTextField('Item Type', itemTypeController),
            _buildTextField('Item Description', itemDescriptionController),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveProductChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: green_tea,
                padding: EdgeInsets.all(20),
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: turquoise,
        ),
      ),
    );
  }
}
