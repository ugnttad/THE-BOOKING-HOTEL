<%@page import="dao.HotelDAO"%>
<%@page import="model.Hotel"%>
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
            <%@ include file="../layout/header.jsp" %>
        </div>

        <c:set var="name" value="My Wishlist" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />

        <div class="content">
            <div class="container">
                <div class="row">
                    <%@ include file="../layout/profile-sidebar.jsp" %>
                    <div class="col-xl-9 col-lg-8">
                        <div class="card">
                            <div class="card-body">
                                <h6>My Wishlist</h6>
                                <p class="fs-14">Items in Wishlist: ${fn:length(favoriteHotels)}</p>
                            </div>
                        </div>

                        <div class="hotel-list">
                            <c:forEach var="hotel" items="${favoriteHotels}">
                                <div class="place-item mb-4" data-hotel-id="${hotel.hotelId}">
                                    <div class="place-img">
                                        <c:set var="imageUrls" value="${hotel.getHotelImageURLs()}" />
                                        <c:choose>
                                            <c:when test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                                                <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                                                <c:set var="firstImage" value="${fn:split(cleanUrls, ',')[0]}" />
                                                <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">
                                                    <img src="${fn:trim(fn:replace(firstImage, '\\"', ''))}" class="img-fluid" alt="${hotel.hotelName}">
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">
                                                    <img src="${pageContext.request.contextPath}/assets/img/hotels/default-hotel.jpg" class="img-fluid" alt="Default">
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="fav-item">
                                            <a href="javascript:void(0);" class="fav-icon" data-hotel-id="${hotel.hotelId}">
                                                <i class="isax isax-heart5" style="color: #dc3545 !important;"></i>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="place-content pb-1">
                                        <div class="d-flex align-items-center justify-content-between flex-wrap">
                                            <div>
                                                <h5 class="mb-1 text-truncate">
                                                    <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">${hotel.hotelName}</a>
                                                </h5>
                                                <p class="d-flex align-items-center mb-2"><i class="isax isax-location5 me-2"></i>${hotel.location}</p>
                                            </div>
                                            <div class="d-flex align-items-center mb-2">
                                                <a href="javascript:void(0);" class="d-flex align-items-center overflow-hidden border-end pe-2 me-2">
                                                    <span class="avatar avatar-md flex-shrink-0 me-2">
                                                        <img src="${pageContext.request.contextPath}/assets/img/users/user-default.jpg" class="rounded-circle" alt="Agent">
                                                    </span>
                                                    <p class="fs-14 text-truncate">${hotel.agentName}</p>
                                                </a>
                                                <div class="d-flex align-items-center text-nowrap">
                                                    <%
                                                        Hotel currentHotel = (Hotel) pageContext.getAttribute("hotel");
                                                        HotelDAO dao = new HotelDAO();
                                                        double avgRating = dao.getAverageHotelRating(currentHotel.getHotelId());
                                                        int totalFeedback = dao.getTotalFeedbackForHotel(currentHotel.getHotelId());
                                                    %>
                                                    <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2"><%= avgRating %></span>
                                                    <p class="fs-14">(<%= totalFeedback %> Reviews)</p>
                                                </div>
                                            </div>
                                        </div>
                                        <p class="line-ellipsis fs-14">${hotel.description}</p>
                                        <div class="d-flex align-items-center justify-content-between flex-wrap border-top pt-3">
                                            <h6 class="d-flex align-items-center mb-3">
                                                Facilities: 
                                                <i class="isax isax-home-wifi ms-2 me-2 text-primary"></i>
                                                <i class="isax isax-scissor me-2 text-primary"></i>
                                                <i class="isax isax-profile-2user me-2 text-primary"></i>
                                                <i class="isax isax-wind-2 me-2 text-primary"></i>
                                                <a href="javascript:void(0);" class="fs-14 fw-normal text-default d-inline-block">+2</a>
                                            </h6>
                                            <h5 class="text-primary text-nowrap me-2 mb-3">
                                                $${hotel.cheapestRoomPrice} <span class="fs-14 fw-normal text-default">/ Night</span>
                                            </h5>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="../layout/footer.jsp" %>
            <%@ include file="../layout/cursor.jsp" %>
            <%@ include file="../layout/back-to-top.jsp" %>
            <%@ include file="../layout/script.jsp" %>

            <!-- Script xử lý AJAX cho wishlist -->
            <script>
                $(document).ready(function () {
                    $('.fav-icon').on('click', function (e) {
                        e.preventDefault();
                        var $this = $(this);
                        var hotelId = $this.data('hotel-id');
                        var $hotelItem = $this.closest('.place-item'); // Lấy phần tử hotel để xóa
                        var action = 'remove'; // Trong wishlist, click chỉ có thể xóa

                        console.log('Clicked: HotelId=' + hotelId + ', Action=' + action);

                        $.ajax({
                            url: '${pageContext.request.contextPath}/favorites',
                            type: 'POST',
                            data: {
                                action: action,
                                hotelId: hotelId
                            },
                            dataType: 'json',
                            success: function (response) {
                                console.log('Server response:', response);
                                if (response.status === 'success') {
                                    // Xóa phần tử khỏi giao diện trước khi reload
                                    $hotelItem.fadeOut(300, function() {
                                        $(this).remove();
                                        // Kiểm tra nếu không còn hotel nào thì hiển thị thông báo
                                        if ($('.place-item').length === 0) {
                                            $('.hotel-list').html('<p class="text-center">Your wishlist is empty.</p>');
                                        }
                                        // Reload trang để đồng bộ dữ liệu
                                        window.location.reload();
                                    });
                                } else {
                                    alert('Failed to remove hotel: ' + response.message);
                                }
                            },
                            error: function (xhr) {
                                console.log('AJAX error: Status=' + xhr.status + ', Response=' + xhr.responseText);
                                if (xhr.status === 401) {
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                } else {
                                    alert('Error processing your request. Please try again.');
                                }
                            }
                        });
                    });
                });
            </script>
    </body>
</html>