<?php
$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'fauna_en' : 'fauna';
$id   = $_GET['id'] ?? '';
$row  = $id ? fb_get_one($coll, $id) : null;
$err  = '';
if (!$row) { header("Location: ?page=fauna"); exit; }

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = [
        'title'       => trim($_POST['title'] ?? ''),
        'subtitle'    => trim($_POST['subtitle'] ?? ''),
        'description' => trim($_POST['description'] ?? ''),
        'imagePath'   => trim($_POST['imagePath'] ?? ''),
        'order'       => (int)($_POST['order'] ?? 0),
    ];
    if (empty($data['title'])) { $err = 'Nama wajib diisi.'; }
    elseif (fb_update($coll, $id, $data)) {
        header("Location: ?page=fauna&msg=edit&lang=$lang"); exit;
    } else { $err = 'Gagal mengupdate data.'; }
}
$v = fn($k) => htmlspecialchars($_POST[$k] ?? $row[$k] ?? '');
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
                <h6> Edit Fauna — <?= $lang==='en'?'🇬🇧 EN':'🇮🇩 ID' ?></h6>
            </div>
            <div style="padding:24px;">
                <?php if ($err): ?><div class="alert alert-danger"><?= $err ?></div><?php endif; ?>
                <form method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required value="<?= $v('title') ?>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama Ilmiah (subtitle)</label>
                        <input type="text" name="subtitle" class="form-control" value="<?= $v('subtitle') ?>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Deskripsi <span class="text-danger">*</span></label>
                        <textarea name="description" class="form-control" rows="4" required><?= $v('description') ?></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Image Path</label>
                        <input type="text" name="imagePath" class="form-control" value="<?= $v('imagePath') ?>">
                        <?php if (!empty($row['imagePath'])): ?>
                            <div class="mt-2">
                                <img src="<?= fb_storage_url($row['imagePath']) ?>"
                                     style="height:80px;border-radius:8px;object-fit:cover;"
                                     onerror="this.style.display='none'">
                            </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Urutan (order)</label>
                        <input type="number" name="order" class="form-control" min="0" value="<?= $v('order') ?>">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning fw-bold"><i class="bi bi-save me-1"></i>Update</button>
                        <a href="?page=fauna&lang=<?= $lang ?>" class="btn btn-outline-secondary">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>