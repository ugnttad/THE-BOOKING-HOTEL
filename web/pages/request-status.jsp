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
        <c:set var="name" value="Request Status" scope="request" />
        <jsp:include page="../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">
                <div class="row">
                    <!-- Sidebar -->
                    <%@ include file="../layout/profile-sidebar.jsp" %>

                    <div class="col-xl-9 col-lg-8">
                        <div class="card shadow-none mb-0">
                            <div class="card-header d-flex align-items-center justify-content-between">
                                <h6>Your Hotel Agent Request Status</h6>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${request != null}">
                                        <dl class="row mb-0">
                                            <dt class="col-sm-4 fw-bold">Request ID:</dt>
                                            <dd class="col-sm-8">${request.requestId}</dd>

                                            <dt class="col-sm-4 fw-bold">Hotel Name:</dt>
                                            <dd class="col-sm-8">${request.hotelName}</dd>

                                            <dt class="col-sm-4 fw-bold">Address:</dt>
                                            <dd class="col-sm-8">${request.address}</dd>

                                            <dt class="col-sm-4 fw-bold">Description:</dt>
                                            <dd class="col-sm-8">${request.description}</dd>

                                            <dt class="col-sm-4 fw-bold">Status:</dt>
                                            <dd class="col-sm-8">
                                                <span class="badge
                                                      ${request.requestStatus == 'Pending' ? 'bg-warning text-dark' : 
                                                        request.requestStatus == 'Approved' ? 'bg-success' : 'bg-danger'}">
                                                          ${request.requestStatus}
                                                      </span>
                                                </dd>

                                                <dt class="col-sm-4 fw-bold">Submitted At:</dt>
                                                <dd class="col-sm-8">
                                                    <fmt:formatDate value="${request.submittedAt}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                                                </dd>

                                                <c:if test="${request.requestStatus == 'Rejected'}">
                                                    <dt class="col-sm-4 fw-bold">Rejection Reason:</dt>
                                                    <dd class="col-sm-8">${request.rejectionReason}</dd>
                                                </c:if>

                                                <c:if test="${request.requestStatus == 'Approved'}">
                                                    <dt class="col-sm-4 fw-bold">Reviewed At:</dt>
                                                    <dd class="col-sm-8">
                                                        <fmt:formatDate value="${request.reviewedAt}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                                                    </dd>
                                                </c:if>
                                            </dl>
                                            <c:if test="${request.requestStatus == 'Pending'}">
                                                <div class="alert alert-info mt-3" role="alert">
                                                    Your request is currently under review. Please wait for admin approval.
                                                </div>
                                            </c:if>
                                            <c:if test="${request.requestStatus == 'Approved'}">
                                                <div class="alert alert-success mt-3" role="alert">
                                                    Your request has been approved! You are now a Hotel Agent.
                                                </div>
                                            </c:if>
                                            <c:if test="${request.requestStatus == 'Rejected'}">
                                                <div class="alert alert-danger mt-3" role="alert">
                                                    Your request has been rejected. You can submit a new request if needed.
                                                    <a href="${pageContext.request.contextPath}/add-hotel" class="alert-link"> Submit New Request</a>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center mb-3">You have not submitted any Hotel Agent request yet.</p>
                                            <div class="text-center">
                                                <a href="${pageContext.request.contextPath}/add-hotel" class="btn btn-primary">Submit a Request</a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
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
        </body>
    </html>