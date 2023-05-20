part of 'async_forms.dart';

class _AsyncFormScope extends InheritedWidget {
  const _AsyncFormScope({
    required super.child,
    required AsyncFormState asyncformState,
    required int generation,
  })  : _asyncformState = asyncformState,
        _generation = generation;

  final AsyncFormState _asyncformState;

  final int _generation;

  AsyncForm get asyncform => _asyncformState.widget;

  @override
  bool updateShouldNotify(_AsyncFormScope old) =>
      _generation != old._generation;
}
