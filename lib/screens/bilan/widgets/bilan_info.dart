import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_app/constants/colors.dart';
import 'package:hospital_app/constants/icons.dart';

class BilanInfo extends StatelessWidget {
  const BilanInfo({
    super.key,
    required this.mediaQuery,
    required this.index,
    required this.title,
    required this.date,
  });

  final MediaQueryData mediaQuery;
  final int index;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Bilan $index",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            height: mediaQuery.size.height * 0.07,
            decoration: const BoxDecoration(
                color: lightPink,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.add_box_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Ajouter",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: grey,
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(calendarIcon),
                  SizedBox(
                    width: mediaQuery.size.width * 0.02,
                  ),
                  Text(date)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
