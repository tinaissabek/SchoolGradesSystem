<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.schoolgrades.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String message = null;
    String error = null;

    String action = request.getParameter("action");
    if ("addSubject".equals(action)) {
        String subjectName = request.getParameter("subjectName");
        if (subjectName == null || subjectName.trim().isEmpty()) {
            error = "Название предмета не может быть пустым.";
        } else {
            SchoolData.addSubject(subjectName.trim());
            message = "Предмет успешно добавлен.";
        }
    }

    List<Subject> subjects = SchoolData.getSubjects();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Предметы</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">SchoolGrades</a>
        <div>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="students.jsp">Ученики</a></li>
                <li class="nav-item"><a class="nav-link active" href="subjects.jsp">Предметы</a></li>
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
                    <h5 class="card-title mb-0">Добавить предмет</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="subjects.jsp">
                        <input type="hidden" name="action" value="addSubject" />
                        <div class="mb-3">
                            <label for="subjectName" class="form-label">Название предмета</label>
                            <input type="text" class="form-control" id="subjectName" name="subjectName">
                        </div>
                        <button type="submit" class="btn btn-primary">Добавить</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <div class="card mb-4 shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">Список предметов</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Название</th>
                                <th>Средний балл</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (subjects.isEmpty()) { %>
                            <tr>
                                <td colspan="3" class="text-center text-muted">Пока нет ни одного предмета.</td>
                            </tr>
                        <% } else {
                               for (Subject sub : subjects) { %>
                            <tr>
                                <td><%= sub.getId() %></td>
                                <td><%= sub.getName() %></td>
                                <td>
                                    <%
                                        double avgSub = SchoolData.getAverageForSubject(sub.getId());
                                        if (avgSub == 0.0) {
                                            out.print("-");
                                        } else {
                                            out.print(String.format("%.2f", avgSub));
                                        }
                                    %>
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
