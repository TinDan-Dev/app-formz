typedef ValidationFunc<T> = bool Function(T? value);

// General

ValidationFunc<T> notNull<T>() => (value) => value != null;

ValidationFunc<T> equals<T>(T test) => (value) => value == test;

// Iterables

ValidationFunc<T> getLength<T extends Iterable>(ValidationFunc<int> func) => (value) {
      if (value == null) {
        return false;
      }
      return func(value.length);
    };

ValidationFunc<T> notEmpty<T extends Iterable>() => (value) {
      if (value == null) {
        return false;
      }
      return value.isNotEmpty;
    };

// String

ValidationFunc<String> stringNotEmpty() => (value) => value != null && value.trim().isNotEmpty;

ValidationFunc<String> regexMatches({required RegExp regex}) => (value) {
      if (value == null) {
        return false;
      }
      return regex.hasMatch(value);
    };

ValidationFunc<String> getStringLength(ValidationFunc<int> func) => (value) {
      if (value == null) return false;
      return func(value.length);
    };

// Numbers

ValidationFunc<T> inRange<T extends num>({T? min, T? max}) => (value) {
      if (value == null) {
        return false;
      }
      if (min != null && value < min) {
        return false;
      }
      if (max != null && value > max) {
        return false;
      }
      return true;
    };

ValidationFunc<T> isGreater<T extends num>({required T min}) => (value) {
      if (value == null) {
        return false;
      }
      return value > min;
    };

ValidationFunc<T> isSmaller<T extends num>({required T max}) => (value) {
      if (value == null) {
        return false;
      }
      return value < max;
    };

// Booleans

ValidationFunc<bool> isTrue() => (value) => value == true;

ValidationFunc<bool> isFalse() => (value) => value == false;
