/// 신살 정보
class SinsalInfo {
  final String name; // 신살 이름
  final String description; // 설명
  final String position; // 위치 (년지, 월지, 일지, 시지)
  final bool isGood; // 길신(true) or 흉신(false)

  SinsalInfo({
    required this.name,
    required this.description,
    required this.position,
    required this.isGood,
  });
}

/// 신살 계산 서비스
class SinsalService {
  /// 천을귀인 (天乙貴人) - 가장 길한 신살
  static List<String> getCheonEulGuiIn(String ilgan) {
    const map = {
      '갑': ['축', '미'],
      '을': ['자', '신'],
      '병': ['해', '유'],
      '정': ['해', '유'],
      '무': ['축', '미'],
      '기': ['자', '신'],
      '경': ['축', '미'],
      '신': ['자', '신'],
      '임': ['사', '묘'],
      '계': ['사', '묘'],
    };
    return map[ilgan] ?? [];
  }

  /// 천덕귀인 (天德貴人) - 덕을 받는 신살
  static String? getCheonDeokGuiIn(String monthJiji) {
    const map = {
      '자': '정',
      '축': '경',
      '인': '계',
      '묘': '갑',
      '진': '을',
      '사': '병',
      '오': '무',
      '미': '기',
      '신': '신',
      '유': '임',
      '술': '계',
      '해': '갑',
    };
    return map[monthJiji];
  }

  /// 역마살 (驛馬殺) - 이동, 변화
  static String? getYeokMaSal(String yearJiji, String dayJiji) {
    const map = {
      '인': '신',
      '오': '인',
      '술': '신',
      '신': '인',
      '자': '인',
      '진': '신',
      '사': '해',
      '유': '해',
      '축': '해',
      '해': '사',
      '묘': '사',
      '미': '해',
    };

    final yeokma = map[yearJiji];
    if (yeokma == dayJiji) {
      return '역마살';
    }
    return null;
  }

  /// 도화살 (桃花殺) - 이성, 예술, 매력
  static String? getDoHwaSal(String yearJiji, String dayJiji) {
    const map = {
      '인': '묘',
      '오': '묘',
      '술': '묘',
      '사': '오',
      '유': '오',
      '축': '오',
      '신': '유',
      '자': '유',
      '진': '유',
      '해': '자',
      '묘': '자',
      '미': '자',
    };

    final dohwa = map[yearJiji];
    if (dohwa == dayJiji) {
      return '도화살';
    }
    return null;
  }

  /// 공망 (空亡) - 비어있음
  static List<String> getGongMang(String dayGanzhi) {
    const ganzhiGroups = {
      '갑자': ['술', '해'],
      '갑술': ['신', '유'],
      '갑신': ['오', '미'],
      '갑오': ['진', '사'],
      '갑진': ['인', '묘'],
      '갑인': ['자', '축'],
    };

    for (final entry in ganzhiGroups.entries) {
      final baseGanzhi = entry.key;
      final gongmangJiji = entry.value;

      // 간단한 판정 (첫 글자가 같으면)
      if (dayGanzhi.startsWith(baseGanzhi[0])) {
        return gongmangJiji;
      }
    }

    return [];
  }

  /// 화개살 (華蓋殺) - 예술, 종교, 고독
  static String? getHwaGaeSal(String yearJiji, String dayJiji) {
    const map = {
      '인': '술',
      '오': '술',
      '술': '술',
      '사': '축',
      '유': '축',
      '축': '축',
      '신': '진',
      '자': '진',
      '진': '진',
      '해': '미',
      '묘': '미',
      '미': '미',
    };

    final hwagae = map[yearJiji];
    if (hwagae == dayJiji) {
      return '화개살';
    }
    return null;
  }

  /// 모든 신살 계산
  static List<SinsalInfo> calculateAllSinsal({
    required String ilgan,
    required String yearJiji,
    required String monthJiji,
    required String dayJiji,
    required String timeJiji,
    required String dayGanzhi,
  }) {
    final List<SinsalInfo> sinsalList = [];

    // 천을귀인
    final guiinList = getCheonEulGuiIn(ilgan);
    for (final guiin in guiinList) {
      String? position;
      if (yearJiji == guiin) position = '년지';
      if (monthJiji == guiin) position = '월지';
      if (dayJiji == guiin) position = '일지';
      if (timeJiji == guiin) position = '시지';

      if (position != null) {
        sinsalList.add(SinsalInfo(
          name: '천을귀인',
          description: '하늘의 귀인. 위기 시 도움을 받음. 가장 길한 신살',
          position: position,
          isGood: true,
        ));
      }
    }

    // 역마살
    final yeokma = getYeokMaSal(yearJiji, dayJiji);
    if (yeokma != null) {
      sinsalList.add(SinsalInfo(
        name: '역마살',
        description: '이동, 변화가 많음. 활동적이고 역동적',
        position: '일지',
        isGood: true,
      ));
    }

    // 도화살
    final dohwa = getDoHwaSal(yearJiji, dayJiji);
    if (dohwa != null) {
      sinsalList.add(SinsalInfo(
        name: '도화살',
        description: '이성에게 인기, 예술적 재능. 매력적',
        position: '일지',
        isGood: true,
      ));
    }

    // 화개살
    final hwagae = getHwaGaeSal(yearJiji, dayJiji);
    if (hwagae != null) {
      sinsalList.add(SinsalInfo(
        name: '화개살',
        description: '예술, 종교, 학문에 재능. 고독한 면도 있음',
        position: '일지',
        isGood: true,
      ));
    }

    // 공망
    final gongmangList = getGongMang(dayGanzhi);
    for (final gongmang in gongmangList) {
      String? position;
      if (yearJiji == gongmang) position = '년지';
      if (monthJiji == gongmang) position = '월지';
      if (dayJiji == gongmang) position = '일지';
      if (timeJiji == gongmang) position = '시지';

      if (position != null) {
        sinsalList.add(SinsalInfo(
          name: '공망',
          description: '비어있음. 허무함, 무(無)의 상태',
          position: position,
          isGood: false,
        ));
      }
    }

    return sinsalList;
  }

  /// 신살 통계
  static Map<String, int> calculateSinsalStats(List<SinsalInfo> sinsalList) {
    return {
      '길신': sinsalList.where((s) => s.isGood).length,
      '흉신': sinsalList.where((s) => !s.isGood).length,
    };
  }
}
