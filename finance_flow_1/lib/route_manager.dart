import 'package:finance_flow_1/routes/authentication/forgot_password.dart';
import 'package:finance_flow_1/routes/authentication/login_page.dart';
import 'package:finance_flow_1/routes/budget_pages/add_budget_page.dart';
import 'package:finance_flow_1/routes/budget_pages/budget_overview_page.dart';
import 'package:finance_flow_1/routes/chat_page.dart';
import 'package:finance_flow_1/routes/dashboard_page.dart';
import 'package:finance_flow_1/routes/monthly_totals_page.dart';
import 'package:finance_flow_1/routes/notifications_page.dart';
import 'package:finance_flow_1/routes/page_not_found.dart';
import 'package:finance_flow_1/routes/settings/profile_page.dart';
import 'package:finance_flow_1/routes/settings/settings_page.dart';
import 'package:finance_flow_1/routes/splash_screen.dart';
import 'package:finance_flow_1/routes/transactions pages/add_transaction.dart';
import 'package:finance_flow_1/routes/transactions pages/main_transactions.dart';
import 'package:finance_flow_1/routes/virtual_card.dart';
import 'package:finance_flow_1/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/widgets/no_animation.dart';

class RouteManager {
  static const String dashboard = '/';
  static const String chat = '/chat';
  static const String chartPage = '/chart';
  static const String login = '/login';
  static const String transactionsPage = '/transactions';
  static const String virtualCard = '/virtual';
  static const String settingsPage = '/settings';
  static const String splash = '/splash';
  static const String pageNotFound = '/notFound';
  static const String profilePage = '/profile';
  static const String addTransactionPage = '/addTransaction';
  static const String addBudgetPage = '/addBudget';
  static const String forgotPassword = '/forgotPassword';
  static const String viewBudget = '/viewBudget';
  static const String monthlyTotals = "/totals";
  static const String notifications = "/notificationsPage";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addTransactionPage:
        return NoAnimationPageRoute(page: const AddTransactionPage());
      case profilePage:
        return NoAnimationPageRoute(page: const ProfilePage());
      case dashboard:
        return NoAnimationPageRoute(page: const DashboardPage());
      case chat:
        return NoAnimationPageRoute(page: const ChatPage());
      case login:
        return NoAnimationPageRoute(page: const LoginPage());
      case forgotPassword:
        return NoAnimationPageRoute(page: const ForgotPasswordPage());
      case monthlyTotals:
        return NoAnimationPageRoute(page: const MonthlyTotalsPage());
      case transactionsPage:
        return NoAnimationPageRoute(page: const TransactionsPage());
      case viewBudget:
        return NoAnimationPageRoute(page: const BudgetOverviewPage());
      case chartPage:
        return NoAnimationPageRoute(page: const ChartPage());
      case addBudgetPage:
        return NoAnimationPageRoute(page: const AddBudgetPage());
      case virtualCard:
        return NoAnimationPageRoute(page: const VirtualCardPage());
      case settingsPage:
        return NoAnimationPageRoute(page: SettingsPage());
      case splash:
        return NoAnimationPageRoute(page: const SplashScreen());
      case notifications:
        return NoAnimationPageRoute(page: const NotificationPage());
      default:
        return NoAnimationPageRoute(page: const PageNotFound());
    }
  }
}
