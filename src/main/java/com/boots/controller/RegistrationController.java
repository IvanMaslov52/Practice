package com.boots.controller;

import com.boots.entity.Role;
import com.boots.entity.User;
import com.boots.repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.Map;

@Controller
public class RegistrationController {
    @Autowired
    private UserRepo userRepo;

    @GetMapping("/registration")
    public String show(Model model) {
        model.addAttribute("userForm", new User());
        return "registration";
    }

    @PostMapping("/registration")
    public String addUser(User user, Model model, @RequestParam(name = "role", required = false) String role) {
        try {
            user.setActive(true);
            if (role.equals("ADMIN")) {

                user.setRoles(Collections.singleton(Role.ADMIN));
            } else {
                user.setRoles(Collections.singleton(Role.USER));
            }
            userRepo.save(user);
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("usernameError", "Пользователь с таким именем уже существует");
            return "registration";
        }


    }


}
