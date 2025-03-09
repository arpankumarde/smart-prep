import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class StudyMaterialsPage extends StatelessWidget {
  const StudyMaterialsPage({super.key});

  final String studyMaterials = """
It appears you're requesting study materials on national symbols and geographical features.  

Let's break down these topics to help you study effectively.  

**I. National Symbols**  

National symbols are objects, emblems, figures or creatures used to represent a particular country. Understanding them can provide insights into a nation's history, culture, values, and identity.

**Tips for Studying:**

* **Categorize:** Group symbols into categories like animals, plants, colors, monuments, etc. This helps visualize connections.
* **Context:** Don't just memorize. Research the symbolism behind each symbol. Why was it chosen? What does it represent?
* **Create Flashcards:** For quick revision, make flashcards with the symbol on one side and its meaning and associated country on the other.

**Examples:**

* **Lion:** Strength, courage (e.g., England, Singapore)
* **Eagle:** Freedom, power (e.g., United States, Mexico)
* **Maple Leaf:** Canada

**II. Geographical Features**  

Geographical features are natural shapes or formations on the Earth's surface. Understanding these features helps grasp global climate patterns, biodiversity, and human interaction with the environment.

**Tips for Studying:**

* **Map It Out:** Use maps to locate major geographical features.
* **Visualize:** Try to imagine the landscapes and climates associated with different features.
* **Connect the Dots:** Relate geographical features to ecosystems, climates, and human settlements.

**Examples:**

* **Rainforests:** Found near the equator, with high biodiversity and rainfall.
  * **Amazon Rainforest:** Largest rainforest in the world.
* **Deserts:** Arid regions with little rainfall and extreme temperatures.
  * **Sahara Desert:** Largest hot desert globally.
* **Mountains:** Landforms rising significantly above the surrounding terrain.
  * **Himalayas:** Highest mountain range in the world.
* **Jungles:** Densely forested areas with high humidity and warmth.
  * **Congo Rainforest:** Second-largest rainforest in the world.

**Remember:**

* Use a variety of visual aids, like maps, diagrams, and images.
* Actively read and take notes.
* Test your knowledge with practice questions and quizzes.

Best of luck with your studies!
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Materials'),
      ),
      body: SafeArea(
        child: Markdown(
          data: studyMaterials,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}