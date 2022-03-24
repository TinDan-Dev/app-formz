mixin ObjectComparable implements Comparable<Object> {
  @override
  int compareTo(Object other) => identityHashCode(this).compareTo(identityHashCode(other));
}
