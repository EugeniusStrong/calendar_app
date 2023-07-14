import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'note_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  static const notesTable = 'CalendarWithNotes';
  static const columnId = 'id';
  static const columnDescription = 'description';
  static const columnRemainingDate = 'remainingDate';

  /// Ленивая инициализация базы данных.
  ///
  /// Инициализация происходит через геттер "database",который используется для доступа
  /// к базе данных "_database". При первом вызове, если база данных = null, идет обращение
  /// к методу _initDB(), который создает базу данных и далее оно будет использоваться
  /// при последующих вызовах геттера.
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  /// Создание базы данных.
  ///
  /// Сначала определяем директорию, где будет храниться база данных, с помощью функции getApplicationDocumentsDirectory().
  /// Затем формируем путь к базе данных, используя уже полученную директорию и задаем имя для базы данных.
  /// Функция openDatabase() открывает базу данных или создает новую, если она не была создана.
  /// В нее необходимо передать путь, созданный ранее. Указать версию. Передать функцию для для создания таблиц.
  Future<Database?> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/NewCalendarWithNotes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  /// Создание таблиц в базе данных.
  ///
  /// Метод представляет собой SQL-запрос для создания таблицы, с указанием имени таблицы,
  /// и имени столбцов в этой таблице.
  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $notesTable'
        '($columnId TEXT PRIMARY KEY,'
        ' $columnDescription TEXT,'
        ' $columnRemainingDate TEXT,');
  }

  /// Получение списка заметок(объектов NoteModel) из базы данных.
  ///
  /// Получаем экземпляр базы данных и через SQL-запрос с помощью метода "query()",
  /// добавлям все записи из таблицы "notesTable" в Map-список "notesMapList".
  /// Далее через цикл for-in для каждого элемента notesMapList,
  /// создается объект NoteModel с помощью статического метода fromMap и добавляется в
  /// Мар-список notesList.
  Future<List<NoteModel>> getNotes() async {
    Database? db = await database;
    final List<Map<String, dynamic>> notesMapList = await db!.query(notesTable);
    final List<NoteModel> notesList = [];
    for (var noteMap in notesMapList) {
      notesList.add(NoteModel.fromMap(noteMap));
    }
    return notesList;
  }

  /// Удаление записи из базы данных по заданному идентификатору.
  ///
  /// Получаем экземпляр базы данных и через SQL-запрос с помощью метода "delete()",
  /// удаляем запись, указывая имя таблицы, условие "where",для удаления конкретной
  /// заметки с заданным идентификатором и идентификатор в "whereArgs" для подстановки его значения в условие.
  Future<int> deleteNote(String id) async {
    Database? db = await database;
    return await db!.delete(
      notesTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  /// Создание или обновления заметки в базе данных.
  ///
  /// Получаем экземпляр базы данных. Создаем экземпляр NoteModel с переданными параметрами
  /// (id, description, remainingDate). Через SQL-запрос с помощью метода "insert()",
  /// указываем таблицу "notesTable", в которую производится вставка и экземпляр NoteModel,
  /// из которого с помощью метода toMap(), передаем данные модели в виде Map.
  ///  В данном случае используется ConflictAlgorithm.replace, что означает, что
  ///  если запись с таким идентификатором уже существует, она будет заменена новой записью,
  ///  что позволяет, как выполнить сохранение новой записи, так и обновить уже имеющуюся,
  ///  с помощью более компактного кода.
  Future<void> insertOrUpdate(
      String id, String description, DateTime remainingDate) async {
    final model = NoteModel(id, description, remainingDate);
    Database? db = await database;
    await db!.insert(notesTable, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
