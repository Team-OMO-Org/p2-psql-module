package com.java_db.database;

import com.java_db.Main;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class SQLQueryExecutor {

  private static final Logger LOGGER = Logger.getLogger(SQLQueryExecutor.class.getName());
  private final Connection connection;

  static {
    try {
      File logDir = new File("logs");
      if (!logDir.exists()) {
        logDir.mkdirs();
      }
      LogManager.getLogManager().readConfiguration(Main.class.getResourceAsStream("/logging.properties"));
    } catch (IOException e) {
      LOGGER.severe("Could not load logging configuration: " + e.getMessage());
    }
  }

  public SQLQueryExecutor(Connection connection) {
    this.connection = connection;
      }

  public void findHighSpendingCustomers() {
    String query = "SELECT c.last_name || ' ' || c.first_name as name , c.email, SUM(o.total_amount) AS total_spent\n" +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "GROUP BY c.customer_id\n" +
        "HAVING SUM(o.total_amount) > 500\n" +
        "ORDER BY total_spent DESC\n";

    try (Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("High-Spending Customers:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s %-30s %-10s\n", "Name", "Email", "Total Spent");
      System.out.println("-----------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-30s $%-10.2f\n", rs.getString("name"), rs.getString("email"), rs.getDouble("total_spent"));
      }
    } catch (SQLException e) {
      // e.printStackTrace();
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
  }

  public void identifyPopularProducts() {
    String query = "SELECT p.product_name AS product_name, SUM(od.quantity) AS total_quantity, SUM(od.quantity * p.price) AS revenue_generated\n" +
        "FROM products p " +
        "JOIN order_items od ON p.product_id = od.product_id\n" +
        "GROUP BY p.product_id, p.product_name\n" +
        "ORDER BY total_quantity DESC\n" +
        "LIMIT 3\n";

    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Top 3 Popular Products:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s %-15s %-15s\n", "Product Name", "Total Quantity", "Revenue Generated");
      System.out.println("-------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-15d $%-15.2f\n", rs.getString("product_name"), rs.getInt("total_quantity"), rs.getDouble("revenue_generated"));
      }
    } catch (SQLException e) {
      // e.printStackTrace();
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
  }

  public void customerOrderHistory(Connection conn, int customerId) {
    String query = "SELECT c.last_name || ' ' || c.first_name as name,  o.order_date, p.product_name AS product_name, od.quantity, o.total_amount\n " +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "JOIN order_items od ON o.order_id = od.order_id\n" +
        "JOIN products p ON od.product_id = p.product_id\n" +
        "WHERE c.customer_id = ? \n" +
        "ORDER BY o.order_date\n";

    try (PreparedStatement pstmt = connection.prepareStatement(query)) {
      pstmt.setInt(1, customerId);
      try (ResultSet rs = pstmt.executeQuery()) {
        System.out.println("Order History");
        System.out.println("--------------------------------------------------------------");
        System.out.println("Query: " + query);
        System.out.println("--------------------------------------------------------------");
        System.out.printf("%-20s %-15s %-50s %-10s %-15s\n", "Customer Name", "Order Date", "Product Name", "Quantity", "Total Amount");
        System.out.println("--------------------------------------------------------------------------------------------------------------");
        while (rs.next()) {
          System.out.printf("%-20s %-15s %-50s %-10d $%-15.2f\n", rs.getString("name"), rs.getDate("order_date"), rs.getString("product_name"), rs.getInt("quantity"), rs.getDouble("total_amount"));
        }
      }
    } catch (SQLException e) {
      // e.printStackTrace();
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
  }

  public List<String> getMostPopularProductsInCategory(){
    String query = "SELECT cat.category_name, p.product_name, SUM(oi.quantity) AS total_sold\n" +
        "FROM categories cat\n" +
        "JOIN products p ON cat.category_id = p.category_id\n" +
        "JOIN order_items oi ON p.product_id = oi.product_id\n" +
        "GROUP BY cat.category_name, p.product_name\n" +
        "ORDER BY cat.category_name, total_sold DESC";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Most Popular Products In Category:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s %-20s %-10s\n", "Category Name", "Product Name", "Total Sold");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-20s %-10d\n", rs.getString("category_name"), rs.getString("product_name"), rs.getInt("total_sold"));
        results.add(rs.getString("category_name") + ": " + rs.getString("product_name") + " - " + rs.getInt("total_sold"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getCustomersWithoutOrders(){
    String query = "SELECT c.customer_id, c.first_name, c.last_name\n" +
        "FROM customers c\n" +
        "LEFT JOIN orders o ON c.customer_id = o.customer_id\n" +
        "WHERE o.order_id IS NULL";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Customers Without Orders:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-10s %-15s %-15s\n", "Customer ID", "First Name", "Last Name");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d %-15s %-15s\n", rs.getInt("customer_id"), rs.getString("first_name"), rs.getString("last_name"));
        results.add(rs.getInt("customer_id") + ": " + rs.getString("first_name") + " " + rs.getString("last_name"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getProductsInCartsNotPurchased(){
    String query = "SELECT DISTINCT p.product_name, sc.customer_id\n" +
        "FROM shopping_cart_items sci\n" +
        "JOIN products p ON sci.product_id = p.product_id\n" +
        "JOIN shopping_carts sc ON sci.shopping_cart_id = sc.shopping_cart_id\n" +
        "LEFT JOIN orders o ON sc.customer_id = o.customer_id\n" +
        "WHERE o.order_id IS NULL";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Products In Carts Not Purchased:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s %-10s\n", "Product Name", "Customer ID");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-10d\n", rs.getString("product_name"), rs.getInt("customer_id"));
        results.add(rs.getString("product_name") + ": " + rs.getInt("customer_id"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

   public List<String> getRevenueLostDueToCancelledOrders(){
    String query = "SELECT SUM(oi.quantity * p.price) AS total_lost_revenue\n" +
        "FROM orders o\n" +
        "JOIN order_items oi ON o.order_id = oi.order_id\n" +
        "JOIN products p ON oi.product_id = p.product_id\n" +
        "WHERE o.status = 'Cancelled'";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Revenue Lost Due To Cancelled Orders:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s\n", "Total Lost Revenue");
      System.out.println("--------------------------------------------------------------");
      if (rs.next()) {
        System.out.printf("$%-20.2f\n", rs.getDouble("total_lost_revenue"));
        results.add("Total Lost Revenue: " + rs.getDouble("total_lost_revenue"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getCustomersWithPendingOrders(){
   // String query = "SELECT customer_id, COUNT(*) AS pending_orders\n" +
        String query = "SELECT c.customer_id, c.last_name || ' ' || c.first_name as name , COUNT(*) AS pending_orders\n" +
        "FROM customers c " +
        "JOIN orders o ON c.customer_id = o.customer_id " +
        "WHERE status = 'Pending'\n" +
        "GROUP BY c.customer_id\n" +
        "HAVING COUNT(*) > 1 " +
        "ORDER BY pending_orders DESC";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Customers With Pending Orders:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-10s  %-25s  %-15s\n", "Customer ID", "Customer Name" , "Pending Orders");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d  %-25s  %-15d\n", rs.getInt("customer_id"),  rs.getString("name"), rs.getInt("pending_orders"));
        results.add(rs.getInt("customer_id") + ": " + rs.getInt("pending_orders"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getRevenueAndAverageByCustomer(){
    String query = "SELECT c.customer_id, c.first_name || ' '||  c.last_name as name, \n" +
        "       SUM(o.total_amount) AS total_revenue,\n" +
        "       AVG(o.total_amount) AS avg_revenue\n" +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "GROUP BY c.customer_id, c.first_name, c.last_name";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Revenue And Average By Customer:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-10s %-25s  %-15s %-15s\n", "Customer ID", "Customer Name", "Total Revenue", "Avg Revenue");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d %-25s $%-15.2f $%-15.2f\n", rs.getInt("customer_id"), rs.getString("name"), rs.getDouble("total_revenue"), rs.getDouble("avg_revenue"));
        results.add(rs.getInt("customer_id") + ": " + rs.getString("name") +
            " - Total Revenue: " + rs.getDouble("total_revenue") + ", Avg Revenue: " + rs.getDouble("avg_revenue"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getShippedOrderPercentage(){
    String query = "SELECT (COUNT(*) FILTER (WHERE status = 'Shipped') * 100.0 / COUNT(*)) AS shipped_percentage\n" +
        "FROM orders";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Shipped Order Percentage:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s\n", "Shipped Percentage");
      System.out.println("--------------------------------------------------------------");
      if (rs.next()) {
        System.out.printf("%-20.2f%%\n", rs.getDouble("shipped_percentage"));
        results.add("Shipped Order Percentage: " + rs.getDouble("shipped_percentage") + "%");
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getMostValuableCustomers(){
    String query = "SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent\n" +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "GROUP BY c.customer_id, c.first_name, c.last_name\n" +
        "ORDER BY total_spent DESC";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Most Valuable Customers:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-10s %-15s %-15s %-15s\n", "Customer ID", "First Name", "Last Name", "Total Spent");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d %-15s %-15s $%-15.2f\n", rs.getInt("customer_id"), rs.getString("first_name"), rs.getString("last_name"), rs.getDouble("total_spent"));
        results.add(rs.getInt("customer_id") + ": " + rs.getString("first_name") + " " + rs.getString("last_name") +
            " - Total Spent: " + rs.getDouble("total_spent"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getTopProductsByCategory(){
    String query = "WITH RevenueByCategory AS (\n" +
        "    SELECT cat.category_id, cat.category_name, p.product_id, p.product_name, SUM(oi.quantity * p.price) AS revenue,\n" +
        "           RANK() OVER (PARTITION BY cat.category_id ORDER BY SUM(oi.quantity * p.price) DESC) AS rank\n" +
        "    FROM categories cat\n" +
        "    JOIN products p ON cat.category_id = p.category_id\n" +
        "    JOIN order_items oi ON p.product_id = oi.product_id\n" +
        "    GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name\n" +
        ")\n" +
        "SELECT *\n" +
        "FROM RevenueByCategory\n" +
        "WHERE rank <= 3";

    List<String> results = new ArrayList<>();
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Top Products By Category:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-25s %-50s %-15s\n", "Category Name", "Product Name", "Revenue");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-25s %-50s $%-15.2f\n", rs.getString("category_name"), rs.getString("product_name"), rs.getDouble("revenue"));
        results.add(rs.getString("category_name") + ": " + rs.getString("product_name") + " - Revenue: " + rs.getDouble("revenue"));
      }
    } catch (SQLException e) {
//      e.printStackTrace();
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public void getOrderSummaryByStatus() {
    String query = "SELECT  status, COUNT(order_id) AS total_orders,SUM(order_total) AS total_revenue\n" +
        "FROM\n" +
        "    order_details\n" +
        "GROUP BY\n" +
        "    status\n" +
        "ORDER BY\n" +
        "    total_orders DESC;";

    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Order Summary By Status:");
      System.out.println("--------------------------------------------------------------");
      System.out.println("Query: " + query);
      System.out.println("--------------------------------------------------------------");
      System.out.printf("%-20s %-15s %-15s\n", "Status", "Total Orders", "Total Revenue");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-15d $%-15.2f\n", rs.getString("status"),
            rs.getInt("total_orders"), rs.getDouble("total_revenue"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
  }

  public void bulkUpdateProductPricesDuringSale() {
    String updatePricesStmt = "UPDATE products SET price = price * 0.9 WHERE category_id IN (1, 3)";
    System.out.println("Top Products By Category:");
    System.out.println("--------------------------------------------------------------");
    System.out.println("Update statement: " + updatePricesStmt);
    System.out.println("--------------------------------------------------------------");
    try (Statement stmt = connection.createStatement()) {

      // Update product prices
      int rowsAffected = stmt.executeUpdate(updatePricesStmt);


      System.out.println("Product prices updated successfully. Rows affected: " + rowsAffected);
    } catch (SQLException e) {
        LOGGER.severe("Error executing query: " + e.getMessage());
        System.err.println("Error executing query: " + e.getMessage());
    }
  }
  public void batchInsertCustomers() {
    List<Customer> customers = new ArrayList<>();
    Random random = new Random();
    StringBuilder queryBuilder = new StringBuilder();

    for (int i = 0; i < 3; i++) {
      int randomInt = random.nextInt(1000);
      String firstName = "Name" + randomInt;
      String LastName = "LastName" + randomInt;
      customers.add(new Customer(firstName, LastName, (firstName + '.' + LastName).toLowerCase() + "@example.com", LocalDate.now()));
    }
    for (Customer customer : customers) {
      queryBuilder.append("INSERT INTO customers (first_name, last_name, email, registered_at) VALUES ('")
          .append(customer.firstName()).append("', '")
          .append(customer.lastName()).append("', '")
          .append(customer.email()).append("', '")
          .append(customer.registeredAt()).append("');");
    }
    System.out.println("Batch Insert Customers:");
    System.out.println("--------------------------------------------------------------");
    System.out.println("Insert statements: " + queryBuilder);
    System.out.println("--------------------------------------------------------------");

    String insertCustomerQuery = "INSERT INTO customers (first_name, last_name, email, registered_at) VALUES (?, ?, ?, ?)";

    try (PreparedStatement pstmt = connection.prepareStatement(insertCustomerQuery)) {
      for (Customer customer : customers) {
        pstmt.setString(1, customer.firstName());
        pstmt.setString(2, customer.lastName());
        pstmt.setString(3, customer.email());
        pstmt.setDate(4, Date.valueOf(customer.registeredAt()));
        pstmt.addBatch();
      }

      int sumInsertCounts = Arrays.stream(pstmt.executeBatch()).sum();
      System.out.println("Bulk insert completed. Insert counts: " + sumInsertCounts);
    } catch (SQLException e) {
      LOGGER.severe("Error executing bulk insert: " + e.getMessage());
      System.err.println("Error executing bulk insert: " + e.getMessage());
    }
  }

  public void createOrderWithStockValidation(int customerId, int productId, int quantity, double totalAmount) {
    String sqlScript = String.format("""
        BEGIN;

        -- Step 1: Insert the order and retrieve the new order ID
        DO $$
        DECLARE
            new_order_id INT;
            stock_quantity INT;
        BEGIN
            INSERT INTO orders (customer_id, order_date, status, total_amount)
            VALUES (%d, NOW(), 'Pending', %.2f)
            RETURNING order_id INTO new_order_id;

            -- Step 2: Insert the order item
            INSERT INTO order_items (order_id, product_id, quantity)
            VALUES (new_order_id, %d, %d);

            -- Step 3: Check stock quantity
            SELECT stock_quantity INTO stock_quantity
            FROM products
            WHERE product_id = %d;

            -- Step 4: Validate stock and commit/rollback
            IF stock_quantity < %d THEN
                ROLLBACK;
                RAISE EXCEPTION 'Insufficient stock for product_id: %%', %d;
            ELSE
                COMMIT;
                RAISE NOTICE 'Order created successfully. Order ID: %%', new_order_id;
            END IF;
        END $$;
        """, customerId, totalAmount, productId, quantity, productId, quantity, productId);

    System.out.println("--------------------------------------------------------------");
    System.out.println("SQL Script: " + sqlScript);
    System.out.println("--------------------------------------------------------------");

    String insertOrderQuery =
        "INSERT INTO orders (customer_id, order_date, status, total_amount) " +
            "VALUES (?, NOW(), 'Pending', ?) RETURNING order_id";
    String insertOrderItemQuery = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";

    String checkStockQuery = "SELECT stock_quantity FROM products WHERE product_id = ?";

    try (PreparedStatement insertOrderStmt = connection.prepareStatement(insertOrderQuery);
        PreparedStatement insertOrderItemStmt = connection.prepareStatement(insertOrderItemQuery);
        PreparedStatement checkStockStmt = connection.prepareStatement(checkStockQuery)) {

      connection.setAutoCommit(false);

      // Insert order and get the new order ID
      insertOrderStmt.setInt(1, customerId);
      insertOrderStmt.setDouble(2, totalAmount);
      ResultSet rs = insertOrderStmt.executeQuery();
      int newOrderId = 0;
      if (rs.next()) {
        newOrderId = rs.getInt("order_id");
      }

      // Insert order item
      insertOrderItemStmt.setInt(1, newOrderId);
      insertOrderItemStmt.setInt(2, productId);
      insertOrderItemStmt.setInt(3, quantity);
      insertOrderItemStmt.executeUpdate();

      // Check stock
      checkStockStmt.setInt(1, productId);
      rs = checkStockStmt.executeQuery();
      if (rs.next()) {
        int stockQuantity = rs.getInt("stock_quantity");
        if (stockQuantity < quantity) {
          connection.rollback();
          throw new SQLException("Insufficient stock");
        } else {
          connection.commit();
          System.out.println("Order created successfully. Order ID: " + newOrderId);
        }
      }
    } catch (SQLException e) {
      try {
        connection.rollback();
        LOGGER.severe("Transaction failed, rolled back. Error: " + e.getMessage());
        System.err.println("Transaction failed, rolled back. Error: " + e.getMessage());
      } catch (SQLException rollbackEx) {
        LOGGER.severe("Error during rollback: " + rollbackEx.getMessage());
        System.err.println("Error during rollback: " + rollbackEx.getMessage());
      }
    }
    finally {
      try {
        connection.setAutoCommit(true);
      } catch (SQLException e) {
        LOGGER.severe("Error setting auto commit to true: " + e.getMessage());
        System.err.println("Error setting auto commit to true: " + e.getMessage());
      }
    }
  }

  public void deleteCategory(int categoryId) {
    String deleteCategoryQuery = "DELETE FROM categories WHERE category_id = ?";

    System.out.println("--------------------------------------------------------------");
    System.out.println("SQL Script: " + deleteCategoryQuery);
    System.out.println("--------------------------------------------------------------");

    try (PreparedStatement deleteCategoryStmt = connection.prepareStatement(deleteCategoryQuery)) {
      deleteCategoryStmt.setInt(1, categoryId);
      int rowsAffected = deleteCategoryStmt.executeUpdate();

      if (rowsAffected > 0) {
        System.out.println("Category deleted successfully.");
      } else {
        System.out.println("No category found with the given ID.");
      }
    } catch (SQLException e) {
      LOGGER.severe("Error deleting category: " + e.getMessage());
      System.err.println("Error deleting category: " + e.getMessage());
    }
  }

}

record Customer(String firstName, String lastName, String email, LocalDate registeredAt) {
}
