class ApiResponse<T> {
  final String message;
  final String httpStatus;
  final T data;
  final String? errorCode;

  const ApiResponse({
    required this.message,
    required this.httpStatus,
    required this.data,
    this.errorCode,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ApiResponse(
      message: json['message'] ?? '',
      httpStatus: json['httpStatus'] ?? '',
      errorCode: json['errorCode'],
      data: fromJsonT(json['data'] as Map<String, dynamic>),
    );
  }
}