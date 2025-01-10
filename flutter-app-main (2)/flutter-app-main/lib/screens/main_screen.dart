import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blog_provider.dart';
import 'blog_list_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Provider를 통해 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BlogProvider>().fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showMenu(BuildContext context) {
    final blogProvider = context.read<BlogProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      '메뉴',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.brown[400]),
                title: const Text('회원가입'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.login, color: Colors.brown[400]),
                title: Text(blogProvider.isLoggedIn ? '로그아웃' : '로그인'),
                onTap: () async {
                  if (blogProvider.isLoggedIn) {
                    blogProvider.setLoginState(false);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    if (mounted && result == true) {
                      blogProvider.setLoginState(true);
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip, color: Colors.brown[400]),
                title: const Text('개인정보처리방침'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.brown[400]),
                title: const Text('이용약관'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsOfServiceScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "좋은글 다함께",
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.brown),
            onPressed: () => _showMenu(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.brown,
          unselectedLabelColor: Colors.brown[300],
          indicatorColor: Colors.brown,
          tabs: const [
            Tab(text: '좋은글'),
            Tab(text: '즐겨찾기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BlogListScreen(),
          FavoritesScreen(),
        ],
      ),
    );
  }
}
