import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';
import 'providers/blog_provider.dart';
import 'screens/blog_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_service_screen.dart';
// import 'services/push_notification_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_API_KEY']);
  runApp(
    ChangeNotifierProvider(
      create: (context) => BlogProvider(),
      child: const InfiniteGridApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: \${message.messageId}");

  final supabase = Supabase.instance.client;
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final response =
          await supabase.from('notifications').delete().eq('fcm_token', token);
      if (response.error == null) {
        debugPrint("FCM Token deleted successfully");
      } else {
        debugPrint("Error deleting FCM token: ${response.error?.message}");
      }
    } else {
      debugPrint("FCM Token is null");
    }
  } catch (e) {
    debugPrint("Error deleting FCM token: $e");
  }
}

class InfiniteGridApp extends StatelessWidget {
  const InfiniteGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.orange[50],
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _token = "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
    _initializeLocalNotifications();
    _setupFirebaseMessaging();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: \${response.payload}');
      },
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _setupFirebaseMessaging() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token ?? "";
    });
    debugPrint("FCM Token: $_token");

    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      setState(() {
        _token = newToken;
      });
      debugPrint("Refreshed FCM Token: $newToken");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          'Received foreground message: \${message.notification?.title}');

      if (message.notification != null) {
        _showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> insertFCMToken(String token) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('notifications').delete().eq('fcm_token', _token);
      final response = await supabase.from('notifications').insert({
        'fcm_token': token,
      });
      if (response.error == null) {
        debugPrint("FCM Token inserted successfully");
      } else {
        debugPrint("Error inserting FCM token: ${response.error?.message}");
      }
    } catch (e) {
      debugPrint("Error inserting FCM token: $e");
    }
  }

  Future<void> _showMenu(BuildContext context) async {
    final blogProvider = context.read<BlogProvider>();

    if (!mounted) return;

    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (menuContext) {
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
                onTap: () {
                  Navigator.pop(menuContext); // menuContext 안전하게 사용
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.login, color: Colors.brown[400]),
                title: Text(blogProvider.isLoggedIn ? '로그아웃' : '로그인'),
                onTap: () async {
                  Navigator.pop(menuContext); // menuContext 닫기
                  if (mounted) {
                    if (blogProvider.isLoggedIn) {
                      blogProvider.setLoginState(false);
                    } else {
                      final loginResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      if (mounted && loginResult == true) {
                        blogProvider.setLoginState(true);
                      }
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip, color: Colors.brown[400]),
                title: const Text('개인정보처리방침'),
                onTap: () {
                  Navigator.pop(menuContext);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.brown[400]),
                title: const Text('이용약관'),
                onTap: () {
                  Navigator.pop(menuContext);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsOfServiceScreen(),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.brown[400]),
                title: const Text('Push Notification'),
                onTap: () {
                  Navigator.pop(menuContext);
                  if (mounted && _token.isNotEmpty) {
                    // Insert FCM token into Supabase
                    insertFCMToken(_token);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    if (mounted && result != null) {
      // 필요한 경우 추가 작업 처리
    }
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
