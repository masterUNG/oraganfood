import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oraganfood/model/user_model.dart';
import 'package:oraganfood/screens/add_info_shop.dart';
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
    print('routeToAddInfo Work!');
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInfoShop(),
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
          Text(
            userModel.nameShop,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.orange.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.network(
                  '${MyConstant().domain}${userModel.urlPicture}',
                  fit: BoxFit.contain,
                ),
                height: 300.0,
                width: 300.0,
              ),
            ],
          ),
          Text('ที่อยู่่ : ${userModel.address}'),
          Text('โทรศัพท์ : ${userModel.phone}'),
        ],
      );

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
