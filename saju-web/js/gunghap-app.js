// 궁합 계산기 인스턴스
const gunghapCalculator = new GunghapCalculator();

// 궁합 계산 및 표시
function calculateGunghap() {
    // 첫 번째 사람 입력값
    const birthDateStr1 = document.getElementById('birthDate1').value;
    const birthTimeStr1 = document.getElementById('birthTime1').value;
    const gender1 = document.querySelector('input[name="gender1"]:checked').value;
    const isMale1 = gender1 === 'male';

    // 두 번째 사람 입력값
    const birthDateStr2 = document.getElementById('birthDate2').value;
    const birthTimeStr2 = document.getElementById('birthTime2').value;
    const gender2 = document.querySelector('input[name="gender2"]:checked').value;
    const isMale2 = gender2 === 'male';

    // 입력 검증
    if (!birthDateStr1 || !birthTimeStr1 || !birthDateStr2 || !birthTimeStr2) {
        alert('모든 정보를 입력해주세요.');
        return;
    }

    // 첫 번째 사람 날짜 객체 생성
    const [year1, month1, day1] = birthDateStr1.split('-').map(Number);
    const [hour1, minute1] = birthTimeStr1.split(':').map(Number);
    const birthDate1 = new Date(year1, month1 - 1, day1, hour1, minute1);

    // 두 번째 사람 날짜 객체 생성
    const [year2, month2, day2] = birthDateStr2.split('-').map(Number);
    const [hour2, minute2] = birthTimeStr2.split(':').map(Number);
    const birthDate2 = new Date(year2, month2 - 1, day2, hour2, minute2);

    // 로딩 표시
    document.getElementById('inputContainer').style.display = 'none';
    document.getElementById('loading').classList.add('show');

    // 계산 (약간의 딜레이 추가)
    setTimeout(() => {
        // 각 사람의 사주 계산
        const saju1 = gunghapCalculator.sajuCalculator.calculate(birthDate1, isMale1);
        const saju2 = gunghapCalculator.sajuCalculator.calculate(birthDate2, isMale2);

        // 궁합 계산
        const gunghapResult = gunghapCalculator.calculateGunghap(saju1, saju2);

        // 결과 표시
        displayGunghapResult(gunghapResult);

        // 결과 표시
        document.getElementById('loading').classList.remove('show');
        document.getElementById('resultContainer').classList.remove('hidden');

        // 맨 위로 스크롤
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }, 500);
}

// 궁합 결과 표시
function displayGunghapResult(result) {
    // 총점 및 등급
    document.getElementById('gradeDisplay').textContent = result.grade;
    document.getElementById('gradeDisplay').style.color = gunghapCalculator.getGradeColor(result.totalScore);
    document.getElementById('totalScoreDisplay').textContent = `${result.totalScore}점`;
    document.getElementById('summaryDisplay').textContent = result.summary;

    // 첫 번째 사람 정보
    displayPersonInfo(result.person1, '1');

    // 두 번째 사람 정보
    displayPersonInfo(result.person2, '2');

    // 카테고리별 점수
    displayCategoryScores(result.categoryScores);

    // 긍정적 요소
    displayPoints(result.positivePoints, 'positivePointsList');

    // 부정적 요소
    displayPoints(result.negativePoints, 'negativePointsList');
}

// 개인 정보 표시
function displayPersonInfo(saju, personNumber) {
    const birthDate = saju.birthDate;
    document.getElementById(`person${personNumber}BirthDate`).textContent =
        `${birthDate.getFullYear()}년 ${birthDate.getMonth() + 1}월 ${birthDate.getDate()}일 ` +
        `${birthDate.getHours()}시 ${birthDate.getMinutes()}분`;
    document.getElementById(`person${personNumber}Gender`).textContent = saju.isMale ? '남자' : '여자';
    document.getElementById(`person${personNumber}Ilgan`).textContent = saju.ilgan;

    // 사주팔자
    document.getElementById(`person${personNumber}YearCheongan`).textContent = saju.yearPillar.cheongan;
    document.getElementById(`person${personNumber}YearJiji`).textContent = saju.yearPillar.jiji;
    document.getElementById(`person${personNumber}MonthCheongan`).textContent = saju.monthPillar.cheongan;
    document.getElementById(`person${personNumber}MonthJiji`).textContent = saju.monthPillar.jiji;
    document.getElementById(`person${personNumber}DayCheongan`).textContent = saju.dayPillar.cheongan;
    document.getElementById(`person${personNumber}DayJiji`).textContent = saju.dayPillar.jiji;
    document.getElementById(`person${personNumber}TimeCheongan`).textContent = saju.timePillar.cheongan;
    document.getElementById(`person${personNumber}TimeJiji`).textContent = saju.timePillar.jiji;
}

// 카테고리별 점수 표시
function displayCategoryScores(categoryScores) {
    const container = document.getElementById('categoryScoresContainer');
    let html = '';

    // 최대 점수 정의
    const maxScores = {
        '일간 궁합': 30,
        '오행 조화': 25,
        '지지 관계': 25,
        '신살 궁합': 20
    };

    for (const [category, score] of Object.entries(categoryScores)) {
        const maxScore = maxScores[category];
        const percentage = (score / maxScore * 100).toFixed(1);
        html += `
            <div class="ohaeng-item">
                <div class="ohaeng-label">
                    <span>${category}</span>
                    <span>${score}점 / ${maxScore}점</span>
                </div>
                <div class="ohaeng-bar">
                    <div class="ohaeng-fill" style="width: ${percentage}%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        ${score}
                    </div>
                </div>
            </div>
        `;
    }

    container.innerHTML = html;
}

// 긍정/부정 포인트 표시
function displayPoints(points, elementId) {
    const list = document.getElementById(elementId);
    let html = '';

    if (points.length === 0) {
        html = '<li style="color: #999;">해당 요소가 없습니다.</li>';
    } else {
        points.forEach(point => {
            html += `<li style="margin-bottom: 10px; line-height: 1.6;">${point}</li>`;
        });
    }

    list.innerHTML = html;
}

// 오늘 날짜로 초기화
window.addEventListener('DOMContentLoaded', () => {
    const today = new Date();
    const dateStr = today.toISOString().split('T')[0];
    const timeStr = '12:00';

    const birthDate1Input = document.getElementById('birthDate1');
    const birthTime1Input = document.getElementById('birthTime1');
    const birthDate2Input = document.getElementById('birthDate2');
    const birthTime2Input = document.getElementById('birthTime2');

    if (birthDate1Input) birthDate1Input.value = dateStr;
    if (birthTime1Input) birthTime1Input.value = timeStr;
    if (birthDate2Input) birthDate2Input.value = dateStr;
    if (birthTime2Input) birthTime2Input.value = timeStr;
});
