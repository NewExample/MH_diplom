import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


class ShopsScreen extends StatefulWidget {
  final bool allowBack;
  const ShopsScreen({this.allowBack = false, super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  ScrollController controller = ScrollController();
  var textColor = const Color(0xff0D0140);
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> itemCoordinates = [];
  var loading = false;
  var show = true;
  @override
  void initState() {
    loadData();
    loadCoordinate();
    super.initState();
  }
 // final availableMaps = MapLauncher.installedMaps;
 //  String query = Uri.encodeComponent(Utils.getSelectedStoreAddress());
 //  Uri appleUrl = Uri.parse('maps:q=$query');
 //  Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.allowBack;
      },
      child: Scaffold(
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
                    if (widget.allowBack)
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
              Center(
                  child: Text(
                'Сервисные станции'.toUpperCase(),
                style: const TextStyle(
                    color: Color(0xff092B95),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
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
                  itemCount: items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (items[index]['photo'] != null)
                            Image.network(
                              items[index]['photo'],
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 16, right: 16),
                            title: Text(
                              items[index]['name'] ?? '',
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                            trailing: GestureDetector(
                                onTap: () async {
                                  var urlLink = Uri.parse(itemCoordinates[index]['url']);
                                  //   MapLauncher.showMarker(mapType: MapType.google, coords: Coords(itemCoordinates[index]['coord1'], itemCoordinates[index]['coord2']), title:  items[index]['address'] ?? '');
                                  //   MapsLauncher.launchCoordinates(
                                  //       itemCoordinates[index]['coord1'], itemCoordinates[index]['coord2']);
                                  //launch(itemCoordinates[index]['url']);
                                  final nativeAppLaunchSucceeded = await launchUrl(
                                    urlLink,
                                    mode: LaunchMode.externalNonBrowserApplication,
                                  );
                                  if (!nativeAppLaunchSucceeded) {
                                    await launchUrl(
                                      urlLink,
                                        mode: LaunchMode.inAppWebView,
                                    );
                                  }
                                  },
                                child: SvgPicture.asset(
                                  'assets/images/to_map.svg',
                                  width: 32,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/shops.svg',
                                  height: 16,
                                  width: 16,
                                  color: textColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                    child: Text(
                                  items[index]['address'] ?? '',
                                  style:
                                      TextStyle(color: textColor, fontSize: 13),
                                ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/info_circle.svg',
                                  height: 16,
                                  width: 16,
                                  color: textColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                    child: Text(
                                        '${items[index]['phone'] ?? ''}\n${items[index]['email'] ?? ''}',
                                        style: TextStyle(
                                            color: textColor, fontSize: 13)))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/clock.svg',
                                  height: 16,
                                  width: 16,
                                  color: textColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                    child: Text(items[index]['workTime'] ?? '',
                                        style: TextStyle(
                                            color: textColor, fontSize: 13)))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     centerTitle: true,
    //     backgroundColor: const Color(0xff092B95),
    //     title: const Text(
    //       'Сервисные станции',
    //       style: TextStyle(fontWeight: FontWeight.w400),
    //     ),
    //   ),
    //   body: loading
    //       ? const Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : ListView.builder(
    //           itemCount: items.length,
    //           itemBuilder: (context, index) {
    //             return Card(
    //               clipBehavior: Clip.hardEdge,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8.0),
    //               ),
    //               margin: const EdgeInsets.all(16),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   if (items[index]['photo'] != null)
    //                     Image.network(
    //                       items[index]['photo'],
    //                       height: 250,
    //                       width: double.infinity,
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ListTile(
    //                     contentPadding:
    //                         const EdgeInsets.only(left: 16, right: 16),
    //                     title: Text(
    //                       items[index]['name'] ?? '',
    //                       style: TextStyle(fontSize: 18, color: textColor),
    //                     ),
    //                     trailing: GestureDetector(
    //                         onTap: () {
    //                           MapsLauncher.launchQuery(
    //                               items[index]['address'] ?? '');
    //                         },
    //                         child: SvgPicture.asset(
    //                           'assets/images/to_map.svg',
    //                           width: 32,
    //                         )),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(left: 16, right: 16),
    //                     child: Row(
    //                       children: [
    //                         SvgPicture.asset(
    //                           'assets/images/shops.svg',
    //                           height: 16,
    //                           width: 16,
    //                           color: textColor,
    //                         ),
    //                         const SizedBox(
    //                           width: 6,
    //                         ),
    //                         Expanded(
    //                             child: Text(
    //                           items[index]['address'] ?? '',
    //                           style: TextStyle(color: textColor, fontSize: 13),
    //                         ))
    //                       ],
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 8,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(left: 16, right: 16),
    //                     child: Row(
    //                       children: [
    //                         Expanded(
    //                             child: Row(
    //                           children: [
    //                             SvgPicture.asset(
    //                               'assets/images/info_circle.svg',
    //                               height: 16,
    //                               width: 16,
    //                               color: textColor,
    //                             ),
    //                             const SizedBox(
    //                               width: 6,
    //                             ),
    //                             Expanded(
    //                                 child: Text(
    //                                     '${items[index]['phone'] ?? ''}\n${items[index]['email'] ?? ''}',
    //                                     style: TextStyle(
    //                                         color: textColor, fontSize: 13)))
    //                           ],
    //                         )),
    //                         const SizedBox(
    //                           width: 12,
    //                         ),
    //                         Expanded(
    //                             child: Row(
    //                           children: [
    //                             SvgPicture.asset(
    //                               'assets/images/clock.svg',
    //                               height: 16,
    //                               width: 16,
    //                               color: textColor,
    //                             ),
    //                             const SizedBox(
    //                               width: 6,
    //                             ),
    //                             Expanded(
    //                                 child: Text(items[index]['workTime'] ?? '',
    //                                     style: TextStyle(
    //                                         color: textColor, fontSize: 13)))
    //                           ],
    //                         ))
    //                       ],
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 16,
    //                   )
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    // );
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
    var usersRef = await db.collection('shops').get();
    var shops = usersRef.docs.map((e) => e.data()..['id'] = e.id).toList();
    setState(() {
      loading = false;
      items = shops;
    });
  }
  Future<void> loadCoordinate() async {
    setState(() {
      loading = true;
    });
    var usersRef = await db.collection('coordinates').get();
    var coordinates = usersRef.docs.map((e) => e.data()..['id'] = e.id).toList();
    setState(() {
      loading = false;
      itemCoordinates = coordinates;
    });
  }

}
