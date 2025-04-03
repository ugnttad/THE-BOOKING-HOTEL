package config;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryConfig {

    private static final Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dnrlbmshg",
                "api_key", "176274574617476",
                "api_secret", "mJDLAZquT88AQzYcfe0OGG1QRYE"));
    }

    public static Cloudinary getCloudinary() {
        return cloudinary;
    }
}
