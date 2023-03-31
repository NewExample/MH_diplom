import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:megaholod_client/presentation/auth/login_screen.dart';
import 'package:megaholod_client/presentation/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var db = FirebaseFirestore.instance;
  String? percent;
  @override
  void initState() {
    getPercent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 390,
                  color: const Color(0xff092B95),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 300,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: -50,
                            right: -50,
                            top: -50,
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                  color:  Color(0xff092B95),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(600, 200))),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: SvgPicture.asset(
                                    'assets/images/logo_mini.svg',
                                    height: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,),
                        child: FirebaseAuth.instance.currentUser != null
                            ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // SvgPicture.asset(
                            //   'assets/images/logo_mini.svg',
                            //   height: 60,
                            // ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Center(
                                child: Text(
                                  'ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ',
                                  style: TextStyle(
                                      color: Color(0xff092B95),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: getFirstName(),
                              decoration:
                              const InputDecoration(labelText: 'Имя'),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: getLastName(),
                              decoration:
                              const InputDecoration(labelText: 'Фамилия'),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: FirebaseAuth
                                  .instance.currentUser?.phoneNumber ??
                                  '',
                              decoration: const InputDecoration(
                                  labelText: 'Номер телефона'),
                            ),
                            //  const Spacer(),
                            const SizedBox(
                              height: 16,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Ваша индивидуальная скидка\n',
                                style: const TextStyle(
                                    color: Color(0xff092B95),
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${percent ?? ''}%',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: CupertinoButton(
                                onPressed: () {
                                  logOut();
                                },
                                borderRadius: BorderRadius.circular(30),
                                color:
                                const Color.fromRGBO(217, 217, 217, 0.21),
                                child: const Text(
                                  'Выйти из профиля',
                                  style: TextStyle(
                                      color: Color(0xff5880FF),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            Center(
                              child: CupertinoButton(onPressed: () {
                                alertDialog();
                              },
                                child: const Text('Удалить аккаунт', style:TextStyle(
                                    color: CupertinoColors.systemRed,
                                    fontWeight: FontWeight.w300)),

                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        )
                            :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // SvgPicture.asset(
                            //   'assets/images/logo_mini.svg',
                            //   height: 60,
                            // ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Center(
                                child: Text(
                                  'ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ',
                                  style: TextStyle(
                                      color: Color(0xff092B95),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 36),
                              child: CupertinoButton(
                                onPressed: () {
                                  login();
                                },
                                borderRadius: BorderRadius.circular(30),
                                color:
                                const Color.fromRGBO(217, 217, 217, 0.21),
                                child: const Text(
                                  'Войти',
                                  style: TextStyle(
                                      color: Color(0xff5880FF),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFirstName() {
    var name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    var names = name.split(' ');
    if (names.isNotEmpty) {
      return names[0];
    } else {
      return '';
    }
  }

  getLastName() {
    var name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    var names = name.split(' ');
    if (names.length > 1) {
      return names[1];
    } else {
      return '';
    }
  }

  void logOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  // void deleteAlert() {
  //   FirebaseAuth.instance.signOut().then((value) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const LoginScreen()));
  //   });
  // }

  Future<void> alertDialog() async {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Удалить аккаунт"),
        content: const Text("Вы действительно хотите удалить аккаунт и выйти с приложения?"),
        actions: [
          TextButton(
          onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Нет")),
      TextButton(
      onPressed: () {
      deleteAccount().then((value) =>
          SystemNavigator.pop()
      );
      },
      child: const Text("Да")),
        ],
      );
    },
    );
  }


  Future<void> getPercent() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      var userRef = await db.collection('users').doc(uid).get();
      setState(() {
        percent = userRef.data()?['percent'].toString();
      });
    } catch (e) {
      showError(context, e.toString());
    }
  }

  void login() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> deleteAccount() async {
    //await FirebaseAuth.instance.currentUser?.delete();
    var percentFive = '5';
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      var userRef = await db.collection('users').doc(uid).get();
      db
          .collection('users')
          .doc(uid)
          .update({'percent': percentFive});
      setState(() {
        percent = userRef.data()?['percent'].toString();

      });
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    } catch (e) {
      showError(context, e.toString());
    }

  }
}