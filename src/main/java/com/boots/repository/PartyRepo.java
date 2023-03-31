package com.boots.repository;

import com.boots.entity.Party;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PartyRepo extends CrudRepository<Party, Long> {
    List<Party> findAll();

    Party findPartyById(Long id);

    @Query(nativeQuery = true, value = "SELECT id,name,course FROM party WHERE party.name  LIKE CONCAT('%',:name,'%')")
    List<Party> findAllByNameLikeOrderByName(@Param("name") String name);


}
