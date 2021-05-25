import 'dart:convert';

import 'package:http/http.dart';

class NetworkHelper {
  String _mCrypto, _mFiat;

  Future<dynamic> getCryptoValues(String crypto, fiat) async {
    _mCrypto = crypto;
    _mFiat = fiat;

    // 7AE5B0F0-88E0-451E-A4EB-EF97ACAAA6ED

    String _API = 'https://rest.coinapi.io/v1/exchangerate/'
        '$_mCrypto/$_mFiat?apikey=65F02A63-3ECF-4AB0-8362-4363D2792ABE';
    try {
      return await _getNetworkResponse(_API);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Response> _getNetworkResponse(String mApi) async {
    Response response = await get(mApi);
    if (response.statusCode == 200) {
      print('1 $_mFiat is ${jsonDecode(response.body)['rate']} $_mCrypto');
      return response;
    } else {
      print(response.statusCode);
    }
  }
}
