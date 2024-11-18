import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _newPasswordController = TextEditingController();

  void changePassword() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null &&
        user.providerData
            .any((provider) => provider.providerId == 'password')) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Change Password',
        widget: TextField(
          controller: _newPasswordController,
          decoration: const InputDecoration(
            labelText: 'Enter new password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        confirmBtnText: 'Update',
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          try {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            await user.updatePassword(_newPasswordController.text.trim());
            Navigator.of(context).pop(); // Close the loading indicator

            // Show success message
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success',
              text: 'Your password has been updated.',
              confirmBtnText: 'OK',
            );
          } on FirebaseAuthException catch (e) {
            Navigator.of(context).pop();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text: e.message.toString(),
              confirmBtnText: 'OK',
            );
          }
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Password change is not available for Google sign-in.',
        confirmBtnText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    void signUserOut() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: NetworkImage(
                              'https://t4.ftcdn.net/jpg/03/59/58/91/360_F_359589186_JDLl8dIWoBNf1iqEkHxhUeeOulx0wOC5.webp'))),
                ),
                const SizedBox(height: 30),
                Text('Logged in as: ${user.email}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: changePassword,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 30.0),
                        backgroundColor: Pallete.gradient2),
                    child: const Text('Change Password',
                        style:
                            TextStyle(fontSize: 18, color: Pallete.whiteColor)),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                ProfileListItem(
                  title: 'About',
                  icon: LineAwesomeIcons.info,
                  onPress: () => Get.to(() => AboutScreen()),
                ),
                /**
                ProfileListItem(
                  title: 'Information',
                  icon: LineAwesomeIcons.info,
                  onPress: () {},
                ),
                ProfileListItem(
                  title: 'Change Currency',
                  icon: LineAwesomeIcons.gg_currency,
                  onPress: () {},
                ), */
                ProfileListItem(
                  title: 'Logout',
                  textColor: Colors.red,
                  icon: LineAwesomeIcons.alternate_sign_out,
                  onPress: signUserOut,
                  endIcon: false,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  const ProfileListItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Pallete.gradient3.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Pallete.gradient2,
          ),
        ),
        title: Text(title, style: TextStyle(fontSize: 20, color: textColor)),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Pallete.greyColor.withOpacity(0.1)),
                child: const Icon(
                  LineAwesomeIcons.angle_right,
                  size: 18.0,
                  color: Color.fromARGB(255, 42, 42, 42),
                ),
              )
            : null,
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
          title: const Text('About The App'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(children: [
              SizedBox(height: 30),
              Text(
                  "This hotel booking application presents a strong solution to streamline reservations for Ethiopia's growing tourism industry. Leveraging modern technologies like Flutter, Dart, and Firebase allows for building high-performing, secure, and scalable mobile apps.",
                  style: Pallete.textStyle),
              SizedBox(height: 10),
              Text(
                  "Overall, this hotel booking application streamlines daily processes for visitors while offering hospitality providers a powerful new channel. By focusing intensely on usability and satisfaction, we aim to become travelers' preferred choice for all future Ethiopian reservations. We're hopeful you'll support realizing this vision to benefit tourism throughout the country.",
                  style: Pallete.textStyle),
              SizedBox(height: 30),
              Text('Done By:', style: Pallete.headlineStyle),
              SizedBox(height: 10),
              Text('1.	Feven Alene …………………………… UGR/5513/13',
                  style: Pallete.textStyle),
              Text('2.	Menna Solomon ……………………… UGR/9311/13',
                  style: Pallete.textStyle),
              Text('3.	Mety Ayele …………………………… UGR/1111/13',
                  style: Pallete.textStyle),
              Text('4.	Rahel Ayana …………………………… UGR/5612/13',
                  style: Pallete.textStyle),
              Text('5.	Yonatan Bedilu ……………………… UGR/0247/13',
                  style: Pallete.textStyle)
            ]),
          ),
        ));
  }
}
