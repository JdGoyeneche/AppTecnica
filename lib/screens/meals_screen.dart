// lib/screens/meals_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List meals = [];
  List<String> favoriteMealIds = [];
  bool isLoading = true;
  bool hasError = false;
  bool showFavoritesOnly = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=c"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          meals = data["meals"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void toggleFavorite(String mealId) {
    setState(() {
      if (favoriteMealIds.contains(mealId)) {
        favoriteMealIds.remove(mealId);
      } else {
        favoriteMealIds.add(mealId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final textColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    // Filtrado por favoritos y búsqueda
    final displayedMeals = meals.where((meal) {
      final matchesFavorites = !showFavoritesOnly || favoriteMealIds.contains(meal['idMeal']);
      final matchesSearch = meal['strMeal']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesFavorites && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          showFavoritesOnly ? 'Favoritos' : 'Recetas',
          style: TextStyle(color: textColor),
        ),
        actions: [
          // Botón cambiar tema
          IconButton(
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.yellow.shade700,
            ),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
          // Botón ver favoritos
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.list : Icons.favorite,
              color: Colors.yellow.shade700,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Buscar recetas...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                prefixIcon: Icon(Icons.search, color: Colors.yellow.shade700),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Error al cargar recetas"),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: fetchMeals,
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchMeals,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showFavoritesOnly
                        ? ListView.builder(
                            itemCount: displayedMeals.length,
                            itemBuilder: (context, index) {
                              final meal = displayedMeals[index];
                              final mealId = meal['idMeal'];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    meal['strMealThumb'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  meal['strMeal'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    favoriteMealIds.contains(mealId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.yellow.shade700,
                                  ),
                                  onPressed: () => toggleFavorite(mealId),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MealDetailScreen(mealId: mealId),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : GridView.builder(
                            itemCount: displayedMeals.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.55,
                            ),
                            itemBuilder: (context, index) {
                              final meal = displayedMeals[index];
                              final mealId = meal['idMeal'];
                              final isFavorite =
                                  favoriteMealIds.contains(mealId);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MealDetailScreen(mealId: mealId),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 6,
                                      shadowColor:
                                          Colors.yellow.withOpacity(0.3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              child: Image.network(
                                                meal['strMealThumb'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              meal['strMeal'] ?? 'Sin nombre',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.yellow.shade700,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              toggleFavorite(mealId),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
    );
  }
}
