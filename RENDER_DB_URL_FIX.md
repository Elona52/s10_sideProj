# 렌더 데이터베이스 연결 URL 수정 가이드

## ❌ 현재 문제

에러: `java.net.UnknownHostException: dpg-d4gq7i4hg0os73803cmg-a`

원인: Internal Database URL의 호스트명이 잘못되었거나 포트가 누락되었습니다.

---

## ✅ 해결 방법

### 1단계: 렌더 대시보드에서 정확한 Internal Database URL 확인

1. **렌더 대시보드** → **PostgreSQL 데이터베이스** 클릭
2. **"Connections"** 탭 클릭
3. **"Internal Database URL"** 섹션에서 **전체 URL 확인**

### 2단계: Internal Database URL 형식 확인

렌더 PostgreSQL Internal Database URL은 다음 형식 중 하나입니다:

#### 형식 1 (포트 포함):
```
postgresql://user:password@dpg-xxx-xxx-xxx.oregon-postgres.render.com:5432/dbname
```

#### 형식 2 (포트 생략, 기본값 5432):
```
postgresql://user:password@dpg-xxx-xxx-xxx.oregon-postgres.render.com/dbname
```

#### 형식 3 (짧은 형식):
```
postgresql://user:password@dpg-xxx-xxx-xxx.render.com/dbname
```

**중요:** 호스트명에는 **`.render.com`** 또는 **`.oregon-postgres.render.com`** 같은 도메인이 포함되어야 합니다!

---

### 3단계: JDBC URL로 변환

Internal Database URL이 다음과 같다면:
```
postgresql://product_yw3f_user:OoksWSaoei9leNC02nlm3Na6sBbjSAQj@dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

JDBC URL은:
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

**변환 방법:**
1. `postgresql://` → `jdbc:postgresql://`로 변경
2. 사용자명:비밀번호@ 부분은 제거 (별도 환경 변수로 설정)
3. 호스트:포트/데이터베이스명 부분만 사용

---

## 📋 환경 변수 설정 (정확한 값)

렌더 대시보드 → "side-proj" → "Environment" 탭에서:

### 현재 설정이 잘못되었을 수 있습니다. 다음을 확인하세요:

#### 1. Internal Database URL 다시 확인
- PostgreSQL 페이지 → Connections 탭
- Internal Database URL **전체를 다시 복사**하세요
- 호스트명에 `.render.com` 또는 `.oregon-postgres.render.com`가 포함되어 있는지 확인

#### 2. 환경 변수 수정

**SPRING_DATASOURCE_URL:**
- Internal Database URL에서 호스트명과 포트, 데이터베이스명만 추출
- 형식: `jdbc:postgresql://[호스트명]:[포트]/[데이터베이스명]`

**예시:**
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

또는 포트가 없다면 (기본값 5432):
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com/product_yw3f
```

**나머지 환경 변수:**
```
SPRING_DATASOURCE_USERNAME = product_yw3f_user
SPRING_DATASOURCE_PASSWORD = OoksWSaoei9leNC02nlm3Na6sBbjSAQj
SPRING_DATASOURCE_DRIVER = org.postgresql.Driver
SPRING_PROFILES_ACTIVE = prod
```

---

## 🔍 확인 사항

### Internal Database URL에 다음이 포함되어 있나요?

- [ ] 호스트명 끝에 `.render.com` 또는 `.oregon-postgres.render.com` 포함
- [ ] 포트 번호 (보통 `:5432`)
- [ ] 사용자명과 비밀번호 (`:` 앞에 사용자명, `@` 앞에 비밀번호)
- [ ] 데이터베이스명 (마지막 `/` 뒤)

### 현재 설정된 SPRING_DATASOURCE_URL 확인:

렌더 대시보드 → Environment 탭에서 `SPRING_DATASOURCE_URL` 값 확인:
- 호스트명이 `.render.com`으로 끝나는지 확인
- 포트 번호가 포함되어 있는지 확인

---

## 💡 빠른 수정 방법

1. **PostgreSQL 페이지** → **Connections 탭**
2. **Internal Database URL 전체 복사**
3. **다음 형식인지 확인:**
   ```
   postgresql://[사용자명]:[비밀번호]@[호스트명.render.com]:[포트]/[데이터베이스명]
   ```
4. **호스트명이 `.render.com`으로 끝나지 않으면 오류입니다!**
5. **JDBC URL 형식으로 변환:**
   ```
   jdbc:postgresql://[호스트명.render.com]:[포트]/[데이터베이스명]
   ```
6. **환경 변수 `SPRING_DATASOURCE_URL` 수정**
7. **"Save Changes" 클릭 → 재배포**


