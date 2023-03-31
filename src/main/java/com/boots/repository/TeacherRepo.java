package com.boots.repository;

import com.boots.entity.Teacher;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface TeacherRepo extends CrudRepository<Teacher, Long> {
    List<Teacher> findAll();

    Teacher findTeacherById(Long id);


}
