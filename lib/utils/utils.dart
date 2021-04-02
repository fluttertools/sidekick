extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void f(E e, int i)) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}
