typedef CorrectionFunction<T> = T Function(T value);

CorrectionFunction<T> correctInRange<T extends num>({T? min, T? max}) => (value) {
      if (min != null && value < min) {
        return min;
      }
      if (max != null && value > max) {
        return max;
      }
      return value;
    };
