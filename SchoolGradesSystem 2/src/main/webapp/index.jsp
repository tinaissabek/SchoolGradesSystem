<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Система учёта школьных предметов</title>
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
                <li class="nav-item"><a class="nav-link" href="admin.jsp">Панель администратора</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="p-5 mb-4 bg-white rounded-3 shadow-sm">
        <h1 class="display-6 mb-3">Система учёта школьных предметов и анализа оценок</h1>
        <p class="lead mb-4">
            Выберите раздел, с которым хотите работать:
        </p>

        <div class="row g-3">
            <div class="col-md-4">
                <a href="students.jsp" class="text-decoration-none">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">Ученики</h5>
                            <p class="card-text flex-grow-1">
                                Добавление и просмотр учеников, работа с базой данных.
                            </p>
                            <button class="btn btn-primary mt-auto">Перейти</button>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="subjects.jsp" class="text-decoration-none">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">Предметы</h5>
                            <p class="card-text flex-grow-1">
                                Управление списком школьных предметов, которые используются при выставлении оценок.
                            </p>
                            <button class="btn btn-primary mt-auto">Перейти</button>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="admin.jsp" class="text-decoration-none">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">Панель администратора</h5>
                            <p class="card-text flex-grow-1">
                                Выставление, изменение и удаление оценок, а также анализ: лучший ученик и лучшая оценка.
                            </p>
                            <button class="btn btn-primary mt-auto">Перейти</button>
                        </div>
                    </div>
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
