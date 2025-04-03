<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="model.Room"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String checkInDateStr = (String) session.getAttribute("checkInDate");
    String checkOutDateStr = (String) session.getAttribute("checkOutDate");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    Date checkInDate = checkInDateStr != null ? dateFormat.parse(checkInDateStr) : null;
    Date checkOutDate = checkOutDateStr != null ? dateFormat.parse(checkOutDateStr) : null;
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <%@ include file="../layout/head.jsp" %>
    </head>

    <body>

        <!-- Header -->
        <%@ include file="../layout/header.jsp" %>

        <!-- Breadcrumb -->
        <c:set var="name" value="Hotel Booking" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <form action="${pageContext.request.contextPath}/process-checkout" method="POST">
            <input name="checkInDate" type="hidden" value="<%= checkInDate%>">
            <input name="checkOutDate" type="hidden" value="<%= checkOutDate%>">
            <div class="content content-two">
                <div class="container">          
                    <div class="row">

                        <!-- Checkout -->
                        <div class="col-lg-8">
                            <div class="card checkout-card">
                                <div class="card-header">
                                    <h5>Secure Checkout</h5>
                                </div>
                                <div class="card-body">
                                    <div>
                                        <div class="checkout-title">
                                            <h6 class="mb-2">Contact Info</h6>
                                        </div>
                                        <div class="checkout-details pb-2 border-bottom mb-4">
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Email</label>
                                                        <input name="email" type="email" value="<%=user.getEmail()%>" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-lg-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Phone</label>
                                                        <input name="phoneNumber" type="text" value="<%=user.getPhoneNumber()%>" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="checkout-title">
                                            <h6 class="mb-2">Traveler info</h6>
                                        </div>
                                        <div class="checkout-details">
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">First Name</label>
                                                        <input name="firstName" type="text" value="<%=user.getFirstName()%>" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-lg-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Last Name</label>
                                                        <input name="lastName" type="text" value="<%=user.getLastName()%>" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /Checkout -->

                        <!-- Review Order Details -->
                        <div class="col-lg-4 theiaStickySidebar">
                            <div class="card order-details">
                                <div class="card-header">
                                    <div class="d-flex align-items-center justify-content-between header-content">
                                        <h5>Review Order Details</h5>
                                        <a href="#" class="rounded-circle p-2 btn btn-light d-flex align-items-center justify-content-center"><span class="fs-16 d-flex align-items-center justify-content-center"><i class="isax isax-edit-2"></i></span></a>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="room" items="${selectedRoomsForCurrentHotel}">
                                        <div class="pb-3 border-bottom">
                                            <div class="mb-3 review-img">
                                                <img src="assets/img/hotels/hotel-large-02.jpg" alt="Img" class="img-fluid">
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between">
                                                <div>
                                                    <h6 class="mb-2">${room.getRoomTypeName()}</h6>
                                                </div>
                                                <h6 class="fs-14 fw-normal text-gray-9">$${room.getPricePerNight()}</h6>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="mt-3 border-bottom">
                                        <h6 class="text-primary mb-3">Order Info</h6>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <h6 class="fs-16">Check In</h6>
                                            <p class="fs-16"><%=checkInDateStr%> at 02:10 PM</p>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <h6 class="fs-16">Check Out</h6>
                                            <p class="fs-16"><%=checkOutDateStr%> at 12:00 PM</p>
                                        </div>
                                    </div>
                                    <div class="mt-3 border-bottom">
                                        <h6 class="text-primary mb-3">Payment Info</h6>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <h6 class="fs-16">Sub Total</h6>
                                            <p class="fs-16">$${subTotal}</p>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <h6 class="fs-16">Booking Fees</h6>
                                            <p class="fs-16">$10.0</p>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <h6>Amount to Pay</h6>
                                            <h6 class="text-primary">$${amountToPay}</h6>
                                        </div>
                                    </div>
                                </div>
                                <input name="total" type="hidden" value="${amountToPay}">
                                <div class="d-flex align-items-center justify-content-end flex-wrap gap-2 mb-2">
                                    <button type="submit" class="btn btn-primary">Confirm & Pay $${amountToPay} </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /Review Order Details -->

                </div>
            </div>
        </form>

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