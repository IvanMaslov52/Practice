package com.boots.controller;

import com.boots.constant.StringConstant;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
    @GetMapping("/")
    public String get() {
        return StringConstant.MAIN;
    }

}
