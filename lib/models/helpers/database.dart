abstract class Databaseervices<T> {
  Future createData(T item);
  Future updateData(int id, T item);
  Future deleteData(int id);
  Stream readData();
}
