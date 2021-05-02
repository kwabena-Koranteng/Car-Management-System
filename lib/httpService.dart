import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as requests;
import './httpCustomException.dart';

class HttpService {
  static const base_url = "https://platinumhostel.000webhostapp.com/";

  static const headers = {
    'Content-Type': 'application/json',
    'Charset': 'utf-8'
  };

  Future<dynamic> getAllCars() async {
    try {
      final response =
          await requests.get("$base_url/available_cars.php", headers: headers);
      final responseValue = _handleResponse(response);
      print(responseValue);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAllRes(Map<String, String> data) async {
    try {
      final datas = jsonEncode(data);
      print(datas);
      final response = await requests.post("$base_url/reserve.php",
          headers: headers, body: datas);
      final responseValue = _handleResponse(response);
      // print(responseValue);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> bookCar(Map<String, String> data) async {
    try {
      final sendData = json.encode(data);
      final response = await requests.post("$base_url/booking.php",
          headers: headers, body: sendData);
      final responseValue = _handleResponse(response);
      // print(responseValue);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> delete(Map<String, String> data) async {
    try {
      final sendData = json.encode(data);
      final response = await requests.post("$base_url/DeleteRental.php",
          headers: headers, body: sendData);
      final responseValue = _handleResponse(response);
      // print(responseValue);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updateDetails(Map<String, String> data) async {
    try {
      final sendData = json.encode(data);
      print(sendData);
      final response = await requests.post("$base_url/updateRental.php",
          headers: headers, body: sendData);
      final responseValue = _handleResponse(response);
      // print(responseValue);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> searchcar(Map<String, String> data) async {
    try {
      final sendData = json.encode(data);
      print(sendData);
      final response = await requests.post("$base_url/searchcar.php",
          headers: headers, body: sendData);
      final responseValue = _handleResponse(response);
      return responseValue;
    } on SocketException catch (e) {
      throw FetchDataException("There is no internet connection");
    } catch (e) {
      print(e);
    }
  }

  dynamic _handleResponse(requests.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      // return response.body;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
