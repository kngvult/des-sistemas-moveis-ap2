import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3), // Azul vibrante para modo claro
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21), // Azul escuro para modo escuro
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      themeMode: ThemeMode.system,
      home: const IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  IMCCalculatorState createState() => IMCCalculatorState();
}

class IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _selectedGender = 'Homem';
  bool _isDarkMode = false;

  void _calculateIMC() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira valores válidos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double heightInMeters = height / 100;
    final double imc = weight / (heightInMeters * heightInMeters);

    String classification;
    if (imc < 18.5) {
      classification = 'Abaixo do peso';
    } else if (imc < 25) {
      classification = 'Normal';
    } else if (imc < 30) {
      classification = 'Sobrepeso';
    } else if (imc < 35) {
      classification = 'Obesidade Classe I';
    } else if (imc < 40) {
      classification = 'Obesidade Classe II';
    } else {
      classification = 'Obesidade Classe III';
    }

    // Mostrar o diálogo com os resultados
    _showResultsDialog(imc, classification);
  }

  void _showResultsDialog(double imc, String classification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: _isDarkMode ? const Color(0xFF1D1E33) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seu IMC',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gauge personalizado
                  _buildIMCGauge(imc),

                  const SizedBox(height: 10),
                  Text(
                    classification,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getClassificationColor(imc),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tabela de Classificação do IMC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildBMICategory(
                    'Menos de 18.5',
                    'Abaixo do peso',
                    Colors.blue,
                  ),
                  _buildBMICategory('18.5 a 24.9', 'Normal', Colors.green),
                  _buildBMICategory('25 a 29.9', 'Sobrepeso', Colors.orange),
                  _buildBMICategory('30 ou mais', 'Obesidade', Colors.red),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetFields();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB1555),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Calcular Novamente',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIMCGauge(double imc) {
    double maxImc = 40.0;
    double percentage = imc / maxImc;
    if (percentage > 1.0) percentage = 1.0;

    Color gaugeColor = _getClassificationColor(imc);

    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 15.0,
      percent: percentage,
      progressColor: gaugeColor,
      backgroundColor: _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1200,
      startAngle: 180,
      arcType: ArcType.HALF,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            imc.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            'IMC',
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.grey : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMICategory(String range, String category, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1D1E33) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withAlpha((255 * 0.3).round()),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            range,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: _isDarkMode ? Colors.grey : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFields() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _selectedGender = 'Homem';
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isDarkMode ? const Color(0xFF0A0E21) : Colors.grey[100];
    final cardColor = _isDarkMode ? const Color(0xFF1D1E33) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    // Cor da AppBar baseada no tema
    final appBarColor = _isDarkMode
        ? const Color(0xFF0A0E21) // Azul escuro para modo escuro
        : const Color(0xFF2196F3); // Azul vibrante para modo claro

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarColor, // Usando a cor baseada no tema
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: _isDarkMode ? 'Modo claro' : 'Modo escuro',
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender selection
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Homem';
                      });
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _selectedGender == 'Homem'
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (_selectedGender == 'Homem')
                            BoxShadow(
                              color: Colors.blue.withAlpha((255 * 0.3).round()),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/male.png', width: 80),
                          const SizedBox(height: 10),
                          Text(
                            'Homem',
                            style: TextStyle(fontSize: 18, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Mulher';
                      });
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _selectedGender == 'Mulher'
                              ? Colors.pink
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (_selectedGender == 'Mulher')
                            BoxShadow(
                              color: Colors.pink.withAlpha((255 * 0.3).round()),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/female.png', width: 80),
                          const SizedBox(height: 10),
                          Text(
                            'Mulher',
                            style: TextStyle(fontSize: 18, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Weight input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seu peso (kg)',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isDarkMode ? Colors.grey : Colors.grey[700],
                    ),
                  ),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 40,
                        color: _isDarkMode ? Colors.grey : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Height input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sua altura (cm)',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isDarkMode ? Colors.grey : Colors.grey[700],
                    ),
                  ),
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 40,
                        color: _isDarkMode ? Colors.grey : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Calculate button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _calculateIMC,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB1555),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Calcule seu IMC',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getClassificationColor(double imc) {
    if (imc < 18.5) {
      return Colors.blue;
    } else if (imc < 25) {
      return Colors.green;
    } else if (imc < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
