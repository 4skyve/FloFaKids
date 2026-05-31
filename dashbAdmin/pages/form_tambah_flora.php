<?php
$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'flora_en' : 'flora';
$err  = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = [
        'title'       => trim($_POST['title'] ?? ''),
        'subtitle'    => trim($_POST['subtitle'] ?? ''),
        'description' => trim($_POST['description'] ?? ''),
        'imagePath'   => trim($_POST['imagePath'] ?? ''),
        'order'       => fb_next_order($coll), // otomatis
    ];
    if (empty($data['title'])) {
        $err = 'Nama wajib diisi.';
    } elseif (fb_insert($coll, $data)) {
        header("Location: ?page=flora&msg=tambah&lang=$lang"); exit;
    } else {
        $err = 'Gagal menyimpan ke Firebase.';
    }
}
?>
<div class="mb-3">
    <a href="?page=flora&lang=<?= $lang ?>" class="btn btn-sm btn-outline-secondary btn-action">
        <i class="bi bi-arrow-left me-1"></i>Kembali
    </a>
</div>
<div class="row justify-content-center">
    <div class="col-md-7">
        <div class="content-card">
            <div class="card-header-custom">
                <h6>
                    <i class="bi bi-plus-circle text-primary me-2"></i>
                    Tambah Flora — <i class="bi bi-translate me-1"></i><?= strtoupper($lang) ?>
                </h6>
            </div>
            <div style="padding:24px;">
                <?php if ($err): ?><div class="alert alert-danger"><?= $err ?></div><?php endif; ?>
                <form method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required
                               value="<?= htmlspecialchars($_POST['title'] ?? '') ?>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama Ilmiah</label>
                        <input type="text" name="subtitle" class="form-control"
                               value="<?= htmlspecialchars($_POST['subtitle'] ?? '') ?>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Deskripsi <span class="text-danger">*</span></label>
                        <textarea name="description" class="form-control" rows="4" required><?= htmlspecialchars($_POST['description'] ?? '') ?></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">URL Gambar</label>
                        <input type="text" name="imagePath" class="form-control"
                               placeholder=" "
                               value="<?= htmlspecialchars($_POST['imagePath'] ?? '') ?>">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-1"></i>Simpan
                        </button>
                        <a href="?page=flora&lang=<?= $lang ?>" class="btn btn-outline-secondary">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>