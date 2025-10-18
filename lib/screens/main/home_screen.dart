import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/services.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/ui.dart';
import '/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  bool isUserPremium = false;
  final revenueCatService = RevenueCatService();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    final isPremium = await revenueCatService.isUserPremium();
    if (mounted) {
      setState(() {
        isUserPremium = isPremium;
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (tabController.index != 0) {
          tabController.animateTo(0);
          return;
        }

        SystemNavigator.pop();
      },
      child: Container(
        decoration: getAppBackground(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: MainAppbar(),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: getBordersScreen(context),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    child: TabBarView(
                      controller: tabController,
                      children: const [
                        ScanScreen(),
                        HistoryScreen(),
                        StatsScreen(),
                        SafeParentScreen(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: getTabBarShadow(context),
                child: SafeArea(
                  child: TabBar(
                    dividerHeight: 0,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    controller: tabController,
                    tabs: [
                      CustomTab(
                        icon: Icons.search,
                        label: 'Scan',
                        index: 0,
                        tabController: tabController,
                        isPremiumFeature: false,
                        isUserPremium: isUserPremium,
                      ),
                      CustomTab(
                        icon: Icons.history,
                        label: 'History',
                        index: 1,
                        tabController: tabController,
                        isPremiumFeature: false,
                        isUserPremium: isUserPremium,
                      ),
                      CustomTab(
                        icon: Icons.bar_chart,
                        label: 'Stats',
                        index: 2,
                        tabController: tabController,
                        isPremiumFeature: false,
                        isUserPremium: isUserPremium,
                      ),
                      CustomTab(
                        icon: Icons.family_restroom,
                        label: 'Safe',
                        index: 3,
                        tabController: tabController,
                        isPremiumFeature: false,
                        isUserPremium: isUserPremium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
