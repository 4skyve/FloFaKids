<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FloFaKids Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 235px;
            --green: #16a34a;
            --green-light: #dcfce7;
            --green-mid: #86efac;
            --sidebar-bg: #ffffff;
            --sidebar-border: #e2e8f0;
            --accent: #16a34a;
        }

        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        body { margin:0; background:#f1f5f9; display:flex; }

        /* ── SIDEBAR (TERANG) ── */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--sidebar-bg);
            border-right: 1.5px solid var(--sidebar-border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top:0; left:0;
            height: 100vh;
            z-index: 100;
            box-shadow: 2px 0 12px rgba(0,0,0,.04);
        }

        .sidebar-brand {
            padding: 20px 18px 16px;
            border-bottom: 1.5px solid var(--sidebar-border);
            display: flex; align-items: center; gap: 10px;
        }
        .sidebar-brand .logo-icon {
            width:38px; height:38px;
            background: linear-gradient(135deg, #16a34a, #4ade80);
            border-radius: 12px;
            display:flex; align-items:center; justify-content:center;
            font-size:18px; box-shadow: 0 2px 8px rgba(22,163,74,.3);
        }
        .sidebar-brand .brand-text .name {
            font-size:15px; font-weight:800; color:#0f172a; line-height:1.2;
        }
        .sidebar-brand .brand-text .sub {
            font-size:10px; color:#94a3b8; font-weight:500; letter-spacing:.5px; text-transform:uppercase;
        }

        .sidebar-section {
            padding: 16px 18px 4px;
            font-size: 10px; font-weight:700; letter-spacing:1px;
            text-transform:uppercase; color:#94a3b8;
        }

        .sidebar nav a {
            display:flex; align-items:center; gap:9px;
            padding:9px 12px; margin:2px 10px;
            border-radius:9px;
            color:#64748b; text-decoration:none; font-size:13.5px; font-weight:500;
            transition:all .15s;
        }
        .sidebar nav a i { font-size:15px; width:20px; text-align:center; }
        .sidebar nav a:hover { background:#f0fdf4; color:#16a34a; }
        .sidebar nav a.active {
            background: var(--green-light);
            color: var(--green);
            font-weight:700;
        }
        .sidebar nav a.active i { color: var(--green); }

        .sidebar-divider { border:none; border-top:1.5px solid var(--sidebar-border); margin:8px 18px; }

        .sidebar-user {
            margin-top:auto; padding:14px 16px;
            border-top:1.5px solid var(--sidebar-border);
            display:flex; align-items:center; gap:10px;
        }
        .sidebar-user .avatar {
            width:34px; height:34px; border-radius:10px;
            background: linear-gradient(135deg,#16a34a,#4ade80);
            display:flex; align-items:center; justify-content:center;
            font-weight:800; color:#fff; font-size:14px; flex-shrink:0;
        }
        .sidebar-user .info .name { font-size:13px; font-weight:700; color:#0f172a; line-height:1.2; }
        .sidebar-user .info .role { font-size:11px; color:#94a3b8; }
        .sidebar-user a.logout-btn {
            margin-left:auto; color:#cbd5e1; font-size:17px;
            text-decoration:none; transition:color .15s;
        }
        .sidebar-user a.logout-btn:hover { color:#ef4444; }

        .main { margin-left:var(--sidebar-width); flex:1; display:flex; flex-direction:column; min-height:100vh; }

        .topbar {
            background:#fff; padding:13px 28px;
            border-bottom:1.5px solid #e2e8f0;
            display:flex; align-items:center; justify-content:space-between;
            position:sticky; top:0; z-index:50;
        }
        .topbar .page-title { font-size:15px; font-weight:800; color:#0f172a; }
        .topbar .page-sub   { font-size:12px; color:#94a3b8; margin-top:1px; }

        .content { flex:1; padding:24px 28px; }

        .footer {
            background:#fff; border-top:1px solid #e2e8f0;
            padding:12px 28px; font-size:12px; color:#94a3b8; text-align:center;
        }

        .stat-card {
            background:#fff; border-radius:14px; padding:20px 22px;
            border:1.5px solid #e2e8f0;
            display:flex; align-items:center; gap:14px;
            transition: all .2s;
        }
        .stat-card:hover { border-color:#86efac; box-shadow:0 4px 20px rgba(22,163,74,.08); transform:translateY(-1px); }
        .stat-icon { width:46px; height:46px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; }
        .stat-card .stat-val { font-size:28px; font-weight:800; color:#0f172a; line-height:1; }
        .stat-card .stat-lbl { font-size:12px; color:#94a3b8; margin-top:3px; font-weight:500; }

        .content-card {
            background:#fff; border-radius:14px;
            border:1.5px solid #e2e8f0; overflow:hidden;
        }
        .card-header-custom {
            padding:16px 22px; border-bottom:1.5px solid #e2e8f0;
            display:flex; align-items:center; justify-content:space-between;
        }
        .card-header-custom h6 { margin:0; font-weight:800; font-size:14px; color:#0f172a; }

        table thead th {
            background:#f8fafc; font-size:11px; font-weight:700;
            text-transform:uppercase; letter-spacing:.6px; color:#94a3b8;
            border-bottom:1.5px solid #e2e8f0 !important; padding:11px 14px;
        }
        table tbody td { padding:12px 14px; vertical-align:middle; font-size:13.5px; color:#334155; }
        table tbody tr:hover { background:#f8fafc; }
        .btn-action { font-size:12px; padding:5px 11px; border-radius:7px; font-weight:600; }

        .table-toolbar {
            padding:14px 20px; border-bottom:1.5px solid #e2e8f0;
            display:flex; align-items:center; gap:8px; flex-wrap:wrap;
            background:#fafcff;
        }
        .search-box { position:relative; flex:1; max-width:260px; }
        .search-box input {
            width:100%; padding:7px 12px 7px 34px;
            border:1.5px solid #e2e8f0; border-radius:9px;
            font-size:13px; background:#fff; outline:none;
            transition:border-color .15s; font-family:inherit;
        }
        .search-box input:focus { border-color:#16a34a; }
        .search-box .si { position:absolute; left:10px; top:50%; transform:translateY(-50%); color:#94a3b8; font-size:14px; }
        .filter-sel, .sort-sel {
            padding:7px 10px; border-radius:9px;
            border:1.5px solid #e2e8f0; background:#fff;
            font-size:13px; color:#334155; outline:none; cursor:pointer;
            font-family:inherit; font-weight:500;
        }
        .filter-sel:focus, .sort-sel:focus { border-color:#16a34a; }

        .btn-primary { background:#16a34a; border-color:#16a34a; font-weight:600; }
        .btn-primary:hover { background:#15803d; border-color:#15803d; }
        .btn-outline-success { border-color:#16a34a; color:#16a34a; font-weight:600; }
        .btn-outline-success:hover { background:#16a34a; color:#fff; }

        .badge { font-weight:600; border-radius:6px; }
        .badge-title { background:#dcfce7; color:#15803d; }
        .badge-sub   { background:#dbeafe; color:#1d4ed8; }
        .badge-lv1   { background:#dcfce7; color:#15803d; }
        .badge-lv2   { background:#fef9c3; color:#a16207; }
        .badge-lv3   { background:#fee2e2; color:#b91c1c; }

        .img-thumb {
            width:56px; height:42px; border-radius:8px;
            object-fit:cover; border:1.5px solid #e2e8f0;
            background:#f1f5f9;
        }
        .img-placeholder {
            width:56px; height:42px; border-radius:8px;
            background:#f1f5f9; border:1.5px solid #e2e8f0;
            display:flex; align-items:center; justify-content:center; font-size:20px;
        }

        th.sortable { cursor:pointer; user-select:none; transition:color .15s; }
        th.sortable:hover { color:#16a34a; }
        th.sorted { color:#16a34a !important; }

        .pagination .page-link { color:#16a34a; border-color:#e2e8f0; font-size:13px; font-weight:600; border-radius:7px !important; margin:0 2px; }
        .pagination .page-item.active .page-link { background:#16a34a; border-color:#16a34a; color:#fff; }
        .pagination .page-link:focus { box-shadow:none; }

        .alert { border-radius:10px; font-size:13.5px; }
    </style>
</head>
<body>