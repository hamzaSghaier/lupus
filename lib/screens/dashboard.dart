import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/bilan/bilan_screen.dart';
import 'package:lupus_app/screens/bilan/widgets/rdv_widget.dart';
import 'package:lupus_app/screens/bilan/widgets/user_info.dart';
import 'package:lupus_app/screens/medicaments.dart';
import 'package:lupus_app/screens/signup.dart';
import 'package:lupus_app/screens/statistics/rdv_model.dart';
import 'package:lupus_app/screens/symptoms.dart';
import '../entity/profile.dart';
import '../shared/file_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Profile? profile;
  RdvModel? latestRdv;
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

  Future<void> getRdv() async {
    try {
      RdvModel? rdvFile = await FileService.getLatestRDV();
      setState(() {
        latestRdv = rdvFile;
        errorMessage = null;
      });
    } catch (e) {
      // Only set latestRdv to null, don't show error message as this is expected for new users
      setState(() {
        latestRdv = null;
      });
      debugPrint('No RDV found or error loading RDV: $e');
    }
  }

  @override
  void initState() {
    getProfile();
    getRdv();
    super.initState();
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
      bottomNavigationBar:  CustomBottomBar(),
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
                RdvWidget(
                  mediaQuery: size,
                  hasRdv: latestRdv != null,
                  rdv: latestRdv,
                  update: getRdv,
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
        width: size,
        height: size * 1.2,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 229, 245, 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: const Color.fromRGBO(255, 180, 252, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: size * 0.4,
              height: size * 0.4,
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
                    fontSize: size * 0.12,
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