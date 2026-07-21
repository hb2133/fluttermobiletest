# Task

## Context
- 전자 두부의 핵심 재미를 확인할 수 있는 첫 실행 버전을 만든다.

## Current Understanding
- 독립 화면은 `TofuHomeBasePanel`, 시각 표현은 Section, 상태 전이는 단일 Controller가 소유한다.
- 센서 SDK 구독은 Action으로 분리하고 Controller에는 정규화된 흔들기 강도만 전달한다.
- 첫 버전은 별도 이미지 없이 Flutter 도형과 애니메이션으로 두부를 표현한다.

## Observed Issues
- 아직 없음.

## Decision Notes
- 센서가 없는 테스트 환경을 위해 두부 탭을 보조 충격 입력으로 제공한다.

## Implementation Notes
- `sensors_plus` 가속도계 입력을 정규화해 Controller로 전달한다.
- 두부 탭은 센서가 없는 환경에서 사용할 수 있는 보조 흔들림 입력이다.
- 강한 흔들림은 420ms 쿨다운으로 내구도를 감소시키며 상태를 금감/부서짐으로 전환한다.
- CustomPainter와 AnimationController로 두부, 그릇, 표정, 금, 출렁임을 표현한다.
- iOS 동작 센서 사용 설명을 Info.plist에 추가했다.

## Result
- `dart format lib test` 완료
- `flutter analyze` 문제 없음
- `flutter test` 3개 통과
- Windows 임시 로컬 경로에서 Android debug APK 빌드 성공
- WSL UNC 원본 경로의 직접 Gradle 빌드는 Windows Java 파일 해시 오류로 실행할 수 없음

## History Index
- 아직 분리된 이력이 없다.
