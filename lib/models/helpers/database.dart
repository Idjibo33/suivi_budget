abstract class Databaseervices<T> {
  Future createData(T item);
  Future updateData(String id, T item);
  Future deleteData(String id);
  Stream readData(String id);
}
