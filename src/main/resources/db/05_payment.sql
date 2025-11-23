-- =====================================================
-- 결제 관련 테이블
-- =====================================================

-- 결제 정보 테이블
-- PostgreSQL 호환: AUTO_INCREMENT → BIGSERIAL, ON UPDATE 제거
CREATE TABLE IF NOT EXISTS KNPayment (
    id BIGSERIAL PRIMARY KEY,
    auction_no INT NOT NULL,
    member_id VARCHAR(50) NOT NULL,
    
    -- 아임포트 결제 정보
    imp_uid VARCHAR(100) UNIQUE,
    merchant_uid VARCHAR(100) UNIQUE NOT NULL,
    item_name VARCHAR(500),
    amount BIGINT NOT NULL,
    paid_amount BIGINT,
    payment_method VARCHAR(50),
    pg_provider VARCHAR(50),
    pg_tid VARCHAR(100),
    
    -- 카드 정보
    card_name VARCHAR(50),
    card_number VARCHAR(50),
    
    -- 구매자 정보
    buyer_name VARCHAR(50),
    buyer_email VARCHAR(100),
    buyer_tel VARCHAR(20),
    buyer_addr VARCHAR(200),
    buyer_postcode VARCHAR(10),
    
    -- 결제 상태 및 시간
    status VARCHAR(20) DEFAULT 'ready',
    paid_at TIMESTAMP,
    failed_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    
    -- 실패/취소 사유
    fail_reason TEXT,
    cancel_reason TEXT,
    
    -- 기타
    receipt_url VARCHAR(500),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (auction_no) REFERENCES KNAuction(no) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES KNMember(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_status ON KNPayment(status);
CREATE INDEX IF NOT EXISTS idx_member_id ON KNPayment(member_id);
CREATE INDEX IF NOT EXISTS idx_created_date ON KNPayment(created_date);

-- 결제 히스토리 테이블 (로그 기록용)
CREATE TABLE IF NOT EXISTS KNPaymentHistory (
    id BIGSERIAL PRIMARY KEY,
    payment_id BIGINT NOT NULL,
    status VARCHAR(20),
    action VARCHAR(50),
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (payment_id) REFERENCES KNPayment(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_payment_id ON KNPaymentHistory(payment_id);
CREATE INDEX IF NOT EXISTS idx_created_date ON KNPaymentHistory(created_date);

