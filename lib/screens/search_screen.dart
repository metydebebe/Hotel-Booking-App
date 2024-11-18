import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/screens/hotel_description_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.backgroundColor,
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search for hotels...',
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Text('No data available');
            }
            final results = snapshot.data!.docs
                .where((DocumentSnapshot a) => a['name']
                    .toString()
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
                .toList();

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        HotelDescriptionScreen(hotelId: results[index].id));
                  },
                  child: ListTile(
                    title: Text(results[index]['name']),
                    // Add other hotel details here
                  ),
                );
              },
            );
          },
        ));
  }
}
