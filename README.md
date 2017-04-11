# spaceapi-bot
Ein irssi bot, damit man den Zustand des Hackerspaces der über die SpaceAPI bekannt gegeben wird auch direkt im IRC abfragen und ändern kann.


## Installation:

### Im Dateisystem des irssi Users:

**via Bash:**
```bash

cd ~/.irssi/
git clone https://github.com/see-base/spaceapi-bot.git
mkdir scripts
ln -s ~/.irssi/spaceapi-bot/spaceapibot.pl ~/.irssi/scripts/spaceapibot.pl
mkdir scripts/autojoin
ln -s ~/.irssi/spaceapi-bot/spaceapibot.pl ~/.irssi/scripts/autojoin/spaceapibot.pl
```

**die Konfiguration anpassen**
Die Datei ``example.token.ini`` in ``token.ini`` ändern und die Token anpassen.

### In irssi:
```
/script load spaceapibot.pl
```
