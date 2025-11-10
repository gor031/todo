import 'package:flutter/material.dart';
import '../../models/saju/saju.dart';
import '../../services/saju/sipseong_service.dart';
import '../../services/saju/sinsal_service.dart';

/// 사주 결과 화면
class SajuResultScreen extends StatelessWidget {
  final Saju saju;

  const SajuResultScreen({
    Key? key,
    required this.saju,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사주팔자 결과'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 생년월일 정보
            _buildInfoCard(),
            const SizedBox(height: 16),

            // 사주팔자
            _buildSajuCard(),
            const SizedBox(height: 16),

            // 오행 분석
            _buildOhaengCard(),
            const SizedBox(height: 16),

            // 십성 분석
            _buildSipseongCard(),
            const SizedBox(height: 16),

            // 신살 분석
            _buildSinsalCard(),
            const SizedBox(height: 16),

            // 대운
            _buildDaeunCard(),
            const SizedBox(height: 16),

            // 세운
            _buildSeunCard(),
            const SizedBox(height: 16),

            // 월운
            _buildWolunCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '생년월일 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              '양력',
              '${saju.birthDateTime.year}년 ${saju.birthDateTime.month}월 ${saju.birthDateTime.day}일 ${saju.birthDateTime.hour}시 ${saju.birthDateTime.minute}분',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              '성별',
              saju.isMale ? '남자' : '여자',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              '일간',
              saju.ilgan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSajuCard() {
    return Card(
      elevation: 2,
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '사주팔자 (四柱八字)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            Table(
              border: TableBorder.all(
                color: Colors.black54,
                width: 1,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                  ),
                  children: const [
                    _TableHeader('시주'),
                    _TableHeader('일주'),
                    _TableHeader('월주'),
                    _TableHeader('년주'),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(saju.timePillar.cheongan, isCheongan: true),
                    _TableCell(saju.dayPillar.cheongan, isCheongan: true),
                    _TableCell(saju.monthPillar.cheongan, isCheongan: true),
                    _TableCell(saju.yearPillar.cheongan, isCheongan: true),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(saju.timePillar.jiji, isCheongan: false),
                    _TableCell(saju.dayPillar.jiji, isCheongan: false),
                    _TableCell(saju.monthPillar.jiji, isCheongan: false),
                    _TableCell(saju.yearPillar.jiji, isCheongan: false),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPillarInfo('시', saju.timePillar),
                  _buildPillarInfo('일', saju.dayPillar),
                  _buildPillarInfo('월', saju.monthPillar),
                  _buildPillarInfo('년', saju.yearPillar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOhaengCard() {
    final ohaeng = saju.ohaengAnalysis;
    final total = ohaeng.values.fold(0, (sum, val) => sum + val);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오행 분석 (五行)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...ohaeng.entries.map((entry) {
              final percentage = (entry.value / total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getOhaengEmoji(entry.key) + entry.key,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${entry.value}개 ($percentage%)',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor: Colors.grey[200],
                      color: _getOhaengColor(entry.key),
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDaeunCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '대운 (大運)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '10년 단위의 운의 흐름',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 24),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: saju.daeun.length,
                itemBuilder: (context, index) {
                  final daeun = saju.daeun[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daeun.ganzhi,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${daeun.startAge}~${daeun.endAge}세',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeunCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '세운 (歲運)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '매년의 운세',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: saju.seun.map((seun) {
                final isCurrentYear = seun.year == DateTime.now().year;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentYear ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentYear ? Colors.green : Colors.grey[300]!,
                      width: isCurrentYear ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${seun.year}년',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        seun.ganzhi,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWolunCard() {
    final currentMonth = DateTime.now().month;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '월운 (月運) - ${DateTime.now().year}년',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '매월의 운세',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: saju.wolun.length,
              itemBuilder: (context, index) {
                final wolun = saju.wolun[index];
                final isCurrentMonth = wolun.month == currentMonth;
                return Container(
                  decoration: BoxDecoration(
                    color: isCurrentMonth ? Colors.orange[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentMonth ? Colors.orange : Colors.grey[300]!,
                      width: isCurrentMonth ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${wolun.month}월',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        wolun.ganzhi,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPillarInfo(String label, pillar) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${pillar.cheonganOhaeng}·${pillar.jijiOhaeng}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getOhaengEmoji(String ohaeng) {
    switch (ohaeng) {
      case '목':
        return '🌳 ';
      case '화':
        return '🔥 ';
      case '토':
        return '⛰️ ';
      case '금':
        return '⚔️ ';
      case '수':
        return '💧 ';
      default:
        return '';
    }
  }

  Color _getOhaengColor(String ohaeng) {
    switch (ohaeng) {
      case '목':
        return Colors.green;
      case '화':
        return Colors.red;
      case '토':
        return Colors.brown;
      case '금':
        return Colors.grey;
      case '수':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSipseongCard() {
    // 십성 계산
    final sipseongMap = SipseongService.calculateAllSipseong(
      ilgan: saju.ilgan,
      yearCheongan: saju.yearPillar.cheongan,
      monthCheongan: saju.monthPillar.cheongan,
      dayCheongan: saju.dayPillar.cheongan,
      timeCheongan: saju.timePillar.cheongan,
    );

    final stats = SipseongService.calculateSipseongStats(sipseongMap);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '십성 분석 (十星)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '일간을 기준으로 한 천간의 역할',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 24),
            Table(
              border: TableBorder.all(color: Colors.black54, width: 1),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.purple[50]),
                  children: const [
                    _TableHeader('시간'),
                    _TableHeader('일간'),
                    _TableHeader('월간'),
                    _TableHeader('년간'),
                  ],
                ),
                TableRow(
                  children: [
                    _SipseongCell(
                      cheongan: saju.timePillar.cheongan,
                      sipseong: sipseongMap['시간']!.sipseong,
                    ),
                    _SipseongCell(
                      cheongan: saju.dayPillar.cheongan,
                      sipseong: '일간(나)',
                      isIlgan: true,
                    ),
                    _SipseongCell(
                      cheongan: saju.monthPillar.cheongan,
                      sipseong: sipseongMap['월간']!.sipseong,
                    ),
                    _SipseongCell(
                      cheongan: saju.yearPillar.cheongan,
                      sipseong: sipseongMap['년간']!.sipseong,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getSipseongCategoryColor(entry.key),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinsalCard() {
    // 신살 계산
    final sinsalList = SinsalService.calculateAllSinsal(
      ilgan: saju.ilgan,
      yearJiji: saju.yearPillar.jiji,
      monthJiji: saju.monthPillar.jiji,
      dayJiji: saju.dayPillar.jiji,
      timeJiji: saju.timePillar.jiji,
      dayGanzhi: saju.dayPillar.ganzhi,
    );

    final stats = SinsalService.calculateSinsalStats(sinsalList);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '신살 분석 (神殺)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '길신 ${stats['길신']}개, 흉신 ${stats['흉신']}개',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 24),
            if (sinsalList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '주요 신살이 없습니다',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...sinsalList.map((sinsal) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sinsal.isGood ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: sinsal.isGood ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: sinsal.isGood ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              sinsal.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              sinsal.position,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sinsal.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getSipseongCategoryColor(String category) {
    switch (category) {
      case '비겁':
        return Colors.green;
      case '식상':
        return Colors.orange;
      case '재성':
        return Colors.red;
      case '관성':
        return Colors.blue;
      case '인성':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _SipseongCell extends StatelessWidget {
  final String cheongan;
  final String sipseong;
  final bool isIlgan;

  const _SipseongCell({
    required this.cheongan,
    required this.sipseong,
    this.isIlgan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: isIlgan ? Colors.amber[100] : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cheongan,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sipseong,
            style: TextStyle(
              fontSize: 12,
              color: isIlgan ? Colors.brown : Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isCheongan;

  const _TableCell(this.text, {required this.isCheongan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: isCheongan ? Colors.white : Colors.grey[50],
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
