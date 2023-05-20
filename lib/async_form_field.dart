part of 'async_forms.dart';

class AsyncFormField<T> extends StatefulWidget {
  const AsyncFormField({
    super.key,
    required this.builder,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
    AutovalidateMode? autovalidateMode,
    this.restorationId,
  }) : autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled;

  final AsyncFormFieldSetter<T>? onSaved;
  final AsyncFormFieldValidator<T>? validator;
  final AsyncFormFieldBuilder<T> builder;
  final T? initialValue;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final String? restorationId;

  @override
  AsyncFormFieldState<T> createState() => AsyncFormFieldState<T>();
}

class AsyncFormFieldState<T> extends State<AsyncFormField<T>>
    with RestorationMixin {
  late T? _value = widget.initialValue;
  final RestorableStringN _errorText = RestorableStringN(null);
  final RestorableBool _hasInteractedByUser = RestorableBool(false);

  T? get value => _value;
  String? get errorText => _errorText.value;
  bool get hasError => _errorText.value != null;
  Future<bool> get isValid async =>
      await widget.validator?.call(_value) == null;

  Future<void> save() async {
    await widget.onSaved?.call(value);
  }

  void reset() {
    setState(() {
      _value = widget.initialValue;
      _hasInteractedByUser.value = false;
      _errorText.value = null;
    });
    AsyncForm.maybeOf(context)?._fieldDidChange();
  }

  Future<bool> validate() async {
    await _validate();
    setState(() {});
    return !hasError;
  }

  Future<void> _validate() async {
    if (widget.validator != null) {
      _errorText.value = await widget.validator!(_value);
    }
  }

  void didChange(T? value) {
    setState(() {
      _value = value;
      _hasInteractedByUser.value = true;
    });
    AsyncForm.maybeOf(context)?._fieldDidChange();
  }

  @protected
  void setValue(T? value) {
    _value = value;
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_errorText, 'error_text');
    registerForRestoration(_hasInteractedByUser, 'has_interacted_by_user');
  }

  @override
  void deactivate() {
    AsyncForm.maybeOf(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      switch (widget.autovalidateMode) {
        case AutovalidateMode.always:
          _validate();
        case AutovalidateMode.onUserInteraction:
          if (_hasInteractedByUser.value) {
            _validate();
          }
        case AutovalidateMode.disabled:
          break;
      }
    }
    AsyncForm.maybeOf(context)?._register(this);
    return widget.builder(this);
  }
}
