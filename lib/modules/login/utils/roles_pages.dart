import 'package:flutter/material.dart';
import 'package:ummobile/modules/tabs/models/page_tab_view.dart';
import 'package:ummobile/modules/tabs/modules/announcements/views/announcements_forms.dart';
import 'package:ummobile/modules/tabs/modules/calendar/views/calendar_page.dart';
import 'package:ummobile/modules/tabs/modules/conectate/views/conectate_page.dart';
import 'package:ummobile/modules/tabs/modules/intereses/views/intereses_page.dart';
// import 'package:ummobile/modules/tabs/modules/forms/views/page_forms.dart';
import 'package:ummobile/modules/tabs/modules/payments/views/page_payment.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/modules/tabs/modules/profile/views/profile_page.dart';
import 'package:ummobile/statics/settings/app_icons_icons.dart';

/// The list of student pages
List<PageTabView> student = <PageTabView>[
  PageTabView(
    page: ConectatePage(),
    icon: Icon(Icons.home_rounded, size: 30),
    label: "Home",
  ),
  PageTabView(
    page: CalendarPage(),
    icon: Icon(Icons.event, size: 30),
    label: "Agenda",
  ),
  PageTabView(
    page: PaymentPage(),
    icon: Icon(AppIcons.financial),
    label: "Financiero",
  ),
  PageTabView(
    page: ProfilePage(),
    icon: Icon(AppIcons.user),
    label: "Usuario",
  ),
];

/// The list of employees pages
List<PageTabView> employee = <PageTabView>[
  PageTabView(
    page: ConectatePage(),
    icon: Icon(Icons.home_rounded, size: 30),
    label: "Home",
  ),
  PageTabView(
    page: CalendarPage(),
    icon: Icon(Icons.event, size: 30),
    label: "Agenda",
  ),
  // PageTabView(
  //   page: FormsPage(),
  //   icon: Icon(Icons.business_center_rounded, size: 30),
  //   label: "Formularios",
  // ),
  PageTabView(
      page: AnnouncementsPage(),
      icon: Icon(Icons.article, size: 30),
      label: "Comunicados"),
  PageTabView(
    page: NoticesPage(),
    icon: Icon(Icons.announcement, size: 30),
    label: "De Interes",
  ),

  PageTabView(
    page: ProfilePage(),
    icon: Icon(AppIcons.user),
    label: "Usuario",
  ),
];

/// Get the list of authorized tabs for the current user
List<PageTabView> viewsForCurrentUser() {
  if (userIsStudent) {
    return student;
  } else if (userIsEmployee) {
    return employee;
  } else {
    return student;
  }
}
