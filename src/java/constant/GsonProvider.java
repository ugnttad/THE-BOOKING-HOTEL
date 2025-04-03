package constant;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDateTime;
import utils.LocalDateTimeAdapter;

public class GsonProvider {
    private static final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
        .create();

    public static Gson getGson() {
        return gson;
    }
}

