<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuickBook - Hotel Management</title>

        <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath()%>/assets/img/apple-touch-icon.png">
        <link rel="icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">

        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/style.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

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
                background: #fff;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            .agent-link {
                color: #007bff;
                cursor: pointer;
                text-decoration: underline;
            }
            .status-active {
                color: #28a745;
            }
            .status-banned {
                color: #dc3545;
            }
            .status-pending {
                color: #ffc107;
            }
        </style>
    </head>
    <body>
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
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/users">Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath()%>/admin/hotels">Hotels</a>
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

        <div class="container-fluid py-5">
            <h2 class="mb-4 text-center">Hotel Management</h2>
            <div class="card">
                <table id="hotelTable" class="table table-striped table-bordered" style="width:100%">
                    <thead>
                        <tr>
                            <th>Hotel ID</th>
                            <th>Hotel Name</th>
                            <th>Location</th>
                            <th>Total Revenue (USD)</th>
                            <th>Hotel Agent</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data will be populated by DataTables -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Agent Details Modal -->
        <div class="modal fade" id="agentModal" tabindex="-1" aria-labelledby="agentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="agentModalLabel">Agent Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>ID:</strong> <span id="agentId"></span></p>
                        <p><strong>Username:</strong> <span id="agentUsername"></span></p>
                        <p><strong>Full Name:</strong> <span id="agentFullName"></span></p>
                        <p><strong>Email:</strong> <span id="agentEmail"></span></p>
                        <p><strong>Phone:</strong> <span id="agentPhone"></span></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%= request.getContextPath()%>/assets/js/jquery-3.7.1.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
            $(document).ready(function () {
                var table = $('#hotelTable').DataTable({
                    ajax: {
                        url: '<%= request.getContextPath()%>/admin/hotels/data',
                        dataSrc: ''
                    },
                    columns: [
                        {data: 'hotelId'},
                        {data: 'hotelName'},
                        {data: 'location'},
                        {
                            data: 'totalRevenue',
                            render: function (data, type, row) {
                                return '$' + parseFloat(data).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                            }
                        },
                        {
                            data: 'agentName',
                            render: function (data, type, row) {
                                return '<a class="agent-link" data-agent-id="' + row.hotelId + '" data-bs-toggle="modal" data-bs-target="#agentModal">' + data + '</a>';
                            }
                        },
                        {
                            data: null,
                            render: function (data, type, row) {
                                if (!row.isAccepted) {
                                    return '<span class="status-pending">Pending</span>';
                                } else if (row.isActive) {
                                    return '<span class="status-active">Active</span>';
                                } else {
                                    return '<span class="status-banned">Banned</span>';
                                }
                            }
                        },
                        {
                            data: null,
                            render: function (data, type, row) {
                                if (!row.isAccepted) {
                                    return '<button class="btn btn-primary btn-sm accept-hotel" data-hotel-id="' + row.hotelId + '">Accept</button>';
                                } else if (row.isActive) {
                                    return '<button class="btn btn-danger btn-sm ban-hotel" data-hotel-id="' + row.hotelId + '">Ban</button>';
                                } else {
                                    return '<button class="btn btn-success btn-sm unban-hotel" data-hotel-id="' + row.hotelId + '">Unban</button>';
                                }
                            }
                        }
                    ],
                    order: [[3, 'desc']],
                    pageLength: 10,
                    responsive: true,
                    language: {
                        search: "Filter hotels:",
                        emptyTable: "No hotels found"
                    }
                });

                // Handle click on agent name to fetch details
                $('#hotelTable').on('click', '.agent-link', function () {
                    var hotelId = $(this).data('agent-id');
                    $.ajax({
                        url: '<%= request.getContextPath()%>/admin/hotels/agent/' + hotelId,
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            $('#agentId').text(data.userId);
                            $('#agentUsername').text(data.username);
                            $('#agentFullName').text((data.firstname || '') + ' ' + (data.lastname || ''));
                            $('#agentEmail').text(data.email || 'N/A');
                            $('#agentPhone').text(data.phoneNumber || 'N/A');
                        },
                        error: function (xhr, status, error) {
                            console.error('Error fetching agent details:', error);
                            alert('Failed to load agent details.');
                        }
                    });
                });

                // Handle accept hotel
                $('#hotelTable').on('click', '.accept-hotel', function () {
                    var hotelId = $(this).data('hotel-id');
                    if (confirm('Are you sure you want to accept this hotel? This action cannot be undone.')) {
                        $.ajax({
                            url: '<%= request.getContextPath()%>/admin/hotels/accept',
                            type: 'POST',
                            data: {hotelId: hotelId},
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    table.ajax.reload();
                                    alert('Hotel accepted successfully.');
                                } else {
                                    alert('Failed to accept hotel.');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error accepting hotel:', error);
                                alert('Error accepting hotel.');
                            }
                        });
                    }
                });

                // Handle ban hotel
                $('#hotelTable').on('click', '.ban-hotel', function () {
                    var hotelId = $(this).data('hotel-id');
                    if (confirm('Are you sure you want to ban this hotel?')) {
                        $.ajax({
                            url: '<%= request.getContextPath()%>/admin/hotels/ban',
                            type: 'POST',
                            data: {hotelId: hotelId},
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    table.ajax.reload();
                                    alert('Hotel banned successfully.');
                                } else {
                                    alert('Failed to ban hotel.');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error banning hotel:', error);
                                alert('Error banning hotel.');
                            }
                        });
                    }
                });

                // Handle unban hotel
                $('#hotelTable').on('click', '.unban-hotel', function () {
                    var hotelId = $(this).data('hotel-id');
                    if (confirm('Are you sure you want to unban this hotel?')) {
                        $.ajax({
                            url: '<%= request.getContextPath()%>/admin/hotels/unban',
                            type: 'POST',
                            data: {hotelId: hotelId},
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    table.ajax.reload();
                                    alert('Hotel unbanned successfully.');
                                } else {
                                    alert('Failed to unban hotel.');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error unbanning hotel:', error);
                                alert('Error unbanning hotel.');
                            }
                        });
                    }
                });
            });
        </script>
    </body>
</html>