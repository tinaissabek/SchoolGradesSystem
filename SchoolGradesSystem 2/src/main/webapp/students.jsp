<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, com.schoolgrades.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String message = null;
    String error = null;

    String action = request.getParameter("action");
    if (action != null) {
        try {
            if ("addStudent".equals(action)) {
                String fullName = request.getParameter("fullName");
                String className = request.getParameter("className");

                if (fullName == null || fullName.trim().isEmpty()) {
                    error = "ФИО ученика не может быть пустым.";
                } else {
                    StudentDAO.createStudent(
                        fullName.trim(),
                        className != null ? className.trim() : ""
                    );
                    // PRG
                    response.sendRedirect("students.jsp");
                    return;
                }
            } else if ("deleteStudent".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    StudentDAO.deleteStudent(id);
                    // PRG
                    response.sendRedirect("students.jsp");
                    return;
                } else {
                    error = "Не указан ID ученика для удаления.";
                }
            }
        } catch (SQLException e) {
            error = "Ошибка работы с базой данных: " + e.getMessage();
        } catch (Exception e) {
            error = "Внутренняя ошибка: " + e.getMessage();
        }
    }

    List<Student> students = new ArrayList<>();
    try {
        students = StudentDAO.getAllStudents();
    } catch (SQLException e) {
        error = "Ошибка чтения учеников из базы данных: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ученики</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">SchoolGrades</a>
        <div>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="students.jsp">Ученики</a></li>
                <li class="nav-item"><a class="nav-link" href="subjects.jsp">Предметы</a></li>
                <li class="nav-item"><a class="nav-link" href="admin.jsp">Панель администратора</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">

    <% if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <div class="row">
        <div class="col-md-5">
            <div class="card mb-4 shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">Добавить ученика</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="students.jsp">
                        <input type="hidden" name="action" value="addStudent" />
                        <div class="mb-3">
                            <label for="fullName" class="form-label">ФИО</label>
                            <input type="text" class="form-control" id="fullName" name="fullName">
                        </div>
                        <div class="mb-3">
                            <label for="className" class="form-label">Класс (например, 7А)</label>
                            <input type="text" class="form-control" id="className" name="className">
                        </div>
                        <button type="submit" class="btn btn-primary">Добавить</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <div class="card mb-4 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">Список учеников</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>ФИО</th>
                                <th>Класс</th>
                                <th>Средний балл</th>
                                <th>Действия</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (students.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="text-center text-muted">Пока нет ни одного ученика.</td>
                            </tr>
                        <% } else {
                               for (Student s : students) { %>
                            <tr>
                                <td><%= s.getId() %></td>
                                <td><%= s.getFullName() %></td>
                                <td><%= s.getClassName() %></td>
                                <td>
                                    <%
                                        double avg = SchoolData.getAverageForStudent(s.getId());
                                        if (avg == 0.0) {
                                            out.print("-");
                                        } else {
                                            out.print(String.format("%.2f", avg));
                                        }
                                    %>
                                </td>
                                <td>
                                    <form method="post" action="students.jsp" style="display:inline;">
                                        <input type="hidden" name="action" value="deleteStudent">
                                        <input type="hidden" name="id" value="<%= s.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('Удалить ученика?');">
                                            Удалить
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <%   }
                           } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
