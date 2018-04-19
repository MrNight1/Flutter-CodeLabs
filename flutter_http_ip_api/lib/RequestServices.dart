import 'dart:io';
import 'dart:convert';

class RequestServices{
  var url;

  String _result;
  var _response;
  var _jsonString;

  RequestServices({this.url});

  String get result => _result;
  get jsonString => _jsonString;
  get response => _response;

  doRequest(String method) async{
    var httpClient;
    var request;
    bool success = false;

    httpClient = new HttpClient();
    try{
      if(method == 'put')
        request = await httpClient.putUrl(Uri.parse(url));
      else if(method == 'get')
        request = await httpClient.getUrl(Uri.parse(url));

      _response = await request.close();

      if (_response.statusCode == HttpStatus.OK) {
        success = true;
        _jsonString = await _response.transform(utf8.decoder).join();
        //print('jsonString: $jsonString');
        if(method == 'put') {
          var data = json.decode(_jsonString);
          _result = data['requestURL'];
          //print('result: $result');
        }
      } else {
        success = false;
        print('Error:\nHttp status ${_response.statusCode}');
      }

    }catch( e ){
      print('Exception: $e');
    }
    return success;
  }
}