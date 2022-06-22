function myrandom
  //input Integer seed;
  output Real result;
  // funzione C che genera un numero casuale nel range [0;1]
  external "C" result = myrandom(); // sfrutto quindi la funzione myrandom() definita in C 
  annotation(Include = "#include \"myextlib.c\"");
end myrandom;