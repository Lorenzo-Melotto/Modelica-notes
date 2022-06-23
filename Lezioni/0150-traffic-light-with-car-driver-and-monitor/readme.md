# 0150-traffic-light-with-car-driver-and-monitor

Stesso esempio di 0140, ma con l'aggiunta del monitor per controllare gli errori. Il monitor scatta quando il semaforo è rosso e il driver accelera.

> NOTA: nel monitor, all'interno della `equation`, non andiamo a controllare se la velocità è diversa da 0 ma andiamo a vedere se il valore assoluto della velocità è maggiore di una **costante piccola**. Questo viene fatto in quanto il controllo diretto sui reali può portare a dei problemi di precisione e quindi è meglio eseguire un controllo con un _epsilon_ piccolo di errore.

Notiamo dalla simulazione che con il **timer per lo stato arancione impostato a 10** all'interno del file [constants.mo](constants.mo), il driver non ha tempo di fermarsi quando il semaforo transita da verde ad arancione, andando così a violare la condizione nel monitor.
