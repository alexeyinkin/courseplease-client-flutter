import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AppNavigator {
  final BuildContext context;

  AppNavigator(
    this.context,
  );

  void toLastPurchasedLesson() {
    final appState = GetIt.instance.get<AppState>();
    appState.homeState.homeTab = HomeTab.learn;

    _closeAllRoutesExceptFirst();

    // TODO: Navigate to 'To Schedule' tab.

    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, Delivery, DeliveryFilter>();
    for (final list in lists.values) {
      list.clearAndLoadFirstPage();
    }
  }

  void _closeAllRoutesExceptFirst() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
