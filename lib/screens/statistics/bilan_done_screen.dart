import 'package:flutter/material.dart';
import 'package:tulup/custom_widgets/custom_bottom_bar.dart';
import 'package:tulup/screens/bilan/models/bilan_model.dart';
import 'package:tulup/screens/bilan/widgets/bilan_done_info.dart';
import 'package:tulup/shared/file_service.dart';

class BilanDoneScreen extends StatefulWidget {
  const BilanDoneScreen({super.key});

  @override
  State<BilanDoneScreen> createState() => _BilanDoneScreenState();
}

class _BilanDoneScreenState extends State<BilanDoneScreen> {
  List<BilanModel> doneBilans = [];
  late MediaQueryData mediaQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return Scaffold(
        bottomNavigationBar: CustomBottomBar(),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: FileService.getDoneBilans(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) => BilanDoneInfo(
                      mediaQuery: mediaQuery,
                      index: index,
                      bilan: snapshot.data![index]),
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}
