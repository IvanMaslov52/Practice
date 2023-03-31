package com.boots.configuration;

import com.boots.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;

@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = false)
@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private UserService userService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
                .authorizeRequests()
                .antMatchers("/", "/registration")
                .permitAll()
                .antMatchers("/Party", "/Student")
                .hasAnyAuthority("USER")
                .antMatchers("/Subject", "/Teacher")
                .hasAnyAuthority("ADMIN")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login")
                .permitAll()
                .defaultSuccessUrl("/")//глобальная константа!
                .and()
                .logout()
                .permitAll()
                .and()
                .exceptionHandling()
                .accessDeniedPage("/error");
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userService)
                .passwordEncoder(NoOpPasswordEncoder.getInstance());
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/resources/js/datepicker-ru.js","https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.11.1/jquery.validate.js", "https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js", "//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css", "https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js", "/resources/js/language.js", "//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css", "https://mdbootstrap.com/docs/b4/jquery/forms/date-picker/", "/src/main/webapp/resources/image/switch.png", "/resources/js/jquery.multi-select.js", "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css", "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css", "https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js", "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css", "https://cdn.datatables.net/v/dt/dt-1.13.2/datatables.min.css", "/resources/image/plus.png", "/resources/image/recycle.png", "/resources/image/disc.png", "/resources/image/back.png", "/resources/image/git.png", "/resources/css/style.css", "https://code.jquery.com/jquery-3.6.0.js", "https://code.jquery.com/ui/1.13.2/jquery-ui.js", "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.11.1/jquery.validate.js", "https://cdn.datatables.net/v/dt/dt-1.13.2/datatables.min.js", "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css", "/**/*.css");
    }
}
