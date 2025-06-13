import 'package:flutter/material.dart';

class AppConstants {
  // Colores principales
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryLightColor = Color(0xFFE3F2FD);
  static const Color primaryDarkColor = Color(0xFF1976D2);
  
  // Colores de estado
  static const Color successColor = Color(0xFF4CAF50);
  static const Color successLightColor = Color(0xFFE8F5E8);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color warningLightColor = Color(0xFFFFF3E0);
  static const Color errorColor = Color(0xFFF44336);
  static const Color errorLightColor = Color(0xFFFFEBEE);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Colores de fondo
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // Espaciado
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;
  
  // Tamaños de fuente
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 32.0;
  
  // Elevación
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // Duraciones de animación
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  
  // Sombras predefinidas
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 3,
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
  
  // Estilos de texto predefinidos
  static const TextStyle titleStyle = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeLarge,
    color: textPrimary,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeSmall,
    color: textSecondary,
    fontWeight: FontWeight.w500,
  );
  
  // Decoraciones de contenedores
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    boxShadow: lightShadow,
  );
  
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    boxShadow: mediumShadow,
  );
  
  // Decoraciones para badges/chips
  static BoxDecoration statusActiveDecoration = BoxDecoration(
    color: successLightColor,
    borderRadius: BorderRadius.circular(borderRadiusXLarge),
    border: Border.all(color: successColor.withOpacity(0.3)),
  );
  
  static BoxDecoration statusInactiveDecoration = BoxDecoration(
    color: warningLightColor,
    borderRadius: BorderRadius.circular(borderRadiusXLarge),
    border: Border.all(color: warningColor.withOpacity(0.3)),
  );
  
  static BoxDecoration riskDecoration = BoxDecoration(
    color: errorLightColor,
    borderRadius: BorderRadius.circular(borderRadiusXLarge),
    border: Border.all(color: errorColor.withOpacity(0.3)),
  );
  
  static BoxDecoration codeDecoration = BoxDecoration(
    color: primaryLightColor,
    borderRadius: BorderRadius.circular(borderRadiusXLarge),
    border: Border.all(color: primaryColor.withOpacity(0.3)),
  );
}

// Extensiones para facilitar el uso
extension BuildContextExtensions on BuildContext {
  // Shortcuts para obtener el theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Shortcuts para MediaQuery
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
}