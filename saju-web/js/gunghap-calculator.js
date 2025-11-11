// 궁합 계산기
class GunghapCalculator {
    constructor() {
        this.sajuCalculator = new SajuCalculator();
    }

    /**
     * 전체 궁합 계산
     */
    calculateGunghap(saju1, saju2) {
        const categoryScores = {};
        const positivePoints = [];
        const negativePoints = [];

        // 1. 일간 궁합 (30점)
        const ilganScore = this._calculateIlganGunghap(
            saju1.ilgan,
            saju2.ilgan,
            positivePoints,
            negativePoints
        );
        categoryScores['일간 궁합'] = ilganScore;

        // 2. 오행 조화 (25점)
        const ohaengScore = this._calculateOhaengGunghap(
            saju1.ohaeng,
            saju2.ohaeng,
            positivePoints,
            negativePoints
        );
        categoryScores['오행 조화'] = ohaengScore;

        // 3. 지지 관계 (25점)
        const jijiScore = this._calculateJijiGunghap(
            saju1,
            saju2,
            positivePoints,
            negativePoints
        );
        categoryScores['지지 관계'] = jijiScore;

        // 4. 신살 궁합 (20점)
        const sinsalScore = this._calculateSinsalGunghap(
            saju1,
            saju2,
            positivePoints,
            negativePoints
        );
        categoryScores['신살 궁합'] = sinsalScore;

        // 총점 계산
        const totalScore = Object.values(categoryScores).reduce((sum, score) => sum + score, 0);

        // 종합 평가
        const summary = this._getSummary(totalScore);
        const grade = this._getGrade(totalScore);

        return {
            person1: saju1,
            person2: saju2,
            totalScore,
            categoryScores,
            positivePoints,
            negativePoints,
            summary,
            grade
        };
    }

    /**
     * 일간 궁합 계산 (30점)
     */
    _calculateIlganGunghap(ilgan1, ilgan2, positivePoints, negativePoints) {
        let score = 15; // 기본 점수

        // 같은 일간
        if (ilgan1 === ilgan2) {
            score += 5;
            positivePoints.push('같은 일간으로 서로를 잘 이해함');
        }

        // 일간 오행 관계
        const ohaeng1 = SajuConstants.cheonganOhaeng[ilgan1];
        const ohaeng2 = SajuConstants.cheonganOhaeng[ilgan2];

        if (SajuConstants.ohaengSangsaeng[ohaeng1] === ohaeng2) {
            score += 10;
            positivePoints.push(`${ilgan1}이(가) ${ilgan2}을(를) 생해줌 (상생 관계)`);
        } else if (SajuConstants.ohaengSangsaeng[ohaeng2] === ohaeng1) {
            score += 10;
            positivePoints.push(`${ilgan2}이(가) ${ilgan1}을(를) 생해줌 (상생 관계)`);
        } else if (SajuConstants.ohaengSanggeuk[ohaeng1] === ohaeng2) {
            score -= 5;
            negativePoints.push(`${ilgan1}이(가) ${ilgan2}을(를) 극함 (상극 관계)`);
        } else if (SajuConstants.ohaengSanggeuk[ohaeng2] === ohaeng1) {
            score -= 5;
            negativePoints.push(`${ilgan2}이(가) ${ilgan1}을(를) 극함 (상극 관계)`);
        } else if (ohaeng1 === ohaeng2) {
            score += 5;
            positivePoints.push('같은 오행으로 동질감이 있음');
        }

        return Math.max(0, Math.min(30, score));
    }

    /**
     * 오행 조화 계산 (25점)
     */
    _calculateOhaengGunghap(ohaeng1, ohaeng2, positivePoints, negativePoints) {
        let score = 12; // 기본 점수

        // 부족한 오행을 보완하는지 확인
        for (const [element, count1] of Object.entries(ohaeng1)) {
            const count2 = ohaeng2[element] || 0;

            if (count1 === 0 && count2 > 2) {
                score += 3;
                positivePoints.push(`한 쪽의 부족한 ${element}을(를) 다른 쪽이 보완함`);
            } else if (count2 === 0 && count1 > 2) {
                score += 3;
                positivePoints.push(`한 쪽의 부족한 ${element}을(를) 다른 쪽이 보완함`);
            }

            if (count1 > 3 && count2 > 3) {
                score -= 2;
                negativePoints.push(`${element}이(가) 양쪽 모두 과다함`);
            }
        }

        return Math.max(0, Math.min(25, score));
    }

    /**
     * 지지 관계 계산 (25점)
     */
    _calculateJijiGunghap(saju1, saju2, positivePoints, negativePoints) {
        let score = 12; // 기본 점수

        const jiji1List = [
            saju1.yearPillar.jiji,
            saju1.monthPillar.jiji,
            saju1.dayPillar.jiji,
            saju1.timePillar.jiji
        ];

        const jiji2List = [
            saju2.yearPillar.jiji,
            saju2.monthPillar.jiji,
            saju2.dayPillar.jiji,
            saju2.timePillar.jiji
        ];

        // 충(沖) 관계 확인
        let chungCount = 0;
        for (const jiji1 of jiji1List) {
            for (const jiji2 of jiji2List) {
                if (SajuConstants.jijiChung[jiji1] === jiji2) {
                    chungCount++;
                }
            }
        }

        if (chungCount === 0) {
            score += 8;
            positivePoints.push('지지 충(沖)이 없어 안정적');
        } else if (chungCount >= 2) {
            score -= 5;
            negativePoints.push('지지 충(沖)이 많아 갈등 가능성');
        }

        // 같은 지지가 있는 경우
        let sameJijiCount = 0;
        for (const jiji1 of jiji1List) {
            if (jiji2List.includes(jiji1)) {
                sameJijiCount++;
            }
        }

        if (sameJijiCount >= 2) {
            score += 5;
            positivePoints.push('같은 지지가 있어 공감대 형성');
        }

        return Math.max(0, Math.min(25, score));
    }

    /**
     * 신살 궁합 계산 (20점)
     */
    _calculateSinsalGunghap(saju1, saju2, positivePoints, negativePoints) {
        let score = 10; // 기본 점수

        // 오행 균형으로 판단
        const ohaeng1Count = Object.values(saju1.ohaeng).filter(v => v > 0).length;
        const ohaeng2Count = Object.values(saju2.ohaeng).filter(v => v > 0).length;

        if (ohaeng1Count >= 4 && ohaeng2Count >= 4) {
            score += 5;
            positivePoints.push('양쪽 모두 오행이 고르게 분포됨');
        }

        if (ohaeng1Count <= 2 || ohaeng2Count <= 2) {
            score -= 3;
            negativePoints.push('한 쪽의 오행이 편중됨');
        }

        return Math.max(0, Math.min(20, score));
    }

    /**
     * 종합 평가
     */
    _getSummary(totalScore) {
        if (totalScore >= 90) {
            return '천생연분! 매우 궁합이 좋습니다. 서로를 보완하고 조화롭게 지낼 수 있습니다.';
        } else if (totalScore >= 75) {
            return '좋은 궁합입니다. 서로 노력한다면 행복한 관계를 유지할 수 있습니다.';
        } else if (totalScore >= 60) {
            return '보통 궁합입니다. 서로의 차이를 이해하고 존중한다면 좋은 관계가 될 수 있습니다.';
        } else if (totalScore >= 45) {
            return '조금 어려운 궁합입니다. 많은 이해와 노력이 필요합니다.';
        } else {
            return '궁합이 맞지 않는 편입니다. 서로의 단점을 보완하는 노력이 매우 필요합니다.';
        }
    }

    /**
     * 궁합 등급
     */
    _getGrade(score) {
        if (score >= 90) return 'S';
        if (score >= 75) return 'A';
        if (score >= 60) return 'B';
        if (score >= 45) return 'C';
        return 'D';
    }

    /**
     * 궁합 등급 색상
     */
    getGradeColor(score) {
        if (score >= 90) return '#FFD700'; // 금색
        if (score >= 75) return '#4CAF50'; // 초록색
        if (score >= 60) return '#2196F3'; // 파란색
        if (score >= 45) return '#FF9800'; // 주황색
        return '#F44336'; // 빨간색
    }
}
