import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MpesaService {
  final String businessShortCode = dotenv.env['SHORT_CODE']!;
  final String passkey = dotenv.env['PASSKEY']!;
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;
  final String callbackUrl = dotenv.env[
      'CALLBACK_URL']!; // call back response sent from daraja to another server
  Future<String> getAccessToken() async {
    String url =
        "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
    String credentials =
        base64.encode(utf8.encode('$consumerKey:$consumerSecret'));
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<void> lipaNaMpesa(String phoneNumber, double amount) async {
    String accessToken = await getAccessToken();
    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String password =
        base64.encode(utf8.encode('$businessShortCode$passkey$timestamp'));

    var url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";
    var body = json.encode({
      "BusinessShortCode": businessShortCode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount,
      "PartyA": phoneNumber,
      "PartyB": businessShortCode,
      "PhoneNumber": phoneNumber,
      "CallBackURL": callbackUrl,
      "AccountReference": "Sports Center",
      "TransactionDesc": "Registeration Fee"
    });

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("STK Push sent successfully");
      print(response.body);
    } else {
      throw Exception('Failed to send STK Push');
    }
  }
}
