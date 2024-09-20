import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/constants/icons.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/bilan/models/bilan_model.dart';
import 'package:lupus_app/screens/bilan/widgets/bilan_info.dart';
import 'package:lupus_app/screens/bilan/widgets/user_info.dart';

import '../../entity/profile.dart';
import '../../shared/file_service.dart';

class BilanScreen extends StatefulWidget {
  const BilanScreen({super.key});

  @override
  State<BilanScreen> createState() => _BilanScreenState();
}

class _BilanScreenState extends State<BilanScreen> {
  Profile? profile;

  Future<Profile> getProfile() async {
    Profile profileFile = await FileService.getProfile();

    setState(() {
      profile = profileFile;
    });

    return profileFile;
  }

  List<BilanModel> pendingBilans = [];

  @override
  void initState() {
    getProfile();
    /* FileService.writeFile(
        "mes_bilans.txt",
        BilanModel(date: "22/12/2022", type: "NSC", image: "image bilan", id: 1)
            .toJson()
            .toString());
    FileService.writeFile(
        "mes_bilans.txt",
        BilanModel(
                date: "12/12/2021", type: "type 2", image: "image bilan", id: 2)
            .toJson()
            .toString());
    FileService.writeFile(
        "mes_bilans.txt",
        BilanModel(date: "22/12/2022", type: "NSC", image: "image bilan", id: 3)
            .toJson()
            .toString());
            */

    super.initState();
  }

  final dateController = TextEditingController();

  late MediaQueryData mediaQuery;
  List<String> listBilanType = ["NFS", "Protéinurie"];
  String selectedBilanType = "NFS";

  List<BilanModel> listBilans = [];

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Bilan\nالفحص الطبي',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UserInfo(
              mediaQuery: MediaQuery.of(context),
              name: "${profile?.nom} ${profile?.prenom}",
              gender: "",
              age: (DateTime.now().year -
                      int.parse(profile?.dateNaissance.substring(0, 4) ?? '0'))
                  .toString(),
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
                          const Text(
                              "Veuillez ajouer votre bilan\nالرجاء إضافة الفحص الطبي الخاصة بك")
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
                          onPressed: () {
                            AwesomeDialog(
                                context: context,
                                dismissOnBackKeyPress: false,
                                dismissOnTouchOutside: false,
                                dialogType: DialogType.noHeader,
                                btnOk: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: pink,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        onPressed: () async {
                                          if (RegExp(
                                                  r"^[0-9]{2}-[0-9]{2}-[0-9]{4}$")
                                              .hasMatch(dateController.text)) {
                                            BilanModel b = BilanModel(
                                                id: DateTime.now()
                                                    .millisecond
                                                    .toString(),
                                                type: selectedBilanType,
                                                date: dateController.text);

                                            await FileService.writeFile(
                                                "bilans.txt",
                                                jsonEncode(b.toJson()));
                                            dateController.clear();

                                            Navigator.pop(context);

                                            AwesomeDialog(
                                                dismissOnBackKeyPress: true,
                                                dismissOnTouchOutside: true,
                                                context: context,
                                                dialogType: DialogType.success,
                                                body: const Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Text(
                                                    "Bilan Ajouté !\nتم إضافة الفحص !",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )).show();
                                          }
                                        },
                                        child: const Text(
                                          "Ajouter | إضافة",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                btnCancel: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        onPressed: () =>
                                            {Navigator.pop(context)},
                                        child: const Text(
                                          "Annuler | إلغاء",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: "Bilan | الفحص الطبي",
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Type de bilan | نوع الفحص الطبي",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: StatefulBuilder(
                                          builder: (context, setState) =>
                                              DropdownButton(
                                                  hint: const Text(
                                                    "Type de bilan",
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  elevation: 5,
                                                  iconSize: 40,
                                                  iconEnabledColor: pink,
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  value: selectedBilanType,
                                                  items: listBilanType
                                                      .map((e) =>
                                                          DropdownMenuItem(
                                                            value: e.toString(),
                                                            child: Text(
                                                              e.toString(),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedBilanType =
                                                          value!;
                                                    });
                                                  }),
                                        ),
                                      ),
                                      const Text(
                                        "Date de bilan | موعد الفحص الطبي",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          enabled: true,
                                          onTap: (() async {
                                            DateTime? date =
                                                DateTime(lastDateYear);
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            date = await showDatePicker(
                                                builder: (context, child) =>
                                                    Theme(
                                                      data: ThemeData(),
                                                      child: child!,
                                                    ),
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate:
                                                    DateTime(firstDateYear),
                                                lastDate:
                                                    DateTime(lastDateYear));

                                            if (date != null) {
                                              dateController.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(date);
                                            } else {
                                              dateController.text = "";
                                            }
                                          }),
                                          autovalidateMode:
                                              //widget.shouldAutoValidate
                                              //? AutovalidateMode.onUserInteraction
                                              //:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                          validator: (value) {
                                            if ((value != null &&
                                                    value.isNotEmpty) &&
                                                !RegExp(r"^[0-9]{2}-[0-9]{2}-[0-9]{4}$")
                                                    .hasMatch(value)) {
                                              return "Valeur invalide";
                                            }
                                            return null;
                                          },
                                          controller: dateController,
                                          decoration: InputDecoration(
                                              hintText: "Date | التاريخ",
                                              suffixIcon: IconButton(
                                                onPressed: (() async {
                                                  DateTime? date =
                                                      DateTime(1900);
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());

                                                  date = await showDatePicker(
                                                      builder: (context,
                                                              child) =>
                                                          Theme(
                                                            data: ThemeData(),
                                                            child: child!,
                                                          ),
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(
                                                          firstDateYear),
                                                      lastDate: DateTime(
                                                          lastDateYear));

                                                  if (date != null) {
                                                    dateController.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(date);
                                                  } else {
                                                    dateController.text = "";
                                                  }
                                                }),
                                                icon: SvgPicture.asset(
                                                  calendarIcon,
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )).show();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.add_box_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Ajouter | إضافة",
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
            FutureBuilder(
              future: FileService.getAllBilans(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) => BilanInfo(
                        mediaQuery: mediaQuery,
                        index: index,
                        bilan: snapshot.data![index]),
                  );
                } else {
                  return Container();
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
