import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masked_text/masked_text.dart';
import 'package:megaholod_client/presentation/auth/name_screen.dart';
import 'package:megaholod_client/presentation/main/main_screen.dart';
import 'package:megaholod_client/presentation/utils.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final InputDecoration inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
  String phone = '';
  String code = '';
  String verificationId = '';
  bool sent = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  int _start = 30;
  bool wait = false;
  int? value;
  String buttonName = "Повторить отправку";
  int? _resendToken;
  String pin = "";
  String _codeon="";
  String signature = "{{ app signature }}";
  late Timer _timer;
  void _startTimer() {
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobileFormatter = PhoneNumberTextInputFormatter();
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AbsorbPointer(
        absorbing: loading,
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ListView(
                      children:[
                        Container(
                            //height: 390,
                            color: const Color(0xffB2C5FF),
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
                                        decoration: const BoxDecoration(
                                            color: Color(0xffB2C5FF),
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(600, 200))),
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
                                                      style: TextStyle(
                                                          color: Color(0xff5880FF))),
                                                  TextSpan(
                                                      text: ' в мире\nтранспортного климата'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 32,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 20),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          const Center(
                                              child: Text(
                                                'Авторизация',
                                                style: TextStyle(
                                                    color: Color(0xff092B95),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 32),
                                              )),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          const Text(
                                            'Номер телефона',
                                            style: TextStyle(color: Colors.black54),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          MaskedTextField(
                                            enabled: !sent,
                                            onChanged: (value) {
                                              phone = value
                                                  .replaceAll('-', '')
                                                  .replaceAll(' ', '');
                                            },
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Заполните данные';
                                              }
                                              return null;
                                            },
                                            decoration:
                                            inputDecoration.copyWith(hintText: '+'),
                                            keyboardType: TextInputType.number,
                                            maxLength: 16,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            mask: "+# ### ###-##-##",
                                          ),
                                          if (sent)
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          if (sent)
                                          const Text(
                                            'Введите код из СМС',
                                            style: TextStyle(color: Colors.black54),
                                          ),
                                          if (sent)
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          if (sent)
                                          wait
                                              ? const LinearProgressIndicator() :
                                            PinFieldAutoFill(
                                                decoration: UnderlineDecoration(
                                                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                                  colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                                                ), // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                                                currentCode: _codeon,// prefill with a code
                                                onCodeSubmitted: (code) {
                                                  _auth();
                                                },//code submitted callback
                                                onCodeChanged: (value) {
                                                  code = value!;
                                                  if (value!.length == 6) {
                                                //FocusScope.of(context).requestFocus(FocusNode());
                                                    _auth();
                                                 }
                                                  },
                                                //code changed callback
                                                codeLength: 6,//code length, default 6
                                                autoFocus:true
                                            ),
                                          // TextFormField(
                                          //   autofocus: sent,
                                          //   inputFormatters: [
                                          //     LengthLimitingTextInputFormatter(6),
                                          //   ],
                                          //   textAlign: TextAlign.center,
                                          //   onChanged: (value) {
                                          //     code = value;
                                          //
                                          //   },
                                          //   keyboardType: TextInputType.number,
                                          //   validator: (value) {
                                          //     if (value == null || value.isEmpty) {
                                          //       return 'Заполните данные';
                                          //     }
                                          //
                                          //     return null;
                                          //   },
                                          //   decoration: inputDecoration,
                                          // ),
                                          if (sent)
                                          Container(
                                            padding: EdgeInsets.only(top: 30),
                                            alignment: Alignment.center,
                                            child: InkWell(onTap: wait  ? null : () {
                                              _startTimer();
                                              setState(() {
                                                _start = 30;
                                                _resend();
                                                wait = true;
                                              });
                                              },
                                              child: Text(
                                                buttonName,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: wait
                                                        ? Colors.grey
                                                        : Color(0xff3E64FF),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:'Raleway'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        if (wait)
                                          Container(
                                            alignment: Alignment.center,
                                            //margin: EdgeInsets.only(left: 30),
                                            child: InkWell(
                                              child: Text('(после $_start секунд)',
                                                style: TextStyle( color: Color(0xff3E64FF), fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          if(!sent)
                                          SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  _auth();
                                                  //_startTimer();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: const Color(0xff5880FF),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(12))),
                                                child: loading
                                                    ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                                    : Text(
                                                  sent ? 'Войти' : 'Войти',
                                                  style:
                                                  const TextStyle(fontSize: 16),
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
                              Container(
                                 child: SizedBox(
                                      height:34,
                                      child: TextButton(
                                          onPressed: () {
                                            skip();
                                          },
                                          child: const Text(
                                            'Пропустить',
                                            style: TextStyle(color: Color(0xff092B95)),
                                          ))),
                                ),
                            ],
                          ),
                        ),
                      ],
            ),
          ),
        ),

      ),
    );
  }

  Future<void> _auth() async {
    if (sent) {
      setState(() {
        loading = true;
      });
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code);
        await FirebaseAuth.instance.signInWithCredential(credential);
        toStart();
      } catch (e) {
        setState(() {
          loading = false;
        });
        showError(context, e.toString());
      }
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await FirebaseAuth.instance.signInWithCredential(credential);
              toStart();
            } catch (e) {
              setState(() {
                loading = false;
              });
              showError(context, e.toString());
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              loading = false;
            });
            showError(context, e.message ?? '');
          },
          codeSent: (String verificationId, int? resendToken) async {
            this.verificationId = verificationId;
            _resendToken = resendToken;
            setState(() {
              loading = false;
              sent = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (!mounted) return;
            setState(() {
              loading = false;
            });
          },
        );
      }
    }
  }

  Future<void> _resend() async {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {

          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              loading = false;
            });
            showError(context, e.message ?? '');
          },
          codeSent: (String verificationId, int? resendToken) async {
            this.verificationId = verificationId;
            _resendToken = resendToken;
            setState(() {
              loading = false;
              sent = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (!mounted) return;
            setState(() {
              loading = false;
            });
          },
        );
      }

  void toStart() {
    if (FirebaseAuth.instance.currentUser?.displayName == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NameScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }



  void skip() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainScreen()));
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 5) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 4)}-');
      if (newValue.selection.end >= 5) {
        selectionIndex += 3;
      }
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 7));
      if (newValue.selection.end >= 7) {
        selectionIndex++;
      }
    }
    if (newTextLength >= 8) {
      newText.write('-${newValue.text.substring(7, usedSubstringIndex = 8)}');
      if (newValue.selection.end >= 11) {
        selectionIndex++;
      }
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

