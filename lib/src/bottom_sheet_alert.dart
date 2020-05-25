import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_action.dart';
import 'cancel_action.dart';

Future<T> showAdaptiveActionSheet<T>({
  BuildContext context,
  List<BottomSheetAction> actions,
  CancelAction cancelAction,
}) async {
  return _show<T>(context, actions, cancelAction);
}

Future<T> _show<T>(
  BuildContext context,
  List<BottomSheetAction> actions,
  CancelAction cancelAction,
) {
  if (Platform.isIOS) {
    return _showCupertinoBottomSheet(context, actions, cancelAction);
  } else {
    return _showMaterialBottomSheet(context, actions, cancelAction);
  }
}

Future<T> _showCupertinoBottomSheet<T>(
  BuildContext context,
  List<BottomSheetAction> actions,
  CancelAction cancelAction,
) {
  final _textStyle = Theme.of(context).textTheme.headline6;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext coxt) {
      return CupertinoActionSheet(
        actions: actions.map((action) {
          return CupertinoActionSheetAction(
            onPressed: action.onPressed,
            child: Text(
              action.title,
              // style: _textStyle,
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: cancelAction.onPressed ?? () => Navigator.of(coxt).pop(),
          child: Text(
            cancelAction.title,
            style: _textStyle.copyWith(color: Colors.lightBlue),
          ),
        ),
      );
    },
  );
}

Future<T> _showMaterialBottomSheet<T>(
  BuildContext context,
  List<BottomSheetAction> actions,
  CancelAction cancelAction,
) {
  final _textStyle = Theme.of(context).textTheme.headline6;
  return showModalBottomSheet<T>(
    context: context,
    elevation: 0,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (BuildContext coxt) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...actions.map<Widget>((action) {
            return InkWell(
              onTap: action.onPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      action.title,
                      style: _textStyle,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          InkWell(
            onTap: cancelAction.onPressed ?? () => Navigator.of(coxt).pop(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  cancelAction.title,
                  style: _textStyle.copyWith(color: Colors.lightBlue),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
