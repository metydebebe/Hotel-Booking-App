import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/image_slider.dart';
import 'package:hotel_reservation/data/services/firestore_service.dart';
import 'package:hotel_reservation/screens/room_description_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HotelDescriptionScreen extends StatefulWidget {
  final String hotelId;

  const HotelDescriptionScreen({super.key, required this.hotelId});

  @override
  State<HotelDescriptionScreen> createState() => _HotelDescriptionScreenState();
}

class _HotelDescriptionScreenState extends State<HotelDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FirestoreService().getHotelData(widget.hotelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: Pallete.backgroundColor,
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          final hotelData = snapshot.data!;
          // Use hotelData to display hotel details
          // Example: hotelData['name'], hotelData['address'], etc.
          return Scaffold(
            backgroundColor: Pallete.backgroundColor,
            appBar: AppBar(
              title: Text(hotelData['name'] ?? 'Hotel Details'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlider(
                    imageDocumentStream: FirebaseFirestore.instance
                        .collection('hotels')
                        .doc(widget.hotelId)
                        .snapshots(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotelData['name'], style: Pallete.headlineStyle),
                        RatingBar.builder(
                            initialRating: hotelData['stars']!.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            ignoreGestures: true,
                            itemSize: 25,
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Pallete.gradient2,
                                ),
                            onRatingUpdate: (rating) {}),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Pallete.gradient2.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Text(
                                  hotelData['rating']!.toString(),
                                  style: Pallete.headlineStyle2,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                getRatingString(hotelData['rating']!),
                                style: Pallete.textStyle,
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          height: 20,
                        ),
                        const Text(
                          'Overview',
                          style: Pallete.headlineStyle2,
                        ),
                        const SizedBox(height: 10),
                        Text(hotelData['description'],
                            style: Pallete.textStyle),
                        const Divider(
                          thickness: 2,
                          height: 20,
                        ),
                        const Text(
                          'Location',
                          style: Pallete.headlineStyle2,
                        ),
                        const SizedBox(height: 10),
                        Text(hotelData['address'], style: Pallete.textStyle),
                        const Divider(
                          thickness: 2,
                          height: 20,
                        ),
                        const Text(
                          'Rooms',
                          style: Pallete.headlineStyle2,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('rooms')
                              .where('hotelRef',
                                  isEqualTo: FirebaseFirestore.instance
                                      .collection('hotels')
                                      .doc(widget.hotelId))
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final rooms = snapshot.data?.docs ?? [];
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rooms.length,
                              itemBuilder: (context, index) {
                                var room =
                                    rooms[index].data() as Map<String, dynamic>;
                                var roomId = rooms[index].id;
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        RoomDescriptionScreen(roomId: roomId));
                                  },
                                  child: ListTile(
                                    leading: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(room['images'][0]),
                                        ),
                                      ),
                                    ),
                                    title: Text(room['name']),
                                    subtitle: Text(
                                        'Price: ETB ${(room['price'].toDouble() * 74).toString()} / night'),
                                    trailing: const Icon(
                                      LineAwesomeIcons.angle_right,
                                      size: 18.0,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Pallete.backgroundColor,
            body: Center(
                child: Text(
              'Hotel Data not found',
              style: Pallete.textStyle,
            )),
          );
        }
      },
    );
  }

  String getRatingString(double? rating) {
    if (rating != null) {
      if (rating >= 9.0 && rating <= 10.0) {
        return 'Fabulous';
      } else if (rating >= 8.0 && rating < 9.0) {
        return 'Very Good';
      } else if (rating >= 6.0 && rating < 8.0) {
        return 'Good';
      } else if (rating >= 4.0 && rating < 6.0) {
        return 'Average'; // or any other default return string
      } else {
        return 'Bad';
      }
    } else {
      return 'Rating not available'; // Ensure a non-nullable String is returned
    }
  }
}
