import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lxk_flutter_boilerplate/src/widgets/lazy_load_list_view/base_load_more_delegate.dart';
import 'package:loadmore/loadmore.dart';

class BaseLazyLoadListView extends StatefulWidget {
  final bool canLoadMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final bool isEmpty;
  final int? itemCount;
  final EdgeInsets padding;
  final TargetPlatform? customPlatform;

  const BaseLazyLoadListView(
      {super.key,
      required this.onRefresh,
      required this.canLoadMore,
      required this.onLoadMore,
      required this.isEmpty,
      required this.itemCount,
      required this.itemBuilder,
      this.padding = const EdgeInsets.all(0),
      this.customPlatform});

  @override
  State<BaseLazyLoadListView> createState() => BaseLazyLoadListViewState();
}

class BaseLazyLoadListViewState extends State<BaseLazyLoadListView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // https://github.com/flutter/flutter/issues/70971
  final ScrollController _controller = ScrollController(initialScrollOffset: 1);
  TargetPlatform platform = TargetPlatform.iOS;

  @override
  void didChangeDependencies() {
    platform = widget.customPlatform ?? Theme.of(context).platform;
    super.didChangeDependencies();
  }

  Widget _emptyView() {
    return const SliverFillRemaining(
        child: Center(
      child: Text("No results found."),
    ));
  }

  void showRefresh() async {
    if (platform == TargetPlatform.android) {
      _refreshIndicatorKey.currentState?.show();
    } else {
      /*
        we have to pull up the sliver list to the top with the offset of
        _defaultRefreshTriggerPullDistance (in CupertinoSliverRefreshControl)
        programmatically since CupertinoSliverRefreshControl doesn't expose its
        state through the key
       */
      _controller.animateTo(
        _controller.position.minScrollExtent - 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (platform == TargetPlatform.android) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: widget.onRefresh,
        child: widget.isEmpty
            ? CustomScrollView(
                controller: _controller,
                slivers: <Widget>[
                  _emptyView(),
                ],
              )
            : LoadMore(
                textBuilder: DefaultLoadMoreTextBuilder.english,
                isFinish: !widget.canLoadMore,
                delegate: const BaseLoadMoreDelegate(),
                onLoadMore: () {
                  return widget
                      .onLoadMore()
                      .then((value) => true)
                      .onError((error, stackTrace) => false);
                },
                child: ListView.builder(
                  padding: widget.padding,
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                ),
              ),
      );
    }

    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
        ),
        widget.isEmpty
            ? _emptyView()
            : SliverPadding(
                padding: widget.padding,
                sliver: LoadMore(
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                  isFinish: !widget.canLoadMore,
                  delegate: const BaseLoadMoreDelegate(),
                  onLoadMore: () {
                    return widget
                        .onLoadMore()
                        .then((value) => true)
                        .onError((error, stackTrace) => false);
                  },
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      widget.itemBuilder,
                      childCount: widget.itemCount,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
