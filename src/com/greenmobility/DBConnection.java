package com.greenmobility;

import java.sql.Connection;
import java.sql.DriverManager;

/*
 * Database settings come from environment variables so that no password
 * is stored in the code (the repo is public). Set these on your server:
 *
 *   DB_URL       e.g. jdbc:mysql://your-db-host:3306/green_mobility
 *   DB_USER      e.g. ecotransit_app
 *   DB_PASSWORD  your database password
 *
 * If they are not set, it falls back to a local MySQL with user "root"
 * and an empty password, for development on your own machine.
 */
public class DBConnection {

    private static String env(String name, String fallback) {
        String value = System.getenv(name);
        return (value == null || value.isEmpty()) ? fallback : value;
    }

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
                env("DB_URL", "jdbc:mysql://localhost:3306/green_mobility"),
                env("DB_USER", "root"),
                env("DB_PASSWORD", "")
        );
    }
}
