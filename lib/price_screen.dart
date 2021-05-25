import 'dart:convert';
import 'dart:io' show Platform;

import 'package:btc_tracker/coin_data.dart';
import 'package:btc_tracker/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String cryptoBTC = 'BTC';
  String cryptoETH = 'ETH';
  String cryptoLTC = 'LTC';
  double btcValue = 0;
  double ethValue = 0;
  double ltcValue = 0;
  dynamic result;

  void fetchFromNetwork(String crypto, fiat) async {
    if (crypto == 'BTC') {
      result = await NetworkHelper().getCryptoValues(crypto, fiat);
      setState(() {
        btcValue = jsonDecode(result.body)['rate'];
        print(btcValue);
      });
    } else if (crypto == 'ETH') {
      result = await NetworkHelper().getCryptoValues(crypto, fiat);
      setState(() {
        ethValue = jsonDecode(result.body)['rate'];
      });
    } else if (crypto == 'LTC') {
      result = await NetworkHelper().getCryptoValues(crypto, fiat);
      setState(() {
        ltcValue = jsonDecode(result.body)['rate'];
      });
    }
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) async {
        // await fetchFromNetwork(crypto, value);
        setState(() {
          selectedCurrency = value;
          // if (result != null) {
          //   cryptoValue = jsonDecode(result.body)['rate'];
          // }
        });
      },
    );
  }

  CupertinoPicker iosPickerMenu() {
    selectedCurrency = currenciesList[0];

    List<Text> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      dropDownItems.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 40.0,
      children: dropDownItems,
      onSelectedItemChanged: (selectedIndex) async {
        //await fetchFromNetwork('BTC', 'USD');
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 18.0, .0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cryptoCards(),
              ),
            ),
            Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: iosPickerMenu()),
          ],
        ),
      ),
    );
  }

  List<Widget> cryptoCards() {
    List<Widget> cardList = [];
    for (String cryptos in cryptoList) {
      fetchFromNetwork(cryptos, selectedCurrency);
      cardList.add(Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '${cardText(cryptos)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ));
    }
    return cardList;
  }

  String cardText(String crypto) {
    if (crypto == 'BTC') {
      return '1 $crypto = $btcValue $selectedCurrency';
    } else if (crypto == 'ETH') {
      return '1 $crypto = $ethValue $selectedCurrency';
    } else if (crypto == 'LTC') {
      return '1 $crypto = $ltcValue $selectedCurrency';
    }
  }
}
