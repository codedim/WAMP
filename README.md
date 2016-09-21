# WAMP

**WAMP** project is an auto-installer of WAMP server units for 32- and 64-bit 
Windows platforms.

It's useful if you need to have installed bunch of "**Apache 2.4 + MySQL 5.6 + 
PHP 5.6**" on your windows system quickly. Only **Windows 7 SP1, Vista SP2, 
8 / 8.1, 10, Server 2008 SP2 / R2 SP1, Server 2012 / R2, Server 2016** are 
supported.


## Installation

Firstly download this repository on your local drive. Once you have the **WAMP** 
root direcotry, download
[wamp.zip](https://drive.google.com/open?id=0B_8B-dFXY5lBU0tjM0FLMmlqLUE) and 
unzip it to **WAMP\distrib** subdirectory.

The **wamp.zip** consists of command line **unzip.exe** application and two 
corresponding archives: **WAMPx64.zip** and **WAMPx86.zip**. The **wamp.bat** 
script will select appropriate zip-file automatically.
	
>Note: Each zip-file has a minimal set of necessary files to start WAMP server. 
You may want to build your own kit.


## Usage

>Note: The installer uses **D:\HOST** as root directory for the server. You 
may change it by editing **ROOTDIR** in **wamp.bat**.

To install the **WAMP** server run:

```
wamp.bat install
```

When you have the **WAMP** installed you get all the server stuff in one 
place:

```
 D:\HOST\
         |___ apache\
         |___ log\
         |___ mysql\
         |___ php\
         |___ tmp\
         |___ www\

```

In addition web and sql servers have been installed as Window services: 
**Apache24** and **MySQL**.

To uninstall the server run:

```
wamp.bat uninstall
```

>Note: The **www** subdirectory will not be deleted. So save your work and 
delete it manually.
