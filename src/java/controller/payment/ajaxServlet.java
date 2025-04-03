package controller.payment;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import config.VNPayConfig;
import java.io.IOException;
import java.io.ObjectInputFilter.Config;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ajaxServlet", urlPatterns = {"/ajaxServlet"})
public class ajaxServlet extends HttpServlet {

    public ajaxServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        try {
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";
            String vnp_TmnCode = VNPayConfig.vnp_TmnCode;
            long amountInVND = Long.parseLong(req.getParameter("amountInVND")); // Amount in VND
            String bankCode = req.getParameter("NCB");
            String vnp_TxnRef = VNPayConfig.getRandomNumber(8); // Generate a random transaction reference
            String vnp_IpAddr = VNPayConfig.getIpAddress(req); // Get IP address of the request
            String locate = req.getParameter("language");

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amountInVND));
            vnp_Params.put("vnp_CurrCode", "VND");

            if (bankCode != null && !bankCode.isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode);  // Optional: bank code
            }
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);  // Transaction reference
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);  // Order info
            vnp_Params.put("vnp_OrderType", orderType);

            if (locate != null && !locate.isEmpty()) {
                vnp_Params.put("vnp_Locale", locate);
            } else {
                vnp_Params.put("vnp_Locale", "vn");  // Default locale: Vietnamese
            }

            // Đảm bảo vnp_ReturnUrl có thể truy cập từ bên ngoài
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);  // Return URL after payment
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);  // IP address

            // Create timestamp for the transaction
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            // Set expiry date (15 minutes from creation)
            cld.add(Calendar.MINUTE, 15);  // Expiry after 15 minutes
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            // Sort parameters and build hash data
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString())).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }

            // Generate secure hash for the parameters
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);

            // Construct the payment URL
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query.toString();
            
            System.out.println(paymentUrl);

            // Prepare JSON response
//            JsonObject job = new JsonObject();
//            job.addProperty("code", "00");
//            job.addProperty("message", "success");
//            job.addProperty("data", paymentUrl);  // URL thanh toán VNPAY

            // Gửi phản hồi JSON về client
//            try (PrintWriter out = resp.getWriter()) {
//                Gson gson = new Gson();
//                out.print(gson.toJson(job));  // Chuyển đối tượng JSON thành chuỗi và gửi về frontend
//                out.flush();
//            }

        resp.sendRedirect(paymentUrl);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorJob = new JsonObject();
            errorJob.addProperty("code", "99");
            errorJob.addProperty("message", "Error processing request");
            try (PrintWriter out = resp.getWriter()) {
                Gson gson = new Gson();
                out.print(gson.toJson(errorJob));
                out.flush();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
