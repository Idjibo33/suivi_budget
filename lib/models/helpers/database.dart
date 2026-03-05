abstract class DatabaseServices<T> {
  Future createData(T item);
  Future updateData(String id, T item);
  Future deleteData(String id);
  Stream readData(String id);
}
