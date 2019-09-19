import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> data = [];

void main() {
  runApp(MaterialApp(
    home: Cripto(),
  ));
}

// Create a stateful widget
class Cripto extends StatefulWidget {
  @override
  CriptoState createState() => CriptoState();
}

// Create the state for our stateful widget
class CriptoState extends State<Cripto> {
  final String api = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';
  final List<String> currenciesList = [
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'EUR',
    'GBP',
    'HKD',
    'IDR',
    'ILS',
    'INR',
    'JPY',
    'MXN',
    'NOK',
    'NZD',
    'PLN',
    'RON',
    'RUB',
    'SEK',
    'SGD',
    'USD',
    'ZAR'
  ];
  final List<String> cryptoList = [
    'BTC',
    'ETH',
    'LTC',
  ];

  // Function to get the JSON data
  Future<String> getJSONData({String crypto, String currency}) async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(api + crypto + currency),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    // Logs the response body to the console
    print(response.body);

    // To modify the state of the app, use this method
    setState(() {
      // Get the JSON data
      var dataConvertedToJSON = json.decode(response.body);
      // Extract the required part and assign it to the global variable named data
      data.add(dataConvertedToJSON['last'].toString());
    });
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Retrieve JSON Data via HTTP GET"),
      ),
      // Create a Listview and load the data when available
      body: Center(
          child: Column(
        // Stretch the cards in horizontal axis
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            // Read the name field value and set it in the Text widget
            data[0],
            // set some style to text
            style: TextStyle(fontSize: 20.0, color: Colors.lightBlueAccent),
          ),
          Text(
            // Read the name field value and set it in the Text widget
            data[1],
            // set some style to text
            style: TextStyle(fontSize: 20.0, color: Colors.lightBlueAccent),
          ),
          Text(
            // Read the name field value and set it in the Text widget
            data[2],
            // set some style to text
            style: TextStyle(fontSize: 20.0, color: Colors.lightBlueAccent),
          )
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();

    // Call the getJSONData() method when the app initializes
    for (int i = 0; i < cryptoList.length; i++) {
      this.getJSONData(crypto: cryptoList[i], currency: currenciesList[19]);
    }
  }
}
