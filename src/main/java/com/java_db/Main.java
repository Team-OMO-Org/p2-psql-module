package com.java_db;

import com.java_db.database.DBConnection;
import com.java_db.database.DBConnectionImpl;
import com.java_db.database.SQLQueryExecutor;
import com.java_db.menu.MenuHandlerUtil;
import com.java_db.menu.MenuOption;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.util.Scanner;

public class Main {

  public static void main(String[] args) {
    DBConnection dbConnection = new DBConnectionImpl();
    try (Connection connection = dbConnection.getConnection()) {
      if (connection != null) {
        System.out.println("Connected to the PostgreSQL server successfully!");
        SQLQueryExecutor sqlQueryExecutor = new SQLQueryExecutor(connection);

        Scanner scanner = new Scanner(System.in);
        List<MenuOption> menuOptions = new ArrayList<>();
        menuOptions.add(new MenuOption("Execute SQL script from file", dbConnection::executeScript));
        menuOptions.add(new MenuOption("Select and execute SQL script from file ", () -> {
          System.out.print("Enter file path: ");
          scanner.nextLine();
          String filePath = scanner.nextLine();
          dbConnection.executeScript(filePath);
        }));
        menuOptions.add(new MenuOption("Find High-Spending Customers",
            sqlQueryExecutor::findHighSpendingCustomers));
        menuOptions.add(new MenuOption("Identify Popular Products",
            sqlQueryExecutor::identifyPopularProducts));
        menuOptions.add(new MenuOption("Get Customers Without Orders",
            sqlQueryExecutor::getCustomersWithoutOrders));
        menuOptions.add(new MenuOption("Get Products In Carts Not Purchased",
            sqlQueryExecutor::getProductsInCartsNotPurchased));
        menuOptions.add(new MenuOption("Get Revenue Lost Due To Cancelled Orders",
            sqlQueryExecutor::getRevenueLostDueToCancelledOrders));
        menuOptions.add(new MenuOption("Get Customers With Pending Orders",
            sqlQueryExecutor::getCustomersWithPendingOrders));
        menuOptions.add(new MenuOption("Get Revenue And Average By Customer",
            sqlQueryExecutor::getRevenueAndAverageByCustomer));
        menuOptions.add(new MenuOption("Get Shipped Order Percentage",
            sqlQueryExecutor::getShippedOrderPercentage));
        menuOptions.add(new MenuOption("Get Most Valuable Customers",
            sqlQueryExecutor::getMostValuableCustomers));
        menuOptions.add(new MenuOption("Get Top Products By Category",
            sqlQueryExecutor::getTopProductsByCategory));
        menuOptions.add(new MenuOption("Orders by Status and Total Revenue using View order_details",
            sqlQueryExecutor::getOrderSummaryByStatus));
        menuOptions.add(new MenuOption("Customer Order History", () -> {
          System.out.print("Enter customer ID: ");
          int customerId = scanner.nextInt();
          sqlQueryExecutor.customerOrderHistory(connection, customerId);
        }));
        menuOptions.add(new MenuOption("Batch Insert Customers",
            sqlQueryExecutor::batchInsertCustomers));
        menuOptions.add(new MenuOption("Bulk Update Product Prices During Sale",
            sqlQueryExecutor::bulkUpdateProductPricesDuringSale));
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
        menuOptions.add(new MenuOption("Delete Category using prevent_category_deletion Trigger", () -> {
          System.out.print("Enter category ID: ");
          int categoryId = scanner.nextInt();
          sqlQueryExecutor.deleteCategory(categoryId);
        }));
        MenuHandlerUtil menuHandler = new MenuHandlerUtil(menuOptions, scanner);
        menuHandler.interactWithUser();
      }
    } catch (SQLException | IOException e) {
      System.out.println("Connection failed: " + e.getMessage());
    }
  }


}
