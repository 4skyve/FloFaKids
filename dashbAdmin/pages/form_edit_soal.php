<?php
$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'questions_en' : 'questions';
$id   = $_GET['id'] ?? '';
$row  = $id ? fb_get_one($coll, $id) : null;
$err  = '';
if (!$row) { header("Location: ?page=soal"); exit; }

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $opts = [
        trim($_POST['opt0'] ?? ''),
        trim($_POST['opt1'] ?? ''),
        trim($_POST['opt2'] ?? ''),
        trim($_POST['opt3'] ?? ''),
    ];
    $level = (int)($_POST['level'] ?? 1);
    if ($level < 1) $level = 1;

    $data = [
        'question' => trim($_POST['question'] ?? ''),
        'options'  => $opts,
        'answer'   => (int)($_POST['answer'] ?? 0),
        'level'    => $level,
    ];
    if (empty($data['question'])) { $err = 'Pertanyaan wajib diisi.'; }
    elseif (fb_update($coll, $id, $data)) {
        header("Location: ?page=soal&msg=edit&lang=$lang"); exit;
    } else { $err = 'Gagal mengupdate data.'; }
}

$opts  = $row['options'] ?? ['','','',''];
$pOpts = isset($_POST['opt0'])
    ? [$_POST['opt0'],$_POST['opt1'],$_POST['opt2'],$_POST['opt3']]
    : $opts;
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
                <h6>
                    <i class="bi bi-pencil-square text-warning me-2"></i>
                    Edit Soal — <i class="bi bi-translate me-1"></i><?= strtoupper($lang) ?>
                </h6>
            </div>
            <div style="padding:24px;">
                <?php if ($err): ?><div class="alert alert-danger"><?= $err ?></div><?php endif; ?>
                <form method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Pertanyaan <span class="text-danger">*</span></label>
                        <textarea name="question" class="form-control" rows="3" required><?= htmlspecialchars($_POST['question'] ?? $row['question'] ?? '') ?></textarea>
                    </div>
                    <?php for ($i = 0; $i < 4; $i++): ?>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Opsi <?= $i+1 ?></label>
                        <input type="text" name="opt<?= $i ?>" class="form-control"
                               value="<?= htmlspecialchars($pOpts[$i] ?? '') ?>">
                    </div>
                    <?php endfor; ?>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Jawaban Benar <span class="text-danger">*</span></label>
                        <select name="answer" class="form-select" required>
                            <?php for ($i = 0; $i < 4; $i++): ?>
                                <option value="<?= $i ?>" <?= (int)($_POST['answer'] ?? $row['answer'] ?? 0)===$i?'selected':'' ?>>
                                    Opsi <?= $i+1 ?> — <?= htmlspecialchars($opts[$i] ?? '') ?>
                                </option>
                            <?php endfor; ?>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            Level <span class="text-danger">*</span>
                            <small class="text-muted fw-normal ms-1">(angka, contoh: 1, 2, 3, 4, dst)</small>
                        </label>
                        <input type="number" name="level" class="form-control" min="1" required
                               value="<?= htmlspecialchars($_POST['level'] ?? $row['level'] ?? '1') ?>"
                               style="max-width:120px;">
                        <div class="form-text">
                            <i class="bi bi-info-circle me-1"></i>
                            Isi level sesuai tingkat kesulitan 
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning fw-bold">
                            <i class="bi bi-save me-1"></i>Update
                        </button>
                        <a href="?page=soal&lang=<?= $lang ?>" class="btn btn-outline-secondary">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>