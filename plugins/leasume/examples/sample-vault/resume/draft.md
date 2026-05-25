---
type: resume-draft
mentee_id: "jaewon-park-2026"
version: 1
inferred_count: 1
incomplete_count: 0
created: 2026-05-25
updated: 2026-05-25
note: "가공 데이터 — fictional. 실제 인물 아님. > 추정: 마커는 final.html에서 strip됨."
---

# 박재원 (가명, fictional)

백엔드 개발자 · Java/Spring Boot · 3년

---

## 요약

Java/Spring Boot 기반 백엔드 개발 3년 경력. 핀테크 스타트업에서 상품조회 API 성능 문제를
직접 진단하고 Redis 캐시 아키텍처를 설계·도입한 경험이 있습니다. 기술 선택 시 read/write
특성과 데이터 정합성 요구사항을 함께 고려합니다.

---

## 경력

### 핀테크 스타트업 A사 | 백엔드 개발자 | 2023-03 ~ 현재

**상품조회 API 응답 지연 해소 — Redis Look-aside 캐시 도입** (2024-06 ~ 2024-08)

PM 이슈 제보로 시작해 APM 로그로 원인(풀스캔 + N+1 쿼리)을 직접 특정했습니다.
상품조회의 read-heavy 특성(읽기:쓰기 ≈ 95:5)을 근거로 Look-aside 패턴을 선택했고,
TTL 5분 + 명시적 eviction을 조합해 정합성을 유지했습니다.

> 추정: "응답시간 대폭 단축" 효과는 팀 내 확인됐으나, 이력서에 기재된 "20초→0.8초"
> 수치의 부하 조건(동시 접속, 측정 환경)은 인터뷰에서 명확히 검증되지 않았습니다.
> 프로덕션 APM 기준 수치로 교체 권장.

**회원 인증 시스템 JWT 전환** (2023-09 ~ 2023-11)

서버 수평 확장 계획에 따른 sticky session 의존 제거가 목적이었습니다.
Spring Security + JWT 필터 체인을 구성하고 Access/Refresh Token 분리 발급을 구현했습니다.

---

### SI 업체 B사 | 개발자 | 2022-01 ~ 2023-02

레거시 JSP 기반 시스템 유지보수 및 Oracle DB 프로시저 작성.
고객사 요청 기능을 요구사항 분석부터 배포까지 담당했습니다.

---

## 기술 스택

| 구분 | 기술 | 수준 |
|------|------|------|
| 언어/프레임워크 | Java, Spring Boot | 실무 3년 |
| 데이터베이스 | MySQL, Oracle | 실무 3년 |
| 캐시 | Redis (Look-aside, TTL·eviction 설계 경험) | 최적화경험 |
| 인증 | JWT, Spring Security | 해본것 |
| 레거시 | JSP, Oracle 프로시저 | 유지보수 경험 |

---

## 교육

OO대학교 컴퓨터공학과 졸업 (2022-02)
