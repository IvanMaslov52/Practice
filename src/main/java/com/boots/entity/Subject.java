package com.boots.entity;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.HashSet;
import java.util.Set;

@AllArgsConstructor
@Entity
public class Subject {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "group_id")
    @NotNull
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Party party;
    @Column(unique = true, nullable = false)
    @Size(min = 2)
    private String name;
    @Column
    @NotNull
    @Min(10)
    @Max(250)
    private Long studyingtime;


    //@ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.REMOVE})
    //@JoinTable(name = "teacher_subjects",
    //        joinColumns = {@JoinColumn(name = "subjects_id")},
    //        inverseJoinColumns = {@JoinColumn(name = "teacher_id")})
    //@OnDelete(action = OnDeleteAction.CASCADE)
    //private Set<Teacher> teachers = new HashSet<>();

    //public Set<Teacher> getTeachers() {
    //    return teachers;
    //}
//
    //public void setTeachers(Set<Teacher> teachers) {
    //    this.teachers = teachers;
    //}

    public Subject(Party party, String name, Long studyingtime) {
        this.party = party;
        this.name = name;
        this.studyingtime = studyingtime;
    }

    public Subject() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Party getParty() {
        return party;
    }

    public void setParty(Party party) {
        this.party = party;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getStudyingtime() {
        return studyingtime;
    }

    public void setStudyingtime(Long studyingtime) {
        this.studyingtime = studyingtime;
    }

    //@Override
    //public String toString() {
    //    try {
    //        return new ObjectMapper().writeValueAsString(this);
    //    } catch (Exception e) {
    //        return "";
    //    }
    //}

    @Override
    public String toString() {
        return "{" +
                "\"id\":" + id +
                ", \"party\":" + party +
                ", \"name\":\"" + name + '\"' +
                ", \"studyingtime\":" + studyingtime +
                '}';
    }
}
