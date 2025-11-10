/// 음력 날짜 정보
class LunarDate {
  final int year; // 음력 년
  final int month; // 음력 월
  final int day; // 음력 일
  final bool isLeapMonth; // 윤달 여부

  LunarDate({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
  });

  @override
  String toString() {
    final leap = isLeapMonth ? '(윤)' : '';
    return '음력 $year년 $month월$leap $day일';
  }
}

/// 음력-양력 변환 서비스
/// 간단한 알고리즘 사용 (2020-2030년)
class LunarCalendarService {
  // 음력 데이터: 각 년도의 음력 정보
  // 비트 형식: 하위 12비트는 각 월의 큰달(30일)/작은달(29일) 정보
  // 상위 4비트는 윤달이 있는 월 (0이면 윤달 없음)
  static final Map<int, int> _lunarInfo = {
    2020: 0x2b5a6, // 윤4월
    2021: 0x0d4ae,
    2022: 0x0d95b, // 윤2월
    2023: 0x25aa4,
    2024: 0x256d3, // 윤2월
    2025: 0x0b

575,
    2026: 0x0d4bb, // 윤7월
    2027: 0x0a4ae,
    2028: 0x2d493, // 윤5월
    2029: 0x0b557,
    2030: 0x06aab, // 윤6월
  };

  // 양력 기준일 (2020년 1월 1일 = 음력 2019년 12월 7일)
  static final DateTime _baseDate = DateTime(2020, 1, 1);
  static const int _baseLunarYear = 2019;
  static const int _baseLunarMonth = 12;
  static const int _baseLunarDay = 7;

  /// 양력을 음력으로 변환
  static LunarDate solarToLunar(DateTime solarDate) {
    // 간단한 근사 계산 (정확하지 않음)
    // 실제로는 복잡한 천문 계산이 필요

    final year = solarDate.year;
    final month = solarDate.month;
    final day = solarDate.day;

    // 음력은 양력보다 약 1개월 늦음
    int lunarYear = year;
    int lunarMonth = month - 1;
    int lunarDay = day;

    if (lunarMonth <= 0) {
      lunarYear--;
      lunarMonth = 12;
    }

    // 간단한 조정
    if (day > 15) {
      lunarDay = day - 1;
    }

    return LunarDate(
      year: lunarYear,
      month: lunarMonth,
      day: lunarDay,
      isLeapMonth: false,
    );
  }

  /// 음력을 양력으로 변환
  static DateTime lunarToSolar({
    required int year,
    required int month,
    required int day,
    bool isLeapMonth = false,
  }) {
    // 간단한 근사 계산
    int solarYear = year;
    int solarMonth = month + 1;
    int solarDay = day;

    if (solarMonth > 12) {
      solarYear++;
      solarMonth = 1;
    }

    // 간단한 조정
    if (day > 15) {
      solarDay = day + 1;
    }

    return DateTime(solarYear, solarMonth, solarDay);
  }

  /// 특정 년도의 윤달 정보 가져오기 (0이면 윤달 없음)
  static int getLeapMonth(int year) {
    final info = _lunarInfo[year];
    if (info == null) return 0;
    return (info >> 16) & 0x0f;
  }

  /// 특정 년도, 월의 날짜 수 가져오기
  static int getMonthDays(int year, int month, {bool isLeapMonth = false}) {
    final info = _lunarInfo[year];
    if (info == null) return 29;

    if (isLeapMonth) {
      // 윤달의 날짜 수
      return (info & 0x10000) != 0 ? 30 : 29;
    }

    // 일반 월의 날짜 수
    return (info & (1 << (month - 1))) != 0 ? 30 : 29;
  }

  /// 음력 날짜 유효성 검사
  static bool isValidLunarDate({
    required int year,
    required int month,
    required int day,
    bool isLeapMonth = false,
  }) {
    if (year < 2020 || year > 2030) return false;
    if (month < 1 || month > 12) return false;

    if (isLeapMonth) {
      if (getLeapMonth(year) != month) return false;
    }

    final maxDays = getMonthDays(year, month, isLeapMonth: isLeapMonth);
    return day >= 1 && day <= maxDays;
  }
}
