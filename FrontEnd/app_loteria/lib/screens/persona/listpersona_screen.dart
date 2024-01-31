import 'dart:convert';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/screens/persona/editpersona_screen.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';
import 'package:app_loteria/models/Persona.dart';
import 'package:app_loteria/screens/persona/createperonsa_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPersonaScreen extends StatefulWidget {
  @override
  _ListPersonaScreenState createState() => _ListPersonaScreenState();
}

class UserDataProvider {
  static Future<Usuario> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Usuario(
      usuarioId: prefs.getInt('usuarioId') ?? 0,
      nombreUsuario: prefs.getString('nombreUsuario') ?? '',
      contrasena: '',
      imagen: prefs.getString('imagen') ?? '',
      fechaCreacion: DateTime.now(),
      personaId: prefs.getInt('personaId'),
      sucursalId: prefs.getInt('sucursalId') ?? 0,
      usuarioCreacion: 0,
      admin: prefs.getInt('admin') == 1,
    );
  }
}

class _ListPersonaScreenState extends State<ListPersonaScreen> {
  List<Persona> personas = [];
  List<Persona> filteredPersonas = [];
  late Usuario _userProfile;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPersonList();
    _loadUserData();
  }

  Future<void> _fetchPersonList() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}Persona/Listado'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          personas = data.map((item) {
            // Convertir las fechas de String a DateTime
            item['fechaCreacion'] = DateTime.parse(item['fechaCreacion']);
            item['fechaModificacion'] = item['fechaModificacion'] != null
                ? DateTime.parse(item['fechaModificacion'])
                : null;

            return Persona.fromJson(item);
          }).toList();
          filteredPersonas = List.from(personas);
        });
      } else {
        // Manejar el error de la solicitud HTTP
        print('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de red u otros
      print('Error: $e');
    }
  }

  @override
  void _loadUserData() async {
    Usuario userProfile = await UserDataProvider.getUserData();
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _filterPersonas(String query) {
    setState(() {
      filteredPersonas = personas
          .where((persona) =>
              persona.nombres.toLowerCase().contains(query.toLowerCase()) ||
              (persona.apellidos != null &&
                  persona.apellidos!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (persona.identidad != null && persona.identidad!.contains(query)))
          .toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Listado de Personas',
        profileImageUrl: _userProfile.imagen,
        onProfilePressed: () {},
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPersonForm()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorPalette.darkblueColorApp,
              minimumSize: const Size(365.0, 45.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Nuevo',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterPersonas,
              decoration: InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPersonas.length,
              itemBuilder: (context, index) {
                final persona = filteredPersonas[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title:
                        Text('${persona.nombres} ${persona.apellidos ?? ''}'),
                    subtitle: Text('Identidad: ${persona.identidad ?? 'N/A'}'),
                    trailing: IconButton(
                      onPressed: () {
                        // Redirecciona a EditPersonForm y pasa la información de la persona
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPersonForm(persona: persona),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit), // Icono de editar
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
