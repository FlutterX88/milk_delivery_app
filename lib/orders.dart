import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const MilkDeliveryApp());
}

class MilkDeliveryApp extends StatelessWidget {
  const MilkDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Milk Delivery",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(LucideIcons.shoppingCart, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            _buildSectionTitle("Categories"),
            _buildCategoryList(),
            const SizedBox(height: 16),
            _buildSectionTitle("Today's Offers"),
            _buildOfferList(),
            const SizedBox(height: 16),
            _buildSectionTitle("Items"),
            _buildItemList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return CarouselSlider(
      options:
          CarouselOptions(height: 180, autoPlay: true, enlargeCenterPage: true),
      items: [
        "assets/images/banner.jpeg",
        "assets/images/banner.jpeg",
        "assets/images/banner.jpeg"
      ].map((image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue));
  }

  Widget _buildCategoryList() {
    List<String> categories = ["Milk", "Cheese", "Yogurt", "Butter", "Paneer"];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: Center(
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildOfferList() {
    return _buildHorizontalList();
  }

  Widget _buildItemList() {
    return _buildHorizontalList();
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildItemCard();
        },
      ),
    );
  }

  Widget _buildItemCard() {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.droplet, size: 40, color: Colors.blue),
          SizedBox(height: 8),
          Text("Milk Pack",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("₹50.00",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
