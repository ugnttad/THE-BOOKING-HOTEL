<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">


    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Summernote JS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.css">

        <!-- Select2 CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/select2/css/select2.min.css">
        <%@ include file="../../layout/head.jsp" %>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Add Room" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">
                <div class="tab-content">
                    <!-- Add Room -->
                    <div class="tab-pane fade active show" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-3 theiaStickySidebar">
                                <div class="card border-0">
                                    <div class="card-body">
                                        <div>
                                            <h5 class="mb-3">Add Room</h5>
                                            <ul class="add-tab-list">
                                                <li><a href="#basic_info_2" class="active">Basic Info</a></li>
                                                <li><a href="#specification">Specifications</a></li>
                                                <li><a href="#popular_amenities_2">Amenities</a></li>
                                                <li><a href="#gallery">Gallery</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-9">
                                <form action="${pageContext.request.contextPath}/add-room" method="POST" enctype="multipart/form-data" id="addRoomForm">
                                    <div class="card shadow-none" id="basic_info_2">
                                        <div class="card-header">
                                            <div class="d-flex align-items-center justify-content-between">
                                                <h5 class="fs-18">Basic Info</h5>
                                            </div>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Room Number</label>
                                                        <input name="roomNumber" type="text" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Description</label>
                                                        <input name="roomDescription" type="text" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Name</label>
                                                        <input type="text" readonly class="form-control" value="${hotel.getHotelName()}">
                                                        <input type="hidden" name="hotelId" value="${hotel.getHotelId()}">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Room Type</label>
                                                        <select class="select" id="type" name="type">
                                                            <option value="">Select</option>
                                                            <c:forEach var="type" items="${roomTypes}">
                                                                <option value="${type.getRoomTypeId()}">${type.getRoomTypeName()}</option>
                                                            </c:forEach>                                                            
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card shadow-none" id="specification">
                                        <div class="card-header">
                                            <div class="d-flex align-items-center justify-content-between">
                                                <h5 class="fs-18">Specifications</h5>
                                            </div>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Capacity</label>
                                                        <input name="capacity" type="number" min="0" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Price Per Night</label>
                                                        <input name="price" type="number" min="0" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card shadow-none" id="popular_amenities_2">
                                        <div class="card-header">
                                            <div class="d-flex align-items-center justify-content-between">
                                                <h5 class="fs-18">Facilities</h5>
                                            </div>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <c:forEach var="facility" items="${roomFacilities}">
                                                    <div class="col-lg-4 col-md-6">
                                                        <div class="mb-3">
                                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                                <input class="form-check-input ms-0 mt-0" type="checkbox" id="facility-${facility.facilityId}" name="facilityIds" value="${facility.facilityId}">
                                                                <label class="form-check-label ms-2" for="facility-${facility.facilityId}">
                                                                    ${facility.facilityName}
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card shadow-none" id="gallery">
                                        <div class="card-header">
                                            <h5 class="fs-18">Gallery</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="file-upload drag-file w-100 d-flex align-items-center justify-content-center flex-column mb-2">
                                                <span class="upload-img d-block mb-2"><i class="isax isax-document-upload fs-24"></i></span>
                                                <h6 class="mb-1">Upload Gallery Images</h6>
                                                <p class="mb-0">Upload Feature Image First, Image size should below 5MB</p>
                                                <input type="file" name="galleryImages" id="galleryImages" accept="image/*" multiple>
                                            </div>
                                            <div class="d-flex align-items-center flex-wrap" id="galleryPreview"></div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-center">
                                        <button type="button" class="btn btn-light me-2" onclick="document.getElementById('addRoomForm').reset(); $('#galleryPreview').empty();">Reset</button>
                                        <button type="submit" class="btn btn-primary">Add New Room</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- /Add Room -->

                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../../layout/footer.jsp" %>
        <!-- /Footer -->   

        <!-- Cursor -->
        <%@ include file="../../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../../layout/script.jsp" %>

        <script>
            $(document).ready(function () {
                $("#galleryImages").change(function () {
                    let files = this.files;
                    let preview = $("#galleryPreview");
                    preview.empty(); // Xóa preview cũ

                    for (let i = 0; i < files.length; i++) {
                        let file = files[i];
                        if (file.size > 5 * 1024 * 1024) { // Kiểm tra kích thước < 5MB
                            alert("Image " + file.name + " exceeds 5MB limit!");
                            continue;
                        }
                        let reader = new FileReader();
                        reader.onload = function (e) {
                            let img = $('<img>').attr('src', e.target.result).addClass('gallery-preview');
                            let trash = $('<span>').addClass('trash-icon d-flex align-items-center justify-content-center text-danger gallery-trash')
                                    .html('<i class="isax isax-trash"></i>')
                                    .click(function () {
                                        $(this).parent().remove();
                                    });
                            let container = $('<a>').addClass('gallery-upload-img me-2').append(img, trash);
                            preview.append(container);
                        };
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
</html>