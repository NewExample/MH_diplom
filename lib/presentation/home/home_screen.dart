import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:megaholod_client/presentation/auth/login_screen.dart';
import 'package:megaholod_client/presentation/info/info_screen.dart';
import 'package:megaholod_client/presentation/shops/shops_screen.dart';
import 'package:megaholod_client/presentation/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> items = [];
  var loading = false;
  var show = true;
  CollectionReference noteref = FirebaseFirestore.instance.collection('users');

  var qrLoading = false;
  String? userUid;
  String? percent;
  String? name;
  String? phone;
  String? base;
//This is outside the stream builder:
  String orderResponseCheck = "";
  @override
  void initState() {
    loadData();
    getPercent();
    super.initState();
  }

  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Stack(
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
            physics: const BouncingScrollPhysics(),
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 440,
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
                              color: show
                                  ? const Color(0xff092B95)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                  Radius.elliptical(600, 200))),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: SvgPicture.asset(
                                show
                                    ? 'assets/images/logo_mini.svg'
                                    : 'assets/images/logo.svg',
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    showQrCode();
                                  } else {
                                    login();
                                  }
                                },
                                child: Container(
                                  height: 250,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              134, 103, 242, 0.4),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(3.0,
                                              3.0), // shadow direction: bottom right
                                        )
                                      ],
                                      color: const Color(0xff7CA1FF),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          FirebaseAuth.instance.currentUser !=
                                                  null
                                              ? 'Сканируй QR-код и получи скидку на наших сервисных станциях'
                                              : 'Войдите в личный кабинет и получите доступ к скидкам',
                                          textAlign: TextAlign.center,
                                          // 'Сканируй QR\nв наших магазинах\nи получи скидку',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        if (FirebaseAuth.instance.currentUser ==
                                            null)
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        SvgPicture.asset(
                                          'assets/images/qr.svg',
                                          width: FirebaseAuth
                                                      .instance.currentUser ==
                                                  null
                                              ? 72
                                              : 120,
                                        ),
                                        if (FirebaseAuth.instance.currentUser ==
                                            null)
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        if (FirebaseAuth.instance.currentUser ==
                                            null)
                                          CupertinoButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 24),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: const Text(
                                                overflow: TextOverflow.ellipsis,
                                                'Войти',
                                                style: TextStyle(
                                                    color: Color(0xff092B95),
                                                    fontSize: 14),
                                              ),
                                              onPressed: () {
                                                login();
                                              })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ShopsScreen(
                                                  allowBack: true,
                                                )));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                134, 103, 242, 0.4),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(3.0,
                                                3.0), // shadow direction: bottom right
                                          )
                                        ],
                                        color: const Color(0xff7CA1FF),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/service.svg',
                                          height: 32,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Сервисные\nстанции',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 176,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              134, 103, 242, 0.4),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(3.0,
                                              3.0), // shadow direction: bottom right
                                        )
                                      ],
                                      color: const Color(0xff7CA1FF),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Информация\nдля наших\nклиентов\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        CupertinoButton(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 12),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: const Text(
                                              overflow: TextOverflow.ellipsis,
                                              'Подробнее',
                                              style: TextStyle(
                                                  color: Color(0xff092B95),
                                                  fontSize: 14),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const InfoScreen(
                                                            allowBack: true,
                                                          )));
                                            }),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                // const Padding(
                //   padding: EdgeInsets.only(left: 16),
                //   child: Text(
                //     'Подборка акций',
                //     style: TextStyle(color: Color(0xff092B95), fontSize: 24),
                //   ),
                // ),
                // if (loading)
                //   const SizedBox(
                //     height: 12,
                //   ),
                // if (loading)
                //   const Center(
                //       child: CircularProgressIndicator(
                //     color: Color(0xff092B95),
                //   )),
                // const SizedBox(
                //   height: 8,
                // ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Подборка акций',
                          style:
                              TextStyle(color: Color(0xff092B95), fontSize: 24),
                        ),
                      ),
                      if (loading)
                        const SizedBox(
                          height: 12,
                        ),
                      if (loading)
                        const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xff092B95),
                        )),
                      const SizedBox(
                        height: 8,
                      ),
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: const Color.fromRGBO(124, 161, 255, 0.9),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    items[index]['photo'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  ListTile(
                                    title: Text(
                                      items[index]['name'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(items[index]['desc'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<void> showQrCode() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'QR Code',
            style: TextStyle(color: Color(0xff092B95)),
          )),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (percent != null)
                  StreamBuilder<DocumentSnapshot>(
                      stream: _usersStream,
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                  return const Text("Загружается данные");
                  } else if (snapshot.hasError) {
                  return const Text('Что-то пошло не так');
                  } else if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                  }
                  dynamic data = snapshot.data;
                      return Column(
                        children: [
                          QrImage(
                            //data: base64.encode(percent!.codeUnits),
                            data: '${data['uid']};${data['name']};${data['phone']};${data['percent']}',
                           //data: User.instance.currentUser,
                            //data: '${data['uid']}',
                            version: 4,
                            size: 250,
                            padding: const EdgeInsets.all(6),
                            gapless: false,
                            eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square, color: Color(0xff092B95)),
                            dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Color(0xff092B95)),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text('Скидка: ${data['percent']}%',
                      style: const TextStyle(fontSize: 26, color: Color(0xff092B95)),)

                        ],
                      );
                    }
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void login() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> getPercent() async {
    setState(() {
      qrLoading = true;
    });
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      var userRef = await db.collection('users').doc(uid).get();
      setState(() {
        qrLoading = false;
        userUid = userRef.data()?['uid'].toString();
        percent = userRef.data()?['percent'].toString();
        name = userRef.data()?['name'].toString();
        phone = userRef.data()?['phone'].toString();
        base = base64.encode(percent!.codeUnits);
      });
    } catch (e) {
      showError(context, e.toString());
    } finally {
      setState(() {
        qrLoading = false;
      });
    }
    // late QuerySnapshot<Map<String, dynamic>> qs;
    // qs = await db.collection('users').get();
    // var users = qs.docs.map((e) => e.data()).toList();
    // setState(() {
    //   loading = false;
    //   items = users;
    // });
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
    var usersRef = await db.collection('sales').get();
    var shops = usersRef.docs.map((e) => e.data()..['id'] = e.id).toList();
    setState(() {
      loading = false;
      items = shops;
    });
  }
}

