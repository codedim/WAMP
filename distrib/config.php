<?php
/* 
** 	Auto-configuration script for WAMP/LAMP units (Apache, MySQL, PHP).
*/

$main_path = $argv[1]; // main path for unit subdirectories
$unit_name = $argv[2]; // unit name to configure: "apache","php","mysql"

// check out the script arguments
if (!($main_path) || !($unit_name)) 
	die ("Error: The required script argument is not specified!");
$main_path = str_replace("\\", "/", $main_path); // reverce slash in path
if (!file_exists("$main_path/$unit_name")) 
	die ("Error: The directory '$main_path/$unit_name' does not exist!");

// determine the paths to files for auto-configuring
if ($unit_name == "php") {

	$bak_file = "$main_path/php/php.ini.bak";
	if (!copy("$main_path/php/php.ini-development", $bak_file))
		die ("Error: Cannot copy the 'php.ini' file!");
	$new_file = "$main_path/php/php.ini";

} elseif ($unit_name == "apache") {

	$bak_file = "$main_path/apache/conf/httpd.conf.bak";
	$new_file = "$main_path/apache/conf/httpd.conf";
	if (!copy($new_file, $bak_file))
		die ("Error: Cannot copy the 'httpd.conf' file!");

} elseif ($unit_name == "mysql") {

	$bak_file = "$main_path/mysql/my.ini.bak";
	if (!copy("$main_path/mysql/my-default.ini", $bak_file))
		die ("Error: Cannot copy the 'my.ini' file!");
	$new_file = "$main_path/mysql/my.ini";

} else 
	die ("Error: Unsupported unit to configure!");


// find/replace function
function process_line($line, $unit, $path) 
{
	if ($unit == "php") {

		// the paths for extensions and temp files
		$line = str_replace("; extension_dir = \"ext\"", 
			"extension_dir = \"$path/php/ext\"", $line);
		$line = str_replace("; sys_temp_dir = \"/tmp\"", 
			"sys_temp_dir = \"$path/tmp\"", $line);
		// uncomment mysql and openssl libs
		$line = str_replace(";extension=php_mysql.dll", 
			"extension=php_mysql.dll", $line);
		$line = str_replace(";extension=php_mysqli.dll", 
			"extension=php_mysqli.dll", $line);
		$line = str_replace(";extension=php_openssl.dll", 
			"extension=php_openssl.dll", $line);
		// set the time zone for the server
		$line = str_replace(";date.timezone =", 
			"date.timezone = Europe/Moscow", $line);

	} elseif ($unit == "apache") {

		// main path to the server
		$line = str_replace("c:/Apache24", "$path/apache", $line);
		// root server directory
		$line = str_replace("apache/htdocs", "www", $line);
		// server domain name
		$line = str_replace("#ServerName www.example.com:80", 
			"ServerName localhost:80", $line);
		// error log file
		$line = str_replace("logs/error.log", 
			"$path/log/apache-error.log", $line);
		// access log file
		$line = str_replace("logs/access.log", 
			"$path/log/apache-access.log", $line);
		// load php modules before the others
		$line = str_replace("Listen 80", 
			"Listen 80\n\n# load php modules\n" .
			"LoadModule php5_module \"$path/php/php5apache2_4.dll\"\n" . 
			"AddHandler application/x-httpd-php .php\n" .
			"PHPIniDir \"$path/php\"\n", $line);

	} elseif ($unit == "mysql") {

		// path to sql server installation
		$line = str_replace("# basedir = .....", 
			"basedir = $path/mysql", $line);
		// location of data directory
		$line = str_replace("# datadir = .....", 
			"datadir = $path/mysql/data", $line);

	} else {
		echo "Fatal Error: No data to configure!";
	}

	return $line;
}


// the main job
$res = True;
try {

	$fin = fopen($bak_file, "r");
	$fout = fopen($new_file, "w");

	// process new file line by line
	while (!feof($fin)) {
		$line = fgets($fin);
		$line = process_line($line, $unit_name, $main_path);
		fwrite($fout, $line);
	}

} catch (Exception $e) {

	echo "Exception: " . $e->getMessage() . "\n";
	$res = False;

} finally {

	fclose($fin);
	fclose($fout);
	unlink($bak_file);

}

if ($res) echo "The '$unit_name' unit was configured successfully.\n";
?>
