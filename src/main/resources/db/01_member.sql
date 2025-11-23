-- =====================================================
-- 회원 관련 테이블
-- =====================================================

-- 회원 테이블
-- PostgreSQL 호환
CREATE TABLE IF NOT EXISTS KNMember (
    id VARCHAR(50) PRIMARY KEY,
    pass VARCHAR(500),
    name VARCHAR(50),
    phone VARCHAR(20),
    mail VARCHAR(100),
    zipcode INT,
    address1 VARCHAR(200),
    address2 VARCHAR(200),
    marketing VARCHAR(10),
    joindate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modificationdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type VARCHAR(20)
);

