import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/repositories/weight_repository.dart';

class WeightBloc extends Cubit<List<WeightEntry>> {
  final WeightRepository _repository;

  WeightBloc(this._repository) : super([]) {
    loadWeights();
  }

  void loadWeights() async {
    try {
      final weights = await _repository.getWeights();
      emit(weights);
    } catch (e) {
      // Handle error (e.g., emit error state or log)
      print('Error loading weights: $e');
    }
  }

  void addWeight(WeightEntry entry) async {
    try {
      await _repository.addWeight(entry);
      loadWeights();
    } catch (e) {
      // Handle error
      print('Error adding weight: $e');
    }
  }

  void deleteWeight(WeightEntry entry) async {
    try {
      await _repository.deleteWeight(entry);
      loadWeights();
    } catch (e) {
      // Handle error
      print('Error deleting weight: $e');
    }
  }
}
