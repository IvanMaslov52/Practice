package com.boots.service;


import com.boots.entity.Party;
import com.boots.entity.Subject;
import com.boots.repository.PartyRepo;
import com.boots.repository.SubjectRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SubjectService {
    @Autowired
    private SubjectRepo subjectRepo;
    @Autowired
    private PartyRepo partyRepo;

    public List<Subject> findAll() {
        return subjectRepo.findAll();
    }

    public Subject findSubjectsById(Long id) {
        return subjectRepo.findSubjectsById(id);

    }

    public Subject save(Subject subject) {
        return subjectRepo.save(subject);
    }

    public void update(Long id, Long partyid, String name, Long studyingtime) {
        Subject subject = subjectRepo.findSubjectsById(id);
        subject.setParty(partyRepo.findPartyById(partyid));
        subject.setName(name);
        subject.setStudyingtime(studyingtime);
        subjectRepo.save(subject);
    }

    public List<Party> listWithoutParty(List<Party> list, String party) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getName().equals(party))
                list.remove(i);
        }
        return list;
    }

    public void delete(Long id) {
        subjectRepo.delete(findSubjectsById(id));
    }

    public List<Subject> findAllByNameContainingOrderByName(String name) {
        return subjectRepo.findAllByNameContainingOrderByName(name);
    }


}
