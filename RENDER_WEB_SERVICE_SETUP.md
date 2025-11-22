# 렌더 웹 서비스 수동 설정 가이드

## 🔧 렌더 대시보드에서 환경을 Java로 변경하기

### 1. 웹 서비스 설정 페이지로 이동
- 렌더 대시보드에서 현재 서비스 클릭
- **Settings** 탭 클릭

### 2. 환경 설정 변경 (중요!)

#### Environment 설정
1. **Environment** 섹션 찾기
2. 드롭다운에서 **"Java"** 선택 (현재 Node.js로 되어 있을 것)
3. **"Save Changes"** 클릭

#### Runtime 설정
1. **Runtime** 섹션에서 **"Java 21"** 또는 **"OpenJDK 21"** 선택
2. 저장

### 3. 빌드 명령어 설정

**Build Command** 섹션에서:
```bash
chmod +x ./gradlew && ./gradlew clean bootJar -x test
```

### 4. 시작 명령어 설정

**Start Command** 섹션에서:
```bash
java -Dserver.port=$PORT -Djava.security.egd=file:/dev/./urandom -jar build/libs/PublicApiProj-0.0.1-SNAPSHOT.jar
```

### 5. Health Check 설정

**Health Check Path:**
```
/
```

### 6. 환경 변수 설정 (Environment Variables 탭)

**필수 환경 변수:**
```
SPRING_PROFILES_ACTIVE=prod
```

**데이터베이스 연결 (필수):**
```
SPRING_DATASOURCE_URL=jdbc:mariadb://... (또는 postgresql://...)
SPRING_DATASOURCE_USERNAME=...
SPRING_DATASOURCE_PASSWORD=...
```

### 7. 저장 후 재배포

모든 설정 변경 후:
- **"Save Changes"** 클릭
- **"Manual Deploy"** → **"Deploy latest commit"** 클릭
- 또는 GitHub에 새 커밋 푸시하면 자동 재배포

## ⚠️ 주의사항

1. **Environment는 반드시 "Java"여야 함**
   - Node.js가 선택되어 있으면 안 됩니다
   - Java로 변경해야 Gradle 빌드가 실행됩니다

2. **Runtime은 Java 21로 설정**
   - Java 17도 가능하지만, 프로젝트는 Java 21 사용 중

3. **JAR 파일 이름 확인**
   - `PublicApiProj-0.0.1-SNAPSHOT.jar` 확인
   - 다른 이름이면 build.gradle의 버전 확인

## 🔍 문제 해결

### 여전히 Node.js로 인식되는 경우
1. 서비스 삭제 후 재생성
2. 재생성 시 Environment를 처음부터 Java로 선택
3. 또는 Blueprint 사용 (render.yaml 자동 적용)

### JAVA_HOME 에러가 계속 발생하는 경우
1. Runtime이 Java 21로 설정되어 있는지 확인
2. Build Command에 Java 경로 명시 (일반적으로 불필요):
   ```bash
   export JAVA_HOME=/usr/lib/jvm/java-21-openjdk && chmod +x ./gradlew && ./gradlew clean bootJar -x test
   ```

### 빌드는 성공하지만 실행이 안 되는 경우
1. Start Command 확인
2. JAR 파일 경로 확인 (`build/libs/PublicApiProj-0.0.1-SNAPSHOT.jar`)
3. 포트 설정 확인 (`-Dserver.port=$PORT`)

