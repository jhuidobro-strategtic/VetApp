import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/models/maestros.dart';
import 'package:mobile_vet_app/screens/success_dialog.dart';
import 'package:mobile_vet_app/services/api_service_maestro.dart';
import 'package:mobile_vet_app/services/service_pet.dart';
import 'app_config.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  //String? selectedSpecies;
  //String? selectedGender;
  //String? selectedBreed;

  File? _imageFile;
  bool _isLoading = false;

  DateTime? selectedDate;
  File? _image;

  MaestroTipo? _selectedTipo;
  MaestroTipo? _selectedGender;
  MaestroTipo? _selectedBreed;

  List<MaestroTipo> _tipos = [];
  List<MaestroTipo> _genderOptions = [];
  List<MaestroTipo> _breedOptions = [];
  bool _loadingTipos = true;

  bool _hasNameError = false;
  bool _hasWeigthError = false;
  bool _hasSpecieError = false;
  bool _hasBreedError = false;
  bool _hasGenderError = false;
  bool _hasBirthDateError = false;

  //final List<String> speciesOptions = ["Dog", "Cat", "Bird"];
  //final List<String> genderOptions = ["Male", "Female"];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // para mostrar en UI
        _imageFile = File(pickedFile.path); // para enviar en el POST
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
  }

  @override
  void initState() {
    super.initState();
    _fetchTipos();
    _fetchTiposGender();
    _fetchTiposBreed();
  }

  Future<void> _fetchTipos() async {
    try {
      final apiService = ApiService();
      final tipos = await apiService.getMaestroTipos(1);
      setState(() {
        _tipos = tipos;
        _loadingTipos = false;
      });
    } catch (e) {
      setState(() => _loadingTipos = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando especies: $e")));
    }
  }

  Future<void> _fetchTiposGender() async {
    try {
      final apiService = ApiService();
      final genderOptions = await apiService.getMaestroTipos(9);
      setState(() {
        _genderOptions = genderOptions;
        _loadingTipos = false;
      });
    } catch (e) {
      setState(() => _loadingTipos = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando generos: $e")));
    }
  }

  Future<void> _fetchTiposBreed() async {
    try {
      final apiService = ApiService();
      final breedOptions = await apiService.getMaestroTipos(2);
      setState(() {
        _breedOptions = breedOptions;
        _loadingTipos = false;
      });
    } catch (e) {
      setState(() => _loadingTipos = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando razas: $e")));
    }
  }

  final PetService _petService = PetService();

  Future<void> _registerPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _petService.registerPet(
        clientID: "2",
        name: _nameController.text.trim(),
        specie: _selectedTipo!.id.toString(),
        breed: _selectedBreed!.id.toString(),
        gender: _selectedGender!.id.toString(),
        birthDate: _birthDateController.text.trim(),
        weight: _weightController.text.trim(),
        imageFile: _imageFile,
      );

      final body = jsonDecode(result["body"]);
      print("body: $body");
      print("a: $body[success]");
      print("b: $result[success]");
      if (result["success"]) {
        showDialog(
          context: context,
          barrierDismissible: false, // evitar cerrar tocando afuera
          builder: (context) {
            return SuccessDialog(
              message: body["message"] ?? "Mascota registrada con éxito",
              onAccept: () {
                Navigator.pop(context); // cerrar el dialog
                Navigator.pop(context, true); // regresar a PetsScreen con éxito
              },
            );
          },
        );
      } else {
        print("entra al else");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body["message"] ?? "Error al registrar la mascota"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    //_typeController.dispose();
    _birthDateController.dispose(); // <- IMPORTANTE liberar memoria
    super.dispose();
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
          child: Form(
            key: _formKey, // 👈 importante
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Nombre
                _buildFormField(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.arrow_outward_rounded,
                        color: _hasNameError ? Colors.red : AppColors.textInput,
                      ),
                      hintText: "Pet Name",
                      labelText: "Pet Name",
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        setState(() => _hasNameError = true);
                        return "Pet name is required";
                      }
                      setState(() => _hasNameError = false);
                      return null;
                    },
                  ),
                ),

                // 🔹 Especie
                _buildFormField(
                  child: _loadingTipos
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.0),
                        )
                      : DropdownButtonFormField<MaestroTipo>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.category,
                              color: _hasSpecieError
                                  ? Colors.red
                                  : AppColors.textInput,
                            ),
                            labelText: "Specie",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          items: _tipos
                              .map(
                                (tipo) => DropdownMenuItem<MaestroTipo>(
                                  value: tipo,
                                  child: Text(
                                    tipo.nombre,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTipo = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              setState(() => _hasSpecieError = true);
                              return "Pet specie is required";
                            }
                            setState(() => _hasSpecieError = false);
                            return null;
                          },
                        ),
                ),
                //Breed
                _buildFormField(
                  child: _loadingTipos
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.0),
                        )
                      : DropdownButtonFormField<MaestroTipo>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.pets,
                              color: _hasBreedError
                                  ? Colors.red
                                  : AppColors.textInput,
                            ),
                            labelText: "Breed",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          items: _breedOptions
                              .map(
                                (tipo) => DropdownMenuItem<MaestroTipo>(
                                  value: tipo,
                                  child: Text(
                                    tipo.nombre,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBreed = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              setState(() => _hasBreedError = true);
                              return "Pet specie is required";
                            }
                            setState(() => _hasBreedError = false);
                            return null;
                          },
                        ),
                ),

                // Especie (Dropdown dinámico)
                /* _buildFormField(
                child: _loadingTipos
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<MaestroTipo>(
                        value: _selectedTipo,
                        items: _tipos
                            .map(
                              (tipo) => DropdownMenuItem<MaestroTipo>(
                                value: tipo,
                                child: Text(
                                  tipo.nombre,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTipo = value;
                          });
                        },
                        // decoration: _inputDecoration(
                        //   label: "Especie",
                        //   icon: Icons.category,
                        // ),
                      ),
              ), */

                // 🔹 Género
                _buildFormField(
                  child: _loadingTipos
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.0),
                        )
                      : DropdownButtonFormField<MaestroTipo>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.transgender_outlined,
                              color: _hasBreedError
                                  ? Colors.red
                                  : AppColors.textInput,
                            ),
                            labelText: "Gender",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          items: _genderOptions
                              .map(
                                (tipo) => DropdownMenuItem<MaestroTipo>(
                                  value: tipo,
                                  child: Text(
                                    tipo.nombre,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              setState(() => _hasGenderError = true);
                              return "Pet gender is required";
                            }
                            setState(() => _hasGenderError = false);
                            return null;
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

                // 🔹 Peso
                _buildFormField(
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ), // Ensures the numeric keyboard with a decimal point is shown
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d*'),
                      ), // Allows digits and a single optional decimal point
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.line_weight,
                        color: _hasWeigthError
                            ? Colors.red
                            : AppColors.textInput,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      hintText: "Weight",
                      labelText: "Weight",
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        setState(() => _hasWeigthError = true);
                        return "Pet weight is required";
                      }
                      setState(() => _hasWeigthError = false);
                      return null;
                    },
                  ),
                ),

                // 🔹 Fecha de nacimiento
                _buildFormField(
                  child: TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: _hasBirthDateError
                            ? Colors.red
                            : AppColors.textInput,
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        setState(() => _hasBirthDateError = true);
                        return "Pet birthday is required";
                      }
                      setState(() => _hasBirthDateError = false);
                      return null;
                    },
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
                    onPressed: _isLoading
                        ? null
                        : _registerPet, // 👉 aquí invocas tu método
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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
      ),
    );
  }
}
