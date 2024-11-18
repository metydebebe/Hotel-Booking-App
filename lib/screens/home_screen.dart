import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/image_slider.dart';
import 'package:hotel_reservation/screens/search_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreetingMessage(),
                          style: Pallete.headlineStyle3,
                        ),
                        const SizedBox(height: 5),
                        const Text('Book Reservations',
                            style: Pallete.headlineStyle),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Pallete.gradient2.withOpacity(0.7)),
                      child: IconButton(
                        icon: const Icon(LineAwesomeIcons.bell),
                        onPressed: () =>
                            Get.to(() => const NotificationScreen()),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => Get.to(() => SearchScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Pallete.whiteColor),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Pallete.greyColor,
                        ),
                        Text(
                          'Search',
                          style: Pallete.headlineStyle4,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Popular Destinations',
                  style: Pallete.headlineStyle,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                ImageSlider(
                  imageStream: FirebaseFirestore.instance
                      .collection('cities')
                      .snapshots(),
                  initialImageName: 'Initial Image Name',
                ),
                const SizedBox(height: 20),
                const Text(
                  '',
                  style: Pallete.headlineStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getGreetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: const Text('Notifications'),
      ),
      body: Center(
          child: Image.network('https://i.imgflip.com/43ods0.jpg', width: 80)),
    );
  }
}
