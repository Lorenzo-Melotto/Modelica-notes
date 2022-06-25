# 0160-traffic-light-with-car-driver-and-monitor-montecarlo

In Modelica non è possibile definire variabili statiche, come invece è possibile fare in C (vedi [myextlib.c](myextlib.c)) per salvare lo stato precedente della funzione.

Questo esempio è importante anche perché ci mostra come utilizzare uno script in Python insieme a Modelica per fare una simulazione.

Innanzitutto bisogna ristrutturare [run.mos](run.mos).

Lo script che abbiamo visto finora è diviso in tre parti:

1. Tutte le load e caricamento dei file
2. Lancia la simulazione
3. Stampa il grafico

In questa versione invece il nostro approccio è modulare e utilizziamo invece l'istruzione `runScript`.
Dentro [load.mos](load.mos) ho esattamente le stesse cose che avevo prima nei vecchi [run.mos](run.mos), quindi il caricamento dei file e le load (vedi [load.mos](load.mos) e **run.mos di 0150**).

Dentro [simulate.mos](simulate.mos) ci sono semplicemente le istruzioni per lanciare la simulazione. Il comando `simulate` compila e poi lancia la simulazione.

Infine dentro [plot.mos](plot.mos) ho solo le istruzioni per stampare il grafico.

Ho quindi diviso [run.mos](run.mos) in diversi file, in modo da rendere modulare il tutto.

Dentro [build.mos](build.mos) c'è lo script per **compilare la simulazione senza eseguirla**. Se dopo aver generato gli eseguibili volessi simulare, mi basterebbe solo lanciare l'eseguibile [System](System), ma non avrei il grafico, avrei solo i risultati dentro **System_res.mat**. Per vedere correttamente i risultati nel grafico mi basta lanciare [plot.mos](plot.mos).

Ricapitolando, i tre step sono:

1. Load
2. Build (ed eventualmente simulate)
3. Plot dei risultati

## Montecarlo

Grazie alla libreria OMPython, possiamo creare uno script Python che si interfaccia con Modelica. Vedi [montecarlo.py](montecarlo.py) e i commenti.
Grazie a questa libreria posso modificare i parametri di simulazione e lavorare meglio con i dati, testandolo per vedere se con i vari parametri continua a funzionare o in qualche situazione il monitor scatta a 1.

### Passagio dei valori nella simulazione

Riportare nello script i parametri con cui si vuole lavorare:

```python
param1 = 1500.00
param2 = 700000.00
...
paramN = ...
```

Nello script python, nel loop di simulazione, aprire un file chiamato `modelica_rand.in`

```python
for i in range(num_samples):
  with open("modelica_rand.in", "wt") as f:
    ...
...
```

All'interno di questo file vanno scritti i parametri che si vogliono cambiare nel sistema. Questo viene fatto nel seguente modo:

- Generazione dei valori casuali:
  ```python
  with open("modelica_rand.in", "wt") as f:
    rand1 = param1*np.random.uniform(0.8,1.2)
    rand2 = param2*np.random.uniform(0.8,1.2)
    ...
    randN = paramN*np.random.uniform(0.8,1.2)
  ```
  L'istruzione `np.random.uniform(0.8,1.2)` fa si che il parametro originale venga variato di un 20%
- Scrittura dei valori generati all'interno del file `modelica_rand.in`:
  ```python
  ...
  randN = paramN*np.random.uniform(0.8,1.2)
  f.write(f"q.param1={str(rand1)}\nq.param2={str(rand2)}\n ... q.paramN={str(randN)}\n")
  f.flush()
  os.fsync(f) # la sincronizzazione è importante
  ```
  Il nome `q.` viene preso dall'oggetto a cui si volgiono cambiare i valori nel file `system.mo`
- Override dei valori nel file `System`: sempre all'interno del loop, dopo aver scritto i valori, eseguire la seguente operazione:

  ```python
  for i in range(num_samples):
    with open("modelica_rand.in", "wt") as f:
      # scriuttura valori

    os.system("./System -overrideFile=modelica_rand.in >> log") # CRUCIALE
    time.sleep(1.0) # delay importante per evitare condizioni di racing nella riscrittura dei file
  ```

  Passo importantissimo in quanto se saltato, i valori scelti randomicamente non verranno utilizzati nella simulazione.

- Lettura del valore del monitor:

  ```python
  for i in range(num_samples):
    with open("modelica_rand.in", "wt") as f:
      # scriuttura valori

    # override dei valori

    y = omc.sendExpression("val(m1.z, 1.8, \"System_res.mat\")")
  ```

  Spiegazione:

  - `val()` permette di andare a leggere un determinato valore della simulazione;
  - `m1.z` non è nient'altro che il valore del monitor che si trova in `system.mo`;
  - `1.8` sta ad indicare il tempo di simulazione in cui si vuole leggere il valore, in questo caso veso la fine della simulazione in quanto ha come orizzonte 2;
  - `"System_res.mat"` è il file in cui `val()` va a leggere il parametro.

### Contenuto del file `output.txt`

All'interno del file `output.txt` verranno inseriti tutti i valori modificati in ogni test. Avrà la seguente struttura:

```
y[0] = 0.0: PASS with
	Mass = 1450.2132028215444
	MaxBreak = 761690.8581638042
y[1] = 0.0: PASS with
	Mass = 1200.068624890407
	MaxBreak = 644653.1203369151
y[2] = 0.0: PASS with
	Mass = 1288.0535344902678
	MaxBreak = 585854.8065352634
y[3] = 1.0: FAIL with
	Mass = 1311.7561268266027
	MaxBreak = 656757.0035720534
y[4] = 0.0: PASS with
	Mass = 1438.0604845384019
	MaxBreak = 710868.6855209399
y[5] = 0.0: PASS with
	Mass = 1451.516708641977
	MaxBreak = 751861.4601110927
y[6] = ...
```

Questo file ci dirà i valori che sono stati utilizzati per `Mass` e `MaxBreak` e se il test con quei valori è fallito o meno. Questi dati sono estremamente importanti per capire quali valori ci permettono di passare o meno.
