import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    super.key, required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(
            right: MediaQuery.of(context).size.height * 0.04,
          ),
          child: Image.asset("assets/lupus-icon.png"),
        ),
      ],
      title: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
          ),
    
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
