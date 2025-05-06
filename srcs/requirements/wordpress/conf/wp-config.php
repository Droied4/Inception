<?php

$db_password_file="/run/secrets/db_password";
$db_password=file_get_contents($db_password_file);
if ($db_password === false)
{
	echo "file {$db_password_file} not found";
	exit;
}

define( 'DB_NAME', 'mydb' );
define( 'DB_USER', 'deordone') );
define( 'DB_PASSWORD', 'h1234' );
define( 'DB_HOST', 'mariadb:3306' );
define( 'DB_CHARSET', 'utf8') );
define( 'DB_COLLATE', '' );

$table_prefix = 'wp_';
 
/*
define( 'DB_NAME', getenv('WP_DB') );
define( 'DB_USER', getenv('WP_DB_USER') );
define( 'DB_PASSWORD', "$db_password" );
define( 'DB_HOST', getenv('WP_HOST') );
define( 'DB_CHARSET', getenv('WP_CHARSET') );
define( 'DB_COLLATE', '' );
$table_prefix = getenv('WP_PREFIX');
 */
 
/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */

/** Absolute path to the WordPress directory. */
define( 'ABSPATH', '/var/www/html/wordpress' );

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
