import 'package:ummobile/statics/widgets/overlays/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

//método para abrir los url de los eventos en un explorador secundario
openExternalExplorer(String siteUrl) async {
  if (await canLaunch(siteUrl)) {
    await launch(siteUrl);
  } else {
    snackbarMessage("No se logró abrir el URL", "Ocurrió un error inesperado");
  }
}
