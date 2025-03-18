import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final Random random = Random();
  int selectedCategoryIndex = 0;
  Map<int, int> itemQuantities = {};

  final List<String> categories = [
    "Milk Products",
    "Cheese & Butter",
    "Yogurt & Curd",
    "Plant-Based Milk",
    "Fresh Cream"
  ];

  final Map<String, List<Item>> categoryItems = {};

  @override
  void initState() {
    super.initState();
    for (var category in categories) {
      categoryItems[category] =
          List.generate(5, (index) => _generateRandomItem(index));
    }
  }

  Item _generateRandomItem(int index) {
    List<String> itemNames = [
      "Milk Pack",
      "Cheese",
      "Yogurt",
      "Butter",
      "Paneer",
      "Almond Milk",
      "Oat Milk",
      "Fresh Cream",
      "Cottage Cheese",
      "Curd"
    ];
    return Item(
      id: index,
      name: itemNames[random.nextInt(itemNames.length)],
      price: (random.nextDouble() * 50 + 10).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selectedCategoryIndex == index
                          ? Colors.blue.shade100
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.droplet,
                            size: 30, color: Colors.blue),
                        const SizedBox(height: 5),
                        Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedCategoryIndex == index
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount:
                  categoryItems[categories[selectedCategoryIndex]]!.length,
              itemBuilder: (context, index) {
                final item =
                    categoryItems[categories[selectedCategoryIndex]]![index];
                int qty = itemQuantities[item.id] ?? 0;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 6)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.droplet,
                          size: 40, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("₹${item.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      qty > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      if (itemQuantities[item.id]! > 0) {
                                        itemQuantities[item.id] =
                                            itemQuantities[item.id]! - 1;
                                      }
                                      if (itemQuantities[item.id] == 0) {
                                        itemQuantities.remove(item.id);
                                      }
                                    });
                                  },
                                ),
                                Text("$qty",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      itemQuantities[item.id] =
                                          (itemQuantities[item.id] ?? 0) + 1;
                                    });
                                  },
                                ),
                              ],
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  itemQuantities[item.id] = 1;
                                });
                              },
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ListView(
                children: [
                  ...itemQuantities.entries.map((entry) {
                    final item = categoryItems.values
                        .expand((list) => list)
                        .firstWhere((i) => i.id == entry.key);
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text("Qty: ${entry.value}"),
                      trailing: Text(
                          "₹${(item.price * entry.value).toStringAsFixed(2)}"),
                    );
                  }),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen(
                                    cartItems: [],
                                  )));
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              );
            },
          );
        },
        child: Badge(
          label: Text("${itemQuantities.keys.length}"),
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}

class Item {
  final int id;
  final String name;
  final double price;

  Item({required this.id, required this.name, required this.price});
}

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    int totalItems = cartItems.length;
    int totalQty = cartItems.fold(0, (sum, item) => sum + item.quantity);
    double totalValue =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "Qty: ${item.quantity} | Price: ₹${item.price.toStringAsFixed(2)}"),
                      trailing: Text(
                          "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Total Items", totalItems.toString()),
                  _buildSummaryRow("Total Quantity", totalQty.toString()),
                  _buildSummaryRow(
                      "Total Value", "₹${totalValue.toStringAsFixed(2)}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentScreen(totalAmount: totalValue)),
                      );
                    },
                    child: const Text("Proceed to Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const SizedBox(height: 20),
            const Text("Select Payment Method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPaymentOption(Icons.money, "Cash"),
            _buildPaymentOption(Icons.credit_card, "Card"),
            _buildPaymentOption(Icons.qr_code, "UPI"),
            _buildPaymentOption(Icons.local_offer, "Other"),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onTap: () {},
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}
