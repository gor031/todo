import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          '이용약관',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('제1조 (목적)',
                  '이 약관은 회사가 제공하는 서비스의 이용조건 및 절차, 회사와 회원 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.'),
              _buildSection(
                  '제2조 (용어의 정의)',
                  '1. "서비스"란 회사가 제공하는 모든 서비스를 의미합니다.\n'
                      '2. "회원"이란 이 약관에 동의하고 서비스를 이용하는 자를 의미합니다.\n'
                      '3. "콘텐츠"란 서비스에서 제공하는 모든 형태의 정보를 의미합니다.'),
              _buildSection('제3조 (약관의 효력과 변경)',
                  '회사는 약관을 변경할 수 있으며, 변경된 약관은 서비스를 통하여 공지함으로써 효력이 발생합니다.'),
              _buildSection(
                  '제4조 (서비스의 제공 및 변경)',
                  '1. 회사는 다음과 같은 서비스를 제공합니다.\n'
                      '  - 블로그 글 조회 서비스\n'
                      '  - 댓글 작성 서비스\n'
                      '  - 알림 서비스\n'
                      '2. 회사는 서비스의 내용을 변경할 수 있으며, 이 경우 변경된 내용을 사전에 공지합니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
