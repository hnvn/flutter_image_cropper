int int32(int i) {
  if (i == null)
    return i;
  else
    return (i & 0x7fffffff) - (i & 0x80000000);
}
