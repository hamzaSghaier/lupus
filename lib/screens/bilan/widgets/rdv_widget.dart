import 'package:flutter/material.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/constants/icons.dart';

class RdvWidget extends StatefulWidget {
  const RdvWidget({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;
  @override
  State<RdvWidget> createState() => _RdvWidgetState();
}

bool hasRdv = false;

class _RdvWidgetState extends State<RdvWidget> {
  @override
  Widget build(BuildContext context) {
    hasRdv = true;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.all(10),
        height: widget.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            color: grey,
            border: Border.all(color: greyContour),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: hasRdv
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Image(
                    image: AssetImage(rdvIcon),
                    height: 50,
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("RDV TITLE"), Text("02/08/2024")],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_calendar_outlined))
              ])
            : InkWell(
                enableFeedback: true,
                onTap: () {},
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Image(
                          image: AssetImage(rdvPlusIcon),
                          height: 60,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("Ajouter un RDV"), Text("أضف موعدًا")],
                      )
                    ]),
              ));
  }
}
