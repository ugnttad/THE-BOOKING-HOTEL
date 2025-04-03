//package utils;
//
//import com.google.gson.Gson;
//import com.google.gson.JsonObject;
//import org.apache.http.client.fluent.Request;
//import org.apache.http.client.fluent.Response;
//
//import java.io.IOException;
//import constant.OAuth2;
//import constant.GsonProvider;
//import model.User;
//import org.apache.http.client.fluent.Form;
//
//public class GoogleUtils {
//
//    private static final Gson gson = GsonProvider.getGson();
//
//    public static String getToken(String code) throws IOException {
//        Response response = Request.Post(OAuth2.GOOGLE_LINK_GET_TOKEN)
//                .bodyForm(Form.form().add("code", code)
//                        .add("client_id", OAuth2.GOOGLE_CLIENT_ID)
//                        .add("client_secret", OAuth2.GOOGLE_CLIENT_SECRET)
//                        .add("redirect_uri", OAuth2.GOOGLE_REDIRECT_URI)
//                        .add("grant_type", OAuth2.GOOGLE_GRANT_TYPE).build())
//                .execute();
//
//        String responseBody = response.returnContent().asString();
//        System.out.println("Token Response: " + responseBody);
//
//        JsonObject jsonObject = gson.fromJson(responseBody, JsonObject.class);
//        return jsonObject.get("access_token").getAsString();
//    }
//
//    public static User getUserInfo(final String accessToken) throws IOException {
//        String link = OAuth2.GOOGLE_LINK_GET_USER_INFO + accessToken;
//        Response response = Request.Get(link)
//                .addHeader("Authorization", "Bearer " + accessToken)
//                .execute();
//
//        String responseBody = response.returnContent().asString();
//        System.out.println("User Info Response: " + responseBody);
//
//        JsonObject jsonObject = gson.fromJson(responseBody, JsonObject.class);
//        System.out.println("JSON response: " + jsonObject.toString());
//
//        String googleId = jsonObject.has("id") ? jsonObject.get("id").getAsString() : null;
//        String email = jsonObject.has("email") ? jsonObject.get("email").getAsString() : null;
//        String givenName = jsonObject.has("given_name") ? jsonObject.get("given_name").getAsString() : "";
//        String familyName = jsonObject.has("name") ? jsonObject.get("name").getAsString() : "";
//        String picture = jsonObject.has("picture") ? jsonObject.get("picture").getAsString() : "";
//
//        User user = new User();
//        user.setGoogleId(googleId);
//        user.setEmail(email);
//        user.setFirstName(givenName);
//        user.setLastName(familyName);
//        user.setAvatarUrl(picture);
//
//        return user;
//    }
//}
