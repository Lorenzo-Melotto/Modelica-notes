# 0110-traffic-light

> NOTA: anche in questo caso non c'è né il monitor né il SUV. Abbiamo solo introdotto il tempo di soggiorno negli stati.

A differenza di [0105](../0105-traffic-light/) qui ho la scelta sui tempi di soggiorno in uno stato del semaforo.

Il tipo enumerativo ([types.mo](types.mo)) è sempre lo stesso, così come la funzione next, definita in [next.mo](next.mo).

Un'importante differenza è la funzione `UpdateTimer`, definita in [update.mo](update.mo), che aggiorna il semaforo sulla base di un contatore che viene decrementato. Il tempo di soggiorno in ogni stato è settato nel file [constants.mo](constants.mo).
