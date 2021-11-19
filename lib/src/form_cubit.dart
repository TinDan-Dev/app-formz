import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'attachments.dart';
import 'form_state.dart';
import 'functional/result.dart';
import 'input/input.dart';
import 'input_container.dart';

class _InputAttachment<T> {
  final T value;
  final void Function(T value)? _dispose;

  _InputAttachment(this.value, this._dispose);

  void dispose() => _dispose?.call(value);
}

abstract class FormCubit extends Cubit<FormState> with InputContainer, MutableInputContainer {
  final _attachments = <String, List<_InputAttachment>>{};

  FormCubit(FormState initialState) : super(initialState);

  @override
  Iterable<Input> get inputs => state.inputs;

  @override
  void replaceInput(Input input) {
    emit(state.copyWith(inputs: [input]));
  }

  T getAttachment<T>(
    String name, {
    required T create(),
    void dispose(T value)?,
  }) {
    final attachments = _attachments.putIfAbsent(name, () => []);

    final attachment = attachments.where((e) => e.value is T);
    assert(attachment.length <= 1, '${attachment.length} attachments of Type $T found');

    if (attachment.length < 1) {
      final value = create();
      attachments.add(_InputAttachment<T>(value, dispose));

      return value;
    } else {
      return attachment.first.value;
    }
  }

  Iterable<T> getAttachments<T>() {
    return _attachments.values.expand((e) => e).where((e) => e.value is T).map((e) => e.value);
  }

  void setFailure(Failure? failure) => emit(state.copyWith(failure: () => failure));

  Future<Result<void>> submit(FutureOr<ResultFuture<void>> action()) async {
    assert(!state.submission, 'Another submission is currently in progress');
    unfocusAll();

    emit(state.copyWith(submission: true, failure: () => null));
    final result = await action();

    return result.consume(
      onRight: (_) {
        emit(state.copyWith(submission: false, failure: () => null));
        return Result.right(null);
      },
      onLeft: (failure) {
        emit(state.copyWith(submission: false, failure: () => failure));
        return Result.left(failure);
      },
    );
  }

  T getProperty<T extends Object>(String key) => state.getProperty<T>(key);

  void setProperty(String key, {required Object value}) => emit(state.copyWith(properties: {key: value}));

  @override
  Future<void> close() async {
    await super.close();

    _attachments.values.forEach((attachments) => attachments.forEach((attachment) => attachment.dispose.call()));
  }
}
