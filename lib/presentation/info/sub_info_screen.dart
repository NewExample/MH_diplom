import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubInfoScreen extends StatefulWidget {
  final Map<String, dynamic> items;
  final String name;
  const SubInfoScreen({required this.name, required this.items, super.key});

  @override
  State<SubInfoScreen> createState() => _SubInfoScreenState();
}

class _SubInfoScreenState extends State<SubInfoScreen> {
  var textColor = const Color(0xff0D0140);
  ScrollController controller = ScrollController();
  var loading = false;
  var show = true;

  var qrLoading = false;
  String? percent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 280,
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
                          padding: const EdgeInsets.only(bottom: 80),
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
                    top: 30,
                    left: 0,
                    child: CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.chevron_left_outlined,
                          size: 40,
                          color: show ? Colors.white : textColor,
                        )),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'ТЕХНИЧЕСКАЯ ДОКУМЕНТАЦИЯ\n',
                style: const TextStyle(
                    color: Color(0xff092B95),
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
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
              height: 24,
            ),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      launchUrlString(widget.items.values.elementAt(index));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(134, 103, 242, 0.4),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  3.0, 3.0), // shadow direction: bottom right
                            )
                          ],
                          color: const Color.fromRGBO(124, 161, 255, 0.84),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        widget.items.keys.elementAt(index),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      )),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
