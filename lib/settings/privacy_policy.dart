import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
            'Privacy Policy',
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
          _buildSection(
              context,
              '1) Information about the collection of personal data',
              'We are pleased that you are using our application Habitchain (hereinafter referred to as the “app”). In the following, we inform you about the handling of your personal data when using our app.\n\nPersonal data is all data with which you can be personally identified.'),
          _buildSection(context, '1.2 Responsible Person',
              'Abdul Wahab, HabitChain\nEmail: wahabjnab@gmail.com\n\nThe person responsible is the natural or legal person who alone or jointly with others decides on the purposes and means of processing personal data.'),
          _buildSection(context, '2) Contact',
              'When you contact us (for example via email or in-app contact options), personal data is collected. The data collected is used exclusively for responding to your request or for technical administration.\n\nThe legal basis for processing this data is Art. 6 (1) (f) GDPR.'),
          _buildSection(context, '3) Data processing for in-app purchases',
              'For processing subscriptions and in-app purchases within Habitchain, we work with service providers who support us in handling payments. Personal data is transferred only as necessary for payment processing.\n\nThe legal basis is Art. 6 (1) (b) GDPR.'),
          _buildSection(context, '3.2 RevenueCat',
              'In-app purchases and subscriptions are processed via RevenueCat Inc. Information such as transaction identifiers and subscription status may be shared for payment processing only.'),
          _buildSection(context, '4) Firebase Crashlytics',
              'Habitchain uses Firebase Crashlytics to monitor app stability. Crash reports include anonymous technical information such as app state at crash, device type, and OS. No personally identifiable data is collected.'),
          _buildSection(context, '5) Rights of the data subject',
              'You have the following rights:\n\n• Right of access (Art. 15 GDPR)\n• Right to rectification (Art. 16 GDPR)\n• Right to erasure (Art. 17 GDPR)\n• Right to restriction of processing (Art. 18 GDPR)\n• Right to data portability (Art. 20 GDPR)\n• Right to withdraw consent (Art. 7 (3) GDPR)'),
          _buildSection(context, '6) Right to object',
              'If your personal data is processed based on legitimate interests, you may object at any time. If data is used for direct marketing, you may object and processing will stop immediately.'),
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
