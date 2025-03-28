package controller;

import dao.InvoiceDAO;
import model.Invoice;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            request.getRequestDispatcher("/").forward(request, response);
            return;
        }

        try {
            // Lấy TransactionId từ request
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));

            // Lấy thông tin hóa đơn từ DAO
            Invoice invoice = new InvoiceDAO().getInvoiceDetails(transactionId);

            // Gửi dữ liệu vào JSP
            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/pages/invoice.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving invoice");
        }
    }
}
