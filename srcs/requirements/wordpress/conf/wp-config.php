<?php

$db_password_file="/run/secrets/db_password";
$db_password = trim(file_get_contents($db_password_file));
if ($db_password === false)
{
	echo "file {$db_password_file} not found";
	exit;
}

define( 'DB_NAME', getenv('WP_DB') );
define( 'DB_USER', getenv('WP_DB_USER') );
define('DB_PASSWORD', "$db_password");
define( 'DB_HOST', getenv('WP_HOST') );
define( 'DB_CHARSET', getenv('WP_CHARSET') );
define( 'DB_COLLATE', '' );

$table_prefix = getenv('WP_PREFIX');

/*Redis Bonus*/
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_CACHE', true);
define('WP_REDIS_DISABLED', false);


/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', true );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
