-- TODO try the fmta() function for readability
return {
  s(
    {
      trig = "testfile", 
      dscr = "Test file",
    },
    { 
      t({ 
        "import 'package:flutter_test/flutter_test.dart';" ,
        "import 'package:mocktail/mocktail.dart';",
        "",
        "void main() {group('$",
      }),
      i(1),
      t({
        "', () {",
        "",
        "});}",
      }),
    }
  )
}
