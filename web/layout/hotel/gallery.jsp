<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Gallery -->
<div class="border-bottom pb-4 mb-4">
    <h5 class="mb-3 fs-18">Gallery</h5>
    <div class="row row-cols-lg-6 row-cols-sm-4 row-cols-2 g-2">
        <c:forEach var="imageUrl" items="${imageUrls}" varStatus="loop">
            <c:if test="${loop.count <= 11}">
                <div class="col">
                    <a class="galley-wrap" data-fancybox="gallery" href="${imageUrl}">
                        <img src="${imageUrl}" alt="Hotel Image ${loop.count}">
                    </a>
                </div>
            </c:if>
        </c:forEach>
        <c:if test="${fn:length(imageUrls) > 11}">
            <div class="col">
                <div class="galley-wrap more-gallery d-flex align-items-center justify-content-center">
                    <a data-fancybox="gallery" href="${imageUrls[0]}" class="btn btn-white btn-xs">
                        <i class="isax isax-image5 me-1"></i>See All
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</div>
<!-- /Gallery -->