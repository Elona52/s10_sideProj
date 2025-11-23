package com.api.config;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;

/**
 * 전역 예외 처리기
 * 모든 컨트롤러에서 발생하는 예외를 처리합니다.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 인증 예외 처리
     */
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<Map<String, Object>> handleAuthenticationException(AuthenticationException e) {
        log.error("인증 예외 발생: {}", e.getMessage(), e);
        Map<String, Object> response = new HashMap<>();
        response.put("error", "인증이 필요합니다.");
        response.put("message", e.getMessage());
        response.put("status", HttpStatus.UNAUTHORIZED.value());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
    }

    /**
     * 권한 예외 처리
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAccessDeniedException(AccessDeniedException e) {
        log.error("접근 거부 예외 발생: {}", e.getMessage(), e);
        Map<String, Object> response = new HashMap<>();
        response.put("error", "접근 권한이 없습니다.");
        response.put("message", e.getMessage());
        response.put("status", HttpStatus.FORBIDDEN.value());
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }

    /**
     * 404 예외 처리
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNoHandlerFoundException(NoHandlerFoundException e) {
        log.warn("요청한 경로를 찾을 수 없음: {}", e.getRequestURL());
        Map<String, Object> response = new HashMap<>();
        response.put("error", "요청한 경로를 찾을 수 없습니다.");
        response.put("path", e.getRequestURL());
        response.put("status", HttpStatus.NOT_FOUND.value());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    /**
     * 일반 예외 처리
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleException(Exception e) {
        log.error("예외 발생: {}", e.getMessage(), e);
        Map<String, Object> response = new HashMap<>();
        response.put("error", "서버 오류가 발생했습니다.");
        response.put("message", e.getMessage());
        response.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
        
        // 프로덕션 환경이 아닐 때만 스택 트레이스 포함
        String activeProfile = System.getProperty("spring.profiles.active", "");
        if (!activeProfile.contains("prod")) {
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            e.printStackTrace(pw);
            response.put("stackTrace", sw.toString());
        }
        
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}

