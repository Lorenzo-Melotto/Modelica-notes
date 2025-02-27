block Car

  // throttle = accelerazione della macchina

  // max acceleration = 10 seconds to go from 0 tp 100Km/h (Ford Mondeo)
  // a = velocty/time = 100/(10/3600) = 360*100 = 36000 (Km/h^2) =
  // speed in meters per second = 100*1000/3600 = 1000/36 = 27.78 m/s velocity
  // accelelration in m/s^2 = 27.78/10 = 2.78 m/s^2  (g = 9.8 m/s^2).

  // Breaking: how many meters to go from 100 Km/h to 0: (Frod Mustang) :  34 meters.
  // Max deceleration:

  // parametri della macchina
  parameter Real Mass = 1500;  // peso della macchina in kg
  parameter Real MaxAcceleration = 36000;  // max possible acceleration in Km/h^2 
  parameter Real Friction = 300000;
  parameter Real MaxThrottle = Mass*MaxAcceleration;  // max possible force (rough)
  parameter Real MaxBreak = 36000;  // max possible force (rough), frenata massima

  InputReal throttle;  // real number on [0, 1], quanto sto accelerando
  InputReal brake;  // real number on [0, 1], quanto sto frenando
  OutputReal x;  // car position
  OutputReal v;  // car velocity

  initial equation
    // inizialmente la macchina è ferma al punto iniziale x = 0
    x = 0;
    v = 0;

  equation
    /* 
     Throttle = Force = Mass * Accelleration = m * a
     a = der(velocity) = Force/Mass = throttle/m
     velocity = der(x)
     considering 
    */
    // l'accelerazione è la derivata prima della velocità
    der(v) = MaxAcceleration*throttle  - (MaxBreak/Mass)*brake*v - (Friction/Mass)*v;   // MaxThrottle*throttle/M = MaxAcceleration*throttle
    // la velocità è la derivata della posizione
    der(x) = v;
end Car;