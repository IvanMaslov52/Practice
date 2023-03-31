package com.boots.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.print.DocFlavor;

@Controller
public class ErrorController {
    @GetMapping("/error")
    public String showPage() {
        return "error";
    }
}
