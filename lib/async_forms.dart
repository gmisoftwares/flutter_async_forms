library async_forms;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

part 'async_form_field.dart';
part 'async_form.dart';
part 'async_form_scope.dart';
part 'async_text_form_field.dart';

const Duration _kIOSAnnouncementDelayDuration = Duration(seconds: 1);

typedef AsyncFormFieldValidator<T> = Future<String?> Function(T? value);

typedef AsyncFormFieldSetter<T> = Future<void> Function(T? newValue);

typedef AsyncFormFieldBuilder<T> = Widget Function(
    AsyncFormFieldState<T> field);
