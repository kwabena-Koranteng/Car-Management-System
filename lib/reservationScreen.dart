import 'dart:io';
import 'package:flutter/material.dart';
import './AppProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import './utils/hexToColor.dart';
import './ButtonPay.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isData = false;
  @override
  void initState() {
    PaystackPlugin.initialize(
        publicKey: "pk_test_94a687ed35ed853ca7ef64f66cff23e0ead15615");
    super.initState();
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: hexToColor("#41aa5e"),
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard(int payment, String email) async {
    Charge charge = Charge()
      ..amount = payment * 100
      ..currency = "GHS"
      ..reference = _getReference()
      ..email = email;
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {
      _showDialog();
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationData = Provider.of<AppProvider>(context).ressData;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.get_app), onPressed: () => _onSubmut(context))
        ],
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Reservations",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: reservationData == null || reservationData.length <= 1
              ? Center(
                  child: Text("No Reservations"),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                          "https://platinumhostel.000webhostapp.com/${reservationData["img"]}"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "Client:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(reservationData["client"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Payment:", style: TextStyle(fontSize: 20)),
                        Text(reservationData["payment"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Reservation Date:",
                            style: TextStyle(fontSize: 20)),
                        Text(reservationData["reservationDate"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Car Reserved:", style: TextStyle(fontSize: 20)),
                        Text(reservationData["CarReserved"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Start Date:", style: TextStyle(fontSize: 20)),
                        Text(reservationData["startDate"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("End Date:", style: TextStyle(fontSize: 20)),
                        Text(reservationData["endDate"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Pickup Location:",
                            style: TextStyle(fontSize: 20)),
                        Text(reservationData["pickup"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Return Location:",
                            style: TextStyle(fontSize: 20)),
                        Text(reservationData["dropoff"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Status:", style: TextStyle(fontSize: 20)),
                        Text(
                            reservationData["status"] == null
                                ? "Not Approved"
                                : reservationData["status"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Phone Number:", style: TextStyle(fontSize: 20)),
                        Text(reservationData["number"],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.purple),
                            onPressed: reservationData == null ||
                                    reservationData.length <= 1
                                ? null
                                : () => _onUpdate(
                                      context,
                                      reservationData["number"],
                                      reservationData["pickup"],
                                      reservationData["dropoff"],
                                      reservationData["endDate"],
                                      reservationData["startDate"],
                                      reservationData["customerId"],
                                      reservationData["ReserveId"],
                                    ),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.purple),
                            onPressed: () {
                              chargeCard(int.parse(reservationData["payment"]),
                                  reservationData["email"]);
                            },
                            child: Text(
                              "Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              Map<String, String> data = {
                                "id": reservationData["ReserveId"],
                                "cId": reservationData["customerId"],
                                "carid": reservationData["carid"]
                              };
                              print(data);
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text("Delete"),
                                      content:
                                          Text("Do you really want to delete"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text("No")),
                                        TextButton(
                                            onPressed: () {
                                              Provider.of<AppProvider>(context,
                                                      listen: false)
                                                  .delete(data);
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text("Yes"))
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _onSubmut(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Map<String, String> _formDetails = {
      "email": "",
      "code": "",
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
                        decoration: InputDecoration(labelText: "email"),
                        onSaved: (value) {
                          _formDetails["email"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "code"),
                        onSaved: (value) {
                          _formDetails["code"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.purple),
                          onPressed: () async {
                            try {
                              _formKey.currentState.save();
                              await Provider.of<AppProvider>(context,
                                      listen: false)
                                  .getReservations(_formDetails);
                              Navigator.of(context).pop();
                              setState(() {
                                isData = !isData;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
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

  void _onUpdate(
      BuildContext context,
      String phoneNumber,
      String pickup,
      String returnLoc,
      String returnDate,
      String pickupDate,
      String cid,
      String id) {
    print(pickup);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Map<String, String> _formDetails = {
      "phoneNumber": "",
      "cId": cid,
      "id": id,
      "pickUp": "",
      "returnLoc": "",
      "returnDate": "",
      "pickUpDate": "",
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
                          "Update Reservation Info",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: phoneNumber,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "phone Number"),
                        onSaved: (value) {
                          _formDetails["phoneNumber"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: pickup,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Pick Up"),
                        onSaved: (value) {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // String code = prefs.getString("reservation_id");
                          _formDetails["pickUp"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: returnLoc,
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Return Location"),
                        onSaved: (value) {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // String code = prefs.getString("reservation_id");
                          _formDetails["returnLoc"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: returnDate,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Return Date"),
                        onSaved: (value) {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // String code = prefs.getString("reservation_id");
                          _formDetails["returnDate"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: pickupDate,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Pickup Date"),
                        onSaved: (value) {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // String code = prefs.getString("reservation_id");
                          _formDetails["pickUpDate"] = value;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.purple),
                          onPressed: () {
                            try {
                              _formKey.currentState.save();
                              Provider.of<AppProvider>(context, listen: false)
                                  .updates(_formDetails);
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop()  ;

                              // print(_formDetails);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            "Update Details",
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
}
