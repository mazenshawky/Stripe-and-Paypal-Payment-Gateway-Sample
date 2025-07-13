import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post({
    required body,
    required String url,
    required String token,
    String? contentType,
  }) async {
    final response = await dio.post(
      url,
      data: body,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: contentType ?? Headers.formUrlEncodedContentType,
      ),
    );

    return response;
  }
}
