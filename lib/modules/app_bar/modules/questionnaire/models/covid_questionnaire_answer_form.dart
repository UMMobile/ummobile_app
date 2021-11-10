import 'package:ummobile_sdk/ummobile_sdk.dart';

CovidQuestionnaireAnswer blankAnswer = CovidQuestionnaireAnswer(
  countries: [],
  recentContact: RecentContact(yes: false),
  majorSymptoms: {},
  minorSymptoms: {},
);

enum ChooseOptions { yes, no }
