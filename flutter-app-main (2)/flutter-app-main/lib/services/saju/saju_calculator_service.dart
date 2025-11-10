import '../../models/saju/saju.dart';
import '../../models/saju/pillar.dart';
import '../../constants/saju/saju_constants.dart';

/// 사주 계산 서비스
class SajuCalculatorService {
  /// 사주팔자 전체 계산
  Future<Saju> calculateSaju({
    required DateTime birthDateTime,
    required bool isMale,
  }) async {
    // 년주 계산
    final yearPillar = _calculateYearPillar(birthDateTime);

    // 월주 계산
    final monthPillar = _calculateMonthPillar(birthDateTime);

    // 일주 계산
    final dayPillar = _calculateDayPillar(birthDateTime);

    // 시주 계산
    final timePillar = _calculateTimePillar(birthDateTime, dayPillar.cheongan);

    // 대운 계산
    final daeun = _calculateDaeun(monthPillar, isMale, birthDateTime);

    // 세운 계산 (현재부터 10년)
    final seun = _calculateSeun(birthDateTime.year);

    // 월운 계산 (현재 연도 기준)
    final wolun = _calculateWolun(DateTime.now().year);

    return Saju(
      birthDateTime: birthDateTime,
      lunarBirthDate: null, // TODO: 음력 변환 구현 필요
      isMale: isMale,
      yearPillar: yearPillar,
      monthPillar: monthPillar,
      dayPillar: dayPillar,
      timePillar: timePillar,
      daeun: daeun,
      seun: seun,
      wolun: wolun,
    );
  }

  /// 년주 계산 (입춘 기준)
  Pillar _calculateYearPillar(DateTime date) {
    // 입춘은 대략 2월 4일경
    // 입춘 이전이면 전년도의 간지를 사용
    int year = date.year;

    // 간단한 입춘 판정 (2월 4일 기준)
    // TODO: 정확한 절기 시각 데이터 필요
    if (date.month == 1 || (date.month == 2 && date.day < 4)) {
      year = year - 1;
    }

    // 기준년도 1984년(갑자년)부터 계산
    const baseYear = 1984;
    final yearDiff = year - baseYear;
    final ganzhiIndex = yearDiff % 60;
    final adjustedIndex = (ganzhiIndex + 60) % 60; // 음수 방지

    return _ganzhiToPillar(SajuConstants.sixtyGanzhi[adjustedIndex]);
  }

  /// 월주 계산 (절기 기준)
  Pillar _calculateMonthPillar(DateTime date) {
    // 월주는 절기 기준으로 결정됨
    // 입춘(1월), 경칩(2월), 청명(3월), 입하(4월), 망종(5월), 소서(6월)
    // 입추(7월), 백로(8월), 한로(9월), 입동(10월), 대설(11월), 소한(12월)

    // 간단한 구현: 절기를 각 월 초로 근사
    // TODO: 정확한 절기 시각 데이터 필요
    int monthIndex = date.month - 1;
    if (date.day < 6) { // 절기가 대략 6일경
      monthIndex = (monthIndex - 1 + 12) % 12;
    }

    // 기준: 1901년 1월 = 기축
    const baseYear = 1901;
    const baseIndex = 25; // 기축의 인덱스

    final totalMonths = (date.year - baseYear) * 12 + monthIndex;
    final ganzhiIndex = (baseIndex + totalMonths) % 60;

    return _ganzhiToPillar(SajuConstants.sixtyGanzhi[ganzhiIndex]);
  }

  /// 일주 계산
  Pillar _calculateDayPillar(DateTime date) {
    // 기준일: 1900년 1월 1일 = 경인일
    final baseDate = DateTime(1900, 1, 1);
    const baseIndex = 26; // 경인의 인덱스

    // 날짜 차이 계산
    final daysDiff = date.difference(baseDate).inDays;
    final ganzhiIndex = (baseIndex + daysDiff) % 60;
    final adjustedIndex = (ganzhiIndex + 60) % 60; // 음수 방지

    return _ganzhiToPillar(SajuConstants.sixtyGanzhi[adjustedIndex]);
  }

  /// 시주 계산
  Pillar _calculateTimePillar(DateTime date, String dayCheongan) {
    // 시간을 지지로 변환
    final hour = date.hour;
    final timeJiji = SajuConstants.jijiTime[hour] ?? '자';

    // 일간에 따른 시간 천간 계산
    // 갑/기일: 갑자시부터 시작
    // 을/경일: 병자시부터 시작
    // 병/신일: 무자시부터 시작
    // 정/임일: 경자시부터 시작
    // 무/계일: 임자시부터 시작

    final Map<String, int> dayCheonganOffset = {
      '갑': 0, '기': 0,
      '을': 2, '경': 2,
      '병': 4, '신': 4,
      '정': 6, '임': 6,
      '무': 8, '계': 8,
    };

    final offset = dayCheonganOffset[dayCheongan] ?? 0;
    final jijiIndex = SajuConstants.jiji.indexOf(timeJiji);
    final cheonganIndex = (offset + jijiIndex) % 10;

    final timeCheongan = SajuConstants.cheongan[cheonganIndex];

    return Pillar(
      cheongan: timeCheongan,
      jiji: timeJiji,
    );
  }

  /// 대운 계산
  List<DaeunInfo> _calculateDaeun(Pillar monthPillar, bool isMale, DateTime birthDate) {
    // 대운은 월주를 기준으로 10년 단위로 진행
    // 남자 양년생, 여자 음년생: 순행
    // 남자 음년생, 여자 양년생: 역행

    final yearGanIndex = (birthDate.year - 4) % 10; // 천간 인덱스
    final isYangYear = yearGanIndex % 2 == 0; // 양년생 판정

    final isForward = (isMale && isYangYear) || (!isMale && !isYangYear);

    final monthGanzhi = monthPillar.ganzhi;
    final monthIndex = SajuConstants.sixtyGanzhi.indexOf(monthGanzhi);

    final List<DaeunInfo> daeunList = [];
    int startAge = 1; // 대운 시작 나이 (간단하게 1세부터)

    for (int i = 0; i < 10; i++) {
      int ganzhiIndex;
      if (isForward) {
        ganzhiIndex = (monthIndex + i + 1) % 60;
      } else {
        ganzhiIndex = (monthIndex - i - 1 + 60) % 60;
      }

      daeunList.add(DaeunInfo(
        startAge: startAge,
        endAge: startAge + 9,
        ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex],
      ));

      startAge += 10;
    }

    return daeunList;
  }

  /// 세운 계산 (연운)
  List<SeunInfo> _calculateSeun(int birthYear) {
    final currentYear = DateTime.now().year;
    final List<SeunInfo> seunList = [];

    // 현재 연도부터 향후 10년
    for (int i = 0; i < 10; i++) {
      final year = currentYear + i;
      final yearDiff = year - 1984; // 1984년 갑자년 기준
      final ganzhiIndex = (yearDiff % 60 + 60) % 60;

      seunList.add(SeunInfo(
        year: year,
        ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex],
      ));
    }

    return seunList;
  }

  /// 월운 계산
  List<WolunInfo> _calculateWolun(int year) {
    // 기준: 1901년 1월 = 기축
    const baseYear = 1901;
    const baseIndex = 25; // 기축의 인덱스

    final List<WolunInfo> wolunList = [];

    for (int month = 1; month <= 12; month++) {
      final totalMonths = (year - baseYear) * 12 + (month - 1);
      final ganzhiIndex = (baseIndex + totalMonths) % 60;

      wolunList.add(WolunInfo(
        month: month,
        ganzhi: SajuConstants.sixtyGanzhi[ganzhiIndex],
      ));
    }

    return wolunList;
  }

  /// 간지 문자열을 Pillar 객체로 변환
  Pillar _ganzhiToPillar(String ganzhi) {
    if (ganzhi.length != 2) {
      throw ArgumentError('Invalid ganzhi: $ganzhi');
    }

    return Pillar(
      cheongan: ganzhi[0],
      jiji: ganzhi[1],
    );
  }
}
