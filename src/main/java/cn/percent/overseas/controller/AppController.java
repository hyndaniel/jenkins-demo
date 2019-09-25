package cn.percent.overseas.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * AppController
 *
 * @author shuanghu
 * @date 2019-09-25
 */
@RestController
@RequestMapping("")
public class AppController {
    @GetMapping("/info")
    public String initAcm() {
        return "This is a test.";
    }
}
