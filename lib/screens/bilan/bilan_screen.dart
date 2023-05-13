import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_app/constants/colors.dart';
import 'package:hospital_app/constants/icons.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:hospital_app/screens/bilan/models/bilan_model.dart';
import 'package:hospital_app/screens/bilan/widgets/bilan_info.dart';
import 'package:hospital_app/screens/bilan/widgets/user_info.dart';
import 'package:hospital_app/shared/file_service.dart';
import 'package:intl/intl.dart';

class BilanScreen extends StatefulWidget {
  const BilanScreen({super.key});

  @override
  State<BilanScreen> createState() => _BilanScreenState();
}

class _BilanScreenState extends State<BilanScreen> {
  @override
  void initState() {
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

    //FileService.getBilans("mes_bilans.txt").then((value) => print(value));

    print(listBilans.length);

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
       appBar: const CustomAppBar(
        title: 'Bilan',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                        onPressed: () {
                                          Navigator.pop(context);

                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              body: const Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child: Text(
                                                  "Bilan Ajouté !",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )).show();
                                        },
                                        child: const Text(
                                          "Ajouter",
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
                                          "Annuler",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: "Bilan",
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Type de bilan",
                                      style: TextStyle(fontSize: 12),
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
                                                    selectedBilanType = value!;
                                                  });
                                                }),
                                      ),
                                    ),
                                    const Text(
                                      "Date de bilan",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: TextFormField(
                                        enabled: true,
                                        onTap: (() async {
                                          DateTime? date = DateTime(1900);
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
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now());

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
                                            AutovalidateMode.disabled,
                                        validator: (value) {
                                          if ((value != null &&
                                                  value.isNotEmpty) &&
                                              !RegExp("[0-9]{2}-[0-9]{2}-[0-9]{4}")
                                                  .hasMatch(value)) {
                                            return "Valeur invalide";
                                          }
                                          return null;
                                        },
                                        controller: dateController,
                                        decoration: InputDecoration(
                                            hintText: "Date",
                                            suffixIcon: IconButton(
                                              onPressed: (() async {
                                                DateTime? date = DateTime(1900);
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
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime.now());

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
                                )).show();
                          },
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
            BilanInfo(
              mediaQuery: mediaQuery,
              title: "NFS",
              index: 1,
              date: "12/05/2023",
            ),
            BilanInfo(
              mediaQuery: mediaQuery,
              title: "Protéinurie",
              index: 2,
              date: "8/02/2023",
            ),
            BilanInfo(
              mediaQuery: mediaQuery,
              title: "Protéinurie",
              index: 3,
              date: "5/02/2023",
            ),
          ]),
        ),
      ),
    );
  }
}
