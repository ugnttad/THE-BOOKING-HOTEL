<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.Hotel" %>
<%@ page import="dao.HotelDAO" %>
<%@ page import="dao.BookingDAO" %>

<%
    Hotel currentHotel = (Hotel) request.getAttribute("hotel");
    HotelDAO dao = new HotelDAO();

    BookingDAO bookingDAO = new BookingDAO();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="../layout/head.jsp" %>

        <style>
            .edit-popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
                z-index: 1000;
                width: 400px;
                max-width: 90%;
            }
            .edit-popup.active {
                display: block;
            }
            .overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 999;
            }
            .overlay.active {
                display: block;
            }
            .rating-selction input[type="radio"] {
                display: none;
            }
            .rating-selction label {
                cursor: pointer;
                color: #ddd;
            }
            .rating-selction input[type="radio"]:checked + label,
            .rating-selction input[type="radio"]:checked ~ label {
                color: #ffd700;
            }
        </style>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>

    <body>

        <!-- Header -->
        <%@ include file="../layout/header.jsp" %>

        <!-- Breadcrumb -->
        <c:set var="name" value="Hotel Details" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Hotel Details -->
                    <div class="col-xl-8">

                        <!-- Slider -->
                        <div class="d-flex align-items-center justify-content-between flex-wrap mb-2">
                            <div class="mb-2">
                                <h4 class="mb-1 d-flex align-items-center flex-wrap"><%=currentHotel.getHotelName()%>
                                    <% if (currentHotel.isIsAccepted()) { %>
                                    <span class="badge badge-xs bg-success rounded-pill ms-2">
                                        <i class="isax isax-ticket-star me-1"></i>Verified
                                    </span>
                                    <% } else { %>
                                    <span class="badge badge-xs bg-warning rounded-pill ms-2">
                                        <i class="isax isax-ticket-star me-1"></i>Pending
                                    </span>
                                    <% }%>
                                </h4>
                                <div class="d-flex align-items-center flex-wrap">
                                    <p class="fs-14 mb-2 me-3 pe-3 border-end"><i class="isax isax-buildings me-2"></i>Hotel</p>
                                    <p class="fs-14 mb-2 me-3 pe-3 border-end"><i class="isax isax-location5 me-2"></i><%=currentHotel.getLocation()%></p>
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2"><%=dao.getAverageHotelRating(currentHotel.getHotelId())%></span>
                                        <p class="fs-14"><a href="#reviews">(<%=dao.getTotalFeedbackForHotel(currentHotel.getHotelId())%> Reviews)</a></p>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center mb-3">
                                <a href="javascript:void(0);" class="btn btn-outline-light btn-icon btn-sm d-flex align-items-center justify-content-center me-2"><i class="isax isax-share"></i></a>
                                <a href="javascript:void(0);" class="btn btn-outline-light btn-sm d-inline-flex align-items-center"><i class="isax isax-heart5 text-danger me-1"></i>Save</a>
                            </div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between flex-wrap mb-3">
                            <div class="d-flex align-items-center flex-wrap">
                                <p class="fs-14 me-2 mb-2"><i class="isax isax-tick-circle5 text-success me-2"></i>Fully refundable</p>
                                <p class="fs-14 me-2 mb-2"><i class="isax isax-tick-circle5 text-success me-2"></i>Express check-in/out available</p>
                                <p class="fs-14 mb-2"><i class="isax isax-tick-circle5 text-success me-2"></i>Minimum check-in age: 18</p>
                            </div>
                            <span class="badge badge-light text-gray-9 badge-md fs-13 fw-medium rounded-pill mb-2">Total <%=dao.getTotalRoomsForHotel(currentHotel.getHotelId())%> Rooms </span>
                        </div>

                        <!-- Popular Amenities -->
                        <%@ include file="../layout/hotel/popular-amenities.jsp" %>
                        <!-- /Popular Amenities -->

                        <!-- Room types -->
                        <%@ include file="../layout/hotel/room-types.jsp" %>
                        <!-- /Room types -->

                        <!-- Availability -->
                        <c:set var="rooms" value="${hotelRooms}" scope="request" />
                        <%@ include file="../layout/hotel/room-list.jsp" %>
                        <!-- /Availability -->

                        <!-- Services -->
                        <%@ include file="../layout/hotel/hotel-services.jsp" %>
                        <!-- /Services -->

                        <!-- Gallery -->
                        <%@ include file="../layout/hotel/gallery.jsp" %>
                        <!-- /Gallery -->

                        <!-- Hotel Rules -->
                        <%@ include file="../layout/hotel/hotel-rules.jsp" %>
                        <!-- /Hotel Rules -->

                        <!-- Reviews -->
                        <%@ include file="../layout/hotel/hotel-reviews.jsp" %>
                        <!-- /Reviews -->

                    </div>
                    <!-- /Hotel Details -->

                    <!-- Sidebar Details -->
                    <%@ include file="../layout/hotel/selected-rooms-sidebar.jsp" %>
                    <!-- /Sidebar Details -->

                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../layout/footer.jsp" %>
        <!-- /Footer -->

        <!-- Login Modal -->
        <%@ include file="../layout/loginModal.jsp" %>
        <!-- /Login Modal -->

        <!-- Register Modal -->
        <%@ include file="../layout/registerModal.jsp" %>
        <!-- /Register Modal -->

        <!-- Forgot Password -->
        <%@ include file="../layout/forgot-password.jsp" %>
        <!-- /Forgot Password -->

        <!-- Cursor -->
        <%@ include file="../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../layout/script.jsp" %>
</html>