import 'package:bloc_crud_sqlite/models/student.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static final DatabaseProvider instace = DatabaseProvider._init();
  static Database? _db;

  List<Student> allStudents = [];

  String search = '';

  DatabaseProvider._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase('students.db');
    return _db!;
  }

  Future<Database> _useDatabase(String filePath) async {
    //sqfliteFfiInit();
    //databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasesPath();
    await deleteDatabase(join(dbPath, 'students.db'));

    return await openDatabase(join(dbPath, 'students.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE students (id INTERGER PRIMARY KEY NOT NULL, name TEXT, email TEXT, phone TEXT, payment REAL, password TEXT, note TEXT, active TEXT)');
    }, version: 1);
  }

  List<Student> get filteredStudentsByName {
    if (search.isEmpty) {
      return filteredStudentsByRel.toList();
    } else {
      return filteredStudentsByRel
          .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
  }

  List<Student> get filteredStudentsByRel {
    if (filteredActive) {
      return allStudents.where((s) => s.active == '1').toList();
    } else if (filteredNotActive) {
      return allStudents.where((s) => s.active == '0').toList();
    } else {
      return List<Student>.from(allStudents);
    }
  }

  bool filteredActive = false;
  bool filteredNotActive = false;

  Future<List<Student>> listStudents() async {
    final db = await instace.db;
    final result = await db.rawQuery('SELECT * FROM students ORDER BY id');
    allStudents = result.map((json) => Student.fromJson(json)).toList();
    return allStudents;
  }

  Future<Student> save(Student student) async {
    final db = await instace.db;

    final id = await db.rawInsert(
        'INSERT INTO students(name, email, phone, payment, password, note, active) VALUES(?,?,?,?,?,?,?)',
        [
          student.name,
          student.email,
          student.phone,
          student.payment,
          student.password,
          student.note,
          student.active
        ]);

    return student.clone(id: id);
  }

  Future<Student> update(Student student) async {
    final db = await instace.db;
    await db.rawUpdate(
        'UPDATE students SET name = ?, email = ?, phone = ?, payment = ?, password = ?, note = ?, active = ?',
        [
          student.name,
          student.email,
          student.phone,
          student.payment,
          student.password,
          student.note,
          student.active
        ]);

    return student;
  }

  Future<int> delete(int studentId) async {
    final db = await instace.db;
    final result = await db.rawDelete('DELETE FROM students WHERE id = ?', [studentId]);

    return result;
  }

  Future<int> deleteAll() async {
    final db = await instace.db;
    final result = await db.rawDelete('DELETE FROM students');

    return result;
  }

  Future close() async {
    final db = await instace.db;
    db.close();
  }
}
