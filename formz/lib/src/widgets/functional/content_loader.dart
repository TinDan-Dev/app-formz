import 'package:flutter/cupertino.dart';

import '../../functional/content_loader/content_loader.dart';
import '../util/change_notifier.dart';

const double _defaultRefreshTriggerPullDistance = 100.0;

class ContentLoaderWidget<T> extends StatefulWidget {
  final ScrollPhysics? physics;

  final ContentLoader<T> loader;
  final Widget? Function(BuildContext context, int index, T? value) builder;

  final Widget? header;
  final Widget? footer;

  final bool footerOnlyWhenEmpty;

  final double refreshTriggerPullDistance;
  final Future<void> Function()? onRefresh;

  const ContentLoaderWidget({
    required this.loader,
    required this.builder,
    this.physics,
    this.header,
    this.footer,
    this.footerOnlyWhenEmpty = false,
    this.refreshTriggerPullDistance = _defaultRefreshTriggerPullDistance,
    this.onRefresh,
    Key? key,
  }) : super(key: key);

  @override
  State<ContentLoaderWidget<T>> createState() => _ContentLoaderWidgetState<T>();
}

class _ContentLoaderWidgetState<T> extends State<ContentLoaderWidget<T>> {
  Widget changeNotifier(Widget Function(BuildContext context) builder) {
    return ChangeNotifierWidget<ContentLoader>(
        unsubscribe: (notifier) => !notifier.isDisposed, notifier: widget.loader, builder: builder);
  }

  Widget createList(bool withNotifier) {
    final buildList = () => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => widget.builder(context, index, widget.loader[index]),
            childCount: widget.loader.length,
          ),
        );

    if (withNotifier) {
      return changeNotifier((_) => buildList());
    } else {
      return buildList();
    }
  }

  Widget createScrollView(bool withContentNotifier) {
    final footer = widget.footer;

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
        createList(withContentNotifier),
        if (footer != null && (!widget.footerOnlyWhenEmpty || widget.loader.isEmpty)) footer,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.footerOnlyWhenEmpty && widget.footer != null) {
      return changeNotifier((_) => createScrollView(false));
    } else {
      return createScrollView(true);
    }
  }
}
