import 'package:flutter/material.dart';
import 'package:lupus_app/screens/statistics/calendar_screen.dart';
import 'package:lupus_app/screens/statistics/statistics_screen.dart';

class SuiviScreen extends StatefulWidget {
  const SuiviScreen({super.key});

  @override
  State<SuiviScreen> createState() => _SuiviScreenState();
}

class _SuiviScreenState extends State<SuiviScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'RDV'),
            Tab(text: 'Courbes'),
          ],
        ),
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
        title: const Text(
          "Suivi",
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CalendarScreen(),
          Statistics(),
        ],
      ),
    );
  }
}
