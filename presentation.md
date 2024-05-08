---
title: "Analysis of visual cortical neurons of mice"
author: 
  - Cristian Bargiacchi
  - Christian Mancini
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
marp: true
footer: Statistical Analysis of Network Data 2024
---

![bg left:40% 80%](https://images.ctfassets.net/qr8kennq1pom/universi-3fe6338f32314aa42822b6bc165091b2/77204ff0b1572bebc7cab3161a28c878/university-of-florence-logo?fm=png)

# **Analysis of visual cortical neurons of mice**


<a href="mailto:cristian.bargiacchi@edu.unifi.it">Cristian Bargiacchi</a>
<a href="mailto:christian.mancini1@edu.unifi.it">Christian Mancini</a>
  
https://github.com/cMancio00/sand-2024

---

# Dati

* Il grafo rappresenta la struttura del primo strato della corteccia visiva prefontale di un topo.
* Vengono stimolati dei neuroni (<span style="color: salmon;">piramidali</span>) e si controlla se, dopo la sinapsi con un altro neurone, quest'ultimo tende a <span style="color: green;">promuovere</span> o <span style="color: red;">inibire</span> l'attività neuronale.

---

# Sinapsi

![bg](Plots/neurons.png)

---

# Domande

* Quali sono i neuroni che <span style="color: green;">promuovere</span>/<span style="color: red;">inibire</span> maggiormente l'attività?
* Quali <span style="color: salmon;">piramidali</span> sono coinvolti?
* Che proporzione di <span style="color: green;">promotori</span>/<span style="color: red;">inibitori</span> mi aspetto in una sinapsi?
* Altro da discutere :brain: :rocket:

---

# Simple Random Graph Model

Iniziamo a modellare il nostro grafo tramite un **Simple Random Graph** che, anche se semplice, è una buona base di paragone per altri modelli. (Peggio di così non si può fare :smile:).

Da questo primo modello, simuliamo le misure di centralità per vedere se il modello è adeguato e cosa rappresentano.

:bulb: Il vero valore della statistica è contrassegnato in <span style="color: red;">rosso</span> in ogni simulazione.


---



![bg left fit](Plots/SRG/Pasted%20image.png)
# SRG Betweenes Centrality
  
  Devo mettere le immagini per bene

---

# SRG Densitá

![bg left fit](Plots/SRG/SRG_Degree.svg)

da rivedere le immagini