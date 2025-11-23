-- =====================================================
-- 캠코 온비드 공매 물건 관련 테이블들
-- =====================================================

-- 캠코 온비드 공매 물건 테이블 (온비드 API 데이터 저장)
-- PostgreSQL 호환: AUTO_INCREMENT → BIGSERIAL
CREATE TABLE IF NOT EXISTS KNKamcoItem (
    id BIGSERIAL PRIMARY KEY,
    
    -- 기본 식별 정보
    rnum INT COMMENT '순번 (admin-panel에서 사용)',
    plnm_no VARCHAR(100) COMMENT '공고번호',
    pbct_no VARCHAR(100) COMMENT '공매번호',
    org_base_no VARCHAR(100) COMMENT '기관기준번호 (API 원본 데이터 보존용, 응답에서는 제외)',
    org_nm VARCHAR(150) COMMENT '기관명',
    cltr_no VARCHAR(100) NOT NULL UNIQUE COMMENT '물건번호 (고유키)',
    pbct_cdtn_no VARCHAR(100) COMMENT '공매조건번호 (API 원본 데이터 보존용, 응답에서는 제외)',
    cltr_mnmt_no VARCHAR(100) COMMENT '물건관리번호',
    cltr_hstr_no VARCHAR(100) COMMENT '물건이력번호 (API 원본 데이터 보존용, 응답에서는 제외)',
    bid_mnmt_no VARCHAR(100) COMMENT '입찰관리번호',
    
    -- 분류 정보
    scrn_grp_cd VARCHAR(50) COMMENT '화면그룹코드 (NewItemNotificationService에서 사용)',
    ctgr_id VARCHAR(50) COMMENT '카테고리ID (API 원본 데이터 보존용, 응답에서는 제외, ctgr_full_nm 사용)',
    ctgr_full_nm VARCHAR(500) COMMENT '카테고리 전체명',
    
    -- 물건 정보
    cltr_nm VARCHAR(500) COMMENT '물건명',
    goods_nm TEXT COMMENT '물건내역',
    manf VARCHAR(200) COMMENT '제조사 (API 원본 데이터 보존용, 응답에서는 제외)',
    
    -- 주소 정보
    ldnm_adrs VARCHAR(500) COMMENT '지번주소',
    nmrd_adrs VARCHAR(500) COMMENT '도로명주소',
    rod_nm VARCHAR(120) COMMENT '도로명 (admin-panel에서 사용)',
    bld_no VARCHAR(60) COMMENT '건물번호 (admin-panel에서 사용)',
    sido VARCHAR(50) COMMENT '시도 (검색용)',
    
    -- 처분/입찰 방식
    dpsl_mtd_cd VARCHAR(20) COMMENT '처분방식코드 (API 원본 데이터 보존용, 응답에서는 제외, dpsl_mtd_nm 사용)',
    dpsl_mtd_nm VARCHAR(100) COMMENT '처분방식명',
    bid_mtd_nm VARCHAR(200) COMMENT '입찰방식명',
    
    -- 가격 정보
    min_bid_prc BIGINT COMMENT '최저입찰가',
    apsl_ases_avg_amt BIGINT COMMENT '감정평가액 평균',
    fee_rate VARCHAR(50) COMMENT '수수료율',
    
    -- 입찰 일정
    pbct_begn_dtm VARCHAR(20) COMMENT '입찰시작일시',
    pbct_cls_dtm VARCHAR(20) COMMENT '입찰종료일시',
    
    -- 상태 정보
    pbct_cltr_stat_nm VARCHAR(100) COMMENT '입찰상태명',
    uscb_cnt INT DEFAULT 0 COMMENT '유찰횟수',
    iqry_cnt INT DEFAULT 0 COMMENT 'API 조회수',
    
    -- 통계 정보 (자체 관리)
    view_count INT DEFAULT 0 COMMENT '조회수 (자체 카운트)',
    interest_count INT DEFAULT 0 COMMENT '관심수 (즐겨찾기 수)',
    
    -- API 데이터 동기화 정보
    -- PostgreSQL 호환: TINYINT(1) → BOOLEAN
    is_new BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    api_sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 관리 일시
    -- PostgreSQL 호환: ON UPDATE CURRENT_TIMESTAMP 제거 (트리거 필요하지만 일단 제거)
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PostgreSQL 호환: 인덱스는 별도로 생성
CREATE INDEX IF NOT EXISTS idx_cltr_no ON KNKamcoItem(cltr_no);
CREATE INDEX IF NOT EXISTS idx_pbct_cls_dtm ON KNKamcoItem(pbct_cls_dtm);
CREATE INDEX IF NOT EXISTS idx_sido ON KNKamcoItem(sido);
CREATE INDEX IF NOT EXISTS idx_is_new ON KNKamcoItem(is_new);
CREATE INDEX IF NOT EXISTS idx_view_count ON KNKamcoItem(view_count);
CREATE INDEX IF NOT EXISTS idx_interest_count ON KNKamcoItem(interest_count);
CREATE INDEX IF NOT EXISTS idx_min_bid_prc ON KNKamcoItem(min_bid_prc);

-- 캠코 온비드 공매 물건 조회 이력 테이블
CREATE TABLE IF NOT EXISTS KNKamcoItemViewLog (
    id BIGSERIAL PRIMARY KEY,
    item_id BIGINT NOT NULL COMMENT '물건 ID',
    cltr_no VARCHAR(100) NOT NULL COMMENT '물건번호',
    member_id VARCHAR(50) COMMENT '회원 ID (비회원은 NULL)',
    ip_address VARCHAR(50) COMMENT 'IP 주소',
    user_agent TEXT COMMENT 'User Agent',
    view_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '조회일시',
    
    FOREIGN KEY (item_id) REFERENCES KNKamcoItem(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_item_id ON KNKamcoItemViewLog(item_id);
CREATE INDEX IF NOT EXISTS idx_view_date ON KNKamcoItemViewLog(view_date);

-- 새로운 물건 공지사항 테이블
CREATE TABLE IF NOT EXISTS KNNewItemNotification (
    id BIGSERIAL PRIMARY KEY,
    item_id BIGINT NOT NULL COMMENT '물건 ID',
    cltr_no VARCHAR(100) NOT NULL COMMENT '물건번호',
    cltr_nm VARCHAR(500) COMMENT '물건명',
    min_bid_prc BIGINT COMMENT '최저입찰가',
    pbct_cls_dtm VARCHAR(20) COMMENT '입찰종료일시',
    notification_type VARCHAR(20) DEFAULT 'NEW',
    is_displayed BOOLEAN DEFAULT true,
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    expired_date TIMESTAMP COMMENT '공지 만료일',
    
    FOREIGN KEY (item_id) REFERENCES KNKamcoItem(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_is_displayed ON KNNewItemNotification(is_displayed);
CREATE INDEX IF NOT EXISTS idx_created_date ON KNNewItemNotification(created_date);
CREATE INDEX IF NOT EXISTS idx_notification_type ON KNNewItemNotification(notification_type);

-- 물건 통계 스냅샷 테이블 (일별/주별 통계용)
CREATE TABLE IF NOT EXISTS KNKamcoItemStats (
    id BIGSERIAL PRIMARY KEY,
    item_id BIGINT NOT NULL COMMENT '물건 ID',
    cltr_no VARCHAR(100) NOT NULL COMMENT '물건번호',
    stat_date DATE NOT NULL COMMENT '통계 날짜',
    view_count INT DEFAULT 0 COMMENT '조회수',
    interest_count INT DEFAULT 0 COMMENT '관심수',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    
    FOREIGN KEY (item_id) REFERENCES KNKamcoItem(id) ON DELETE CASCADE,
    UNIQUE (item_id, stat_date)
);

CREATE INDEX IF NOT EXISTS idx_stat_date ON KNKamcoItemStats(stat_date);

