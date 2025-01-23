package com.java_db.database;

import java.io.Closeable;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
public class DBConnectionImpl implements DBConnection {
    private static final String APPLICATION_PROPERTIES_PATH = "src/main/resources/application.properties";
    private Connection connection;
    private static final String SQL_SCRIPT_FILE_PATH = "src/main/resources/sql/script.sql";;
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
    public void executeScript() {
        executeScript(SQL_SCRIPT_FILE_PATH);
    }
    @Override
    public void executeScript(String sqlScriptFilePath) {
        try {
            // Read the file into a single String
            String script = Files.readString(Path.of(sqlScriptFilePath));
            // Execute the SQL query
            executeQuery(script);
            System.out.println("Script executed successfully");
        } catch (IOException | SQLException e) {
            System.out.println("Error executing script: " + e.getMessage());
        }
    }
    @Override
    public void executeQuery(String input) throws SQLException {
        try {
            connection.setAutoCommit(false); // Start transaction
            var statement = connection.createStatement();
            boolean hasResultSet = statement.execute(input);
            if (hasResultSet) {
                ResultSet resultSet = statement.getResultSet();
                if (!printRecords(resultSet)) {
                    System.out.println("No records found");
                }
            }
            int numRowsAffected = statement.getUpdateCount();
            if (numRowsAffected > 0) {
                System.out.println("Number of rows affected: " + numRowsAffected);
            }
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
    private static boolean printRecords(ResultSet resultSet) throws SQLException {
        boolean foundData = false;
        var meta = resultSet.getMetaData();
        int columnCount = meta.getColumnCount();
        int columnWidth = 28;
        for (int i = 1; i <= columnCount; i++) {
            System.out.printf("%-" + columnWidth + "s", meta.getColumnName(i).toUpperCase());
        }
        System.out.println();
        System.out.println("=".repeat(columnCount * columnWidth));
        while (resultSet.next()) {
            for (int i = 1; i <= columnCount; i++) {
                System.out.printf("%-" + columnWidth + "s", resultSet.getString(i));
            }
            System.out.println();
            foundData = true;
        }
        return foundData;
    }
}
