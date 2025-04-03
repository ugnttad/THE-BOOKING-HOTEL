package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import config.CloudinaryConfig;
import dao.HotelAgentRequestDAO;
import dao.HotelDAO;
import dao.HotelServiceDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.UserDAO;
import dao.WalletDAO;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.sql.SQLException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Hotel;
import model.HotelAgentRequest;
import model.HotelService;
import model.Room;
import model.RoomType;
import model.User;
import model.Wallet;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "HotelManagementController", urlPatterns = {"/add-hotel", "/get-cities", "get-hotels", "edit-hotel"})
public class HotelManagementController extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() {
        this.cloudinary = CloudinaryConfig.getCloudinary();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/add-hotel".equals(action)) {
            try {
                handleAddHotelPage(request, response);
            } catch (Exception ex) {
                Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("/get-cities".equals(action)) {
            handleGetCities(request, response);
        } else if ("/get-hotels".equals(action)) {
            try {
                handleGetHotels(request, response);
            } catch (Exception ex) {
                Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("/edit-hotel".equals(action)) {
            try {
                handleEditHotelPage(request, response);
            } catch (Exception ex) {
                Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/add-hotel".equals(request.getServletPath())) {
            handleAddHotelSubmit(request, response);
        } else if ("/edit-hotel".equals(request.getServletPath())) {
            handleEditHotelSubmit(request, response);
        }
    }

    private void handleAddHotelSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRole().getRoleId() != 2 && user.getRole().getRoleId() != 3)) {
            request.setAttribute("error", "You must be logged in as a Customer or Hotel Agent to submit this request.");
            request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
            return;
        }

        String hotelName = null;
        String hotelDescription = null;
        String country = null;
        String city = null;
        String address = null;
        String requestType = user.getRole().getRoleId() == 2 ? "BecomeHotelAgent" : "AddHotel";
        List<String> businessLicenseUrls = new ArrayList<>();

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String value = item.getString("UTF-8");
                    switch (fieldName) {
                        case "hotelName":
                            hotelName = value;
                            break;
                        case "hotelDescription":
                            hotelDescription = value;
                            break;
                        case "country":
                            country = value;
                            break;
                        case "city":
                            city = value;
                            break;
                        case "address":
                            address = value;
                            break;
                    }
                } else if (item.getFieldName().equals("businessLicense") && item.getSize() > 0) {
                    if (businessLicenseUrls.size() >= 3) {
                        request.setAttribute("error", "Maximum 3 business license files allowed.");
                        request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                        return;
                    }
                    if (item.getSize() > 5 * 1024 * 1024) { // 5MB
                        request.setAttribute("error", "File " + item.getName() + " exceeds 5MB limit.");
                        request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                        return;
                    }
                    String contentType = item.getContentType();
                    if (!contentType.startsWith("image/") && !contentType.equals("application/pdf")) {
                        request.setAttribute("error", "Only image and PDF files are allowed for business license.");
                        request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                        return;
                    }

                    File tempFile = File.createTempFile("license_", "." + (contentType.equals("application/pdf") ? "pdf" : "jpg"));
                    item.write(tempFile);
                    Map<String, Object> uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
                    String licenseUrl = (String) uploadResult.get("secure_url");
                    businessLicenseUrls.add(licenseUrl);
                    Files.deleteIfExists(tempFile.toPath());
                }
            }

            // Validation
            if (hotelName == null || hotelName.trim().isEmpty()) {
                request.setAttribute("error", "Hotel name is required.");
                request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                return;
            }
            if (country == null || city == null || address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Complete location information is required.");
                request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                return;
            }
            if (businessLicenseUrls.isEmpty()) {
                request.setAttribute("error", "At least one business license file is required.");
                request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng HotelAgentRequest và truyền List<String>
            HotelAgentRequestDAO requestDAO = new HotelAgentRequestDAO();
            HotelAgentRequest requestModel = new HotelAgentRequest();
            requestModel.setUserId(user.getUserId());
            requestModel.setHotelName(hotelName);
            requestModel.setBusinessLicenseUrls(businessLicenseUrls); // Truyền List<String>
            requestModel.setAddress(address + ", " + city + ", " + country);
            requestModel.setDescription(hotelDescription);
            requestModel.setRequestStatus("Pending");
            requestModel.setRequestType(requestType);

            boolean success = requestDAO.addHotelAgentRequest(requestModel);
            if (!success) {
                request.setAttribute("error", "Failed to submit request. Please try again.");
                request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/home?success=Request submitted successfully");
        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error submitting hotel request", e);
            request.setAttribute("error", "Error submitting request: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
        }
    }

    private void handleAddHotelPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRole().getRoleId() != 2 && user.getRole().getRoleId() != 3)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Country> countries = fetchCountriesFromAPI();
        request.setAttribute("countries", countries);

        // Hiển thị thông báo thành công nếu có
        String success = request.getParameter("success");
        if (success != null) {
            request.setAttribute("success", success);
        }

        request.getRequestDispatcher("/pages/hotel-management/add-hotel.jsp").forward(request, response);
    }

    private void handleEditHotelPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int hotelId = Integer.parseInt(request.getParameter("hotelId"));
            HotelDAO hotelDAO = new HotelDAO();
            HotelServiceDAO serviceDAO = new HotelServiceDAO();
            RoomDAO roomDAO = new RoomDAO();
            List<Room> rooms = roomDAO.getRoomsByHotelId(hotelId);

            Hotel hotel = hotelDAO.getHotelById(hotelId); // Giả định có hàm này
            if (hotel == null || hotel.getHotelAgentId() != user.getUserId()) {
                request.setAttribute("error", "Hotel not found or you don't have permission to edit.");
                request.getRequestDispatcher("/pages/hotel-management/error.jsp").forward(request, response);
                return;
            }

            // Tách location thành country, city, address (giả định location dạng "address, city, country")
            String[] locationParts = hotel.getLocation().split(", ");
            String hotelAddress = locationParts.length > 0 ? locationParts[0] : "";
            String hotelCity = locationParts.length > 1 ? locationParts[1] : "";
            String hotelCountry = locationParts.length > 2 ? locationParts[2] : "";

            request.setAttribute("rooms", rooms);
            request.setAttribute("hotel", hotel);
            request.setAttribute("hotelCountry", hotelCountry);
            request.setAttribute("hotelCity", hotelCity);
            request.setAttribute("hotelAddress", hotelAddress);
            request.setAttribute("countries", fetchCountriesFromAPI());
            request.setAttribute("cities", fetchCitiesFromAPI(hotelCountry));
            request.setAttribute("services", serviceDAO.getAllFreeServices());
            request.setAttribute("hotelServices", hotelDAO.getHotelServiceIds(hotelId)); // Giả định có hàm này

            request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error loading edit hotel page", e);
            request.setAttribute("error", "Error loading page: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/error.jsp").forward(request, response);
        }
    }

    private void handleEditHotelSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            request.setAttribute("error", "You must be logged in as a Hotel Agent to edit a hotel.");
            request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
            return;
        }

        int hotelId = 0;
        String hotelName = null;
        String hotelDescription = null;
        String country = null;
        String city = null;
        String address = null;
        List<String> serviceIds = new ArrayList<>();
        List<String> imageUrls = new ArrayList<>();

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String value = item.getString("UTF-8");
                    switch (fieldName) {
                        case "hotelId" ->
                            hotelId = Integer.parseInt(value);
                        case "hotelName" ->
                            hotelName = value;
                        case "hotelDescription" ->
                            hotelDescription = value;
                        case "country" ->
                            country = value;
                        case "city" ->
                            city = value;
                        case "address" ->
                            address = value;
                        case "serviceIds" ->
                            serviceIds.add(value);
                    }
                } else if (item.getFieldName().equals("galleryImages") && item.getSize() > 0) {
                    File tempFile = File.createTempFile("hotel_img_", ".jpg");
                    item.write(tempFile);
                    Map<String, Object> uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
                    String imageUrl = (String) uploadResult.get("secure_url");
                    imageUrls.add(imageUrl);
                    Files.deleteIfExists(tempFile.toPath());
                }
            }

            // Kiểm tra dữ liệu
            if (hotelId <= 0) {
                request.setAttribute("error", "Invalid hotel ID.");
                request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
                return;
            }
            if (hotelName == null || hotelName.trim().isEmpty()) {
                request.setAttribute("error", "Hotel name is required.");
                request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
                return;
            }

            // Cập nhật database
            HotelDAO hotelDAO = new HotelDAO();
            Hotel existingHotel = hotelDAO.getHotelById(hotelId);
            if (existingHotel == null || existingHotel.getHotelAgentId() != user.getUserId()) {
                request.setAttribute("error", "Hotel not found or you don't have permission to edit.");
                request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
                return;
            }

            // Nếu không upload ảnh mới, giữ nguyên ảnh cũ
            List<String> updatedImageUrls = imageUrls.isEmpty()
                    ? new org.json.JSONArray(existingHotel.getHotelImageURLs()).toList().stream().map(Object::toString).collect(Collectors.toList())
                    : imageUrls;

            boolean success = hotelDAO.updateHotel(hotelId, hotelName, hotelDescription, country, city, address, serviceIds, updatedImageUrls);
            if (!success) {
                request.setAttribute("error", "Failed to update hotel. Please try again.");
                request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/get-hotels?success=Hotel updated successfully");
        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error editing hotel", e);
            request.setAttribute("error", "Error editing hotel: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/edit-hotel.jsp").forward(request, response);
        }
    }

    private List<Country> fetchCountriesFromAPI() throws IOException {
        List<Country> countryList = new ArrayList<>();
        String apiUrl = "https://restcountries.com/v3.1/all";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            StringBuilder response;
            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                response = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
            }

            // Phân tích JSON từ API
            JSONArray jsonArray = new JSONArray(response.toString());
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject countryJson = jsonArray.getJSONObject(i);
                String code = countryJson.getString("cca2");
                JSONObject nameObj = countryJson.getJSONObject("name");
                String name = nameObj.getString("common");
                countryList.add(new Country(code, name));
            }

            // Sắp xếp danh sách quốc gia theo tên (A-Z)
            Collections.sort(countryList, (Country c1, Country c2) -> c1.getName().compareToIgnoreCase(c2.getName()));
            // Nếu dùng Java 8+, có thể thay bằng:
            // countryList.sort(Comparator.comparing(Country::getName, String.CASE_INSENSITIVE_ORDER));
        } else {
            Logger.getLogger(HotelManagementController.class.getName())
                    .log(Level.SEVERE, "Failed to fetch countries. Response code: " + responseCode);
        }

        conn.disconnect();
        return countryList;
    }

    private void handleGetCities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String countryCode = request.getParameter("country");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (countryCode != null && !countryCode.isEmpty()) {
            try {
                List<String> cities = fetchCitiesFromAPI(countryCode);
                // Tạo JSONArray từ List<String>
                JSONArray jsonArray = new JSONArray(cities);
                response.getWriter().write(jsonArray.toString());
            } catch (Exception e) {
                Logger.getLogger(HotelManagementController.class.getName())
                        .log(Level.SEVERE, "Error fetching cities for country " + countryCode, e);
                response.getWriter().write("[]"); // Trả về mảng rỗng nếu có lỗi
            }
        } else {
            response.getWriter().write("[]"); // Trả về mảng rỗng nếu không có countryCode
        }
    }

    private void handleGetHotels(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Lấy user từ session

        if (user == null || user.getRole().getRoleId() != 3) { // Giả định RoleId 3 là Hotel Agent
            request.setAttribute("error", "You must be logged in as a Hotel Agent.");
            request.getRequestDispatcher("/").forward(request, response);
            return;
        }

        HotelDAO hotelDAO = new HotelDAO();
        List<Hotel> hotels = hotelDAO.getHotelsByHotelAgentId(user.getUserId());

        request.setAttribute("hotels", hotels);
        request.getRequestDispatcher("/pages/hotel-management/listings.jsp").forward(request, response);
    }

    private List<String> fetchCitiesFromAPI(String countryCode) throws IOException {
        List<String> cityList = new ArrayList<>();
        String apiUrl = "http://api.geonames.org/searchJSON?country=" + countryCode
                + "&maxRows=500&username=thaonguyent543";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        Logger.getLogger(HotelManagementController.class.getName())
                .log(Level.INFO, "GeoNames API response code: " + responseCode);

        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            Logger.getLogger(HotelManagementController.class.getName())
                    .log(Level.INFO, "Raw API response: " + response.toString());

            JSONObject jsonResponse = new JSONObject(response.toString());
            if (jsonResponse.has("geonames")) {
                JSONArray geonames = jsonResponse.getJSONArray("geonames");
                for (int i = 0; i < geonames.length(); i++) {
                    JSONObject cityJson = geonames.getJSONObject(i);
                    String fcl = cityJson.getString("fcl"); // Loại đối tượng
                    String fcode = cityJson.getString("fcode"); // Mã chi tiết
                    int population = cityJson.optInt("population", 0); // Dân số, mặc định 0 nếu không có

                    // Mở rộng lọc để bao gồm nhiều loại địa danh hơn
                    if (("P".equals(fcl)
                            && // Populated places
                            ("PPL".equals(fcode) || "PPLC".equals(fcode) || "PPLL".equals(fcode) || "PPLX".equals(fcode)))
                            || ("A".equals(fcl)
                            && // Administrative divisions
                            ("ADM1".equals(fcode) || "ADM2".equals(fcode)))
                            || ("L".equals(fcl) && "RGN".equals(fcode))
                            || // Regions
                            ("S".equals(fcl) && "AIRP".equals(fcode))) { // Airports
                        String cityName = cityJson.getString("name");
                        // Tránh trùng lặp bằng cách kiểm tra trước khi thêm
                        if (!cityList.contains(cityName)) {
                            cityList.add(cityName);
                        }
                    }
                }
                Collections.sort(cityList, String.CASE_INSENSITIVE_ORDER);

                Logger.getLogger(HotelManagementController.class.getName())
                        .log(Level.INFO, "Processed cities: " + cityList);
            } else {
                Logger.getLogger(HotelManagementController.class.getName())
                        .log(Level.WARNING, "No 'geonames' array found in response");
            }
        } else {
            Logger.getLogger(HotelManagementController.class.getName())
                    .log(Level.SEVERE, "Failed to fetch cities for country " + countryCode + ". Response code: " + responseCode);
        }

        conn.disconnect();
        return cityList;
    }

    public static class Country {

        private String code;
        private String name;

        public Country(String code, String name) {
            this.code = code;
            this.name = name;
        }

        public String getCode() {
            return code;
        }

        public String getName() {
            return name;
        }
    }
}
