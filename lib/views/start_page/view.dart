import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/widgets/keepalive_widget.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/sparkles_drawer.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    StartPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    _FirstPage(
        continueTapped: () => dispatch(StartPageActionCreator.onStart())),
  ];

  Widget _buildPage(Widget page) {
    return keepAliveWrapper(page);
  }

  return Builder(builder: (BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "images/image 37.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "images/image 38.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 67.0),
                  SvgPicture.asset(
                    "images/The Perfect Gift.svg",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "made for you".toUpperCase(),
                    strutStyle: StrutStyle(
                      fontSize: 14.0,
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: 100.0,
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 26.0),
        child: Center(
          child: Container(
            width: double.infinity,
            height: 48.0,
            constraints: BoxConstraints(maxWidth: 300.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31.0),
              color: Colors.white,
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(8.0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shadowColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#6092DC"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset("images/Vector.svg"),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  });

  // return Scaffold(
  //   body: FutureBuilder(
  //       future: _checkContextInit(
  //         Stream<double>.periodic(Duration(milliseconds: 50),
  //             (x) => MediaQuery.of(viewService.context).size.height),
  //       ),
  //       builder: (_, snapshot) {
  //         if (snapshot.hasData) if (snapshot.data > 0) {
  //           Adapt.initContext(viewService.context);
  //           if (state.isFirstTime != true)
  //             return Container();
  //           else
  //             return PageView.builder(
  //               physics: NeverScrollableScrollPhysics(),
  //               controller: state.pageController,
  //               allowImplicitScrolling: false,
  //               itemCount: pages.length,
  //               itemBuilder: (context, index) {
  //                 return _buildPage(pages[index]);
  //               },
  //             );
  //         }
  //         return Container();
  //       }),
  //   drawer: SparklesDrawer(),
  //   appBar: PreferredSize(
  //       preferredSize: const Size.fromHeight(60), child: _AppBar()),
  // );
}

Future<double> _checkContextInit(Stream<double> source) async {
  await for (double value in source) {
    if (value > 0) {
      return value;
    }
  }
  return 0.0;
}

class _FirstPage extends StatelessWidget {
  final Function continueTapped;
  const _FirstPage({this.continueTapped});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Adapt.px(20)),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: continueTapped,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
                height: 60,
                decoration: BoxDecoration(
                    color: HexColor("#182465"),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    "Continue",
                    // AppLocalizations.of(context).continuebtn,
                    style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: Adapt.px(20))
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Welcome"
          // AppLocalizations.of(context).startPageTitle
          ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              HexColor('#3D9FB0'),
              HexColor('#557084'),
            ],
            begin: const FractionalOffset(0.5, 0.5),
            end: const FractionalOffset(0.5, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
