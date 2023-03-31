package com.boots.controller;

import com.boots.constant.StringConstant;
import com.boots.entity.Party;
import com.boots.entity.Student;
import com.boots.entity.User;
import com.boots.service.PartyService;
import com.boots.service.StudentService;
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
@PreAuthorize("hasAnyAuthority('USER')")
public class StudentController {
    @Autowired
    private PartyService partyService;
    @Autowired
    private StudentService studentService;

    @GetMapping(StringConstant.SLSTUDENT)
    public String student() {
        return StringConstant.STUDENT;
    }

    @GetMapping("/getAllStudent")
    public ResponseEntity<List<Student>> getStudent() {
        return new ResponseEntity<>(studentService.findAll(), HttpStatus.OK);
    }

    @PostMapping(value = "/addStudent")
    public ResponseEntity<Student> addStudent(@RequestBody Student student) {
        try {
            studentService.save(student);
            return new ResponseEntity<>(studentService.save(student), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/getOneStudent/{id}")
    public ResponseEntity<Student> getOneParty(@PathVariable("id") Long id) {
        return new ResponseEntity<>(studentService.findStudentById(id), HttpStatus.OK);
    }

    @GetMapping(StringConstant.SLDELETESTUDENT)
    public String delete(@PathVariable("id") Long id) {
        studentService.delete(id);
        return StringConstant.REDSTUDENT;
    }
}
