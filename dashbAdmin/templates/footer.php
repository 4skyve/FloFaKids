<div class="footer">
        &copy; <?= date('Y') ?> FloFaKids Admin Panel
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    const tbl = document.getElementById('dataTable');
    if (!tbl) return;

    const tbody  = tbl.querySelector('tbody');
    const ppSel  = document.getElementById('perPage');
    const inp    = document.getElementById('searchInput');
    const allThs = Array.from(tbl.querySelectorAll('thead th'));

    // Simpan data baris — nomor tdk disimpan di sini, ditulis ulang saat render
    const allRows = Array.from(tbody.querySelectorAll('tr')).filter(r =>
        !r.querySelector('td[colspan]')
    ).map(r => ({
        el:   r,
        text: r.textContent.toLowerCase()
    }));

    let displayed   = [...allRows];
    let currentPage = 1;
    let perPage     = ppSel ? parseInt(ppSel.value) : 10;
    let sortCol     = -1;
    let sortDir     = 1;

    // SEARCH
    if (inp) {
        inp.addEventListener('input', () => {
            const q = inp.value.toLowerCase().trim();
            displayed = q
                ? allRows.filter(item => item.text.includes(q))
                : [...allRows];
            sortCol = -1;
            sortDir = 1;
            resetSortIcons();
            currentPage = 1;
            render();
        });
    }

    // PER PAGE
    if (ppSel) {
        ppSel.addEventListener('change', () => {
            perPage = parseInt(ppSel.value);
            currentPage = 1;
            render();
        });
    }

    // SORT
    tbl.querySelectorAll('th.sortable').forEach(th => {
        th.addEventListener('click', () => {
            const colIndex = allThs.indexOf(th);
            if (colIndex === -1) return;

            if (sortCol === colIndex) {
                sortDir *= -1;
            } else {
                sortCol = colIndex;
                sortDir = 1;
            }

            resetSortIcons();
            th.classList.add('sorted');
            const icon = th.querySelector('.sort-icon');
            if (icon) {
                icon.textContent = sortDir === 1 ? '▲' : '▼';
                icon.style.color = '#16a34a';
            }

            displayed.sort((a, b) => {
                // Skip kolom No (index 0) — bkn sort berdasarkan nomor
                const ci = colIndex === 0 ? 1 : colIndex;
                const cellA = a.el.cells[ci]?.textContent.trim() ?? '';
                const cellB = b.el.cells[ci]?.textContent.trim() ?? '';

                const numA = parseFloat(cellA);
                const numB = parseFloat(cellB);
                if (!isNaN(numA) && !isNaN(numB)) {
                    return (numA - numB) * sortDir;
                }
                return cellA.localeCompare(cellB, 'id') * sortDir;
            });

            currentPage = 1;
            render();
        });
    });

    function resetSortIcons() {
        tbl.querySelectorAll('th.sortable').forEach(t => {
            const ic = t.querySelector('.sort-icon');
            if (ic) { ic.textContent = '⇅'; ic.style.color = '#94a3b8'; }
            t.classList.remove('sorted');
        });
    }

    // RENDER 
    function render() {
        const total = displayed.length;
        const pages = Math.max(1, Math.ceil(total / perPage));
        if (currentPage > pages) currentPage = pages;

        const start   = (currentPage - 1) * perPage;
        const end     = start + perPage;
        const shown   = displayed.slice(start, end);
        const shownSet = new Set(shown.map(i => i.el));

        // Reorder DOM sesuai urutan sort
        displayed.forEach(item => tbody.appendChild(item.el));

        // Show/hide + tulis nomor urut sesuai posisi di halaman
        allRows.forEach(item => {
            item.el.style.display = 'none';
        });

        shown.forEach((item, i) => {
            item.el.style.display = '';
            // Nomor = posisi di halaman, bkn dari database
            const nc = item.el.querySelector('.num-cell');
            if (nc) nc.textContent = start + i + 1;
        });

        // Page info
        const info = document.getElementById('pageInfo');
        if (info) {
            info.textContent = total === 0
                ? 'Tidak ada data'
                : `Menampilkan ${start + 1}–${Math.min(end, total)} dari ${total} data`;
        }

        renderPager(pages);
    }

    function renderPager(pages) {
        const pager = document.getElementById('pager');
        if (!pager) return;
        pager.innerHTML = '';

        const make = (label, pg, disabled, active) => {
            const li = document.createElement('li');
            li.className = `page-item${disabled ? ' disabled' : ''}${active ? ' active' : ''}`;
            const a = document.createElement('a');
            a.className = 'page-link';
            a.href = '#';
            a.innerHTML = label;
            if (!disabled) {
                a.addEventListener('click', e => {
                    e.preventDefault();
                    currentPage = pg;
                    render();
                    tbl.closest('.content-card')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
                });
            }
            li.appendChild(a);
            return li;
        };

        pager.appendChild(make('&lsaquo;', currentPage - 1, currentPage === 1));
        for (let p = 1; p <= pages; p++) {
            if (p === 1 || p === pages || Math.abs(p - currentPage) <= 1) {
                pager.appendChild(make(p, p, false, p === currentPage));
            } else if (Math.abs(p - currentPage) === 2) {
                const li = document.createElement('li');
                li.className = 'page-item disabled';
                li.innerHTML = '<a class="page-link" href="#">…</a>';
                pager.appendChild(li);
            }
        }
        pager.appendChild(make('&rsaquo;', currentPage + 1, currentPage === pages));
    }

    render();
})();
</script>
</body>
</html>