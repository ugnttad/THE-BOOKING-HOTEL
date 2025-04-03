<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="config.*" %>
<%@ page import="java.util.*" %>
<%
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    Double total = (Double) session.getAttribute("total"); // Amount in USD
    long amountInVND = 0;
    // Check if total is not null
    if (total != null) {
        amountInVND = Math.round(total * 25336 * 100); // Convert USD to VND (assuming 1 USD = 23000 VND) and multiply by 100 for smallest currency unit
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="../../layout/head.jsp" %>
    </head>
    <body>
        <div class="container">
            <div class="header clearfix">
                <h3 class="text-muted">VNPAY DEMO</h3>
            </div>
            <h3>Checkout</h3>
            <div class="table-responsive">
                <form action="<%= request.getContextPath()%>/ajaxServlet" id="frmCreateOrder" method="post">
                    <div class="form-group">
                        <label class="required">First Name</label>
                        <input type="text" class="form-control" name="firstName" value="<%= firstName%>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="required">Last Name</label>
                        <input type="text" class="form-control" name="lastName" value="<%= lastName%>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="required">Email Address</label>
                        <input type="email" class="form-control" name="email" value="<%= email%>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="required">Order Total (VND)</label>
                        <input type="text" class="form-control" name="orderTotal" value="<%= amountInVND / 100%>" readonly>
                    </div>
                    <div class="form-group">
                        <h5>Select Payment Interface Language:</h5>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="languageVN" name="language" value="vn" checked="true">
                            <label class="form-check-label" for="languageVN">Vietnamese</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="languageEN" name="language" value="en">
                            <label class="form-check-label" for="languageEN">English</label>
                        </div>
                    </div>
                    <input type="hidden" name="amountInVND" value="<%= amountInVND%>">
                    <button type="submit" class="btn btn-primary">Pay</button>
                </form>
            </div>
            <p>&nbsp;</p>
            <footer class="footer">
                <p>&copy; VNPAY 2020</p>
            </footer>
        </div>

        <link href="https://pay.vnpay.vn/lib/vnpay/vnpay.css" rel="stylesheet" />
        <script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>
        <script type="text/javascript">
            $("#frmCreateOrder").submit(function (event) {
                event.preventDefault();  // Ngừng việc gửi form mặc định

                var postData = $("#frmCreateOrder").serialize();  // Serialize dữ liệu của form
                var submitUrl = $("#frmCreateOrder").attr("action");  // Lấy URL gửi dữ liệu (tới ajaxServlet)

                // Gửi AJAX request tới servlet
                $.ajax({
                    type: "POST",
                    url: submitUrl,
                    data: postData,
                    dataType: 'JSON', // Đảm bảo nhận phản hồi dạng JSON
                    success: function (response) {
                        console.log("Response: ", response);

                        // Kiểm tra nếu mã trạng thái là "00" (thành công)
                        if (response.code === '00') {
                            // Lấy URL thanh toán từ trường "data" trong phản hồi
                            var paymentUrl = response.data;
                            console.log(paymentUrl);
                            // Chuyển hướng người dùng đến trang thanh toán của VNPAY
                            window.location.href = paymentUrl;  // Chuyển hướng đến URL thanh toán
                        } else {
                            // Nếu không thành công, hiển thị thông báo lỗi
                            alert(response.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        // Nếu có lỗi trong quá trình gửi request
                        console.error("AJAX call failed. Status: ", status, "Error: ", error);
                        alert("Có lỗi xảy ra trong quá trình gửi yêu cầu.");
                    }
                });
            });
        </script>
    </body>

    <!-- Script -->
    <%@ include file="../../layout/script.jsp" %>
</html>