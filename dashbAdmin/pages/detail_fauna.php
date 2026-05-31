<?php
$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'fauna_en' : 'fauna';
$id   = $_GET['id'] ?? '';
$row  = $id ? fb_get_one($coll, $id) : null;
if (!$row) { echo '<div class="alert alert-warning">Data tidak ditemukan.</div>'; return; }
?>
<div class="mb-3">
    <a href="?page=fauna&lang=<?= $lang ?>" class="btn btn-sm btn-outline-secondary btn-action">
        <i class="bi bi-arrow-left me-1"></i>Kembali
    </a>
</div>
<div class="row justify-content-center">
    <div class="col-md-7">
        <div class="content-card">
            <div class="card-header-custom">
                <h6>🦁 <?= htmlspecialchars($row['title'] ?? 'Detail Fauna') ?></h6>
                <a href="?page=form_edit_fauna&id=<?= $id ?>&lang=<?= $lang ?>"
                   class="btn btn-sm btn-warning btn-action"><i class="bi bi-pencil me-1"></i>Edit</a>
            </div>
            <div style="padding:24px;">
                <?php if (!empty($row['imagePath'])): ?>
                    <img src="<?= fb_storage_url($row['imagePath']) ?>"
                         style="width:100%;max-height:260px;object-fit:cover;border-radius:12px;margin-bottom:20px;"
                         onerror="this.style.display='none'">
                <?php endif; ?>
                <table class="table table-borderless">
                    <tr>
                        <th style="width:140px;color:#94a3b8;font-size:12px;text-transform:uppercase;">Nama</th>
                        <td style="font-weight:700;"><?= htmlspecialchars($row['title'] ?? '—') ?></td>
                    </tr>
                    <tr>
                        <th style="color:#94a3b8;font-size:12px;text-transform:uppercase;">Nama Ilmiah</th>
                        <td><span class="badge badge-sub"><?= htmlspecialchars($row['subtitle'] ?? '—') ?></span></td>
                    </tr>
                    <tr>
                        <th style="color:#94a3b8;font-size:12px;text-transform:uppercase;">Deskripsi</th>
                        <td style="color:#334155;"><?= nl2br(htmlspecialchars($row['description'] ?? '—')) ?></td>
                    </tr>
                    <tr>
                        <th style="color:#94a3b8;font-size:12px;text-transform:uppercase;">Bahasa</th>
                        <td><?= strtoupper($lang) ?></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>