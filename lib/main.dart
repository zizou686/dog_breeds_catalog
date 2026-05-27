import 'package:flutter/material.dart';
import 'package:dog_breeds_catalog/models/dog_breed.dart';
import 'package:dog_breeds_catalog/models/user.dart';
import 'package:dog_breeds_catalog/services/dog_service.dart';
import 'package:dog_breeds_catalog/services/auth_service.dart';

void main() => runApp(const DogBreedsApp());

class DogBreedsApp extends StatefulWidget {
  const DogBreedsApp({super.key});

  @override
  State<DogBreedsApp> createState() => _DogBreedsAppState();
}

class _DogBreedsAppState extends State<DogBreedsApp> {
  User? _currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Razas de Perros',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.light,
      ),
      home: _currentUser == null
          ? LoginScreen(
              onLoginSuccess: (user) {
                setState(() => _currentUser = user);
              },
            )
          : HomeScreen(
              user: _currentUser!,
              onLogout: () {
                setState(() => _currentUser = null);
              },
            ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function(User) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  Future<void> _handleAuth() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      User? user;
      if (_isLogin) {
        user = await _authService.login(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );
      } else {
        user = await _authService.signup(
          _usernameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );
      }

      if (user != null) {
        widget.onLoginSuccess(user);
      } else {
        setState(() =>
            _error = _isLogin ? 'Usuario o contraseña incorrectos' : 'Usuario ya existe');
      }
    } catch (e) {
      setState(() => _error = 'Error: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐕 Catálogo de Razas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                _isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameCtrl,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLogin)
                Column(
                  children: [
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() {
                  _isLogin = !_isLogin;
                  _error = null;
                }),
                child: Text(
                  _isLogin
                      ? '¿No tienes cuenta? Crear una'
                      : '¿Ya tienes cuenta? Inicia sesión',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Credenciales de prueba:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Usuario: admin'),
                    Text('Contraseña: 123456'),
                    SizedBox(height: 8),
                    Text('Usuario: user'),
                    Text('Contraseña: password'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.user, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DogService _service = DogService();
  final TextEditingController _searchCtrl = TextEditingController();
  List<DogBreed> _breeds = [];
  List<DogBreed> _filteredBreeds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
    _searchCtrl.addListener(_filterBreeds);
  }

  Future<void> _loadBreeds() async {
    try {
      final breeds = await _service.getBreeds();
      setState(() {
        _breeds = breeds;
        _filteredBreeds = breeds;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _filterBreeds() {
    final query = _searchCtrl.text;
    if (query.isEmpty) {
      setState(() => _filteredBreeds = _breeds);
    } else {
      setState(() {
        _filteredBreeds = _breeds
            .where((breed) =>
                breed.name.toLowerCase().contains(query.toLowerCase()) ||
                breed.temperament.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _navigateToCreateBreed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreedFormScreen(
          onSave: (breed) async {
            await _service.createBreed(breed);
            _loadBreeds();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐕 Razas de Perros'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(widget.user.username, style: const TextStyle(fontSize: 14)),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                widget.onLogout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar Sesión'),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Buscar raza...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredBreeds.isEmpty
                      ? Center(
                          child: Text(
                            _searchCtrl.text.isEmpty
                                ? 'No hay razas disponibles'
                                : 'No se encontraron razas',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredBreeds.length,
                          itemBuilder: (context, index) {
                            final breed = _filteredBreeds[index];
                            return BreedCard(
                              breed: breed,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BreedDetailScreen(breed: breed, onDelete: () async {
                                          await _service.deleteBreed(breed.id);
                                          _loadBreeds();
                                          Navigator.pop(context);
                                        }, onEdit: (updatedBreed) async {
                                          await _service.updateBreed(breed.id, updatedBreed);
                                          _loadBreeds();
                                          Navigator.pop(context);
                                        }),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateBreed,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BreedCard extends StatelessWidget {
  final DogBreed breed;
  final VoidCallback onTap;

  const BreedCard({
    super.key,
    required this.breed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text('🐕', style: TextStyle(fontSize: 28)),
          ),
        ),
        title: Text(
          breed.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          breed.size,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class BreedDetailScreen extends StatelessWidget {
  final DogBreed breed;
  final VoidCallback onDelete;
  final Function(DogBreed) onEdit;

  const BreedDetailScreen({
    super.key,
    required this.breed,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreedFormScreen(
                    breed: breed,
                    onSave: (updatedBreed) {
                      onEdit(updatedBreed);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar Eliminación'),
                  content: Text('¿Eliminar ${breed.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete();
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade300, Colors.amber.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text('🐕', style: TextStyle(fontSize: 100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Descripción', breed.description),
                  const SizedBox(height: 20),
                  _buildInfoRow('Origen', breed.origin, Icons.location_on),
                  const SizedBox(height: 16),
                  _buildInfoRow('Tamaño', breed.size, Icons.height),
                  const SizedBox(height: 16),
                  _buildInfoRow('Esperanza de vida', breed.lifeSpan, Icons.cake),
                  const SizedBox(height: 20),
                  _buildInfoSection('Temperamento', breed.temperament),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BreedFormScreen extends StatefulWidget {
  final DogBreed? breed;
  final Function(DogBreed) onSave;

  const BreedFormScreen({
    super.key,
    this.breed,
    required this.onSave,
  });

  @override
  State<BreedFormScreen> createState() => _BreedFormScreenState();
}

class _BreedFormScreenState extends State<BreedFormScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _originCtrl;
  late TextEditingController _temperamentCtrl;
  late TextEditingController _sizeCtrl;
  late TextEditingController _lifeSpanCtrl;
  late TextEditingController _descriptionCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.breed?.name ?? '');
    _originCtrl = TextEditingController(text: widget.breed?.origin ?? '');
    _temperamentCtrl = TextEditingController(text: widget.breed?.temperament ?? '');
    _sizeCtrl = TextEditingController(text: widget.breed?.size ?? '');
    _lifeSpanCtrl = TextEditingController(text: widget.breed?.lifeSpan ?? '');
    _descriptionCtrl = TextEditingController(text: widget.breed?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _originCtrl.dispose();
    _temperamentCtrl.dispose();
    _sizeCtrl.dispose();
    _lifeSpanCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es requerido')),
      );
      return;
    }

    final breed = DogBreed(
      id: widget.breed?.id ?? '',
      name: _nameCtrl.text,
      origin: _originCtrl.text,
      temperament: _temperamentCtrl.text,
      size: _sizeCtrl.text,
      lifeSpan: _lifeSpanCtrl.text,
      description: _descriptionCtrl.text,
    );

    widget.onSave(breed);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.breed == null ? 'Nueva Raza' : 'Editar Raza'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Ej: Labrador Retriever',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _originCtrl,
                decoration: InputDecoration(
                  labelText: 'Origen',
                  hintText: 'Ej: Canada',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _temperamentCtrl,
                decoration: InputDecoration(
                  labelText: 'Temperamento',
                  hintText: 'Ej: Friendly, Outgoing',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sizeCtrl,
                decoration: InputDecoration(
                  labelText: 'Tamaño',
                  hintText: 'Ej: Large, Medium, Small',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lifeSpanCtrl,
                decoration: InputDecoration(
                  labelText: 'Esperanza de Vida',
                  hintText: 'Ej: 10-12 years',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionCtrl,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Descripción de la raza...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.breed == null ? 'Crear Raza' : 'Actualizar Raza',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
