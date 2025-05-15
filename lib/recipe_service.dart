import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class RecipeService {
  static final _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyCZZ08VAqhohiRjIfbOeAWU2UOFpck87SY',
  );

  // Method to identify ingredients from an image
  static Future<List<String>> identifyIngredientsFromImage(XFile image) async {
    try {
      final imageByte = await image.readAsBytes();
      final prompt = '''
      Identify the ingredients visible in this image. Return the list of ingredients as a comma-separated string (e.g., "chicken, rice, tomatoes").
      ''';

      final content = [
        Content.multi([
          DataPart('image/JPG', imageByte), // Assuming the image is JPEG; adjust if needed
          TextPart(prompt),
        ]),
      ];

      final response = await _model.generateContent(content);
      final ingredientsText = response.text?.trim() ?? '';
      if (ingredientsText.isEmpty) {
        throw Exception('No ingredients identified from the image');
      }
      return ingredientsText.split(',').map((e) => e.trim()).toList();
    } catch(e) {
      throw Exception('Failed to identify ingredients: $e');
    }
  }

  // Method to generate a recipe based on ingredients
  static Future<Map<String, dynamic>> generateRecipe({
    required List<String> ingredients,
    String? dietaryRestrictions,
    List<String>? allergens,
  }) async {
    final ingredientsText = ingredients.join(', ');
    final prompt = '''
    Create a detailed recipe using these ingredients: $ingredientsText
    Dietary requirements: ${dietaryRestrictions ?? 'none'}
    Allergens to avoid: ${allergens?.join(', ') ?? 'none'}

    Format response as JSON:
    {
      "title": "Recipe title",
      "ingredients": [
        {"name": "ingredient", "quantity": "1 cup"}
      ],
      "instructions": ["step 1", "step 2"],
      "cooking_time": "30 mins",
      "difficulty": "Easy",
      "nutrition": {
        "calories": "500",
        "protein": "20g"
      },
      "allergen_warnings": ["Contains Dairy", "May contain Nuts"]
    }
    ''';

    try {
      final response = await _model.generateContent(
        [Content.text(prompt)],
        safetySettings: [
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        ],
      );
      return _parseResponse(response.text ?? '');
    } catch (e) {
      throw Exception('Failed to generate recipe: $e');
    }
  }

  static Map<String, dynamic> _parseResponse(String response) {
    try {
      // Remove markdown and extra text (e.g., ```json or other annotations)
      String cleaned = response
          .replaceAll(RegExp(r'```json|```|```plaintext'), '')
          .trim();

      // Handle cases where the response might not be valid JSON
      // Try to extract JSON if it's embedded in a larger text
      final jsonStart = cleaned.indexOf('{');
      final jsonEnd = cleaned.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        cleaned = cleaned.substring(jsonStart, jsonEnd);
      }

      // Attempt to decode the JSON
      final parsed = jsonDecode(cleaned);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
      throw Exception('Response is not a valid JSON object');
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }
}

