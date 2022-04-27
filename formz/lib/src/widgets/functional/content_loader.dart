import 'package:flutter/cupertino.dart';

import '../../functional/dynamic_content_loader/dynamic_content_loader.dart';
import '../util/change_notifier.dart';

const double _defaultRefreshTriggerPullDistance = 100.0;

class ContentLoaderWidget<T> extends StatefulWidget {
  final ScrollPhysics? physics;

  final DynamicContentLoader<T> loader;
  final Widget? Function(BuildContext context, int index, T? value) builder;

  final Widget? header;
  final Widget? footer;

  final double refreshTriggerPullDistance;
  final Future<void> Function()? onRefresh;

  const ContentLoaderWidget({
    required this.loader,
    required this.builder,
    this.physics,
    this.header,
    this.footer,
    this.refreshTriggerPullDistance = _defaultRefreshTriggerPullDistance,
    this.onRefresh,
    Key? key,
  }) : super(key: key);

  @override
  State<ContentLoaderWidget<T>> createState() => _ContentLoaderWidgetState<T>();
}

class _ContentLoaderWidgetState<T> extends State<ContentLoaderWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: widget.physics,
      slivers: [
        if (widget.header != null) widget.header!,
        if (widget.onRefresh != null)
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: widget.refreshTriggerPullDistance,
            onRefresh: widget.onRefresh,
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 4)),
        ChangeNotifierWidget<DynamicContentLoader>(
          unsubscribe: (notifier) => !notifier.isDisposed,
          notifier: widget.loader,
          builder: (context) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.builder(context, index, widget.loader[index]),
                childCount: widget.loader.length,
              ),
            );
          },
        ),
        if (widget.footer != null) widget.footer!,
      ],
    );
  }
}
