import 'package:flutter_test/flutter_test.dart';
import 'package:phishpop/helpers/validators.dart';
import '../../fixtures/test_data.dart';

void main() {
  group('Email Validator', () {
    test('should return null for valid emails', () {
      for (final email in validEmails) {
        expect(Validators.validateEmail(email), isNull,
            reason: 'Failed for: $email');
      }
    });

    test('should return error for invalid emails', () {
      for (final email in invalidEmails) {
        expect(Validators.validateEmail(email), isNotNull,
            reason: 'Failed for: $email');
      }
    });

    test('should return error for null or empty email', () {
      expect(Validators.validateEmail(null), equals('Email is required'));
      expect(Validators.validateEmail(''), equals('Email is required'));
    });

    test('should return specific error message for invalid format', () {
      expect(Validators.validateEmail('invalid.email'),
          equals('Please enter a valid email'));
    });
  });

  group('Password Validator', () {
    test('should return null for valid passwords', () {
      for (final password in validPasswords) {
        expect(Validators.validatePassword(password), isNull,
            reason: 'Failed for: $password');
      }
    });

    test('should return error for invalid passwords', () {
      for (final password in invalidPasswords) {
        expect(Validators.validatePassword(password), isNotNull,
            reason: 'Failed for: $password');
      }
    });

    test('should return error for null or empty password', () {
      expect(Validators.validatePassword(null), equals('Password is required'));
      expect(Validators.validatePassword(''), equals('Password is required'));
    });

    test('should return error for password shorter than 8 characters', () {
      expect(Validators.validatePassword('Short1'),
          equals('Password must be at least 8 characters'));
    });

    test('should return error for password without uppercase', () {
      expect(Validators.validatePassword('lowercase123'),
          equals('Must include uppercase, lowercase and numbers'));
    });

    test('should return error for password without lowercase', () {
      expect(Validators.validatePassword('UPPERCASE123'),
          equals('Must include uppercase, lowercase and numbers'));
    });

    test('should return error for password without numbers', () {
      expect(Validators.validatePassword('NoNumbers'),
          equals('Must include uppercase, lowercase and numbers'));
    });
  });

  group('Password Simple Validator', () {
    test('should return null for passwords with 6+ characters', () {
      expect(Validators.validatePasswordSimple('simple'), isNull);
      expect(Validators.validatePasswordSimple('123456'), isNull);
      expect(Validators.validatePasswordSimple('pass123'), isNull);
    });

    test('should return error for passwords shorter than 6 characters', () {
      expect(Validators.validatePasswordSimple('short'),
          equals('Password must be at least 6 characters'));
    });

    test('should return error for null or empty', () {
      expect(
          Validators.validatePasswordSimple(null), equals('Password is required'));
      expect(Validators.validatePasswordSimple(''), equals('Password is required'));
    });
  });

  group('Name Validator', () {
    test('should return null for valid names', () {
      expect(Validators.validateName('John Doe'), isNull);
      expect(Validators.validateName('María García'), isNull);
      expect(Validators.validateName('Jean François'), isNull);
      expect(Validators.validateName('Al'), isNull);
    });

    test('should return error for null or empty name', () {
      expect(Validators.validateName(null), equals('Name is required'));
      expect(Validators.validateName(''), equals('Name is required'));
    });

    test('should return error for name shorter than 2 characters', () {
      expect(Validators.validateName('A'),
          equals('Name must be at least 2 characters'));
    });

    test('should return error for name longer than 50 characters', () {
      final longName = 'A' * 51;
      expect(Validators.validateName(longName),
          equals('Name cannot exceed 50 characters'));
    });

    test('should return error for name with numbers or special characters', () {
      expect(Validators.validateName('John123'),
          equals('Name can only contain letters and spaces'));
      expect(Validators.validateName('John@Doe'),
          equals('Name can only contain letters and spaces'));
    });
  });

  group('Phone Number Validator', () {
    test('should return null for valid phone numbers', () {
      for (final phone in validPhoneNumbers) {
        expect(Validators.validatePhone(phone), isNull,
            reason: 'Failed for: $phone');
      }
    });

    test('should return error for invalid phone numbers', () {
      for (final phone in invalidPhoneNumbers) {
        expect(Validators.validatePhone(phone), isNotNull,
            reason: 'Failed for: $phone');
      }
    });

    test('should return error for null or empty phone', () {
      expect(
          Validators.validatePhone(null), equals('Phone number is required'));
      expect(Validators.validatePhone(''), equals('Phone number is required'));
    });

    test('should handle phone numbers with spaces', () {
      expect(Validators.validatePhone('+1 234 567 890'), isNull);
    });
  });

  group('Password Confirmation Validator', () {
    test('should return null when passwords match', () {
      expect(Validators.validatePasswordConfirmation('Password123', 'Password123'),
          isNull);
    });

    test('should return error when passwords do not match', () {
      expect(Validators.validatePasswordConfirmation('Password123', 'Different'),
          equals('Passwords do not match'));
    });

    test('should return error for null or empty confirmation', () {
      expect(Validators.validatePasswordConfirmation(null, 'Password123'),
          equals('Please confirm your password'));
      expect(Validators.validatePasswordConfirmation('', 'Password123'),
          equals('Please confirm your password'));
    });
  });

  group('Description Validator', () {
    test('should return null for valid descriptions', () {
      expect(Validators.validateDescription('This is a valid description'), isNull);
      expect(
          Validators.validateDescription('A' * 100), isNull);
    });

    test('should return error for null or empty description', () {
      expect(Validators.validateDescription(null),
          equals('Please describe the scam incident'));
      expect(Validators.validateDescription(''),
          equals('Please describe the scam incident'));
      expect(Validators.validateDescription('   '),
          equals('Please describe the scam incident'));
    });

    test('should return error for description shorter than 10 characters', () {
      expect(Validators.validateDescription('Short'),
          equals('Description must be at least 10 characters'));
    });

    test('should return error for description longer than 1000 characters', () {
      final longDescription = 'A' * 1001;
      expect(Validators.validateDescription(longDescription),
          equals('Description cannot exceed 1000 characters'));
    });
  });

  group('Required Field Validator', () {
    test('should return null for non-empty values', () {
      expect(Validators.validateRequired('value', 'Field'), isNull);
    });

    test('should return error for null or empty with custom field name', () {
      expect(Validators.validateRequired(null, 'Username'),
          equals('Username is required'));
      expect(Validators.validateRequired('', 'Email'),
          equals('Email is required'));
    });
  });

  group('Scam Type Validator', () {
    test('should return null for non-empty scam type', () {
      expect(Validators.validateScamType('Phishing'), isNull);
    });

    test('should return error for null or empty scam type', () {
      expect(Validators.validateScamType(null),
          equals('Please select a scam type'));
      expect(Validators.validateScamType(''),
          equals('Please select a scam type'));
    });
  });
}
