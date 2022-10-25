This project mainly exists so the arduino bits can remain a somewhat understandable fork of https://github.com/Juerd/kWh/

But I dumbed down the arduino part because I just want MQTT!

So I added an esp8266. Why not just use the 8266? Because I can't have blocking network traffic while also looking for pulses on the same µC core.

Why not pick an esp32 instead? Hey stop asking difficult questions okay!
