import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
  });
  void arrangeArticles() {
    when(() => mockNewsService.getArticles().then((_) async { [
          Article(title: "title", content: "content"),
          Article(title: "title2", content: "content2"),
          Article(title: "title3", content: "content3"),
        ];
    }));
  }
  void arrangeArticlesafter2Seconds() {
    when(() => mockNewsService.getArticles().then((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return [
      Article(title: "title", content: "content"),
      Article(title: "title2", content: "content2"),
      Article(title: "title3", content: "content3"),
    ];
    }));
  }
  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    "description",
    (WidgetTester tester) async {
      arrangeArticles();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("News"), findsOneWidget);
    },
  );
}
