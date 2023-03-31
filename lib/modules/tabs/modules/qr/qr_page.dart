import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // Importa el escaneo de
import '../calendar/views/calendar_page.dart'; // Importa la pantalla de calendario
import '../conectate/views/conectate_page.dart'; // Importa la pantalla de conectate

// Define una pantalla que escanea códigos QR y muestra el resultado en una pantalla separada
class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

// Define la funcionalidad de la pantalla de escaneo de códigos QR
class _QrPageState extends State<QrPage> {
  // Inicializa el resultado del escaneo con un valor predeterminado
  var getResultado = 'Codigo QR Resultado';

  // El método initState se llama una vez cuando se crea esta pantalla.
  // En este caso, se llama al método scanQRCode() para escanear un código QR una vez que la pantalla se carga.
  @override
  void didUpdateWidget(QrPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) scanQRCode();
  }

  @override
  void initState() {
    super.initState();
    scanQRCode();
  }

  // Este método utiliza el paquete flutter_barcode_scanner para escanear códigos QR.
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'ATRAS', false, ScanMode.QR);
      // Si el resultado se escanea correctamente, actualiza el estado de la clase _QrPageState con el resultado.
      if (!mounted) return;
      setState(() {
        getResultado = qrCode;
      });

      // Muestra la pantalla correspondiente al resultado escaneado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoScreen(resultado: qrCode),
        ),
      );
    } on PlatformException {
      // Si no se pudo escanear el código QR, actualiza el estado de la clase _QrPageState con un mensaje de error.
      setState(() {
        getResultado = 'No se pudo escanear el código QR';
      });
    }
  }

  // El método build() se llama cada vez que se actualiza el estado de la pantalla.
  // En este caso, devuelve un Scaffold vacío.
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// Define una pantalla que muestra el resultado del escaneo de códigos QR
class ResultadoScreen extends StatelessWidget {
  // Toma una cadena de resultado como argumento
  final String resultado;
  ResultadoScreen({required this.resultado});

  // Este mapa se utiliza para devolver la pantalla correspondiente al resultado.
  final Map<String, dynamic> paginas = {
    "-1": ConectatePage(),
    "1": CalendarPage(),
  };

  // El método build() se llama cada vez que se actualiza el estado de la pantalla.
  // En este caso, devuelve la pantalla correspondiente al resultado escaneado.
  @override
  Widget build(BuildContext context) {
    return paginas[resultado];
  }
}
