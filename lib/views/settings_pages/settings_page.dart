import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tunin_2/views/settings_pages/about_us.dart';
import 'package:tunin_2/views/settings_pages/license.dart';
import 'package:tunin_2/views/settings_pages/privacy_policy.dart';
import 'package:tunin_2/views/settings_pages/reset_app.dart';
import 'package:tunin_2/views/settings_pages/settings_option.dart';
import 'package:tunin_2/views/settings_pages/sharelink.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const space = SizedBox(
    height: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 140,
        elevation: 10,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Settings',
            style:
                GoogleFonts.aboreto(fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            space,
            OptionWidget(
              infoText: 'About Us',
              infoIcon: Icons.person,
              infoAction: () {
                AboutUs().aboutUs(context);
              },
            ),
            space,
            OptionWidget(
                infoText: 'Reset App',
                infoIcon: Icons.restore,
                infoAction: () {
                  resetApp(context);
                }),
            space,
            OptionWidget(
                infoText: 'Privacy Policy',
                infoIcon: Icons.privacy_tip,
                infoAction: () {
                  Privacy().privacyPolicy(context);
                }),
            space,
            OptionWidget(
                infoText: 'License',
                infoIcon: Icons.info_outline,
                infoAction: () {
                  LicenseView().license(context);
                }),
            space,
            OptionWidget(
                infoText: 'App Settings',
                infoIcon: Icons.app_settings_alt,
                infoAction: () {
                  openAppSettings();
                }),
            space,
            OptionWidget(
              infoText: 'Share',
              infoIcon: Icons.share,
              infoAction: () {
                shareLink(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
