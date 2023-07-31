import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
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
              right: MediaQuery.of(context).size.height * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(38), // Image radius
                child: Image.asset(
                  "assets/lupus-icon.png",
                  width: 64,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            )),
      ],
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
