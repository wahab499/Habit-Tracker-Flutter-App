import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildContentCard(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2128) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C313B)
                      : Colors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
          ),
          Text(
            'Terms of Use',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2128) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2C313B)
              : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Effective Date: 26/2/2026',
            style: TextStyle(
              color: context.theme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _buildBodyText(
            context,
            'Welcome to Habitchain (“App”, “Service”, “we”, “us”, “our”). By downloading, installing, or using Habitchain, you agree to these Terms of Use. If you do not agree, please do not use the App.',
          ),
          const SizedBox(height: 32),
          _buildSection(context, '1. Eligibility',
              'You must be at least 13 years old (or the minimum legal age in your country) to use Habitchain. If you are under 18, you confirm that you have parental or legal guardian permission.'),
          _buildSection(context, '2. Description of Service',
              'Habitchain is a habit-tracking application that allows users to:\n\n• Track positive and negative habits\n• Monitor consistency and streaks\n• View visual progress data\n• Access premium features via subscription\n\nWe reserve the right to modify or discontinue features at any time.'),
          _buildSection(context, '3. User Accounts',
              'If the App includes account creation:\n\n• You are responsible for maintaining account security.\n• You agree to provide accurate information.\n• You are responsible for all activity under your account.\n• We reserve the right to suspend or terminate accounts that violate these Terms.'),
          _buildSection(context, '4. Subscriptions and Payments',
              '• Habitchain may offer paid subscriptions or premium features.\n• Payments are processed via Apple App Store or Google Play.\n• Subscriptions automatically renew unless canceled.\n• You may manage or cancel subscriptions in your device account settings.\n• Refunds are handled according to Apple or Google policies.\n• We do not directly store your payment information.'),
          _buildSection(context, '5. Acceptable Use',
              'You agree NOT to:\n\n• Reverse engineer the app\n• Use the app for illegal purposes\n• Attempt to hack, disrupt, or overload the service\n• Upload harmful code or malware\n• Abuse free trials or payment systems\n\nViolation may result in account suspension or termination.'),
          _buildSection(context, '6. Intellectual Property',
              'All content, design, branding, code, logos, and visual elements of Habitchain are the property of the developer and are protected by intellectual property laws. You may not copy, reproduce, or distribute any part of the app without written permission.'),
          _buildSection(context, '7. Data and Privacy',
              'Your use of Habitchain is also governed by our Privacy Policy. By using the app, you consent to the collection and use of data as described in the Privacy Policy.'),
          _buildSection(context, '8. No Medical or Professional Advice',
              'Habitchain is a productivity and habit-tracking tool only. It does not provide medical, psychological, financial, or professional advice. You are responsible for your own decisions and actions.'),
          _buildSection(context, '9. Disclaimer of Warranties',
              'Habitchain is provided “as is” and “as available.” We do not guarantee that the app will always be error-free, the service will be uninterrupted, or data will never be lost. Use of the app is at your own risk.'),
          _buildSection(context, '10. Limitation of Liability',
              'To the maximum extent permitted by law: We shall not be liable for indirect damages, loss of data, loss of profits, business interruption, or device damage. Our total liability shall not exceed the amount you paid for the service (if any).'),
          _buildSection(context, '11. Termination',
              'We reserve the right to suspend or terminate access to Habitchain at our discretion if you violate these Terms. You may stop using the app at any time.'),
          _buildSection(context, '12. Updates and Changes',
              'We may update these Terms at any time. If significant changes are made, we will update the “Effective Date.” Continued use of the app after changes means you accept the revised Terms.'),
          _buildSection(context, '13. Governing Law',
              'These Terms shall be governed by the laws of [Your Country], without regard to conflict of law principles.'),
          _buildSection(context, '14. Contact',
              'Habit Chain\nEmail: myemail@example.com'),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final isDark = Get.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildBodyText(context, content),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildBodyText(BuildContext context, String text) {
    final isDark = Get.isDarkMode;

    return Text(
      text,
      style: TextStyle(
        color: isDark
            ? Colors.white.withValues(alpha: 0.6)
            : Colors.black.withValues(alpha: 0.7),
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
