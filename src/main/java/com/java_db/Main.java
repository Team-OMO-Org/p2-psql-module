package com.java_db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;
import java.util.logging.LogManager;
import java.util.logging.Logger;

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
        SQLQueryExecutor sqlQueryExecutor = new SQLQueryExecutor(connection);

        Scanner scanner = new Scanner(System.in);
        List<MenuOption> menuOptions = new ArrayList<>();
        menuOptions.add(new MenuOption("Find High-Spending Customers", () -> sqlQueryExecutor.findHighSpendingCustomers(connection)));
        menuOptions.add(new MenuOption("Identify Popular Products", () -> sqlQueryExecutor.identifyPopularProducts(connection)));
        menuOptions.add(new MenuOption("Get Most Popular Products In Category", () -> sqlQueryExecutor.getMostPopularProductsInCategory(connection)));
        menuOptions.add(new MenuOption("Get Total Quantity Sold Per Day", () -> sqlQueryExecutor.getTotalQuantitySoldPerDay(connection)));
        menuOptions.add(new MenuOption("Get Customers Without Orders", () -> sqlQueryExecutor.getCustomersWithoutOrders(connection)));
        menuOptions.add(new MenuOption("Get Products In Carts Not Purchased", () -> sqlQueryExecutor.getProductsInCartsNotPurchased(connection)));
        menuOptions.add(new MenuOption("Get Cancelled Orders With Total Value", () -> sqlQueryExecutor.getCancelledOrdersWithTotalValue(connection)));
        menuOptions.add(new MenuOption("Get Revenue Lost Due To Cancelled Orders", () -> sqlQueryExecutor.getRevenueLostDueToCancelledOrders(connection)));
        menuOptions.add(new MenuOption("Get Customers With Pending Orders", () -> sqlQueryExecutor.getCustomersWithPendingOrders(connection)));
        menuOptions.add(new MenuOption("Get Revenue And Average By Customer", () -> sqlQueryExecutor.getRevenueAndAverageByCustomer(connection)));
        menuOptions.add(new MenuOption("Get Shipped Order Percentage", () -> sqlQueryExecutor.getShippedOrderPercentage(connection)));
        menuOptions.add(new MenuOption("Get Most Valuable Customers", () -> sqlQueryExecutor.getMostValuableCustomers(connection)));
        menuOptions.add(new MenuOption("Get Top Products By Category", () -> sqlQueryExecutor.getTopProductsByCategory(connection)));
        menuOptions.add(new MenuOption("Bulk Update Product Prices During Sale", () -> sqlQueryExecutor.bulkUpdateProductPricesDuringSale()));
        menuOptions.add(new MenuOption("Customer Order History", () -> {
          System.out.print("Enter customer name: ");
          String customerName = scanner.nextLine();
          sqlQueryExecutor.customerOrderHistory(connection, customerName);
        }));
        menuOptions.add(new MenuOption("Create Order With Stock Validation", () -> {
          System.out.print("Enter customer ID: ");
          int customerId = scanner.nextInt();
          System.out.print("Enter product ID: ");
          int productId = scanner.nextInt();
          System.out.print("Enter quantity: ");
          int quantity = scanner.nextInt();
          System.out.print("Enter total amount: ");
          double totalAmount = scanner.nextDouble();
          sqlQueryExecutor.createOrderWithStockValidation(customerId, productId, quantity, totalAmount);
        }));
        MenuHandlerUtil menuHandler = new MenuHandlerUtil(menuOptions, scanner);
        menuHandler.interactWithUser();
      }
    } catch (SQLException | IOException e) {
      System.out.println("Connection failed: " + e.getMessage());
    }
  }


}
