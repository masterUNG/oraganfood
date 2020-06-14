import 'package:flutter/material.dart';
import 'package:oraganfood/model/food_model.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {

  FoodModel foodModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    foodModel = widget.foodModel;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปรับปรุง ${foodModel.nameFood}'),
      ),
    );
  }
}
