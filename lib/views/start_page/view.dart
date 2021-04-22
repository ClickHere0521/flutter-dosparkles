import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/widgets/keepalive_widget.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  return Scaffold(
    body: FutureBuilder(
        future: _checkContextInit(
          Stream<double>.periodic(Duration(milliseconds: 50),
              (x) => MediaQuery.of(viewService.context).size.height),
        ),
        builder: (_, snapshot) {
          if (snapshot.hasData) if (snapshot.data > 0) {
            Adapt.initContext(viewService.context);
            if (state.isFirstTime != true)
              return Container();
            else
              return PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: state.pageController,
                allowImplicitScrolling: false,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              );
          }
          return Container();
        }),
    drawer: SparklesDrawer(),
    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), child: _AppBar()),
  );
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
