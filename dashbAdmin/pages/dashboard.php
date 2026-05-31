<?php
$fauna_all = array_merge(fb_get_all('fauna'), fb_get_all('fauna_en'));
$flora_all = array_merge(fb_get_all('flora'), fb_get_all('flora_en'));
$soal_all  = array_merge(fb_get_all('questions'), fb_get_all('questions_en'));

$recent_fauna = array_slice(fb_get_all('fauna'), 0, 4);
$recent_flora = array_slice(fb_get_all('flora'), 0, 4);
$recent_soal  = array_slice(fb_get_all('questions'), 0, 4);
?>

<div class="mb-4">
    <div style="font-size:22px;font-weight:800;color:#0f172a;">
        <i class="bi bi-hand-wave text-warning"></i>
        Halo, <?= htmlspecialchars($_SESSION['username']) ?>!
    </div>
    <div style="font-size:13px;color:#94a3b8;margin-top:3px;">
        Selamat datang kembali di panel admin FloFaKids.
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7;">
                <i class="bi bi-bug-fill" style="color:#16a34a;font-size:20px;"></i>
            </div>
            <div>
                <div class="stat-val"><?= count($fauna_all) ?></div>
                <div class="stat-lbl">Total Fauna (ID + EN)</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#dbeafe;">
                <i class="bi bi-flower2" style="color:#1d4ed8;font-size:20px;"></i>
            </div>
            <div>
                <div class="stat-val"><?= count($flora_all) ?></div>
                <div class="stat-lbl">Total Flora (ID + EN)</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#fef9c3;">
                <i class="bi bi-question-circle-fill" style="color:#a16207;font-size:20px;"></i>
            </div>
            <div>
                <div class="stat-val"><?= count($soal_all) ?></div>
                <div class="stat-lbl">Total Soal (ID + EN)</div>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
    <!-- Fauna Terbaru -->
    <div class="col-lg-4">
        <div class="content-card h-100">
            <div class="card-header-custom">
                <h6><i class="bi bi-bug-fill text-success me-2"></i>Fauna Terbaru</h6>
                <a href="?page=fauna" class="btn btn-sm btn-outline-success btn-action">Semua</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Gambar</th><th>Nama</th></tr></thead>
                    <tbody>
                    <?php foreach ($recent_fauna as $r): ?>
                        <tr>
                            <td>
                                <?php if (!empty($r['imagePath'])): ?>
                                    <img src="<?= fb_storage_url($r['imagePath']) ?>"
                                         class="img-thumb"
                                         onerror="this.outerHTML='<div class=\'img-placeholder\'><i class=\'bi bi-bug\' style=\'color:#94a3b8\'></i></div>'">
                                <?php else: ?>
                                    <div class="img-placeholder">
                                        <i class="bi bi-bug" style="color:#94a3b8;"></i>
                                    </div>
                                <?php endif; ?>
                            </td>
                            <td style="font-weight:600;"><?= htmlspecialchars($r['title'] ?? '—') ?></td>
                        </tr>
                    <?php endforeach; ?>
                    <?php if (empty($recent_fauna)): ?>
                        <tr><td colspan="2" class="text-center text-muted py-3">Belum ada data.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Flora Terbaru -->
    <div class="col-lg-4">
        <div class="content-card h-100">
            <div class="card-header-custom">
                <h6><i class="bi bi-flower2 text-primary me-2"></i>Flora Terbaru</h6>
                <a href="?page=flora" class="btn btn-sm btn-outline-success btn-action">Semua</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Gambar</th><th>Nama</th></tr></thead>
                    <tbody>
                    <?php foreach ($recent_flora as $r): ?>
                        <tr>
                            <td>
                                <?php if (!empty($r['imagePath'])): ?>
                                    <img src="<?= fb_storage_url($r['imagePath']) ?>"
                                         class="img-thumb"
                                         onerror="this.outerHTML='<div class=\'img-placeholder\'><i class=\'bi bi-flower2\' style=\'color:#94a3b8\'></i></div>'">
                                <?php else: ?>
                                    <div class="img-placeholder">
                                        <i class="bi bi-flower2" style="color:#94a3b8;"></i>
                                    </div>
                                <?php endif; ?>
                            </td>
                            <td style="font-weight:600;"><?= htmlspecialchars($r['title'] ?? '—') ?></td>
                        </tr>
                    <?php endforeach; ?>
                    <?php if (empty($recent_flora)): ?>
                        <tr><td colspan="2" class="text-center text-muted py-3">Belum ada data.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Soal Terbaru -->
    <div class="col-lg-4">
        <div class="content-card h-100">
            <div class="card-header-custom">
                <h6><i class="bi bi-question-circle-fill text-warning me-2"></i>Soal Terbaru</h6>
                <a href="?page=soal" class="btn btn-sm btn-outline-success btn-action">Semua</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Pertanyaan</th><th>Lv</th></tr></thead>
                    <tbody>
                    <?php foreach ($recent_soal as $r): ?>
                        <tr>
                            <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:500;">
                                <?= htmlspecialchars($r['question'] ?? '—') ?>
                            </td>
                            <td>
                                <?php $lv = (int)($r['level'] ?? 0); ?>
                                <span class="badge badge-lv<?= $lv ?>">Lv<?= $lv ?></span>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    <?php if (empty($recent_soal)): ?>
                        <tr><td colspan="2" class="text-center text-muted py-3">Belum ada data.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>