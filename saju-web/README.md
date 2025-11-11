# 사주팔자 웹 앱

순수 HTML/CSS/JavaScript로 구현된 사주팔자 웹 애플리케이션입니다.

## 기능

- 🪄 **사주팔자 보기**: 생년월일시 입력으로 사주팔자 계산
- 💑 **궁합 보기**: 두 사람의 궁합 분석 (100점 만점)
- 🌿 **오행 분석**: 목, 화, 토, 금, 수 분석
- 🔄 **대운/세운/월운**: 10년 단위 대운, 매년 세운, 매월 월운 확인

## 파일 구조

```
saju-web/
├── index.html              # 메인 페이지
├── saju.html               # 사주팔자 페이지
├── gunghap.html            # 궁합 페이지
├── css/
│   └── style.css           # 스타일시트
└── js/
    ├── saju-calculator.js      # 사주 계산 로직
    ├── saju-app.js             # 사주 앱 로직
    ├── gunghap-calculator.js   # 궁합 계산 로직
    └── gunghap-app.js          # 궁합 앱 로직
```

## 사용 방법

1. 웹 브라우저에서 `index.html` 파일을 엽니다.
2. "사주팔자 보기" 또는 "궁합 보기"를 선택합니다.
3. 생년월일시와 성별을 입력합니다.
4. 결과를 확인합니다.

## 기술 스택

- HTML5
- CSS3 (Gradient, Flexbox)
- Vanilla JavaScript (ES6+)
- No external dependencies

## 특징

- 프레임워크 없는 순수 웹 구현
- 반응형 디자인
- 60갑자, 오행, 상생상극 기반 정통 사주 계산
- 아름다운 그라디언트 UI

## 주의사항

본 서비스는 참고용이며, 모든 결정은 본인의 책임입니다.
