package com.java_db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;

public class Main {

  public static Connection getConnection() throws SQLException, IOException {
    // Load database properties
    Properties props = new Properties();
    FileInputStream fis = new FileInputStream("src/main/resources/application.properties");
    props.load(fis);

    // Retrieve the connection details from the properties file
    String url = props.getProperty("db.url");
    String username = props.getProperty("db.username");
    String password = props.getProperty("db.password");
    String driver = props.getProperty("db.driver");

    // Return the database connection
    return DriverManager.getConnection(url, username, password);
  }

  public static void main(String[] args) {
    try (Connection connection = getConnection()) {
      if (connection != null) {
        System.out.println("Connected to the PostgreSQL server successfully!");
      }
    } catch (SQLException | IOException e) {
      System.out.println("Connection failed: " + e.getMessage());
    }
  }
}
