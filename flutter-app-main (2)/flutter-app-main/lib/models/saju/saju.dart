import 'pillar.dart';

/// 사주팔자 모델
class Saju {
  final DateTime birthDateTime; // 생년월일시 (양력)
  final DateTime? lunarBirthDate; // 음력 생년월일
  final bool isMale; // 성별 (남성 여부)

  final Pillar yearPillar; // 년주
  final Pillar monthPillar; // 월주
  final Pillar dayPillar; // 일주
  final Pillar timePillar; // 시주

  final List<DaeunInfo> daeun; // 대운
  final List<SeunInfo> seun; // 세운
  final List<WolunInfo> wolun; // 월운

  Saju({
    required this.birthDateTime,
    this.lunarBirthDate,
    required this.isMale,
    required this.yearPillar,
    required this.monthPillar,
    required this.dayPillar,
    required this.timePillar,
    required this.daeun,
    required this.seun,
    required this.wolun,
  });

  // 일간 (일주의 천간)
  String get ilgan => dayPillar.cheongan;

  // 사주팔자 전체 문자열
  String get sajuString {
    return '${yearPillar.ganzhi} ${monthPillar.ganzhi} ${dayPillar.ganzhi} ${timePillar.ganzhi}';
  }

  // 오행 분석
  Map<String, int> get ohaengAnalysis {
    final Map<String, int> ohaeng = {
      '목': 0,
      '화': 0,
      '토': 0,
      '금': 0,
      '수': 0,
    };

    // 천간 오행
    ohaeng[yearPillar.cheonganOhaeng] = (ohaeng[yearPillar.cheonganOhaeng] ?? 0) + 1;
    ohaeng[monthPillar.cheonganOhaeng] = (ohaeng[monthPillar.cheonganOhaeng] ?? 0) + 1;
    ohaeng[dayPillar.cheonganOhaeng] = (ohaeng[dayPillar.cheonganOhaeng] ?? 0) + 1;
    ohaeng[timePillar.cheonganOhaeng] = (ohaeng[timePillar.cheonganOhaeng] ?? 0) + 1;

    // 지지 오행
    ohaeng[yearPillar.jijiOhaeng] = (ohaeng[yearPillar.jijiOhaeng] ?? 0) + 1;
    ohaeng[monthPillar.jijiOhaeng] = (ohaeng[monthPillar.jijiOhaeng] ?? 0) + 1;
    ohaeng[dayPillar.jijiOhaeng] = (ohaeng[dayPillar.jijiOhaeng] ?? 0) + 1;
    ohaeng[timePillar.jijiOhaeng] = (ohaeng[timePillar.jijiOhaeng] ?? 0) + 1;

    return ohaeng;
  }

  Map<String, dynamic> toJson() {
    return {
      'birthDateTime': birthDateTime.toIso8601String(),
      'lunarBirthDate': lunarBirthDate?.toIso8601String(),
      'isMale': isMale,
      'yearPillar': yearPillar.toJson(),
      'monthPillar': monthPillar.toJson(),
      'dayPillar': dayPillar.toJson(),
      'timePillar': timePillar.toJson(),
      'daeun': daeun.map((d) => d.toJson()).toList(),
      'seun': seun.map((s) => s.toJson()).toList(),
      'wolun': wolun.map((w) => w.toJson()).toList(),
    };
  }
}

/// 대운 정보
class DaeunInfo {
  final int startAge; // 시작 나이
  final int endAge; // 종료 나이
  final String ganzhi; // 간지

  DaeunInfo({
    required this.startAge,
    required this.endAge,
    required this.ganzhi,
  });

  Map<String, dynamic> toJson() {
    return {
      'startAge': startAge,
      'endAge': endAge,
      'ganzhi': ganzhi,
    };
  }
}

/// 세운 정보
class SeunInfo {
  final int year; // 연도
  final String ganzhi; // 간지

  SeunInfo({
    required this.year,
    required this.ganzhi,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'ganzhi': ganzhi,
    };
  }
}

/// 월운 정보
class WolunInfo {
  final int month; // 월 (1-12)
  final String ganzhi; // 간지

  WolunInfo({
    required this.month,
    required this.ganzhi,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'ganzhi': ganzhi,
    };
  }
}
