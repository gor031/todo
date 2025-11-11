import '../../models/saju/saju.dart';
import '../../constants/saju/saju_constants.dart';

/// 궁합 결과
class GunghapResult {
  final Saju person1; // 첫 번째 사람
  final Saju person2; // 두 번째 사람
  final int totalScore; // 총점 (100점 만점)
  final Map<String, int> categoryScores; // 카테고리별 점수
  final List<String> positivePoints; // 긍정적 요소
  final List<String> negativePoints; // 부정적 요소
  final String summary; // 종합 평가

  GunghapResult({
    required this.person1,
    required this.person2,
    required this.totalScore,
    required this.categoryScores,
    required this.positivePoints,
    required this.negativePoints,
    required this.summary,
  });
}

/// 궁합 계산 서비스
class GunghapService {
  /// 전체 궁합 계산
  static GunghapResult calculateGunghap(Saju person1, Saju person2) {
    final categoryScores = <String, int>{};
    final positivePoints = <String>[];
    final negativePoints = <String>[];

    // 1. 일간 궁합 (30점)
    final ilganScore = _calculateIlganGunghap(
      person1.ilgan,
      person2.ilgan,
      positivePoints,
      negativePoints,
    );
    categoryScores['일간 궁합'] = ilganScore;

    // 2. 오행 조화 (25점)
    final ohaengScore = _calculateOhaengGunghap(
      person1.ohaengAnalysis,
      person2.ohaengAnalysis,
      positivePoints,
      negativePoints,
    );
    categoryScores['오행 조화'] = ohaengScore;

    // 3. 지지 관계 (25점)
    final jijiScore = _calculateJijiGunghap(
      person1,
      person2,
      positivePoints,
      negativePoints,
    );
    categoryScores['지지 관계'] = jijiScore;

    // 4. 신살 궁합 (20점)
    final sinsalScore = _calculateSinsalGunghap(
      person1,
      person2,
      positivePoints,
      negativePoints,
    );
    categoryScores['신살 궁합'] = sinsalScore;

    // 총점 계산
    final totalScore = categoryScores.values.fold(0, (sum, score) => sum + score);

    // 종합 평가
    final summary = _getSummary(totalScore);

    return GunghapResult(
      person1: person1,
      person2: person2,
      totalScore: totalScore,
      categoryScores: categoryScores,
      positivePoints: positivePoints,
      negativePoints: negativePoints,
      summary: summary,
    );
  }

  /// 일간 궁합 계산 (30점)
  static int _calculateIlganGunghap(
    String ilgan1,
    String ilgan2,
    List<String> positivePoints,
    List<String> negativePoints,
  ) {
    int score = 15; // 기본 점수

    // 같은 일간
    if (ilgan1 == ilgan2) {
      score += 5;
      positivePoints.add('같은 일간으로 서로를 잘 이해함');
    }

    // 일간 오행 관계
    final ohaeng1 = SajuConstants.cheonganOhaeng[ilgan1]!;
    final ohaeng2 = SajuConstants.cheonganOhaeng[ilgan2]!;

    if (SajuConstants.ohaengSangsaeng[ohaeng1] == ohaeng2) {
      score += 10;
      positivePoints.add('$ilgan1이(가) $ilgan2을(를) 생해줌 (상생 관계)');
    } else if (SajuConstants.ohaengSangsaeng[ohaeng2] == ohaeng1) {
      score += 10;
      positivePoints.add('$ilgan2이(가) $ilgan1을(를) 생해줌 (상생 관계)');
    } else if (SajuConstants.ohaengSanggeuk[ohaeng1] == ohaeng2) {
      score -= 5;
      negativePoints.add('$ilgan1이(가) $ilgan2을(를) 극함 (상극 관계)');
    } else if (SajuConstants.ohaengSanggeuk[ohaeng2] == ohaeng1) {
      score -= 5;
      negativePoints.add('$ilgan2이(가) $ilgan1을(를) 극함 (상극 관계)');
    } else if (ohaeng1 == ohaeng2) {
      score += 5;
      positivePoints.add('같은 오행으로 동질감이 있음');
    }

    return score.clamp(0, 30);
  }

  /// 오행 조화 계산 (25점)
  static int _calculateOhaengGunghap(
    Map<String, int> ohaeng1,
    Map<String, int> ohaeng2,
    List<String> positivePoints,
    List<String> negativePoints,
  ) {
    int score = 12; // 기본 점수

    // 부족한 오행을 보완하는지 확인
    for (final entry in ohaeng1.entries) {
      final element = entry.key;
      final count1 = entry.value;
      final count2 = ohaeng2[element] ?? 0;

      if (count1 == 0 && count2 > 2) {
        score += 3;
        positivePoints.add('한 쪽의 부족한 $element을(를) 다른 쪽이 보완함');
      } else if (count2 == 0 && count1 > 2) {
        score += 3;
        positivePoints.add('한 쪽의 부족한 $element을(를) 다른 쪽이 보완함');
      }

      if (count1 > 3 && count2 > 3) {
        score -= 2;
        negativePoints.add('$element이(가) 양쪽 모두 과다함');
      }
    }

    return score.clamp(0, 25);
  }

  /// 지지 관계 계산 (25점)
  static int _calculateJijiGunghap(
    Saju person1,
    Saju person2,
    List<String> positivePoints,
    List<String> negativePoints,
  ) {
    int score = 12; // 기본 점수

    final jiji1List = [
      person1.yearPillar.jiji,
      person1.monthPillar.jiji,
      person1.dayPillar.jiji,
      person1.timePillar.jiji,
    ];

    final jiji2List = [
      person2.yearPillar.jiji,
      person2.monthPillar.jiji,
      person2.dayPillar.jiji,
      person2.timePillar.jiji,
    ];

    // 충(沖) 관계 확인
    int chungCount = 0;
    for (final jiji1 in jiji1List) {
      for (final jiji2 in jiji2List) {
        if (SajuConstants.jijiChung[jiji1] == jiji2) {
          chungCount++;
        }
      }
    }

    if (chungCount == 0) {
      score += 8;
      positivePoints.add('지지 충(沖)이 없어 안정적');
    } else if (chungCount >= 2) {
      score -= 5;
      negativePoints.add('지지 충(沖)이 많아 갈등 가능성');
    }

    // 같은 지지가 있는 경우
    int sameJijiCount = 0;
    for (final jiji1 in jiji1List) {
      if (jiji2List.contains(jiji1)) {
        sameJijiCount++;
      }
    }

    if (sameJijiCount >= 2) {
      score += 5;
      positivePoints.add('같은 지지가 있어 공감대 형성');
    }

    return score.clamp(0, 25);
  }

  /// 신살 궁합 계산 (20점)
  static int _calculateSinsalGunghap(
    Saju person1,
    Saju person2,
    List<String> positivePoints,
    List<String> negativePoints,
  ) {
    int score = 10; // 기본 점수

    // 간단한 신살 궁합 (실제로는 더 복잡)
    // 여기서는 오행 균형으로 대체
    final ohaeng1Count = person1.ohaengAnalysis.values.where((v) => v > 0).length;
    final ohaeng2Count = person2.ohaengAnalysis.values.where((v) => v > 0).length;

    if (ohaeng1Count >= 4 && ohaeng2Count >= 4) {
      score += 5;
      positivePoints.add('양쪽 모두 오행이 고르게 분포됨');
    }

    if (ohaeng1Count <= 2 || ohaeng2Count <= 2) {
      score -= 3;
      negativePoints.add('한 쪽의 오행이 편중됨');
    }

    return score.clamp(0, 20);
  }

  /// 종합 평가
  static String _getSummary(int totalScore) {
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

  /// 궁합 등급
  static String getGrade(int score) {
    if (score >= 90) return 'S';
    if (score >= 75) return 'A';
    if (score >= 60) return 'B';
    if (score >= 45) return 'C';
    return 'D';
  }

  /// 궁합 등급 색상
  static String getGradeColor(int score) {
    if (score >= 90) return '#FFD700'; // 금색
    if (score >= 75) return '#4CAF50'; // 초록색
    if (score >= 60) return '#2196F3'; // 파란색
    if (score >= 45) return '#FF9800'; // 주황색
    return '#F44336'; // 빨간색
  }
}
