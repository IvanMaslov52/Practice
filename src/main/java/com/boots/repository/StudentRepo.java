package com.boots.repository;

import com.boots.entity.Party;
import com.boots.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface StudentRepo extends JpaRepository<Student,Long> {
    List<Student> findAll();
    List<Student> findAllByParty(Party party);
    Student findStudentById(Long id);
    Student findStudentBySticket(String sticket);




}
