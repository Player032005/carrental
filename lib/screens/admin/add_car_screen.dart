import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_textstyles.dart';
import '../../models/car_model.dart';
import '../../providers/car_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Screen for adding new cars (Admin)
class AddCarScreen extends StatefulWidget {
  final CarModel? carToEdit;

  const AddCarScreen({
    this.carToEdit,
    Key? key,
  }) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _seatsController;
  late TextEditingController _descriptionController;

  String _selectedCategory = 'Sedan';
  String _selectedTransmission = 'Automatic';
  String _selectedFuelType = 'Petrol';
  bool _hasAC = true;

  final _categories = ['Sedan', 'SUV', 'Luxury', 'Economic', 'Family'];
  final _transmissions = ['Manual', 'Automatic'];
  final _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.carToEdit?.name ?? '',
    );
    _modelController = TextEditingController(
      text: widget.carToEdit?.model ?? '',
    );
    _yearController = TextEditingController(
      text: widget.carToEdit?.year.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.carToEdit?.pricePerDay.toString() ?? '',
    );
    _seatsController = TextEditingController(
      text: widget.carToEdit?.seats.toString() ?? '5',
    );
    _descriptionController = TextEditingController(
      text: widget.carToEdit?.description ?? '',
    );

    if (widget.carToEdit != null) {
      _selectedCategory = widget.carToEdit!.category;
      _selectedTransmission = widget.carToEdit!.transmission;
      _selectedFuelType = widget.carToEdit!.fuelType;
      _hasAC = widget.carToEdit!.airConditioning;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final carProvider = Provider.of<CarProvider>(context, listen: false);

    final car = CarModel(
      id: widget.carToEdit?.id ?? '',
      name: _nameController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text),
      category: _selectedCategory,
      pricePerDay: double.parse(_priceController.text),
      rating: widget.carToEdit?.rating ?? 0.0,
      reviewCount: widget.carToEdit?.reviewCount ?? 0,
      seats: int.parse(_seatsController.text),
      transmission: _selectedTransmission,
      fuelType: _selectedFuelType,
      airConditioning: _hasAC,
      description: _descriptionController.text.trim(),
      imageUrls: widget.carToEdit?.imageUrls ?? [],
      isAvailable: widget.carToEdit?.isAvailable ?? true,
      createdAt: widget.carToEdit?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.carToEdit != null) {
      success = await carProvider.updateCar(car);
    } else {
      success = await carProvider.addCar(car);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.carToEdit != null
                ? AppStrings.carUpdated
                : AppStrings.carAdded,
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(carProvider.error ?? AppStrings.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          widget.carToEdit != null ? 'Edit Car' : AppStrings.addNewCar,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: Consumer<CarProvider>(
        builder: (context, carProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car name
                  CustomTextField(
                    label: AppStrings.carName,
                    hint: AppStrings.enterCarName,
                    controller: _nameController,
                    prefixIcon: Icons.directions_car,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Car model
                  CustomTextField(
                    label: AppStrings.carModel,
                    hint: AppStrings.enterCarModel,
                    controller: _modelController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Year
                  CustomTextField(
                    label: AppStrings.carYear,
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      if (int.tryParse(value!) == null) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category
                  _buildDropdownField(
                    label: AppStrings.carCategory,
                    value: _selectedCategory,
                    items: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price per day
                  CustomTextField(
                    label: AppStrings.dailyRate,
                    hint: AppStrings.enterDailyRate,
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icons.attach_money,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      if (double.tryParse(value!) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Seats
                  CustomTextField(
                    label: AppStrings.seats,
                    controller: _seatsController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      if (int.tryParse(value!) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Transmission
                  _buildDropdownField(
                    label: 'Transmission',
                    value: _selectedTransmission,
                    items: _transmissions,
                    onChanged: (value) {
                      setState(() {
                        _selectedTransmission = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Fuel type
                  _buildDropdownField(
                    label: 'Fuel Type',
                    value: _selectedFuelType,
                    items: _fuelTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedFuelType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Air conditioning checkbox
                  CheckboxListTile(
                    title: const Text('Air Conditioning'),
                    value: _hasAC,
                    onChanged: (value) {
                      setState(() {
                        _hasAC = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  CustomTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    maxLines: 4,
                    minLines: 3,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  CustomButton(
                    text: widget.carToEdit != null ? 'Update Car' : 'Add Car',
                    onPressed: _handleSubmit,
                    isLoading: carProvider.isLoading,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build dropdown field
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
