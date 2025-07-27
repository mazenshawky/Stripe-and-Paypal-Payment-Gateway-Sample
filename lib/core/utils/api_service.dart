import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post({
    required body,
    required String url,
    required String token,
    String? contentType,
    String tokenType = 'Bearer',
    Map<String, dynamic>? additionalHeaders,
  }) async {
    Map<String, dynamic> headers = {'Authorization': '$tokenType $token'};
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    final response = await dio.post(
      url,
      data: body,
      options: Options(
        headers: headers,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
      ),
    );

    return response;
  }
}
