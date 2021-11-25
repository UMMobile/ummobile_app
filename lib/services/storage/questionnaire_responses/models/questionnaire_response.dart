import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

part 'questionnaire_response.g.dart';

@HiveType(typeId: 1)
class QuestionnaireResponse extends HiveObject {
  /// QR image
  @HiveField(0)
  List<int> qr;

  /// The user's image formatted in base64
  @HiveField(1)
  String userImage;

  /// The user's name
  @HiveField(2)
  String name;

  /// The user's role
  @HiveField(3)
  String strRole;

  /// The user's residence
  @HiveField(4)
  String strResidence;

  /// The user's department
  @HiveField(5)
  String department;

  /// The reason of the current result
  @HiveField(6)
  String strReason;

  /// The date when the questionnaire was answer
  @HiveField(7)
  DateTime dateFilled;

  Roles get role => fromStringToRoleType(strRole);

  Residence get residence => fromStringToResidenceType(strResidence);

  Reasons get reason => fromStringToReasonType(strReason);

  String get strDateFilled => DateFormat('yyyy-MM-dd').format(this.dateFilled);

  /// True if the answered date is equals to today
  bool get isFromToday {
    DateTime now = DateTime.now();
    return this.dateFilled.day == now.day &&
        this.dateFilled.month == now.month &&
        this.dateFilled.year == now.year;
  }

  QuestionnaireResponse({
    required this.qr,
    required this.userImage,
    required this.name,
    this.department: '',
    this.strRole: '',
    this.strResidence: '',
    this.strReason: '',
    DateTime? answerDate,
  }) : this.dateFilled = answerDate != null ? answerDate : DateTime.now();

  QuestionnaireResponse.forToday({
    required this.qr,
    required this.userImage,
    required this.name,
    required this.strRole,
    this.department: '',
    this.strResidence: '',
    this.strReason: '',
  }) : this.dateFilled = DateTime.now();

  QuestionnaireResponse.empty()
      : this.qr = [],
        this.userImage = '',
        this.name = '',
        this.department = '',
        this.strRole = '',
        this.strResidence = '',
        this.strReason = '',
        this.dateFilled = DateTime(1997, 1, 15);

  QuestionnaireResponse.fromJson(Map<String, dynamic> json)
      : this.qr = json['qr'].cast<int>(),
        this.userImage = json['userImage'] ?? '',
        this.name = json['name'] ?? '',
        this.department = json['department'] ?? '',
        this.strRole = json['role'] ?? '',
        this.strResidence = json['residence'] ?? '',
        this.strReason = json['reason'] ?? '',
        this.dateFilled = DateTime.parse(json['dateFilled'] ?? '1997-01-15');

  Map<String, dynamic> toJson() => {
        'qr': qr,
        'userImage': this.userImage,
        'name': this.name,
        'department': this.department,
        'role': this.strRole,
        'residence': this.strResidence,
        'reason': this.strReason,
        'dateFilled': this.strDateFilled,
      };
}

String fromReasonTypeToString(Reasons reason) {
  switch (reason) {
    case Reasons.HaveCovid:
      return 'haveCovid';
    case Reasons.RecentArrival:
      return 'recentArrival';
    case Reasons.IsInQuarantine:
      return 'isInQuarantine';
    case Reasons.IsSuspect:
      return 'isSuspect';
    case Reasons.NoResponsiveLetter:
      return 'noResponsiveLetter';
    case Reasons.None:
      return '';
  }
}

Reasons fromStringToReasonType(String strReason) {
  switch (strReason) {
    case 'haveCovid':
      return Reasons.HaveCovid;
    case 'recentArrival':
      return Reasons.RecentArrival;
    case 'isInQuarantine':
      return Reasons.IsInQuarantine;
    case 'isSuspect':
      return Reasons.IsSuspect;
    case 'noResponsiveLetter':
      return Reasons.NoResponsiveLetter;
    default:
      return Reasons.None;
  }
}

String fromResidenceTypeToString(Residence residence) {
  switch (residence) {
    case Residence.Internal:
      return 'internal';
    case Residence.External:
      return 'external';
    case Residence.Unknown:
      return '-';
  }
}

Residence fromStringToResidenceType(String strResidence) {
  switch (strResidence) {
    case 'internal':
      return Residence.Internal;
    case 'external':
      return Residence.External;
    default:
      return Residence.Unknown;
  }
}

String fromRoleTypeToString(Roles role) {
  switch (role) {
    case Roles.Student:
      return 'student';
    case Roles.Employee:
      return 'employee';
    case Roles.Unknown:
      return '';
  }
}

Roles fromStringToRoleType(String strRole) {
  switch (strRole) {
    case 'student':
      return Roles.Student;
    case 'employee':
      return Roles.Employee;
    default:
      return Roles.Unknown;
  }
}
