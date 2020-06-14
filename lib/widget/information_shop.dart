import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oraganfood/model/user_model.dart';
import 'package:oraganfood/screens/add_info_shop.dart';
import 'package:oraganfood/screens/edit_info_shop.dart';
import 'package:oraganfood/utility/my_constant.dart';
import 'package:oraganfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel userModel;
  @override
  void initState() {
    // todo: implement initState
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/oraganfood/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      // แปลงการเข้ารหัสภาษาไทยออกมาก่อน ของเราไม่เข้ารหัสก็แสดงไทยแล้ว
      print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('nameShop = ${(userModel.nameShop)}');
      }
    });
  }

  void routeToAddInfo() {
    
    
    Widget widget = userModel.nameShop.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // วัตถุจะสามารถซ่อนทันกันได้
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel.nameShop.isEmpty ? showNoData(context) : showContent(),
        addAndEditButton(),
      ],
    );
  }

  Widget showContent() => Column(
        children: <Widget>[
          //   Text(
          //     userModel.nameShop,
          //     style: TextStyle(
          //       fontSize: 24.0,
          //       color: Colors.green.shade800,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         child: Image.network(
          //           '${MyConstant().domain}${userModel.urlPicture}',
          //           fit: BoxFit.contain,
          //         ),
          //         height: 300.0,
          //         width: 300.0,
          //       ),
          //     ],
          //   ),
          //   Text('ที่อยู่่ : ${userModel.address}'),
          //   Text('โทรศัพท์ : ${userModel.phone}'),
          MyStyle().mySizebox(),
          MyStyle().showTitleH2('ข้อมูลร้าน : ${userModel.nameShop}'),
          MyStyle().mySizebox(),
          showImage(),
          MyStyle().mySizebox(),
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('ที่อยู่ :'),
            ],
          ),
          Row(
            children: <Widget>[
              Text(userModel.address),
            ],
          ),
         
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('โทรศัพท์ :'),
            ],
          ),
          Row(
            children: <Widget>[
              Text(userModel.phone),
            ],
          ),
          MyStyle().mySizebox(),
          showMap(),
        ],
      );

  Container showImage() {
    return Container(width: 200.0,height: 200.0,
          child: Image.network('${MyConstant().domain}${userModel.urlPicture}'),
        );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('shopID'),
        position: LatLng(
          double.parse(userModel.lat),
          double.parse(userModel.lng),
        ),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้าน',
            snippet:
                'ละติจูด = ${userModel.lat},  ลองติจูด = ${userModel.lng}'),
      )
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      //padding: EdgeInsets.all(10.0),
      //height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Widget showNoData(BuildContext context) {
    return MyStyle().titleCenter('กรุณาเพิ่มข้อมูล', context);
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('You Click at Floating');
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
