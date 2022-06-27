# 1375-communication-channel-random-timing

Finora ho sempre modellato canali di comunicazione in cui il sender e receiver inviavano e ricevevano con un tempo fissato. Nella realtà il tempo non è fissato e conosco al più il tempo medio. In questo modello vediamo quindi come implementare il canale di comunicazione con un tempo medio di invio e di ricezione.

Il sender alternerà periodi in cui è idle a periodi in cui invia. Una cosa simile l'abbiamo già vista nei processi software (1200, 1240).
Immaginiamo quindi di avere un automa con due stati:

1. idle
2. invio

Ogni stato avrà due archi uscenti, uno che rientra nello stato corrente e uno che passa allo stato successivo. Ogni arco ha una probabilità di essere scelto. Come negli esempi precedenti la somma delle probabilità sugli archi uscenti dello stato corrente deve essere 1.

![alt text](Images/2.png)

Faccio una transizione ogni $T$ secondi. Il tempo di soggiorno sarà quindi:

$$
S = \frac{T}{1-p}
$$

Notare in **sender.mo** che il tempo è in _secondi_. Se il tempo fosse stato in _millisecondi_ la catena di Markov non sarebbe cambiata, ma il sender avrebbe avuto **1000 occasioni in più di inviare**. Questo perché ogni $T$ secondi faccio una sample.

> NOTA: mettere T=1000 non è gratuito. Questo perché bisognerà poi aumentare l'orizzonte di simulazione di 1000 volte per avere lo stesso plot di T=1. Se con T=1 l'orizzonte di simulazione era 50, con T=1000 dovrà essere di 50000.
