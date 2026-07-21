# 화면 속 돌멩이 MVP

## Summary
- 매일 한 번 쓰다듬으면 조금씩 윤이 나는 화면 속 돌멩이 앱으로 프로젝트를 전환한다.

## Background
- 데스크톱에서는 기존 전자 두부의 흔들기 센서 입력을 테스트하기 어려웠다.
- 마우스와 터치에서 동일하게 성립하는 조용한 직접 조작 경험으로 교체한다.

## Scope
- 전자 두부, 흔들기 센서, 파손 상태를 제거한다.
- 돌멩이 클릭/드래그 쓰다듬기와 잔잔한 표면 반응을 구현한다.
- 하루 최대 횟수까지 윤기가 증가하고 앱 재실행 후에도 유지되게 한다.
- Controller와 Widget 테스트, Android debug 빌드를 검증한다.

## References
- `AgentWorks/docs/project-rules/architecture/ARCHITECTURE_RULES_PANEL_SECTION_FLUTTER_V1.md`
- `AgentWorks/docs/project-rules/platform/FLUTTER_PLATFORM_PROFILE_MOBILE_V2.md`
- `PROJECT_ElectronicTofu_MVP`

## Current Status
- TODO_01_DailyPetting 구현, 리뷰, 검증 완료
- TODO_02_FullscreenDailyLimit 전체 화면 배치와 일일 반복 쓰다듬기 개선 완료
- TODO_03_CenteredPhotoShineFeedback 중앙 정렬, 실사 돌, 연속 진행 바와 광택 피드백 개선 완료
- TODO_04_TouchCleanupCheatDistance 터치 블러 정리, 초기화 치트, 거리 조정 완료
- TODO_05_GitHubPublication 상태 비교 촬영, 프로젝트 설명과 GitHub 게시 완료
