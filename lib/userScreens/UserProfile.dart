import 'dart:convert';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:fit_track/model/User.dart';
import 'package:fit_track/provider/UserProvider.dart';
import 'package:fit_track/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _emailController = TextEditingController(text: user.email);
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _heightController = TextEditingController(text: user.height.toString());
    _weightController = TextEditingController(text: user.weight.toString());
  }

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _authService.uploadProfilePicture(context, pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'user Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickImage(context);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.profilePicture.isNotEmpty
                          ? MemoryImage(base64Decode(user.profilePicture))
                          : AssetImage('assets/default_avatar.png'),
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(_firstNameController, 'FirstName', Icons.person),
              _buildTextField(_lastNameController, 'LastName', Icons.person),
              _buildTextField(
                _heightController,
                'Height (cm)',
                Icons.height,
                isNumeric: true,
              ),
              _buildTextField(
                _weightController,
                'Weight (kg)',
                Icons.fitness_center,
                isNumeric: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = User(
                      email: _emailController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      height: double.parse(_heightController.text),
                      weight: double.parse(_weightController.text),
                      profilePicture: user.profilePicture,
                    );
                    await _authService.updateUserInfo(context, updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Informations has been updated')),
                    );
                  }
                },
                child: Text('save modifications'),
              ),
              SizedBox(height: 40),
              _LogoutButton(
                onPressed: () {
                  _authService.logout(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumeric = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.logout, size: 20),
      label: Text('Disconnect'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }
}
