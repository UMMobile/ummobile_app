import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class UmCalendarController extends ControllerTemplate
    with StateMixin<Calendar> {
  Future<UMMobileCatalogue> get calendarApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileCatalogue(token: accessToken);
  }

  @override
  void onInit() {
    fetchCalendar();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchCalendar();
    super.refreshContent();
  }

  /// * Mehod in charge of loading the necessary data of the page
  void fetchCalendar() async {
    call<Calendar>(
      httpCall: () async => await (await calendarApi).getCalendar(),
      onSuccess: (data) => change(data, status: RxStatus.success()),
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  /// * Mehod that returns the list of events inside a calendar and format each
  /// * event for the calendar package to read it correctly
  List<Appointment> getAppointments(List<Event> calendarItems) {
    List<Appointment> meetings = List.empty(growable: true);

    calendarItems.forEach(
      (element) => meetings.add(
        Appointment(
          isAllDay: element.start!.date != null ? true : false,
          startTime: element.start!.date != null
              ? element.start!.date!
              : element.start!.dateTime!,
          endTime: element.end!.date != null
              ? DateTime(element.end!.date!.year, element.end!.date!.month,
                  element.end!.date!.day - 1)
              : element.end!.dateTime!,
          subject: element.summary!,
          notes: element.description,
          color: Get.theme.colorScheme.secondary,
        ),
      ),
    );

    return meetings;
  }
}
