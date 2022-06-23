block Monitor1
  InputTrafficLightSignal w; // stato del semaforo
  InputReal CarSpeed;        // velocità della macchina
  OutputBoolean z;           // per segnalare l'errore

  Boolean error;

  initial equation
    // inizializzo il flag di errore a false
    z = false;

  // Req: if traffic light is red then car speed shall be 0.

  equation
    // error = (TrafficLightSignal.red == w) and (CarSpeed <> 0) ;
    // se il semaforo è rosso e la mia velocità non è zero
    // NOTA: evitiamo il test di uguaglianza sui reali in quanto potrebbe portare problemi di precisione
    error = (TrafficLightSignal.red == w) and (abs(CarSpeed) > 1E-2); // 1E-2 = 10^-2 = 0.01

  algorithm
    when edge(error) then
      z := true; // sustain: una volta trovato un errore, non tornerà mai più a false
    end when;
end Monitor1;