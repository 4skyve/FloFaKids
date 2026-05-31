<?php
session_start();
if (isset($_SESSION['username'])) {
    header("Location: index.php"); exit;
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — FloFaKids Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f2f7; font-family: 'Segoe UI', sans-serif; }
        .card { border: none; border-radius: 14px; box-shadow: 0 4px 24px rgba(0,0,0,0.09); }
        .brand-icon { width:48px;height:48px;
                      display:flex;align-items:center;justify-content:center;
                      font-size:22px;margin:0 auto 12px; }
        .btn-primary { background:#22c55e;border-color:#22c55e; }
        .btn-primary:hover { background:#16a34a;border-color:#16a34a; }
        a { color:#22c55e; }
    </style>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="card p-4" style="width:380px;">
        <div class="text-center mb-3">
            <div class="brand-icon">🌿</div>
            <h5 class="fw-bold mb-0">FloFaKids Admin</h5>
            <!-- <p class="text-muted" style="font-size:.85rem;">Masuk ke panel admin</p> -->
        </div>

        <?php if (isset($_GET['error'])): ?>
            <div class="alert alert-danger py-2" style="font-size:.875rem;">
                <?= $_GET['error'] === 'password' ? 'Password salah!' : 'Username tidak ditemukan!' ?>
            </div>
        <?php endif; ?>
        <?php if (isset($_GET['logout'])): ?>
            <div class="alert alert-success py-2" style="font-size:.875rem;">Berhasil logout.</div>
        <?php endif; ?>

        <form method="post" action="proses_login.php">
            <div class="mb-2">
                <label class="form-label mb-1" style="font-size:.875rem;">Username</label>
                <input type="text" name="username" class="form-control form-control-sm" required autofocus>
            </div>
            <div class="mb-3">
                <label class="form-label mb-1" style="font-size:.875rem;">Password</label>
                <input type="password" name="password" class="form-control form-control-sm" required>
            </div>
            <div class="d-grid">
                <button type="submit" name="login" class="btn btn-primary btn-sm">
                    <i class="bi bi-box-arrow-in-right me-1"></i>Login
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>