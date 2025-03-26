class Display {
  final String id;
  final String detail;
  final String imageUrl;
  final String name;
  final int timestamp;

  Display({
    required this.id,
    required this.detail,
    required this.imageUrl,
    required this.name,
    required this.timestamp,
  });

  factory Display.fromMap(Map<String, dynamic> map) {
    return Display(
      id: map['id'],
      detail: map['detail'],
      imageUrl: map['imageUrl'],
      name: map['name'],
      timestamp: map['timestamp'],
    );
  }
}
