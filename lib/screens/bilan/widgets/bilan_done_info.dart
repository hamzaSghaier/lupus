import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/constants/icons.dart';
import 'package:tulup/screens/bilan/models/bilan_model.dart';
import 'package:tulup/screens/bilan/widgets/bilan_info.dart';

class BilanDoneInfo extends StatefulWidget {
  const BilanDoneInfo({
    super.key,
    required this.mediaQuery,
    required this.index,
    required this.bilan,
  });

  final MediaQueryData mediaQuery;
  final int index;
  final BilanModel bilan;
  @override
  State<BilanDoneInfo> createState() => _BilanDoneInfoState();
}

class _BilanDoneInfoState extends State<BilanDoneInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30),
            border: Border.all(
                color: Colors.grey.withAlpha(30),
                style: BorderStyle.solid,
                width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Bilan ${widget.index}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            */
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              height: widget.mediaQuery.size.height * 0.07,
              decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.bilan.type ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16)),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BilanImagesGallery(
                                imagePaths: widget.bilan.images ?? [],
                                initialIndex: 0,
                                date: widget.bilan.date ?? "",
                                title: widget.bilan.type ?? "",
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Afficher | عرض",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                      width: widget.mediaQuery.size.width * 0.02,
                    ),
                    Text(widget.bilan.date ?? "")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
