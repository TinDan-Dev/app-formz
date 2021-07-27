extension ObjectExtension<T> on T? {
  S fold<S>(S ifNull(), S ifSome(T some)) {
    if (this == null)
      return ifNull();
    else
      return ifSome(this as T);
  }

  S? let<S>(S? ifSome(T some)) {
    if (this != null)
      return ifSome(this as T);
    else
      return null;
  }

  T or(T value) {
    if (this != null)
      return this as T;
    else
      return value;
  }

  T? orOther(T? value) {
    if (this != null)
      return this as T;
    else
      return value;
  }
}
