import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'attachments.dart';
import 'form_state.dart';
import 'functional/result/result.dart';
import 'input/input.dart';
import 'input_container.dart';

class _InputAttachment<T> {
  final T value;
  final void Function(T value)? _dispose;

  _InputAttachment(this.value, this._dispose);

  void dispose() => _dispose?.call(value);
}

abstract class FormCubit extends Cubit<FormState> with InputContainer, MutableInputContainer {
  final _attachments = <InputIdentifier, List<_InputAttachment>>{};

  FormCubit(FormState initialState) : super(initialState);

  @override
  Iterable<Input> get inputs => state.inputs;

  @override
  Stream<FormState> get stream => super.stream.where((e) => !e.synchronization).distinct();

  void synchronized(void action()) {
    emit(state.copyWith(synchronization: true));
    action();
    emit(state.copyWith(synchronization: false));
  }

  @override
  void replaceInput(Input input) {
    emit(state.copyWith(inputs: [input]));
  }

  T getAttachment<T>(
    InputIdentifier inputId, {
    required T create(),
    void dispose(T value)?,
  }) {
    final attachments = _attachments.putIfAbsent(inputId, () => []);

    final attachment = attachments.whereType<_InputAttachment<T>>();
    assert(attachment.length <= 1, '${attachment.length} attachments of Type $T found');

    if (attachment.isEmpty) {
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

  Future<Result<T>> submit<T>(FutureOr<Result<T>> action()) async {
    assert(!state.submission, 'Another submission is currently in progress');
    assert(!state.synchronization, 'Do not submit during synchronization');

    unfocusAll();

    emit(state.copyWith(submission: true, failure: () => null));
    final result = await action();

    return result.consume(
      onRight: (result) {
        emit(state.copyWith(submission: false, failure: () => null));
        return Result.right(result);
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
  @mustCallSuper
  Future<void> close() async {
    await super.close();

    for (final attachments in _attachments.values) {
      for (final attachment in attachments) {
        attachment.dispose.call();
      }
    }
  }
}
