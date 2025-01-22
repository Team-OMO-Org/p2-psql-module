package com.java_db.database;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

public interface DBConnection {

    Connection getConnection() throws SQLException, IOException;

    void executeScript();
    void executeQuery(String input) throws SQLException;
}
