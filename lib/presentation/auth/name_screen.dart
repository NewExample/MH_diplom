import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:megaholod_client/presentation/main/main_screen.dart';
import 'package:megaholod_client/presentation/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  var db = FirebaseFirestore.instance;
  final InputDecoration inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
  String firstName = '';
  String lastName = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AbsorbPointer(
        absorbing: loading,
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 150),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 130,
                            ),
                            const Center(
                                child: Text(
                              'Введите ваше имя',
                              style: TextStyle(
                                  color: Color(0xff092B95),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32),
                            )),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Фамилия',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                lastName = value;
                              },
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Заполните данные';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Имя',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                firstName = value;
                              },
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Заполните данные';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _save();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: const Color(0xff5880FF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Сохранить',
                                          style: TextStyle(fontSize: 16),
                                        )),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -50,
                  right: -50,
                  top: -50,
                  child: Container(
                    height: 300,
                    decoration: const BoxDecoration(
                        color: Color(0xffB2C5FF),
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(600, 200))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: 'Ваш ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff092B95)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'надёжный партнёр',
                                  style: TextStyle(color: Color(0xff5880FF))),
                              TextSpan(text: ' в мире\nтранспортного климата'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName('$firstName $lastName');
        await saveToStore();
      } catch (e) {
        setState(() {
          loading = false;
        });
        showError(context, e.toString());
      }
    }
  }

  Future<void> saveToStore() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      await showError(context, 'User not found');
      return;
    }
    try {
      var data = <String, dynamic>{
        'uid': currentUser.uid,
        'email': currentUser.email,
        'phone': currentUser.phoneNumber,
        'photoURL': currentUser.photoURL,
        'name': currentUser.displayName,
      };

      final user = await db.collection('users').doc(currentUser.uid).get();
      if (user.exists) {
        data['authed'] = Timestamp.fromDate(DateTime.now());
        final docRef = db.collection('users').doc(currentUser.uid);
        await docRef.set(data);
      } else {
        data['created'] = Timestamp.fromDate(DateTime.now());
        final docRef = db.collection('users').doc(currentUser.uid);
        data['percent'] = 3;
        await docRef.set(data);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } catch (e) {
      showError(context, e.toString());
    }
  }
}
