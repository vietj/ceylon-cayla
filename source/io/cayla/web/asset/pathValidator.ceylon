"Validate a path to make sure it does not navigate up in the file system"
shared Boolean pathValidator(String path) {
  variable String p = path;
  while (true) {
    if ((p.size == 2 && p == "..") || p.startsWith("../")) {
      return false;
    } else {
      if (exists index = p.firstIndexWhere((Character element) => element == '/')) {
        p = p.spanFrom(index + 1);
      } else {
        return true;
      }
    }
  }
}