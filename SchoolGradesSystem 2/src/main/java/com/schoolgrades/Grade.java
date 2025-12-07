package com.schoolgrades;

public class Grade {
    private int id;
    private int studentId;
    private int subjectId;
    private int value; // оценка (1..5)

    public Grade(int id, int studentId, int subjectId, int value) {
        this.id = id;
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.value = value;
    }

    public int getId() {
        return id;
    }

    public int getStudentId() {
        return studentId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}