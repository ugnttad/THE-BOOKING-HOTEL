<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuickBook - Admin Dashboard</title>
        <meta name="description" content="QuickBook Admin Dashboard">
        <meta name="keywords" content="hotel booking, admin, dashboard">
        <meta name="author" content="">
        <meta name="robots" content="index, follow">

        <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath()%>/assets/img/apple-touch-icon.png">
        <link rel="icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/assets/img/favicon.png" type="image/x-icon">

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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js/dist/chart.min.css">

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
            .stat-card {
                border-radius: 15px;
                padding: 20px;
                background: #fff;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .stat-icon {
                font-size: 2rem;
                color: #fff;
                background: linear-gradient(135deg, #007bff, #00d4ff);
                padding: 15px;
                border-radius: 50%;
            }
            .chart-card {
                border-radius: 15px;
                background: #fff;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            /* Added style to reduce Booking Status chart height */
            #bookingStatusChart {
                height: 360px !important; /* Adjust this value as needed */
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
                            <a class="nav-link active" href="<%= request.getContextPath()%>/admin/dashboard">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath()%>/admin/users">Users</a>
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

        <div class="container-fluid py-5">
            <h2 class="mb-4 text-center wow fadeIn" data-wow-delay="0.2s">Admin Dashboard</h2>

            <div class="row g-4 mb-5">
                <div class="col-md-3 wow fadeInUp" data-wow-delay="0.2s">
                    <div class="stat-card text-center">
                        <i class="fas fa-users stat-icon"></i>
                        <h3 class="mt-3" id="totalUsers">0</h3>
                        <p class="text-muted">Total Users</p>
                    </div>
                </div>
                <div class="col-md-3 wow fadeInUp" data-wow-delay="0.4s">
                    <div class="stat-card text-center">
                        <i class="fas fa-user-check stat-icon"></i>
                        <h3 class="mt-3" id="activeUsers">0</h3>
                        <p class="text-muted">Active Users</p>
                    </div>
                </div>
                <div class="col-md-3 wow fadeInUp" data-wow-delay="0.6s">
                    <div class="stat-card text-center">
                        <i class="fas fa-ticket-alt stat-icon"></i>
                        <h3 class="mt-3" id="totalBookings">0</h3>
                        <p class="text-muted">Total Bookings</p>
                    </div>
                </div>
                <div class="col-md-3 wow fadeInUp" data-wow-delay="0.8s">
                    <div class="stat-card text-center">
                        <i class="fas fa-dollar-sign stat-icon"></i>
                        <h3 class="mt-3" id="totalRevenue">$0</h3>
                        <p class="text-muted">Total Revenue</p>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-6 wow fadeInLeft" data-wow-delay="0.2s">
                    <div class="chart-card">
                        <h5 class="mb-4">Revenue Growth (Monthly)</h5>
                        <canvas id="revenueGrowthChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-6 wow fadeInRight" data-wow-delay="0.4s">
                    <div class="chart-card">
                        <h5 class="mb-4">Booking Status</h5>
                        <canvas id="bookingStatusChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

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
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            $(document).ready(function () {
                new WOW().init();
                $('#navbarNav').meanmenu({
                    meanScreenWidth: "991",
                    meanMenuContainer: '.container-fluid'
                });

                var baseUrl = "<%= request.getContextPath()%>/admin/dashboard/data";

                $.ajax({
                    url: baseUrl,
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        console.log('Full response:', data);
                        console.log('totalRevenue raw:', data.totalRevenue);
                        console.log('totalRevenue type:', typeof data.totalRevenue);

                        $('#totalUsers').text(data.totalUsers || 0).counterUp({delay: 10, time: 1000});
                        $('#activeUsers').text(data.activeUsers || 0).counterUp({delay: 10, time: 1000});
                        $('#totalBookings').text(data.totalBookings || 0).counterUp({delay: 10, time: 1000});

                        let revenue = parseFloat(data.totalRevenue);
                        console.log('totalRevenue parsed:', revenue);
                        if (isNaN(revenue) || !isFinite(revenue)) {
                            console.warn('totalRevenue was NaN or invalid, defaulting to 0');
                            revenue = 0;
                        }
                        let formattedRevenue = '$' + revenue.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                        console.log('Formatted revenue:', formattedRevenue);
                        $('#totalRevenue').text(formattedRevenue);

                        // Revenue Growth Chart (Line)
                        var revenueGrowthCtx = document.getElementById('revenueGrowthChart').getContext('2d');
                        new Chart(revenueGrowthCtx, {
                            type: 'line',
                            data: {
                                labels: data.revenueGrowth.labels,
                                datasets: [{
                                        label: 'Revenue (USD)',
                                        data: data.revenueGrowth.data,
                                        borderColor: '#007bff',
                                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                                        fill: true,
                                        tension: 0.4
                                    }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        title: {
                                            display: true,
                                            text: 'Revenue (USD)'
                                        }
                                    }
                                }
                            }
                        });

                        // Booking Status Chart (Pie)
                        var bookingStatusCtx = document.getElementById('bookingStatusChart').getContext('2d');
                        new Chart(bookingStatusCtx, {
                            type: 'pie',
                            data: {
                                labels: ['Completed', 'Pending', 'Cancelled'],
                                datasets: [{
                                        data: [data.bookingStatus.completed, data.bookingStatus.pending, data.bookingStatus.cancelled],
                                        backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false, // Allows custom height
                                plugins: {
                                    legend: {position: 'bottom'}
                                }
                            }
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error('Error loading dashboard data:', error);
                        alert('Failed to load dashboard data.');
                    }
                });
            });
        </script>
    </body>
</html>