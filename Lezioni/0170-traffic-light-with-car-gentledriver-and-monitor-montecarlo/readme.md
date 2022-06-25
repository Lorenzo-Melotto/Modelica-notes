# 0170-traffic-light-with-car-gentledriver-and-monitor-montecarlo

Il traffic driver di 0160 e degli esempi precedenti non guida in maniera realistica: o schiaccia l'acceleratore fino al 50% o frena di colpo al 100%.

Lavoriamo quindi sul file **driver.mo**, implementando una accelerazione e una frenata di tipo graudale, con due coefficienti personalizzabili (`Driver.a` e `Driver.b`).

Passiamo quindi allo script **montecarlo.py**. Con i valori del freno tra 1.1 e 2.0 mi rendo conto che non freno abbastanza e con alcuni parametri della macchina la simulazione fallisce. Devo quindi aumentare il valore minimo del coefficiente per il freno. Mi rendo conto che scegliendo un valore compreso tra 2.0 e 3.0 non ho più problemi. A questo punto provo con 100 test, poi con 1000 magari, per verificare che non ci siano ancora problemi.

Notiamo anche come i test ci facciano fare design, ovvero in base ai parametri che fanno fallire i vari test, andiamo a modificare i parametri del nostro sistema in modo da capire cosa può funzionare e cosa no. In questo esempio ci siamo accorti che il valore `700000` per il parametro `MaxBreak` non era abbastanza, quindi è stato aumentato a `1000000`, andando effettivamente a lavorare sul design del sistema.

Questo modo di procedere prende il nome di **test-driven design**.

Finita questa fase di test posso eseguire dei test particolarmente complessi generati da un esperto.
