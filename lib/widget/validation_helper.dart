/* 
class Validations {
  String validateEmail(String value) {
    if (value.isEmpty) return 'Please Enter Email Address';
    final RegExp nameExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',);

    if (!nameExp.hasMatch(value)) return 'Please Enter Valid Email Address';
    return '';
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    final RegExp nameExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$');
    if (!nameExp.hasMatch(value)) return 'Invalid password';
    return '';
  }

  String validateEmpty(String? value) {
    if (value!.isEmpty || value == null) return 'Please enter a value.';
    return '';
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  String validateFName(String value) {
    if (value.isEmpty) {
      return 'Please enter first name';
    } else {
      final RegExp nameExp = RegExp(r'^[a-z A-Z,.\-]+$');
      if (!nameExp.hasMatch(value)) {
        return 'Please enter only alphabetical characters.';
      } else {
        return '';
      }
    }
  }

  String validateLName(String value) {
    if (value.isEmpty) {
      return 'Please enter last name';
    } else {
      final RegExp nameExp = RegExp(r'^[a-z A-Z,.\-]+$');
      if (!nameExp.hasMatch(value)) {
        return 'Please enter only alphabetical characters.';
      } else {
        return '';
      }
    }
  }
}

extension ListExtension on List {
  String arrayToString() {
    return toString().replaceAll('[', '').replaceAll(']', '');
  }
}
 */

class TextFieldValidation {
  TextFieldValidation._();

  static String? validation({
    String? value,
    String? message,
    bool isEmailValidator = false,
    bool isPasswordValidator = false,
    bool isConfPassValidator = false,
    bool isPhoneNumberValidator = false,
    bool isPinCodeValidator = false,
    bool isCardValidator = false,
    bool isCVCValidator = false,
    // bool isExpiryYearValidator = false,
    // bool isExpiryMonthValidator = false,
    bool isExpiryDateValidator = false,
  }) {
    if (value!.isEmpty) {
      return "$message is required!";
    }
    if (isPhoneNumberValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 10 || value.length > 10) {
        return 'Phone number must be 10 character!';
      }
    }

    if (isPinCodeValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 6 || value.length > 6) {
        return 'Pincode number must be 6 character!';
      }
    }
    if (isCardValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 16) {
        return 'Card number must be 16 digit!';
      }
    }
    if (isCVCValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 3) {
        return 'Enter valid CVC!';
      }
    }
    if (isConfPassValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      }
    }
    if (isExpiryDateValidator == true) {
      final DateTime now = DateTime.now();
      final List<String> date = value.split(RegExp(r'/'));
      final int month = int.parse(date.first);
      final int year = int.parse('20${date.last}');
      final int lastDayOfMonth = month < 12 ? DateTime(year, month + 1, 0).day : DateTime(year + 1, 1, 0).day;
      final DateTime cardDate = DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);
      if (value.isEmpty) {
        return "$message is required!";
      } else if (cardDate.isBefore(now) || month > 12 || month == 0) {
        return 'Enter valid Expiry Date';
      }
      return null;
    }
    // if (isExpiryMonthValidator == true) {
    //   if (value.isEmpty) {
    //     return "$message is required!";
    //   }
    // }

    if (isEmailValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return 'Enter Valid $message';
      }
    } else if (isPasswordValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(value)) {
        if (value.length < 6) {
          return 'Password must have at least 6 characters!';
        } else if (!value.contains(RegExp(r'[A-Za-z]'))) {
          return 'Password must have at least one alphabet characters!';
        } else if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Password must have at least one number characters!';
        }
      }
    }

    return null;
  }
}
