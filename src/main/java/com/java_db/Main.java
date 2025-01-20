package com.java_db;

import com.java_db.database.DBConnection;
import com.java_db.database.DBConnectionImpl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;

public class Main {

  public static void main(String[] args) {

    DBConnection db = new DBConnectionImpl();
    try (Connection connection = db.getConnection()) {
      if (connection != null) {
        System.out.println("Connected to the PostgreSQL server successfully!\n");

        Scanner scanner = new Scanner(System.in);
        System.out.println("Welcome to the SQL Query Console!");
        System.out.println("-".repeat(20));

        String input = "";
        while (true) {
          System.out.println("Type your SQL Query or 'exit' and press enter:");
          input = scanner.nextLine();
          System.out.println();
          if (input.equalsIgnoreCase("exit")) {
            System.out.println("Goodbye!");
            break;
          }
          db.executeQuery(input);
          System.out.println();
        }
      }
    } catch (SQLException | IOException e) {
      System.out.println("Connection failed: " + e.getMessage());
    }
  }
}
