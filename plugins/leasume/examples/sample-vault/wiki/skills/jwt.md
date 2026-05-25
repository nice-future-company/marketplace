---
type: skill-item
title: "JWT"
level: "해본것"
evidence_flags: ["Why부재"]
created: 2026-05-25
updated: 2026-05-25
note: "가공 데이터 — fictional. 실제 인물 아님."
---

# JWT

## 요약
세션 방식에서 JWT 기반 인증으로 전환한 경험. 원본 이력서에는 Why가 없었으나 인터뷰에서
"수평 확장(sticky session 제거)" 이유를 확보했습니다.

## 근거

### Why 확보 (인터뷰에서 발굴)
- 전환 이유: 서버 수평 확장 계획에서 sticky session 의존 제거 필요
- 선택 시점: 인프라팀과 협의 후 JWT stateless 방식 채택

### 직접 경험한 것 (해본것)
- Spring Security + JWT 필터 체인 구성
- Access Token / Refresh Token 분리 발급
- 토큰 검증 미들웨어 구현

### 동작 원리 (설명가능 수준)
- Header.Payload.Signature 구조
- 서명 검증 방식 (HS256 사용, 공개키 방식과 차이 인지)

### 아직 경험 없는 것 / 확인 필요
- Refresh Token Rotation 구현 (현재 단순 재발급)
- 토큰 블랙리스트 구현 여부 불명확 → 인터뷰에서 확인 미흡

## 결핍 플래그
- Why부재: 원본 이력서에 전환 이유 없음 → 인터뷰에서 "sticky session 제거" 확보.
  STAR 에피소드에서 Why 포함 가능.
