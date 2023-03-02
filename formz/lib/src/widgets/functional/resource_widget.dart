import 'package:flutter/material.dart';

import '../../functional/resource/resource.dart';
import '../../functional/result/result.dart';
import '../../utils/extensions.dart';
import 'either_widget.dart';

class ResourceWidget<T extends Object> extends StatelessWidget {
  final Resource<T, dynamic> resource;

  final Widget Function(BuildContext context) onLoading;

  final Widget Function(BuildContext context, T value) onSuccess;

  final Widget Function(BuildContext context, Failure remoteFailure) onError;

  const ResourceWidget({
    required this.resource,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Result<T>>(
      stream: resource.stream,
      initialData: resource.snapshot.consume(
        onRight: (value) => value.let((some) => Result.right(some)),
        onLeft: (failure) => Result.left(failure),
      ),
      builder: (context, snapshot) {
        return snapshot.data.fold(
          () => onLoading(context),
          (some) => ResultWidget<T>(
            either: some,
            onLeft: onError,
            onRight: onSuccess,
          ),
        );
      },
    );
  }
}
