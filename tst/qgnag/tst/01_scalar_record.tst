gap> START_TEST("qgnag: scalar and record converters");
gap> # --- Escalares: enteros ---
gap> CppQuoInt(17, 5);
3
gap> # --- Escalares: flotantes ---
gap> CppSumVectorDouble([2.1, -3, 4, 10]);
13.1
gap> # --- Records ---
gap> r := rec(x := 1, y := 2);;
gap> HasRecordField(r, "x");
true
gap> HasRecordField(r, "z");
false
gap> GetRecordField(r, "y");
2
gap> SetRecordField(r, "z", 99);;
gap> r.z;
99
gap> # --- Strings ---
gap> CppRemoveCharacters("hello world", "lo");
"he wrd"
gap> STOP_TEST("scalar_record.tst");