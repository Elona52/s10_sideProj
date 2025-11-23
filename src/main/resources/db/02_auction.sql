-- =====================================================
-- 경매 관련 테이블
-- =====================================================

-- 경매 테이블
-- PostgreSQL 호환: AUTO_INCREMENT → SERIAL, TINYINT → BOOLEAN
CREATE TABLE IF NOT EXISTS KNAuction (
    no SERIAL PRIMARY KEY,
    id VARCHAR(50),
    name VARCHAR(200),
    content TEXT,
    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    startdate DATE,
    enddate DATE,
    startprice INT,
    endprice INT,
    img VARCHAR(500),
    buyer VARCHAR(50),
    count INT DEFAULT 0,
    bidder JSON,
    deposit_status BOOLEAN DEFAULT false,
    deposit_date DATE,
    delivery_status BOOLEAN DEFAULT false,
    delivery_date DATE,
    remit_status BOOLEAN DEFAULT false,
    remit_date DATE,
    
    -- 외래키: 판매자는 반드시 회원이어야 함
    FOREIGN KEY (id) REFERENCES KNMember(id) ON DELETE CASCADE,
    -- 외래키: 낙찰자도 회원이어야 함 (NULL 허용: 아직 낙찰되지 않은 경우)
    FOREIGN KEY (buyer) REFERENCES KNMember(id) ON DELETE SET NULL
);

