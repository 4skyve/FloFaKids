<?php
if (isset($_GET['hapus'])) {
    $coll_del = ($_GET['lang'] ?? 'id') === 'en' ? 'fauna_en' : 'fauna';
    fb_delete($coll_del, $_GET['hapus']);
    header("Location: ?page=fauna&msg=hapus&lang=" . ($_GET['lang'] ?? 'id')); exit;
}

$lang = $_GET['lang'] ?? 'id';
$coll = $lang === 'en' ? 'fauna_en' : 'fauna';
$data = fb_get_all($coll);
?>

<div class="content-card">
    <div class="card-header-custom">
        <h6><i class="bi bi-bug-fill text-success me-2"></i>Daftar Fauna</h6>
        <a href="?page=form_tambah_fauna&lang=<?= $lang ?>" class="btn btn-primary btn-sm btn-action">
            <i class="bi bi-plus-lg me-1"></i>Tambah
        </a>
    </div>

    <?php if (isset($_GET['msg'])): ?>
        <div class="alert alert-success alert-dismissible mx-3 mt-3 mb-0">
            <?= ['tambah'=>'Data berhasil ditambahkan!','edit'=>'Data berhasil diperbarui!','hapus'=>'Data berhasil dihapus!'][$_GET['msg']] ?? '' ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <div class="table-toolbar">
        <div class="search-box">
            <i class="bi bi-search si"></i>
            <input type="text" id="searchInput" placeholder="Cari nama...">
        </div>
        <select class="filter-sel" id="perPage">
            <option value="10">10/hal</option>
            <option value="25">25/hal</option>
            <option value="50">50/hal</option>
        </select>
        <div class="ms-auto d-flex gap-2">
            <a href="?page=fauna&lang=id" class="btn btn-sm <?= $lang==='id'?'btn-success':'btn-outline-success' ?> btn-action">
                <i class="bi bi-translate me-1"></i>ID
            </a>
            <a href="?page=fauna&lang=en" class="btn btn-sm <?= $lang==='en'?'btn-success':'btn-outline-success' ?> btn-action">
                <i class="bi bi-translate me-1"></i>EN
            </a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover mb-0" id="dataTable">
            <thead>
                <tr>
                    <th style="width:46px;padding-left:18px">No</th>
                    <th style="width:70px">Gambar</th>
                    <th class="sortable">Nama <span class="sort-icon text-muted">⇅</span></th>
                    <th class="sortable">Nama Ilmiah <span class="sort-icon text-muted">⇅</span></th>
                    <th class="sortable">Deskripsi <span class="sort-icon text-muted">⇅</span></th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <?php $no = 1; foreach ($data as $row): ?>
                <tr>
                    <td class="num-cell" style="padding-left:18px;color:#94a3b8;font-weight:700;"><?= $no++ ?></td>
                    <td>
                        <?php if (!empty($row['imagePath'])): ?>
                            <img src="<?= fb_storage_url($row['imagePath']) ?>"
                                 class="img-thumb"
                                 onerror="this.outerHTML='<div class=\'img-placeholder\'><i class=\'bi bi-bug\' style=\'color:#94a3b8\'></i></div>'">
                        <?php else: ?>
                            <div class="img-placeholder">
                                <i class="bi bi-bug" style="color:#94a3b8;"></i>
                            </div>
                        <?php endif; ?>
                    </td>
                    <td style="font-weight:700;color:#0f172a;"><?= htmlspecialchars($row['title'] ?? '—') ?></td>
                    <td><span class="badge badge-sub"><?= htmlspecialchars($row['subtitle'] ?? '—') ?></span></td>
                    <td style="max-width:240px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#64748b;">
                        <?= htmlspecialchars($row['description'] ?? '—') ?>
                    </td>
                    <td>
                        <a href="?page=detail_fauna&id=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-info btn-action me-1">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="?page=form_edit_fauna&id=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-warning btn-action me-1">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <a href="?page=fauna&hapus=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-danger btn-action"
                           onclick="return confirm('Yakin hapus <?= htmlspecialchars($row['title'] ?? '') ?>?')">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>
            <?php endforeach; ?>
            <?php if (empty($data)): ?>
                <tr><td colspan="6" class="text-center text-muted py-5">Belum ada data fauna.</td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>

    <div class="d-flex align-items-center justify-content-between px-3 py-3">
        <span class="text-muted" style="font-size:12px;" id="pageInfo"></span>
        <ul class="pagination pagination-sm mb-0" id="pager"></ul>
    </div>
</div>