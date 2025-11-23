-- =====================================================
-- 즐겨찾기 / 가격 알림 관련 테이블
-- =====================================================

-- 즐겨찾기 테이블 (User_Favorite)
-- PostgreSQL 호환: AUTO_INCREMENT → BIGSERIAL
CREATE TABLE IF NOT EXISTS User_Favorite (
    favorite_id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    item_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE (user_id, item_id),
    FOREIGN KEY (user_id) REFERENCES KNMember(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES KNKamcoItem(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_id ON User_Favorite(user_id);
CREATE INDEX IF NOT EXISTS idx_item_id ON User_Favorite(item_id);

-- 가격 알림 히스토리 테이블
CREATE TABLE IF NOT EXISTS KNPriceAlert (
    id BIGSERIAL PRIMARY KEY,
    favorite_id BIGINT NOT NULL,
    member_id VARCHAR(50) NOT NULL,
    item_plnm_no VARCHAR(100) NOT NULL,
    previous_price BIGINT,
    new_price BIGINT,
    alert_sent BOOLEAN DEFAULT false,
    sent_date TIMESTAMP,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (favorite_id) REFERENCES User_Favorite(favorite_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES KNMember(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_favorite_id ON KNPriceAlert(favorite_id);
CREATE INDEX IF NOT EXISTS idx_member_id ON KNPriceAlert(member_id);
CREATE INDEX IF NOT EXISTS idx_created_date ON KNPriceAlert(created_date);

