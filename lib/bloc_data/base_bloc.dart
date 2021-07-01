import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<T> {

  final fetcher = PublishSubject<T>();
  dispose() {
    fetcher.close();
  }
}