import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

List<String> data = [];
String currency = 'USD';

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
    // Get the JSON data
    var dataConvertedToJSON = json.decode(response.body);
    // Extract the required part and assign it to the global variable named data
    data.add(dataConvertedToJSON['last'].toString());
    setState(() {});
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getCards(),
      )),
    );
  }

  @override
  void initState() {
    super.initState();

    // Call the getJSONData() method when the app initializes
    for (int i = 0; i < cryptoList.length; i++) {
      this.getJSONData(crypto: cryptoList[i], currency: currency);
    }
  }

  List<Widget> getCards() {
    List<Widget> result = [];
    for (int i = 0; i < cryptoList.length; i++) {
      result.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 ${cryptoList[i]} = ${data[i]} $currency',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    result.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? iOSPicker() : androidDropDown(),
    ));
    return result;
  }

  DropdownButton<String> androidDropDown() {
    String currency;
    List<DropdownMenuItem<String>> curr = List<DropdownMenuItem<String>>();
    for (int i = 0; i < currenciesList.length; i++) {
      curr.add(
        DropdownMenuItem(
          child: Text(
            currenciesList[i],
          ),
          value: currenciesList[i],
        ),
      );
    }
    return DropdownButton<String>(
      value: currency,
      items: curr,
      onChanged: (value) {
        currency = value;
        for (int i = 0; i < cryptoList.length; i++) {
          getJSONData(currency: currency, crypto: cryptoList[i]);
          setState(() {});
        }
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerList = List<Text>();
    for (String currency in currenciesList) {
      pickerList.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectdIndex) {
        data.clear();
        currency = currenciesList[selectdIndex];
        for (int i = 0; i < cryptoList.length; i++) {
          this.getJSONData(currency: currency, crypto: cryptoList[i]);
        }
        setState(() {});
      },
      children: pickerList,
    );
  }
}
