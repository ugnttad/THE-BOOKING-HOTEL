<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <%@ include file="../../layout/head.jsp" %>

        <style>
            .place-img {
                position: relative;
                width: 100%;
                height: 200px; /* Chiều cao cố định cho ảnh */
                overflow: hidden;
            }
            .place-img img {
                width: 100%;
                height: 100%;
                object-fit: cover; /* Đảm bảo ảnh lấp đầy khung mà không bị méo */
                object-position: center; /* Căn giữa ảnh */
            }
            .edit-delete-item {
                position: absolute;
                top: 10px;
                right: 10px;
                background: rgba(0, 0, 0, 0.5); /* Nền mờ cho nút edit/delete */
                padding: 5px;
                border-radius: 5px;
            }
        </style>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Add Hotel" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Sidebar -->
                    <%@ include file="../../layout/profile-sidebar.jsp" %>

                    <div class="col-xl-9 col-lg-8"> 
                        <div class="tab-content">
                            <!-- Hotels List -->
                            <div class="tab-pane fade active show" id="Hotels-list">
                                <div class="card border-0">
                                    <div class="card-body d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                                        <div>
                                            <h5 class="mb-1">Listings</h5>
                                            <p>No of  Listings : ${hotels.size()}</p>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/add-hotel" class="btn btn-primary d-inline-flex align-items-center me-0"><i class="isax isax-add me-1 fs-16"></i>Add Hotel</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="row justify-content-center">

                                    <!-- Hotel Grid -->
                                    <c:forEach var="hotel" items="${hotels}">
                                        <div class="col-xl-4 col-md-6 d-flex">
                                            <div class="place-item mb-4 flex-fill">
                                                <div class="place-img">
                                                    <a href="#">
                                                        <c:set var="imageUrls" value="${hotel.hotelImageURLs}" />
                                                        <c:choose>
                                                            <c:when test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                                                                <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                                                                <c:set var="firstImage" value="${fn:split(cleanUrls, ',')[0]}" />
                                                                <c:set var="firstImage" value="${fn:trim(fn:replace(firstImage, '\"', ''))}" />
                                                                <img src="${firstImage}" alt="${hotel.hotelName}" onerror="this.src='assets/img/hotels/default-hotel.jpg'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="assets/img/hotels/default-hotel.jpg" alt="Default Image">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </a>
                                                    <div class="edit-delete-item d-flex align-items-center">
                                                        <a href="edit-hotel?hotelId=${hotel.hotelId}" class="me-2 d-inline-flex align-items-center justify-content-center">
                                                            <i class="isax isax-edit"></i>
                                                        </a>
                                                        <!--                                                        <a href="#" class="d-inline-flex align-items-center justify-content-center" data-bs-toggle="modal" data-bs-target="#delete-list">
                                                                                                                    <i class="isax isax-trash"></i>
                                                                                                                </a>-->
                                                    </div>
                                                </div>
                                                <div class="place-content">
                                                    <h5 class="mb-1 text-truncate">
                                                        <a href="hotel-details.html?hotelId=${hotel.hotelId}">${hotel.hotelName}</a>
                                                    </h5>
                                                    <p class="d-flex align-items-center mb-2">
                                                        <i class="isax isax-location5 me-2"></i>${hotel.location}
                                                    </p>
                                                    <div class="d-flex align-items-center justify-content-between border-top pt-3">
                                                        <h5 class="text-primary text-nowrap me-2">
                                                            $${hotel.cheapestRoomPrice} <span class="fs-14 fw-normal text-default">/ Night</span>
                                                        </h5>
                                                        <div class="d-flex align-items-center lh-1">
                                                            <c:choose>
                                                                <c:when test="${hotel.isActive()}">
                                                                    <a href="#inactive_list" data-bs-toggle="modal" class="d-flex align-items-center">
                                                                        <i class="isax isax-info-circle me-1"></i>
                                                                        Active
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise><a href="#active_list" data-bs-toggle="modal" class="d-flex align-items-center">
                                                                        <i class="isax isax-info-circle me-1"></i>
                                                                        Inactive
                                                                    </a></c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <!-- /Hotel Grid -->

                                    <div class="col-md-12">
                                        <!-- Pagination -->
                                        <nav class="pagination-nav">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item disabled">
                                                    <a class="page-link" href="javascript:void(0);" aria-label="Previous">
                                                        <span aria-hidden="true"><i class="fa-solid fa-chevron-left"></i></span>
                                                    </a>
                                                </li>
                                                <li class="page-item"><a class="page-link" href="javascript:void(0);">1</a></li>
                                                <li class="page-item"><a class="page-link" href="javascript:void(0);">2</a></li>
                                                <li class="page-item"><a class="page-link" href="javascript:void(0);">3</a></li>
                                                <li class="page-item active"><a class="page-link" href="javascript:void(0);">4</a></li>
                                                <li class="page-item"><a class="page-link" href="javascript:void(0);">5</a></li>
                                                <li class="page-item">
                                                    <a class="page-link" href="javascript:void(0);" aria-label="Next">
                                                        <span aria-hidden="true"><i class="fa-solid fa-chevron-right"></i></span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                        <!-- /Pagination -->
                                    </div>

                                </div>
                            </div>
                            <!-- /Hotels List -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../../layout/footer.jsp" %>
        <!-- /Footer --> 

        <!-- Inactive Modal -->
        <div class="modal fade" id="inactive_list" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="text-center">
                            <h5 class="mb-3">Inactive Listing</h5>
                            <p class="mb-3">Are you sure you want to mark this listing as inactive and keep it unavailable</p>
                            <div class="d-flex align-items-center justify-content-center">
                                <a href="#" class="btn btn-light me-2">No</a>
                                <a href="agent-listings.html" class="btn btn-primary">Yes</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Inactive Modal -->

        <!-- Active Modal -->
        <div class="modal fade" id="active_list" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="text-center">
                            <h5 class="mb-3">Active Listing</h5>
                            <p class="mb-3">Are you sure you want to mark this listing as active and keep it available?</p>
                            <div class="d-flex align-items-center justify-content-center">
                                <a href="#" class="btn btn-light me-2">No</a>
                                <a href="agent-listings.html" class="btn btn-primary">Yes</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Active Modal -->

        <!-- Delete Modal -->
<!--        <div class="modal fade" id="delete-list" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="text-center">
                            <h5 class="mb-3">Delete Listing</h5>
                            <p class="mb-3">Are you sure you want to delete this listing?</p>
                            <div class="d-flex align-items-center justify-content-center">
                                <a href="#" class="btn btn-light me-2">No</a>
                                <a href="agent-listings.html" class="btn btn-primary">Yes, Delete</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>-->
        <!--  Delete Modal -->

        <!-- Cursor -->
        <%@ include file="../../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../../layout/script.jsp" %>
    </body>
</html>