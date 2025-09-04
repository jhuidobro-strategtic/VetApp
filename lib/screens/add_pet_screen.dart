import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController =
      TextEditingController(); // <- ESTE
  String? selectedSpecies;
  String? selectedGender;
  DateTime? selectedDate;
  File? _image;

  final List<String> speciesOptions = ["Dog", "Cat", "Bird"];
  final List<String> genderOptions = ["Male", "Female"];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }

    @override
    void dispose() {
      _nameController.dispose();
      //_typeController.dispose();
      _birthDateController.dispose(); // <- IMPORTANTE liberar memoria
      super.dispose();
    }
  }

  Widget _buildFormField({required Widget child}) {
    // 🔹 Reutilizable para sombra + borde redondeado
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register New Pet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Nombre
              _buildFormField(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.pets, color: Colors.black87),
                    hintText: "Nombre de la mascota",
                    labelText: "Nombre",
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                ),
              ),

              // 🔹 Especie
              _buildFormField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.category,
                      color: Colors.black87,
                    ),
                    labelText: "Especie",
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  items: ["Dog", "Cat", "Bird"].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSpecies = value;
                    });
                  },
                ),
              ),

              // 🔹 Género
              _buildFormField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.transgender_outlined,
                      color: Colors.black87,
                    ),
                    labelText: "Gender",
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  items: ["Male", "Female"].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ),
              // _buildFormField(
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide.none,
              //       ),
              //       prefixIcon: const Icon(Icons.transgender),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //     hint: const Text("Select Gender"),
              //     value: selectedGender,
              //     items: genderOptions.map((gender) {
              //       return DropdownMenuItem(value: gender, child: Text(gender));
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedGender = value;
              //       });
              //     },
              //   ),
              // ),

              // 🔹 Fecha de nacimiento
              _buildFormField(
                child: TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.black87,
                    ),
                    labelText: "Fecha de Nacimiento",
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    hintText: "Selecciona una fecha",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _birthDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                // child: ListTile(
                //   leading: const Icon(Icons.calendar_today),
                //   title: Text(
                //     selectedDate == null
                //         ? "Select Birth Date"
                //         : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                //     style: GoogleFonts.poppins(),
                //   ),
                //   onTap: _pickDate,
                // ),
              ),

              // 🔹 Subir Foto
              _buildFormField(
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: _image == null
                        ? const Center(child: Text("Tap to upload photo"))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Botón Register
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pet agregado con éxito")),
                    );
                  },
                  child: Text(
                    "REGISTER",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
