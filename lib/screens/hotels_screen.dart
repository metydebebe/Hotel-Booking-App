import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/my_list_item.dart';

class HotelsScreen extends StatefulWidget {
  final String? selectedCity;
  const HotelsScreen({super.key, this.selectedCity});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  var _hotelStream =
      FirebaseFirestore.instance.collection('hotels').snapshots();
  String _selectedCity = '';

  @override
  void initState() {
    super.initState();
    if (widget.selectedCity != null) {
      _selectedCity = widget.selectedCity!;
      _hotelStream = _selectedCity.isNotEmpty
          ? FirebaseFirestore.instance
              .collection('hotels')
              .where('city', isEqualTo: _selectedCity)
              .snapshots()
          : FirebaseFirestore.instance.collection('hotels').snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _selectedSortOption;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        title: const Center(child: Text('Hotels')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Filter Hotels By City',
              style: Pallete.headlineStyle2,
            ),
            const SizedBox(height: 10),
            SizedBox(
              // Adjust the height as needed
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('cities').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text('No cities available');
                  }
                  final cities = snapshot.data!.docs
                      .map((doc) => doc['name'] as String)
                      .toList();

                  return Wrap(
                    spacing: 12.0, // Gap between adjacent chips
                    runSpacing: 3.0, // Gap between lines
                    children: List<Widget>.generate(
                      cities.length,
                      (int index) {
                        return ChoiceChip(
                          label: Text(cities[index]),
                          selected: _selectedCity == cities[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCity = selected ? cities[index] : '';
                              // Update the stream only if a city is selected, otherwise show all hotels
                              _hotelStream = selected
                                  ? FirebaseFirestore.instance
                                      .collection('hotels')
                                      .where('city', isEqualTo: _selectedCity)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection('hotels')
                                      .snapshots();
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort By', style: Pallete.headlineStyle2),
                  DropdownButton<String>(
                    value: _selectedSortOption,
                    // ignore: unnecessary_null_comparison
                    hint: _selectedSortOption != null
                        ? Text(_selectedSortOption
                            .replaceAll('_', ' ')
                            .capitalize())
                        : const Text('Select an option'),
                    items: const [
                      DropdownMenuItem(
                        value: 'rating_desc',
                        child: Text('Rating - Highest First'),
                      ),
                      DropdownMenuItem(
                        value: 'rating_asc',
                        child: Text('Rating - Lowest First'),
                      ),
                      DropdownMenuItem(
                        value: 'stars_desc',
                        child: Text('Stars - Highest First'),
                      ),
                      DropdownMenuItem(
                        value: 'stars_asc',
                        child: Text('Stars - Lowest First'),
                      ),
                      DropdownMenuItem(
                        value: 'price_desc',
                        child: Text('Price - Highest First'),
                      ),
                      DropdownMenuItem(
                        value: 'price_asc',
                        child: Text('Price - Lowest First'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSortOption = value;
                        // ignore: unnecessary_null_comparison
                        if (_selectedCity != null && _selectedCity.isNotEmpty) {
                          if (value == 'rating_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('rating', descending: true)
                                .snapshots();
                          } else if (value == 'rating_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('rating', descending: false)
                                .snapshots();
                          } else if (value == 'stars_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('stars', descending: true)
                                .snapshots();
                          } else if (value == 'stars_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('stars', descending: false)
                                .snapshots();
                          } else if (value == 'price_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('price', descending: true)
                                .snapshots();
                          } else if (value == 'price_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .where('city', isEqualTo: _selectedCity)
                                .orderBy('price', descending: false)
                                .snapshots();
                          }
                          // Add conditions for 'Stars' and 'Price' within the selected city
                        } else {
                          // Apply the sorting without city filter
                          if (value == 'rating_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('rating', descending: true)
                                .snapshots();
                          } else if (value == 'rating_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('rating', descending: false)
                                .snapshots();
                          } else if (value == 'stars_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('stars', descending: true)
                                .snapshots();
                          } else if (value == 'stars_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('stars', descending: false)
                                .snapshots();
                          } else if (value == 'price_desc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('price', descending: true)
                                .snapshots();
                          } else if (value == 'price_asc') {
                            _hotelStream = FirebaseFirestore.instance
                                .collection('hotels')
                                .orderBy('price', descending: false)
                                .snapshots();
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: _hotelStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Connection Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Pallete.gradient2.withOpacity(0.7)),
                  );
                }
                var docs = snapshot.data!.docs;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return MyListItem(
                        hotelId: docs[index].id,
                        name: docs[index]['name'],
                        city: docs[index]['city'],
                        imageURL: docs[index]['images'][0],
                        stars: docs[index]['stars'],
                        rating: docs[index]['rating'],
                        address: docs[index]['address'],
                        price: docs[index]['price'],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
