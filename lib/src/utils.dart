///
/// A helper function that forces a int value into a 32-bit number.
///
/// In Dart, a int number can be a 32-bit or 64-bit number, it's dynamic to use
/// just enough memory to store an integer number value. It's flexible but not
/// explict, especially when these number values need to pass through a platform
/// channel into other platforms that store number values in different and more
/// explict types such as Java. A int number in Dart can be converted to an integer
/// or a long number in Java according to its bit length, a 32-bit int number in
/// Dart is converted to an integer number and the 64-bit one is going to be a
/// long number in Java. The unclear converting in the platform channel lets to
/// ClassCastException in Java sometimes. This function will ensures that a int
/// value int Dart codes is 32-bit number and it will be a integer number in Java
/// codes.
///
int int32(int i) {
  if (i == null)
    return i;
  else
    return (i & 0x7fffffff) - (i & 0x80000000);
}
