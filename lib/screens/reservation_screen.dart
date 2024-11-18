import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/my_text_field.dart';
import 'package:hotel_reservation/data/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class ReservationScreen extends StatefulWidget {
  final String roomId;

  const ReservationScreen({super.key, required this.roomId});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final guestController = ValueNotifier<int>(1);
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  int numberOfNights = 1;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDateController.addListener(calculateAndSetNights);
    endDateController.addListener(calculateAndSetNights);
  }

  @override
  void dispose() {
    startDateController.removeListener(calculateAndSetNights);
    endDateController.removeListener(calculateAndSetNights);
    super.dispose();
  }

  void calculateAndSetNights() {
    if (startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty) {
      DateTime startDate =
          DateFormat('yyyy-MM-dd').parse(startDateController.text);
      DateTime endDate = DateFormat('yyyy-MM-dd').parse(endDateController.text);
      if (endDate.isAfter(startDate)) {
        setState(() {
          numberOfNights = endDate.difference(startDate).inDays;
        });
      } else {
        setState(() {
          numberOfNights = 0;
        });
      }
    } else {
      setState(() {
        numberOfNights = 1;
      });
    }
  }

  int _type = 1;
  String paidWith = 'Amazon Pay';
  void _handleRatio(Object? e) => setState(() {
        _type = e as int;
        if (_type == 1) {
          paidWith = 'Amazon Pay';
        } else if (_type == 2) {
          paidWith = 'Credit Card';
        } else if (_type == 3) {
          paidWith = 'Paypal';
        }
      });

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
                title: Text('Reservation for Room ${roomData['name']}'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Center(
                          child: Text('Reservation Form',
                              style: Pallete.headlineStyle)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 2, color: Pallete.gradient2),
                            color: const Color.fromARGB(255, 166, 166, 179),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: ListTile(
                          leading: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(roomData['images'][0]),
                              ),
                            ),
                          ),
                          title: Text(roomData['name']),
                          subtitle: Text(
                              'Price: ETB ${(roomData['price'].toDouble() * 74).toString()} / night'),
                          // Add other room details here
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                          controller: nameController,
                          hintText: 'Full Name',
                          obscureText: false),
                      const SizedBox(height: 15),
                      MyTextField(
                          controller: emailController,
                          hintText: 'Email (${user!.email!})',
                          obscureText: false),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Number of Guests',
                                style: Pallete.textStyle),
                            DropdownButton<int>(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(5.0),
                              value: guestController.value,
                              items: const [
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('1 Guest'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('2 Guests'),
                                ),
                              ],
                              onChanged: (int? newValue) {
                                setState(() {
                                  guestController.value = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Start Date'),
                            ),
                            TextField(
                              controller: startDateController,
                              decoration: const InputDecoration(
                                hintText: 'Start Date',
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDate(context, startDateController);
                              },
                            ),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('End Date'),
                            ),
                            TextField(
                              controller: endDateController,
                              decoration: const InputDecoration(
                                hintText: 'End Date',
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDate(context, endDateController);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        thickness: 2,
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Payment Method',
                        style: Pallete.textStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: _type == 1
                              ? Border.all(width: 1, color: Pallete.gradient2)
                              : Border.all(
                                  width: 0.3, color: Pallete.blackColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Pallete.whiteColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _type,
                                      onChanged: _handleRatio,
                                      activeColor: Pallete.gradient2,
                                    ),
                                    Text("Amazon Pay",
                                        style: _type == 1
                                            ? Pallete.textStyle.copyWith(
                                                color: Pallete.blackColor)
                                            : Pallete.textStyle.copyWith(
                                                color: const Color.fromARGB(
                                                    255, 122, 122, 122),
                                              )),
                                  ],
                                ),
                                Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3CmlWROUwQtzmEPMYwx0tV97zb-tfjucQSjV0uB_Esg&s',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: _type == 2
                              ? Border.all(width: 1, color: Pallete.gradient2)
                              : Border.all(
                                  width: 0.3, color: Pallete.blackColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Pallete.whiteColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _type,
                                      onChanged: _handleRatio,
                                      activeColor: Pallete.gradient2,
                                    ),
                                    Text("Credit Card",
                                        style: _type == 2
                                            ? Pallete.textStyle.copyWith(
                                                color: Pallete.blackColor)
                                            : Pallete.textStyle.copyWith(
                                                color: const Color.fromARGB(
                                                    255, 122, 122, 122),
                                              )),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/visa.jpg',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: _type == 3
                              ? Border.all(width: 1, color: Pallete.gradient2)
                              : Border.all(
                                  width: 0.3, color: Pallete.blackColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Pallete.whiteColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 3,
                                      groupValue: _type,
                                      onChanged: _handleRatio,
                                      activeColor: Pallete.gradient2,
                                    ),
                                    Text("PayPal",
                                        style: _type == 2
                                            ? Pallete.textStyle.copyWith(
                                                color: Pallete.blackColor)
                                            : Pallete.textStyle.copyWith(
                                                color: const Color.fromARGB(
                                                    255, 122, 122, 122),
                                              )),
                                  ],
                                ),
                                Image.network(
                                  'https://i.pcmag.com/imagery/reviews/068BjcjwBw0snwHIq0KNo5m-15.fit_scale.size_760x427.v1602794215.png',
                                  width: 80,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Payment', style: Pallete.textStyle),
                          Text(
                              'ETB ${(roomData['price'].toDouble() * 74 * numberOfNights).toString()}',
                              style: Pallete.headlineStyle2)
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text != '' &&
                              emailController.text != '' &&
                              startDateController.text != '' &&
                              endDateController.text != '') {
                            CollectionReference reservation = FirebaseFirestore
                                .instance
                                .collection('reservations');
                            reservation.add({
                              'user_id': user!.uid,
                              'room_id': widget.roomId,
                              'reservation_time': DateTime.now().toString(),
                              'number_of_nights': numberOfNights.toString(),
                              'name': nameController.text,
                              'email': emailController.text,
                              'start_date': startDateController.text,
                              'end_date': endDateController.text,
                              'paid_with': paidWith
                            });
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: 'Success',
                                text:
                                    'Your Reservation has been successfully booked',
                                confirmBtnColor: Pallete.gradient2);
                          } else {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Error',
                                text: 'Please fill in all the fields',
                                confirmBtnColor: Pallete.gradient2);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 70.0),
                            backgroundColor: Pallete.gradient2),
                        child: Text(
                            'Reserve (ETB ${(roomData['price'].toDouble() * 74 * numberOfNights).toString()})',
                            style: const TextStyle(
                                fontSize: 18, color: Pallete.whiteColor)),
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                ),
              ));
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
