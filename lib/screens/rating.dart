import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDisplay extends StatelessWidget {
  final double rating; // Rating value from the backend

  const RatingDisplay({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20,
      direction: Axis.horizontal,
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// class RatingDisplay extends StatelessWidget {
//   final double rating; // Rating value from the backend
//
//   const RatingDisplay({super.key, required this.rating});
//
//   @override
//   Widget build(BuildContext context) {
//     return RatingBar.builder(
//       initialRating: rating,
//       minRating: 1,
//       direction: Axis.horizontal,
//       allowHalfRating: true,
//       itemCount: 5,
//       itemSize: 20,
//       itemBuilder: (context, _) => const Icon(
//         Icons.star,
//         size: 5,
//         color: Colors.amber,
//       ),
//       onRatingUpdate: (rating) {
//         // Handle rating update if needed
//       },
//     );
//   }
// }
