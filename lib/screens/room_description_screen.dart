import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/image_slider.dart';
import 'package:hotel_reservation/data/services/firestore_service.dart';
import 'package:hotel_reservation/screens/reservation_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RoomDescriptionScreen extends StatefulWidget {
  final String roomId;
  const RoomDescriptionScreen({super.key, required this.roomId});

  @override
  State<RoomDescriptionScreen> createState() => _RoomDescriptionScreenState();
}

class _RoomDescriptionScreenState extends State<RoomDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FirestoreService().getRoomData(widget.roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: Pallete.backgroundColor,
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          final roomData = snapshot.data!;
          return Scaffold(
            backgroundColor: Pallete.backgroundColor,
            appBar: AppBar(
              title: Text(roomData['name'] ?? 'Room Details'),
            ),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageSlider(
                      imageDocumentStream: FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(widget.roomId)
                          .snapshots(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(roomData['name'], style: Pallete.headlineStyle),
                          const Divider(
                            thickness: 2,
                            height: 20,
                          ),
                          Row(children: [
                            const Text(
                              'Price for 1 night: ',
                              style: Pallete.textStyle,
                            ),
                            Text(
                                'ETB ${(roomData['price'].toDouble() * 74).toString()}',
                                style: Pallete.headlineStyle.copyWith(
                                    color: Pallete.gradient2, fontSize: 30)),
                          ]),
                          Row(children: [
                            const Text(
                              'Room Size: ',
                              style: Pallete.textStyle,
                            ),
                            Text('${roomData['size_(sq_ft)']} sq ft',
                                style: Pallete.headlineStyle
                                    .copyWith(fontSize: 20)),
                          ]),
                          Row(children: [
                            const Text(
                              'Bed: ',
                              style: Pallete.textStyle,
                            ),
                            Text('${roomData['bed']}',
                                style: Pallete.headlineStyle
                                    .copyWith(fontSize: 20)),
                          ]),
                          const Divider(
                            thickness: 2,
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Free Cancellation',
                                    style: Pallete.textStyle),
                                roomData['freeCancellation']
                                    ? const Icon(LineAwesomeIcons.check_circle,
                                        color: Colors.green)
                                    : const Icon(LineAwesomeIcons.times_circle,
                                        color: Colors.red),
                              ]),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Free Internet',
                                    style: Pallete.textStyle),
                                roomData['freeInternet']
                                    ? const Icon(LineAwesomeIcons.check_circle,
                                        color: Colors.green)
                                    : const Icon(LineAwesomeIcons.times_circle,
                                        color: Colors.red),
                              ]),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Free Breakfast',
                                    style: Pallete.textStyle),
                                roomData['freeBreakfast']
                                    ? const Icon(LineAwesomeIcons.check_circle,
                                        color: Colors.green)
                                    : const Icon(LineAwesomeIcons.times_circle,
                                        color: Colors.red),
                              ]),
                          const Divider(
                            thickness: 2,
                            height: 20,
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() =>
                                    ReservationScreen(roomId: widget.roomId));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 70.0),
                                  backgroundColor: Pallete.gradient2),
                              child: const Text('Reserve Room',
                                  style: TextStyle(
                                      fontSize: 18, color: Pallete.whiteColor)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Pallete.backgroundColor,
            body: Center(
                child: Text(
              'Room Data not found',
              style: Pallete.textStyle,
            )),
          );
        }
      },
    );
  }
}
