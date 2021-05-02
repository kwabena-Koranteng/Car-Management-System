import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'httpService.dart';

class Car {
  final String id;
  final String model;
  final String make;
  final String type;
  final String year;
  final String color;
  final String pricePerDay;
  final String mileage;
  final String transmission;
  final String numberOfDoors;
  final String power;
  final String fuel;
  final String imagePath;

  Car(
      {@required this.id,
      @required this.model,
      @required this.make,
      @required this.type,
      @required this.year,
      @required this.color,
      @required this.pricePerDay,
      @required this.mileage,
      @required this.transmission,
      @required this.numberOfDoors,
      @required this.power,
      @required this.fuel,
      @required this.imagePath});
}

class AppProvider with ChangeNotifier {
  List<dynamic> _carList = [];

  List<Car> clist = [];

  List testData = [];

  Map _resData = {};

  // Map<String, String> resData = {
  //   "client": "",
  //   "payment": "",
  //   "reservationDate": "",
  //   "number": "",
  //   "carReserved": "",
  //   "startDate": "",
  //   "endDate": "",
  //   "pickup": "",
  //   "dropoff": "",
  //   "status": "",
  //   "img": "",
  // };

  List<Car> get getAllCarData {
    return [..._carList];
  }

  Map get ressData {
    return _resData;
  }

  HttpService _httpService = new HttpService();

  Future<String> sendBooking(Map<String, String> data) async {
    final response = await _httpService.bookCar(data);
    if (response == null) {
      throw "Error";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("reservation_id", response);
    return response;
  }

  Future<void> updates(Map<String, String> data) async {
    final response = await _httpService.updateDetails(data);
    print(response);
    _resData = response;
    notifyListeners();
    return response;
  }

  Future<void> delete(Map<String, String> data) async {
    final response = await _httpService.delete(data);
    print(response);
    _resData.clear();
    notifyListeners();
    return response;
  }

  Future<void> getReservations(Map<String, String> data) async {
    final response = await _httpService.getAllRes(data);
    print(response);
    _resData = response;
  }

  Future<void> search(Map<String, String> data) async {
    final response = await _httpService.searchcar(data);
    print(response);
    final convertResponse = response["data"];
    final List<Car> ldata = [];
    convertResponse.forEach((element) {
      ldata.add(Car(
          id: element["id"],
          make: element["make"],
          model: element["model"],
          type: element["type"],
          year: element["year"],
          color: element["color"],
          pricePerDay: element["Pricesperday"],
          mileage: element["mileage"],
          transmission: element["transmission"],
          numberOfDoors: element["Numberofdoors"],
          fuel: element["fuel"],
          power: element["power"],
          imagePath: element["img"]));
    });
    clist = ldata;
    notifyListeners();
  }

  Future<void> getAllCarsFromAPI() async {
    final response = await _httpService.getAllCars();
    final convertedResponse = response["data"];
    final List<Car> loadedData = [];
    convertedResponse.forEach((element) {
      print(element["year"].runtimeType);
      loadedData.add(Car(
          id: element["id"],
          make: element["make"],
          model: element["model"],
          type: element["type"],
          year: element["year"],
          color: element["color"],
          pricePerDay: element["Pricesperday"],
          mileage: element["mileage"],
          transmission: element["transmission"],
          numberOfDoors: element["Numberofdoors"],
          fuel: element["fuel"],
          power: element["power"],
          imagePath: element["img"]));
    });
    _carList = loadedData;
    notifyListeners();
  }
}
