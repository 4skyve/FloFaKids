<?php
$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'questions_en' : 'questions';
$id   = $_GET['id'] ?? '';
$row  = $id ? fb_get_one($coll, $id) : null;
if (!$row) { echo '<div class="alert alert-warning">Soal tidak ditemukan.</div>'; return; }

$opts   = $row['options'] ?? [];
$ansIdx = (int)($row['answer'] ?? 0);
$lv     = (int)($row['level'] ?? 1);
?>
<div class="mb-3">
    <a href="?page=soal&lang=<?= $lang ?>" class="btn btn-sm btn-outline-secondary btn-action">
        <i class="bi bi-arrow-left me-1"></i>Kembali
    </a>
</div>
<div class="row justify-content-center">
    <div class="col-md-7">
        <div class="content-card">
            <div class="card-header-custom">
                <h6>❓ Detail Soal</h6>
                <a href="?page=form_edit_soal&id=<?= $id ?>&lang=<?= $lang ?>"
                   class="btn btn-sm btn-warning btn-action"><i class="bi bi-pencil me-1"></i>Edit</a>
            </div>
            <div style="padding:24px;">
                <span class="badge badge-lv<?= $lv ?> mb-3">Level <?= $lv ?></span>
                <p style="font-size:16px;font-weight:700;color:#0f172a;line-height:1.5;">
                    <?= htmlspecialchars($row['question'] ?? '—') ?>
                </p>
                <div class="mb-2" style="font-size:12px;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:.5px;">
                    Pilihan Jawaban
                </div>
                <?php foreach ($opts as $i => $opt): ?>
                    <div class="d-flex align-items-center gap-3 mb-2 p-3 rounded-3"
                         style="background:<?= $i===$ansIdx?'#dcfce7':'#f8fafc' ?>;
                                border:1.5px solid <?= $i===$ansIdx?'#16a34a':'#e2e8f0' ?>;">
                        <span style="width:28px;height:28px;border-radius:8px;flex-shrink:0;
                                     display:flex;align-items:center;justify-content:center;
                                     font-weight:800;font-size:12px;
                                     background:<?= $i===$ansIdx?'#16a34a':'#e2e8f0' ?>;
                                     color:<?= $i===$ansIdx?'#fff':'#64748b' ?>;">
                            <?= chr(65 + $i) ?>
                        </span>
                        <span style="font-weight:<?= $i===$ansIdx?700:500 ?>;color:#0f172a;">
                            <?= htmlspecialchars($opt) ?>
                        </span>
                        <?php if ($i === $ansIdx): ?>
                            <i class="bi bi-check-circle-fill text-success ms-auto"></i>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
                <div class="mt-3" style="font-size:12px;color:#94a3b8;">
                    Bahasa: <strong><?= strtoupper($lang) ?></strong>
                </div>
            </div>
        </div>
    </div>
</div>