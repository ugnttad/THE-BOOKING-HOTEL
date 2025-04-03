<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String name = (String)request.getAttribute("name");
%>

<!-- Breadcrumb -->
<div class="breadcrumb-bar breadcrumb-bg-01 text-center">
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-12">
                <h2 class="breadcrumb-title mb-2"><%=name%></h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-center mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"><i class="isax isax-home5"></i></a></li>
                        <li class="breadcrumb-item">Hotels</li>
                    </ol>
                </nav>
            </div>
        </div>
    </div>
</div>
<!-- /Breadcrumb -->