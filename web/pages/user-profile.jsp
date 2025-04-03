<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <div class="breadcrumb-bar breadcrumb-bg-01 text-center">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 col-12">
                        <h2 class="breadcrumb-title mb-2">My Profile</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center mb-0">
                                <li class="breadcrumb-item"><a href="index.html"><i class="isax isax-home5"></i></a></li>
                                <li class="breadcrumb-item active" aria-current="page">My Profile</li>
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
                    <%@ include file="../layout/profile-sidebar.jsp" %>

                    <!-- My Profile -->
                    <div class="col-xl-9 col-lg-8">
                        <div class="card shadow-none mb-0">
                            <div class="card-header d-flex align-items-center justify-content-between">
                                <h6>My Profile</h6>
                                <div class="d-flex align-items-center justify-content-center">
                                    <a href="user-profile/edit" class="p-1 rounded-circle btn btn-light d-flex align-items-center justify-content-center"><i class="isax isax-edit-2 fs-14"></i></a>
                                </div>
                            </div>
                            <div class="card-body">
                                <h6 class="fs-16 mb-3">Basic Information</h6>
                                <div class="d-flex align-items-center mb-3">
                                    <span class="avatar avatar-xl flex-shrink-0 me-3 ">
                                        <img id="avatarImage2" src="<%=user.getAvatarUrl()%>" alt="Img" class="img-fluid rounded">
                                    </span>
                                    <div class="profile-upload">
                                        <div class="mb-2">
                                            <p class="fs-12">Recommended image size is 40px x 40px</p>
                                        </div>
                                        <div class="profile-uploader d-flex align-items-center">
                                            <div class="drag-upload-btn btn btn-sm btn-primary me-2">
                                                Upload
                                                <input type="file" id="avatarUpload" class="form-control image-sign" onchange="changeAva();">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row border-bottom pb-2 mb-3">
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <h6 class="fs-14">First Name</h6>
                                            <p>
                                                <%=user.getFirstName()%>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <h6 class="fs-14">Last Name</h6>
                                            <p>
                                                <%=user.getLastName()%>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <h6 class="fs-14">Email</h6>
                                            <p>
                                                <%=user.getEmail()%>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <h6 class="fs-14">Phone</h6>
                                            <p>
                                                <%=user.getPhoneNumber()%>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /My Profile -->

                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <script>
            function changeAva() {
                var formData = new FormData();
                var fileInput = document.getElementById('avatarUpload');
                var file = fileInput.files[0];
                formData.append('avatar', file);

                fetch('${pageContext.request.contextPath}/upload-avatar', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.text()) // <-- Use .text() instead of .json() for debugging
                        .then(data => {
                            try {
                                let jsonData = JSON.parse(data); // Try parsing manually
                                if (jsonData.success) {
                                    document.getElementById('avatarImage').src = jsonData.avatarUrl;
                                    document.getElementById('avatarImage2').src = jsonData.avatarUrl;
                                } else {
                                    console.error('Error updating avatar:', jsonData.message);
                                }
                            } catch (e) {
                                console.error("Failed to parse JSON:", e);
                            }
                        })
                        .catch(error => {
                            console.error('Error uploading avatar:', error);
                        });

            }
        </script>

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