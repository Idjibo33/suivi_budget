abstract class DatabaseRepository {
  Future<void> addData();
  Future<void> editData();
  Future<void> deleteData();
  Future<void> updateData();
}
