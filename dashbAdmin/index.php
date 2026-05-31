<?php
ob_start();

require 'cek.php';
require 'koneksi.php';

$page = $_GET['page'] ?? 'dashboard';

$allowed = [
    'dashboard',
    'fauna',  'detail_fauna',  'form_tambah_fauna',  'form_edit_fauna',
    'flora',  'detail_flora',  'form_tambah_flora',  'form_edit_flora',
    'soal',   'detail_soal',   'form_tambah_soal',   'form_edit_soal',
];

if (!in_array($page, $allowed)) $page = 'dashboard';
?>

<?php include 'templates/header.php'; ?>
<?php include 'templates/sidebar.php'; ?>

<div class="main">
    <div class="content">
        <?php include "pages/$page.php"; ?>
    </div>
    <?php include 'templates/footer.php'; ?>
</div>

<?php
ob_end_flush();
?>