<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <%@ include file="../../layout/head.jsp" %>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Agent Dashboard" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Sidebar -->
                    <%@ include file="../../layout/profile-sidebar.jsp" %>

                    <div class="col-xl-9 col-lg-8">                    
                        <div class="row">
                            <div class="col-xl-3 col-sm-6 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body text-center">
                                        <span class="avatar avatar rounded-circle bg-success mb-2">
                                            <i class="isax isax-calendar-15 fs-24"></i>
                                        </span>
                                        <p class="mb-1">Total Bookings</p>
                                        <h5 class="mb-2">${totalBooking}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body text-center">
                                        <span class="avatar avatar rounded-circle bg-orange mb-2">
                                            <i class="isax isax-money-time5 fs-24"></i>
                                        </span>
                                        <p class="mb-1">Total Listings</p>
                                        <h5 class="mb-2">${totalHotel}</h5>
                                        <a href="${pageContext.request.contextPath}/get-hotels" class="fs-14 link-primary text-decoration-underline">View All</a>   
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body text-center">
                                        <span class="avatar avatar rounded-circle bg-info mb-2">
                                            <i class="isax isax-money-send5 fs-24"></i>
                                        </span>
                                        <p class="mb-1">Total Earnings</p>
                                        <h5 class="mb-2">$${Math.round(totalEarnings/25336.0)}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body text-center">
                                        <span class="avatar avatar rounded-circle bg-indigo mb-2">
                                            <i class="isax isax-magic-star5 fs-24"></i>
                                        </span>
                                        <p class="mb-1">Total Reviews</p>
                                        <h5 class="mb-2">${totalFeedback}</h5>
                                        <a href="#" class="fs-14 link-primary text-decoration-underline">View All</a>   
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Earnings -->
                            <div class="col-xl-12 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body pb-0">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <h6>Earnings</h6>
                                            <div class="dropdown">
                                                <a href="javascript:void(0);" class="dropdown-toggle btn bg-light-200 btn-sm text-gray-6 rounded-pill fw-normal fs-14 d-inline-flex align-items-center" data-bs-toggle="dropdown" id="yearDropdown">
                                                    <i class="isax isax-calendar-2 me-2 fs-14 text-gray-6"></i><span id="selectedYear">${currentYear}</span>
                                                </a>
                                                <ul class="dropdown-menu dropdown-menu-end p-3">
                                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1 year-option" data-year="${currentYear}"><i class="ti ti-point-filled me-1"></i>${currentYear}</a></li>
                                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1 year-option" data-year="${yearMinus1}"><i class="ti ti-point-filled me-1"></i>${yearMinus1}</a></li>
                                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1 year-option" data-year="${yearMinus2}"><i class="ti ti-point-filled me-1"></i>${yearMinus2}</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="d-flex align-items-center justify-content-between flex-wrap">
                                                <div class="mb-2">
                                                    <p class="mb-0">Total Earnings this Year</p>
                                                    <h3 id="totalEarnings">$<fmt:formatNumber value="${earningsByYear[currentYear]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                                                </div>
                                                <div class="d-flex align-items-center mb-2">
                                                    <p class="fs-14" id="percentageChangeContainer">
                                                        <span id="percentageBadge" class="badge badge-md rounded-pill me-2">
                                                            <i class="isax"></i><span id="percentageValue"></span>%
                                                        </span>vs last year
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /Earnings -->                        

                        </div>

                        <div class="row">

                            <!-- Recently Added -->
                            <div class="col-xl-6 col-xxl-5 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body">
                                        <h6 class="mb-4">Recently Added</h6>
                                        <c:forEach var="hotel" items="${recentlyBookedHotels}">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <div class="d-flex align-items-center">
                                                    <a href="hotel-details.html?hotelId=${hotel.hotelId}" class="avatar avatar-lg flex-shrink-0 me-2">
                                                        <img src="${hotel.hotelImageURLs != null && !empty hotel.hotelImageURLs ? hotel.hotelImageURLs : 'assets/img/hotels/default.jpg'}" 
                                                             class="img-fluid rounded-circle" alt="${hotel.hotelName}">
                                                    </a>
                                                    <div>
                                                        <h6 class="fs-16"><a href="#">${hotel.hotelName}</a></h6>
                                                        <p class="fs-14">
                                                            Last Booked: 
                                                            <c:choose>
                                                                <c:when test="${hotel.lastBooked != null}">
                                                                    <fmt:formatDate value="${hotel.lastBooked}" pattern="dd MMM yyyy"/>
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                </div>
                                                <a href="agent-hotel-booking.html?hotelId=${hotel.hotelId}" class="btn rebook-btn btn-sm">
                                                    <fmt:formatNumber value="${hotel.bookingCount}" type="number" minIntegerDigits="1"/> Bookings
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <!-- /Recently Added -->

                            <!-- Recent Transactions -->
                            <div class="col-xxl-7 col-xl-6 d-flex">
                                <div class="card shadow-none flex-fill">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-4 gap-2">
                                            <h6>Latest Invoices</h6>
                                        </div>
                                        <c:forEach var="transaction" items="${latestTransactions}" varStatus="loop">
                                            <div class="card shadow-none ${loop.last ? 'mb-0' : 'mb-4'}">
                                                <div class="card-body p-2">
                                                    <div class="d-flex justify-content-between align-items-center flex-fill">
                                                        <div>
                                                            <div class="d-flex align-items-center flex-wrap mb-1">
                                                                <a href="invoices.html?bookingId=${transaction.bookingId}" class="fs-14 link-primary border-end pe-2 me-2 mb-0">#INV${transaction.bookingId}</a>
                                                                <p class="fs-14">Date: <fmt:formatDate value="${transaction.createdAt}" pattern="dd MMM yyyy"/></p>
                                                            </div>
                                                            <h6 class="fs-16 fw-medium"><a href="hotel-details.html">${transaction.hotelName}</a></h6>
                                                        </div>
                                                        <div class="text-end">
                                                            <p class="fs-14 mb-1">Amount</p>
                                                            <h6 class="fw-medium">$<fmt:formatNumber value="${transaction.totalAmount}" type="number" minFractionDigits="0" maxFractionDigits="0"/></h6>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <!-- /Recent Invoices -->

                        </div>

                        <!-- Hotel-Booking List -->
<!--                        <div class="card hotel-list mb-0">
                            <div class="card-body p-0">
                                <div class="list-header d-flex align-items-center justify-content-between flex-wrap">
                                    <h6 class="">Recent Bookings</h6>
                                    <div class="d-flex align-items-center flex-wrap">
                                        <div class="dropdown me-3">
                                            <a href="javascript:void(0);" class="dropdown-toggle text-gray-6 btn  rounded border d-inline-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">
                                                Hotels
                                            </a>
                                            <ul class="dropdown-menu dropdown-menu-end p-3">
                                                <li>
                                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">Single Room</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">Double Room</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">Twin Room</a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="input-icon-start position-relative">
                                            <span class="icon-addon">
                                                <i class="isax isax-search-normal-1 fs-14"></i>
                                            </span>
                                            <input type="text" class="form-control" placeholder="Search">
                                        </div>
                                    </div>
                                </div>

                                 Hotel List 
                                <div class="custom-datatable-filter table-responsive">
                                    <table class="table datatable">
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
                                            <tr>
                                                <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#upcoming">#HB-1245</a></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="hotel-details.html" class="avatar avatar-lg"><img src="assets/img/hotels/hotel-01.jpg" class="img-fluid rounded-circle" alt="img"></a>
                                                        <div class="ms-2">
                                                            <p class="text-dark mb-0 fw-medium fs-14"><a href="hotel-details.html">Hotel Athenee</a></p>
                                                            <span class="fs-14 fw-normal text-gray-6">Barcelona</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <h6 class="fs-14 mb-1">Suite Room</h6>
                                                    <span class="fs-14 fw-normal text-gray-6">2 Adults, 1 Child</span>
                                                </td>
                                                <td>4 Days, 3 Nights</td>
                                                <td>$11,569</td>
                                                <td>15 May 2025</td>
                                                <td>
                                                    <span class="badge badge-info rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Upcoming</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#upcoming"><i class="isax isax-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#upcoming">#HB-3215</a></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="hotel-details.html" class="avatar avatar-lg"><img src="assets/img/hotels/hotel-18.jpg" class="img-fluid rounded-circle" alt="img"></a>
                                                        <div class="ms-2">
                                                            <p class="text-dark mb-0 fw-medium fs-14"><a href="hotel-details.html">The Luxe Haven</a></p>
                                                            <span class="fs-14 fw-normal text-gray-6">London</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <h6 class="fs-14 mb-1">Queen Room</h6>
                                                    <span class="fs-14 fw-normal text-gray-6">2 Adults, 2 Child</span>
                                                </td>
                                                <td>3 Days, 2 Nights</td>
                                                <td>$10,745</td>
                                                <td>20 May 2025</td>
                                                <td>
                                                    <span class="badge badge-info rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Upcoming</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#upcoming"><i class="isax isax-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#upcoming">#HB-4581</a></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="hotel-details.html" class="avatar avatar-lg"><img src="assets/img/hotels/hotel-19.jpg" class="img-fluid rounded-circle" alt="img"></a>
                                                        <div class="ms-2">
                                                            <p class="text-dark mb-0 fw-medium fs-14"><a href="hotel-details.html">The Urban Retreat</a></p>
                                                            <span class="fs-14 fw-normal text-gray-6">Edinburgh</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <h6 class="fs-14 mb-1">Single Room</h6>
                                                    <span class="fs-14 fw-normal text-gray-6">2 Adults, 1 Child</span>
                                                </td>
                                                <td>2 Days, 1 Night</td>
                                                <td>$8,160</td>
                                                <td>04 Jun 2025</td>
                                                <td>
                                                    <span class="badge badge-info rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Upcoming</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#upcoming"><i class="isax isax-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#cancelled">#HB-3654</a></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="hotel-details.html" class="avatar avatar-lg"><img src="assets/img/hotels/hotel-22.jpg" class="img-fluid rounded-circle" alt="img"></a>
                                                        <div class="ms-2">
                                                            <p class="text-dark mb-0 fw-medium fs-14"><a href="hotel-details.html">Hotel Evergreen</a></p>
                                                            <span class="fs-14 fw-normal text-gray-6">Las Vegas</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <h6 class="fs-14 mb-1">Suite Room</h6>
                                                    <span class="fs-14 fw-normal text-gray-6">2 Adults, 1 Child</span>
                                                </td>
                                                <td>4 Days, 3 Nights</td>
                                                <td>$12,600</td>
                                                <td>02 Jul 2025</td>
                                                <td>
                                                    <span class="badge badge-danger rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Cancelled</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#cancelled"><i class="isax isax-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#pending">#HB-6545</a></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="hotel-details.html" class="avatar avatar-lg"><img src="assets/img/hotels/hotel-20.jpg" class="img-fluid rounded-circle" alt="img"></a>
                                                        <div class="ms-2">
                                                            <p class="text-dark mb-0 fw-medium fs-14"><a href="hotel-details.html">The Grand Horizon</a></p>
                                                            <span class="fs-14 fw-normal text-gray-6">Manchester</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <h6 class="fs-14 mb-1">Balcony View</h6>
                                                    <span class="fs-14 fw-normal text-gray-6">3 Adults, 2 Child</span>
                                                </td>
                                                <td>5 Days, 4 Nights</td>
                                                <td>$14,840</td>
                                                <td>17 Jun 2025</td>
                                                <td>
                                                    <span class="badge badge-secondary rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Pending</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#pending"><i class="isax isax-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                 /Hotel List 

                            </div>
                        </div>-->
                        <!-- /Hotel-Booking List -->

                    </div>
                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../../layout/footer.jsp" %>
        <!-- /Footer -->  

        <!-- Upcoming Modal -->
<!--        <div class="modal fade" id="upcoming" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5>Booking Info <span class="fs-14 fw-medium text-primary">#HB-1245</span></h5>
                        <a href="javascript:void(0);" data-bs-dismiss="modal" class="btn-close text-dark"></a>
                    </div>
                    <div class="modal-body">
                        <div class="upcoming-content">
                            <div class="upcoming-title mb-4 d-flex align-items-center justify-content-between p-3 rounded">
                                <div class="d-flex align-items-center flex-wrap">
                                    <div class="me-2">
                                        <img src="assets/img/hotels/hotel-13.jpg" alt="image" class="avatar avartar-md avatar-rounded">
                                    </div>
                                    <div>
                                        <h6 class="mb-1">The Luxe Haven</h6>
                                        <div class="title-list">
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-building me-2"></i>Luxury Hotel</p>
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-location5 me-2"></i>15/C Prince Dareen Road, New York</p>
                                            <p class="d-flex align-items-center pe-2 me-2  fw-normal"><span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>(400 Reviews)</p>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge badge-info rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Upcoming</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Room Details</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Type</h6>
                                        <p class="text-gray-6 fs-16 ">Queen Room</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Rooms</h6>
                                        <p class="text-gray-6 fs-16 ">1</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Price</h6>
                                        <p class="text-gray-6 fs-16 ">$400</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Guests</h6>
                                        <p class="text-gray-6 fs-16 ">4 Adults, 2 Child</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Booking Info</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booked On</h6>
                                        <p class="text-gray-6 fs-16 ">15 May 2024</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Check In Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Checkout Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">25 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Days Stay</h6>
                                        <p class="text-gray-6 fs-16 ">4 Days, 5 Nights</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Extra Service Info</h6>
                                <div class="d-flex align-items-center">
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Cleaning</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Airport Pickup</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14">Breakfast</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Billing Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Name</h6>
                                        <p class="text-gray-6 fs-16 ">Chris Foxy</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Email</h6>
                                        <p class="text-gray-6 fs-16 "><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="33505b41555c0100060573564b525e435f561d505c5e">[email&#160;protected]</a></p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Phone</h6>
                                        <p class="text-gray-6 fs-16 ">+1 12656 26654</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Address</h6>
                                        <p class="text-gray-6 fs-16 ">15/C Prince Dareen Road, New York</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Order Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Order Id</h6>
                                        <p class="text-primary fs-16 ">#45669</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Method</h6>
                                        <p class="text-gray-6 fs-16 ">Credit Card (Visa)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Status</h6>
                                        <p class="text-success fs-16 ">Paid</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Date of Payment</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Tax</h6>
                                        <p class="text-gray-6 fs-16 ">15% ($60)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Discount</h6>
                                        <p class="text-gray-6 fs-16 ">20% ($15)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booking Fees</h6>
                                        <p class="text-gray-6 fs-16 ">$25</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Total Paid</h6>
                                        <p class="text-gray-6 fs-16 ">$6569</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="javascript:void(0);" class="btn btn-md btn-primary" data-bs-toggle="modal" data-bs-target="#cancel-booking">Cancel Booking</a>
                    </div>
                </div>
            </div>
        </div>-->
        <!-- /Upcoming Modal -->

        <!-- Pending Modal -->
<!--        <div class="modal fade" id="pending" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5>Booking Info <span class="fs-14 fw-medium text-primary">#HB-1245</span></h5>
                        <a href="javascript:void(0);" data-bs-dismiss="modal" class="btn-close text-dark"></a>
                    </div>
                    <div class="modal-body">
                        <div class="upcoming-content">
                            <div class="upcoming-title mb-4 d-flex align-items-center justify-content-between p-3 rounded">
                                <div class="d-flex align-items-center flex-wrap">
                                    <div class="me-2">
                                        <img src="assets/img/hotels/hotel-13.jpg" alt="image" class="avatar avartar-md avatar-rounded">
                                    </div>
                                    <div>
                                        <h6 class="mb-1">The Luxe Haven</h6>
                                        <div class="title-list">
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-building me-2"></i>Luxury Hotel</p>
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-location5 me-2"></i>15/C Prince Dareen Road, New York</p>
                                            <p class="d-flex align-items-center pe-2 me-2  fw-normal"><span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>(400 Reviews)</p>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge badge-secondary rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Pending</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Room Details</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Type</h6>
                                        <p class="text-gray-6 fs-16 ">Queen Room</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Rooms</h6>
                                        <p class="text-gray-6 fs-16 ">1</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Price</h6>
                                        <p class="text-gray-6 fs-16 ">$400</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Guests</h6>
                                        <p class="text-gray-6 fs-16 ">4 Adults, 2 Child</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Booking Info</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booked On</h6>
                                        <p class="text-gray-6 fs-16 ">15 May 2024</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Check In Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Checkout Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">25 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Days Stay</h6>
                                        <p class="text-gray-6 fs-16 ">4 Days, 5 Nights</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Extra Service Info</h6>
                                <div class="d-flex align-items-center">
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Cleaning</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Airport Pickup</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14">Breakfast</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Billing Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Name</h6>
                                        <p class="text-gray-6 fs-16 ">Chris Foxy</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Email</h6>
                                        <p class="text-gray-6 fs-16 "><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="2b4843594d4419181e1d6b4e534a465b474e05484446">[email&#160;protected]</a></p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Phone</h6>
                                        <p class="text-gray-6 fs-16 ">+1 12656 26654</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Address</h6>
                                        <p class="text-gray-6 fs-16 ">15/C Prince Dareen Road, New York</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Order Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Order Id</h6>
                                        <p class="text-primary fs-16 ">#45669</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Method</h6>
                                        <p class="text-gray-6 fs-16 ">Credit Card (Visa)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Status</h6>
                                        <p class="text-success fs-16 ">Paid</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Date of Payment</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Tax</h6>
                                        <p class="text-gray-6 fs-16 ">15% ($60)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Discount</h6>
                                        <p class="text-gray-6 fs-16 ">20% ($15)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booking Fees</h6>
                                        <p class="text-gray-6 fs-16 ">$25</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Total Paid</h6>
                                        <p class="text-gray-6 fs-16 ">$6569</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="javascript:void(0);" class="btn btn-md btn-primary" data-bs-toggle="modal" data-bs-target="#cancel-booking">Cancel Booking</a>
                    </div>
                </div>
            </div>
        </div>-->
        <!-- /Pending Modal -->

        <!-- Completed Modal -->
<!--        <div class="modal fade" id="completed" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5>Booking Info <span class="fs-14 fw-medium text-primary">#HB-1245</span></h5>
                        <a href="javascript:void(0);" data-bs-dismiss="modal" class="btn-close text-dark"></a>
                    </div>
                    <div class="modal-body">
                        <div class="upcoming-content">
                            <div class="upcoming-title mb-4 d-flex align-items-center justify-content-between p-3 rounded">
                                <div class="d-flex align-items-center flex-wrap">
                                    <div class="me-2">
                                        <img src="assets/img/hotels/hotel-13.jpg" alt="image" class="avatar avartar-md avatar-rounded">
                                    </div>
                                    <div>
                                        <h6 class="mb-1">The Luxe Haven</h6>
                                        <div class="title-list">
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-building me-2"></i>Luxury Hotel</p>
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-location5 me-2"></i>15/C Prince Dareen Road, New York</p>
                                            <p class="d-flex align-items-center pe-2 me-2  fw-normal"><span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>(400 Reviews)</p>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Room Details</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Type</h6>
                                        <p class="text-gray-6 fs-16 ">Queen Room</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Rooms</h6>
                                        <p class="text-gray-6 fs-16 ">1</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Price</h6>
                                        <p class="text-gray-6 fs-16 ">$400</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Guests</h6>
                                        <p class="text-gray-6 fs-16 ">4 Adults, 2 Child</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Booking Info</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booked On</h6>
                                        <p class="text-gray-6 fs-16 ">15 May 2024</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Check In Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Checkout Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">25 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Days Stay</h6>
                                        <p class="text-gray-6 fs-16 ">4 Days, 5 Nights</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Extra Service Info</h6>
                                <div class="d-flex align-items-center">
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Cleaning</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Airport Pickup</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14">Breakfast</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Billing Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Name</h6>
                                        <p class="text-gray-6 fs-16 ">Chris Foxy</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Email</h6>
                                        <p class="text-gray-6 fs-16 "><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1c7f746e7a732e2f292a5c79647d716c7079327f7371">[email&#160;protected]</a></p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Phone</h6>
                                        <p class="text-gray-6 fs-16 ">+1 12656 26654</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Address</h6>
                                        <p class="text-gray-6 fs-16 ">15/C Prince Dareen Road, New York</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Order Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Order Id</h6>
                                        <p class="text-primary fs-16 ">#45669</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Method</h6>
                                        <p class="text-gray-6 fs-16 ">Credit Card (Visa)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Status</h6>
                                        <p class="text-success fs-16 ">Paid</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Date of Payment</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Tax</h6>
                                        <p class="text-gray-6 fs-16 ">15% ($60)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Discount</h6>
                                        <p class="text-gray-6 fs-16 ">20% ($15)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booking Fees</h6>
                                        <p class="text-gray-6 fs-16 ">$25</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Total Paid</h6>
                                        <p class="text-gray-6 fs-16 ">$6569</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="hotel-details.html" class="btn btn-md btn-primary">Book Again</a>
                    </div>
                </div>
            </div>
        </div>-->
        <!-- /Completed Modal -->

        <!-- Cancelled Modal -->
<!--        <div class="modal fade" id="cancelled" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5>Booking Info <span class="fs-14 fw-medium text-primary">#HB-1245</span></h5>
                        <a href="javascript:void(0);" data-bs-dismiss="modal" class="btn-close text-dark"></a>
                    </div>
                    <div class="modal-body">
                        <div class="upcoming-content">
                            <div class="upcoming-title mb-4 d-flex align-items-center justify-content-between p-3 rounded">
                                <div class="d-flex align-items-center flex-wrap">
                                    <div class="me-2">
                                        <img src="assets/img/hotels/hotel-13.jpg" alt="image" class="avatar avartar-md avatar-rounded">
                                    </div>
                                    <div>
                                        <h6 class="mb-1">The Luxe Haven</h6>
                                        <div class="title-list">
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-building me-2"></i>Luxury Hotel</p>
                                            <p class="d-flex align-items-center pe-2 me-2 border-end border-light fw-normal"><i class="isax isax-location5 me-2"></i>15/C Prince Dareen Road, New York</p>
                                            <p class="d-flex align-items-center pe-2 me-2  fw-normal"><span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>(400 Reviews)</p>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge badge-danger rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Cancelled</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Room Details</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Type</h6>
                                        <p class="text-gray-6 fs-16 ">Queen Room</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Rooms</h6>
                                        <p class="text-gray-6 fs-16 ">1</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Room Price</h6>
                                        <p class="text-gray-6 fs-16 ">$400</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Guests</h6>
                                        <p class="text-gray-6 fs-16 ">4 Adults, 2 Child</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Booking Info</h6>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booked On</h6>
                                        <p class="text-gray-6 fs-16 ">15 May 2024</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Check In Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Checkout Date & Time</h6>
                                        <p class="text-gray-6 fs-16 ">25 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">No of Days Stay</h6>
                                        <p class="text-gray-6 fs-16 ">4 Days, 5 Nights</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Extra Service Info</h6>
                                <div class="d-flex align-items-center">
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Cleaning</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14 me-2">Airport Pickup</span>
                                    <span class="bg-light rounded-pill py-1 px-2 text-gray-6 fs-14">Breakfast</span>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Billing Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Name</h6>
                                        <p class="text-gray-6 fs-16 ">Chris Foxy</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Email</h6>
                                        <p class="text-gray-6 fs-16 "><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="33505b41555c0100060573564b525e435f561d505c5e">[email&#160;protected]</a></p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Phone</h6>
                                        <p class="text-gray-6 fs-16 ">+1 12656 26654</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Address</h6>
                                        <p class="text-gray-6 fs-16 ">15/C Prince Dareen Road, New York</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details">
                                <h6 class="mb-2">Order Info</h6>
                                <div class="row gy-3">
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Order Id</h6>
                                        <p class="text-primary fs-16 ">#45669</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Method</h6>
                                        <p class="text-gray-6 fs-16 ">Credit Card (Visa)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Payment Status</h6>
                                        <p class="text-success fs-16 ">Paid</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Date of Payment</h6>
                                        <p class="text-gray-6 fs-16 ">20 May 2024, 10:50 AM</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Tax</h6>
                                        <p class="text-gray-6 fs-16 ">15% ($60)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Discount</h6>
                                        <p class="text-gray-6 fs-16 ">20% ($15)</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Booking Fees</h6>
                                        <p class="text-gray-6 fs-16 ">$25</p>
                                    </div>
                                    <div class="col-lg-3">
                                        <h6 class="fs-14">Total Paid</h6>
                                        <p class="text-gray-6 fs-16 ">$6569</p>
                                    </div>
                                </div>
                            </div>
                            <div class="upcoming-details mb-0">
                                <h6 class="mb-2">Cancel Reason</h6>
                                <div class="row">
                                    <div class="col-lg-5">
                                        <h6 class="fs-14">Reason</h6>
                                        <p class="text-gray-6 fs-16 ">Illness or medical appointments that prevent travel</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="hotel-details.html" class="btn btn-md btn-primary">Reschedule</a>
                    </div>
                </div>
            </div>
        </div>-->
        <!-- /Cancelled Modal -->

        <!-- Booking Cancel -->
<!--        <div class="modal fade" id="cancel-booking">
            <div class="modal-dialog  modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body p-5">
                        <form action="https://dreamstour.dreamstechnologies.com/html/agent-dashboard.html">
                            <div class="text-center">
                                <div class="mb-4">
                                    <i class="isax isax-location-cross5 text-danger fs-40"></i>
                                </div>
                                <h5 class="mb-2">Are you sure you want to cancel booking?</h5>
                                <p class="mb-4 text-gray-9">Order ID : <span class="text-primary">#HB-1245</span></p>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Reason <span class="text-danger">*</span></label>
                                <textarea class="form-control" rows="3"></textarea>
                            </div>    
                            <div class="d-flex align-items-center justify-content-center">
                                <a href="#" class="btn btn-light me-2" data-bs-dismiss="modal">No, Dont Cancel</a>
                                <button type="submit" class="btn btn-primary">Yes, Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>  -->
        <!-- /Booking Cancel -->

        <!-- Cursor -->
        <%@ include file="../../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../../layout/script.jsp" %>

        <script>
            $(document).ready(function () {
                // Dữ liệu thu nhập từ JSP
                var earnings = {
            ${yearMinus2}: ${earningsByYear[yearMinus2]},
            ${yearMinus1}: ${earningsByYear[yearMinus1]},
            ${currentYear}: ${earningsByYear[currentYear]}
                };

                // Hàm cập nhật giao diện
                function updateEarnings(year) {
                    var currentEarnings = earnings[year];
                    var lastYearEarnings = earnings[year - 1] || 0;
                    var percentageChange = lastYearEarnings !== 0 ?
                            ((currentEarnings - lastYearEarnings) / lastYearEarnings) * 100 : 0;

                    // Cập nhật tổng thu nhập
                    $("#totalEarnings").text("$" + currentEarnings.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,'));

                    // Cập nhật phần trăm thay đổi
                    var badgeClass = percentageChange >= 0 ? 'badge-soft-success border border-success' : 'badge-soft-danger border border-danger';
                    var iconClass = percentageChange >= 0 ? 'isax-arrow-up-3' : 'isax-arrow-down-2';
                    $("#percentageBadge").removeClass().addClass('badge badge-md rounded-pill me-2 ' + badgeClass);
                    $("#percentageBadge i").removeClass().addClass('isax ' + iconClass);
                    $("#percentageValue").text(Math.abs(percentageChange.toFixed(0)));

                    // Cập nhật năm hiển thị
                    $("#selectedYear").text(year);
                }

                // Khởi tạo với năm hiện tại
                updateEarnings(${currentYear});

                // Xử lý khi chọn năm từ dropdown
                $(".year-option").click(function () {
                    var selectedYear = parseInt($(this).data("year"));
                    updateEarnings(selectedYear);
                });
            });
        </script>
    </body>
</html>
