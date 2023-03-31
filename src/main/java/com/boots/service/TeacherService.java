package com.boots.service;


import com.boots.entity.Subject;
import com.boots.entity.Teacher;
import com.boots.repository.SubjectRepo;
import com.boots.repository.TeacherRepo;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class TeacherService {
    @Autowired
    private SubjectRepo subjectRepo;
    @Autowired
    private TeacherRepo teacherRepo;

    public Set<Subject> parsing(String subjects) {
        Set<Subject> set = new HashSet<>();
        String[] list = subjects.split(" ");
        for (int i = 0; i < list.length; i++) {
            set.add(subjectRepo.findSubjectsById(Long.valueOf(list[i])));
        }
        return set;
    }

    public List<Teacher> findAll() {
        return teacherRepo.findAll();
    }

    public Teacher findTeacherById(Long id) {
        return teacherRepo.findTeacherById(id);
    }

    public Teacher save(Teacher teacher) {
        return teacherRepo.save(teacher);
    }

    public String parseIntoString(Teacher teacher) {
        String str = new String();
        for (Subject subject : teacher.getSubjects()) {
            str += subject.getId();
            str += " ";
        }
        str = str.substring(0, str.length() - 1);
        return str;
    }

    public void update(Long id, String fio, String bornDate, String subjects, String speciality) {
        Teacher teacher = teacherRepo.findTeacherById(id);
        teacher.setFio(fio);
        teacher.setBornDate(bornDate);
        teacher.setSubjects(this.parsing(subjects));
        teacher.setSpeciality(speciality);
        teacherRepo.save(teacher);
    }

    public List<Subject> listWithoutSubject(Set<Subject> set, List<Subject> list) {
        for (Subject subject : set) {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getName().equals(subject.getName()))
                    list.remove(i);
            }
        }
        return list;
    }

    public void delete(Long id) {
        teacherRepo.delete(findTeacherById(id));
    }


}
