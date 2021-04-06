import 'package:com.floridainc.dosparkles/widgets/branch/branch_two.dart';
import 'package:com.floridainc.dosparkles/widgets/test_apple_signin.dart';
import 'package:com.floridainc.dosparkles/widgets/test_facebook_signin.dart';
import 'package:com.floridainc.dosparkles/widgets/test_geolocation_module.dart';
import 'package:com.floridainc.dosparkles/widgets/test_google_signin.dart';
import 'package:com.floridainc.dosparkles/widgets/test_image_picker.dart';
import 'package:com.floridainc.dosparkles/widgets/test_share_module.dart';
import 'package:com.floridainc.dosparkles/widgets/test_dynamic_link.dart';
import 'package:com.floridainc.dosparkles/widgets/test_stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';

class SparklesDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
            decoration: BoxDecoration(
              color: HexColor("#182465"),
              // image: DecorationImage(
              //     image: AssetImage(""),
              //     fit: BoxFit.cover)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Forgot Password'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('forgot_passwordpage', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Reset Password'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('reset_passwordpage', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Sign Up'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('registrationpage', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Invite Friends'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('invite_friendpage', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Customize Link'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('customize_linkpage', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('settings_page', arguments: null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DemoApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text('Location'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeolocatorWidget()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: Text('Google Sign In'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInDemo()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: Text('Facebook Sign In'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_off),
            title: Text('Stripe'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStripeApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: Text('Apple sign-in'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppleApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: Text('Branch Routing'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BranchApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('chatpage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: Text('Image Picker'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyImagePickerPage()),
              );
            },
          ),
          Divider(color: Colors.black),

          //

          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('storeselectionpage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('profilepage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Inbox'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('storeselectionpage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Setting'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('storeselectionpage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Share'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('storeselectionpage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text('Help and Support'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('helppage');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: HexColor("#d93731")),
            title: Text(
              'Log out',
              style: TextStyle(color: HexColor("#d93731")),
            ),
            onTap: () async {
              await UserInfoOperate.whenLogout();

              Navigator.of(context).pushReplacementNamed('startpage');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
