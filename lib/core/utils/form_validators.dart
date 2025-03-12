import 'package:form_field_validator/form_field_validator.dart';

final validatedUserName = MultiValidator([
  RequiredValidator(errorText: 'Error text'),
  MinLengthValidator(3, errorText: 'Error msg')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Error text'),
  MinLengthValidator(6, errorText: 'Error msg'),
]);
