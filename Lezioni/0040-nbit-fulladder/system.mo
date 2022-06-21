class System

    Environment env;
    SUV  mysuv;
    Monitor m;
    Monitor2 m2;

    equation
        // connessione dell'environment al SUV
        connect(env.a, mysuv.a);
        connect(env.b, mysuv.b);
        connect(env.carry_in, mysuv.carry_in);

        // connessione dell'environment e del SUV al monitor1
        connect(env.a, m.a);
        connect(env.b, m.b);
        connect(env.carry_in, m.carry_in);
        connect(mysuv.y, m.y);
        connect(mysuv.carry_out, m.carry_out);
        connect(mysuv.carry, m.carry);

        // connessione dell'environment e del SUV al monitor2
        connect(env.a, m2.a);
        connect(env.b, m2.b);
        connect(env.carry_in, m2.carry_in);
        connect(mysuv.y, m2.y);
        connect(mysuv.carry_out, m2.carry_out);
        connect(mysuv.carry, m2.carry);

end System;
