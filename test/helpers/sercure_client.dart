import 'package:common/common.dart';

class SecureClient implements IHttpClient {
  final IHttpClient client;
  final String token;
  SecureClient(this.client, this.token);

  @override
  Future<HttpResult> get(String url, {Map<String, String> headers}) async {
   
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token;
    return await client.get(url, headers: modifiedHeader);
  }

  @override
  Future<HttpResult> post(String url, String body,
      {Map<String, String> headers}) async {
    
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token;
    modifiedHeader['Content-Type'] = "application/json";
    return await client.post(url, body, headers: modifiedHeader);
  }
}