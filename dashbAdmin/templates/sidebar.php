<?php $page = $page ?? 'dashboard'; ?>
<div class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon">
            <i class="bi bi-tree-fill" style="font-size:17px;color:#fff;"></i>
        </div>
        <div class="brand-text">
            <div class="name">FloFaKids</div>
            <div class="sub">Admin Panel</div>
        </div>
    </div>

    <div class="sidebar-section">Menu</div>
    <nav>
        <a href="?page=dashboard" class="<?= $page === 'dashboard' ? 'active' : '' ?>">
            <i class="bi bi-grid-1x2-fill"></i> Dashboard
        </a>
    </nav>

    <div class="sidebar-section">Konten</div>
    <nav>
        <a href="?page=fauna"
           class="<?= in_array($page, ['fauna','detail_fauna','form_tambah_fauna','form_edit_fauna']) ? 'active' : '' ?>">
            <i class="bi bi-bug-fill"></i> Fauna
        </a>
        <a href="?page=flora"
           class="<?= in_array($page, ['flora','detail_flora','form_tambah_flora','form_edit_flora']) ? 'active' : '' ?>">
            <i class="bi bi-flower2"></i> Flora
        </a>
        <a href="?page=soal"
           class="<?= in_array($page, ['soal','detail_soal','form_tambah_soal','form_edit_soal']) ? 'active' : '' ?>">
            <i class="bi bi-question-circle-fill"></i> Soal
        </a>
    </nav>

    <hr class="sidebar-divider">

    <div class="sidebar-user">
        <div class="avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)) ?></div>
        <div class="info">
            <div class="name"><?= htmlspecialchars($_SESSION['username']) ?></div>
            <div class="role">Admin</div>
        </div>
        <a href="logout.php" class="logout-btn" title="Logout">
            <i class="bi bi-box-arrow-right"></i>
        </a>
    </div>
</div>