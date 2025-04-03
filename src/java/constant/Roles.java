package constant;

import model.Role;

public class Roles {
    public static final int ROLE_ADMIN = 1;
    public static final int ROLE_USER = 2;
    public static final int ROLE_HOTEL_AGENT = 3;
    public static final Role ADMIN = new Role(ROLE_ADMIN, "Admin");
    public static final Role USER = new Role(ROLE_USER, "User");
    public static final Role HOTEL_AGENT = new Role(ROLE_HOTEL_AGENT, "Hotel Agent");
}