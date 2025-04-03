<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuickBook - User Management</title>
        <meta name="description" content="QuickBook Admin Panel - User Management">
        <meta name="keywords" content="hotel booking, admin, user management">
        <meta name="author" content="">
        <meta name="robots" content="index, follow">

        <!-- Apple Touch Icon -->
        <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath()%>/assets/img/apple-touch-icon.png">

        <!-- Favicon -->
        <link rel="icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">

        <!-- CSS Libraries -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/animate.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/meanmenu.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/tabler-icons/tabler-icons.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fancybox/jquery.fancybox.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/owlcarousel/owl.carousel.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/slick/slick.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/iconsax.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/bootstrap-datetimepicker.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/style.css">

        <!-- Custom Styles -->
        <style>
            body {
                background: #f5f7fa;
                font-family: 'Poppins', sans-serif;
            }
            .navbar {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                padding: 15px 0;
            }
            .navbar-brand {
                font-size: 1.5rem;
                font-weight: 700;
                color: #fff !important;
            }
            .nav-link {
                font-weight: 500;
                transition: color 0.3s ease;
            }
            .nav-link:hover, .nav-link.active {
                color: #00d4ff !important;
            }
            .avatar-img {
                width: 45px;
                height: 45px;
                border: 2px solid #fff;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            }
            .card {
                border-radius: 15px;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-header {
                background: linear-gradient(135deg, #007bff, #00d4ff);
                padding: 20px;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
            }
            .status-active {
                background: #e6ffe6;
                color: #28a745;
            }
            .status-banned {
                background: #ffe6e6;
                color: #dc3545;
            }
            .status-inactive {
                background: #fff3e6;
                color: #fd7e14;
            }
            .action-btn {
                padding: 5px 10px;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            #userDetailsModal .modal-content {
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }
            .modal-header {
                background: #007bff;
                color: #fff;
                border-radius: 15px 15px 0 0;
            }
        </style>
    </head>
    <body>
        <!-- Header with Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">
                <a class="navbar-brand" href="<%= request.getContextPath()%>/admin/dashboard">QuickBook Admin</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath()%>/admin/users">Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/hotels">Hotels</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath()%>/wallet">Wallet</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="<%= request.getContextPath()%>/assets/img/default-avatar.jpg" 
                                     alt="Admin Avatar" class="rounded-circle avatar-img">
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item" href="<%= request.getContextPath()%>/admin/profile">Profile</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<%= request.getContextPath()%>/logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container-fluid py-5">
            <div class="row justify-content-center">
                <div class="col-lg-12">
                    <div class="card wow fadeInUp" data-wow-delay="0.2s">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-users me-2"></i>User Management</h4>
                        </div>
                        <div class="card-body p-4">
                            <table id="userTable" class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data populated by DataTables -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- User Details Modal -->
        <div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div id="userDetailsContent">
                            <!-- Dynamic content inserted here -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Libraries -->
        <script src="<%= request.getContextPath()%>/assets/js/jquery-3.7.1.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/wow.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/jquery.meanmenu.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/plugins/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/plugins/fancybox/jquery.fancybox.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/plugins/slick/slick.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/jquery.counterup.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/jquery.waypoints.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/plugins/moment/moment.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap-datetimepicker.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/cursor.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/script.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/theme-script.js"></script>

        <!-- DataTables JS (Added separately as it wasn't in your list) -->
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

        <!-- Custom JavaScript -->
        <script>
            $(document).ready(function () {
                // Initialize Wow.js for animations
                new WOW().init();

                var baseUrl = "<%= request.getContextPath()%>/admin/users";

                // Date formatting functions
                function formatDate(dateValue) {
                    if (!dateValue)
                        return 'N/A';
                    var date = new Date(dateValue);
                    if (isNaN(date.getTime())) {
                        console.warn('Invalid date value:', dateValue);
                        return dateValue || 'N/A';
                    }
                    return date.toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric'
                    });
                }

                function formatDetailedDate(dateValue) {
                    if (!dateValue)
                        return 'N/A';
                    var date = new Date(dateValue);
                    if (isNaN(date.getTime())) {
                        console.warn('Invalid detailed date value:', dateValue);
                        return dateValue || 'N/A';
                    }
                    return date.toLocaleString('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    });
                }

                // Initialize DataTables
                var table = $('#userTable').DataTable({
                    ajax: {
                        url: baseUrl + '/data',
                        dataSrc: '',
                        error: function (xhr, error, thrown) {
                            console.error('Error loading user data:', error);
                            alert('Failed to load user data.');
                        }
                    },
                    columns: [
                        {data: 'userId'},
                        {data: 'username', defaultContent: 'N/A'},
                        {
                            data: null,
                            render: function (data) {
                                return (data.firstName || '') + ' ' + (data.lastName || '');
                            }
                        },
                        {data: 'email', defaultContent: 'N/A'},
                        {
                            data: 'role',
                            render: function (data) {
                                return data && data.roleName ? data.roleName : 'N/A';
                            }
                        },
                        {
                            data: null,
                            render: function (data) {
                                if (data.isBanned)
                                    return '<span class="status-badge status-banned">Banned</span>';
                                else if (data.isActive)
                                    return '<span class="status-badge status-active">Active</span>';
                                return '<span class="status-badge status-inactive">Inactive</span>';
                            }
                        },
                        {
                            data: 'createdAt',
                            render: function (data) {
                                return formatDate(data);
                            }
                        },
                        {
                            data: null,
                            render: function (data) {
                                var banBtn = data.isBanned ?
                                        '<button class="btn btn-success btn-sm action-btn unban-btn" data-id="' + data.userId + '"><i class="fas fa-unlock"></i> Unban</button>' :
                                        '<button class="btn btn-danger btn-sm action-btn ban-btn" data-id="' + data.userId + '"><i class="fas fa-ban"></i> Ban</button>';
                                return banBtn +
                                        ' <button class="btn btn-info btn-sm action-btn view-btn" data-id="' + data.userId + '"><i class="fas fa-eye"></i> View</button>';
                            }
                        }
                    ],
                    language: {
                        search: '<i class="fas fa-search me-2"></i>Search users:',
                        lengthMenu: "Show _MENU_ users",
                        emptyTable: "No users found",
                        info: "Showing _START_ to _END_ of _TOTAL_ users",
                        loadingRecords: "Loading users..."
                    },
                    pageLength: 10,
                    order: [[0, 'desc']],
                    responsive: true,
                    dom: '<"row mb-3"<"col-md-6"l><"col-md-6"f>>t<"row"<"col-md-6"i><"col-md-6"p>>'
                });

                // Ban User
                $('#userTable tbody').on('click', '.ban-btn', function () {
                    var userId = $(this).data('id');
                    if (confirm('Are you sure you want to ban user ID ' + userId + '?')) {
                        $.ajax({
                            url: baseUrl + '/ban',
                            type: 'POST',
                            data: {userId: userId},
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    alert('User banned successfully!');
                                    table.ajax.reload(null, false);
                                } else {
                                    alert('Failed to ban user.');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Ban error:', error);
                                alert('Error banning user.');
                            }
                        });
                    }
                });

                // Unban User
                $('#userTable tbody').on('click', '.unban-btn', function () {
                    var userId = $(this).data('id');
                    if (confirm('Are you sure you want to unban user ID ' + userId + '?')) {
                        $.ajax({
                            url: baseUrl + '/unban',
                            type: 'POST',
                            data: {userId: userId},
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    alert('User unbanned successfully!');
                                    table.ajax.reload(null, false);
                                } else {
                                    alert('Failed to unban user.');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Unban error:', error);
                                alert('Error unbanning user.');
                            }
                        });
                    }
                });

                // View User Details
                $('#userTable tbody').on('click', '.view-btn', function () {
                    var userId = $(this).data('id');
                    $.ajax({
                        url: baseUrl + '/view/' + userId,
                        type: 'GET',
                        dataType: 'json',
                        success: function (user) {
                            if (user) {
                                var detailsHtml =
                                        '<dl class="row">' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-id-badge me-2"></i>ID:</dt>' +
                                        '<dd class="col-sm-9">' + user.userId + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-user me-2"></i>Username:</dt>' +
                                        '<dd class="col-sm-9">' + (user.username || 'N/A') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-user-tag me-2"></i>Full Name:</dt>' +
                                        '<dd class="col-sm-9">' + (user.firstName || '') + ' ' + (user.lastName || '') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-envelope me-2"></i>Email:</dt>' +
                                        '<dd class="col-sm-9">' + (user.email || 'N/A') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-user-shield me-2"></i>Role:</dt>' +
                                        '<dd class="col-sm-9">' + (user.role && user.role.roleName ? user.role.roleName : 'N/A') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-phone me-2"></i>Phone:</dt>' +
                                        '<dd class="col-sm-9">' + (user.phoneNumber || 'N/A') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-info-circle me-2"></i>Status:</dt>' +
                                        '<dd class="col-sm-9">' +
                                        (user.isBanned ? '<span class="status-badge status-banned">Banned</span>' :
                                                (user.isActive ? '<span class="status-badge status-active">Active</span>' :
                                                        '<span class="status-badge status-inactive">Inactive</span>')) +
                                        '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-calendar-alt me-2"></i>Created At:</dt>' +
                                        '<dd class="col-sm-9">' + formatDetailedDate(user.createdAt) + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fab fa-google me-2"></i>Google ID:</dt>' +
                                        '<dd class="col-sm-9">' + (user.googleId || 'N/A') + '</dd>' +
                                        '<dt class="col-sm-3 fw-bold"><i class="fas fa-image me-2"></i>Avatar URL:</dt>' +
                                        '<dd class="col-sm-9">' +
                                        (user.avatarUrl ? '<a href="' + user.avatarUrl + '" data-fancybox="gallery" class="text-primary">View</a>' : 'N/A') +
                                        '</dd>';

                                // Thêm phần Hotel Agent Request nếu có
                                if (user.hotelAgentRequest && user.hotelAgentRequest.requestStatus === 'Pending') {
                                    detailsHtml +=
                                            '<dt class="col-sm-3 fw-bold"><i class="fas fa-hotel me-2"></i>Hotel Agent Request:</dt>' +
                                            '<dd class="col-sm-9">' +
                                            '<span class="status-badge status-pending">Pending</span> ' +
                                            '<a href="<%= request.getContextPath()%>/admin/hotel-agent-requests/view/' + user.hotelAgentRequest.requestId + '" class="btn btn-primary btn-sm ms-2">' +
                                            '<i class="fas fa-eye me-1"></i>View Request</a>' +
                                            '</dd>';
                                }

                                detailsHtml += '</dl>';
                                $('#userDetailsContent').html(detailsHtml);
                                $('#userDetailsModal').modal('show');
                            } else {
                                alert('User not found.');
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('View error:', error);
                            alert('Failed to load user details.');
                        }
                    });
                });

                // Initialize MeanMenu for mobile
                $('#navbarNav').meanmenu({
                    meanScreenWidth: "991",
                    meanMenuContainer: '.container-fluid'
                });
            });
        </script>
    </body>
</html>