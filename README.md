# nice-future-marketplace

nice-future-company의 Claude Code 플러그인 마켓플레이스. 커리어·이력서 등 **사람의 시간을 최소로 쓰면서 결과를 내는 셀프 파이프라인 도구**를 모읍니다.

## 설치

```
/plugin marketplace add nice-future-company/marketplace
/plugin install leasume
```

## 플러그인

### leasume — 개발자 이력서 작성 멘토링
멘티별 vault에 이력서 전체 사이클을 셀프로 돌리는 가이드 레일.

```
/leasume:init-resume-workspace <id>   # vault 생성 + 이력서 입력
/leasume:assess <id>                  # 진단 L0~L3
/leasume:interview-resume-hybrid <id> # 인터뷰 드릴다운(grill)
/leasume:format-star-sbi <id>         # STAR/SBI 에피소드
/leasume:export <id> [--html]         # HTML 이력서 출력
```

1년 52세션 멘토링에서 반복된 패턴(Why부재·정량과잉·두괄식 미적용 등)을 인터뷰 단계에 박제. 자세한 사용법은 [`plugins/leasume/README.md`](plugins/leasume/README.md), 워크드 예시는 [`plugins/leasume/examples/`](plugins/leasume/examples/) 참고.

## 확장
이력서 외 커리어·생산성 도구 플러그인을 같은 마켓플레이스에 추가해 나갑니다. 각 플러그인은 `plugins/<name>/`에 두고 `.claude-plugin/marketplace.json`에 등록합니다.
