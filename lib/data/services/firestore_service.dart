import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference hotelsCollection =
      FirebaseFirestore.instance.collection('hotels');
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('rooms');

  Future<Map<String, dynamic>?> getHotelData(String hotelId) async {
    try {
      final hotelDoc = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .get();
      if (hotelDoc.exists) {
        // Cast the result to Map<String, dynamic>
        return hotelDoc.data();
      }
    } catch (e) {
      print('Error fetching hotel data: $e');
    }
    return null; // Return null if hotel data retrieval fails
  }

  Future<Map<String, dynamic>?> getRoomData(String roomId) async {
    try {
      final roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();
      if (roomDoc.exists) {
        // Cast the result to Map<String, dynamic>
        return roomDoc.data();
      }
    } catch (e) {
      print('Error fetching hotel data: $e');
    }
    return null; // Return null if hotel data retrieval fails
  }
}
