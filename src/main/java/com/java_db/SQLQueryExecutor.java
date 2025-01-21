package com.java_db;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class SQLQueryExecutor {

  private static final Logger LOGGER = Logger.getLogger(Main.class.getName());
  private final Connection connection;

  static {
    try {
      LogManager.getLogManager().readConfiguration(Main.class.getResourceAsStream("/logging.properties"));
    } catch (IOException e) {
      LOGGER.severe("Could not load logging configuration: " + e.getMessage());
    }
  }

  public SQLQueryExecutor(Connection connection) {
    this.connection = connection;
      }

  public void findHighSpendingCustomers(Connection conn) {
    String query = "SELECT c.last_name || ' ' || c.first_name as name , c.email, SUM(o.total_amount) AS total_spent " +
        "FROM customers c " +
        "JOIN orders o ON c.customer_id = o.customer_id " +
        "GROUP BY c.customer_id " +
        "HAVING SUM(o.total_amount) > 500";

    try (Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("High-Spending Customers:");
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

  public void identifyPopularProducts(Connection conn) {
    String query = "SELECT p.product_name AS product_name, SUM(od.quantity) AS total_quantity, SUM(od.quantity * p.price) AS revenue_generated " +
        "FROM products p " +
        "JOIN order_items od ON p.product_id = od.product_id " +
        "GROUP BY p.product_id, p.product_name " +
        "ORDER BY total_quantity DESC " +
        "LIMIT 3";

    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Top 3 Popular Products:");
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

  public void customerOrderHistory(Connection conn, String customerName) {
    String query = "SELECT o.order_date, p.product_name AS product_name, od.quantity, o.total_amount " +
        "FROM customers c " +
        "JOIN orders o ON c.customer_id = o.customer_id " +
        "JOIN order_items od ON o.order_id = od.order_id " +
        "JOIN products p ON od.product_id = p.product_id " +
        "WHERE c.last_name = ? " +
        "ORDER BY o.order_date";

    try (PreparedStatement pstmt = conn.prepareStatement(query)) {
      pstmt.setString(1, customerName);
      try (ResultSet rs = pstmt.executeQuery()) {
        System.out.printf("Order History for %s:\n", customerName);
        System.out.printf("%-15s %-20s %-10s %-15s\n", "Order Date", "Product Name", "Quantity", "Total Amount");
        System.out.println("--------------------------------------------------------------");
        while (rs.next()) {
          System.out.printf("%-15s %-20s %-10d $%-15.2f\n", rs.getDate("order_date"), rs.getString("product_name"), rs.getInt("quantity"), rs.getDouble("total_amount"));
        }
      }
    } catch (SQLException e) {
      // e.printStackTrace();
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
  }

  public List<String> getMostPopularProductsInCategory(Connection conn) {
    String query = "SELECT cat.category_name, p.product_name, SUM(oi.quantity) AS total_sold\n" +
        "FROM categories cat\n" +
        "JOIN products p ON cat.category_id = p.category_id\n" +
        "JOIN order_items oi ON p.product_id = oi.product_id\n" +
        "GROUP BY cat.category_name, p.product_name\n" +
        "ORDER BY cat.category_name, total_sold DESC";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Most Popular Products In Category:");
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

  public List<String> getTotalQuantitySoldPerDay(Connection conn) {
    String query = "SELECT order_date, SUM(oi.quantity) AS total_quantity\n" +
        "FROM orders o\n" +
        "JOIN order_items oi ON o.order_id = oi.order_id\n" +
        "GROUP BY order_date\n" +
        "ORDER BY order_date";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Total Quantity Sold Per Day:");
      System.out.printf("%-15s %-10s\n", "Order Date", "Total Quantity");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-15s %-10d\n", rs.getDate("order_date"), rs.getInt("total_quantity"));
        results.add(rs.getDate("order_date") + ": " + rs.getInt("total_quantity"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getCustomersWithoutOrders(Connection conn) {
    String query = "SELECT c.customer_id, c.first_name, c.last_name\n" +
        "FROM customers c\n" +
        "LEFT JOIN orders o ON c.customer_id = o.customer_id\n" +
        "WHERE o.order_id IS NULL";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Customers Without Orders:");
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

  public List<String> getProductsInCartsNotPurchased(Connection conn) {
    String query = "SELECT DISTINCT p.product_name, sc.customer_id\n" +
        "FROM shopping_cart_items sci\n" +
        "JOIN products p ON sci.product_id = p.product_id\n" +
        "JOIN shopping_carts sc ON sci.shopping_cart_id = sc.shopping_cart_id\n" +
        "LEFT JOIN orders o ON sc.customer_id = o.customer_id\n" +
        "WHERE o.order_id IS NULL";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Products In Carts Not Purchased:");
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

  public List<String> getCancelledOrdersWithTotalValue(Connection conn) {
    String query = "SELECT o.order_id, SUM(oi.quantity * p.price) AS cancelled_value\n" +
        "FROM orders o\n" +
        "JOIN order_items oi ON o.order_id = oi.order_id\n" +
        "JOIN products p ON oi.product_id = p.product_id\n" +
        "WHERE o.status = 'Cancelled'\n" +
        "GROUP BY o.order_id";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Cancelled Orders With Total Value:");
      System.out.printf("%-10s %-15s\n", "Order ID", "Cancelled Value");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d $%-15.2f\n", rs.getInt("order_id"), rs.getDouble("cancelled_value"));
        results.add(rs.getInt("order_id") + ": " + rs.getDouble("cancelled_value"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getRevenueLostDueToCancelledOrders(Connection conn) {
    String query = "SELECT SUM(oi.quantity * p.price) AS total_lost_revenue\n" +
        "FROM orders o\n" +
        "JOIN order_items oi ON o.order_id = oi.order_id\n" +
        "JOIN products p ON oi.product_id = p.product_id\n" +
        "WHERE o.status = 'Cancelled'";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Revenue Lost Due To Cancelled Orders:");
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

  public List<String> getCustomersWithPendingOrders(Connection conn) {
    String query = "SELECT customer_id, COUNT(*) AS pending_orders\n" +
        "FROM orders\n" +
        "WHERE status = 'Pending'\n" +
        "GROUP BY customer_id\n" +
        "HAVING COUNT(*) > 1";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Customers With Pending Orders:");
      System.out.printf("%-10s %-15s\n", "Customer ID", "Pending Orders");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d %-15d\n", rs.getInt("customer_id"), rs.getInt("pending_orders"));
        results.add(rs.getInt("customer_id") + ": " + rs.getInt("pending_orders"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getRevenueAndAverageByCustomer(Connection conn) {
    String query = "SELECT c.customer_id, c.first_name, c.last_name, \n" +
        "       SUM(o.total_amount) AS total_revenue,\n" +
        "       AVG(o.total_amount) AS avg_revenue\n" +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "GROUP BY c.customer_id, c.first_name, c.last_name";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Revenue And Average By Customer:");
      System.out.printf("%-10s %-15s %-15s %-15s %-15s\n", "Customer ID", "First Name", "Last Name", "Total Revenue", "Avg Revenue");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-10d %-15s %-15s $%-15.2f $%-15.2f\n", rs.getInt("customer_id"), rs.getString("first_name"), rs.getString("last_name"), rs.getDouble("total_revenue"), rs.getDouble("avg_revenue"));
        results.add(rs.getInt("customer_id") + ": " + rs.getString("first_name") + " " + rs.getString("last_name") +
            " - Total Revenue: " + rs.getDouble("total_revenue") + ", Avg Revenue: " + rs.getDouble("avg_revenue"));
      }
    } catch (SQLException e) {
      LOGGER.severe("Error executing query: " + e.getMessage());
      System.err.println("Error executing query: " + e.getMessage());
    }
    return results;
  }

  public List<String> getShippedOrderPercentage(Connection conn) {
    String query = "SELECT (COUNT(*) FILTER (WHERE status = 'Shipped') * 100.0 / COUNT(*)) AS shipped_percentage\n" +
        "FROM orders";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Shipped Order Percentage:");
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

  public List<String> getMostValuableCustomers(Connection conn) {
    String query = "SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent\n" +
        "FROM customers c\n" +
        "JOIN orders o ON c.customer_id = o.customer_id\n" +
        "GROUP BY c.customer_id, c.first_name, c.last_name\n" +
        "ORDER BY total_spent DESC";

    List<String> results = new ArrayList<>();
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Most Valuable Customers:");
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

  public List<String> getTopProductsByCategory(Connection conn) {
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
    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
      System.out.println("Top Products By Category:");
      System.out.printf("%-20s %-20s %-15s\n", "Category Name", "Product Name", "Revenue");
      System.out.println("--------------------------------------------------------------");
      while (rs.next()) {
        System.out.printf("%-20s %-20s $%-15.2f\n", rs.getString("category_name"), rs.getString("product_name"), rs.getDouble("revenue"));
        results.add(rs.getString("category_name") + ": " + rs.getString("product_name") + " - Revenue: " + rs.getDouble("revenue"));
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return results;
  }

  public void bulkUpdateProductPricesDuringSale() {
    String updatePricesQuery = "UPDATE products SET price = price * 0.9 WHERE category_id IN (1, 3)";

    try (Statement stmt = connection.createStatement()) {
      connection.setAutoCommit(false);

      // Update product prices
      int rowsAffected = stmt.executeUpdate(updatePricesQuery);

      connection.commit();
      System.out.println("Product prices updated successfully. Rows affected: " + rowsAffected);
    } catch (SQLException e) {
      try {
        connection.rollback();
        System.err.println("Transaction failed, rolled back. Error: " + e.getMessage());
      } catch (SQLException rollbackEx) {
        System.err.println("Error during rollback: " + rollbackEx.getMessage());
      }
    }
  }

  public void createOrderWithStockValidation(int customerId, int productId, int quantity, double totalAmount) {
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
        System.err.println("Transaction failed, rolled back. Error: " + e.getMessage());
      } catch (SQLException rollbackEx) {
        System.err.println("Error during rollback: " + rollbackEx.getMessage());
      }
    }
  }
}
