import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Espectrofotómetro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A6B2C)),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF35551B),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A6B2C),
          ),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomePage(),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                             QuantumFrame Base                              */
/* -------------------------------------------------------------------------- */
class QuantumFrame extends StatelessWidget {
  final Widget child;
  final String headerTitle;
  final String? logoAsset;
  final String? frogAsset;

  const QuantumFrame({
    super.key,
    required this.child,
    required this.headerTitle,
    this.logoAsset,
    this.frogAsset,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Fondo con olas
          const Positioned.fill(child: WaveBackground()),

          /// Contenido principal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),

              /// Header: logo + título
              Row(
                children: [
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: size.width * 0.08,
                    backgroundColor: const Color(0xFFDCE6D9),
                    child: ClipOval(
                      child: (logoAsset == null)
                          ? Text(
                              "Logo\nproyecto",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.width * 0.025,
                                color: const Color(0xFF35551B),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Image.asset(logoAsset!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EAE3),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      headerTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),

              /// Contenido central
              Expanded(child: Center(child: child)),

              /// Espacio para que las olas no tapen
              SizedBox(height: size.height * 0.12),
            ],
          ),

          /// Cuadro de la ranita
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              width: size.width * 0.18,
              height: size.width * 0.18,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4A6B2C), width: 2),
              ),
              child: (frogAsset == null)
                  ? const Center(
                      child: Text(
                        "Ranita",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    )
                  : Image.asset(frogAsset!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                            Fondo con olas verdes                           */
/* -------------------------------------------------------------------------- */
class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: WavePainter());
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Ola clara
    Path path1 = Path();
    path1.lineTo(0, size.height * 0.85);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.90,
      size.width * 0.5,
      size.height * 0.85,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.80,
      size.width,
      size.height * 0.85,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    paint.color = const Color(0xFFDCE6D9); // verde claro
    canvas.drawPath(path1, paint);

    // Ola intermedia
    Path path2 = Path();
    path2.lineTo(0, size.height * 0.90);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.90,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width,
      size.height * 0.90,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    paint.color = const Color(0xFF9BB59E); // verde medio
    canvas.drawPath(path2, paint);

    // Ola oscura
    Path path3 = Path();
    path3.lineTo(0, size.height * 0.95);
    path3.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.95,
    );
    path3.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.90,
      size.width,
      size.height * 0.95,
    );
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    paint.color = const Color(0xFF4A6B2C); // verde oscuro
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* -------------------------------------------------------------------------- */
/*                              HomePage ejemplo                              */
/* -------------------------------------------------------------------------- */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Maleta cuántica',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD9DCD6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '¿Qué quieres hacer hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF58624D),
            ),
          ),
        ),
        const SizedBox(height: 22),

        Row(
          children: [
            Expanded(
              child: _PrimaryButton(
                labelTop: 'Realizar',
                labelBottom: 'mediciones',
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _PrimaryButton(labelTop: 'Aprender', onPressed: () {}),
            ),
          ],
        ),
      ],
    );

    return QuantumFrame(
      headerTitle: 'Espectrofotómetro',
      logoAsset: 'assets/images/logo.png',
      frogAsset: 'assets/images/frog.png',
      child: content,
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                          Botones personalizados                            */
/* -------------------------------------------------------------------------- */
class _PrimaryButton extends StatelessWidget {
  final String labelTop;
  final String? labelBottom;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.labelTop,
    required this.onPressed,
    this.labelBottom,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A6B2C),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelTop,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          if (labelBottom != null)
            Text(
              labelBottom!,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
