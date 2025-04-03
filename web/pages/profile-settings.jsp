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
        <div class="breadcrumb-bar breadcrumb-bg-04 text-center">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 col-12">
                        <h2 class="breadcrumb-title mb-2">Settings</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center mb-0">
                                <li class="breadcrumb-item"><a href="index.html"><i class="isax isax-grid-55"></i></a></li>
                                <li class="breadcrumb-item active" aria-current="page">Profile Settings</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Sidebar -->
                    <div class="col-xl-3 col-lg-4 theiaStickySidebar">
                        <div class="card user-sidebar mb-4 mb-lg-0">
                            <div class="card-header user-sidebar-header">
                                <div class="profile-content rounded-pill">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class=" d-flex align-items-center justify-content-center">
                                            <img src="${user.getAvatarUrl()}" alt="image" class="img-fluid avatar avatar-lg rounded-circle me-1">
                                            <div>
                                                <h6 class="fs-16">${user.getGoogleId()}</h6>
                                                <span class="fs-14 text-gray-6">Since 10 May 2025</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex align-items-center justify-content-center">
                                                <a href="profile-settings.html" class="p-1 rounded-circle btn btn-light d-flex align-items-center justify-content-center"><i class="isax isax-edit-2 fs-14"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body user-sidebar-body">
                                <ul>
                                    <li>
                                        <span class="fs-14 text-gray-3 fw-medium mb-2">Main</span>
                                    </li>
                                    <li>
                                        <a href="dashboard.html" class="d-flex align-items-center">
                                            <i class="isax isax-grid-55"></i> Dashboard
                                        </a>
                                    </li>
                                    <li class="submenu">
                                        <a href="javascript:void(0);" class="d-block"><i class="isax isax-calendar-tick5"></i><span>My Bookings</span><span class="menu-arrow"></span></a>
                                        <ul>
                                            <li>
                                                <a href="customer-flight-booking.html" class="fs-14 d-inline-flex align-items-center">Flights</a>
                                            </li>
                                            <li>
                                                <a href="customer-hotel-booking.html" class="fs-14 d-inline-flex align-items-center">Hotels</a>
                                            </li>
                                            <li>
                                                <a href="customer-car-booking.html" class="fs-14 d-inline-flex align-items-center">Cars</a>
                                            </li>
                                            <li>
                                                <a href="customer-cruise-booking.html" class="fs-14 d-inline-flex align-items-center">Cruise</a>
                                            </li>
                                            <li>
                                                <a href="customer-tour-booking.html" class="fs-14 d-inline-flex align-items-center">Tour</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="review.html" class="d-flex align-items-center">
                                            <i class="isax isax-magic-star5"></i> My Reviews
                                        </a>
                                    </li>
                                    <li>
                                        <div class="message-content">
                                            <a href="chat.html" class="d-flex align-items-center">
                                                <i class="isax isax-message-square5"></i> Messages
                                            </a>
                                            <span class="msg-count rounded-circle">02</span>
                                        </div>
                                    </li>
                                    <li class="mb-2">
                                        <a href="wishlist.html" class="d-flex align-items-center">
                                            <i class="isax isax-heart5"></i> Wishlist
                                        </a>
                                    </li>
                                    <li>
                                        <span class="fs-14 text-gray-3 fw-medium mb-2">Finance</span>
                                    </li>
                                    <li>
                                        <a href="wallet.html" class="d-flex align-items-center">
                                            <i class="isax isax-wallet-add-15"></i> Wallet
                                        </a>
                                    </li>
                                    <li class="mb-2">
                                        <a href="payment.html" class="d-flex align-items-center">
                                            <i class="isax isax-money-recive5"></i> Payments
                                        </a>
                                    </li>
                                    <li>
                                        <span class="fs-14 text-gray-3 fw-medium mb-2">Account</span>
                                    </li>
                                    <li>
                                        <a href="my-profile.html" class="d-flex align-items-center">
                                            <i class="isax isax-profile-tick5"></i> My Profile
                                        </a>
                                    </li>
                                    <li>
                                        <div class="message-content">
                                            <a href="notification.html" class="d-flex align-items-center">
                                                <i class="isax isax-notification-bing5"></i> Notifications
                                            </a>
                                            <span class="msg-count bg-purple rounded-circle">05</span>
                                        </div>
                                    </li>
                                    <li>
                                        <a href="profile-settings.html" class="d-flex align-items-center active">
                                            <i class="isax isax-setting-25"></i> Settings
                                        </a>
                                    </li>
                                    <li>
                                        <a href="index.html" class="d-flex align-items-center pb-0">
                                            <i class="isax isax-logout-15"></i> Logout
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- /Sidebar -->

                    <!-- Profile Settings -->
                    <div class="col-xl-9 col-lg-8">
                        <div class="card settings mb-0">
                            <div class="card-header">
                                <h6>Settings</h6>
                            </div>
                            <div class="card-body pb-3">
                                <div class="settings-link d-flex align-items-center flex-wrap">
                                    <a href="profile-settings.html" class="active ps-3"><i class="isax isax-user-octagon me-2"></i>Profile Settings</a>
                                    <a href="notification-settings.html"><i class="isax isax-notification me-2"></i>Notifications</a>
                                </div>

                                <!-- Settings Content -->
                                <div class="settings-content mb-3">
                                    <h6 class="fs-16 mb-3">Basic Information</h6>
                                    <form action="edit" method="post">
                                        <div class="row gy-2">
                                            <div class="col-lg-6">
                                                <label class="form-label">First Name</label>
                                                <input type="text" class="form-control" name="first_name" value="${user.getFirstName()}">
                                            </div>
                                            <div class="col-lg-6">
                                                <label class="form-label">Last Name</label>
                                                <input type="text" class="form-control" name="last_name" value="${user.getLastName()}">
                                            </div>
                                            <div class="col-lg-6">
                                                <label class="form-label">Email</label>
                                                <input readonly type="email" class="form-control" name="email" value="${user.getEmail()}">
                                            </div>
                                            <div class="col-lg-6">
                                                <label class="form-label">Phone</label>
                                                <input type="text" class="form-control" name="phone" value="${user.getPhoneNumber()}">
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-end mt-3">
                                            <button type="submit" class="btn btn-primary">Save</button>
                                        </div>
                                    </form>
                                </div>
                                <!-- /Settings Content-->
                            </div>
                            <div class="card-footer">
                                <c:if test="${param.success eq 'true'}">
                                    <div class="alert alert-success">Profile updated successfully!</div>
                                </c:if>
                                <c:if test="${param.error eq 'true'}">
                                    <div class="alert alert-danger">Failed to update profile!</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <!-- /Profile Settings -->

                </div>
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