package controller;

import dao.WalletDAO;
import model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.WalletTransaction;

@WebServlet(name = "WalletController", urlPatterns = {"/wallet"})
public class WalletController extends HttpServlet {

    private static final double EXCHANGE_RATE_VND_TO_USD = 25336.0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRole().getRoleId() != 1 && user.getRole().getRoleId() != 3)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            WalletDAO walletDAO = new WalletDAO();
            BigDecimal balanceVND;
            BigDecimal lastWithdrawnVND;
            List<WalletTransaction> transactions;
            List<WalletTransaction> transactionsUSD = new ArrayList<>();
            String jspPage;

            if (user.getRole().getRoleId() == 1) { // Admin
                balanceVND = walletDAO.getWalletBalance(1, "Role");
                lastWithdrawnVND = walletDAO.getLastWithdrawnAmount(1, "Role");
                transactions = walletDAO.getWalletTransactions(1, "Role");
                for (WalletTransaction transaction : transactions) {
                    BigDecimal amountUSD = transaction.getAmount().divide(BigDecimal.valueOf(EXCHANGE_RATE_VND_TO_USD), 2, BigDecimal.ROUND_HALF_UP);
                    WalletTransaction transactionUSD = new WalletTransaction(
                            transaction.getTransactionId(),
                            amountUSD, // Amount đã chuyển sang USD
                            transaction.getTransactionType(),
                            transaction.getDescription(),
                            transaction.getCreatedAt(),
                            transaction.getRelatedBookingTransactionId()
                    );
                    transactionsUSD.add(transactionUSD);
                }
                request.setAttribute("transactions", transactionsUSD);
                jspPage = "/pages/admin/admin-wallet.jsp";
            } else { // Hotel Agent (RoleId = 3)
                balanceVND = walletDAO.getWalletBalance(user.getUserId(), "User");
                lastWithdrawnVND = walletDAO.getLastWithdrawnAmount(user.getUserId(), "User");
                jspPage = "/pages/hotel-management/agent-earnings.jsp";
            }

            BigDecimal balanceUSD = balanceVND.divide(BigDecimal.valueOf(EXCHANGE_RATE_VND_TO_USD), 2, BigDecimal.ROUND_HALF_UP);
            BigDecimal lastWithdrawnUSD = lastWithdrawnVND.divide(BigDecimal.valueOf(EXCHANGE_RATE_VND_TO_USD), 2, BigDecimal.ROUND_HALF_UP);

            request.setAttribute("balanceUSD", balanceUSD);
            request.setAttribute("lastWithdrawn", lastWithdrawnUSD);
            request.getRequestDispatcher(jspPage).forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(WalletController.class.getName()).log(Level.SEVERE, "Error fetching wallet details", e);
            request.setAttribute("error", "Error loading wallet details.");
            if (user.getRole().getRoleId() == 1) {
                request.getRequestDispatcher("/pages/admin/admin-wallet.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/hotel-management/agent-earnings.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRole().getRoleId() != 1 && user.getRole().getRoleId() != 3)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        if ("withdraw".equals(action)) {
            try {
                BigDecimal amountUSD = new BigDecimal(request.getParameter("amount"));
                BigDecimal amountVND = amountUSD.multiply(BigDecimal.valueOf(EXCHANGE_RATE_VND_TO_USD));

                WalletDAO walletDAO = new WalletDAO();
                boolean success;
                if (user.getRole().getRoleId() == 1) { // Admin
                    success = walletDAO.withdrawPayment(1, "Role", amountVND);
                } else { // Hotel Agent
                    success = walletDAO.withdrawPayment(user.getUserId(), "User", amountVND);
                }

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/wallet?success=Withdrawal successful");
                } else {
                    request.setAttribute("error", "Insufficient balance or withdrawal failed.");
                    doGet(request, response); // Tải lại trang với lỗi
                }
            } catch (Exception e) {
                Logger.getLogger(WalletController.class.getName()).log(Level.SEVERE, "Error processing withdrawal", e);
                request.setAttribute("error", "Error processing withdrawal: " + e.getMessage());
                doGet(request, response);
            }
        }
    }
}
