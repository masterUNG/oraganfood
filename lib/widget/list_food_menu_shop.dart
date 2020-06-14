import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oraganfood/model/food_model.dart';
import 'package:oraganfood/screens/add_food_menu.dart';
import 'package:oraganfood/screens/edit_food_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utility/my_constant.dart';
import '../utility/my_constant.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/my_style.dart';
import '../utility/my_style.dart';
import '../utility/my_style.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  List<FoodModel> foodModels = List();
  bool statusRead = true;

  @override
  void initState() {
    super.initState();
    readFood();
  }

  Future<Null> readFood() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');

    // idShop = '66';

    String urlReadFood =
        '${MyConstant().domain}/oraganfood/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    print('urlReadFood ========>>>>>>>> $urlReadFood');
    await Dio().get(urlReadFood).then((value) {
      print('res = $value');

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          print('Price = ${foodModel.price}');
          setState(() {
            foodModels.add(foodModel);
            statusRead = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        showContent(),
        addFoodButton(),
      ],
    );
  }

  Widget addFoodButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddFoodMenu(),
                    );
                    Navigator.push(context, route).then((value) => readFood());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );

  Widget showContent() {
    return statusRead
        ? Center(
            child: MyStyle().showTitle('ยังไม่มี รายการอาหาร'),
          )
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Image.network(
                    '${MyConstant().domain}${foodModels[index].pathImage}',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: <Widget>[
                      Text(
                        foodModels[index].nameFood,
                        style: MyStyle().mainTitle,
                      ),
                      Text(
                        'ราคา ${foodModels[index].price} บาท',
                        style: MyStyle().mainH2Title,
                      ),
                      Text('รายละเอียด ${foodModels[index].detail}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => EditFoodMenu(
                                  foodModel: foodModels[index],
                                ),
                              );
                              Navigator.push(context, route)
                                  .then((value) => readFood());
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => confirmDelete(foodModels[index]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Future<Null> confirmDelete(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการลบ ${foodModel.nameFood} จริงๆ หรือ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  String id = foodModel.id;
                  String urlDetlete =
                      '${MyConstant().domain}/oraganfood/deleteFoodWhereId.php?isAdd=true&id=$id';
                  await Dio().get(urlDetlete).then((value) => readFood());
                },
                icon: Icon(Icons.check),
                label: Text('ยืนยัน'),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.clear),
                label: Text('ยังไม่ลบ'),
              )
            ],
          )
        ],
      ),
    );
  }
}
