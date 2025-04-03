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

        <!-- Header -->
        <%@ include file="../layout/header.jsp" %>

        <!-- Breadcrumb -->
        <c:set var="name" value="Hotels" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <!-- Hotel Search -->
                <%@ include file="../layout/hotel/hotel-search.jsp" %>
                <!-- /Hotel Search -->

                <div class="row">

                    <!-- Sidebar -->
                    <%@ include file="../layout/hotel/sidebar.jsp" %>
                    <!-- /Sidebar -->

                    <div class="col-xl-9 col-lg-8 theiaStickySidebar">
                        <div class="d-flex align-items-center justify-content-between flex-wrap">
                            <h6 class="mb-3">${hotelList.size()} Hotels Found</h6>
                            <div class="d-flex align-items-center flex-wrap">
                                <div class="dropdown mb-3">
                                    <a href="javascript:void(0);" class="dropdown-toggle py-2" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span class="fw-medium text-gray-9">Sort By : </span>Default
                                    </a>
                                    <div class="dropdown-menu dropdown-sm">
                                        <form action="https://dreamstour.dreamstechnologies.com/html/hotel-grid.html">
                                            <h6 class="fw-medium fs-16 mb-3">Sort By</h6>
                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                <input class="form-check-input ms-0 mt-0" name="recommend" type="checkbox" id="recommend2">
                                                <label class="form-check-label ms-2" for="recommend2">Price: low to high</label>
                                            </div>
                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                <input class="form-check-input ms-0 mt-0" name="recommend" type="checkbox" id="recommend3">
                                                <label class="form-check-label ms-2" for="recommend3">Price: high to low</label>
                                            </div>
                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                <input class="form-check-input ms-0 mt-0" name="recommend" type="checkbox" id="recommend5">
                                                <label class="form-check-label ms-2" for="recommend5">Ratings</label>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-end border-top pt-3 mt-3">
                                                <a href="javascript:void(0);" class="btn btn-light btn-sm me-2">Reset</a>
                                                <button type="submit" class="btn btn-primary btn-sm">Apply</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row justify-content-center">
                            <c:forEach var="hotel" items="${hotelList}">
                                <c:set var="currentHotel" value="${hotel}" scope="request" />
                                <%@ include file="../layout/hotel/hotel-component.jsp" %>
                            </c:forEach>
                        </div>

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