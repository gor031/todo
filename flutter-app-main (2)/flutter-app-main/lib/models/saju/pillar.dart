/// 기둥(柱) 모델 - 년주, 월주, 일주, 시주
class Pillar {
  final String cheongan; // 천간
  final String jiji; // 지지
  final String ganzhi; // 간지 (천간+지지)

  Pillar({
    required this.cheongan,
    required this.jiji,
  }) : ganzhi = cheongan + jiji;

  // 오행 가져오기
  String get cheonganOhaeng {
    const map = {
      '갑': '목', '을': '목',
      '병': '화', '정': '화',
      '무': '토', '기': '토',
      '경': '금', '신': '금',
      '임': '수', '계': '수',
    };
    return map[cheongan] ?? '';
  }

  String get jijiOhaeng {
    const map = {
      '자': '수', '해': '수',
      '인': '목', '묘': '목',
      '사': '화', '오': '화',
      '신': '금', '유': '금',
      '축': '토', '진': '토', '미': '토', '술': '토',
    };
    return map[jiji] ?? '';
  }

  // 음양 가져오기
  String get cheonganYinYang {
    const map = {
      '갑': '양', '을': '음',
      '병': '양', '정': '음',
      '무': '양', '기': '음',
      '경': '양', '신': '음',
      '임': '양', '계': '음',
    };
    return map[cheongan] ?? '';
  }

  String get jijiYinYang {
    const map = {
      '자': '양', '축': '음',
      '인': '양', '묘': '음',
      '진': '양', '사': '음',
      '오': '양', '미': '음',
      '신': '양', '유': '음',
      '술': '양', '해': '음',
    };
    return map[jiji] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'cheongan': cheongan,
      'jiji': jiji,
      'ganzhi': ganzhi,
      'cheonganOhaeng': cheonganOhaeng,
      'jijiOhaeng': jijiOhaeng,
    };
  }

  factory Pillar.fromJson(Map<String, dynamic> json) {
    return Pillar(
      cheongan: json['cheongan'] as String,
      jiji: json['jiji'] as String,
    );
  }

  @override
  String toString() {
    return ganzhi;
  }
}
