import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add interceptors
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add auth token
      final token = await StorageService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        // Handle token expiry - logout user
        await StorageService.clearToken();
        // Navigate to login
      }
      return handler.next(error);
    },
  ));

  return dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // Auth
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await _dio.post('/auth/register', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await _dio.post('/auth/login', data: data);
    return response.data;
  }

  // Farms
  Future<List<dynamic>> getFarms() async {
    final response = await _dio.get('/farms');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createFarm(Map<String, dynamic> data) async {
    final response = await _dio.post('/farms', data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getFarm(String id) async {
    final response = await _dio.get('/farms/$id');
    return response.data['data'];
  }

  // Crops
  Future<List<dynamic>> getCrops({String? farmId}) async {
    final response = await _dio.get('/crops', queryParameters: {
      if (farmId != null) 'farmId': farmId,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createCrop(Map<String, dynamic> data) async {
    final response = await _dio.post('/crops', data: data);
    return response.data['data'];
  }

  // Diagnosis
  Future<Map<String, dynamic>> submitDiagnosis(FormData formData) async {
    final response = await _dio.post('/diagnosis', data: formData);
    return response.data['data'];
  }

  Future<List<dynamic>> getDiagnoses() async {
    final response = await _dio.get('/diagnosis');
    return response.data['data'];
  }

  // Market Prices
  Future<List<dynamic>> getMarketPrices({
    String? commodity,
    String? market,
  }) async {
    final response = await _dio.get('/market/prices', queryParameters: {
      if (commodity != null) 'commodity': commodity,
      if (market != null) 'market': market,
    });
    return response.data['data'];
  }

  // Marketplace
  Future<List<dynamic>> getListings({
    String? cropType,
    String? district,
  }) async {
    final response = await _dio.get('/marketplace/listings', queryParameters: {
      if (cropType != null) 'cropType': cropType,
      if (district != null) 'district': district,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createListing(Map<String, dynamic> data) async {
    final response = await _dio.post('/marketplace/listings', data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getListing(String id) async {
    final response = await _dio.get('/marketplace/listings/$id');
    return response.data['data'];
  }

  // Weather
  Future<Map<String, dynamic>> getWeather({
    required String location,
    bool forecast = false,
  }) async {
    final response = await _dio.get('/weather', queryParameters: {
      'location': location,
      'forecast': forecast,
    });
    return response.data['data'];
  }

  // Learning Content
  Future<List<dynamic>> getLearningContent({
    String? category,
    String? type,
  }) async {
    final response = await _dio.get('/learning/content', queryParameters: {
      if (category != null) 'category': category,
      if (type != null) 'type': type,
    });
    return response.data['data'];
  }

  // Forum
  Future<List<dynamic>> getForumPosts({String? category}) async {
    final response = await _dio.get('/forum/posts', queryParameters: {
      if (category != null) 'category': category,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createForumPost(Map<String, dynamic> data) async {
    final response = await _dio.post('/forum/posts', data: data);
    return response.data['data'];
  }

  // Notifications
  Future<List<dynamic>> getNotifications() async {
    final response = await _dio.get('/notifications');
    return response.data['data'];
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.put('/notifications/$id/read');
  }
}
