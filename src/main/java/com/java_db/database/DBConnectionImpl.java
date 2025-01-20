package com.java_db.database;

import java.io.Closeable;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnectionImpl implements DBConnection {

    private static final String APPLICATION_PROPERTIES_PATH = "src/main/resources/application.properties";
    private Connection connection;

    @Override
    public Connection getConnection() throws SQLException, IOException {
        // Load database properties
        Properties props = new Properties();
        FileInputStream fis = new FileInputStream(APPLICATION_PROPERTIES_PATH);
        props.load(fis);

        // Retrieve the connection details from the properties file
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String password = props.getProperty("db.password");
        String driver = props.getProperty("db.driver");

        // Return the database connection
        return (connection = DriverManager.getConnection(url, username, password));
    }

    @Override
    public void executeQuery(String input) throws SQLException {

        try {
            var statement = connection.createStatement();

            if (input.toLowerCase().contains("select")) {
                var resultSet = statement.executeQuery(input);
                if (!printRecords(resultSet)) {
                    System.out.println("No records found");
                }
            } else {
                try {
                    connection.setAutoCommit(false); // Start transaction

                    int numRowsAffected = statement.executeUpdate(input);
                    System.out.println("Number of rows affected: " + numRowsAffected);

                    connection.commit(); // Commit transaction
                } catch (SQLException e) {
                    System.out.println("Error executing query: " + e.getMessage());
                    try {
                        connection.rollback(); // Rollback transaction on error
                    } catch (SQLException rollbackException) {
                        System.out.println("Error during rollback: " + rollbackException.getMessage());
                    }
                } finally {
                    connection.setAutoCommit(true);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error executing query: " + e.getMessage());
        }
    }

    private static boolean printRecords(ResultSet resultSet) throws SQLException {

        boolean foundData = false;
        var meta = resultSet.getMetaData();

        System.out.println();

        for (int i = 1; i <= meta.getColumnCount(); i++) {
            System.out.printf("%-15s", meta.getColumnName(i).toUpperCase());
        }
        System.out.println("==============================");


        while (resultSet.next()) {
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                System.out.printf("%-15s", resultSet.getString(i));
            }
            System.out.println();
            foundData = true;
        }
        return foundData;
    }
}
