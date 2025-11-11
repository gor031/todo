// 사주 상수 데이터
const SajuConstants = {
    // 10천간
    cheongan: ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'],

    // 12지지
    jiji: ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'],

    // 60갑자
    sixtyGanzhi: [
        '갑자', '을축', '병인', '정묘', '무진', '기사', '경오', '신미', '임신', '계유',
        '갑술', '을해', '병자', '정축', '무인', '기묘', '경진', '신사', '임오', '계미',
        '갑신', '을유', '병술', '정해', '무자', '기축', '경인', '신묘', '임진', '계사',
        '갑오', '을미', '병신', '정유', '무술', '기해', '경자', '신축', '임인', '계묘',
        '갑진', '을사', '병오', '정미', '무신', '기유', '경술', '신해', '임자', '계축',
        '갑인', '을묘', '병진', '정사', '무오', '기미', '경신', '신유', '임술', '계해'
    ],

    // 천간 오행
    cheonganOhaeng: {
        '갑': '목', '을': '목',
        '병': '화', '정': '화',
        '무': '토', '기': '토',
        '경': '금', '신': '금',
        '임': '수', '계': '수'
    },

    // 지지 오행
    jijiOhaeng: {
        '자': '수', '해': '수',
        '인': '목', '묘': '목',
        '사': '화', '오': '화',
        '신': '금', '유': '금',
        '축': '토', '진': '토', '미': '토', '술': '토'
    },

    // 오행 상생
    ohaengSangsaeng: {
        '목': '화', '화': '토', '토': '금', '금': '수', '수': '목'
    },

    // 오행 상극
    ohaengSanggeuk: {
        '목': '토', '토': '수', '수': '화', '화': '금', '금': '목'
    },

    // 지지 충
    jijiChung: {
        '자': '오', '축': '미', '인': '신', '묘': '유', '진': '술', '사': '해',
        '오': '자', '미': '축', '신': '인', '유': '묘', '술': '진', '해': '사'
    },

    // 12지지 시간
    jijiTime: {
        23: '자', 0: '자', 1: '축', 2: '축',
        3: '인', 4: '인', 5: '묘', 6: '묘',
        7: '진', 8: '진', 9: '사', 10: '사',
        11: '오', 12: '오', 13: '미', 14: '미',
        15: '신', 16: '신', 17: '유', 18: '유',
        19: '술', 20: '술', 21: '해', 22: '해'
    }
};

// 사주 계산 클래스
class SajuCalculator {
    // 년주 계산 (입춘 기준)
    calculateYearPillar(date) {
        let year = date.getFullYear();

        // 간단한 입춘 판정 (2월 4일 기준)
        if (date.getMonth() === 0 || (date.getMonth() === 1 && date.getDate() < 4)) {
            year = year - 1;
        }

        const baseYear = 1984;
        const yearDiff = year - baseYear;
        const ganzhiIndex = ((yearDiff % 60) + 60) % 60;

        return this.ganzhiToPillar(SajuConstants.sixtyGanzhi[ganzhiIndex]);
    }

    // 월주 계산 (절기 기준)
    calculateMonthPillar(date) {
        let monthIndex = date.getMonth();
        if (date.getDate() < 6) {
            monthIndex = (monthIndex - 1 + 12) % 12;
        }

        const baseYear = 1901;
        const baseIndex = 25; // 기축
        const totalMonths = (date.getFullYear() - baseYear) * 12 + monthIndex;
        const ganzhiIndex = (baseIndex + totalMonths) % 60;

        return this.ganzhiToPillar(SajuConstants.sixtyGanzhi[ganzhiIndex]);
    }

    // 일주 계산
    calculateDayPillar(date) {
        const baseDate = new Date(1900, 0, 1);
        const baseIndex = 26; // 경인

        const daysDiff = Math.floor((date - baseDate) / (1000 * 60 * 60 * 24));
        const ganzhiIndex = ((baseIndex + daysDiff) % 60 + 60) % 60;

        return this.ganzhiToPillar(SajuConstants.sixtyGanzhi[ganzhiIndex]);
    }

    // 시주 계산
    calculateTimePillar(date, dayCheongan) {
        const hour = date.getHours();
        const timeJiji = SajuConstants.jijiTime[hour] || '자';

        const dayCheonganOffset = {
            '갑': 0, '기': 0,
            '을': 2, '경': 2,
            '병': 4, '신': 4,
            '정': 6, '임': 6,
            '무': 8, '계': 8
        };

        const offset = dayCheonganOffset[dayCheongan] || 0;
        const jijiIndex = SajuConstants.jiji.indexOf(timeJiji);
        const cheonganIndex = (offset + jijiIndex) % 10;
        const timeCheongan = SajuConstants.cheongan[cheonganIndex];

        return { cheongan: timeCheongan, jiji: timeJiji, ganzhi: timeCheongan + timeJiji };
    }

    // 대운 계산
    calculateDaeun(monthPillar, isMale, birthDate) {
        const year = birthDate.getFullYear();
        const yearGanIndex = (year - 4) % 10;
        const isYangYear = yearGanIndex % 2 === 0;
        const isForward = (isMale && isYangYear) || (!isMale && !isYangYear);

        const monthIndex = SajuConstants.sixtyGanzhi.indexOf(monthPillar.ganzhi);
        const daeunList = [];
        let startAge = 1;

        for (let i = 0; i < 10; i++) {
            let ganzhiIndex;
            if (isForward) {
                ganzhiIndex = (monthIndex + i + 1) % 60;
            } else {
                ganzhiIndex = ((monthIndex - i - 1) % 60 + 60) % 60;
            }

            daeunList.push({
                startAge: startAge,
                endAge: startAge + 9,
                ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex]
            });

            startAge += 10;
        }

        return daeunList;
    }

    // 세운 계산
    calculateSeun() {
        const currentYear = new Date().getFullYear();
        const seunList = [];

        for (let i = 0; i < 10; i++) {
            const year = currentYear + i;
            const yearDiff = year - 1984;
            const ganzhiIndex = ((yearDiff % 60) + 60) % 60;

            seunList.push({
                year: year,
                ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex]
            });
        }

        return seunList;
    }

    // 월운 계산
    calculateWolun(year) {
        const baseYear = 1901;
        const baseIndex = 25; // 기축
        const wolunList = [];

        for (let month = 1; month <= 12; month++) {
            const totalMonths = (year - baseYear) * 12 + (month - 1);
            const ganzhiIndex = (baseIndex + totalMonths) % 60;

            wolunList.push({
                month: month,
                ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex]
            });
        }

        return wolunList;
    }

    // 오행 분석
    analyzeOhaeng(yearPillar, monthPillar, dayPillar, timePillar) {
        const ohaeng = { '목': 0, '화': 0, '토': 0, '금': 0, '수': 0 };

        const pillars = [yearPillar, monthPillar, dayPillar, timePillar];
        pillars.forEach(pillar => {
            ohaeng[SajuConstants.cheonganOhaeng[pillar.cheongan]]++;
            ohaeng[SajuConstants.jijiOhaeng[pillar.jiji]]++;
        });

        return ohaeng;
    }

    // 간지를 Pillar로 변환
    ganzhiToPillar(ganzhi) {
        return {
            cheongan: ganzhi[0],
            jiji: ganzhi[1],
            ganzhi: ganzhi
        };
    }

    // 전체 사주 계산
    calculate(birthDate, isMale) {
        const yearPillar = this.calculateYearPillar(birthDate);
        const monthPillar = this.calculateMonthPillar(birthDate);
        const dayPillar = this.calculateDayPillar(birthDate);
        const timePillar = this.calculateTimePillar(birthDate, dayPillar.cheongan);

        const daeun = this.calculateDaeun(monthPillar, isMale, birthDate);
        const seun = this.calculateSeun();
        const wolun = this.calculateWolun(new Date().getFullYear());
        const ohaeng = this.analyzeOhaeng(yearPillar, monthPillar, dayPillar, timePillar);

        return {
            birthDate: birthDate,
            isMale: isMale,
            yearPillar: yearPillar,
            monthPillar: monthPillar,
            dayPillar: dayPillar,
            timePillar: timePillar,
            ilgan: dayPillar.cheongan,
            sajuString: `${yearPillar.ganzhi} ${monthPillar.ganzhi} ${dayPillar.ganzhi} ${timePillar.ganzhi}`,
            daeun: daeun,
            seun: seun,
            wolun: wolun,
            ohaeng: ohaeng
        };
    }
}
