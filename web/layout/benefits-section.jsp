<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<section class="section benifit-section bg-light-200">
    <div class="container">
        <div class="section-header d-flex align-items-center justify-content-between flex-wrap row-gap-3">
            <div>
                <p class="mb-2 fw-medium d-flex align-items-center"><span class="text-bar"></span>Trending Hotel</p>
                <h2>Focusing on Unique Experiences<span class="text-primary">.</span></h2>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/hotels" class="btn btn-primary">View All Hotels<i class="isax isax-arrow-right-3 ms-2"></i></a>
            </div>
        </div>
        <div class="place-slider owl-carousel">
            <c:forEach var="hotel" items="${topHotels}">
                <div class="place-item mb-4 flex-fill">
                    <div class="place-img">
                        <div class="img-slider image-slide owl-carousel nav-center">
                            <c:set var="imageUrls" value="${hotel.hotelImageURLs}" />
                            <c:choose>
                                <c:when test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                                    <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                                    <c:forEach var="image" items="${fn:split(cleanUrls, ',')}" varStatus="loop" end="2">
                                        <div class="slide-images">
                                            <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">
                                                <img src="${fn:trim(fn:replace(image, '\\"', ''))}" class="img-fluid" alt="${hotel.hotelName}">
                                            </a>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="slide-images">
                                        <a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">
                                            <img src="${pageContext.request.contextPath}/assets/img/hotels/default-hotel.jpg" class="img-fluid" alt="Default">
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="fav-item">
                            <span class="badge bg-info d-inline-flex align-items-center"><i class="isax isax-ranking me-1"></i>Trending</span>
                            <c:if test="${not empty sessionScope.user}">
                                <a href="javascript:void(0);" class="fav-icon" data-hotel-id="${hotel.hotelId}" data-is-favorite="${hotel.isFavorite()}">
                                    <i class="isax ${hotel.isFavorite() ? 'isax-heart5 text-danger' : 'isax-heart5'}"></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                    <div class="place-content">
                        <div class="d-flex align-items-center mb-1">
                            <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">4.5</span>
                            <p class="fs-14">(500 Reviews)</p>
                        </div>
                        <h5 class="mb-1 text-truncate"><a href="${pageContext.request.contextPath}/hotel-details?hotelId=${hotel.hotelId}">${hotel.hotelName}</a></h5>
                        <p class="d-flex align-items-center mb-2"><i class="isax isax-location5 me-2"></i>${hotel.location}</p>
                        <div class="border-top pt-2 mb-2">
                            <h6 class="d-flex align-items-center">Facilities: <i class="isax isax-home-wifi ms-2 me-2 text-primary"></i><i class="isax isax-scissor me-2 text-primary"></i><i class="isax isax-profile-2user me-2 text-primary"></i><i class="isax isax-wind-2 me-2 text-primary"></i><a href="javascript:void(0);" class="fs-14 fw-normal text-default d-inline-block">+2</a></h6>
                        </div>
                        <div class="d-flex align-items-center justify-content-between border-top pt-3">
                            <h5 class="text-primary text-nowrap me-2">$${hotel.cheapestRoomPrice} <span class="fs-14 fw-normal text-default">/ Night</span></h5>
                            <a href="javascript:void(0);" class="d-flex align-items-center overflow-hidden">
                                <span class="avatar avatar-md flex-shrink-0 me-2">
                                    <img src="${pageContext.request.contextPath}/assets/img/users/user-default.jpg" class="rounded-circle" alt="Agent">
                                </span>
                                <p class="fs-14 text-truncate">${hotel.agentName}</p>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Thêm script xử lý AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        $('.fav-icon').on('click', function (e) {
            e.preventDefault(); // Ngăn hành động mặc định
            var $this = $(this);
            var $icon = $this.find('i');
            var hotelId = $this.data('hotel-id');
            var isFavorite = $icon.hasClass('text-danger'); // Dùng trạng thái màu đỏ để xác định
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
                        // Tải lại trang sau khi xử lý thành công
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