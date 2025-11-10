import '../../constants/saju/saju_constants.dart';

/// 절기 정보
class SolarTermInfo {
  final String name; // 절기 이름
  final DateTime dateTime; // 절기 시각

  SolarTermInfo({
    required this.name,
    required this.dateTime,
  });
}

/// 절기 계산 서비스
/// 한국천문연구원 데이터 기반 (2020-2030년)
class SolarTermService {
  // 년도별 24절기 데이터 (MM-DD HH:mm 형식)
  static final Map<int, Map<String, String>> _solarTermData = {
    2024: {
      '입춘': '02-04 17:27',
      '우수': '02-19 13:13',
      '경칩': '03-05 11:23',
      '춘분': '03-20 12:06',
      '청명': '04-04 16:02',
      '곡우': '04-19 22:59',
      '입하': '05-05 09:10',
      '소만': '05-20 21:59',
      '망종': '06-05 13:10',
      '하지': '06-21 05:51',
      '소서': '07-06 23:20',
      '대서': '07-22 16:44',
      '입추': '08-07 14:09',
      '처서': '08-22 23:55',
      '백로': '09-07 12:11',
      '추분': '09-22 21:44',
      '한로': '10-08 09:00',
      '상강': '10-23 01:15',
      '입동': '11-07 01:20',
      '소설': '11-22 03:56',
      '대설': '12-07 06:17',
      '동지': '12-21 18:21',
      '소한': '01-06 05:49',
      '대한': '01-20 23:07',
    },
    2025: {
      '입춘': '02-03 23:10',
      '우수': '02-18 19:06',
      '경칩': '03-05 17:07',
      '춘분': '03-20 18:01',
      '청명': '04-04 21:48',
      '곡우': '04-20 04:56',
      '입하': '05-05 15:00',
      '소만': '05-21 03:54',
      '망종': '06-05 19:00',
      '하지': '06-21 11:42',
      '소서': '07-07 05:05',
      '대서': '07-22 22:30',
      '입추': '08-07 19:52',
      '처서': '08-23 05:34',
      '백로': '09-07 17:52',
      '추분': '09-23 03:19',
      '한로': '10-08 14:47',
      '상강': '10-23 06:51',
      '입동': '11-07 07:04',
      '소설': '11-22 09:35',
      '대설': '12-07 11:44',
      '동지': '12-21 23:03',
      '소한': '01-05 11:23',
      '대한': '01-20 04:47',
    },
    2026: {
      '입춘': '02-04 04:59',
      '우수': '02-19 00:52',
      '경칩': '03-05 22:52',
      '춘분': '03-20 23:46',
      '청명': '04-05 03:39',
      '곡우': '04-20 10:39',
      '입하': '05-05 20:53',
      '소만': '05-21 09:37',
      '망종': '06-06 00:50',
      '하지': '06-21 17:24',
      '소서': '07-07 10:54',
      '대서': '07-23 04:13',
      '입추': '08-08 01:41',
      '처서': '08-23 11:19',
      '백로': '09-07 23:43',
      '추분': '09-23 09:05',
      '한로': '10-08 20:38',
      '상강': '10-23 12:37',
      '입동': '11-07 12:58',
      '소설': '11-22 15:22',
      '대설': '12-07 17:36',
      '동지': '12-22 04:50',
      '소한': '01-05 17:17',
      '대한': '01-20 10:35',
    },
    2023: {
      '입춘': '02-04 11:43',
      '우수': '02-19 07:34',
      '경칩': '03-06 05:36',
      '춘분': '03-21 06:24',
      '청명': '04-05 10:13',
      '곡우': '04-20 17:14',
      '입하': '05-06 03:19',
      '소만': '05-21 16:09',
      '망종': '06-06 07:18',
      '하지': '06-21 23:58',
      '소서': '07-07 17:31',
      '대서': '07-23 10:50',
      '입추': '08-08 08:23',
      '처서': '08-23 18:01',
      '백로': '09-08 06:27',
      '추분': '09-23 15:50',
      '한로': '10-08 03:16',
      '상강': '10-23 19:21',
      '입동': '11-07 19:35',
      '소설': '11-22 22:03',
      '대설': '12-07 00:33',
      '동지': '12-22 12:27',
      '소한': '01-05 23:55',
      '대한': '01-20 17:30',
    },
    2022: {
      '입춘': '02-04 05:51',
      '우수': '02-19 01:43',
      '경칩': '03-05 23:44',
      '춘분': '03-21 00:33',
      '청명': '04-05 04:20',
      '곡우': '04-20 11:24',
      '입하': '05-05 21:26',
      '소만': '05-21 10:23',
      '망종': '06-06 01:26',
      '하지': '06-21 18:14',
      '소서': '07-07 11:38',
      '대서': '07-23 05:07',
      '입추': '08-08 02:29',
      '처서': '08-23 12:16',
      '백로': '09-08 00:32',
      '추분': '09-23 10:04',
      '한로': '10-08 21:22',
      '상강': '10-23 13:36',
      '입동': '11-07 13:45',
      '소설': '11-22 16:20',
      '대설': '12-07 18:46',
      '동지': '12-22 06:48',
      '소한': '01-05 18:14',
      '대한': '01-20 11:39',
    },
  };

  /// 특정 년도의 모든 절기 정보 가져오기
  static List<SolarTermInfo> getSolarTerms(int year) {
    final data = _solarTermData[year];
    if (data == null) {
      throw Exception('해당 년도($year)의 절기 데이터가 없습니다. (2022-2026년만 지원)');
    }

    final List<SolarTermInfo> terms = [];
    for (final termName in SajuConstants.solarTerms) {
      final dateTimeStr = data[termName];
      if (dateTimeStr != null) {
        final dateTime = _parseDateTime(year, dateTimeStr);
        terms.add(SolarTermInfo(
          name: termName,
          dateTime: dateTime,
        ));
      }
    }

    return terms;
  }

  /// 특정 절기의 시각 가져오기
  static DateTime? getSolarTerm(int year, String termName) {
    final data = _solarTermData[year];
    if (data == null) return null;

    final dateTimeStr = data[termName];
    if (dateTimeStr == null) return null;

    return _parseDateTime(year, dateTimeStr);
  }

  /// 입춘 시각 가져오기 (년주 계산에 사용)
  static DateTime? getIpchun(int year) {
    return getSolarTerm(year, '입춘');
  }

  /// 특정 날짜가 속한 월의 절기 가져오기 (월주 계산에 사용)
  static SolarTermInfo? getMonthSolarTerm(DateTime date) {
    final year = date.year;
    final terms = getSolarTerms(year);

    // 12절기만 필터링 (홀수 번째 절기)
    final monthTerms = terms
        .where((t) => SajuConstants.monthSolarTerms.contains(t.name))
        .toList();

    // 현재 날짜 이전의 가장 최근 절기 찾기
    SolarTermInfo? currentTerm;
    for (final term in monthTerms) {
      if (date.isAfter(term.dateTime) || date.isAtSameMomentAs(term.dateTime)) {
        currentTerm = term;
      } else {
        break;
      }
    }

    // 현재 년도에서 못 찾았으면 이전 년도의 소한 확인
    if (currentTerm == null && date.month == 1) {
      final prevYearTerms = getSolarTerms(year - 1);
      final sohan = prevYearTerms.firstWhere((t) => t.name == '소한');
      if (date.isAfter(sohan.dateTime) || date.isAtSameMomentAs(sohan.dateTime)) {
        currentTerm = sohan;
      }
    }

    return currentTerm;
  }

  /// MM-DD HH:mm 형식의 문자열을 DateTime으로 변환
  static DateTime _parseDateTime(int year, String dateTimeStr) {
    final parts = dateTimeStr.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    final month = int.parse(dateParts[0]);
    final day = int.parse(dateParts[1]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // 소한, 대한은 다음 년도 1월이지만 전년도 데이터에 포함
    int actualYear = year;
    if (month == 1) {
      actualYear = year + 1;
    }

    return DateTime(actualYear, month, day, hour, minute);
  }

  /// 절기 인덱스 가져오기 (0~11, 입춘=0)
  static int getMonthSolarTermIndex(String termName) {
    return SajuConstants.monthSolarTerms.indexOf(termName);
  }
}
