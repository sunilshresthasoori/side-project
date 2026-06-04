class FilterRequest {
  final String search;
  final List<FilterCriterionRequest> filterCriteriaRequests;
  final PaginationRequest paginationRequest;

  const FilterRequest({
    this.search = '',
    this.filterCriteriaRequests = const [],
    required this.paginationRequest,
  });

  Map<String, dynamic> toJson() => {
    'search': search,
    'filterCriteriaRequests':
    filterCriteriaRequests.map((e) => e.toJson()).toList(),
    'paginationRequest': paginationRequest.toJson(),
  };
}

class FilterCriterionRequest {
  final String key;
  final String value;

  const FilterCriterionRequest({required this.key, required this.value});

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
  };
}

class PaginationRequest {
  final int page;
  final int size;
  final String? sortBy;

  const PaginationRequest({
    required this.page,
    required this.size,
    this.sortBy,
  });

  Map<String, dynamic> toJson() => {
    'page': page,
    'size': size,
    'sortBy': sortBy,
  };
}

class PaginatedResponse<T> {
  final String message;
  final String status;
  final List<T> data;
  final int page;
  final int size;
  final int total;
  final int totalPages;

  const PaginatedResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.page,
    required this.size,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PaginatedResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class DestinationImageResponse {
  final String imageUrl;
  final String? description;
  final String? altMessage;
  final int? displayOrder;

  const DestinationImageResponse({
    required this.imageUrl,
    this.description,
    this.altMessage,
    this.displayOrder,
  });

  factory DestinationImageResponse.fromJson(Map<String, dynamic> json) {
    return DestinationImageResponse(
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'],
      altMessage: json['altMessage'],
      displayOrder: json['displayOrder'] ?? json['order'],
    );
  }
}

class DestinationResponse {
  final int id;
  final String name;
  final String destinationType;
  final String? altitude;
  final String? latitude;
  final String? longitude;
  final String? description;
  final String? province;
  final String? district;
  final String? localLevel;
  final String? primaryAccessCity;
  final String? distanceFromAccessCity;
  final List<DestinationImageResponse> images;
  final List<String> highlights;

  const DestinationResponse({
    required this.id,
    required this.name,
    required this.destinationType,
    this.altitude,
    this.latitude,
    this.longitude,
    this.description,
    this.province,
    this.district,
    this.localLevel,
    this.primaryAccessCity,
    this.distanceFromAccessCity,
    this.images = const [],
    this.highlights = const [],
  });

  factory DestinationResponse.fromJson(Map<String, dynamic> json) {
    return DestinationResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      destinationType: json['destinationType'] ?? '',
      altitude: json['altitude'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      province: json['province'],
      district: json['district'],
      localLevel: json['localLevel'],
      primaryAccessCity: json['primaryAccessCity'],
      distanceFromAccessCity: json['distanceFromAccessCity'],
      images: (json['images'] as List? ?? [])
          .map((e) => DestinationImageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      highlights: (json['highlights'] as List? ?? []).map((e) => '$e').toList(),
    );
  }
}

class DestinationDetailResponse extends DestinationResponse {
  final String? region;

  const DestinationDetailResponse({
    required super.id,
    required super.name,
    required super.destinationType,
    super.altitude,
    super.latitude,
    super.longitude,
    super.description,
    super.province,
    super.district,
    super.localLevel,
    super.primaryAccessCity,
    super.distanceFromAccessCity,
    super.images,
    super.highlights,
    this.region,
  });

  factory DestinationDetailResponse.fromJson(Map<String, dynamic> json) {
    return DestinationDetailResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      destinationType: json['destinationType'] ?? '',
      altitude: json['altitude'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      province: json['province'],
      district: json['district'],
      localLevel: json['localLevel'],
      primaryAccessCity: json['primaryAccessCity'],
      distanceFromAccessCity: json['distanceFromAccessCity'],
      region: json['region'],
      images: (json['images'] as List? ?? [])
          .map((e) => DestinationImageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      highlights: (json['highlights'] as List? ?? []).map((e) => '$e').toList(),
    );
  }
}