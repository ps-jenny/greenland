import 'package:flutter/material.dart';
import 'ProductsCreate.dart';
import 'ProductSearch.dart';
import 'models/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> products;

  @override
  void initState() {
    super.initState();
    products = _getProducts();
  }

  Future<List<Map<String, dynamic>>> _getProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    List<Map<String, dynamic>> productList = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      productList.add(document.data() as Map<String, dynamic>);
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Check Our Products!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildSquareButton(
                      'Add New Products',
                      green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductsCreate()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildSquareButton2(
                      'Manage Products',
                      blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductSearch()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: products,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loading products');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No products available');
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> product = snapshot.data![index];
                          return _buildProductCard(product);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: seafoam,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/placeholder_image.jpg'), // Replace with your product image path
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['productName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              Text('Price: \$${product['salesPrice']}'),
              SizedBox(height: 5),
              Text('Quantity: ${product['quantity']}'),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildSquareButton(String text, color, VoidCallback onPressed) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton2(String text, color, VoidCallback onPressed) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
