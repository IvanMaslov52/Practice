package com.boots.service;


import com.boots.entity.Party;
import com.boots.entity.Student;
import com.boots.repository.PartyRepo;
import com.boots.repository.StudentRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentService {
    @Autowired
    private StudentRepo studentRepo;
    @Autowired
    private PartyRepo partyRepo;

    public List<Student> findAll() {
        return studentRepo.findAll();
    }

    public List<Student> findAllByParty(Party party) {
        return studentRepo.findAllByParty(party);
    }

    public Student findStudentById(Long id) {
        return studentRepo.findStudentById(id);
    }

    public Student save(Student student) {
        return studentRepo.save(student);
    }

    public void update(Long id, Long partyid, String fio, Long sticket, String bornDate) {
        Student student = studentRepo.findStudentById(id);
        student.setParty(partyRepo.findPartyById(partyid));
        student.setFio(fio);
        student.setSticket(sticket);
        student.setBornDate(bornDate);
        studentRepo.save(student);
    }

    public List<Party> listWithoutParty(List<Party> list, String party) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getName().equals(party))
                list.remove(i);
        }
        return list;
    }

    public void delete(Long id) {
        studentRepo.delete(findStudentById(id));
    }


}
