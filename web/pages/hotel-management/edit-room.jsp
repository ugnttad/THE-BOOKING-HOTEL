<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/select2/css/select2.min.css">
        <%@ include file="../../layout/head.jsp" %>
        <style>
            .gallery-preview {
                width: 100px;
                height: 100px;
                object-fit: cover;
                margin: 5px;
            }
            .gallery-upload-img {
                position: relative;
                display: inline-block;
            }
            .gallery-trash {
                position: absolute;
                top: 5px;
                right: 5px;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div class="main-header">
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <c:set var="name" value="Edit Room" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />

        <div class="content">
            <div class="container">
                <div class="tab-content">
                    <div class="tab-pane fade active show" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-3 theiaStickySidebar">
                                <div class="card border-0">
                                    <div class="card-body">
                                        <h5 class="mb-3">Edit Room</h5>
                                        <ul class="add-tab-list">
                                            <li><a href="#basic_info_2" class="active">Basic Info</a></li>
                                            <li><a href="#specification">Specifications</a></li>
                                            <li><a href="#popular_amenities_2">Amenities</a></li>
                                            <li><a href="#gallery">Gallery</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-9">
                                <form action="${pageContext.request.contextPath}/edit-room" method="POST" enctype="multipart/form-data" id="editRoomForm">
                                    <input type="hidden" name="roomId" value="${room.roomId}">

                                    <div class="card shadow-none" id="basic_info_2">
                                        <div class="card-header">
                                            <h5 class="fs-18">Basic Info</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Room Number</label>
                                                        <input name="roomNumber" type="text" class="form-control" value="${room.roomNumber}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Description</label>
                                                        <input name="roomDescription" type="text" class="form-control" value="${room.roomDescription}">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Name</label>
                                                        <input type="text" readonly class="form-control" value="${hotel.hotelName}">
                                                        <input type="hidden" name="hotelId" value="${hotel.hotelId}">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Room Type</label>
                                                        <select class="form-select" id="type" name="type" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="type" items="${roomTypes}">
                                                                <option value="${type.roomTypeId}" ${type.roomTypeId == room.roomTypeId ? 'selected' : ''}>${type.roomTypeName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card shadow-none" id="specification">
                                        <div class="card-header">
                                            <h5 class="fs-18">Specifications</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Capacity</label>
                                                        <input name="capacity" type="number" min="0" class="form-control" value="${room.capacity}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Price Per Night</label>
                                                        <input name="price" type="number" min="0" step="0.01" class="form-control" value="${room.pricePerNight}" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card shadow-none" id="popular_amenities_2">
                                        <div class="card-header">
                                            <h5 class="fs-18">Facilities</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <c:forEach var="facility" items="${roomFacilities}">
                                                    <div class="col-lg-4 col-md-6">
                                                        <div class="mb-3">
                                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                                <input class="form-check-input ms-0 mt-0" type="checkbox" id="facility-${facility.facilityId}" 
                                                                       name="facilityIds" value="${facility.facilityId}" 
                                                                       ${roomFacilityIds.contains(facility.facilityId) ? 'checked' : ''}>
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
                                        <button type="button" class="btn btn-light me-2" onclick="resetForm();">Reset</button>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../../layout/footer.jsp" %>
        <%@ include file="../../layout/cursor.jsp" %>
        <%@ include file="../../layout/back-to-top.jsp" %>
        <%@ include file="../../layout/script.jsp" %>

        <script>
            $(document).ready(function () {
                // Load ảnh hiện tại từ roomImageURLs khi trang khởi tạo
                var imageUrls = '${room.roomImageURLs}';
                if (imageUrls && imageUrls.startsWith('[') && imageUrls.endsWith(']')) {
                    var cleanUrls = imageUrls.substring(1, imageUrls.length - 1).split(',');
                    var preview = $("#galleryPreview");
                    cleanUrls.forEach(function (url) {
                        var trimmedUrl = url.trim().replace(/"/g, '');
                        if (trimmedUrl) {
                            var img = $('<img>').attr('src', trimmedUrl).addClass('gallery-preview');
                            var trash = $('<span>').addClass('trash-icon d-flex align-items-center justify-content-center text-danger gallery-trash')
                                    .html('<i class="isax isax-trash"></i>')
                                    .click(function () {
                                        $(this).parent().remove();
                                    });
                            var container = $('<a>').addClass('gallery-upload-img me-2').append(img, trash);
                            preview.append(container);
                        }
                    });
                }

                // Xử lý preview khi upload ảnh mới
                $("#galleryImages").change(function () {
                    let files = this.files;
                    let preview = $("#galleryPreview");
                    preview.empty(); // Xóa preview cũ để chỉ hiển thị ảnh mới

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

            function resetForm() {
                document.getElementById('editRoomForm').reset();
                $("#galleryPreview").empty();
                // Tải lại ảnh hiện tại khi reset
                var imageUrls = '${room.getRoomImageURLs()}';
                if (imageUrls && imageUrls.startsWith('[') && imageUrls.endsWith(']')) {
                    var cleanUrls = imageUrls.substring(1, imageUrls.length - 1).split(',');
                    var preview = $("#galleryPreview");
                    cleanUrls.forEach(function (url) {
                        var trimmedUrl = url.trim().replace(/"/g, '');
                        if (trimmedUrl) {
                            var img = $('<img>').attr('src', trimmedUrl).addClass('gallery-preview');
                            var trash = $('<span>').addClass('trash-icon d-flex align-items-center justify-content-center text-danger gallery-trash')
                                    .html('<i class="isax isax-trash"></i>')
                                    .click(function () {
                                        $(this).parent().remove();
                                    });
                            var container = $('<a>').addClass('gallery-upload-img me-2').append(img, trash);
                            preview.append(container);
                        }
                    });
                }
            }
        </script>
    </body>
</html>