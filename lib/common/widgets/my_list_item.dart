import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/screens/hotel_description_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MyListItem extends StatelessWidget {
  final String hotelId;
  final String imageURL;
  final String name;
  final String? address;
  final String? city;
  final double? rating;
  final int? stars;
  final int price;

  const MyListItem(
      {super.key,
      required this.hotelId,
      required this.imageURL,
      required this.name,
      this.address,
      this.city,
      this.rating,
      required this.price,
      this.stars});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => HotelDescriptionScreen(hotelId: hotelId));
      },
      child: Card(
        elevation: 10.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageURL),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Pallete.headlineStyle2,
                        ),
                        if (city != null)
                          Text(
                            '(${city!}, Ethiopia)',
                            style: Pallete.headlineStyle4,
                          ),
                        if (stars != null)
                          RatingBar.builder(
                              initialRating: stars!.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              ignoreGestures: true,
                              itemSize: 25,
                              itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Pallete.gradient2,
                                  ),
                              onRatingUpdate: (rating) {}),
                        if (rating != null)
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
                                    rating!.toString(),
                                    style: Pallete.headlineStyle2,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  getRatingString(rating!),
                                  style: Pallete.textStyle,
                                ),
                              )
                            ],
                          ),
                        if (address != null)
                          Row(
                            children: [
                              const Icon(LineAwesomeIcons.map_marker),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  address!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Average price for 1 night',
                            style: TextStyle(fontSize: 9)),
                        Text(
                          'ETB ${(price.toDouble() * 74).toString()}',
                          style: Pallete.headlineStyle2,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
