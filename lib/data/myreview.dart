import 'database.dart';
import 'package:moor/moor.dart';

part 'myreview.g.dart';

class MyReview extends Table {
  IntColumn? get id => integer().autoIncrement()();
  RealColumn? get stars => real()();
  TextColumn? get category => text().withLength(min: 1, max: 20)();
  TextColumn? get categoryDetail => text().withLength(max: 30)();
  TextColumn? get title => text().withLength(min: 1, max: 30)();
  TextColumn? get content => text()();
  TextColumn? get imagepath => text()();
  DateTimeColumn? get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

@UseDao(tables: [MyReview])
class MyReviewDao extends DatabaseAccessor<Database> with _$MyReviewDaoMixin {
  MyReviewDao(Database db) : super(db);

  Future<List<MyReviewData>> getAllData() => select(myReview).get();

  Stream<List<MyReviewData>> streamMyReviews() => select(myReview).watch();

  Stream<MyReviewData> streamMyReview(int id) =>
      (select(myReview)..where((tbl) => tbl.id.equals(id))).watchSingle();

  Stream<List<MyReviewData>> streamMyReviewsByCategory(String text) =>
      (select(myReview)..where((tbl) => tbl.category.equals(text))).watch();

  Future<List<MyReviewData>> futureMyReviewsByCategory(String text) =>
      (select(myReview)..where((tbl) => tbl.category.equals(text))).get();

  Future insertMyReview(MyReviewCompanion data) => into(myReview).insert(data);

  Future updateMyReview(MyReviewCompanion data) =>
      update(myReview).replace(data);

  Future deleteMyReviewById(int id) =>
      (delete(myReview)..where((tbl) => tbl.id.equals(id))).go();
}
