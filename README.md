# WAMP

**WAMP** project is an auto-installer of WAMP server units for 32- and 64-bit 
windows platforms.

It's useful if you need to have installed bunch of **Apache + PHP + MySQL** 
on your windows system quickly. Note that only Windows 7 SP1, Vista SP2, 
8 / 8.1, 10, Server 2008 SP2 / R2 SP1, Server 2012 / R2, Server 2016 are 
supported.


## Installation

Firstly download this repository on your local drive. Once you have the **WAMP** 
root direcotry, download
[wamp.zip](https://drive.google.com/open?id=0B_8B-dFXY5lBU0tjM0FLMmlqLUE) and 
unzip it to **WAMP\distrib** subdirectory.

The **wamp.zip** consists of command line **unzip.exe** and two corresponding 
archives: **WAMPx64.zip** and **WAMPx86.zip**. The **wamp.bat** script will 
select appropriate zip-file automatically.
	
>Note: Each zip-file has minimal set of necessary files to start WAMP server. 
You may want to build your own kit.


## Usage

```
wamp.bat install
'''

or

```
wamp.bat uninstall
'''

>Note: The installer uses **D:\HOST** as root directory for WAMP. You may 
change it by editing the **wamp.bat** script.
