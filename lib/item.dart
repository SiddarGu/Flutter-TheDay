class Item {
  int id;
  String description;
  DateTime date;

  Item({
    required this.id,
    required this.description,
    required this.date,
  });

  factory Item.fromDatabase(Map<String, dynamic> json) => Item(
        id: json["id"],
        description: json["description"],
        date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      );

  Map<String, dynamic> toDatabase() => {
        "id": id,
        "description": description,
        "date": date.millisecondsSinceEpoch,
      };
}
