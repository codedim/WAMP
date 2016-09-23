@echo off
@rem *************************************************************
@rem  " Auto Installer of WAMP units for 32- and 64-bit Windows  "
@rem  " Windows 7..10 + Apache 2.4 + MySQL 5.6 + PHP 5.6 (WAMP)  "
@rem  "   for more info see the following web-page:              "
@rem  "   http://blog.denisbondar.com/post/apache24php56win7     "
@rem *************************************************************
@rem        "change your installation directory here"

set ROOTDIR=D:\HOST
set DISTRIB=%CD%\distrib

@rem *************************************************************

@rem "prevent of unwanted start"
if /i "%1" equ "uninstall" (
	if exist %ROOTDIR% ( goto ROOTEXISTS ) else (
		echo Nothing to uninstall. Bye.
		pause
		exit 0
	)
) else if /i "%1" equ "install" (
	if exist %ROOTDIR% ( goto ROOTEXISTS ) else goto STARTINSTALL
) else if /i "%1" equ "start" (
	net start MySQL
	net start Apache2.4
	pause
	exit 0
) else if /i "%1" equ "stop" (
	net stop Apache2.4
	net stop MySQL
	pause
	exit 0
) else (
	echo " Using:                              " 
	echo " > wamp install|start|stop|uninstall "
	echo.
	pause
	exit 1
)


:ROOTEXISTS
echo The WAMP server root directory '%ROOTDIR%' exists.
echo All appropriate subdirectories will be deleted!
echo.
set /p input="Do you want to continue anyway? (Y/N): "
if /i "%input%" neq "Y" (
	echo Exiting...
	pause
	exit 1
)

echo.
echo The system cleanup...
if exist %ROOTDIR%\mysql (
	%ROOTDIR%\mysql\bin\mysqladmin -u root shutdown
	ping -n 8 localhost > NUL
	echo removing the MySQL service
	%ROOTDIR%\mysql\bin\mysqld.exe --remove
	rmdir /s /q  %ROOTDIR%\mysql
)
if exist %ROOTDIR%\apache (
	%ROOTDIR%\apache\bin\httpd.exe -k stop
	%ROOTDIR%\apache\bin\httpd.exe -k uninstall	
	rmdir /s /q  %ROOTDIR%\apache
)
if exist %ROOTDIR%\php 		rmdir /s /q  %ROOTDIR%\php
if exist %ROOTDIR%\tmp 		rmdir /s /q  %ROOTDIR%\tmp
if exist %ROOTDIR%\log 		rmdir /s /q  %ROOTDIR%\log

if /i "%1" equ "uninstall" ( 
	echo.
	echo Done. Remove the root directory '%ROOTDIR%' manually!
	echo.
	pause
	exit 0
)


:STARTINSTALL
echo.
echo Checking for dependencies...
if not exist %DISTRIB%\unzip.exe (
	echo Error: unzip.exe is missing!
	echo Download and unzip 'wamp.zip' to 'distrib' folder.
	pause
	exit 1
)

echo.
@rem "determine the system architecture"
systeminfo | find "based" > temp.txt
for /f "tokens=2,4" %%f in ('ver') do ( 
	set os=%%f
	set ver=%%g
)
for /f "tokens=3" %%f in (temp.txt) do set base=%%f
for /f "tokens=1,2 delims=." %%f in ("%ver%") do set ver=%%f.%%g
del /q temp.txt

@rem "check the windows version out"
if /i "%os%" neq "Windows" (
	echo Error: Unsupported Platphorm!
	pause
	exit 1
)
@rem "only win 7, 8, 8.1 and 10 are allowed"
if "%ver%" neq "6.1" if "%ver%" neq "6.2" if "%ver%" neq "6.3" (
	@rem "the same thing for windows 10"
	if "%ver%" neq "10.0" (
		echo Error: Unsupported Windows Version!
		pause
		exit 1
))
echo System checking: %os% [%ver%] %base%: OK

@rem "determine if the system is 32- or 64-bit"
if "%base%" equ "x64-based" ( 
	set DISTRZIP=WAMPx64.zip 
) else (
	set DISTRZIP=WAMPx86.zip 
)

echo.
echo Creating work directories...
if not exist %ROOTDIR% 			mkdir %ROOTDIR%
if not exist %ROOTDIR%\tmp 		mkdir %ROOTDIR%\tmp
if not exist %ROOTDIR%\www 		mkdir %ROOTDIR%\www
if not exist %ROOTDIR%\log 		mkdir %ROOTDIR%\log

echo.
echo Extracting archives...
%DISTRIB%\unzip.exe %DISTRIB%\%DISTRZIP% -d %ROOTDIR%

echo.
echo Configuring PHP...
%ROOTDIR%\php\php.exe %DISTRIB%\config.php %ROOTDIR%  "php"

echo.
echo Configuring Apache...
%ROOTDIR%\php\php.exe %DISTRIB%\config.php %ROOTDIR%  "apache"
copy %ROOTDIR%\apache\htdocs\index.html %ROOTDIR%\www

echo.
echo Configuring MySQL...
%ROOTDIR%\php\php.exe %DISTRIB%\config.php %ROOTDIR%  "mysql"

echo.
echo Testing the web-server...
%ROOTDIR%\apache\bin\httpd.exe -k install
sc config Apache2.4 start= demand
%ROOTDIR%\apache\bin\httpd.exe -k start
echo.
start explorer http://localhost
echo ** You have to see 'It works!' in your web-browser.
pause

echo.
echo Testing the php module...
copy %DISTRIB%\index.php %ROOTDIR%\www
echo.
start explorer http://localhost/index.php
echo ** You have to see 'PHP Info' in your web-browser.
pause

echo.
echo Testing the sql-server...
%ROOTDIR%\mysql\bin\mysqld.exe --install
sc config MySQL start= demand
net start MySQL
%ROOTDIR%\mysql\bin\mysqladmin.exe ping
echo.
echo ** You have to see 'mysqld is alive' in the line above.
pause

echo *************************************************************
echo.
echo Congrats!
echo.
echo If all three tests above are OK, you may be sure that all 
echo WAMP units (Apache 2.4 + MySQL 5.6 + PHP 5.6) are installed 
echo and working correctly. Go to the '%ROOTDIR%\WWW' directory 
echo to develop your HTML and PHP files.
echo.
echo Note that the web and sql servers have installed as windows 
echo services and configured to 'start on demand' mode. So they 
echo will not startup you reboot the computer. You might switch 
echo them to 'start auto' mode or use 'start' and 'stop' options 
echo when you exactly need them.
echo.
echo As well remember that your sql-server has no password for 
echo root user. Start DB console '%ROOTDIR%\mysql\bin\mysql.exe' 
echo and use the following sql command to set the password:
echo.
echo  SET PASSWORD FOR 'root'@'localhost' = PASSWORD('NewPass');
echo.
echo *************************************************************
echo.
pause
exit 0
