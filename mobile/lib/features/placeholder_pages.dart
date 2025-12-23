import 'package:flutter/material.dart';

// Placeholder pages - These should be fully implemented with actual functionality

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Page - To be implemented')),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Page - To be implemented')),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Page - To be implemented')),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard - To be implemented')),
    );
  }
}

class FarmsPage extends StatelessWidget {
  const FarmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Farms')),
      body: const Center(child: Text('Farms Page - To be implemented')),
    );
  }
}

class FarmDetailPage extends StatelessWidget {
  final String farmId;
  const FarmDetailPage({super.key, required this.farmId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Details')),
      body: Center(child: Text('Farm Detail: $farmId - To be implemented')),
    );
  }
}

class DiagnosisPage extends StatelessWidget {
  const DiagnosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Diagnosis')),
      body: const Center(child: Text('Diagnosis Page - To be implemented')),
    );
  }
}

class DiagnosisResultPage extends StatelessWidget {
  final Map<String, dynamic> diagnosis;
  const DiagnosisResultPage({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Result')),
      body: const Center(child: Text('Result Page - To be implemented')),
    );
  }
}

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: const Center(child: Text('Marketplace - To be implemented')),
    );
  }
}

class ListingDetailPage extends StatelessWidget {
  final String listingId;
  const ListingDetailPage({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      body: Center(child: Text('Listing: $listingId - To be implemented')),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: const Center(child: Text('Weather Page - To be implemented')),
    );
  }
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Center')),
      body: const Center(child: Text('Learning Page - To be implemented')),
    );
  }
}

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Forum')),
      body: const Center(child: Text('Forum Page - To be implemented')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page - To be implemented')),
    );
  }
}
