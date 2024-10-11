import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class AddWeightScreen extends StatefulWidget {
  @override
  _AddWeightScreenState createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Weight Entry'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.fitness_center),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final entry = WeightEntry(date: _selectedDate, weight: weight);
      context.read<WeightBloc>().addWeight(entry);
      Navigator.pop(context);
    }
  }
}