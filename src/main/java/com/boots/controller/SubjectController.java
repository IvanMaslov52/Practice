package com.boots.controller;

import com.boots.constant.StringConstant;
import com.boots.entity.Party;
import com.boots.entity.Student;
import com.boots.entity.Subject;
import com.boots.service.PartyService;
import com.boots.service.SubjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Controller
public class SubjectController {
    @Autowired
    private PartyService partyService;
    @Autowired
    private SubjectService subjectService;

    @GetMapping(StringConstant.SLSUBJECT)
    @PreAuthorize("hasAnyAuthority('ADMIN')")
    public String subjects(Model model) {
        model.addAttribute("subject", subjectService.findAll());
        return StringConstant.SUBJECT;
    }

    @PostMapping("/addSubject")
    public ResponseEntity<Subject> addSubject(@RequestBody Subject subject) {
        try {

            subjectService.save(subject);
            return new ResponseEntity<>(subjectService.save(subject), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/getAllSubject")
    public ResponseEntity<List<Subject>> getStudent() {
        return new ResponseEntity<>(subjectService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/getOneSubject/{id}")
    public ResponseEntity<Subject> getOneParty(@PathVariable("id") Long id) {
        return new ResponseEntity<>(subjectService.findSubjectsById(id), HttpStatus.OK);
    }

    @GetMapping("/subjectFind/{name}")
    public ResponseEntity<List<Subject>> findSubject(@PathVariable("name") String name) {
        return new ResponseEntity<>(subjectService.findAllByNameContainingOrderByName(name), HttpStatus.OK);
    }

    @GetMapping(StringConstant.SLDELETESUBJECT)
    public String getSubject(@PathVariable("id") Long id) {
        subjectService.delete(id);
        return StringConstant.REDSUBJECT;
    }


}
