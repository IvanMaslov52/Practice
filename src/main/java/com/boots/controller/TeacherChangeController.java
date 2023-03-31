package com.boots.controller;

import com.boots.constant.StringConstant;
import com.boots.entity.Subject;
import com.boots.entity.Teacher;
import com.boots.service.SubjectService;
import com.boots.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Controller
public class TeacherChangeController {
    @Autowired
    private TeacherService teacherService;
    @Autowired
    private SubjectService subjectService;

    @GetMapping(StringConstant.SLCHANGETEACHER)
    public String getTeacher(@PathVariable("id") Long id, Model model) {
        model.addAttribute("subjectList", teacherService.listWithoutSubject(teacherService.findTeacherById(id).getSubjects(), subjectService.findAll()));
        model.addAttribute("id", id);
        return StringConstant.CHANGETEACHER;
    }

    //@PostMapping(StringConstant.SLCHANGETEACHER)
    //    public String changeTeacher(@PathVariable("id")Long id, Model model,@ModelAttribute("TeacherForm")@Valid Teacher teacher, BindingResult bindingResult)
    //{
//
//
    //    if(bindingResult.hasErrors())
    //    {
    //        model.addAttribute("SubjectList",teacherService.listWithoutSubject(teacherService.findTeacherById(id).getSubjects(),subjectService.findAll()));
    //        return StringConstant.CHANGETEACHER;
    //    }
    //    teacherService.save(teacher);
    //    return StringConstant.REDTEACHER;
//
//
    //}
    @GetMapping("/change_teacher/{id}")
    public ResponseEntity<Teacher> getStudentById(@PathVariable("id") Long id) {
        return new ResponseEntity<>(teacherService.findTeacherById(id), HttpStatus.OK);
    }

    @PostMapping("/addchange_teacher/{id}")
    public ResponseEntity<String> changeStudent(@RequestBody Teacher teacher) {
        try {
            //System.out.println(teacher);
            teacherService.save(teacher);
            return new ResponseEntity<>("", HttpStatus.OK);
        } catch (Exception e) {

            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
