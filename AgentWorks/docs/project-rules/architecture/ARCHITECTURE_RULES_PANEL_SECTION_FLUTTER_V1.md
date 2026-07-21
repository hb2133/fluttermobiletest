# ARCHITECTURE RULES (Panel-Section, Flutter Profile) V1

## 1) 문서 역할
- 이 문서는 Flutter/Dart 프로젝트에서 `Panel-Section-Controller` 공용 규칙을 실제 경로와 파일 책임으로 매핑하는 플랫폼 전용 아키텍처 문서다.
- 공통 개념과 책임 정의는 반드시 `ARCHITECTURE_RULES_PANEL_SECTION_CORE_V1.md`를 따른다.
- 이 문서는 공용 `Panel` 개념을 Flutter 기준의 `BasePanel`, `LayeredPanel`, `Section`, `Fragment`, `Controller`, `Action`, `Manager`로 매핑한다.
- 이 문서는 구조, 경로, 라우팅 진입, BasePanel 전환, LayeredPanel 배치를 Flutter 기준으로 고정한다.

## 2) 적용 범위
- 전제 프로젝트는 Flutter + Dart다.
- 기본 진입점은 `lib/main.dart`다.
- 라우팅은 `go_router` 또는 Navigator 2.0 계열을 전제로 한다.
- 전역 디자인 SSOT는 `lib/design/global_design.dart`다.
- 이 문서는 Flutter 모바일, 데스크톱, 내부 툴형 앱에 공통 적용할 수 있다.

## 3) 우선순위
- 1순위: `ARCHITECTURE_RULES_PANEL_SECTION_CORE_V1.md`
- 2순위: 본 문서
- 3순위: 프로젝트별 플랫폼/디자인 문서
- 4순위: 개별 작업 요구사항
- 본 문서는 공용 문서의 개념을 실제 경로로 매핑하는 문서이며, 공용 문서의 개념을 변경할 수 없다.

## 4) 공통 코딩 컨벤션
- 중괄호는 `Allman brace style`을 사용한다.
- 식별자 이름은 기본적으로 `PascalCase`를 사용한다.
- boolean 조건은 축약형 부정보다 명시형 비교를 우선한다.
- 예: `if(IsReady == false)`
- Dart 파일명과 디렉터리명은 `snake_case`를 사용한다.
- `lib/` 하위 import는 `package:<app_name>/...` 절대 경로를 기본으로 사용한다.
- 상위 상대 경로 import(`../`, `../../`)는 금지한다.
- 동일 폴더 로컬 파일만 상대 경로를 허용한다.

## 5) 핵심 원칙
- 사용자 화면의 제품 구조는 `lib/panels/` 아래에 둔다.
- `BasePanel`과 `LayeredPanel`은 공용 `Panel` 개념을 Flutter에서 역할별로 나눈 플랫폼 프로파일 용어다.
- app route는 `BasePanel` 선택과 교체만 담당한다.
- `LayeredPanel`은 route 대상이 아니다.
- 현재 화면에서 어떤 `LayeredPanel`을 띄우고 닫을지는 현재 활성 `BasePanel`이 자기 로컬 layered stack으로 직접 관리한다.
- `LayeredPanel`은 여러 `BasePanel`에서 재사용할 수 있다.
- `Section`, `Tab`, Panel 내부 표시 상태 전환은 기본적으로 route가 아니라 현재 `BasePanel Controller` 상태로 처리한다.
- Panel 내부 시각 분해 단위는 `Section`이며, Widget 트리는 Panel root, Section, Fragment, AppShell, PanelLayerHost에서만 작성한다.
- `Controller`, `State`, `Action`은 순수 Dart 파일로 분리하고, Widget `build(...)`는 시각 조립 파일에만 둔다.
- 외부 API, DB, 파일시스템, 네트워크 호출 orchestration은 `Panel Action` 또는 `Manager`에서만 수행한다.
- 여러 Panel에서 반복 검증된 비시각 책임만 `lib/managers/`로 승격한다.
- `LayeredPanel`의 open/close lifecycle, focus/dismiss 정책 상세는 `ARCHITECTURE_RULES_PANEL_LAYER_FLUTTER_V1.md`를 따른다.

## 6) 표준 디렉터리 구조
```text
lib/
├─ main.dart
├─ app/
│  ├─ navigation/
│  │  └─ app_navigator.dart
│  ├─ panel_layer/
│  │  └─ panel_layer_host.dart
│  ├─ router/
│  │  └─ app_router.dart
│  └─ shell/
│     └─ app_shell.dart
├─ core/
│  ├─ config/
│  │  ├─ env.dart
│  │  ├─ runtime_profile.dart
│  │  └─ feature_flags.dart
│  ├─ infra/
│  ├─ localization/
│  └─ services/
├─ design/
│  └─ global_design.dart
├─ managers/
│  └─ <manager_name>/
│     ├─ <manager_name>.dart
│     ├─ <manager_name>_state.dart
│     └─ <manager_name>_types.dart
└─ panels/
   ├─ base/
   │  └─ <base_panel_name>/
   │     ├─ <base_panel_name>_panel.dart
   │     ├─ <base_panel_name>_interface.dart
   │     ├─ controller/
   │     │  ├─ <base_panel_name>_controller.dart
   │     │  ├─ <base_panel_name>_state.dart
   │     │  ├─ <base_panel_name>_types.dart
   │     │  └─ actions/
   │     │     ├─ <load_something_action>.dart
   │     │     └─ <submit_something_action>.dart
   │     └─ sections/
   │        ├─ <section_name>/
   │        │  ├─ <section_name>_section.dart
   │        │  └─ fragments/
   │        │     └─ <fragment_name>_fragment.dart
   │        └─ <tab_group_name>/
   │           ├─ tab_selector_section/
   │           │  └─ tab_selector_section.dart
   │           ├─ tab_viewport_section/
   │           │  └─ tab_viewport_section.dart
   │           └─ tab_fragments/
   │              ├─ <tab_a_section>.dart
   │              └─ <tab_b_section>.dart
   └─ layered/
      └─ <layered_panel_name>/
         ├─ <layered_panel_name>_panel.dart
         ├─ <layered_panel_name>_interface.dart
         ├─ controller/
         │  ├─ <layered_panel_name>_controller.dart
         │  ├─ <layered_panel_name>_state.dart
         │  ├─ <layered_panel_name>_types.dart
         │  └─ actions/
         │     └─ <layered_panel_action>.dart
         └─ sections/
            └─ <section_name>/
               ├─ <section_name>_section.dart
               └─ fragments/
                  └─ <fragment_name>_fragment.dart
```

## 7) App-Level 구조
- app-level route 계층은 아래 세 책임만 가진다.
- route 전환
- `BasePanel` 교체
- 전역 shell 유지

- `LayeredPanel` open/close는 app-level route가 아니라 현재 `BasePanel` 내부 책임이다.
- `AppShell`은 route가 바뀌어도 유지되는 전역 셸이다.
- `AppNavigator`는 `BasePanel` 전환 진입점이다.
- `PanelLayerHost`는 현재 `BasePanel`이 소유한 layered stack를 그리는 host이며, app-level 라우터가 아니다.
- 기본 흐름은 아래와 같다.

```text
Section Event
-> BasePanel Controller
-> if same BasePanel:
   state change or layered panel update
-> if BasePanel change required:
   current BasePanel cleanup / close completion
   -> AppNavigator
   -> route change
   -> next BasePanel mount
```

### 7-1) `lib/main.dart`, `lib/app/router/`
- 역할: Flutter 앱 시작점, router 연결, app shell 수준의 최소 wiring.
- 허용: app bootstrap, router 정의, `BasePanel` 연결, 전역 theme 적용.
- 금지: `Controller`, `Action`, `Manager` 직접 구현, Panel 비즈니스 로직 소유, 복잡한 Widget 조립.
- 필수: route builder는 가능한 한 해당 `BasePanel` root 파일만 연결하는 얇은 라우트 셸이어야 한다.

### 7-2) `lib/app/navigation/`
- 경로: `lib/app/navigation/`
- 역할: app-level `BasePanel` 전환을 담당하는 navigation 계층이다.
- 기준 파일: `app_navigator.dart`
- 허용: route 이동 helper, `BasePanel` 교체, app-level navigation intent 처리
- 금지: `LayeredPanel` open/close, Section 비즈니스 로직 소유
- 기본 구조에서는 `app_navigator.dart` 1개 파일로 시작한다.
- `BasePanel` 전환은 `BasePanel Controller -> AppNavigator -> route change` 흐름을 따른다.

### 7-3) `lib/app/shell/`
- 경로: `lib/app/shell/`
- 역할: 앱 전역 shell과 root viewport 성격의 시각 껍데기를 둔다.
- 기준 파일: `app_shell.dart`
- 허용: provider 연결, 전역 스타일 연결, 현재 `BasePanel`이 들어오는 루트 셸 구성
- 금지: Panel 비즈니스 로직, `LayeredPanel` 상태 소유

### 7-4) `lib/app/panel_layer/`
- 경로: `lib/app/panel_layer/`
- 역할: 현재 `BasePanel`이 연 `LayeredPanel` stack을 실제로 렌더링하는 공용 host 계층이다.
- 기준 파일: `panel_layer_host.dart`
- 허용: layered stack 렌더링, backdrop, enter/exit 애니메이션 연결, focus/dismiss 연결
- 금지: app-level route 판단, Panel 도메인 의미 소유
- 상세 계약은 `ARCHITECTURE_RULES_PANEL_LAYER_FLUTTER_V1.md`를 따른다.

## 8) Core / Design / Managers 경계
### 8-1) `/core`
- 경로: `lib/core/`
- 역할: 전역 공통 설정, 외부 연동 구현, 전역 서비스 기반 계층을 담는다.
- 주요 하위 단위:
- `config/`: 환경값, 런타임 프로파일, feature flag, 정책성 상수
- `infra/`: API client, storage adapter, auth adapter, 외부 SDK 연동
- `localization/`: 전역 문자열 리소스와 locale 규칙
- `services/`: 전역 공통 서비스, 앱 수준 orchestration
- 금지: 특정 Panel 전용 상태, 특정 Panel 전용 시각 로직, 특정 Section 전용 정책
- 허용: `panels -> core`, `managers -> core`
- 금지: `core -> panels`
- 필수: 로컬 개발 런타임과 실제 배포 런타임 차이는 `lib/core/config/`에서 관리한다.
- 금지: `main.dart`, `app_shell.dart`, Panel root 파일, `Section`, `Controller`에 환경 분기를 흩뿌리는 패턴

### 8-2) `/design`
- 경로: `lib/design/`
- 역할: 전역 디자인 SSOT를 담는 레이어다.
- 기준 파일: `lib/design/global_design.dart`
- 허용: 디자인 토큰, ThemeData, ThemeExtension, 전역 스타일 기준
- 금지: Panel 전용 Widget 조립, Section 전용 상태, 비즈니스 로직

### 8-3) `/managers`
- 경로: `lib/managers/`
- 역할: 여러 Panel에서 반복 검증된 비시각 로직, 공용 상태, 외부 연동 orchestration을 관리한다.
- 승격 기준은 공용 코어 문서의 Manager 규칙을 따른다.
- 금지: Panel 조립 코드, Section Widget, 단일 Panel 전용 임시 로직

## 9) `/panels` 경계
- 경로: `lib/panels/`
- 역할: 사용자와 직접 만나는 화면 구현의 주 경계다.
- 모든 사용자 화면 구현은 여기에서 시작한다.
- `base/`는 route 대상 패널만 둔다.
- `layered/`는 오버레이 전용 패널만 둔다.
- 금지: 한 Panel 내부 구현을 다른 Panel에서 직접 끌어다 쓰는 패턴
- 기본 구조에 `shared/`를 미리 두지 않는다.
- 실제 반복이 검증된 경우에만 별도 공용 시각 조각 경로를 예외적으로 추가할 수 있다.

## 10) BasePanel 규칙
- 경로: `lib/panels/base/<base_panel_name>/`
- 각 `BasePanel`은 최소한 `<base_panel_name>_panel.dart`, `controller/`, `sections/`를 가진다.
- `<base_panel_name>_panel.dart`는 해당 `BasePanel`의 최종 화면 셸이자 Section 조립 지점이다.
- `<base_panel_name>_panel.dart`는 `Controller`가 준비한 상태와 이벤트 연결 결과만 사용한다.
- `<base_panel_name>_panel.dart`는 `Action`, `Manager`, `core/infra`를 직접 호출하지 않는다.
- `<base_panel_name>_panel.dart`는 필요 시 자기 하위 `LayeredPanel` stack를 렌더하기 위해 `PanelLayerHost`를 사용할 수 있다.
- `<base_panel_name>_panel.dart`와 그 controller는 자기 layered stack 상태를 직접 소유하고 갱신한다.
- 독립 route 진입점이 필요한 화면은 보통 독립 `BasePanel`로 본다.
- `BasePanel` 전환은 직접 router 파일을 건드리는 방식이 아니라 `Controller -> AppNavigator` 흐름으로 처리한다.
- router builder가 직접 Section을 조립하지 않는다.
- 웬만하면 각 `BasePanel` 옆에 `<base_panel_name>_interface.dart`를 두고 route 입력과 공개 props shape를 분리하는 것을 권장한다.

### 10-1) `BasePanel` 인터페이스 예시
```dart
class WorkspaceBasePanelRouteParams
{
  final String WorkspaceId;

  const WorkspaceBasePanelRouteParams({
    required this.WorkspaceId,
  });
}

class WorkspaceBasePanelProps
{
  final WorkspaceBasePanelRouteParams RouteParams;

  const WorkspaceBasePanelProps({
    required this.RouteParams,
  });
}
```

## 11) LayeredPanel 규칙
- 경로: `lib/panels/layered/<layered_panel_name>/`
- `LayeredPanel`은 `BasePanel` 위에 표시되는 오버레이 전용 패널이다.
- `LayeredPanel`은 route 대상이 아니다.
- `LayeredPanel`은 현재 활성 `BasePanel`의 layered stack 항목으로만 열리고 닫힌다.
- 하나의 `LayeredPanel` 구현은 여러 `BasePanel`에서 재사용할 수 있다.
- `LayeredPanel`은 특정 `BasePanel`에 강결합하지 않는다.
- `LayeredPanel`은 필요 시 `<layered_panel_name>_panel.dart`, `controller/`, `sections/`를 가진다.
- 의미 있는 modal, drawer, popup, confirm, side sheet는 기본적으로 `LayeredPanel`로 분리한다.
- tooltip, dropdown, hover card, 간단한 context menu 같은 초경량 부유 UI는 반드시 `LayeredPanel`로 강제하지 않는다.
- `LayeredPanel` stack 내부에는 여러 패널이 쌓일 수 있다.
- 다만 기본 UX에서는 1~2단 중첩을 권장하고, 3단 이상은 예외 케이스로 본다.
- `LayeredPanel`은 상위 `BasePanel`이 제공한 공개 함수 계약 또는 결과 이벤트 구독 지점을 통해 부모 문맥과 연결될 수 있다.
- 다만 특정 `BasePanel Controller`의 내부 상태나 내부 구현 세부를 직접 참조하지 않는다.
- 기본 통신 패턴은 `payload`, `onComplete(result)`, `onRequestClose(reason)`로 잡는다.
- 특정 `BasePanel`과 짝지어진 전용 `LayeredPanel`은 상위가 주입한 공개 함수를 직접 호출하는 방식을 기본으로 한다.
- 여러 `BasePanel`에서 재사용하는 공용 `LayeredPanel`도 가능하면 표준 `payload/result` 계약으로 처리한다.
- 연속적인 상태 보고가 필요한 경우에만 추가 결과 이벤트를 사용할 수 있다.
- 이벤트 버스는 `LayeredPanel -> BasePanel` 기본 패턴으로 두지 않는다.
- 중첩 layered 구조에서도 각 `LayeredPanel` 결과는 중간 layered를 거치지 않고 현재 stack owner인 `BasePanel`로 직접 반환할 수 있다.
- 웬만하면 각 `LayeredPanel` 옆에 `<layered_panel_name>_interface.dart`를 두고 `Payload`, `Result`, `Bindings`를 분리하는 것을 권장한다.

### 11-1) `LayeredPanel` 인터페이스 예시
```dart
enum LayeredCloseReason
{
  Confirm,
  Cancel,
  Backdrop,
  Escape,
  External,
  Replace,
}

class ConfirmLayeredPanelPayload
{
  final String Title;
  final String Message;

  const ConfirmLayeredPanelPayload({
    required this.Title,
    required this.Message,
  });
}

class ConfirmLayeredPanelResult
{
  final bool Confirmed;

  const ConfirmLayeredPanelResult({
    required this.Confirmed,
  });
}

class ConfirmLayeredPanelBindings
{
  final void Function(ConfirmLayeredPanelResult Result) OnComplete;
  final void Function(LayeredCloseReason Reason) OnRequestClose;

  const ConfirmLayeredPanelBindings({
    required this.OnComplete,
    required this.OnRequestClose,
  });
}
```

## 12) Section / Fragment / Tab 규칙
- 경로: `lib/panels/base/<base_panel_name>/sections/<section_name>/`
- 기본 파일:
- `<section_name>_section.dart`
- 필요 시 `fragments/*.dart`
- `<section_name>_section.dart`는 실제 Widget 렌더링과 이벤트 바인딩을 담당한다.
- Section constructor props 타입이 작으면 `<section_name>_section.dart` 안에 둔다.
- Section 표시용 파생값, 카드/메뉴/탭 구성, 리스트 변환, label 계산, props shape 소유권은 기본적으로 `Panel` 쪽에 둔다.
- 공통 또는 커진 표시 타입은 `<base_panel_name>_types.dart` 또는 `<base_panel_name>_state.dart`에 둔다.
- `<section_name>_view_model.dart`는 기본 생성하지 않는다.
- Section은 `Controller`가 내려준 상태와 이벤트를 받아 렌더링한다.
- Section은 `Action`, `Manager`, `core/infra`, 외부 연동을 직접 호출하지 않는다.
- Widget `build(...)`는 Section과 Fragment 파일에만 둔다.
- Tab, accordion, 조건부 fragment 전환은 overlay가 아니라 Panel 내부 표시 조각이다.
- Panel 내부 상태에 따라 교체되는 탭 조각, fragment, 조건부 section은 `LayeredPanel`이 아니다.

## 13) Controller 규칙
- 경로: `lib/panels/base/<base_panel_name>/controller/`
- 필수 기준 파일:
- `<base_panel_name>_controller.dart`
- `<base_panel_name>_state.dart`
- `<base_panel_name>_types.dart`
- `actions/*.dart`
- `<base_panel_name>_controller.dart`는 Panel의 상태 전이, Section 배치 판단, layered stack 갱신 판단, Action 호출을 담당한다.
- `<base_panel_name>_state.dart`는 Panel 상태 타입, 초기값, selector, 순수 계산 로직을 담는다.
- `actions/*.dart`는 사용자 액션별 처리 흐름을 담는다.
- Widget `build(...)`는 `controller/` 아래에서 허용하지 않는다.
- `Controller`가 직접 Widget tree를 반환하지 않는다.
- `BasePanel` 전환이 필요하면 `Controller`가 `AppNavigator`를 호출한다.
- 현재 Panel 정리나 close animation completion이 필요하면 완료 후 `AppNavigator`를 호출한다.
- `LayeredPanel` 전용 controller가 필요할 경우 layered 패널 내부에 같은 패턴으로 둘 수 있다. 다만 route/navigation 책임은 갖지 않는다.

## 14) 파일 단위 책임 규칙
### 14-1) `lib/main.dart`, `lib/app/router/*.dart`
- 역할: 앱 시작점, 라우팅 연결, app shell 수준의 최소 wiring
- 허용: app bootstrap, router 정의, `BasePanel` 연결, 전역 theme 적용
- 금지: `Controller` 직접 작성, `Manager` 직접 작성, entry 비즈니스 로직, 복잡한 Widget 조립

### 14-2) `lib/app/navigation/app_navigator.dart`
- 역할: app-level `BasePanel` 전환 처리
- 허용: route 이동, route helper, app-level navigation orchestration
- 금지: `LayeredPanel` open/close, Section 비즈니스 로직
- 현재 `BasePanel`의 close animation이나 정리가 필요하면 completion 이후 호출된다.

### 14-3) `lib/app/shell/app_shell.dart`
- 역할: 앱 전역 shell, provider 연결, `BasePanel`이 들어오는 루트 시각 셸
- 허용: shell layout, provider 연결, global theme 연결
- 금지: Panel 도메인 로직, layered stack 상태 소유

### 14-4) `lib/app/panel_layer/panel_layer_host.dart`
- 역할: 현재 `BasePanel`이 연 `LayeredPanel` stack를 실제로 렌더링
- 허용: stacked layered panel 렌더링, backdrop, enter/exit 애니메이션, completion 통지
- 금지: route 전환 결정, Panel 도메인 의미 해석
- `PanelLayerHost`는 공용 host일 뿐이며, layered stack의 원본 상태를 소유하지 않는다.

### 14-5) `lib/panels/base/<base_panel_name>/<base_panel_name>_panel.dart`
- 역할: `BasePanel` 최종 화면 셸, Section 조립, layered host 장착 위치
- 허용: Section import, presentation layout 조립, root `Key('<base_panel_name>.panel.root')`
- 금지: `Action` 직접 호출, `Manager` 직접 호출, 외부 연동 호출

### 14-6) `lib/panels/layered/<layered_panel_name>/<layered_panel_name>_panel.dart`
- 역할: `LayeredPanel` 최종 화면 셸, Section 조립, layered 전용 표시 구조
- 허용: Section import, layered layout 조립, open/close phase 반영
- 금지: route 이동, `AppNavigator` 직접 호출, 특정 `BasePanel` 직접 참조

### 14-7) `lib/panels/base/<base_panel_name>/controller/<base_panel_name>_state.dart`
- 역할: Panel 상태 타입, 초기값, selector, 순수 계산 로직
- 허용: 타입 선언, enum, 순수 함수
- 금지: Widget 선언, `BuildContext`, 외부 호출

### 14-8) `lib/panels/base/<base_panel_name>/controller/<base_panel_name>_controller.dart`
- 역할: Section 이벤트 해석, 상태 전이, Action orchestration, layered panel 전환 판단, navigation 호출
- 허용: Panel state 참조, Panel action 호출, Manager 연결, `AppNavigator` 호출
- 금지: Widget build, `BuildContext` 의존, `core/infra` 직접 호출
- layered stack entry 생성 시 `payload`, `onComplete`, `onRequestClose`, 필요 시 결과 이벤트 구독 지점을 함께 구성할 수 있다.

### 14-9) `lib/panels/base/<base_panel_name>/controller/actions/*.dart`
- 역할: 사용자 액션 처리, validation, Manager 호출, 외부 연동 순서 제어
- 허용: `Manager`, `core/services`, `core/infra` 호출 orchestration
- 금지: Widget 반환, Section import, 상태 최종 반영 소유
- 필수: async 흐름은 `try-catch`와 실패 처리 경로를 가진다.

### 14-10) `lib/panels/base/<base_panel_name>/sections/<section_name>/<section_name>_section.dart`
- 역할: Widget 렌더링, UI 분해, Controller 이벤트 연결
- 허용: Widget tree, style, `Key`, Fragment 조립
- 금지: `Action` 직접 호출, `Manager` 직접 호출, 비즈니스 규칙 직접 구현
- 필수: 사용자 표시 문자열은 `lib/core/localization/` 리소스를 통해 참조한다.

### 14-11) Section props / 표시 타입
- 기본: Section constructor props 타입은 해당 `<section_name>_section.dart` 안에 작게 둔다.
- 역할: Section이 렌더링에 필요한 최소 입력과 DOM/event callback을 표현한다.
- Panel 책임: 표시용 파생 구조체, props shape, 순수 계산, 카드/메뉴/탭 구성 데이터는 Panel root, Panel `State`, 또는 Panel `Types`가 소유한다.
- 허용: Section-local props 타입, Section-local render helper.
- 금지: Section별 `_view_model.dart` 기본 생성, 외부 호출, 저장 규칙 소유, 상태 전이 판단.

## 15) Dart / Widget 규칙
- Widget 선언과 `build(...)` 구현은 아래 위치에서만 허용한다.
- `lib/main.dart`
- `lib/app/shell/**/*.dart`
- `lib/app/panel_layer/**/*.dart`
- `lib/panels/base/**/*_panel.dart`
- `lib/panels/base/**/*_section.dart`
- `lib/panels/base/**/*_fragment.dart`
- `lib/panels/layered/**/*_panel.dart`
- `lib/panels/layered/**/*_section.dart`
- `lib/panels/layered/**/*_fragment.dart`
- 그 외의 `Controller`, `Action`, `State`, `Manager`, `core`, `navigation`, `router` 파일은 순수 Dart 로직만 둔다.

## 16) Import / 타입 / 코드젠 규칙
- `lib/` 하위 import는 `package:<app_name>/...` 절대 경로를 기본으로 사용한다.
- 상위 상대 경로 import(`../`, `../../`)는 금지한다.
- 동일 폴더 로컬 파일만 상대 경로를 허용한다.
- `dynamic` 남용을 금지한다.
- 타입이 불명확하면 `Object?`와 타입 가드 또는 명시적 모델 타입으로 정리한다.
- 선언만 있고 사용하지 않는 변수, import, 함수는 작업 종료 전 제거한다.
- `*.g.dart`, `*.freezed.dart` 등 생성 파일은 수동 수정하지 않는다.
- `part`/`part of`는 같은 Panel 경계 안에서만 사용한다.

## 17) 의존 허용 매트릭스
- 허용: `main.dart/router -> BasePanel`
- 허용: `BasePanel -> BasePanel controller/state`
- 허용: `BasePanel -> BasePanel sections`
- 허용: `BasePanel -> PanelLayerHost`
- 허용: `BasePanel controller -> actions`
- 허용: `BasePanel controller -> managers`
- 허용: `BasePanel controller -> AppNavigator`
- 허용: `BasePanel controller -> layered stack state`
- 허용: `LayeredPanel -> LayeredPanel controller/state`
- 허용: `LayeredPanel -> LayeredPanel sections`
- 허용: `actions -> managers`
- 허용: `actions -> core`
- 허용: `panels -> design`
- 금지: `router -> controller/actions/managers`
- 금지: `AppNavigator -> panels/controller`
- 금지: `PanelLayerHost -> controller`
- 금지: `section -> actions/managers/core`
- 금지: `controller -> section`
- 금지: `LayeredPanel -> AppNavigator`
- 금지: `LayeredPanel -> 특정 BasePanel 직접 참조`
- 금지: `panel A 내부 파일 -> panel B 내부 파일`

## 18) Flutter 라우팅 규칙
- `go_router` 또는 Navigator 2.0 계열을 사용할 수 있다.
- route는 `BasePanel` 선택과 교체를 위한 규칙으로만 사용한다.
- `BasePanel` 내부의 `Section`, `Tab`, 표시 상태 전환은 route로 강제하지 않는다.
- `LayeredPanel`은 route가 아니라 현재 `BasePanel`의 layered stack로 다룬다.
- `BasePanel` 전환은 `Controller -> AppNavigator -> route change` 흐름으로 통일한다.
- 현재 `BasePanel`의 close animation 또는 정리가 필요하면 completion 이후 route 전환을 수행한다.
- route 구조와 `BasePanel` 구조를 1:1로 강제하지 않는다. 다만 독립 진입점은 보통 독립 `BasePanel`로 본다.

## 19) LayeredPanel 분리 기준
- 아래 항목 중 2개 이상이면 기본적으로 `LayeredPanel`로 분리한다.
- barrier, focus trap, dismiss 정책이 필요하다.
- open/close completion이 중요하다.
- modal, drawer, popup, side sheet처럼 별도 레이어 의미가 분명하다.
- 부모 화면과 분리된 payload 또는 독립 상태를 가진다.
- 여러 `BasePanel`에서 재사용 가능성이 있다.
- 내부 구조가 여러 Section으로 나뉜다.

- 아래는 `BasePanel` 또는 Section 내부 조각으로 유지할 수 있다.
- tooltip
- dropdown
- hover card
- 간단한 context menu
- inline expand

## 20) 테스트와 검증
- `BasePanel controller`: 상태 전환과 Action orchestration 테스트 권장
- `LayeredPanel`: open/close phase와 dismiss 흐름 테스트 권장
- `actions`: validation, Manager 호출, 예외 흐름 테스트 권장
- `section`: 핵심 Widget 스모크 테스트 권장
- `manager`: 공용 로직 단위 테스트 권장
- 완료 기준:
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- Error/Warning 0

## 21) 생성 시 금지 패턴
- `<base_panel_name>_panel.dart` 없이 router가 화면을 직접 조립하는 구조
- `Section`마다 별도 Controller를 만드는 구조
- `Section` 내부에서 외부 SDK 또는 저장소를 직접 호출하는 구조
- `LayeredPanel`을 route처럼 직접 늘어놓는 구조
- Widget build를 Controller, Action, Manager에 섞는 구조
- `LayeredPanel`이 특정 `BasePanel`을 직접 import해 강결합되는 구조
- `BasePanel`과 무관한 전역 자유 overlay를 기본 패턴처럼 남발하는 구조
