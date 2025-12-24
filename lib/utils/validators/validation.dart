class SValidator {
  static String? validateEmptyText(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validEmail(String? value) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  static String? validateTagline(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Tagline can be empty
    }

    if (value.length > 120) {
      return 'Tagline cannot exceed 120 characters';
    }

    if (value.split('\n').length > 4) {
      return 'Tagline cannot exceed 4 lines';
    }

    return null;
  }

  static String? validateSparkTextContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Text content is required';
    }
    return validateTagline(value);
  }

  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Image is required';
    }
    return null;
  }

  static String? validateSparkOption(String? value) {
    if (value == null || value.isEmpty) {
      return 'option is required';
    }
    if (value.length >= 30) {
      return 'this option is too long. ${value.length}/30';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required.';
    }
    final height = double.tryParse(value);
    if (height == null || height <= 0 || height > 300) {
      return 'Please enter a valid height in cm (e.g., 175).';
    }
    return null;
  }
}
