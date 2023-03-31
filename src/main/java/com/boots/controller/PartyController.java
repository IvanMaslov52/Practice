package com.boots.controller;

import com.boots.constant.StringConstant;
import com.boots.entity.Party;
import com.boots.service.PartyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class PartyController {
    @Autowired
    private PartyService partyService;

    @GetMapping(StringConstant.SLPARTY)
    @PreAuthorize("hasAnyAuthority('USER')")
    public String party() {
        return StringConstant.PARTY;
    }

    @PostMapping(value = "/addParty", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Party> addparty(@ModelAttribute Party party) {
        try {
            partyService.save(party);
            return new ResponseEntity<>(partyService.save(party), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/getAllParty")
    public ResponseEntity<List<Party>> getParty() {
        return new ResponseEntity<List<Party>>(partyService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/getOneParty/{id}")
    public ResponseEntity<Party> getOneParty(@PathVariable("id") Long id) {
        return new ResponseEntity<>(partyService.findPartyById(id), HttpStatus.OK);
    }

    @GetMapping("/partyFind/{name}")
    public ResponseEntity<List<Party>> findParty(@PathVariable("name") String name) {
        return new ResponseEntity<>(partyService.findAllByNameLikeOrderByName(name), HttpStatus.OK);
    }

    @GetMapping(StringConstant.SLDELETEPARTY)
    public String delete(@PathVariable("id") Long id) {
        partyService.delete(id);
        return StringConstant.REDPARTY;
    }

}
