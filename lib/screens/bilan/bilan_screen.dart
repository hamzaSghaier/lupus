import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_app/constants/colors.dart';
import 'package:hospital_app/constants/icons.dart';
import 'package:hospital_app/screens/bilan/widgets/user_info.dart';

class BilanScreen extends StatefulWidget {
  const BilanScreen({super.key});

  @override
  State<BilanScreen> createState() => _BilanScreenState();
}

class _BilanScreenState extends State<BilanScreen> {
  @override
  void initState() {
    super.initState();
  }

  late MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(children: [
          UserInfo(
            mediaQuery: mediaQuery,
            name: "Houssam Gaff",
            gender: "Homme",
            age: "20",
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          //bloc ajouter bilan
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: grey,
                //border: Border.all(color: greyContour),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: SizedBox(
              width: mediaQuery.size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SvgPicture.asset(bilanIcon),
                        ),
                        const Text("Veuillez ajouer votre bilan")
                      ],
                    ),
                    //button ajouter bilan
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
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
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            height: mediaQuery.size.height * 0.06,
            decoration: const BoxDecoration(
                color: lightPink,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Info bilan N ......"),
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
          )
        ]),
      ),
    );
  }
}
