<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuickBook - Hotel Agent Request Details</title>
        <meta name="description" content="QuickBook Admin Panel - Hotel Agent Request Details">
        <meta name="keywords" content="hotel booking, admin, hotel agent request">
        <meta name="author" content="">
        <meta name="robots" content="index, follow">

        <!-- Favicon -->
        <link rel="icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">

        <!-- CSS Libraries -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fancybox/jquery.fancybox.min.css">
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
            .card {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background: linear-gradient(135deg, #007bff, #00d4ff);
                padding: 20px;
                color: #fff;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
            }
            .status-pending {
                background: #fff3e6;
                color: #fd7e14;
            }
            .status-approved {
                background: #e6ffe6;
                color: #28a745;
            }
            .status-rejected {
                background: #ffe6e6;
                color: #dc3545;
            }
            .action-btn {
                padding: 8px 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .license-link {
                display: block;
                margin: 5px 0;
                word-break: break-all; /* Đảm bảo URL dài không làm tràn layout */
            }
            .back-btn {
                margin-bottom: 20px;
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
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/users">Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/hotels">Hotels</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="<%= request.getContextPath()%>/assets/img/default-avatar.jpg" 
                                     alt="Admin Avatar" class="rounded-circle" style="width: 45px; height: 45px;">
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
                <div class="col-lg-10">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-hotel me-2"></i>Hotel Agent Request Details</h4>
                        </div>
                        <div class="card-body p-4">
                            <!-- Back Button -->
                            <a href="<%= request.getContextPath()%>/admin/users" class="btn btn-secondary back-btn">
                                <i class="fas fa-arrow-left me-1"></i> Back to Users
                            </a>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">${error}</div>
                            </c:if>
                            <c:if test="${not empty request}">
                                <dl class="row">
                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-id-badge me-2"></i>Request ID:</dt>
                                    <dd class="col-sm-9">${request.requestId}</dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-user me-2"></i>User ID:</dt>
                                    <dd class="col-sm-9">${request.userId}</dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-hotel me-2"></i>Hotel Name:</dt>
                                    <dd class="col-sm-9">${request.hotelName}</dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-file-alt me-2"></i>Business License:</dt>
                                    <dd class="col-sm-9">
                                        <c:forEach var="url" items="${request.businessLicenseUrls}">
                                            <a href="${url}" class="license-link text-primary" download target="_blank">${url.substring(url.lastIndexOf('/') + 1)}</a>
                                        </c:forEach>
                                        <c:if test="${empty request.businessLicenseUrls}">
                                            N/A
                                        </c:if>
                                    </dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-map-marker-alt me-2"></i>Address:</dt>
                                    <dd class="col-sm-9">${request.address}</dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-info-circle me-2"></i>Description:</dt>
                                    <dd class="col-sm-9">${request.description}</dd>

                                    <dt class="col-sm-3 fw-bold"><i class="fas fa-tasks me-2"></i>Request Status:</dt>
                                    <dd class="col-sm-9">
                                        <span class="status-badge
                                              ${request.requestStatus == 'Pending' ? 'status-pending' : 
                                                request.requestStatus == 'Approved' ? 'status-approved' : 'status-rejected'}">
                                                  ${request.requestStatus}
                                              </span>
                                        </dd>

                                        <dt class="col-sm-3 fw-bold"><i class="fas fa-tag me-2"></i>Request Type:</dt>
                                        <dd class="col-sm-9">${request.requestType}</dd>

                                        <dt class="col-sm-3 fw-bold"><i class="fas fa-calendar-alt me-2"></i>Submitted At:</dt>
                                        <dd class="col-sm-9">
                                            <fmt:formatDate value="${request.submittedAt}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                                        </dd>
                                    </dl>

                                    <!-- Action Buttons (only show if status is Pending) -->
                                    <c:if test="${request.requestStatus == 'Pending'}">
                                        <div class="d-flex justify-content-end mt-4">
                                            <button class="btn btn-success action-btn me-2" onclick="approveRequest(${request.requestId})">
                                                <i class="fas fa-check me-1"></i>Approve
                                            </button>
                                            <button class="btn btn-danger action-btn" onclick="rejectRequest(${request.requestId})">
                                                <i class="fas fa-times me-1"></i>Reject
                                            </button>
                                        </div>
                                    </c:if>
                                </c:if>
                                <c:if test="${empty request}">
                                    <p class="text-center">No request found.</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- JavaScript Libraries -->
            <script src="<%= request.getContextPath()%>/assets/js/jquery-3.7.1.min.js"></script>
            <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
            <script src="<%= request.getContextPath()%>/assets/plugins/fancybox/jquery.fancybox.min.js"></script>

            <!-- Custom JavaScript -->
            <script>
                                                function approveRequest(requestId) {
                                                    if (confirm('Are you sure you want to approve this request?')) {
                                                        $.ajax({
                                                            url: '<%= request.getContextPath()%>/admin/hotel-agent-requests/approve',
                                                            type: 'POST',
                                                            data: {requestId: requestId},
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success) {
                                                                    alert('Request approved successfully!');
                                                                    location.reload();
                                                                } else {
                                                                    alert('Failed to approve request.');
                                                                }
                                                            },
                                                            error: function (xhr, status, error) {
                                                                console.error('Approve error:', error);
                                                                alert('Error approving request.');
                                                            }
                                                        });
                                                    }
                                                }

                                                function rejectRequest(requestId) {
                                                    var reason = prompt('Please enter the reason for rejection:');
                                                    if (reason) {
                                                        $.ajax({
                                                            url: '<%= request.getContextPath()%>/admin/hotel-agent-requests/reject',
                                                            type: 'POST',
                                                            data: {requestId: requestId, rejectionReason: reason},
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success) {
                                                                    alert('Request rejected successfully!');
                                                                    location.reload();
                                                                } else {
                                                                    alert('Failed to reject request.');
                                                                }
                                                            },
                                                            error: function (xhr, status, error) {
                                                                console.error('Reject error:', error);
                                                                alert('Error rejecting request.');
                                                            }
                                                        });
                                                    }
                                                }
            </script>
        </body>
    </html>