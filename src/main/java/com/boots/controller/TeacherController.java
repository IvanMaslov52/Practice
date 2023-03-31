package com.boots.controller;


import com.boots.constant.StringConstant;
import com.boots.entity.Party;
import com.boots.entity.Student;
import com.boots.entity.Teacher;
import com.boots.entity.User;
import com.boots.repository.PartyRepo;
import com.boots.service.PartyService;
import com.boots.service.SubjectService;
import com.boots.service.TeacherService;
import org.hibernate.tool.schema.internal.exec.ScriptTargetOutputToFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@PreAuthorize("hasAnyAuthority('ADMIN')")
public class TeacherController {
    @Autowired
    private TeacherService teacherService;
    @Autowired
    private SubjectService subjectService;
    @Autowired
    private PartyRepo partyRepo;

    @GetMapping(StringConstant.SLTEACHER)

    public String teacher(Model model) {
        model.addAttribute("teacher", teacherService.findAll());
        model.addAttribute("subjectList", subjectService.findAll());
        return StringConstant.TEACHER;
    }

    @GetMapping("/getAllTeacher")
    public ResponseEntity<List<Teacher>> getTeacher() {
        return new ResponseEntity<List<Teacher>>(teacherService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/getOneTeacher/{id}")
    public ResponseEntity<Teacher> getOneTeacher(@PathVariable("id") Long id) {
        return new ResponseEntity<>(teacherService.findTeacherById(id), HttpStatus.OK);
    }

    @PostMapping(value = "/addTeacher")
    public ResponseEntity<Teacher> addTeacher(@RequestBody Teacher teacher) {
        try {
            teacherService.save(teacher);
            return new ResponseEntity<>(teacherService.save(teacher), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping(StringConstant.SLDELETETEACHER)
    public String getTeacher(@PathVariable("id") Long id) {
        teacherService.delete(id);
        return StringConstant.REDTEACHER;
    }


}
