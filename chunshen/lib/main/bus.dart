import 'package:chunshen/model/excerpt.dart';

abstract class IExcerptOperationListener {
  onExcerptAdd(ExcerptBean? bean) {}
  onExcerptDelete(ExcerptBean? bean) {}
  onExcerptUpdate(ExcerptBean? bean) {}
}

List<IExcerptOperationListener> _listeners = [];

void addExcerptOperationListener(IExcerptOperationListener listener) {
  _listeners.add(listener);
}

void updateExcerpt(ExcerptBean? excerpt) {
  _listeners.forEach((listener) {
    listener.onExcerptUpdate(excerpt);
  });
}

void addexcerpt(ExcerptBean? excerpt) {
  _listeners.forEach((listener) {
    listener.onExcerptAdd(excerpt);
  });
}

void deleteExcerpt(ExcerptBean? excerpt) {
  _listeners.forEach((listener) {
    listener.onExcerptDelete(excerpt);
  });
}
