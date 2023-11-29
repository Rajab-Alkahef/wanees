import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_app/models/response_model.dart';
// import 'package:voice_app/models/response_model.dart';

class ApiRespons {
  String apiKey = "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";
  // getResponse({String prompt = "Hello"}) async {
  //   final response = await http.post(
  //       Uri.parse("https://api.openai.com/v1/completions"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': "Bearer $apiKey"
  //       },
  //       body: jsonEncode(
  //         {
  //           'model': "gpt-3.5-turbo-instruct",
  //           "prompt": prompt,
  //           "max_tokens": 250,
  //           "temperature": 0,
  //           "top_p": 1
  //         },
  //       ));

  //   String res = jsonDecode(utf8.decode(response.bodyBytes)); //ResponseModel.fromJson(
  //   print("res============ $res");
  //   String res1 = res['choices'][0]["text"];
  //   return res1; //res.choices[0]['text']; "res["choices"][0]["text"]
  // }
  Future<String> getResponse({String prompt = "Hello"}) async {
    final response = await http.post(
        Uri.parse("https://api.openai.com/v1/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apiKey"
        },
        body: jsonEncode(
          {
            'model': "text-davinci-003", //"gpt-3.5-turbo-instruct",
            "prompt": prompt,
            "max_tokens": 250,
            "temperature": 0,
            "top_p": 1
          },
        ));

    if (response.statusCode == 200) {
      var responseBody =
          ResponseModel.fromJson(utf8.decode(response.bodyBytes));
      // jsonDecode(utf8.decode(response.bodyBytes));
      return responseBody.choices[0]
          ['text']; //responseBody["choices"][0]["text"];
    } else {
      // Handle errors, e.g., print an error message or throw an exception
      print("Error: ${response.statusCode}");
      return "Error occurred";
    }
  }
}
