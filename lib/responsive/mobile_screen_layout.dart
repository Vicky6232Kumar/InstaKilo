import 'package:flutter/material.dart';
import 'package:instakilo/utils/global_variables.dart';
import 'package:rive/rive.dart';
import 'package:instakilo/utils/rive_utils.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  RiveAssets selectedBottomNav = bottomNavs.first;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onpageChanged(int page){
    setState(() {
      selectedBottomNav = bottomNavs[page];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        
        physics:const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onpageChanged,
        children: homeScreenItems,

      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                  bottomNavs.length,
                  (index) => GestureDetector(
                        onTap: () {
                          if (bottomNavs[index] != selectedBottomNav) {
                            setState(() {
                              selectedBottomNav = bottomNavs[index];
                            });
                            navigationTapped(index);
                          }
                          bottomNavs[index].input!.change(true);
                          Future.delayed(const Duration(seconds: 1), () {
                            bottomNavs[index].input!.change(false);
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBar(
                              isActive: selectedBottomNav == bottomNavs[index],
                            ),
                            SizedBox(
                              height: 36,
                              width: 36,
                              child: Opacity(
                                opacity: selectedBottomNav == bottomNavs[index]
                                    ? 1
                                    : 0.5,
                                child: RiveAnimation.asset(bottomNavs.first.src,
                                    artboard: bottomNavs[index].artboard,
                                    onInit: (artboard) {
                                  StateMachineController controller =
                                      RiveUtils.getRiveController(artboard,
                                          stateMachineName: bottomNavs[index]
                                              .stateMachineName);
                                  bottomNavs[index].input = controller
                                      .findInput<bool>("active") as SMIBool;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ))
            ],
          ),
        ),
      ),
      
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({Key? key, required this.isActive}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 24 : 0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class RiveAssets {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAssets(
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input,
      required this.src});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAssets> bottomNavs = [

    RiveAssets(
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "Home",
      src: "assets/rive/icons.riv"),
  RiveAssets(
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search",
      src: "assets/rive/icons.riv"),


  RiveAssets(
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
      title: "Chat",
      src: "assets/rive/icons.riv"),
  RiveAssets(
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
      title: "Bell",
      src: "assets/rive/icons.riv"),
        RiveAssets(
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "User",
      src: "assets/rive/icons.riv"),
];
