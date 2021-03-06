// Copyright (c) 2015, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'dart:js';

import 'package:firebase/firebase.dart';

import 'package:dart_service_worker/config.dart';
import 'package:dart_service_worker/service_worker_client.dart';

class KsichtApp extends ServiceWorkerClientHelper {
  CheckboxInputElement pushPermissionSwitch;
  Element filipMessageEl;
  Element filipMessageBubbleEl;
  Element subsPermissionDeniedEl;
  ParagraphElement subsCountMessageEl;
  Firebase fb;

  void updatePushPermissionSwitch() {
    pushPermissionSwitch.checked = isPushEnabled;
  }

  void _hideElement(Element el) {
    el.style.display = "none";
  }

  void _showElement(Element el) {
    el.style.display = "block";
  }

  Future handlePushPermissionSwitchClick(_) async {
    // TODO: dim screen as per guidelines
    if (!isPushEnabled) {
      await subscribe();
      updatePushPermissionSwitch();
    } else {
      await unsubscribe();
      updatePushPermissionSwitch();
    }
  }

  Firebase get _subscriptionSet => fb.child(FIREBASE_SUBSCRIPTION_SET);
  Firebase get _subscriptionsCount => fb.child(FIREBASE_SUBSCRIPTIONS_COUNT);
  Firebase get _filipMessage => fb.child(FIREBASE_LATEST_MESSAGE);

  void _updateSubscriptionsCount(int change) {
    _subscriptionsCount.transaction((currentVal) {
      return (currentVal == null ? 0 : currentVal) + change;
    });
  }

  @override
  void onBeforeInit() {
    fb = new Firebase(FIREBASE_URL);
    pushPermissionSwitch = querySelector("#push-permission-switch");
    filipMessageEl = querySelector("#filip-message");
    filipMessageBubbleEl = querySelector("#filip-message-bubble");
    subsPermissionDeniedEl =
        querySelector("#push-subscription-permission-denied");
    subsCountMessageEl = querySelector("#subscriptions-count-message");
  }

  String _createSubsCountMessage(int count) {
    if (count == null || count <= 0) {
      return "(Filipa teď nikdo neposlouchá)";
    } else if (count == 1) {
      return "(Filipa teď poslouchá jeden člověk)";
    } else if (count <= 4) {
      return "(Filipa teď poslouchají $count lidé)";
    } else {
      return "(Filipa teď poslouchá $count lidí)";
    }
  }

  void _startFirebaseListeners() {
    _subscriptionsCount.onValue.listen((event) {
      int count = event.snapshot.val();
      subsCountMessageEl.text = _createSubsCountMessage(count);
    });

    _filipMessage.onValue.listen((event) {
      String msg = event.snapshot.val()["message"];
      filipMessageEl.text = msg == null ? "<teď zrovna nic>" : msg;
      filipMessageBubbleEl.classes.add("expanded");
    });
  }

  void _upgradeSwitch() {
    new JsObject(context['MaterialSwitch'], [querySelector(".mdl-switch")]);
  }

  @override
  void onInitSuccess() {
    updatePushPermissionSwitch();
    pushPermissionSwitch.disabled = false;
    pushPermissionSwitch.onChange.listen((handlePushPermissionSwitchClick));

    _startFirebaseListeners();
    _upgradeSwitch();
  }

  @override
  void onInitFailure(Error e) {
    _showElement(querySelector("#unimplemented-error"));
    print("Service Worker failed to initialize.");
    print(e);

    _startFirebaseListeners();
    _upgradeSwitch();
  }

  @override
  void onPushMessageNoSubscription() {
    print("onPushMessageNoSubscription");
  }

  @override
  void onPushMessagePermissionDeniedError(_) {
    _showElement(subsPermissionDeniedEl);
  }

  @override
  void onPushMessageSubscription(PushSubscription subscription) {
//    print(_generateCurlCommand(subscription.endpoint));
  }

  @override
  onPushMessageSubscribe(PushSubscription subscription) async {
    _hideElement(subsPermissionDeniedEl);
    var subFirebaseRec = _subscriptionSet.child(subscription.subscriptionId);
    var snapshot = await subFirebaseRec.once("value");
    if (!snapshot.exists) {
      subFirebaseRec.set(true);
      _updateSubscriptionsCount(1);
    }
  }

  @override
  onPushMessageUnsubscribe(PushSubscription subscription, bool success) async {
    _hideElement(subsPermissionDeniedEl);
    // Even in case of failure, remove subscription from server.
    var subFirebaseRec = _subscriptionSet.child(subscription.subscriptionId);
    var snapshot = await subFirebaseRec.once("value");
    if (snapshot.exists) {
      subFirebaseRec.set(null);
      _updateSubscriptionsCount(-1);
    }
  }
}

void main() {
  // Start app
  new KsichtApp().init();
}
