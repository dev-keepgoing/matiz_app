class ApiResponse<T> {
  final bool success;
  final T data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final message = json['data']?['message']; // Optional message in data
    final data = json['data'] ?? {};

    return ApiResponse<T>(
      success: json['success'],
      data: fromJsonT(data),
      message: message,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'data': toJsonT(data),
      if (message != null) 'message': message,
    };
  }
}
