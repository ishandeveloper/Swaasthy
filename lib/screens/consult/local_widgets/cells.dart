import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/index.dart';
import '../../../utils/index.dart';
import 'package:flutter/material.dart';

class HDCell extends StatelessWidget {
  final Doctor doctor;
  final Function onTap;

  const HDCell({
    Key key,
    @required this.doctor,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 283,
        height: 199,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: CodeRedColors.primary2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 32,
              left: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dr.',
                    style: TextStyle(
                      fontFamily: 'ProductSans',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontFamily: 'ProductSans',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    doctor.type + ' Specialist',
                    style: const TextStyle(
                      fontFamily: 'ProductSans',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 77,
                height: 54,
                decoration: const BoxDecoration(
                  color: CodeRedColors.primary2Accent,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(32)),
                ),
                child: const Icon(
                  CustomIcons.arrow_right,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 0,
              child: SizedBox(
                width: 120,
                child: Hero(
                  tag: doctor.uid,
                  child: Image(
                    filterQuality: FilterQuality.high,
                    image: CachedNetworkImageProvider(doctor.image),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DoctorCategoryCell extends StatelessWidget {
//   final DoctorCategory category;

//   const DoctorCategoryCell({Key key, @required this.category})
//       : super(key: key);

//   /// **********************************************
//   /// LIFE CYCLE METHODS
//   /// **********************************************

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       clipBehavior: Clip.hardEdge,
//       padding: const .only(top: 14),
//       decoration: BoxDecoration(
//         color: Color(0xFFEDFDFA),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   category.icon,
//                   size: 24,
//                   color: Color(0xFF00C6AD),
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   category.title,
//                   style: TextStyle(
//                     fontFamily: 'ProductSans',
//                     color: Color(0xFF010101),
//                     fontWeight: FontWeight.w700,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Stack(
//             children: [
//               Container(
//                 height: 30,
//                 width: 72,
//                 decoration: BoxDecoration(
//                     color: Color(0xFFE1F7F4),
//                     borderRadius:
//                         BorderRadius.only(topRight: Radius.circular(10))),
//               ),
//               Positioned(
//                 left: 16,
//                 top: 8,
//                 bottom: 8,
//                 child: Text(
//                   'Specialist',
//                   style: TextStyle(
//                     fontFamily: 'ProductSans',
//                     color: Color(0xFF696969),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class TopRatedDoctorCell extends StatelessWidget {
  final Doctor doctor;

  const TopRatedDoctorCell({
    Key key,
    @required this.doctor,
  }) : super(key: key);

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            color: const Color(0XFF404B63).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageSection(),
          const SizedBox(width: 16),
          _detailsSection(),
        ],
      ),
    );
  }

  /// Image Section
  Widget _imageSection() {
    return Hero(
      tag: doctor.uid,
      child: Container(
        height: 77,
        width: 90,
        decoration: BoxDecoration(
          color: CodeRedColors.primary2,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(doctor.image),
          ),
        ),
      ),
    );
  }

  /// Details Section
  Column _detailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              doctor.rating.toString(),
              style: const TextStyle(
                color: Color(0xFF929BB0),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              CustomIcons.star,
              color: Color(0xFFFFBB23),
              size: 14,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          doctor.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          doctor.type + ' Specialist',
          style: const TextStyle(
            color: Color(0xFF929BB0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class DetailCell extends StatelessWidget {
  final String title;
  final String subTitle;

  const DetailCell({
    Key key,
    @required this.title,
    @required this.subTitle,
  }) : super(key: key);

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFEDFDFA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 61,
              height: 31,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F7F4),
                borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF00C6AD),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color(0xFF696969),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
