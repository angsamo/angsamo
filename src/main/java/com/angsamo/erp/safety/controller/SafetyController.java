package com.angsamo.erp.safety.controller;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.safety.domain.WeatherDailyLog;
import com.angsamo.erp.safety.dto.CalendarDay;
import com.angsamo.erp.safety.dto.CctvStatus;
import com.angsamo.erp.safety.service.CctvService;
import com.angsamo.erp.safety.service.SafetyChecklistService;
import com.angsamo.erp.safety.service.WeatherService;

// 접근 제어는 AdminInterceptor(/safety/**)가 담당한다.
@Controller
public class SafetyController {

    private final WeatherService weatherService;
    private final SafetyChecklistService checklistService;
    private final CctvService cctvService;

    public SafetyController(WeatherService weatherService, SafetyChecklistService checklistService,
            CctvService cctvService) {
        this.weatherService = weatherService;
        this.checklistService = checklistService;
        this.cctvService = cctvService;
    }

    @GetMapping("/safety")
    public String dashboard(Model model) {
        model.addAttribute("weather", weatherService.getStatus());
        model.addAttribute("recentViolations", checklistService.getRecentViolations(5));
        model.addAttribute("checklistSummary", checklistService.getDashboardSummary());
        model.addAttribute("cctvStatus", cctvService.getStatus());
        model.addAttribute("recentWeatherLog", weatherService.getRecentDailyLog(7));
        return "safety/dashboard";
    }

    @GetMapping("/safety/weather")
    public String weather(@RequestParam(required = false) String month, Model model) {
        model.addAttribute("weather", weatherService.getStatus());
        model.addAttribute("latitude", weatherService.getLatitude());
        model.addAttribute("longitude", weatherService.getLongitude());

        YearMonth target = parseMonth(month);
        model.addAttribute("calendarMonth", target.format(DateTimeFormatter.ofPattern("yyyy년 M월")));
        model.addAttribute("calendarDays", buildCalendarDays(target));
        model.addAttribute("prevMonth", target.minusMonths(1).toString());
        model.addAttribute("nextMonth", target.plusMonths(1).toString());
        return "safety/weather";
    }

    private YearMonth parseMonth(String month) {
        try {
            return month == null ? YearMonth.now() : YearMonth.parse(month);
        } catch (Exception e) {
            return YearMonth.now();
        }
    }

    private List<CalendarDay> buildCalendarDays(YearMonth month) {
        Map<LocalDate, WeatherDailyLog> logsByDate = new java.util.HashMap<>();
        for (WeatherDailyLog log : weatherService.getMonthlyLog(month)) {
            logsByDate.put(log.getLogDate(), log);
        }

        List<CalendarDay> days = new ArrayList<>();
        int leadingBlanks = month.atDay(1).getDayOfWeek().getValue() % 7; // 일요일=0 시작으로 맞춤
        for (int i = 0; i < leadingBlanks; i++) days.add(CalendarDay.blank());

        LocalDate today = LocalDate.now();
        for (int day = 1; day <= month.lengthOfMonth(); day++) {
            LocalDate date = month.atDay(day);
            WeatherDailyLog log = logsByDate.get(date);
            days.add(new CalendarDay(false, date.toString(), day,
                    log == null ? null : log.getTemperature(),
                    log == null ? null : log.getPrecipitation(),
                    log == null ? null : log.getRiskLevel(),
                    log == null ? "" : log.getRiskCssClass(), date.equals(today),
                    log == null ? null : log.getMaxTemperature(),
                    log == null ? null : log.getMinTemperature(),
                    log == null ? null : log.getSnowfall(),
                    log == null ? null : log.getAlertSummary(),
                    log == null ? null : log.getMemo()));
        }
        return days;
    }

    // 날씨 달력 상세보기: 관리자가 남긴 메모(작업 중지 여부 등) 저장
    @PostMapping("/safety/weather/log/{date}/memo")
    @ResponseBody
    public Map<String, Object> saveDailyMemo(@PathVariable LocalDate date, @RequestParam String memo) {
        weatherService.saveDailyMemo(date, memo);
        return Map.of("success", true);
    }

    @GetMapping("/safety/cctv")
    public String cctv(Model model) {
        model.addAttribute("streamUrl", cctvService.getStreamUrl());
        model.addAttribute("cctvApiBaseUrl", cctvService.getApiBaseUrl());
        return "safety/cctv";
    }

    @PostMapping("/safety/cctv/start")
    public String startCctv(RedirectAttributes redirect) {
        try {
            cctvService.start();
            redirect.addFlashAttribute("success", "CCTV 탐지를 시작했습니다.");
        } catch (IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/cctv";
    }

    @PostMapping("/safety/cctv/stop")
    public String stopCctv(RedirectAttributes redirect) {
        try {
            cctvService.stop();
            redirect.addFlashAttribute("success", "CCTV 탐지를 중지했습니다.");
        } catch (IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/cctv";
    }

    @GetMapping("/safety/cctv/status")
    @ResponseBody
    public CctvStatus cctvStatus() {
        return cctvService.getStatus();
    }
}
