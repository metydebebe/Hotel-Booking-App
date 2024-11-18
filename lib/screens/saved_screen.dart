import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getRoomData(String roomId) async {
    final roomSnapshot =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    return roomSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reservations')
          .where('user_id', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            backgroundColor: Pallete.backgroundColor,
            appBar: AppBar(title: const Center(child: Text('Reservations'))),
            body: const Center(child: Text('No reservations found')),
          );
        }

        final reservations = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(title: const Center(child: Text('Reservations'))),
          backgroundColor: Pallete.backgroundColor,
          body: ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final roomId = reservation['room_id'];
              String reservationTimeString = reservation['reservation_time'];
              DateTime reservationTime = DateTime.parse(reservationTimeString);

              String formattedDate =
                  DateFormat('MMMM d, yyyy').format(reservationTime);
              Text(formattedDate);
              String formattedTime =
                  DateFormat('HH:mm:ss').format(reservationTime);
              Text(formattedTime);
              String formattedStartDate = DateFormat('MMMM d, yyyy')
                  .format(DateTime.parse(reservation['start_date']));
              String formattedEndDate = DateFormat('MMMM d, yyyy')
                  .format(DateTime.parse(reservation['end_date']));

              return FutureBuilder<Map<String, dynamic>>(
                future: getRoomData(roomId),
                builder: (context, roomSnapshot) {
                  if (roomSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Pallete.gradient2));
                  }
                  if (!roomSnapshot.hasData) {
                    return const Center(
                        child: Text(
                      'No Reservations Found',
                      style: Pallete.headlineStyle,
                    ));
                  }
                  final roomData = roomSnapshot.data!;

                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Pallete.whiteColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(roomData['images'][0]),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  roomData['name'],
                                  style: Pallete.textStyle,
                                ),
                                subtitle: Text(
                                  'Paid Amount: ETB ${(roomData['price'] * 74 * double.parse(reservation['number_of_nights'])).toString()}',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From $formattedStartDate to $formattedEndDate (${reservation['number_of_nights']} nights)',
                                      style: Pallete.textStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Reserved By: ${reservation['name']}',
                                        style: Pallete.textStyle),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Reserved On: $formattedDate at $formattedTime',
                                        style: Pallete.textStyle),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          QuickAlert.show(
                                              context: context,
                                              title: 'Are you sure?',
                                              text:
                                                  'Do you want to cancel your reservation? \n ETB ${(roomData['price'] * 74 * double.parse(reservation['number_of_nights'])).toString()} will be returned',
                                              type: QuickAlertType.confirm,
                                              confirmBtnText: 'Yes',
                                              cancelBtnText: 'No',
                                              confirmBtnColor: Colors.green,
                                              onConfirmBtnTap: () {
                                                Navigator.of(context).pop();
                                                FirebaseFirestore.instance
                                                    .collection('reservations')
                                                    .doc(reservation.id)
                                                    .delete()
                                                    .then((_) {})
                                                    .catchError((error) {
                                                  QuickAlert.show(
                                                      context: context,
                                                      type:
                                                          QuickAlertType.error,
                                                      title: 'Error',
                                                      text:
                                                          'Reservation could not be cancelled. Please try again.');
                                                });
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18.0,
                                                horizontal: 30.0),
                                            backgroundColor: Colors.red),
                                        child: const Text('Cancel Reservation',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Pallete.whiteColor)),
                                      ),
                                    ),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
