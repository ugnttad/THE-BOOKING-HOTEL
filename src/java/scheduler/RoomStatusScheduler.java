//package scheduler;
//
//import dao.RoomDAO;
//import java.util.Timer;
//import java.util.TimerTask;
//
//public class RoomStatusScheduler {
//
//    private Timer timer;
//
//    public void startScheduler() {
//        timer = new Timer();
//        RoomDAO roomDAO = new RoomDAO();
//
//        // Tạo một task để thực thi vào lúc 12h00
//        TimerTask task = new TimerTask() {
//            @Override
//            public void run() {
//                System.out.println("Task started at: " + System.currentTimeMillis());
//                try {
//                    roomDAO.updateRoomStatusToAvailable();  // Gọi hàm cập nhật trạng thái phòng
//                    System.out.println("Room status update completed at: " + System.currentTimeMillis());  // Debug: In thời gian cập nhật xong
//                } catch (Exception e) {
//                    System.out.println("Error occurred during room status update: " + e.getMessage());  // Debug: In lỗi nếu có
//                    e.printStackTrace();  // Xử lý lỗi nếu có
//                }
//            }
//        };
//
//        // Tính toán thời gian khởi động vào 12h00 hôm nay
////        long delay = getDelayForNext12pm();
//        // Lên lịch cho task chạy mỗi 24 giờ một lần
////        timer.scheduleAtFixedRate(task, delay, 24 * 60 * 60 * 1000); // Chạy mỗi 24 giờ
//        timer.scheduleAtFixedRate(task, 0, 60 * 1000);
//
//        System.out.println("Scheduler started. Task will run every minute.");
//    }
//
//    private long getDelayForNext12pm() {
//        long currentTime = System.currentTimeMillis();
//        long targetTime = System.currentTimeMillis();
//
//        // Tính toán thời gian 12h00 (12 PM) của hôm nay
//        targetTime = targetTime / (24 * 60 * 60 * 1000) * (24 * 60 * 60 * 1000);  // Reset thời gian về 00h00 hôm nay
//        targetTime += 12 * 60 * 60 * 1000;  // Cộng thêm 12h00 để có 12 PM
//
//        if (currentTime >= targetTime) {
//            // Nếu đã qua 12h hôm nay, lên lịch vào 12h hôm sau
//            targetTime += 24 * 60 * 60 * 1000;
//        }
//
//        return targetTime - currentTime; // Trả về độ trễ để task chạy vào đúng 12h00
//    }
//}
