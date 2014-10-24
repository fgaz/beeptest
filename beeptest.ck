//costanti
//54.0::second => dur leveltime;
1::minute => dur leveltime;
14 => float maxkmh;
[ 7, 7, 8, 8, 8, 9, 9, 10, 10, 10, 11, 11, 12, 12 ] @=> int levels[];//quante transizioni per ogni livello
0 => int automatico;//se le transizioni per livello vanno determinate automaticamente impostare a 1, se si utilizza la lista sopra impostare a 0
8.5 => float kmh;//velocita iniziale
.5 => float aumento;//di quanto deve aumentare ogni minuto
880.0 => float freqBase;//frequenza dei beep
0.5::second => dur durBeep;//durata dei beep

//varie variabili
0 => int levelup;//bool
0 => int level;//contatore livello
0 => int cycle;//contatore delle transizioni
now => time prevtime;//tempo del livello precedente

//oscillatore e gain
Gain g => dac;
SinOsc s => g;
freqBase => s.freq;



//countdown
//TODO for
freqBase / 2 => s.freq;
1 => g.gain;
durBeep => now;//beep
0 => g.gain;
durBeep * 2 => now;//pausa
1 => g.gain;
durBeep => now;//beep
0 => g.gain;
durBeep * 2 => now;//pausa
1 => g.gain;
durBeep => now;//beep
0 => g.gain;
durBeep * 2 => now;//pausa
freqBase => s.freq;

// infinite time-loop
  while( true ){
    //calcola tutto
    now + ((20/(kmh/3.6))::second) => time later;//calcola il tempo del ciclo
    
    int condition;
    if(automatico){
      now-prevtime>=leveltime => condition;//almeno un minuto per livello
    }else{
      cycle>=levels[level] => condition;//organizzati secondo uno schema preciso
    }
    
    if(condition){//aumenta di livello
      aumento +=> kmh;
      leveltime +=> prevtime;
      1 => levelup;
      level++;//avanza di livello
      0 => cycle;
      //break;
    }else{0 => levelup;}
    //if(kmh>=maxkmh){break;}//tmp
    cycle++;//avanza il contatore delle transizioni
    
    
    //beep
    if ((level==0) && (cycle==1)){//beep di partenza
      1 => g.gain;
      durBeep * 2 => now;
      0 => g.gain;
    }
    if (levelup){//beep di cambio livello
      1 => g.gain;
      durBeep => now;
      0 => g.gain;
      durBeep => now;
      1 => g.gain;
      durBeep => now;
      0 => g.gain;
    }else{//beep normale
      1 => g.gain;
      durBeep => now;
      0 => g.gain;
    }
    
    //debug
    <<<"level,cycle">>>;
    <<<level>>>;
    <<<cycle>>>;
    
    // advance time to next cycle
    later => now;
  }
