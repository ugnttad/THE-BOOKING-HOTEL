<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DreamsTour - Travel and Tour Booking Bootstrap 5 template</title>

        <meta name="description" content="DreamsTour - A premium Bootstrap 5 template crafted for travel and tour booking. Tailored for travel agencies and booking platforms, it features flight, hotel, and tour reservations, and holiday packages.">
        <meta name="keywords" content="travel booking template, tour booking, Bootstrap 5 travel template, DreamsTour, hotel booking, flights booking, holiday packages, tour agency website, travel agency template, travel HTML template, booking system, responsive travel template, Bootstrap travel website">
        <meta name="author" content="Dreams Technologies">
        <meta name="robots" content="index, follow">

        <!-- Apple Touch Icon -->
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/img/apple-touch-icon.png">

        <!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/img/favicon.png" type="image/x-icon">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon.png" type="image/x-icon">

        <!-- Theme Settings Js -->
        <script src="${pageContext.request.contextPath}/assets/js/theme-script.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">

        <!-- Main.css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/meanmenu.css">

        <!-- Tabler Icon CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/tabler-icons/tabler-icons.css">

        <!-- Fontawesome Icon CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/fontawesome/css/all.min.css">

        <!-- Fancybox CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/fancybox/jquery.fancybox.min.css">

        <!-- Owlcarousel CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/owlcarousel/owl.carousel.min.css">

        <!-- Iconsax CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/iconsax.css">

        <!-- Datatable CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.bootstrap5.min.css">

        <!-- Daterangepikcer CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/daterangepicker/daterangepicker.css">

        <!-- Datepicker CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-datetimepicker.min.css">

        <!-- Select2 CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/select2/css/select2.min.css">

        <!-- Style CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="My Bookings" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Sidebar -->
                    <%@ include file="../layout/profile-sidebar.jsp" %>

                    <!-- Hotel Booking -->
                    <div class="col-xl-9 col-lg-9 theiaStickySidebar">

                        <!-- Hotel-Booking List -->
                        <div class="card hotel-list">
                            <div class="card-body p-0">
                                <div class="list-header d-flex align-items-center justify-content-between flex-wrap">
                                    <h6 class="">Booking List</h6>
                                    <div class="d-flex align-items-center flex-wrap">
                                        <div class="input-icon-start  me-2 position-relative">
                                            <span class="icon-addon">
                                                <i class="isax isax-search-normal-1 fs-14"></i>
                                            </span>
                                            <input type="text" class="form-control" placeholder="Search">
                                        </div>
                                        <div class="dropdown me-3">
                                            <a href="javascript:void(0);" class="dropdown-toggle text-gray-6 btn  rounded border d-inline-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">
                                                Status
                                            </a>
                                            <ul class="dropdown-menu dropdown-menu-end p-3">
                                                <li>
                                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">Pending</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">Completed</a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="d-flex align-items-center sort-by">
                                            <span class="fs-14 text-gray-9 fw-medium">Sort By :</span>
                                            <div class="dropdown">
                                                <ul class="dropdown-menu dropdown-menu-end p-3">
                                                    <li>
                                                        <a href="javascript:void(0);" class="dropdown-item rounded-1">Recently Added</a>
                                                    </li>
                                                    <li>
                                                        <a href="javascript:void(0);" class="dropdown-item rounded-1">Last Month</a>
                                                    </li>
                                                    <li>
                                                        <a href="javascript:void(0);" class="dropdown-item rounded-1">Last 7 Days</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <!-- Hotel List -->
                                <div class="custom-datatable-filter table-responsive">
                                    <table id="bookingTable" class="table datatable">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Hotel</th>
                                                <th>Room & Guest</th>
                                                <th>Days</th>
                                                <th>Pricing</th>
                                                <th>Booked on</th>
                                                <th>Status</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <tr>
                                                    <td>${booking.bookingId}</td>
                                                    <td>${booking.hotelName}</td>
                                                    <td>${booking.roomType}</td>
                                                    <td>
                                                        <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy" />
                                                        <br>to
                                                        <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>${booking.pricePerNight}</td>
                                                    <td><fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy" /></td>
                                                    <td>${booking.bookingStatus}</td>
                                                    <td>
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#upcoming">
                                                            <i class="isax isax-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- /Hotel List -->

                            </div>
                        </div>
                        <!-- /Hotel-Booking List -->

                        <!-- Pagination -->
                        <div class="table-paginate d-flex justify-content-between align-items-center flex-wrap row-gap-3">
                            <div class="value d-flex align-items-center">
                                <span>Show</span>
                                <select>
                                    <option>5</option>
                                    <option>10</option>
                                    <option>20</option>
                                </select>
                                <span>entries</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-center">
                                <a href="javascript:void(0);"><span class="me-3"><i class="isax isax-arrow-left-2"></i></span></a>
                                <nav aria-label="Page navigation">
                                    <ul class="paginations d-flex justify-content-center align-items-center">
                                        <li class="page-item me-2"><a class="page-link-1 active d-flex justify-content-center align-items-center " href="javascript:void(0);">1</a></li>
                                        <li class="page-item me-2"><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">2</a></li>
                                        <li class="page-item "><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">3</a></li>
                                    </ul>
                                </nav>
                                <a href="javascript:void(0);"><span class="ms-3"><i class="isax isax-arrow-right-3"></i></span></a>
                            </div>
                        </div>
                        <!-- /Pagination -->
                    </div>
                    <!-- /Hotel Booking -->
                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../layout/footer.jsp" %>
        <!-- /Footer -->

        <!-- Upcoming Modal -->
        <%@ include file="../layout/booking/upcoming-modal.jsp" %>
        <!-- /Upcoming Modal -->

        <!-- Pending Modal -->
        <%@ include file="../layout/booking/pending-modal.jsp" %>
        <!-- /Pending Modal -->

        <!-- Completed Modal -->
        <%@ include file="../layout/booking/completed-modal.jsp" %>
        <!-- /Completed Modal -->

        <!-- Cancelled Modal -->
        <%@ include file="../layout/booking/cancelled-modal.jsp" %>
        <!-- /Cancelled Modal -->

        <!-- Booking Cancel -->
        <%@ include file="../layout/booking/booking-cancel.jsp" %>
        <!-- /Booking Cancel -->

        <!-- Cursor -->
        <%@ include file="../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../layout/script.jsp" %>

        <!-- Select2 JS -->
        <script src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/assets/plugins/select2/js/select2.min.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>

        <!-- Sticky Sidebar JS -->
        <script src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/ResizeSensor.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>
        <script src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/theia-sticky-sidebar.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>

        <!-- Daterangepikcer JS -->
        <script src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/assets/js/moment.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>
        <script src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/assets/plugins/daterangepicker/daterangepicker.js" type="b27b54d39bd69b4155ce64a9-text/javascript"></script>

        <!-- Datatable JS -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.dataTables.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/dataTables.bootstrap5.min.js"></script>

        <script>
            $(document).ready(function () {
                // Khởi tạo DataTables
                $('#bookingTable').DataTable({
                    "paging": true, // Cho phép phân trang
                    "searching": true, // Cho phép tìm kiếm
                    "ordering": true, // Cho phép sắp xếp
                    "info": true, // Hiển thị thông tin phân trang
                    "language": {
                        "lengthMenu": "Show _MENU_ entries", // Tùy chỉnh menu phân trang
                        "zeroRecords": "No matching records found",
                        "info": "Showing _START_ to _END_ of _TOTAL_ entries",
                        "infoEmpty": "No entries available",
                        "infoFiltered": "(filtered from _MAX_ total entries)",
                        "search": "Search:"
                    }
                });
            });
        </script>
</html>