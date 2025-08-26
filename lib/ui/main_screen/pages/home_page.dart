import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/main_screen/home_page_provider.dart';

import '../../../widgets/shared/animal_card.dart';

import '../../../widgets/native/main_screen/home_page/featured_banner.dart';
import '../../../widgets/native/main_screen/home_page/categories_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    return RefreshIndicator(
        onRefresh: () async {
          await context.read<HomeProvider>().refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Animal World',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover amazing creatures from around the globe',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const FeaturedBanner(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Animals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeProvider.recentAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = homeProvider.recentAnimals[index];
                          return SizedBox(
                            width: 160,
                            child: AnimalCard(
                              name: animal['name'],
                              image: animal['image'],
                              category: animal['category'],
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('View ${animal['name']} details'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const CategoriesSection(),

            
            ],
          ),
        ),
      );
  }
}