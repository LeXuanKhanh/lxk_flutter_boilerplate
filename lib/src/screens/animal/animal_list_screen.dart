import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/modules/animals/bloc/animal_bloc.dart';
import '/shared/modules/animals/bloc/animal_event.dart';
import '/shared/modules/animals/bloc/animal_state.dart';
import '/src/routes/index.dart';
import '/src/widgets/lazy_load_list_view/base_lazy_load_list_view.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final GlobalKey<BaseLazyLoadListViewState> _listViewKey =
      GlobalKey<BaseLazyLoadListViewState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listViewKey.currentState!.showRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnimalBloc, AnimalState>(listener: (context, state) {
      if (state is AnimalFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
    }, builder: (BuildContext context, AnimalState state) {
      //debugPrint('current state: ${state.runtimeType} ${state.animals.length}');
      final animals = state.animals;
      return BaseLazyLoadListView(
          key: _listViewKey,
          onRefresh: () {
            context.read<AnimalBloc>().add(RefreshAnimalList());
            return context.read<AnimalBloc>().stream.firstWhere((element) {
              return element is NewAnimalListData;
            });
          },
          canLoadMore: state.canLoadMore,
          onLoadMore: () async {
            await Future.delayed(const Duration(seconds: 1));
            context.read<AnimalBloc>().add(LoadMoreAnimalList());
            await context.read<AnimalBloc>().stream.firstWhere((element) {
              return element is NewAnimalListData;
            });
            return Future.value();
          },
          isEmpty: animals.isEmpty,
          itemCount: animals.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                child: Column(
                  children: [
                    ListTile(
                        title: Text(
                      animals[index].name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                    const Divider(
                      height: 10.0,
                    )
                  ],
                ),
                onTap: () => Navigator.pushNamed(
                    context, RouteName.animalDetail.path,
                    arguments: animals[index]));
          });
    });
  }
}
