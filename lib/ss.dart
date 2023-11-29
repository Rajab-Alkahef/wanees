import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:voice_app/services/api_response.dart';

// import 'package:image_picker/image_picker.dart';
String ipCon = '';
sendData2(File photo, String ipco) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://$ipco:5000/api/photo/student'),
  );

  print("photo.path ============ ${photo.path}");
  // Attach the photo to the request
  request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Photo successfully sent');
    } else {
      print('Failed to send photo. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending photo: $e');
  }
}

// resaveData() async {
//   String baseUrl = "http://127.0.0.1:5000//api/photo/student/assets/abd13.jpg";
//   // TODO: Implement your logic to resave the data here
//   Uri url = Uri.parse(baseUrl);
//   http.Response response = await http.get(url);
//   print(jsonDecode(response.body));

//   // print('Resaving data: $newData');
//   // You can add your resaving logic here
// }

// Future<void> fetchData() async {
//   String baseUrl = "http://127.0.0.1:5000//api/photo/student/assets/abd13.jpg";
//   try {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       // TODO: Process the fetched data as needed
//       print('Fetched data: ${response.body}');
//     } else {
//       print('Failed to fetch data. Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   } catch (error) {
//     print('Error fetching data: $error');
//   }
// }

void main() async {
  try {
    ApiRespons ss = ApiRespons();

    var p = await ss.getResponse(prompt: "مرحبا كيفك؟");

    print("p ========== $p ");
    for (var interface in await NetworkInterface.list()) {
      // Check for specific conditions indicating Wi-Fi
      if (interface.name.contains('Wi-Fi') ||
          interface.name.contains('WiFi') ||
          interface.name.contains('wlan')) {
        print('Wi-Fi Interface: ${interface.name}');
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            ipCon = addr.address;
            print('  IP: ${addr.address}');
          }
        }
      }
    }
    // var photoFile = File('E:/new app/VoiceApp/voice_app/assets/abd13.jpg');
    // await sendData2(photoFile, ipCon);
  } catch (e) {
    print('Error retrieving network information: $e');
  }
}
