
package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/bitezy";

    private static final String USERNAME = "root";
    private static final String PASSWORD =
            System.getenv("BITEZY_DB_PASSWORD");

    public static Connection getConnection() {

        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            if (PASSWORD == null || PASSWORD.isEmpty()) {
                throw new SQLException(
                        "BITEZY_DB_PASSWORD environment variable is not set."
                );
            }

            connection = DriverManager.getConnection(
                    URL,
                    USERNAME,
                    PASSWORD
            );

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return connection;
    }
}
