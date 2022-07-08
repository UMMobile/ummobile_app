import 'dart:collection';

import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/utils/animated_list_actions.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class NotificationsController extends ControllerTemplate
    with StateMixin<List<Notification>> {
  /// The notifications api service
  Future<UMMobileNotifications> get notificationsApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileNotifications(token: accessToken);
  }

  /// The list of notifications
  var _notifications = <Notification>[].obs;

  /// The animaed list class actions
  final animatedList = NotificationAnimatedList();

  /// Returns the user's notification list
  UnmodifiableListView<Notification> get items {
    List<Notification> sortedNotifications = _notifications.toList();
    sortedNotifications.sort((a, b) => b.createAt.compareTo(a.createAt));
    return UnmodifiableListView(sortedNotifications);
  }

  /// Returns the user's notifications list sorted by isRead
  ///
  /// First goes the unreaded notifications
  List<Notification> get itemsSorted {
    List<Notification> unreadedNotifications = [];
    List<Notification> readedNotifications = [];

    items.forEach((notification) {
      if (!notification.isSeen)
        unreadedNotifications.add(notification);
      else
        readedNotifications.add(notification);
    });

    unreadedNotifications.addAll(readedNotifications);

    return unreadedNotifications;
  }

  @override
  onInit() {
    fetchNotifications();
    super.onInit();
  }

  @override
  void refreshContent() {
    this.refreshNotifications();
    super.refreshContent();
  }

  /// Retrieves the user notifications from the api
  void fetchNotifications() async {
    call<List<Notification>>(
      httpCall: () async => await (await notificationsApi).getAll(),
      onSuccess: (data) {
        if (data.isNotEmpty) {
          _notifications.addAll(data);
          change(data, status: RxStatus.success());
        } else
          change(null, status: RxStatus.empty());
      },
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  Notification read(String id) =>
      _notifications.firstWhere((notification) => notification.id == id);

  void add(String notificationId) async {
    String accessToken = await Get.find<LoginController>().token;
    // Empty access token means that user is not authorized so refresh notifications.
    // This because this function also can be executed on background and if the user has
    // not entered to the app in a while then the access token can be expired and refresh
    // the user notifications can throw an exception.
    if (accessToken.isNotEmpty) {
      await refreshNotifications();
    }

    // Mark the notification as received do not required an unnexpired access token because
    // is a public endpoint.
    // ignore: todo
    // TODO: (@jonathangomez): [Note] Do not uncomment this code until native code to manage received notifications is written.
    // This to avoid to have trash information stored and have a before and after fix clearly marked.
    // await call(
    //   httpCall: () async =>
    //       await (await notificationsApi).markAsReceived(notificationId),
    //   onSuccess: (data) {},
    //   onCallError: (status) {},
    //   onError: (e) {},
    // );
  }

  /// Removes a notification from the list based by the notification [id]
  Future<void> remove(String id) async {
    int index =
        _notifications.indexWhere((notification) => notification.id == id);

    animatedList.removeItem(index: index);

    _notifications.removeAt(index);

    /// Update user notification on API
    await call(
      httpCall: () async => await (await notificationsApi).delete(id),
      onSuccess: (data) {},
      onCallError: (status) {},
      onError: (e) {},
    );
  }

  /// Removes all the read notification from the list
  void removeAll() async {
    for (int i = itemsSorted.length - 1; i >= 0; i--) {
      if (itemsSorted[i].isSeen) {
        await remove(itemsSorted[i].id);
        await Future.delayed(Duration(milliseconds: 90));
      } else {
        // The read notifications are at the bottom
        break;
      }
    }
  }

  /// Marks a notification as read where notification.id == [id]
  void markAsRead(String id) {
    final int index =
        _notifications.indexWhere((notification) => notification.id == id);
    final Notification notification = _notifications[index];
    notification.seen = DateTime.now();

    /// Update state
    _notifications[index] = notification;

    /// Update user notification on API
    call(
      httpCall: () async => await (await notificationsApi).markAsSeen(id),
      onSuccess: (data) {},
      onCallError: (status) {},
      onError: (e) {},
    );
  }

  /// Clears all the notifications from the list
  ///
  /// This method does not sync with the api
  void reset() {
    _notifications.clear();
  }

  /// Clears all the notifications from the list and makes another
  /// api call to retrieve possible changes
  Future<void> refreshNotifications() async {
    await call<List<Notification>>(
      httpCall: () async => await (await notificationsApi).getAll(),
      onSuccess: (newNotifications) {
        if (newNotifications.isNotEmpty) {
          _notifications.asMap().forEach((key, value) {
            // Need to be removed in reverse
            animatedList.removeItem(
                index: _notifications.length - (key + 1),
                notificationRemoved: value);
          });
          _notifications.clear();

          _notifications.addAll(newNotifications);
          _notifications.asMap().forEach((key, value) {
            animatedList.addItem(key);
          });
        }
      },
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }
}
