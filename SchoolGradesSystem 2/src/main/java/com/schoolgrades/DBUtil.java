package com.schoolgrades;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtil {

    private static final String URL = "jdbc:sqlite:schoolgrades.db";

    static {
        try {
            Class.forName("org.sqlite.JDBC");
            initDatabase();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Не найден драйвер SQLite", e);
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка инициализации БД", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL);
    }

    private static void initDatabase() throws SQLException {
        try (Connection conn = getConnection();
             Statement st = conn.createStatement()) {

            // Таблица учеников
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS students (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "full_name TEXT NOT NULL, " +
                    "class_name TEXT" +
                ")"
            );

            // Таблица предметов
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS subjects (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "name TEXT NOT NULL" +
                ")"
            );

            // Таблица оценок
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS grades (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "student_id INTEGER NOT NULL, " +
                    "subject_id INTEGER NOT NULL, " +
                    "value INTEGER NOT NULL, " +
                    "FOREIGN KEY (student_id) REFERENCES students(id), " +
                    "FOREIGN KEY (subject_id) REFERENCES subjects(id)" +
                ")"
            );
        }
    }
}
