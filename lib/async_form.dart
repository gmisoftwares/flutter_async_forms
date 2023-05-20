part of 'async_forms.dart';

class AsyncForm extends StatefulWidget {
  const AsyncForm({
    super.key,
    required this.child,
    this.onWillPop,
    this.onChanged,
    AutovalidateMode? autovalidateMode,
  }) : autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled;

  static AsyncFormState? maybeOf(BuildContext context) {
    final _AsyncFormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_AsyncFormScope>();
    return scope?._asyncformState;
  }

  static AsyncFormState of(BuildContext context) {
    final AsyncFormState? asyncformState = maybeOf(context);
    assert(() {
      if (asyncformState == null) {
        throw FlutterError(
          'AsyncForm.of() was called with a context that does not contain a AsyncForm widget.\n'
          'No AsyncForm widget ancestor could be found starting from the context that '
          'was passed to AsyncForm.of(). This can happen because you are using a widget '
          'that looks for a AsyncForm ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return asyncformState!;
  }

  final Widget child;

  final WillPopCallback? onWillPop;

  final VoidCallback? onChanged;

  final AutovalidateMode autovalidateMode;

  @override
  AsyncFormState createState() => AsyncFormState();
}

class AsyncFormState extends State<AsyncForm> {
  int _generation = 0;
  bool _hasInteractedByUser = false;
  final Set<AsyncFormFieldState<dynamic>> _fields =
      <AsyncFormFieldState<dynamic>>{};

  void _fieldDidChange() {
    widget.onChanged?.call();

    _hasInteractedByUser = _fields.any((AsyncFormFieldState<dynamic> field) =>
        field._hasInteractedByUser.value);
    _forceRebuild();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }

  void _register(AsyncFormFieldState<dynamic> field) {
    _fields.add(field);
  }

  void _unregister(AsyncFormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.autovalidateMode) {
      case AutovalidateMode.always:
        _validate().then((value) => setState(() {}));
      case AutovalidateMode.onUserInteraction:
        if (_hasInteractedByUser) {
          _validate().then((value) => setState(() {}));
        }
      case AutovalidateMode.disabled:
        break;
    }

    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _AsyncFormScope(
        asyncformState: this,
        generation: _generation,
        child: widget.child,
      ),
    );
  }

  Future<void> save() async {
    for (final AsyncFormFieldState<dynamic> field in _fields) {
      await field.save();
    }
  }

  void reset() {
    for (final AsyncFormFieldState<dynamic> field in _fields) {
      field.reset();
    }
    _hasInteractedByUser = false;
    _fieldDidChange();
  }

  Future<bool> validate() async {
    _hasInteractedByUser = true;
    final bool valide = await _validate();
    _forceRebuild();
    return valide;
  }

  Future<bool> _validate() async {
    bool hasError = false;
    String errorMessage = '';
    for (final AsyncFormFieldState<dynamic> field in _fields) {
      hasError = !(await field.validate()) || hasError;
      errorMessage += field.errorText ?? '';
    }
    if (mounted) {
      if (errorMessage.isNotEmpty) {
        final TextDirection directionality = Directionality.of(context);
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          unawaited(Future<void>(() async {
            await Future<void>.delayed(_kIOSAnnouncementDelayDuration);
            SemanticsService.announce(errorMessage, directionality,
                assertiveness: Assertiveness.assertive);
          }));
        } else {
          SemanticsService.announce(errorMessage, directionality,
              assertiveness: Assertiveness.assertive);
        }
      }
    }
    return !hasError;
  }
}
