/* 
  Lo stesso semaforo dell'esempio precedente, ma con T opportunamente converito in ore
 */
block TrafficLight
  parameter Real T = 0.001; // ogni 3.6 secondi
  parameter Real SwitchProbability = 0.1; // probabilità di cambiare stato del semaforo

  OutputTrafficLightSignal x;

  TimerValues p; // valori che si trovano nel file constants.mo
  Integer counter;

  initial equation
    x = TrafficLightSignal.green; // inizialmente il semaforo è verde
    counter = p.GreenTimer; // timer del semaforo verde

  algorithm
    when (sample(0, T) and ((myrandom() <= SwitchProbability))) then
      if (counter <= 0) then
        x := next(pre(x));
      end if;
      counter := UpdateTimer(counter, pre(x));
    end when;
end TrafficLight;