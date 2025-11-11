import 'package:flutter/material.dart';
import '../../services/saju/saju_calculator_service.dart';
import '../../services/saju/gunghap_service.dart';
import 'gunghap_result_screen.dart';

/// 궁합 입력 화면
class GunghapInputScreen extends StatefulWidget {
  const GunghapInputScreen({Key? key}) : super(key: key);

  @override
  State<GunghapInputScreen> createState() => _GunghapInputScreenState();
}

class _GunghapInputScreenState extends State<GunghapInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sajuCalculator = SajuCalculatorService();

  // 첫 번째 사람
  DateTime _date1 = DateTime.now();
  TimeOfDay _time1 = const TimeOfDay(hour: 12, minute: 0);
  bool _isMale1 = true;

  // 두 번째 사람
  DateTime _date2 = DateTime.now();
  TimeOfDay _time2 = const TimeOfDay(hour: 12, minute: 0);
  bool _isMale2 = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('궁합 보기'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목
              const Text(
                '💑 궁합 보기',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '두 사람의 생년월일시를 입력하세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 첫 번째 사람
              _buildPersonCard(
                title: '첫 번째 사람',
                color: Colors.blue,
                date: _date1,
                time: _time1,
                isMale: _isMale1,
                onDateTap: () => _selectDate(1),
                onTimeTap: () => _selectTime(1),
                onGenderChanged: (isMale) {
                  setState(() {
                    _isMale1 = isMale;
                  });
                },
              ),
              const SizedBox(height: 24),

              // 두 번째 사람
              _buildPersonCard(
                title: '두 번째 사람',
                color: Colors.pink,
                date: _date2,
                time: _time2,
                isMale: _isMale2,
                onDateTap: () => _selectDate(2),
                onTimeTap: () => _selectTime(2),
                onGenderChanged: (isMale) {
                  setState(() {
                    _isMale2 = isMale;
                  });
                },
              ),
              const SizedBox(height: 32),

              // 궁합 보기 버튼
              ElevatedButton(
                onPressed: _isLoading ? null : _calculateGunghap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '궁합 보기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonCard({
    required String title,
    required Color color,
    required DateTime date,
    required TimeOfDay time,
    required bool isMale,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required Function(bool) onGenderChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 생년월일
            const Text(
              '생년월일',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onDateTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: color),
                    const SizedBox(width: 12),
                    Text(
                      '${date.year}년 ${date.month}월 ${date.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 시간
            const Text(
              '태어난 시간',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onTimeTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: color),
                    const SizedBox(width: 12),
                    Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 성별
            const Text(
              '성별',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onGenderChanged(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isMale ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '남자',
                        style: TextStyle(
                          fontSize: 16,
                          color: isMale ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => onGenderChanged(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isMale ? Colors.pink : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '여자',
                        style: TextStyle(
                          fontSize: 16,
                          color: !isMale ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(int person) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: person == 1 ? _date1 : _date2,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (person == 1) {
          _date1 = picked;
        } else {
          _date2 = picked;
        }
      });
    }
  }

  Future<void> _selectTime(int person) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: person == 1 ? _time1 : _time2,
    );
    if (picked != null) {
      setState(() {
        if (person == 1) {
          _time1 = picked;
        } else {
          _time2 = picked;
        }
      });
    }
  }

  Future<void> _calculateGunghap() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 첫 번째 사람 사주 계산
        final birthDateTime1 = DateTime(
          _date1.year,
          _date1.month,
          _date1.day,
          _time1.hour,
          _time1.minute,
        );
        final saju1 = await _sajuCalculator.calculateSaju(
          birthDateTime: birthDateTime1,
          isMale: _isMale1,
        );

        // 두 번째 사람 사주 계산
        final birthDateTime2 = DateTime(
          _date2.year,
          _date2.month,
          _date2.day,
          _time2.hour,
          _time2.minute,
        );
        final saju2 = await _sajuCalculator.calculateSaju(
          birthDateTime: birthDateTime2,
          isMale: _isMale2,
        );

        // 궁합 계산
        final gunghapResult = GunghapService.calculateGunghap(saju1, saju2);

        // 결과 화면으로 이동
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GunghapResultScreen(result: gunghapResult),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('궁합 계산 중 오류가 발생했습니다: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
