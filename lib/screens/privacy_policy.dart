import 'package:flutter/material.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      bodyContent: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _sectionTitle(context, 'Política de Privacidad de Royal App'),
              _sectionText(context,
                  'Esta política detalla cómo recopilamos, utilizamos y protegemos tu información personal cuando usas nuestra aplicación Royal App, diseñada para los fanáticos de la Kings League.'),
              SizedBox(height: 10),
              _sectionTitle(context, '¿Qué información recopilamos?'),
              _listViewItems([
                '• Correo electrónico: Para crear una cuenta y recibir notificaciones sobre actualizaciones y eventos.',
                '• Datos de juego: Tu progreso en el juego, puntuaciones y estadísticas para personalizar tu experiencia.',
              ]),
              SizedBox(height: 10),
              _sectionTitle(context, '¿Cómo utilizamos tu información?'),
              _listViewItems([
                '• Para crear y mantener tu cuenta de usuario.',
                '• Para personalizar tu experiencia de juego, mostrándote contenido relevante.',
                '• Para comunicarnos contigo sobre actualizaciones, eventos y promociones relacionadas con Royal App.',
                '• Para mejorar nuestra aplicación y servicios.',
              ]),
              SizedBox(height: 10),
              _sectionTitle(context, '¿Cómo protegemos tu información?'),
              _listViewItems([
                '• Implementamos medidas de seguridad sólidas para proteger tu información personal de acceso no autorizado, alteración, divulgación o destrucción.',
              ]),
              SizedBox(height: 10),
              _sectionTitle(context, 'Tus derechos'),
              _listViewItems([
                '• Tienes derecho a acceder, corregir, actualizar o eliminar tu información personal en cualquier momento.',
              ]),
              SizedBox(height: 10),
              _sectionTitle(context, 'Cambios en esta política'),
              _listViewItems([
                '• Podemos actualizar esta política de privacidad ocasionalmente. Te notificaremos cualquier cambio significativo.',
              ]),
              SizedBox(height: 10),
              _sectionTitle(context, 'Contacto'),
              _listViewItems([
                '• Si tienes alguna pregunta sobre esta política de privacidad, contáctanos a royalappcontact@gmail.com.',
              ]),
            ],
          ),
        ),
      ],
      showAppBar: false,
      showAdColumnLeft: false,
      showAdColumnRight: false,
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _sectionText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontSize: 12,
          ),
    );
  }

  Widget _listViewItems(List<String> items) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: items.map((item) {
        return Text(
          item,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        );
      }).toList(),
    );
  }
}
