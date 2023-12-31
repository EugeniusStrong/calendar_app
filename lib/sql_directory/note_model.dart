class NoteModel {
  final String? id;
  final String? description;
  final DateTime remainingDate;

  NoteModel({
    this.id,
    this.description,
    required this.remainingDate,
  });

  /// Преобразование полей класса в формат ключ-значение.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'remainingDate': remainingDate.toIso8601String(),
    };
  }

  /// Извлечение данных из базы данных.
  ///
  /// Фабричный конструктор, который позволяет создать экземпляр класса
  /// NoteModel на основе данных из Map.
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      description: map['description'],
      remainingDate: DateTime.parse(map['remainingDate']),
    );
  }

  /// Копирование с изменением.
  ///
  /// copyWith() создает и возвращает новый экземпляр NoteModel с возможностью изменения
  /// значений id, description и remainingDate. Применяется для создания копии
  /// объекта с изменением только некоторых полей, оставив остальные значения без изменений.
  NoteModel copyWith(
      {String? id, String? description, DateTime? remainingDate}) {
    return NoteModel(
      id: id ?? this.id,
      description: description ?? this.description,
      remainingDate: remainingDate ?? this.remainingDate,
    );
  }
}
