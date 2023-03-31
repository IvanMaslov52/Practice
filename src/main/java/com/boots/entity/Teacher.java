package com.boots.entity;


import lombok.AllArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.HashSet;
import java.util.Set;

@AllArgsConstructor
@Entity
public class Teacher {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column
    @Size(min = 3)
    private String fio;
    @NotNull
    private String bornDate;
    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.REMOVE})
    @JoinTable(name = "teacher_subjects",
            joinColumns = {@JoinColumn(name = "teacher_id")},
            inverseJoinColumns = {@JoinColumn(name = "subjects_id")})
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Set<Subject> subjects = new HashSet<Subject>();
    @Column
    @Size(min = 3)
    private String speciality;

    public Teacher(String fio, String bornDate, Set<Subject> subjects, String speciality) {
        this.fio = fio;
        this.bornDate = bornDate;
        this.subjects = subjects;
        this.speciality = speciality;
    }

    public Teacher() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFio() {
        return fio;
    }

    public void setFio(String fio) {
        this.fio = fio;
    }

    public String getBornDate() {
        return bornDate;
    }

    public void setBornDate(String borndate) {
        this.bornDate = borndate;
    }

    public Set<Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(Set<Subject> subjects) {
        this.subjects = subjects;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

    @Override
    public String toString() {
        return "{" +
                "\"id\":" + id +
                ",\" fio\":" + fio + '\"' +
                ", \"borndate\":" + bornDate + '\"' +
                ", \"subjects\":" + subjects +
                ",\" speciality\":" + speciality + '\"' +
                '}';
    }

    public String parseIntoString() {

        String str = new String();
        for (Subject subject : this.getSubjects()) {
            str += subject.getName();
            str += ",";
        }
        if (str.length() == 0) {
            return "";
        }
        str = str.substring(0, str.length() - 1);

        return str;
    }
}
