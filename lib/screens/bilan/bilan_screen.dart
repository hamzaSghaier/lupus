import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tunlup/constants/colors.dart';
import 'package:tunlup/constants/icons.dart';
import 'package:tunlup/custom_widgets/custom_app_bar.dart';
import 'package:tunlup/custom_widgets/custom_bottom_bar.dart';
import 'package:tunlup/screens/bilan/models/bilan_model.dart';
import 'package:tunlup/screens/bilan/widgets/bilan_info.dart';
import 'package:tunlup/screens/bilan/widgets/user_info.dart';

import '../../entity/profile.dart';
import '../../shared/file_service.dart';

class BilanScreen extends StatefulWidget {
  const BilanScreen({super.key});

  @override
  State<BilanScreen> createState() => _BilanScreenState();
}

class _BilanScreenState extends State<BilanScreen> {
  Profile? profile;
  List<BilanModel> listBilans = [];
  bool isLoading = true;

  Future<void> loadBilans() async {
    try {
      final bilans = await FileService.getAllBilans();
      setState(() {
        listBilans = bilans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement des bilans: $e')),
        );
      }
    }
  }

  Future<Profile> getProfile() async {
    try {
      Profile profileFile = await FileService.getProfile();
      setState(() {
        profile = profileFile;
      });
      return profileFile;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement du profile: $e')),
        );
      }
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    loadBilans();
  }

  final dateController = TextEditingController();
  late MediaQueryData mediaQuery;
  List<String> listBilanType = ["NFS", "Protéinurie"];
  String selectedBilanType = "NFS";

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> addBilan(BilanModel bilan) async {
    try {
      await FileService.writeFile(
        "bilans.txt",
        jsonEncode(bilan.toJson()),
      );
      await loadBilans(); // Reload the list after adding
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du bilan: $e')),
        );
      }
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                mediaQuery: MediaQuery.of(context),
                name: "${profile?.nom} ${profile?.prenom}",
                gender: "",
                age: (DateTime.now().year -
                        int.parse(
                            profile?.dateNaissance.substring(0, 4) ?? '0'))
                    .toString(),
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                  width: mediaQuery.size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: SvgPicture.asset(
                                bilanIcon,
                                width: 24,
                              ),
                            ),
                            const Text(
                              "J'ajoute mon RDV de bilan\nأضيف موعد فحصي الطبي",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dismissOnBackKeyPress: false,
                                dismissOnTouchOutside: false,
                                dialogType: DialogType.noHeader,
                                btnOk: _buildAddButton(),
                                btnCancel: _buildCancelButton(),
                                title: "Bilan | الفحص الطبي",
                                body: _buildDialogContent(),
                              ).show();
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (listBilans.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Aucun bilan trouvé\nلم يتم العثور على فحوصات',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listBilans.length,
                  itemBuilder: (context, index) => BilanInfo(
                    mediaQuery: mediaQuery,
                    index: index,
                    bilan: listBilans[index],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            onPressed: () async {
              if (RegExp(r"^[0-9]{2}-[0-9]{2}-[0-9]{4}$")
                  .hasMatch(dateController.text)) {
                BilanModel bilan = BilanModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: selectedBilanType,
                  date: dateController.text,
                );

                await addBilan(bilan);
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
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ).show();
              }
            },
            child: const Text(
              "Ajouter | إضافة",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Annuler | إلغاء",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Type de bilan | نوع الفحص الطبي",
            style: TextStyle(fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StatefulBuilder(
              builder: (context, setState) => DropdownButton(
                hint: const Text("Type de bilan"),
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                iconSize: 40,
                iconEnabledColor: seedColor,
                isExpanded: true,
                underline: Container(),
                value: selectedBilanType,
                items: listBilanType
                    .map((e) => DropdownMenuItem(
                          value: e.toString(),
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBilanType = value!;
                  });
                },
              ),
            ),
          ),
          const Text(
            "Date de bilan | موعد الفحص الطبي",
            style: TextStyle(fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildDateField(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      enabled: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(firstDateYear),
          lastDate: DateTime(lastDateYear),
          builder: (context, child) => Theme(
            data: ThemeData(),
            child: child!,
          ),
        );

        if (date != null) {
          dateController.text = DateFormat('dd-MM-yyyy').format(date);
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if ((value != null && value.isNotEmpty) &&
            !RegExp(r"^[0-9]{2}-[0-9]{2}-[0-9]{4}$").hasMatch(value)) {
          return "Valeur invalide";
        }
        return null;
      },
      controller: dateController,
      decoration: InputDecoration(
        hintText: "Date | التاريخ",
        suffixIcon: IconButton(
          onPressed: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(firstDateYear),
              lastDate: DateTime(lastDateYear),
              builder: (context, child) => Theme(
                data: ThemeData(),
                child: child!,
              ),
            );

            if (date != null) {
              dateController.text = DateFormat('dd-MM-yyyy').format(date);
            }
          },
          icon: SvgPicture.asset(
            calendarIcon,
            width: 20,
            height: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
