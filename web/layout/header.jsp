<%@page import="model.User"%>
<%@page import="dao.FavoritesDAO"%>
<%@page import="dao.HotelAgentRequestDAO"%>
<%@page import="model.HotelAgentRequest"%>
<%
    User user = (User) session.getAttribute("user");
    FavoritesDAO favoritesDAO = new FavoritesDAO();
    HotelAgentRequestDAO requestDAO = new HotelAgentRequestDAO();
    HotelAgentRequest pendingRequest = null;
    if (user != null) {
        pendingRequest = requestDAO.getPendingRequestByUserId(user.getUserId());
        if (pendingRequest != null) {
            System.out.println("Pending Request Description: " + pendingRequest.getDescription());
        }
    }
%>

<div class="main-header">
    <!-- Header -->
    <header>
        <div class="container">
            <div class="offcanvas-info">
                <div class="offcanvas-wrap">
                    <div class="offcanvas-detail">
                        <div class="offcanvas-head">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <a href="/" class="black-logo-responsive">
                                    <img src="${pageContext.request.contextPath}/assets/img/hotel-logo.svg" alt="logo-img">
                                </a>
                                <a href="/" class="white-logo-responsive">
                                    <img src="${pageContext.request.contextPath}/assets/img/hotel-logo-dark.svg" alt="logo-img">
                                </a>
                                <div class="offcanvas-close">
                                    <i class="ti ti-x"></i>
                                </div>
                            </div>
                        </div>
                        <div class="mobile-menu fix mb-3"></div>
                        <div class="offcanvas__contact">
                            <div class="mt-4">
                                <div><a href="javascript:void(0);" class="text-white btn btn-dark w-100 mb-3" data-bs-toggle="modal" data-bs-target="#login-modal">Sign In</a></div>
                                <a href="become-an-expert.html" class="btn btn-primary w-100">Become Expert</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="offcanvas-overlay"></div>
            <div class="header-nav">
                <div class="main-menu-wrapper">
                    <div class="navbar-logo">
                        <a class="logo-white header-logo" href="${pageContext.request.contextPath}/">
                            <img src="${pageContext.request.contextPath}/assets/img/hotel-logo-dark.svg" class="logo" alt="Logo">
                        </a>
                        <a class="logo-dark header-logo" href="${pageContext.request.contextPath}/">
                            <img src="${pageContext.request.contextPath}/assets/img/hotel-logo.svg" class="logo" alt="Logo">
                        </a>
                    </div>
                    <nav id="mobile-menu">
                        <ul class="main-nav">
                            <li class="has-submenu mega-innermenu">
                                <a href="${pageContext.request.contextPath}/">Home</a>
                            </li>
                            <li class="has-submenu mega-innermenu">
                                <a href="${pageContext.request.contextPath}/hotels">Hotels</a>
                            </li>
                            <li class="has-submenu mega-innermenu">
                                <a href="javascript:void(0);">About</a>
                            </li>
                            <li class="has-submenu mega-innermenu">
                                <a href="javascript:void(0);">Faq</a>
                            </li>
                        </ul>
                    </nav>
                    <div class="header-btn d-flex align-items-center">
                        <div class="me-3">
                            <a href="javascript:void(0);" id="dark-mode-toggle" class="theme-toggle">
                                <i class="isax isax-moon"></i>
                            </a>
                            <a href="javascript:void(0);" id="light-mode-toggle" class="theme-toggle">
                                <i class="isax isax-sun-1"></i>
                            </a>
                        </div>

                        <% if (user != null) {%>
                        <div class="dropdown profile-dropdown">
                            <a href="javascript:void(0);" class="d-flex align-items-center" data-bs-toggle="dropdown">
                                <span class="avatar avatar-md">
                                    <img src="<%=user.getAvatarUrl()%>" alt="Img" class="img-fluid rounded-circle border border-white border-4">
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end p-3">
                                <% if (!(user.getRole().getRoleId() == 2)) { %>
                                <li>
                                    <a class="dropdown-item d-inline-flex align-items-center rounded fw-medium p-2" href="${pageContext.request.contextPath}/agent-dashboard">Dashboard</a>
                                </li>
                                <% }%>
                                <li>
                                    <a class="dropdown-item d-inline-flex align-items-center rounded fw-medium p-2" href="${pageContext.request.contextPath}/user-profile">My Profile</a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-inline-flex align-items-center rounded fw-medium p-2" href="${pageContext.request.contextPath}/booking-list">My Booking</a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider my-2">
                                </li>
                                <li>
                                    <a class="dropdown-item d-inline-flex align-items-center rounded fw-medium p-2" href="${pageContext.request.contextPath}/logout">Logout</a>
                                </li>
                            </ul>
                        </div>
                        <div class="fav-dropdown header-btn d-flex align-items-center" style="margin-right: 10px">
                            <a href="${pageContext.request.contextPath}/favorites?action=list" class="position-relative">
                                <i class="isax isax-heart"></i><span class="count-icon bg-secondary text-gray-9"><%=favoritesDAO.getFavoriteHotels(user.getUserId()).size()%></span>
                            </a>
                        </div>
                        <% if (user.getRole().getRoleId() == 2) { %>
                        <% if (pendingRequest != null) { %>
                        <a href="${pageContext.request.contextPath}/admin/hotel-agent-requests/request-status" class="btn btn-info me-0">
                            <i class="fas fa-eye me-1"></i> View Request Status
                        </a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/add-hotel" class="btn btn-primary me-0">Become Agent</a>
                        <% } %>
                        <% } else if (user.getRole().getRoleId() == 3) { %>
                        <% if (pendingRequest != null) { %>
                        <a href="${pageContext.request.contextPath}/admin/hotel-agent-requests/request-status" class="btn btn-info me-0">
                            <i class="fas fa-eye me-1"></i> View Request Status
                        </a>
                        <% } %>
                        <% } %>
                        <% } else { %>
                        <div><a href="javascript:void(0);" class="btn btn-white me-3" data-bs-toggle="modal" data-bs-target="#login-modal">Sign In</a></div>
                        <% }%>

                        <div class="header__hamburger d-xl-none my-auto">
                            <div class="sidebar-menu">
                                <i class="isax isax-menu5"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <!-- /Header -->
</div>