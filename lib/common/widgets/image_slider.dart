import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/screens/hotels_screen.dart';

class ImageSlider extends StatefulWidget {
  final Stream<QuerySnapshot>? imageStream;
  final Stream<DocumentSnapshot>? imageDocumentStream;
  final String? initialImageName;

  const ImageSlider({
    super.key,
    this.imageStream,
    this.imageDocumentStream,
    this.initialImageName,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentSlideIndex = 0;
  String imageName = '';
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    imageName = widget.initialImageName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageStream != null) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Pallete.blackColor, width: 1),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.imageStream!,
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index, ___) {
                      DocumentSnapshot sliderImage = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              HotelsScreen(selectedCity: sliderImage['name']));
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              sliderImage['image'],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Text(
                                sliderImage['name'] ?? imageName,
                                style: Pallete.headlineStyle
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      padEnds: false,
                      height: 250,
                      autoPlay: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          currentSlideIndex = index;
                          imageName = snapshot.data!.docs[index]['name'];
                        });
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Pallete.gradient2.withOpacity(0.7),
                ),
              );
            }
          },
        ),
      );
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: widget.imageDocumentStream,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var documentData = snapshot.data!.data() as Map<String, dynamic>;
            var imagesList = List.from(documentData['images']);
            return Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: imagesList.length,
                    itemBuilder: (_, index, ___) {
                      var imageUrl = imagesList[index];
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      padEnds: false,
                      height: 250,
                      autoPlay: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          currentSlideIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imagesList.length, (index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentSlideIndex == index
                              ? const Color.fromRGBO(0, 0, 0, 0.7)
                              : const Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  }),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Pallete.gradient2.withOpacity(0.7),
              ),
            );
          }
        },
      );
    }
  }
}
