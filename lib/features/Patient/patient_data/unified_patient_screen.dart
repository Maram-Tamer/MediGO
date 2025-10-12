import 'dart:io';
import 'dart:typed_data' ;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medigo/core/utils/colors.dart';
import 'package:medigo/core/utils/fonts.dart';
import 'package:medigo/features/Patient/notification/notification_screen.dart';

enum PatientType {
  iAmPatient,
  anotherPatient,
}

class UnifiedPatientScreen extends StatefulWidget {
  const UnifiedPatientScreen({super.key});

  @override
  State<UnifiedPatientScreen> createState() => _UnifiedPatientScreenState();
}

class _UnifiedPatientScreenState extends State<UnifiedPatientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _caseDescriptionController = TextEditingController();
  
  // State variables
  PatientType _selectedPatientType = PatientType.iAmPatient;
  String selectedGender = "Male";
  String selectedBloodType = "";
  bool isLoading = false;
  File? selectedImage;
  Uint8List? selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  final List<String> bloodTypes = [
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"
  ];

  @override
  void dispose() {
    _nationalIdController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _caseDescriptionController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'National ID is required';
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length != 14) {
      return 'National ID must be exactly 14 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'National ID must contain only numbers';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final trimmedValue = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'Phone number must contain only numbers';
    }
    if (trimmedValue.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final trimmedValue = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'Please enter a valid age';
    }
    final age = int.tryParse(trimmedValue);
    if (age == null) {
      return 'Please enter a valid age';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        if (!mounted) return;
        setState(() {
          if (kIsWeb) {
            selectedImageBytes = bytes;
          } else {
            selectedImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        if (!mounted) return;
        setState(() {
          if (kIsWeb) {
            selectedImageBytes = bytes;
          } else {
            selectedImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedBloodType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedPatientType == PatientType.iAmPatient 
              ? 'Please select your blood type' 
              : 'Please select blood type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_selectedPatientType == PatientType.iAmPatient 
            ? 'Your application has been submitted successfully!' 
            : 'Patient data has been submitted successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillTextForm,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.darkColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
        title: Text(
          "Patient Data",
          style: AppFontStyles.getSize18(
            fontSize: 18,
            fontColor: AppColors.darkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.fillTextForm,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PatientType>(
                value: _selectedPatientType,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.greyColor,
                ),
                style: AppFontStyles.getSize16(
                  fontSize: 16,
                  fontColor: AppColors.darkColor,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  DropdownMenuItem(
                    value: PatientType.iAmPatient,
                    child: Text("I am the patient"),
                  ),
                  DropdownMenuItem(
                    value: PatientType.anotherPatient,
                    child: Text("Another patient"),
                  ),
                ],
                onChanged: (PatientType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPatientType = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show additional fields only for "Another patient"
                if (_selectedPatientType == PatientType.anotherPatient) ...[
                  // National ID
                  _buildTextField(
                    label: "National ID",
                    controller: _nationalIdController,
                    hintText: "Enter 14-digit National ID",
                    keyboardType: TextInputType.number,
                    validator: _validateNationalId,
                  ),
                  const SizedBox(height: 16),

                  // Name
                  _buildTextField(
                    label: "Name",
                    controller: _nameController,
                    hintText: "Enter full name",
                    validator: (value) => _validateRequired(value, "Name"),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  _buildTextField(
                    label: "Phone",
                    controller: _phoneController,
                    hintText: "Enter phone number",
                    keyboardType: TextInputType.number,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 16),

                  // Gender Selection
                  Text(
                    "Gender",
                    style: AppFontStyles.getSize16(
                      fontSize: 16,
                      fontColor: AppColors.darkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Male"),
                          value: "Male",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: AppColors.primaryGreenColor,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Female"),
                          value: "Female",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: AppColors.primaryGreenColor,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),

                  // Age
                  _buildTextField(
                    label: "Age",
                    controller: _ageController,
                    hintText: "Enter age",
                    keyboardType: TextInputType.number,
                    validator: _validateAge,
                  ),
                  const SizedBox(height: 16),
                ],

                // Address (always shown)
                _buildTextField(
                  label: "Address",
                  controller: _addressController,
                  hintText: "Enter detailed address",
                  validator: (value) => _validateRequired(value, "Address"),
                ),
                const SizedBox(height: 16),

                // Blood Type (always shown)
                _buildBloodTypeField(),

                // Case Description (always shown)
                _buildTextField(
                  label: "Case Description",
                  controller: _caseDescriptionController,
                  hintText: "Write a detailed description of the case",
                  maxLines: 4,
                  validator: (value) => _validateRequired(value, "Case Description"),
                ),
                const SizedBox(height: 16),

                // Upload Image (always shown)
                _buildImageUpload(),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Submit",
                            style: AppFontStyles.getSize16(
                              fontSize: 16,
                              fontColor: Colors.white,
                              fontWeight: FontWeight.w600,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyles.getSize16(
            fontSize: 16,
            fontColor: AppColors.darkColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppFontStyles.getSize14(
              fontSize: 14,
              fontColor: AppColors.greyColor,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.fillTextForm),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.fillTextForm),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGreenColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: AppColors.fillTextForm,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Blood Type",
          style: AppFontStyles.getSize16(
            fontSize: 16,
            fontColor: AppColors.darkColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedBloodType.isEmpty ? null : selectedBloodType,
          decoration: InputDecoration(
            hintText: "Select blood type",
            hintStyle: AppFontStyles.getSize14(
              fontSize: 14,
              fontColor: AppColors.greyColor,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.fillTextForm),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.fillTextForm),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGreenColor),
            ),
            filled: true,
            fillColor: AppColors.fillTextForm,
          ),
          items: bloodTypes.map((String bloodType) {
            return DropdownMenuItem<String>(
              value: bloodType,
              child: Text(bloodType),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedBloodType = newValue ?? '';
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Image",
          style: AppFontStyles.getSize16(
            fontSize: 16,
            fontColor: AppColors.darkColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showImageSourceDialog();
          },
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.fillTextForm,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
            child: (selectedImage != null || selectedImageBytes != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.memory(
                            selectedImageBytes!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 32,
                        color: AppColors.greyColor.withOpacity(0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to upload image",
                        style: AppFontStyles.getSize14(
                          fontSize: 14,
                          fontColor: AppColors.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "PNG, JPG, GIF up to 10MB",
                        style: AppFontStyles.getSize14(
                          fontSize: 12,
                          fontColor: AppColors.greyColor.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (selectedImage != null || selectedImageBytes != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showImageSourceDialog();
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Change Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreenColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedImage = null;
                    selectedImageBytes = null;
                  });
                },
                icon: const Icon(Icons.delete, size: 16),
                label: const Text("Remove"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
