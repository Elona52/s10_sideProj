-- =====================================================
-- 게시판 관련 테이블
-- =====================================================

-- 게시판 테이블
-- PostgreSQL 호환: AUTO_INCREMENT → SERIAL
CREATE TABLE IF NOT EXISTS KNfind (
    no SERIAL PRIMARY KEY,
    id VARCHAR(50),
    title VARCHAR(200),
    content TEXT,
    category VARCHAR(20) DEFAULT 'other',
    views INT DEFAULT 0,
    related_link VARCHAR(500),
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키: 작성자는 반드시 회원이어야 함
    FOREIGN KEY (id) REFERENCES KNMember(id) ON DELETE CASCADE
);

-- 댓글 테이블
CREATE TABLE IF NOT EXISTS KNReply (
    no SERIAL PRIMARY KEY,
    id VARCHAR(50),
    content TEXT,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    board_no INT,
    
    -- 외래키: 댓글은 게시글에 속함
    FOREIGN KEY (board_no) REFERENCES KNfind(no) ON DELETE CASCADE,
    -- 외래키: 댓글 작성자는 반드시 회원이어야 함
    FOREIGN KEY (id) REFERENCES KNMember(id) ON DELETE CASCADE
);

