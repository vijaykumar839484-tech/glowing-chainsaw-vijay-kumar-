import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VijayAI Connect Ads Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _banner;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
    _loadInterstitial();
    _loadRewarded();
    _loadAppOpen();
  }

  @override
  void dispose() {
    _banner?.dispose();
    _interstitial?.dispose();
    _rewarded?.dispose();
    super.dispose();
  }

  void _loadBanner() {
    final banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    banner.load();
    setState(() => _banner = banner);
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (error) => _interstitial = null,
      ),
    );
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: RewardedAd.testAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (error) => _rewarded = null,
      ),
    );
  }

  void _loadAppOpen() {
    AppOpenAd.load(
      adUnitId: AppOpenAd.testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isAppOpenLoaded = false;
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VijayAI Connect (Test Ads)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('AdMob Test IDs integrated. Replace with your own IDs in config/app_config.json for real earnings.'),
            const SizedBox(height: 12),
            if (_banner != null)
              SizedBox(
                width: _banner!.size.width.toDouble(),
                height: _banner!.size.height.toDouble(),
                child: AdWidget(ad: _banner!),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_interstitial != null) {
                  _interstitial!.show();
                  _interstitial = null;
                  _loadInterstitial();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Interstitial not ready')));
                }
              },
              child: const Text('Show Interstitial'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_rewarded != null) {
                  _rewarded!.show(onUserEarnedReward: (ad, reward) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reward: ${reward.amount} ${reward.type}')));
                  });
                  _rewarded = null;
                  _loadRewarded();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rewarded not ready')));
                }
              },
              child: const Text('Show Rewarded'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_isAppOpenLoaded && _appOpenAd != null) {
                  _appOpenAd!.show();
                  _isAppOpenLoaded = false;
                  _loadAppOpen();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App Open not ready')));
                }
              },
              child: const Text('Show App Open'),
            ),
          ],
        ),
      ),
    );
  }
}
