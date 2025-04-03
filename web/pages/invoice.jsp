<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <%@ include file="../layout/head.jsp" %>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Invoice" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <!-- Invoices -->
                <div class="row justify-content-center">
                    <div class="col-md-9">
                        <div class="card mb-0">
                            <div class="card-body">
                                <div class="border-bottom mb-4">
                                    <div class="row justify-content-between align-items-center flex-wrap row-gap-4">
                                        <div class="col-md-6">
                                            <div class="mb-2 invoice-logo-dark">
                                                <img src="${pageContext.request.contextPath}/assets/img/hotel-logo.svg" class="img-fluid" alt="logo">
                                            </div>
                                            <div class="mb-2 invoice-logo-white">
                                                <img src="${pageContext.request.contextPath}/assets/img/hotel-logo-dark.svg" class="img-fluid" alt="logo">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class=" text-end mb-3">
                                                <h6 class="text-default mb-1">Invoice No <span class="text-primary fw-medium">#${invoice.transactionId}</span></h6>
                                                <p class="fs-14 mb-1 fw-medium">Created Date : <span class="text-gray-9"><fmt:formatDate value="${invoice.bookings[0].checkInDate}" pattern="dd/MM/yyyy"/></span> </p>
                                                <p class="fs-14 fw-medium">Due Date : <span class="text-gray-9"><fmt:formatDate value="${invoice.bookings[0].checkOutDate}" pattern="dd/MM/yyyy" /></span> </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="border-bottom mb-4">
                                    <div class="row align-items-center g-4">
                                        <div class="col-md-5">
                                            <h6 class="mb-3 fw-semibold fs-14">From</h6>
                                            <div>
                                                <h6 class="mb-1">${invoice.hotelAgent.firstName} ${invoice.hotelAgent.lastName}</h6>
                                                <p class="fs-14 mb-1">Email : <span class="text-gray-9">${invoice.hotelAgent.email}</span></p>
                                                <p class="fs-14">Phone : <span class="text-gray-9">+${invoice.hotelAgent.phoneNumber}</span></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6 class="mb-3 fw-semibold fs-14">To</h6>
                                            <div>
                                                <h6 class="mb-1">${user.getFirstName()} ${user.getLastName()}</h6>
                                                <p class="fs-14 mb-1">Email : <span class="text-gray-9">${user.getEmail()}</span></p>
                                                <p class="fs-14">Phone : <span class="text-gray-9">+${user.getPhoneNumber()}</span></p>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <h6 class="mb-1 fs-14 fw-medium">Payment Status </h6>
                                                <span class="badge badge-success align-items-center fs-10 mb-4"><i class="ti ti-point-filled "></i>${invoice.bookings[0].bookingStatus}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <p class="fw-medium mb-3">Invoice For : <span class="text-dark fw-medium">Hotel Booking</span></p>
                                    <div class="table-responsive">
                                        <table class="table invoice-table">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th class="w-50 bg-light-400">Description</th>
                                                    <th class="text-center bg-light-400">Qty</th>
                                                    <th class="text-end bg-light-400">Cost</th>
                                                    <th class="text-end bg-light-400">Discount</th>
                                                    <th class="text-end bg-light-400">Total</th>
                                                </tr>
                                            </thead>

                                            <tbody>
                                                <c:set var="subTotal" value="0" />
                                                <c:set var="bookingFee" value="10.0" />
                                                <c:set var="discount" value="0" />
                                                <c:forEach var="booking" items="${invoice.bookings}">
                                                    <tr>
                                                        <td>${booking.hotelName} - ${booking.roomType}</td>
                                                        <td class="text-gray fs-14 fw-medium text-center">${booking.quantity}</td>
                                                        <td class="text-gray fs-14 fw-medium text-end">${booking.pricePerNight}</td>
                                                        <td class="text-gray fs-14 fw-medium text-end">0</td>
                                                        <td class="text-gray fs-14 fw-medium text-end">${booking.quantity * booking.pricePerNight}</td>
                                                    </tr>
                                                    <c:set var="subTotal" value="${subTotal + booking.quantity * booking.pricePerNight}" />
                                                </c:forEach>
                                                <c:set var="totalAmount" value="${subTotal + bookingFee - discount}" />
                                            </tbody>

                                        </table>
                                    </div>
                                </div>
                                <div class="row border-bottom mb-3">
                                    <div class="col-md-7">
                                        <div class="py-4">
                                            <div class="mb-3">
                                                <h6 class="fs-14 mb-1">Terms and Conditions</h6>
                                                <p class="fs-12">Please pay within 15 days from the date of invoice, overdue interest @ 14% will be charged on delayed payments.</p>
                                            </div>
                                            <div class="mb-3">
                                                <h6 class="fs-14 mb-1">Notes</h6>
                                                <p class="fs-12">Please quote invoice number when remitting funds.</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="d-flex justify-content-between align-items-center border-bottom my-2 pe-3">
                                            <p class="fs-14 fw-medium text-gray mb-0">Sub Total</p>
                                            <p class="text-gray-9 fs-14 fw-medium mb-2">$${subTotal}</p>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center border-bottom my-2 pe-3">
                                            <p class="fs-14 fw-medium text-gray mb-0">Discount (0%)</p>
                                            <p class="text-gray-9 fs-14 fw-medium mb-2">$0</p>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                            <p class="fs-14 fw-medium text-gray mb-0">Booking Fees</p>
                                            <p class="text-gray-9 fs-14 fw-medium mb-2">$10.0</p>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                            <h6>Total Amount</h6>
                                            <h6>$${totalAmount}</h6>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <div class="mb-3 invoice-logo-dark">
                                        <img src="${pageContext.request.contextPath}/assets/img/hotel-logo.svg" class="img-fluid" alt="logo">
                                    </div>
                                    <div class="mb-3 invoice-logo-white">
                                        <img src="${pageContext.request.contextPath}/assets/img/hotel-logo-dark.svg" class="img-fluid" alt="logo">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- /Invoices -->

            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../layout/footer.jsp" %>
        <!-- /Footer -->

        <!-- Cursor -->
        <%@ include file="../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../layout/script.jsp" %>
</html>