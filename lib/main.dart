import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/firebase_config.dart';
import 'constants/app_colors.dart';
import 'constants/app_textstyles.dart';
import 'providers/auth_provider.dart';
import 'providers/car_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/user_provider.dart';
import 'providers/filter_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseConfig.initializeFirebase();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Authentication provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Car provider
        ChangeNotifierProvider(create: (_) => CarProvider()),
        
        // Booking provider
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        
        // User provider
        ChangeNotifierProvider(create: (_) => UserProvider()),
        
        // Filter provider
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: MaterialApp(
        title: 'CarRental',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Colors
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          
          // Text theme
          textTheme: TextTheme(
            displayLarge: AppTextStyles.displayLarge,
            displayMedium: AppTextStyles.displayMedium,
            displaySmall: AppTextStyles.displaySmall,
            headlineLarge: AppTextStyles.headlineLarge,
            headlineMedium: AppTextStyles.headlineMedium,
            headlineSmall: AppTextStyles.headlineSmall,
            titleLarge: AppTextStyles.titleLarge,
            titleMedium: AppTextStyles.titleMedium,
            titleSmall: AppTextStyles.titleSmall,
            bodyLarge: AppTextStyles.bodyLarge,
            bodyMedium: AppTextStyles.bodyMedium,
            bodySmall: AppTextStyles.bodySmall,
            labelLarge: AppTextStyles.labelLarge,
            labelMedium: AppTextStyles.labelMedium,
            labelSmall: AppTextStyles.labelSmall,
          ),
          
          // App bar theme
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: AppTextStyles.titleLarge.copyWith(
              color: AppColors.white,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.white,
            ),
          ),
          
          // Button themes
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: AppTextStyles.buttonText,
            ),
          ),
          
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: AppTextStyles.buttonText.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          
          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            labelStyle: AppTextStyles.labelMedium,
            hintStyle: AppTextStyles.hintText,
          ),
          
          // Checkbox theme
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(AppColors.primary),
          ),
          
          // Radio theme
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(AppColors.primary),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/profile': (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
