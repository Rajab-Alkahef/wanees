import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:voice_app/services/api_response.dart';

class ApiHandler {
  final String apiUrl;
  String networkIp = 'as';
  String baseUrl = "";

  ApiHandler(this.apiUrl);

  Future<String> getNetWorkIP() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        // Check for specific conditions indicating Wi-Fi
        if (interface.name.contains('Wi-Fi') ||
            interface.name.contains('WiFi') ||
            interface.name.contains('wlan')) {
          print('Wi-Fi Interface: ${interface.name}');
          for (var addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4) {
              networkIp = addr.address.toString();
              print('  IP: ${addr.address}');
            }
          }
        }
      }
    } catch (e) {
      print('Error retrieving network information: $e');
      networkIp = "There is no connection";
    }
    return networkIp;
  }

  resaveData() async {
    String ipco = await getNetWorkIP();
    if (ipco != "There is no connection") {
      baseUrl = "http://$ipco:5000/api/students";
      Uri url = Uri.parse(baseUrl);

      try {
        http.Response response = await http.get(url);

        if (response.statusCode == 200) {
          print(response.body);

          // Map<String, dynamic> data = jsonDecode(response.body);

          // print('Resaving data: $data');
          return response.body;
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          return;
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
      // You can add your resaving logic here
    }
  }

  sendData(XFile photo) async {
    String ipco;
    ipco = await getNetWorkIP();

    if (ipco != "There is no connection") {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://192.168.0.105:5000/api/photo/student'), //192.168.1.103
      );

      print("photo.path ============ ${photo.path}");
      // Attach the photo to the request
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          print('Photo successfully sent');
          var ss = await response.stream.bytesToString();
          var s = jsonDecode(ss);
          print("response======== /n ${s["message"]}");
          var emotion = s["message"];
          print("###########");
          print(emotion);
          return emotion;
        } else {
          print('Failed to send photo. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending photo: $e');
      }
    } else {
      print("There is no connection");
    }
  }
}

// void main() async {
//   // Replace 'your_api_url' with the actual API endpoint
//   final apiHandler = ApiHandler('your_api_url');

//   var r = await apiHandler.resaveData();
//   print("r======== $r");

//   var photoFile = File('E:/new app/VoiceApp/voice_app/assets/abd13.jpg');
//   var s = await apiHandler.sendData(photoFile);
//   print(" sss $s");
//   print("object GoodBay");

//   ApiRespons ss = ApiRespons();
//   var p = await ss.getResponse(prompt: "مرحبا كيفك?");
//   String l = String.fromCharCodes(p.runes.toList().reversed);
//   print("p ========== $l ");
// //   // Replace this with the actual data you want to resave
// //   // final newData = {'key': 'value'};

// //   // Resave data
// //   // await apiHandler.resaveData(newData)
// //   // Replace this with the actual data you want to send
// //   // final sendData = {'key': 'value'};

// //   // Send data
// //   // await apiHandler.sendData2(sendData);

// //   // Fetch data
// //   // await apiHandler.fetchData();
//   return;
// }
