package com.boots.service;

import com.boots.entity.Party;
import com.boots.repository.PartyRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PartyService {
    @Autowired
    private PartyRepo partyRepo;

    public List<Party> findAll() {
        return partyRepo.findAll();
    }

    public Party findPartyById(Long id) {
        return partyRepo.findPartyById(id);
    }

    public Party save(Party party) {
        return partyRepo.save(party);
    }

    public void update(Long id, String name, String course) {
        Party party = partyRepo.findPartyById(id);
        party.setName(name);
        party.setCourse(course);
        partyRepo.save(party);
    }

    public void delete(Long id) {
        partyRepo.delete(findPartyById(id));
    }

    public List<Party> findAllByNameLikeOrderByName(String name) {
        return partyRepo.findAllByNameLikeOrderByName(name);
    }

}
