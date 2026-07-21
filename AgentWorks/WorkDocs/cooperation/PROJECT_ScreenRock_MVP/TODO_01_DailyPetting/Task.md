# Task

## Context
- 센서 없이 데스크톱과 모바일에서 같은 방식으로 경험할 수 있는 화면 속 돌멩이 앱을 만든다.
- 돌멩이는 매일 쓰다듬을수록 조금씩 윤이 나지만 다른 보상이나 사건은 발생하지 않는다.

## Current Understanding
- 독립 화면은 `RockHomePanel`, 시각 표현은 `RockGardenSection`, 상태 전이는 `RockHomeController`가 소유한다.
- 로컬 저장 접근은 `RockCareAction`으로 분리한다.
- 로컬 날짜 문자열을 기준으로 하루 한 번만 `ShineDays`를 증가시킨다.

## Observed Issues
- WSL UNC 원본 경로에서 Windows Flutter 테스트 러너가 `/Ubuntu/...` 경로를 찾지 못했다.
- Windows 임시 로컬 경로에서 동일 프로젝트를 검증해 이 실행 환경 문제를 우회했다.

## Decision Notes
- 흔들기, 내구도, 파손, 교체 흐름은 앱의 새 의도와 맞지 않아 모두 제거했다.
- 쓰다듬기는 마우스 클릭/드래그와 터치 탭/드래그를 함께 지원한다.
- 윤기 변화는 30일에 걸쳐 서서히 보이도록 시각 강도를 정규화하며 누적 일수 자체는 계속 저장한다.

## Implementation Notes
- `shared_preferences`에 누적 쓰다듬기 일수와 마지막 쓰다듬기 날짜를 저장한다.
- CustomPainter로 돌 형태, 질감, 영구 윤기와 손끝을 따라오는 일시적 빛을 표현한다.
- 같은 날 여러 번 쓰다듬어도 누적 일수는 한 번만 증가한다.
- `sensors_plus` 의존성과 iOS 동작 센서 권한 설명을 제거했다.

## Result
- Dart format 완료
- `flutter analyze` 문제 없음
- Controller 및 Widget 테스트 3개 통과
- Windows 임시 로컬 경로에서 Android debug APK 빌드 성공

## History Index
- 아직 분리된 이력이 없다.
