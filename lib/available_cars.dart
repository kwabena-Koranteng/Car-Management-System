import 'car_widget.dart';
import 'package:provider/provider.dart';
import './AppProvider.dart';
import 'package:flutter/material.dart';
import './AppDrawer.dart';
import 'data.dart';
import 'book_car.dart';

class AvailableCars extends StatefulWidget {
  @override
  _AvailableCarsState createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  List<Filter> filters = getFilterList();
  Filter selectedFilter;
  Future<void> getAllCars;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllCars = getCars();
  }

  // @override
  // void initState() {
  //   super.initState();

  // }

  Future<void> getCars() {
    return Provider.of<AppProvider>(context, listen: false).getAllCarsFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllCars,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (snapShot.connectionState == ConnectionState.done) {
            return Scaffold(
              drawer: AppDrawer(),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                title: Text(
                  "Car Rental",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: Colors.grey[100],
              body: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Fleet",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Consumer<AppProvider>(builder: (context, data, i) {
                        // print(data.getAllCarData.length);
                        return Expanded(
                          child: GridView.builder(
                            itemCount: data.getAllCarData.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 350,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.5),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookCar(
                                                model:
                                                    data.getAllCarData[i].model,
                                                price: data.getAllCarData[i]
                                                    .pricePerDay,
                                                id: data.getAllCarData[i].id,
                                                color:
                                                    data.getAllCarData[i].color,
                                                numberOfDoors: data
                                                    .getAllCarData[i]
                                                    .numberOfDoors,
                                                mileage: data
                                                    .getAllCarData[i].mileage,
                                                fuel:
                                                    data.getAllCarData[i].fuel,
                                                power:
                                                    data.getAllCarData[i].power,
                                                transmission: data
                                                    .getAllCarData[i]
                                                    .transmission,
                                              )),
                                    );
                                  },
                                  child: buildCar(
                                      data.getAllCarData[i].make,
                                      data.getAllCarData[i].model,
                                      data.getAllCarData[i].imagePath));
                            },
                            physics: BouncingScrollPhysics(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          }
          return null;
        });
  }
}
