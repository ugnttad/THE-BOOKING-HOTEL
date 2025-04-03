<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.Hotel" %>
<%@ page import="dao.HotelDAO" %>

<%
    Hotel currentHotel = (Hotel) request.getAttribute("currentHotel");
    HotelDAO dao = new HotelDAO();
    // Debug trạng thái isFavorite ngay trong JSP
    out.println("<!-- Debug: Hotel " + currentHotel.getHotelId() + " isFavorite: " + currentHotel.isFavorite() + " -->");
%>
<div class="col-xl-4 col-md-6 d-flex">
    <div class="place-item mb-4 flex-fill">
        <div class="place-img">
            <c:set var="imageUrls" value="${currentHotel.hotelImageURLs}" />
            <c:choose>
                <c:when test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                    <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                    <c:set var="firstImage" value="${fn:split(cleanUrls, ',')[0]}" />
                    <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${currentHotel.hotelId}">
                        <img src="${fn:trim(fn:replace(firstImage, '\\"', ''))}" class="img-fluid" alt="${currentHotel.hotelName}">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${currentHotel.hotelId}">
                        <img src="${pageContext.request.contextPath}/assets/img/hotels/default-hotel.jpg" class="img-fluid" alt="Default">
                    </a>
                </c:otherwise>
            </c:choose>
            <div class="fav-item">
                <span class="badge bg-info d-inline-flex align-items-center"><i class="isax isax-ranking me-1"></i>Trending</span>
                <c:if test="${not empty sessionScope.user}">
                    <a href="javascript:void(0);" class="fav-icon" data-hotel-id="${currentHotel.hotelId}">
                        <i class="isax isax-heart5" style="${currentHotel.isFavorite() ? 'color: #dc3545 !important;' : ''}"></i>
                    </a>
                </c:if>
            </div>
        </div>
        <div class="place-content">
            <div class="d-flex align-items-center mb-1">
                <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2"><%=dao.getAverageHotelRating(currentHotel.getHotelId())%></span>
                <p class="fs-14">(<%=dao.getTotalFeedbackForHotel(currentHotel.getHotelId())%> Reviews)</p>
            </div>
            <h5 class="mb-1 text-truncate"><a href="${pageContext.request.contextPath}/hotel-details?hotelId=${currentHotel.hotelId}">${currentHotel.hotelName}</a></h5>
            <p class="d-flex align-items-center mb-2"><i class="isax isax-location5 me-2"></i>${currentHotel.location}</p>
            <div class="border-top pt-2 mb-2">
                <h6 class="d-flex align-items-center">Facilities :<i class="isax isax-home-wifi ms-2 me-2 text-primary"></i><i class="isax isax-scissor me-2 text-primary"></i><i class="isax isax-profile-2user me-2 text-primary"></i><i class="isax isax-wind-2 me-2 text-primary"></i><a href="javascript:void(0);" class="fs-14 fw-normal text-default d-inline-block">+2</a></h6>
            </div>
            <div class="d-flex align-items-center justify-content-between border-top pt-3">
                <h5 class="text-primary text-nowrap me-2">$${currentHotel.cheapestRoomPrice} <span class="fs-14 fw-normal text-default">/ Night</span></h5>
                <a href="javascript:void(0);" class="d-flex align-items-center overflow-hidden">
                    <span class="avatar avatar-md flex-shrink-0 me-2">
                        <img src="<%=dao.getHotelAgentDetails(currentHotel.getHotelId()).getAvatarUrl()%>" class="rounded-circle" alt="Agent">
                    </span>
                    <p class="fs-14"><%=dao.getHotelAgentDetails(currentHotel.getHotelId()).getFirstName()%> <%=dao.getHotelAgentDetails(currentHotel.getHotelId()).getLastName()%></p>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Thêm script xử lý AJAX -->
<c:if test="${empty pageScope.jqueryIncluded}">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <c:set var="jqueryIncluded" value="true" scope="page" />
</c:if>
<script>
    $(document).ready(function () {
        $('.fav-icon').on('click', function (e) {
            e.preventDefault(); // Ngăn hành động mặc định
            var $this = $(this);
            var hotelId = $this.data('hotel-id');
            var isFavorite = $this.find('i').css('color') === 'rgb(220, 53, 69)'; // Kiểm tra màu hiện tại (#dc3545)
            var action = isFavorite ? 'remove' : 'add';

            console.log('Clicked: HotelId=' + hotelId + ', IsFavorite=' + isFavorite + ', Action=' + action);

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
                        // Reload trang để cập nhật trạng thái từ server
                        window.location.reload();
                    } else if (response.status === 'conflict') {
                        alert(response.message);
                    } else if (response.status === 'not_found') {
                        alert(response.message);
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