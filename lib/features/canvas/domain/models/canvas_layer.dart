class CanvasLayer {
  final String id;
  final String projectId;
  final String name;
  final int orderIndex;
  final bool isVisible;
  final bool isLocked;
  final double opacity;

  const CanvasLayer({
    required this.id,
    required this.projectId,
    required this.name,
    required this.orderIndex,
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
  });

  CanvasLayer copyWith({
    String? id,
    String? projectId,
    String? name,
    int? orderIndex,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
  }) {
    return CanvasLayer(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'name': name,
        'orderIndex': orderIndex,
        'isVisible': isVisible,
        'isLocked': isLocked,
        'opacity': opacity,
      };

  factory CanvasLayer.fromJson(Map<String, dynamic> json) => CanvasLayer(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        name: json['name'] as String,
        orderIndex: json['orderIndex'] as int,
        isVisible: json['isVisible'] as bool? ?? true,
        isLocked: json['isLocked'] as bool? ?? false,
        opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      );
}
