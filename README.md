# Splashscreen
Staying online in windows

Every 30 seconds moves the mouse one pixel NW-SW alternately to maintain on screen activity. After 5 minutes of inactivity show a splash image on the main screen and black on the other screens. WIN+Z to reopen or close manually. Timings can be cutomised in the config file.

Need to supply your own splash.jpg (for example MS_Win locked screen)
The use-case is to avoid screen lock and having to re-insert password.
Can also maintain the illusion of being continuously online in a WFH scenario.

## Installation
Install Autohotkey (https://www.autohotkey.com/)
Save the ahk-file, config and splash.jpg in any arbitrary directory
Create an exe from the script and include in startup.
