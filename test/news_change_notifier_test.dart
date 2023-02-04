import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
// aaaTest ....
// lorem library for mock data
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;
  setUp(() {
      mockNewsService = MockNewsService();
      sut = NewsChangeNotifier(mockNewsService);
});

  test("initial value", () {
  expect(sut.articles, []);
  expect(sut.isLoading, false);
  });

  group("get articles", () {
    void arrangeArticles(){
      when(()=>mockNewsService.getArticles().then((_)async=>[
        Article(title: "title", content: "content"),
        Article(title: "title2", content: "content2"),
        Article(title: "title3", content: "content3"),
      ]
      ));
    }
    test("get articles fro new service", ()async {
      when(()=>mockNewsService.getArticles().then((_)async=>[]
      ));
      await sut.getArticles();
      verify(()=>mockNewsService.getArticles()).called(1);
    });
    test("get 3 item article", () async{
      arrangeArticles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, [
        Article(title: "title", content: "content"),
        Article(title: "title2", content: "content2"),
        Article(title: "title3", content: "content3"),
      ]);
      expect(sut.isLoading, false);
    });
  });

}