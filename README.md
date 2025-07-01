# population-crowth

Logistic regression for monome crow.

![](population-crowth.gif)

The dynamical system xn=rx−1(1−x−1) known as the logistic map. It oscillates between two points when 3≤r≤3.44949, four and more points when 3.44949≤r≤3.56995 and is chaotic when 3.56995<r<4.

![](https://upload.wikimedia.org/wikipedia/commons/0/09/Feigenbaum_Tree.gif)

The function is a real classic in study of systems, and connected to early climate research and populations (of corvids too). I believe that is something lines people can appreciate. From [Wikipedia](https://en.wikipedia.org/wiki/Logistic_map):

> The map was initially utilized by Edward Lorenz in the 1960s to showcase properties of irregular solutions in climate systems. It was popularized in a 1976 paper by the biologist Robert May in part as a discrete-time demographic model analogous to the logistic equation written down by Pierre François Verhulst.

This script exposes the interesting range of r from 3 to 4, set via crow input 2.

Inspired really by [KlangauKöln’s *Logistic Equation* module](https://xn--klangbaukln-zfb.de/2022/12/03/logistic-equation-and-cv-triggerdelay/). Also thank you [Wikipedia](https://en.wikipedia.org/wiki/Logistic_map).

## Documentation

    → 1  clock
    → 2  r
      1 value t      →
      2 value t_{-1} →
      3 value t_{-2} →
      4 value t_{-3} →

This is a druid script, ie. a script running directly on crow and not on norns. Run or upload to crow with [druid](https://monome.org/docs/crow/druid/), or use [bowering](https://llllllll.co/t/bowering-a-crow-script-loader-for-norns/71797) from norns as I do.

Give clock to crow input 1, and set r with input 2. Output 1 is the current output, and the three older values cascade from output 1 towards 4 before falling off, kind of like a shift register. Alternative ideas for outputs 2-4 are welcome.

There are a few [public variables](https://monome.org/docs/crow/reference/#public) if you are into that sort of thing. bowering visualizes then.
