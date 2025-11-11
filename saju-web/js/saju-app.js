// 사주 계산기 인스턴스
const sajuCalculator = new SajuCalculator();

// 폼 제출 이벤트
document.getElementById('sajuForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    calculateAndDisplay();
});

// 사주 계산 및 표시
function calculateAndDisplay() {
    // 입력 값 가져오기
    const birthDateStr = document.getElementById('birthDate').value;
    const birthTimeStr = document.getElementById('birthTime').value;
    const gender = document.querySelector('input[name="gender"]:checked').value;
    const isMale = gender === 'male';

    // 날짜 객체 생성
    const [year, month, day] = birthDateStr.split('-').map(Number);
    const [hour, minute] = birthTimeStr.split(':').map(Number);
    const birthDate = new Date(year, month - 1, day, hour, minute);

    // 로딩 표시
    document.getElementById('inputCard').style.display = 'none';
    document.getElementById('loading').classList.add('show');

    // 계산 (약간의 딜레이 추가)
    setTimeout(() => {
        const saju = sajuCalculator.calculate(birthDate, isMale);
        displayResult(saju);

        // 결과 표시
        document.getElementById('loading').classList.remove('show');
        document.getElementById('resultContainer').classList.remove('hidden');

        // 맨 위로 스크롤
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }, 500);
}

// 결과 표시
function displayResult(saju) {
    // 기본 정보
    const birthDate = saju.birthDate;
    document.getElementById('resultBirthDate').textContent =
        `${birthDate.getFullYear()}년 ${birthDate.getMonth() + 1}월 ${birthDate.getDate()}일 ` +
        `${birthDate.getHours()}시 ${birthDate.getMinutes()}분`;
    document.getElementById('resultGender').textContent = saju.isMale ? '남자' : '여자';
    document.getElementById('resultIlgan').textContent = saju.ilgan;

    // 사주팔자
    document.getElementById('yearCheongan').textContent = saju.yearPillar.cheongan;
    document.getElementById('yearJiji').textContent = saju.yearPillar.jiji;
    document.getElementById('monthCheongan').textContent = saju.monthPillar.cheongan;
    document.getElementById('monthJiji').textContent = saju.monthPillar.jiji;
    document.getElementById('dayCheongan').textContent = saju.dayPillar.cheongan;
    document.getElementById('dayJiji').textContent = saju.dayPillar.jiji;
    document.getElementById('timeCheongan').textContent = saju.timePillar.cheongan;
    document.getElementById('timeJiji').textContent = saju.timePillar.jiji;

    // 오행 분석
    displayOhaeng(saju.ohaeng);

    // 대운
    displayDaeun(saju.daeun);

    // 세운
    displaySeun(saju.seun);

    // 월운
    displayWolun(saju.wolun);
}

// 오행 분석 표시
function displayOhaeng(ohaeng) {
    const container = document.getElementById('ohaengContainer');
    const total = Object.values(ohaeng).reduce((a, b) => a + b, 0);

    const ohaengEmoji = {
        '목': '🌳',
        '화': '🔥',
        '토': '⛰️',
        '금': '⚔️',
        '수': '💧'
    };

    let html = '';
    for (const [element, count] of Object.entries(ohaeng)) {
        const percentage = (count / total * 100).toFixed(1);
        html += `
            <div class="ohaeng-item">
                <div class="ohaeng-label">
                    <span>${ohaengEmoji[element]} ${element}</span>
                    <span>${count}개 (${percentage}%)</span>
                </div>
                <div class="ohaeng-bar">
                    <div class="ohaeng-fill ohaeng-${element}" style="width: ${percentage}%">
                        ${count}
                    </div>
                </div>
            </div>
        `;
    }

    container.innerHTML = html;
}

// 대운 표시
function displayDaeun(daeunList) {
    const container = document.getElementById('daeunContainer');
    let html = '';

    daeunList.forEach(daeun => {
        html += `
            <div class="un-item">
                <div class="un-ganzhi">${daeun.ganzhi}</div>
                <div class="un-info">${daeun.startAge}~${daeun.endAge}세</div>
            </div>
        `;
    });

    container.innerHTML = html;
}

// 세운 표시
function displaySeun(seunList) {
    const container = document.getElementById('seunContainer');
    const currentYear = new Date().getFullYear();
    let html = '';

    seunList.forEach(seun => {
        const isCurrent = seun.year === currentYear;
        html += `
            <div class="un-item ${isCurrent ? 'current' : ''}">
                <div class="un-ganzhi">${seun.ganzhi}</div>
                <div class="un-info">${seun.year}년</div>
            </div>
        `;
    });

    container.innerHTML = html;
}

// 월운 표시
function displayWolun(wolunList) {
    const container = document.getElementById('wolunContainer');
    const currentMonth = new Date().getMonth() + 1;
    let html = '';

    wolunList.forEach(wolun => {
        const isCurrent = wolun.month === currentMonth;
        html += `
            <div class="un-item ${isCurrent ? 'current' : ''}">
                <div class="un-ganzhi">${wolun.ganzhi}</div>
                <div class="un-info">${wolun.month}월</div>
            </div>
        `;
    });

    container.innerHTML = html;
}

// 오늘 날짜로 초기화
window.addEventListener('DOMContentLoaded', () => {
    const today = new Date();
    const dateStr = today.toISOString().split('T')[0];
    const timeStr = '12:00';

    const birthDateInput = document.getElementById('birthDate');
    const birthTimeInput = document.getElementById('birthTime');

    if (birthDateInput) birthDateInput.value = dateStr;
    if (birthTimeInput) birthTimeInput.value = timeStr;
});
