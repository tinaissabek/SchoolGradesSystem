package com.schoolgrades;

import java.util.ArrayList;
import java.util.List;

public class SchoolData {

    private static List<Student> students = new ArrayList<>();
    private static List<Subject> subjects = new ArrayList<>();
    private static List<Grade> grades = new ArrayList<>();

    private static int studentIdSeq = 1;
    private static int subjectIdSeq = 1;
    private static int gradeIdSeq = 1;


    public static synchronized Student addStudent(String fullName, String className) {
        Student s = new Student(studentIdSeq++, fullName, className);
        students.add(s);
        return s;
    }

    public static synchronized Subject addSubject(String name) {
        Subject sub = new Subject(subjectIdSeq++, name);
        subjects.add(sub);
        return sub;
    }

    public static synchronized Grade addGrade(int studentId, int subjectId, int value) {
        Grade g = new Grade(gradeIdSeq++, studentId, subjectId, value);
        grades.add(g);
        return g;
    }


    public static List<Student> getStudents() {
        return students;
    }

    public static List<Subject> getSubjects() {
        return subjects;
    }

    public static List<Grade> getGrades() {
        return grades;
    }

    // Поиск по id

    public static Student findStudentById(int id) {
        for (Student s : students) {
            if (s.getId() == id) {
                return s;
            }
        }
        return null;
    }

    public static Subject findSubjectById(int id) {
        for (Subject sub : subjects) {
            if (sub.getId() == id) {
                return sub;
            }
        }
        return null;
    }

 // Обновление оценки по ID
    public static synchronized void updateGrade(int gradeId, int newValue) {
        for (Grade g : grades) {
            if (g.getId() == gradeId) {
                g.setValue(newValue);
                break;
            }
        }
    }

    // Удаление оценки по ID
    public static synchronized void deleteGrade(int gradeId) {
        java.util.Iterator<Grade> it = grades.iterator();
        while (it.hasNext()) {
            Grade g = it.next();
            if (g.getId() == gradeId) {
                it.remove();
                break;
            }
        }
    }

    // Анализ: средний балл по ученику

    public static double getAverageForStudent(int studentId) {
        int sum = 0;
        int count = 0;
        for (Grade g : grades) {
            if (g.getStudentId() == studentId) {
                sum += g.getValue();
                count++;
            }
        }
        if (count == 0) {
            return 0.0;
        }
        return (double) sum / count;
    }

    // Анализ: средний балл по предмету

    public static double getAverageForSubject(int subjectId) {
        int sum = 0;
        int count = 0;
        for (Grade g : grades) {
            if (g.getSubjectId() == subjectId) {
                sum += g.getValue();
                count++;
            }
        }
        if (count == 0) {
            return 0.0;
        }
        return (double) sum / count;
    }

    // Методы для панели администратора

    public static int getStudentCount() {
        return students.size();
    }

    public static int getSubjectCount() {
        return subjects.size();
    }

    public static int getGradeCount() {
        return grades.size();
    }

    // Лучший ученик по среднему баллу
    public static Student getTopStudent() {
        Student best = null;
        double bestAvg = 0.0;

        for (Student s : students) {
            double avg = getAverageForStudent(s.getId());
            if (avg > 0.0 && avg > bestAvg) {
                bestAvg = avg;
                best = s;
            }
        }
        return best;
    }

    // Лучший предмет по среднему баллу 
    public static Subject getTopSubject() {
        Subject best = null;
        double bestAvg = 0.0;

        for (Subject sub : subjects) {
            double avg = getAverageForSubject(sub.getId());
            if (avg > 0.0 && avg > bestAvg) {
                bestAvg = avg;
                best = sub;
            }
        }
        return best;
    }

    public static double getAverageForTopStudent() {
        Student s = getTopStudent();
        if (s == null) return 0.0;
        return getAverageForStudent(s.getId());
    }

    public static double getAverageForTopSubject() {
        Subject sub = getTopSubject();
        if (sub == null) return 0.0;
        return getAverageForSubject(sub.getId());
    }
}
