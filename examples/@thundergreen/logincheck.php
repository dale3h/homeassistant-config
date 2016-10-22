<?php

function authenticate() {
    global $passwordsettings;

    if ( $_SESSION['login_user'] !== $passwordsettings['AdminUsername'] ) {
        header( 'WWW-Authenticate: Basic realm="Raspberry IP Camera"' );
        header( 'HTTP/1.0 401 Unauthorized' );
        die( '<script type="text/javascript"> document.location = "Login.php"; </script>' );
    }
}

$passwordsettings = parse_ini_file( "/home/pi/RaspberryIPCamera/secret/RaspberryIPCamera.secret" );

session_start();

$username = null;
$password = null;

if ( isset( $_SERVER['PHP_AUTH_USER'] ) && isset( $_SERVER['PHP_AUTH_PW'] ) ) {
  $username = $_SERVER['PHP_AUTH_USER'];
  $password = $_SERVER['PHP_AUTH_PW'];
} elseif ( isset( $_REQUEST['username'] ) && isset( $_REQUEST['password'] ) ) {
  $username = $_REQUEST['username'];
  $password = $_REQUEST['password'];
}

$username_valid = $username && ( $username === $passwordsettings['AdminUsername'] );
$password_valid = $password && password_verify( $password, $passwordsettings['AdminPassword'] );

if ( $username_valid && $password_valid ) {
    $_SESSION['login_user'] = $username;
}

unset( $username, $password, $username_valid, $password_valid );

authenticate();
