# 🔴 즉시 수정 방법

## 문제
호스트명에 도메인이 없어서 연결 실패: `dpg-d4gq7i4hg0os73803cmg-a`

---

## ✅ 해결 방법 (단계별)

### 1단계: 렌더 대시보드에서 Internal Database URL 확인

1. **렌더 대시보드** → **PostgreSQL 데이터베이스** 클릭
2. **"Connections"** 탭 클릭
3. **"Internal Database URL"** 섹션에서 **전체 URL 복사**

**중요:** 호스트명에 **`.render.com`** 또는 **`.oregon-postgres.render.com`** 같은 도메인이 **반드시** 포함되어 있어야 합니다!

---

### 2단계: Internal Database URL 예시

올바른 형식 예시:

```
postgresql://product_yw3f_user:OoksWSaoei9leNC02nlm3Na6sBbjSAQj@dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

또는

```
postgresql://product_yw3f_user:OoksWSaoei9leNC02nlm3Na6sBbjSAQj@dpg-d4gq7i4hg0os73803cmg-a.render.com:5432/product_yw3f
```

**주의:** 
- 호스트명 끝에 **`.oregon-postgres.render.com`** 또는 **`.render.com`** 포함 필수!
- 포트 번호 **`:5432`** 포함 필수!

---

### 3단계: JDBC URL로 변환

Internal Database URL이 다음과 같다면:
```
postgresql://product_yw3f_user:OoksWSaoei9leNC02nlm3Na6sBbjSAQj@dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

**JDBC URL (환경 변수에 설정할 값):**
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

**변환 방법:**
1. `postgresql://` → `jdbc:postgresql://`로 변경
2. `user:password@` 부분 제거 (별도 환경 변수로 설정)
3. 나머지 `호스트명:포트/데이터베이스명` 부분만 사용

---

### 4단계: 환경 변수 수정

**렌더 대시보드** → **"side-proj"** 웹 서비스 → **"Environment"** 탭

#### 환경 변수 수정:

**SPRING_DATASOURCE_URL 수정:**
```
Key: SPRING_DATASOURCE_URL
Value: jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

**⚠️ 중요:** 
- 호스트명 끝에 **`.oregon-postgres.render.com`** 또는 **`.render.com`** 포함 필수!
- 포트 번호 **`:5432`** 포함 필수!

**다른 환경 변수 확인 (변경 불필요):**
```
SPRING_DATASOURCE_USERNAME = product_yw3f_user
SPRING_DATASOURCE_PASSWORD = OoksWSaoei9leNC02nlm3Na6sBbjSAQj
SPRING_DATASOURCE_DRIVER = org.postgresql.Driver
SPRING_PROFILES_ACTIVE = prod
```

---

### 5단계: 저장 및 재배포

1. **"Save Changes"** 버튼 클릭
2. 자동 재배포 또는 **"Manual Deploy"** 클릭

---

## 🔍 확인 체크리스트

렌더 대시보드에서 확인:

- [ ] PostgreSQL → Connections 탭에서 Internal Database URL 확인
- [ ] 호스트명에 **`.render.com`** 또는 **`.oregon-postgres.render.com`** 포함 확인
- [ ] 포트 번호 **`:5432`** 포함 확인
- [ ] Environment 탭에서 `SPRING_DATASOURCE_URL` 값 수정
- [ ] JDBC URL 형식: `jdbc:postgresql://호스트명.render.com:5432/데이터베이스명`

---

## 💡 빠른 확인 방법

**현재 설정된 SPRING_DATASOURCE_URL 값이:**
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a/product_yw3f
```
이런 형식이면 **잘못된 값**입니다!

**올바른 형식:**
```
jdbc:postgresql://dpg-d4gq7i4hg0os73803cmg-a.oregon-postgres.render.com:5432/product_yw3f
```

호스트명에 **도메인**과 **포트**를 추가해야 합니다!


