<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.schoolgrades.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String error = null;

    String action = request.getParameter("action");
    if ("addGrade".equals(action)) {
        try {
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
                } else if (SchoolData.findStudentById(studentId) == null) {
                    error = "Ученик с таким ID не найден.";
                } else if (SchoolData.findSubjectById(subjectId) == null) {
                    error = "Предмет с таким ID не найден.";
                } else {
                    SchoolData.addGrade(studentId, subjectId, gradeValue);
                    message = "Оценка успешно добавлена.";
                }
            }
        } catch (NumberFormatException ex) {
            error = "Ошибка преобразования числа. Проверьте введённые данные.";
        } catch (Exception ex) {
            error = "Внутренняя ошибка: " + ex.getMessage();
        }
    }

    List<Student> students = SchoolData.getStudents();
    List<Subject> subjects = SchoolData.getSubjects();
    List<Grade> grades = SchoolData.getGrades();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Оценки</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6fb; }
        .navbar {
            background: #34495e;
            color: #ecf0f1;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .navbar .title { font-size: 18px; font-weight: bold; }
        .navbar a { color: #ecf0f1; text-decoration: none; margin-left: 15px; }
        .navbar a:hover { text-decoration: underline; }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        h1 { margin-top: 0; color: #2c3e50; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .success { background: #e0ffe0; border: 1px solid #00aa00; }
        .error { background: #ffe0e0; border: 1px solid #cc0000; }
        label { display: inline-block; width: 150px; margin-bottom: 5px; }
        select, input[type="number"] { width: 260px; padding: 5px; margin-bottom: 10px; }
        input[type="submit"] {
            padding: 6px 15px; background: #3498db; color: #fff;
            border: none; border-radius: 4px; cursor: pointer;
        }
        input[type="submit"]:hover { background: #2980b9; }
        table { border-collapse: collapse; width: 100%; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 5px; text-align: left; }
        th { background: #f0f0f0; }
    </style>
</head>
<body>
<div class="navbar">
    <div class="title">Система учёта школьных предметов</div>
    <div class="menu">
        <a href="index.jsp">Главная</a>
        <a href="students.jsp">Ученики</a>
        <a href="subjects.jsp">Предметы</a>
        <a href="grades.jsp">Оценки</a>
        <a href="admin.jsp">Панель админа</a>
    </div>
</div>

<div class="container">
    <h1>Оценки</h1>

    <% if (message != null) { %>
        <div class="message success"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="message error"><%= error %></div>
    <% } %>

    <h3>Выставить оценку</h3>
    <form method="post" action="grades.jsp">
        <input type="hidden" name="action" value="addGrade" />

        <label for="studentId">Ученик:</label>
        <select id="studentId" name="studentId">
            <% for (Student s : students) { %>
                <option value="<%= s.getId() %>">
                    <%= s.getId() %> - <%= s.getFullName() %> (<%= s.getClassName() %>)
                </option>
            <% } %>
        </select><br />

        <label for="subjectId">Предмет:</label>
        <select id="subjectId" name="subjectId">
            <% for (Subject sub : subjects) { %>
                <option value="<%= sub.getId() %>">
                    <%= sub.getId() %> - <%= sub.getName() %>
                </option>
            <% } %>
        </select><br />

        <label for="gradeValue">Оценка (1–5):</label>
        <input type="number" id="gradeValue" name="gradeValue" min="1" max="5" /><br />

        <input type="submit" value="Сохранить" />
    </form>

    <h3>Все оценки</h3>
    <table>
        <tr>
            <th>ID оценки</th>
            <th>Ученик</th>
            <th>Предмет</th>
            <th>Оценка</th>
        </tr>
        <% for (Grade g : grades) {
               Student st = SchoolData.findStudentById(g.getStudentId());
               Subject sb = SchoolData.findSubjectById(g.getSubjectId());
        %>
            <tr>
                <td><%= g.getId() %></td>
                <td>
                    <% if (st != null) { %>
                        <%= st.getFullName() %> (<%= st.getClassName() %>)
                    <% } else { %>
                        -
                    <% } %>
                </td>
                <td>
                    <% if (sb != null) { %>
                        <%= sb.getName() %>
                    <% } else { %>
                        -
                    <% } %>
                </td>
                <td><%= g.getValue() %></td>
            </tr>
        <% } %>
    </table>
</div>
</body>
</html>
