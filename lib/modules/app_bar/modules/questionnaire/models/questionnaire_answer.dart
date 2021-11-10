import 'package:intl/intl.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class QuestionnaireLocalAnswer {
  List<int> qr;
  String userImage;
  String name;
  Roles role;
  Residence residence;
  String department;
  Reasons reason;
  DateTime dateFilled;

  String get strRole => fromRoleTypeToString(this.role);

  String get strReason => fromReasonTypeToString(this.reason);

  String get strResidence => fromResidenceTypeToString(this.residence);

  String get strDateFilled => DateFormat('yyyy-MM-dd').format(this.dateFilled);

  bool get isFromToday {
    DateTime now = DateTime.now();
    return this.dateFilled.day == now.day &&
        this.dateFilled.month == now.month &&
        this.dateFilled.year == now.year;
  }

  QuestionnaireLocalAnswer({
    required this.qr,
    required this.userImage,
    required this.name,
    this.department: '',
    this.role: Roles.Unknown,
    this.residence: Residence.Unknown,
    this.reason: Reasons.None,
    DateTime? answerDate,
  }) : this.dateFilled = answerDate != null ? answerDate : DateTime.now();

  QuestionnaireLocalAnswer.forToday({
    required this.qr,
    required this.userImage,
    required this.name,
    required this.role,
    this.department: '',
    this.residence: Residence.Unknown,
    this.reason: Reasons.None,
  }) : this.dateFilled = DateTime.now();

  QuestionnaireLocalAnswer.empty()
      : this.qr = [],
        this.userImage = '',
        this.name = '',
        this.department = '',
        this.role = Roles.Unknown,
        this.residence = Residence.Unknown,
        this.reason = Reasons.None,
        this.dateFilled = DateTime(1997, 1, 15);

  QuestionnaireLocalAnswer.fromJson(Map<String, dynamic> json)
      : this.qr = json['qr'].cast<int>(),
        this.userImage = json['userImage'] ?? '',
        this.name = json['name'] ?? '',
        this.department = json['department'] ?? '',
        this.role = fromStringToRoleType(json['role'] ?? ''),
        this.residence = fromStringToResidenceType(json['residence'] ?? ''),
        this.reason = fromStringToReasonType(json['reason'] ?? ''),
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
