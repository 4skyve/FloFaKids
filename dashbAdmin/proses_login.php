<?php
session_start();
require 'koneksi.php';

if (!isset($_POST['login'])) {
    header("Location: login.php"); exit;
}

$username = trim($_POST['username']);
$password = $_POST['password'];

$users = fb_get_all('admin_users');

$found = null;
foreach ($users as $u) {
    if (($u['username'] ?? '') === $username) {
        $found = $u; break;
    }
}

if (!$found) {
    header("Location: login.php?error=user"); exit;
}

if (!password_verify($password, $found['password'] ?? '')) {
    header("Location: login.php?error=password"); exit;
}

$_SESSION['username'] = $found['username'];
$_SESSION['uid']      = $found['__id'];
header("Location: index.php");
exit;