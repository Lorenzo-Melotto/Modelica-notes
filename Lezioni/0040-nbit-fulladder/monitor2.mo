class Monitor2

  parameter Real T = 0.1;

  SysParameters p;

  InputBoolean a[p.n];
  InputBoolean b[p.n];
  InputBoolean carry_in;
  InputBoolean y[p.n];
  InputBoolean carry[p.n];
  InputBoolean carry_out;

  OutputBoolean z;
class Monitor2

  /* 
    Avremmo pututo creare il monitor come per l'esempio precendete (0030)
    andando a controllare il risultato bit a bit del full adder ma sarebbe
    stato molto più difficile da leggere. Quello che facciamo invece è
    andare a convertire i vettori booleani in numeri interi ed andare
    a controllare la somma dei numeri interi.
   */

  parameter Real T = 0.1;

  SysParameters p;

  // tutti gli input del sistema
  InputBoolean a[p.n];
  InputBoolean b[p.n];
  InputBoolean carry_in;
  InputBoolean y[p.n];
  InputBoolean carry[p.n];
  InputBoolean carry_out;

  OutputBoolean z; // variabile del monitor per segnalare l'errore

  Integer A, B, Sum;
  Boolean S[p.n + 1]; // output del full adder compreso il carry out (+1)

  initial equation
    z = false;

  algorithm
    when sample(0, T) then
      // conversione di A in intero tenendo conto del carry_in
      if (carry_in) // se ho già un resto, vuol dire che il numero A che sto considerando deve essere incrementato di 1
      then
        A := bool2int(a)+1;
      else
        A := bool2int(a); // se invece carry in è false, A è semplicemente il numero intero in binario
      end if;

      B := bool2int(b); // conversione di B in intero

      // metto nel vettore S i bit di output di ogni FA
      for i in 1:p.n loop
        S[i] := y[i];
      end for;

      S[p.n + 1] := carry_out; // aggiungo il carry_out
      Sum := bool2int(S); // conversione del vettore S in intero

      // se la somma è diversa da A + B, allora scatta il flag z che indica che è avvenuto un errore
      if (Sum <> A + B)
      then
        z:= true;
      end if;
    end when;
    
end Monitor2;

  Integer A, B, Sum;

  Boolean S[p.n + 1];

  initial equation
    z = false;

  algorithm


    when sample(0, T) then

      if (carry_in) // se ho già un resto, vuol dire che il numero A che sto considerando deve essere incrementato di 1
      then
        A := bool2int(a)+1;
      else
        A := bool2int(a); // se invece carry in è false, A è semplicemente il numero intero in binario
      end if;

      B := bool2int(b);

      for i in 1:p.n loop
        S[i] := y[i];
      end for;

      S[p.n + 1] := carry_out;
      Sum := bool2int(S);

      // se la somma è diversa da A + B, allora scatta il flag z che indica che è avvenuto un errore
      if (Sum <> A + B)
      then
        z:= true;
      end if;

    end when;


end Monitor2;
