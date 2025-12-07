<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, com.schoolgrades.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String message = null;
    String error = null;

    String action = request.getParameter("action");
    if (action != null) {
        try {
            if ("addGrade".equals(action)) {
                String studentIdStr = request.getParameter("studentId");
                String subjectIdStr = request.getParameter("subjectId");
                String gradeValueStr = request.getParameter("gradeValue");

                if (studentIdStr == null || subjectIdStr == null || gradeValueStr == null ||
                    studentIdStr.isEmpty() || subjectIdStr.isEmpty() || gradeValueStr.isEmpty()) {
                    error = "Не все поля для оценки заполнены.";
                } else {
                    int studentId = Integer.parseInt(studentIdStr);
                    int subjectId = Integer.parseInt(subjectIdStr);
                    int gradeValue = Integer.parseInt(gradeValueStr);

                    if (gradeValue < 1 || gradeValue > 5) {
                        error = "Оценка должна быть от 1 до 5.";
                    } else {
                        SchoolData.addGrade(studentId, subjectId, gradeValue);
                        // PRG
                        response.sendRedirect("admin.jsp");
                        return;
                    }
                }

            } else if ("deleteGrade".equals(action)) {
                String gradeIdStr = request.getParameter("gradeId");
                if (gradeIdStr != null && !gradeIdStr.isEmpty()) {
                    int gradeId = Integer.parseInt(gradeIdStr);
                    SchoolData.deleteGrade(gradeId);
                    response.sendRedirect("admin.jsp");
                    return;
                } else {
                    error = "Не указан ID оценки для удаления.";
                }

            } else if ("updateGrade".equals(action)) {
                String gradeIdStr = request.getParameter("gradeId");
                String newValueStr = request.getParameter("newValue");
                if (gradeIdStr != null && !gradeIdStr.isEmpty() &&
                    newValueStr != null && !newValueStr.isEmpty()) {

                    int gradeId = Integer.parseInt(gradeIdStr);
                    int newValue = Integer.parseInt(newValueStr);

                    if (newValue < 1 || newValue > 5) {
                        error = "Новая оценка должна быть от 1 до 5.";
                    } else {
                        SchoolData.updateGrade(gradeId, newValue);
                        response.sendRedirect("admin.jsp");
                        return;
                    }
                } else {
                    error = "Не хватает данных для изменения оценки.";
                }
            }
        } catch (NumberFormatException e) {
            error = "Ошибка преобразования числа. Проверьте введённые данные.";
        } catch (Exception e) {
            error = "Внутренняя ошибка: " + e.getMessage();
        }
    }

    // Ученики
    List<Student> students = new ArrayList<>();
    try {
        students = StudentDAO.getAllStudents();
    } catch (SQLException e) {
        error = "Ошибка чтения учеников из базы данных: " + e.getMessage();
    }

    // Предметы и оценки
    List<Subject> subjects = SchoolData.getSubjects();
    List<Grade> grades = SchoolData.getGrades();

    // Расчёт лучшего ученика
    String bestStudentLabel = null;
    double bestStudentAvg = 0.0;
    for (Student s : students) {
        double avg = SchoolData.getAverageForStudent(s.getId());
        if (avg > 0.0 && avg > bestStudentAvg) {
            bestStudentAvg = avg;
            bestStudentLabel = s.getFullName() + " (" + s.getClassName() + ")";
        }
    }

    // Расчёт лучшей оценки
    Grade bestGrade = null;
    for (Grade g : grades) {
        if (bestGrade == null || g.getValue() > bestGrade.getValue()) {
            bestGrade = g;
        }
    }

    Student bestGradeStudent = null;
    Subject bestGradeSubject = null;
    if (bestGrade != null) {
        try {
            bestGradeStudent = StudentDAO.getStudentById(bestGrade.getStudentId());
        } catch (SQLException e) {
        }
        bestGradeSubject = SchoolData.findSubjectById(bestGrade.getSubjectId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Панель администратора</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">SchoolGrades</a>
        <div>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="students.jsp">Ученики</a></li>
                <li class="nav-item"><a class="nav-link" href="subjects.jsp">Предметы</a></li>
                <li class="nav-item"><a class="nav-link active" href="admin.jsp">Панель администратора</a></li>
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
                    <h5 class="card-title mb-0">Выставить оценку</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="admin.jsp">
                        <input type="hidden" name="action" value="addGrade" />

                        <div class="mb-3">
                            <label for="studentId" class="form-label">Ученик</label>
                            <select class="form-select" id="studentId" name="studentId">
                                <% for (Student s : students) { %>
                                    <option value="<%= s.getId() %>">
                                        <%= s.getId() %> - <%= s.getFullName() %> (<%= s.getClassName() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="subjectId" class="form-label">Предмет</label>
                            <select class="form-select" id="subjectId" name="subjectId">
                                <% for (Subject sub : subjects) { %>
                                    <option value="<%= sub.getId() %>">
                                        <%= sub.getId() %> - <%= sub.getName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="gradeValue" class="form-label">Оценка (1–5)</label>
                            <input type="number" class="form-control" id="gradeValue" name="gradeValue" min="1" max="5">
                        </div>

                        <button type="submit" class="btn btn-primary">Сохранить</button>
                    </form>
                </div>
            </div>

            <div class="card mb-4 shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">Аналитика</h5>
                </div>
                <div class="card-body">
                    <h6>Лучший ученик</h6>
                    <% if (bestStudentLabel != null) { %>
                        <p>
                            <strong><%= bestStudentLabel %></strong><br>
                            Средний балл:
                            <strong><%= String.format("%.2f", bestStudentAvg) %></strong>
                        </p>
                    <% } else { %>
                        <p class="text-muted">Недостаточно данных для расчёта лучшего ученика.</p>
                    <% } %>

                    <h6 class="mt-3">Лучшая оценка</h6>
                    <% if (bestGrade != null && bestGradeStudent != null && bestGradeSubject != null) { %>
                        <p>
                            Оценка: <strong><%= bestGrade.getValue() %></strong><br>
                            Ученик: <strong><%= bestGradeStudent.getFullName() %></strong><br>
                            Предмет: <strong><%= bestGradeSubject.getName() %></strong>
                        </p>
                    <% } else { %>
                        <p class="text-muted">Пока нет оценок для анализа.</p>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <div class="card mb-4 shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">Все оценки</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Ученик</th>
                                <th>Предмет</th>
                                <th>Оценка</th>
                                <th>Действия</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (grades.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="text-center text-muted">Пока нет оценок.</td>
                            </tr>
                        <% } else { 
                               for (Grade g : grades) {
                                   Student st = null;
                                   try {
                                       st = StudentDAO.getStudentById(g.getStudentId());
                                   } catch (SQLException e) {
                                       // игнорируем
                                   }
                                   Subject sb = SchoolData.findSubjectById(g.getSubjectId());
                        %>
                            <tr>
                                <td><%= g.getId() %></td>
                                <td>
                                    <% if (st != null) { %>
                                        <%= st.getFullName() %> (<%= st.getClassName() %>)
                                    <% } else { %>
                                        (ученик не найден)
                                    <% } %>
                                </td>
                                <td>
                                    <% if (sb != null) { %>
                                        <%= sb.getName() %>
                                    <% } else { %>
                                        (предмет не найден)
                                    <% } %>
                                </td>
                                <td>
                                    <form method="post" action="admin.jsp" class="d-flex align-items-center">
                                        <input type="hidden" name="action" value="updateGrade">
                                        <input type="hidden" name="gradeId" value="<%= g.getId() %>">
                                        <input type="number" name="newValue" min="1" max="5"
                                               class="form-control form-control-sm me-2"
                                               value="<%= g.getValue() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-primary">Изменить</button>
                                    </form>
                                </td>
                                <td>
                                    <form method="post" action="admin.jsp" onsubmit="return confirm('Удалить оценку?');">
                                        <input type="hidden" name="action" value="deleteGrade">
                                        <input type="hidden" name="gradeId" value="<%= g.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Удалить</button>
                                    </form>
                                </td>
                            </tr>
                        <%     } 
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
