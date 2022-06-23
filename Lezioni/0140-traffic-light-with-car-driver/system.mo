class System
  Car q;           // macchina
  Driver u;        // pilota
  TrafficLight tl; // semaforo

  equation
    // le connessioni vanno messe sempre all'interno di equazioni
    connect(u.throttle, q.throttle);  // driver actuates throttle
    connect(u.brake, q.brake);        // driver actuates brake
    connect(tl.x, u.w);               // driver senses traffic light
end System;