# 렌더에서 Java 배포 (Language 옵션 없을 때)

## 방법 1: Docker 사용 (권장) ⭐

렌더에서 Language 드롭다운에 Java가 없을 때는 **Docker**를 사용하는 것이 가장 확실합니다.

### 1. Dockerfile 생성
프로젝트 루트에 `Dockerfile`을 생성했습니다. (이미 생성됨)

### 2. 렌더 대시보드 설정

1. **Language 드롭다운에서 "Docker" 선택**
2. **Build Command:** (비워두기 - Dockerfile이 자동 사용됨)
3. **Start Command:** (비워두기 - Dockerfile이 자동 사용됨)
4. **Dockerfile Path:** (비워두기 - 루트의 Dockerfile 자동 인식)

### 3. 환경 변수 설정

**Environment Variables 탭에서:**
```
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=...
SPRING_DATASOURCE_USERNAME=...
SPRING_DATASOURCE_PASSWORD=...
```

### 4. 배포
- "Deploy Web Service" 클릭
- Dockerfile이 자동으로 빌드되고 실행됩니다

---

## 방법 2: Language를 Node로 선택하고 명령어만 Java로 설정

Language 드롭다운에는 "Node"를 선택하지만, 실제로는 Java 명령어를 실행합니다.

### 렌더 대시보드 설정

1. **Language:** `Node` 선택 (실제로는 무시됨)
2. **Build Command:**
   ```bash
   chmod +x ./gradlew && ./gradlew clean bootJar -x test
   ```
3. **Start Command:**
   ```bash
   java -Dserver.port=$PORT -Djava.security.egd=file:/dev/./urandom -jar build/libs/PublicApiProj-0.0.1-SNAPSHOT.jar
   ```

### 주의사항
- 이 방법은 Build Command와 Start Command가 Java 명령어를 실행하도록 설정하면 작동합니다
- 하지만 렌더가 Java 런타임을 자동으로 설치하지 않을 수 있습니다
- **방법 1 (Docker)을 권장합니다**

---

## 방법 3: Blueprint 사용 (render.yaml)

`render.yaml` 파일이 있으면 Blueprint를 사용할 수 있습니다.

1. 렌더 대시보드에서 **"New +" → "Blueprint"** 선택
2. GitHub 저장소 연결
3. `render.yaml` 파일이 자동으로 감지됨
4. "Apply" 클릭

이 방법이 가장 자동화되어 있고 추천합니다!

---

## 비교

| 방법 | 장점 | 단점 |
|------|------|------|
| **Docker** | 확실하게 작동, 환경 일관성 | Dockerfile 작성 필요 |
| **Node 선택 + 명령어** | 빠른 설정 | Java 런타임 설치 보장 안 됨 |
| **Blueprint** | 자동화, 설정 간단 | render.yaml 필요 |

## 추천 순서

1. **Blueprint 사용** (render.yaml 있으면)
2. **Docker 사용** (Dockerfile 생성됨)
3. Node 선택 + 명령어 (최후의 수단)

