import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oraganfood/model/user_model.dart';
import 'package:oraganfood/utility/my_constant.dart';
import 'package:oraganfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel; // ประกาศตัวแปร global
  String nameShop, address, phone, urlPicture, lat, lng;

  @override
  void initState() {
    // todo: implement initState
    super.initState();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    print('idShop ======>> $idShop');

    String url =
        '${MyConstant().domain}/oraganfood/getUserWhereId.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    print('response ========>> $response');

    var result = json.decode(response.data);
    print('result ========= $result');

    for (var map in result) {
      // เอามาถอดเครืองหมาย [] ออกมาให้เป็นชุด array เพื่อโยนเข้า json ได้
      print('map =========>> $map');
      setState(() {
        userModel =
            UserModel.fromJson(map); //วาด state ใหม่เผื่อbuilt จะวาดเลยไป
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('ปรับปรุง รายละเอียดร้าน'),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
      child: Column(
          children: <Widget>[
            nameShopForm(),
            // แทรกรูปภาพ
            showImage(),
            addressForm(),
            phoneForm(),
          ],
        ),
  );

  Widget showImage() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.add_a_photo), onPressed: null),
            Container(width: 250.0,height: 250.0,
              child: Image.network('${MyConstant().domain}$urlPicture'),
            ),
            IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: null),
          ],
        ),
      );

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อของร้าน'),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );
  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'โทรศัพท์'),
            ),
          ),
        ],
      );
}
