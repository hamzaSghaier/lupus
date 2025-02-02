import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunlup/constants/colors.dart';
import 'package:tunlup/custom_widgets/custom_app_bar.dart';
import 'package:tunlup/custom_widgets/custom_bottom_bar.dart';
import 'package:tunlup/screens/bilan/bilan_screen.dart';
import 'package:tunlup/screens/bilan/widgets/rdv_widget.dart';
import 'package:tunlup/screens/bilan/widgets/user_info.dart';
import 'package:tunlup/screens/medicaments.dart';
import 'package:tunlup/screens/signup.dart';
import 'package:tunlup/screens/statistics/rdv_model.dart';
import 'package:tunlup/screens/symptoms.dart';

import '../entity/profile.dart';
import '../shared/file_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Profile? profile;
  List<RdvModel> rdvList = [];
  String? errorMessage;

  Future<void> getProfile() async {
    try {
      Profile profileFile = await FileService.getProfile();
      setState(() {
        profile = profileFile;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de chargement du profil';
      });
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> loadRdvs() async {
    try {
      final List<RdvModel> rdvs = await FileService.getRDVs();
      setState(() {
        rdvList =
            rdvs.where((rdv) => rdv.date.isAfter(DateTime.now())).toList();
        // Sort RDVs by date
        rdvList.sort((a, b) => a.date.compareTo(b.date));
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        rdvList = [];
      });
      debugPrint('Error loading RDVs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    loadRdvs();
  }

  String _calculateBirthYear() {
    if (profile?.dateNaissance == null) return "";

    try {
      int yearOfBirth = int.parse(profile!.dateNaissance.substring(0, 4));
      int age = DateTime.now().year - yearOfBirth;
      return age.toString();
    } catch (e) {
      debugPrint('Error calculating age: $e');
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context);
    final isSmallScreen = size.size.width < 600;
    final buttonSize = size.size.width / (isSmallScreen ? 2.5 : 4);
    final spacing = size.size.width * 0.05;

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Accueil\nالإستقبال',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacing / 2),
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: EdgeInsets.all(spacing),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                UserInfo(
                  mediaQuery: size,
                  name: "${profile?.nom ?? ''} ${profile?.prenom ?? ''}",
                  gender: "",
                  age: _calculateBirthYear(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: RdvWidget(
                    mediaQuery: size,
                    rdvs: rdvList,
                    hasRdv: rdvList.isNotEmpty,
                    update: loadRdvs,
                  ),
                ),
                SizedBox(height: spacing),
                _buildMenuGrid(buttonSize, spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(double buttonSize, double spacing) {
    final menuItems = [
      MenuItemData(
        title: 'Médicaments\nالأدوية',
        image: 'assets/Rectangle-2.png',
        onPressed: () => Get.to(const MedicamentsScreen()),
      ),
      MenuItemData(
        title: 'Symptômes\nالأعراض',
        image: 'assets/Rectangle-3.png',
        onPressed: () => Get.to(const SymptomsScreen()),
      ),
      MenuItemData(
        title: 'Bilans\nالفحص',
        image: 'assets/Rectangle.png',
        onPressed: () => Get.to(const BilanScreen()),
      ),
      MenuItemData(
        title: 'Profil\nالحساب',
        image: 'assets/Rectangle-1.png',
        onPressed: () => Get.to(const SignUpScreen()),
      ),
    ];

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      children: menuItems
          .map((item) => HomeButton(
                title: item.title,
                image: item.image,
                onPressed: item.onPressed,
                size: buttonSize,
              ))
          .toList(),
    );
  }
}

class MenuItemData {
  final String title;
  final String image;
  final VoidCallback onPressed;

  MenuItemData({
    required this.title,
    required this.image,
    required this.onPressed,
  });
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
    required this.size,
  });

  final String title;
  final String image;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size * 0.9,
        height: size * 1,
        decoration: BoxDecoration(
          color: seedColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: seedColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: size * 0.3,
              height: size * 0.3,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size * 0.09,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
