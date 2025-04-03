<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="dao.HotelAgentRequestDAO"%>
<%@page import="model.HotelAgentRequest"%>
<%
    if (user != null) {
        pendingRequest = requestDAO.getPendingRequestByUserId(user.getUserId()); // Kiểm tra request Pending
    }
%>
<!-- Sidebar -->
<div class="col-xl-3 col-lg-4 theiaStickySidebar">
    <div class="card user-sidebar mb-4 mb-lg-0">
        <div class="card-header user-sidebar-header text-center bg-gray-transparent">
            <div class="agent-profile d-inline-flex">
                <img id="avatarImage" src="<%=user.getAvatarUrl()%>" alt="image" class="img-fluid rounded-circle">
                <a href="agent-settings.html" class="avatar avatar-sm rounded-circle btn btn-primary d-flex align-items-center justify-content-center p-0"><i class="isax isax-edit-2 fs-14"></i></a>
            </div>
            <h6 class="fs-16">
                <%=(user.getGoogleId()) == null ? user.getUsername() : user.getGoogleId()%>
            </h6>
            <p class="fs-14 mb-2">Member Since <%=user.getCreatedAt()%></p>

            <% if (user.getRole().getRoleId() == 3) {%>
            <div class="d-flex align-items-center justify-content-center notify-item">
                <a href="agent-notifications.html" class="rounded-circle btn btn-white d-flex align-items-center justify-content-center p-0 me-2 position-relative">
                    <i class="isax isax-notification-bing5 fs-20"></i>
                    <span class="position-absolute p-1 bg-secondary rounded-circle"></span>
                </a>
                <a href="agent-chat.html" class="rounded-circle btn btn-white d-flex align-items-center justify-content-center p-0 position-relative">
                    <i class="isax isax-message-square5 fs-20"></i>
                    <span class="position-absolute p-1 bg-danger rounded-circle"></span>
                </a>
            </div>
            <%}%>
        </div>      

        <div class="card-body user-sidebar-body">
            <ul>
                <li>
                    <span class="fs-14 text-gray-3 fw-medium mb-2">Main</span>
                </li>
                <% if (user.getRole().getRoleId() == 3) {%>
                <li>
                    <a href="${pageContext.request.contextPath}/agent-dashboard" class="d-flex align-items-center">
                        <i class="isax isax-grid-55"></i> Dashboard
                    </a>
                </li>
                <%}%>
                <% if (user.getRole().getRoleId() == 3) {%>
                <li>
                    <a href="${pageContext.request.contextPath}/get-hotels" class="d-flex align-items-center">
                        <i class="isax isax-grid-55"></i> Listings
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/wallet" class="d-flex align-items-center">
                        <i class="isax isax-wallet-add-15 me-2"></i>Earnings
                    </a>
                </li>
                <%}%>
                <li>
                    <a href="${pageContext.request.contextPath}/booking-list" class="d-block">
                        <i class="isax isax-calendar-tick5"></i> My Bookings
                    </a>
                </li>
                <li>
                    <a href="#" class="d-flex align-items-center">
                        <i class="isax isax-magic-star5"></i> My Reviews
                    </a>
                </li>
                <li class="mb-2">
                    <a href="${pageContext.request.contextPath}/favorites?action=list" class="d-flex align-items-center">
                        <i class="isax isax-heart5"></i> Wishlist
                    </a>
                </li>
                <% if ((user.getRole().getRoleId() == 2 || user.getRole().getRoleId() == 3) && pendingRequest != null) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/hotel-agent-requests/request-status" class="d-flex align-items-center">
                        <i class="isax isax-eye me-2"></i> View Request Status
                    </a>
                </li>
                <% } %>
                <li>
                    <span class="fs-14 text-gray-3 fw-medium mb-2">Finance</span>
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
                    <a href="${pageContext.request.contextPath}/user-profile" class="d-flex align-items-center">
                        <i class="isax isax-profile-tick5"></i> My Profile
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/change-password" class="d-flex align-items-center">
                        <i class="isax isax-shield-tick me-2"></i> Change Password
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center pb-0">
                        <i class="isax isax-logout-15"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
<!-- /Sidebar -->