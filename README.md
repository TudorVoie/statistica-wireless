<center>
  <h1>Statistica wireless /  wireless statistics </h1>
</center>

[RO](#RO)
[EN](#EN)

## RO
Folosirea unui Raspberry Pi (sau orice alt dispozitiv echipat cu o antenta wireless care ruleaza Linux) pentru a crea o statistica a retelelor wireless din jur. Pe scurt, face un recesnamant.
Colecteaza date precum SSID, adresa MAC, canal, frecventa, daca este sau nu parolata reteaua si cel mai important, producatorul echipamentului.
<br>
<br>
<b> Instalare: </b>
<br>
Se descarca zip cu proiectul, se dezarhiveaza si se ruleaza in consola ```sudo bash install.sh``` cu argumentele: numele interfetei de retea (ex wlan0) si SSID-ul retelei de acasa, care va pune pe pauza scanarea. De exemplu: ```sudo bash install.sh wlan0 TP-Link_2AB3CD```
<br>
<br>
<b> Dependinte necesare: </b> ```bash systemd NetworkManager curl jq netcat```
<br>
<br>
<b> Cum functioneaza: </b>
Atunci cand dispozitivul se deconecteaza de la internet, programul va incepe sa caute retele wireless odata la 20 de secunde, pe care la va salva. La conectarea inapoi la internet, in reteaua de acasa, aparatul va genera un fisier ```wifi_scan.json``` cu toate datele colectate si apoi se va genera o pagina web cu datele respective. Un web server va actiona pe portul 80 cu pagina respectiva.

<br>

## EN
Use a Raspberry Pi (or any other device equipped with a wireless antenna and runs Linux) to create a page with statistics of wireless networks around. For short, it makes a census.
Collects data like SSID, MAC address, channel, frequency, if network is password protected, and most importantly, the device manufacturer.
<br>
<br>
<b> Installation: </b>
<br>
Download project zip, unzip it and run in the terminal the command ```sudo bash install.sh``` with the arguments: name of network interface (eg wlan0) and home SSID, so it will know when to stop. For example: ```sudo bash install.sh wlan0 TP-Link_2AB3CD```
<br>
<br>
<b> Necessary dependencies: </b> ```bash systemd NetworkManager curl jq netcat```
<br>
<br>
<b> How it works: </b>
When the device disconnects from the internet, it will start scanning for wireless networks every 20 seconds. Upon reconnecting to the internet, in the home network, the device will generate a file named ```wifi_scan.json``` with all collected data. From this, an html page will be generated for easier viewing and a webs erver will fire up on port 80 with the page to see.
