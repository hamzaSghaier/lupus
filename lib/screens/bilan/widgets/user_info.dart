import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tulup/constants/colors.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    super.key,
    required this.mediaQuery,
    required this.name,
    required this.age,
    required this.gender,
  });

  final MediaQueryData mediaQuery;
  final String name;
  final String age;
  final String gender;
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.all(10),
      height: widget.mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: greyContour),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SvgPicture.asset("assets/icons/avatar.svg"),
        ),
        Text(widget.name),
        const Spacer(),
        // ${widget.age == "0" ? "" : widget.age+" ans" }
        // Text("${widget.gender}  ", style: const TextStyle(fontWeight: FontWeight.normal)),
      ]),
    );
  }
}
