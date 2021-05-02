import 'car_widget.dart';
import 'package:provider/provider.dart';
import './AppProvider.dart';
import 'package:flutter/material.dart';
import './AppDrawer.dart';
import 'data.dart';
import 'book_car.dart';

class Searchcar extends StatefulWidget {
  @override
  _SearchcarState createState() => _SearchcarState();
}

class _SearchcarState extends State<Searchcar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppProvider>(context).clist;
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: data.length == 0
          ? Scaffold()
          : Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.5),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookCar(
                                    model: data[i].model,
                                    price: data[i].pricePerDay,
                                    id: data[i].id,
                                    color: data[i].color,
                                    numberOfDoors: data[i].numberOfDoors,
                                    mileage: data[i].mileage,
                                    fuel: data[i].fuel,
                                    power: data[i].power,
                                    transmission: data[i].transmission,
                                  )),
                        );
                      },
                      child: buildCar(
                          data[i].make, data[i].model, data[i].imagePath));
                },
                physics: BouncingScrollPhysics(),
              ),
            ),
    );
  }
}
