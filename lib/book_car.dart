import 'package:car_rental/EmailService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './AppProvider.dart' as Cars;
import 'package:car_rental/constants.dart';
import 'package:car_rental/data.dart';
import 'package:intl/intl.dart';
import 'package:tasty_toast/tasty_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCar extends StatefulWidget {
  // final Car car;
  final String model;
  final String price;
  final String id;
  final String color;
  final String transmission;
  final String mileage;
  final String numberOfDoors;
  final String power;
  final String fuel;

  BookCar({
    @required this.model,
    @required this.price,
    @required this.id,
    @required this.color,
    @required this.transmission,
    @required this.mileage,
    @required this.numberOfDoors,
    @required this.power,
    @required this.fuel,
  });

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  bool _isLoading = false;

  int _currentImage = 0;

  Car getCar() {
    return getCarData(widget.model);
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < getCar().images.length; i++) {
      list.add(buildIndicator(i == _currentImage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[400],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(getCar().brand);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Details"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          getCar().model,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          getCar().brand,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Container(
                          child: PageView(
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (int page) {
                              setState(() {
                                _currentImage = page;
                              });
                            },
                            children: getCar().images.map((path) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Hero(
                                  tag: getCar().model,
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      getCar().images.length > 1
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: buildPageIndicator(),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "SPECIFICATIONS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildSpecificationCar("Color", widget.color),
                          buildSpecificationCar("Gearbox", widget.transmission),
                          buildSpecificationCar("Doors", widget.numberOfDoors),
                          buildSpecificationCar("Mileage", widget.mileage),
                          buildSpecificationCar("Fuel", widget.fuel),
                          buildSpecificationCar("Top Speed", widget.power),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "GHC",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      widget.price,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "per day",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.purple),
                onPressed: () => _onSubmit(context),
                child: Text(
                  "Book Car",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Map<String, String> _formDetails = {
      "fName": "",
      "lName": "",
      "email": "",
      "city": "",
      "gen": "",
      "nat": "",
      "pass": "",
      "phoneNumber": "",
      "reg": "Accra",
      "car": widget.id,
      "pickUp": "",
      "returnLoc": "",
      "returnDate": "2020/11/20",
      "pickUpDate": "2020/11/30"
    };

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Booking Details",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "first Name"),
                        onSaved: (value) {
                          _formDetails["fName"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Last Name"),
                        onSaved: (value) {
                          _formDetails["lName"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Email"),
                        onSaved: (value) {
                          _formDetails["email"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "City"),
                        onSaved: (value) {
                          _formDetails["city"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Gender"),
                        onSaved: (value) {
                          _formDetails["gen"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "nationality"),
                        onSaved: (value) {
                          _formDetails["nat"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Passport No."),
                        onSaved: (value) {
                          _formDetails["pass"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Phone Number"),
                        onSaved: (value) {
                          _formDetails["phoneNumber"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Region"),
                        onSaved: (value) {
                          _formDetails["reg"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Pickup Location"),
                        onSaved: (value) {
                          _formDetails["pickUp"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Return Location"),
                        onSaved: (value) {
                          _formDetails["returnLoc"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        onTap: () {},
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            labelText: "Pickup Date", hintText: "yyyy/mm/dd"),
                        onSaved: (value) {
                          _formDetails["pickUpDate"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            labelText: "Return Date", hintText: "yyyy/mm/dd"),
                        onSaved: (value) {
                          _formDetails["returnDate"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.purple),
                          onPressed: () async {
                            try {
                              _formKey.currentState.save();
                              print(_formDetails);
                              setState(() {
                                _isLoading = true;
                              });
                              final bookingId =
                                  await Provider.of<Cars.AppProvider>(context,
                                          listen: false)
                                      .sendBooking(_formDetails);
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Booking successful"),
                                      content: Text(
                                          "Your booking key is $bookingId\n An email has been sent also containing the booking Id"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Okay"))
                                      ],
                                    );
                                  });
                              await sendMail(_formDetails["email"], bookingId);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              print(prefs.getString("reservation_id"));
                            } catch (e) {
                              print(e);
                              setState(() {
                                _isLoading = false;
                              });
                              showToast(
                                context,
                                "Email already exists",
                                textStyle: TextStyle(color: Colors.white),
                                background: BoxDecoration(color: Colors.red),
                                alignment: Alignment.topCenter,
                                duration: Duration(seconds: 5),
                              );
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : Text(
                                  "Confirm Booking",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )),
                      SizedBox(height: 30),
                    ],
                  ),
                )),
          );
        });
  }

  Widget buildSpecificationCar(String title, String data) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            data,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
