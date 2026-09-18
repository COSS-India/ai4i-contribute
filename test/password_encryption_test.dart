import 'package:flutter_test/flutter_test.dart';
import 'package:ai4i_contribute/services/password_encryption_service.dart';

void main() {
  group('PasswordEncryptionService Tests', () {
    test('should encrypt and decrypt password correctly', () {
      const testPassword = 'testPassword123';

      // Encrypt the password
      final encryptedPassword =
          PasswordEncryptionService.encryptPassword(testPassword);

      // Verify encryption format
      expect(encryptedPassword, isNotEmpty);
      expect(encryptedPassword.contains(':'), isTrue);

      // Decrypt the password
      final decryptedPassword =
          PasswordEncryptionService.decryptPassword(encryptedPassword);

      // Verify decryption
      expect(decryptedPassword, equals(testPassword));
    });

    test('should handle empty password', () {
      const emptyPassword = '';

      final encryptedPassword =
          PasswordEncryptionService.encryptPassword(emptyPassword);
      final decryptedPassword =
          PasswordEncryptionService.decryptPassword(encryptedPassword);

      expect(decryptedPassword, equals(emptyPassword));
    });

    test('should handle special characters in password', () {
      const specialPassword = 'P@ssw0rd!@#\$%^&*()';

      final encryptedPassword =
          PasswordEncryptionService.encryptPassword(specialPassword);
      final decryptedPassword =
          PasswordEncryptionService.decryptPassword(encryptedPassword);

      expect(decryptedPassword, equals(specialPassword));
    });

    test('should handle unicode characters in password', () {
      const unicodePassword = 'पासवर्ड123';

      final encryptedPassword =
          PasswordEncryptionService.encryptPassword(unicodePassword);
      final decryptedPassword =
          PasswordEncryptionService.decryptPassword(encryptedPassword);

      expect(decryptedPassword, equals(unicodePassword));
    });

    test('should validate encrypted format correctly', () {
      const testPassword = 'testPassword123';

      final encryptedPassword =
          PasswordEncryptionService.encryptPassword(testPassword);

      expect(
          PasswordEncryptionService.isValidEncryptedFormat(encryptedPassword),
          isTrue);
      expect(PasswordEncryptionService.isValidEncryptedFormat('invalid:format'),
          isFalse);
      expect(PasswordEncryptionService.isValidEncryptedFormat(''), isFalse);
    });

    test('should throw exception for invalid decryption', () {
      expect(
        () => PasswordEncryptionService.decryptPassword('invalid:format'),
        throwsA(isA<PasswordEncryptionException>()),
      );
    });

    test('should produce consistent encryption results', () {
      const testPassword = 'consistentPassword123';

      final encrypted1 =
          PasswordEncryptionService.encryptPassword(testPassword);
      final encrypted2 =
          PasswordEncryptionService.encryptPassword(testPassword);

      // Both should decrypt to the same password
      final decrypted1 = PasswordEncryptionService.decryptPassword(encrypted1);
      final decrypted2 = PasswordEncryptionService.decryptPassword(encrypted2);

      expect(decrypted1, equals(testPassword));
      expect(decrypted2, equals(testPassword));
    });
  });
}
