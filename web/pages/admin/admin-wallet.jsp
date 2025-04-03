<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuickBook - Admin Wallet</title>
        <meta name="description" content="QuickBook Admin Wallet Management">
        <meta name="keywords" content="admin wallet, transactions, withdrawal">
        <meta name="author" content="">

        <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath()%>/assets/img/apple-touch-icon.png">
        <link rel="icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">

        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/plugins/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/style.css">

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
            }
            .card-header {
                background: linear-gradient(135deg, #007bff, #00d4ff);
                color: #fff;
            }
            .table {
                background: #fff;
                border-radius: 10px;
            }
            .table th, .table td {
                vertical-align: middle;
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
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/hotels">Hotels</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath()%>/wallet">Wallet</a>
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
            <h2 class="mb-4 text-center">Admin Wallet Management</h2>

            <!-- Wallet Balance -->
            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Wallet Balance</h5>
                        </div>
                        <div class="card-body text-center">
                            <h3>$<fmt:formatNumber value="${balanceUSD}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                            <p class="text-muted">Current Balance</p>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#withdrawModal">Withdraw Money</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Last Withdrawn</h5>
                        </div>
                        <div class="card-body text-center">
                            <h3>$<fmt:formatNumber value="${lastWithdrawn}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                            <p class="text-muted">Last Withdrawal Amount</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction History -->
            <div class="row g-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Transaction History</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Amount (USD)</th>
                                        <th>Type</th>
                                        <th>Description</th>
                                        <th>Date</th>
                                        <th>Related Booking</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="transaction" items="${transactions}">
                                        <tr>
                                            <td>${transaction.transactionId}</td>
                                            <td>$<fmt:formatNumber value="${transaction.amount}" 
                                                              type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td>${transaction.transactionType}</td>
                                            <td>${transaction.description}</td>
                                            <td><fmt:formatDate value="${transaction.createdAt}" pattern="dd MMM yyyy HH:mm"/></td>
                                            <td>${transaction.relatedBookingTransactionId != null ? transaction.relatedBookingTransactionId : 'N/A'}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-4">${error}</div>
            </c:if>
            <c:if test="${param.success != null}">
                <div class="alert alert-success mt-4">${param.success}</div>
            </c:if>
        </div>

        <!-- Withdraw Modal -->
        <div class="modal fade" id="withdrawModal" tabindex="-1" aria-labelledby="withdrawModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="withdrawModalLabel">Withdraw Money</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="<%= request.getContextPath()%>/wallet" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="withdraw">
                            <div class="mb-3">
                                <label for="amount" class="form-label">Amount (USD)</label>
                                <input type="number" step="0.01" class="form-control" id="amount" name="amount" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Withdraw</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="<%= request.getContextPath()%>/assets/js/jquery-3.7.1.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/script.js"></script>
    </body>
</html>