import 'package:flutter/material.dart';
import '../models/prediccionIA.dart';
import '../services/api_service.dart';

class PrediccionIaProvider {
  List<Prediccionia> _predicciones = [];
  bool _isLoading = false;

  List<Prediccionia> get predicciones => _predicciones;
  bool get isLoading => _isLoading;

  Future<void> getPrediccionesRecientes(int alumnoId) async {

  }

}