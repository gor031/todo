import '../../constants/saju/saju_constants.dart';

/// 십성 정보
class SipseongInfo {
  final String cheongan; // 천간
  final String sipseong; // 십성 이름
  final String category; // 십성 분류 (비겁, 식상, 재성, 관성, 인성)

  SipseongInfo({
    required this.cheongan,
    required this.sipseong,
    required this.category,
  });
}

/// 십성 계산 서비스
class SipseongService {
  /// 일간을 기준으로 다른 천간의 십성 계산
  static String calculateSipseong(String ilgan, String targetCheongan) {
    // 같은 천간이면 비견
    if (ilgan == targetCheongan) {
      return '비견';
    }

    // 일간과 대상의 오행, 음양 가져오기
    final ilganOhaeng = SajuConstants.cheonganOhaeng[ilgan]!;
    final ilganYinYang = SajuConstants.cheonganYinYang[ilgan]!;
    final targetOhaeng = SajuConstants.cheonganOhaeng[targetCheongan]!;
    final targetYinYang = SajuConstants.cheonganYinYang[targetCheongan]!;

    // 같은 음양인지 확인
    final sameYinYang = ilganYinYang == targetYinYang;

    // 오행 관계 확인
    if (ilganOhaeng == targetOhaeng) {
      // 같은 오행
      return sameYinYang ? '비견' : '겁재';
    } else if (SajuConstants.ohaengSangsaeng[ilganOhaeng] == targetOhaeng) {
      // 내가 생하는 오행
      return sameYinYang ? '식신' : '상관';
    } else if (SajuConstants.ohaengSanggeuk[ilganOhaeng] == targetOhaeng) {
      // 내가 극하는 오행
      return sameYinYang ? '편재' : '정재';
    } else if (SajuConstants.ohaengSanggeuk[targetOhaeng] == ilganOhaeng) {
      // 나를 극하는 오행
      return sameYinYang ? '편관(칠살)' : '정관';
    } else if (SajuConstants.ohaengSangsaeng[targetOhaeng] == ilganOhaeng) {
      // 나를 생하는 오행
      return sameYinYang ? '편인(도식)' : '정인';
    }

    return '알 수 없음';
  }

  /// 십성 카테고리 가져오기
  static String getSipseongCategory(String sipseong) {
    if (sipseong.contains('비견') || sipseong.contains('겁재')) {
      return '비겁';
    } else if (sipseong.contains('식신') || sipseong.contains('상관')) {
      return '식상';
    } else if (sipseong.contains('편재') || sipseong.contains('정재')) {
      return '재성';
    } else if (sipseong.contains('편관') || sipseong.contains('정관')) {
      return '관성';
    } else if (sipseong.contains('편인') || sipseong.contains('정인')) {
      return '인성';
    }
    return '알 수 없음';
  }

  /// 십성 설명 가져오기
  static String getSipseongDescription(String sipseong) {
    const descriptions = {
      '비견': '나와 같은 기운. 형제, 동료, 경쟁자를 나타냄',
      '겁재': '나의 재물을 빼앗는 기운. 경쟁, 투쟁을 나타냄',
      '식신': '내가 생산하는 기운. 의식주, 안정, 복을 나타냄',
      '상관': '관성을 상하게 하는 기운. 재능, 표현력, 반항을 나타냄',
      '편재': '움직이는 재물. 사업, 투자, 유동성 재산을 나타냄',
      '정재': '고정된 재물. 월급, 부동산, 아내(남자의 경우)를 나타냄',
      '편관(칠살)': '나를 제압하는 기운. 권력, 압박, 무관(武官)을 나타냄',
      '정관': '나를 다스리는 기운. 명예, 직장, 남편(여자의 경우)을 나타냄',
      '편인(도식)': '편파적으로 생해주는 기운. 학문, 종교, 계모를 나타냄',
      '정인': '정통으로 생해주는 기운. 학식, 명예, 어머니를 나타냄',
    };

    return descriptions[sipseong] ?? '설명 없음';
  }

  /// 십성 색상 가져오기 (UI에서 사용)
  static String getSipseongColor(String category) {
    const colors = {
      '비겁': '#4CAF50', // 녹색
      '식상': '#FF9800', // 주황색
      '재성': '#F44336', // 빨간색
      '관성': '#2196F3', // 파란색
      '인성': '#9C27B0', // 보라색
    };

    return colors[category] ?? '#757575'; // 기본 회색
  }

  /// 사주의 모든 십성 계산
  static Map<String, SipseongInfo> calculateAllSipseong({
    required String ilgan,
    required String yearCheongan,
    required String monthCheongan,
    required String dayCheongan,
    required String timeCheongan,
  }) {
    return {
      '년간': SipseongInfo(
        cheongan: yearCheongan,
        sipseong: calculateSipseong(ilgan, yearCheongan),
        category: getSipseongCategory(calculateSipseong(ilgan, yearCheongan)),
      ),
      '월간': SipseongInfo(
        cheongan: monthCheongan,
        sipseong: calculateSipseong(ilgan, monthCheongan),
        category: getSipseongCategory(calculateSipseong(ilgan, monthCheongan)),
      ),
      '일간': SipseongInfo(
        cheongan: dayCheongan,
        sipseong: '일간(나)',
        category: '일간',
      ),
      '시간': SipseongInfo(
        cheongan: timeCheongan,
        sipseong: calculateSipseong(ilgan, timeCheongan),
        category: getSipseongCategory(calculateSipseong(ilgan, timeCheongan)),
      ),
    };
  }

  /// 십성 통계 계산
  static Map<String, int> calculateSipseongStats(Map<String, SipseongInfo> allSipseong) {
    final stats = <String, int>{
      '비겁': 0,
      '식상': 0,
      '재성': 0,
      '관성': 0,
      '인성': 0,
    };

    for (final info in allSipseong.values) {
      if (info.category != '일간') {
        stats[info.category] = (stats[info.category] ?? 0) + 1;
      }
    }

    return stats;
  }

  /// 십성 균형 분석
  static String analyzeSipseongBalance(Map<String, int> stats) {
    final total = stats.values.fold(0, (sum, val) => sum + val);
    if (total == 0) return '분석 불가';

    final maxCategory = stats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final maxCount = stats[maxCategory]!;

    if (maxCount >= 3) {
      return '$maxCategory이(가) 강함';
    } else if (stats.values.where((v) => v == 0).length >= 3) {
      return '십성이 편중됨';
    } else {
      return '십성이 고르게 분포됨';
    }
  }
}
