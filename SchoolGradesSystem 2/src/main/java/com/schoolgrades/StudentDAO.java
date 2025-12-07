package com.schoolgrades;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // CREATE
    public static void createStudent(String fullName, String className) throws SQLException {
        String sql = "INSERT INTO students (full_name, class_name) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, className);
            ps.executeUpdate();
        }
    }

    // READ
    public static List<Student> getAllStudents() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT id, full_name, class_name FROM students ORDER BY id";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("full_name");
                String className = rs.getString("class_name");
                list.add(new Student(id, fullName, className));
            }
        }
        return list;
    }

    // READ
    public static Student getStudentById(int id) throws SQLException {
        String sql = "SELECT id, full_name, class_name FROM students WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String fullName = rs.getString("full_name");
                    String className = rs.getString("class_name");
                    return new Student(id, fullName, className);
                }
            }
        }
        return null;
    }

    // UPDATE
    public static void updateStudent(int id, String fullName, String className) throws SQLException {
        String sql = "UPDATE students SET full_name = ?, class_name = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, className);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    // DELETE
    public static void deleteStudent(int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
