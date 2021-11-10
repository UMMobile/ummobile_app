import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/calendar/controllers/calendar_controller.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'subpages/appointment_page.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<UmCalendarController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: UmAppBar(
        title: 'calendar'.tr.capitalizeFirst!,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get.find<NavigationController>()
                  .drawerKey
                  .currentState!
                  .openDrawer();
            }),
      ),
      body: controller.obx(
        (calendar) => SfCalendar(
          initialSelectedDate: DateTime.now(),
          initialDisplayDate: DateTime.now(),
          view: CalendarView.month,
          showDatePickerButton: true,
          dataSource:
              _MeetingDataSource(controller.getAppointments(calendar!.events)),
          allowedViews: <CalendarView>[
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
            CalendarView.schedule
          ],
          monthViewSettings: MonthViewSettings(showAgenda: true),
          onTap: _calendarTapped,
        ),
        onLoading: _ShimmerCalendar(),
        onError: (e) => controller.internetPage(e),
      ),
    );
  }

  /// * Mehod used to go to a subpage when an event is clicked
  void _calendarTapped(CalendarTapDetails details) {
    if ((details.targetElement == CalendarElement.appointment ||
            details.targetElement == CalendarElement.agenda) &&
        details.appointments!.isNotEmpty) {
      final Appointment appointmentDetails = details.appointments![0];

      Get.find<NavigationController>().goToSubTabView(
          AppointmentDetailsPage(
            headerColor: appointmentDetails.color,
            subject: appointmentDetails.subject,
            dateText: DateFormat('MMMM dd, yyyy')
                .format(appointmentDetails.startTime)
                .toString(),
            timeDetails: (appointmentDetails.isAllDay)
                ? 'Todo el día'
                : DateFormat('hh:mm a')
                        .format(appointmentDetails.startTime)
                        .toString() +
                    ' - ' +
                    DateFormat('hh:mm a')
                        .format(appointmentDetails.endTime)
                        .toString(),
            description: appointmentDetails.notes,
          ),
          context);
    }
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

class _ShimmerCalendar extends StatelessWidget {
  const _ShimmerCalendar({Key? key}) : super(key: key);

  List<Widget> _shimmerDays() {
    List<Widget> list = List.empty(growable: true);

    for (int i = 0; i < 24; i++) {
      list.add(RectShimmer(
        height: 40,
        width: 40,
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Flexible(
          flex: 5,
          child: Column(
            children: [
              Row(
                children: [
                  RectShimmer(height: 24, width: 150, left: 10),
                  Expanded(child: SizedBox()),
                  RectShimmer(height: 24, width: 24, right: 10),
                  RectShimmer(height: 24, width: 24, right: 10),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: _shimmerDays(),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      RectShimmer(height: 12, width: 48),
                      SizedBox(height: 5),
                      RoundShimmer(size: 48),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      RectShimmer(
                        height: 68,
                        width: 300,
                        radius: 10,
                      ),
                      SizedBox(height: 10),
                      RectShimmer(
                        height: 68,
                        width: 300,
                        radius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
