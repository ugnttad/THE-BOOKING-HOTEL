//package scheduler;
//
//import javax.servlet.ServletContextEvent;
//import javax.servlet.ServletContextListener;
//import javax.servlet.annotation.WebListener;
//
//@WebListener
//public class ApplicationListener implements ServletContextListener {
//
//    @Override
//    public void contextInitialized(ServletContextEvent sce) {
//        // Khởi động RoomStatusScheduler khi ứng dụng được khởi động
//        RoomStatusScheduler scheduler = new RoomStatusScheduler();
//        scheduler.startScheduler();
//    }
//
//    @Override
//    public void contextDestroyed(ServletContextEvent sce) {
//        // Dọn dẹp tài nguyên nếu cần
//    }
//}
