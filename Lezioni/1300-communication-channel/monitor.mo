block MonitorReq1
  /*
    Output sequence is equal to input sequence
  */

  parameter Integer N = 100;

  InputBoolean readsignal;      // segnale di lettura, mandato dal receiver
  InputBoolean writesignal;     // segnale di scrittura, mandato dal sender
  InputInteger inputdata;       // dati da inviare come input alla FIFO da parte del sender
  InputInteger outputdata;      // dati ricevuti dalla FIFO da parte del receiver
  InputBoolean datavailable;    // segnale che indica che sulla FIFO sono presenti dati da leggere
  InputBoolean spaceavailable;  // segnale che indica che sulla FIFO è disponibile spazio per scrivere

  Integer newestinput;
  Integer oldestinput;
  Integer InputBuffer[N];  

  Boolean error;

  algorithm
    // utilizzo l'edge per monitorare gli eventi
    when initial() then
      error := false;    // all'inizio non c'è nessun errore
      newestinput := 0;  // where to write, all'inizio scriviamo dalla posizione 0
      oldestinput := 0;  // where to read, all'iniizo leggiamo dalla posizione 0

      // reset del buffer di input
      for i in 1:N loop 
        InputBuffer[i] := 0; 
      end for;

    /* 
      Dobbiamo considerare tutti i casi possibili di ricezione dei segnali, spazio disponibile e dati disponibili:
       1) Ricezione di lettura e scrittura insieme, vanno controllati i segnali spaceavailable e datavailable
       2) Ricezione di lettura e scrittura insieme, nel caso in cui la coda non abbia dati da leggere
       3) Ricezione di lettura e scrittura insieme, nel caso in cui la coda non abbia spazio per scrivere
       4) Ricezione di lettura con dati disponibili
       5) Ricezione di scrittura con spazio disponibile
     */

    // 1) evento di lettura e scrittura in contemporanea, devo controllare entrambi i segnali spaceavailable e datavailable
    elsewhen (edge(readsignal) and edge(writesignal) and 
              pre(spaceavailable) and pre(datavailable)) then
      // read and write
      error := pre(error) or not(InputBuffer[pre(oldestinput) + 1] == outputdata); // va preso il messaggio più vecchio e vedere se è uguale all'output

      // gestisco la coda come un array circolare
      // modulo per gestire la coda come un array circolare, se il valore di newestinput è maggiore di N allora devo ripartire da 0 
      oldestinput := mod(pre(oldestinput) + 1, N); // aggiornamento di dove devo andare a leggere
      newestinput := mod(pre(newestinput) + 1, N); // aggiornamento di dove devo andare a scrivere
      InputBuffer[newestinput + 1] := inputdata;   // scrivo il dato sul buffer, il +1 serve perché in Modelica gli array partono da 1

    // 2) evento di lettura e scrittura in contemporanea, nel caso in cui la coda non abbia dati da leggere, quindi scrivo soltanto
    elsewhen (edge(readsignal) and edge(writesignal) and
              pre(spaceavailable) and not(pre(datavailable))) then
      // just write
      InputBuffer[pre(newestinput) + 1] := inputdata;
      newestinput := mod(pre(newestinput) + 1, N);

    // 3) evento di lettura e scrittura in contemporanea, nel caso in cui la coda non abbia spazio per scrivere, quindi leggo soltanto
    elsewhen (edge(readsignal) and edge(writesignal) and
              not(pre(spaceavailable)) and pre(datavailable)) then 
      // we can only read,

      error := pre(error) or not(InputBuffer[pre(oldestinput) + 1] == outputdata); // va preso il messaggio più vecchio e vedere se è uguale all'output
      oldestinput := mod(pre(oldestinput) + 1, N);
    // 4) evento di sola lettura con dati disponibili
    elsewhen (edge(readsignal) and not(edge(writesignal)) and pre(datavailable)) then
      // we read
      error := pre(error) or not(InputBuffer[pre(oldestinput) + 1] == outputdata); // va preso il messaggio più vecchio e vedere se è uguale all'output
      oldestinput := mod(pre(oldestinput) + 1, N);

    // 5) evento di sola scrittura con spazio disponibile
    elsewhen (not(edge(readsignal)) and edge(writesignal) and pre(spaceavailable)) then
      // we write
      InputBuffer[pre(newestinput) + 1] := inputdata;
      newestinput := mod(pre(newestinput) + 1, N);
    end when;
end MonitorReq1;