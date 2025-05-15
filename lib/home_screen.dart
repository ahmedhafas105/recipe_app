import 'dart:io'
    show
        File,
        Platform; // Conditional import for mobile, added to support FileImage
import 'package:flutter/foundation.dart'
    show
        kIsWeb; // Added for web detection to handle platform-specific image loading
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'recipe_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ingredientsController = TextEditingController();
  String? _dietaryRestrictions;
  final List<String> _allergens = [];
  Map<String, dynamic>? _recipe;
  bool _isLoading = false;
  String? _error;
  XFile? _selectedImage;

  Future<void> _generateRecipe() async {
    if (_selectedImage == null && _ingredientsController.text.isEmpty) {
      setState(() {
        _error = 'Please upload an image or enter ingredients';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _recipe = null;
    });

    try {
      List<String> ingredients;
      if (_selectedImage != null) {
        ingredients = await RecipeService.identifyIngredientsFromImage(
          _selectedImage!,
        );
        _ingredientsController.text = ingredients.join(', ');
      } else {
        ingredients =
            _ingredientsController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
      }

      if (ingredients.isEmpty) {
        throw Exception('No ingredients provided');
      }

      final recipe = await RecipeService.generateRecipe(
        ingredients: ingredients,
        dietaryRestrictions: _dietaryRestrictions,
        allergens: _allergens,
      );
      setState(() => _recipe = recipe);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Camera permission denied',
            style: TextStyle(fontFamily: 'Aldrich'),
          ),
        ),
      );
      return;
    }

    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _error = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No image selected',
            style: TextStyle(fontFamily: 'Aldrich'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Recipe Generator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Aldrich',
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image:
                        kIsWeb
                            ? NetworkImage(
                              _selectedImage!.path,
                            ) // Retains web compatibility with NetworkImage
                            : FileImage(
                              File(_selectedImage!.path),
                            ), // Changed from NetworkImage to FileImage for mobile to display local file paths
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  label: Text(
                    'Ingredients (comma separated)',
                    style: TextStyle(fontFamily: 'Aldrich'),
                  ),
                  hintText: 'e.g., chicken, rice, tomatoes',
                  hintStyle: TextStyle(fontFamily: 'Aldrich'),
                  prefixIcon: const Icon(Icons.food_bank),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: Text(
                  'Dietary Restrictions',
                  style: TextStyle(fontFamily: 'Aldrich'),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items:
                  ['None', 'Vegetarian', 'Vegan', 'Keto', 'Gluten-Free']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(fontFamily: 'Aldrich'),
                          ),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(() => _dietaryRestrictions = value),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children:
                  ['Nuts', 'Dairy', 'Eggs', 'Shellfish'].map((allergen) {
                    return FilterChip(
                      label: Text(
                        allergen,
                        style: TextStyle(fontFamily: 'Aldrich'),
                      ),
                      selected: _allergens.contains(allergen),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? _allergens.add(allergen)
                              : _allergens.remove(allergen);
                        });
                      },
                      selectedColor: Colors.blue.withOpacity(0.2),
                      checkmarkColor: Colors.blue,
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        'Generate Recipe',
                        style: TextStyle(fontSize: 16, fontFamily: 'Aldrich'),
                      ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Tuffy',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_recipe != null) _RecipeDisplay(recipe: _recipe!),
          ],
        ),
      ),
    );
  }
}

class _RecipeDisplay extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _RecipeDisplay({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe['title'] ?? 'Untitled Recipe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontFamily: 'Aldrich',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cooking Time: ${recipe['cooking_time'] ?? 'N/A'}',
              style: TextStyle(
                fontFamily: 'Tuffy',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Difficulty: ${recipe['difficulty'] ?? 'N/A'}',
              style: TextStyle(
                fontFamily: 'Tuffy',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Aldrich',
              ),
            ),
            ...?recipe['ingredients']
                ?.map<Widget>(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '• ${item['quantity']} ${item['name']}',
                      style: TextStyle(fontFamily: 'Tuffy', fontWeight: FontWeight.bold,),
                    ),
                  ),
                )
                ?.toList(),
            const SizedBox(height: 12),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Aldrich',
              ),
            ),
            ...?recipe['instructions']
                ?.map<Widget>(
                  (step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      step,
                      style: TextStyle(fontFamily: 'Tuffy', fontWeight: FontWeight.bold,),
                    ),
                  ),
                )
                ?.toList(),
            const SizedBox(height: 12),
            const Text(
              'Nutrition:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Aldrich',
              ),
            ),
            if (recipe['nutrition'] != null)
              Text(
                'Calories: ${recipe['nutrition']['calories'] ?? 'N/A'}, Protein: ${recipe['nutrition']['protein'] ?? 'N/A'}',
                style: TextStyle(fontFamily: 'Tuffy', fontWeight: FontWeight.bold,),
              ),
            const SizedBox(height: 12),
            const Text(
              'Allergen Warnings:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'Aldrich',
              ),
            ),
            if (recipe['allergen_warnings'] != null)
              ...recipe['allergen_warnings']
                      .map<Widget>(
                        (warning) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '• $warning',
                            style: const TextStyle(color: Colors.red, fontFamily: 'Tuffy'),
                          ),
                        ),
                      )
                      ?.toList() ??
                  [const Text('None', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tuffy'),)],
          ],
        ),
      ),
    );
  }
}
