import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/bloc/animal_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/bloc/animal_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/bloc/animal_state.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/models/Animal.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/text_widget+extension.dart';
import 'package:lxk_flutter_boilerplate/src/utils/general_utils.dart';
import 'package:lxk_flutter_boilerplate/src/widgets/cache_image_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AnimalDetailScreen extends StatefulWidget {
  const AnimalDetailScreen({super.key});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  Animal? animal;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _createAtController = TextEditingController();

  @override
  void didChangeDependencies() {
    animal = tryCast<Animal>(ModalRoute.of(context)!.settings.arguments);
    if (animal != null) {
      _idController.text = animal!.id;
      _nameController.text = animal!.name;
      _createAtController.text = animal!.createdAt.toString();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    final title =
        animal != null ? 'Update successfully' : 'Create successfully';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          animal != null ? 'Edit Animal' : 'Create Animal',
          style: Theme.of(context).textTheme.bodyLarge,
        ).onColorSurface,
        actions: [
          IconButton(
              icon: Icon(animal != null ? Icons.edit : Icons.add, size: 26.0),
              onPressed: () {
                if (animal != null) {
                  final editAnimal =
                      animal!.copyWith(name: _nameController.text);
                  context.read<AnimalBloc>().add(EditAnimal(
                      id: int.tryParse(editAnimal.id)!, animal: editAnimal));
                } else {
                  final newAnimal = Animal(
                      createdAt: DateTime.now(),
                      name: _nameController.text,
                      avatar: 'https://picsum.photos/seed/animal/300/300',
                      id: '');
                  context
                      .read<AnimalBloc>()
                      .add(CreateAnimal(animal: newAnimal));
                }
              })
        ],
      ),
      body: BlocConsumer<AnimalBloc, AnimalState>(listener: (context, state) {
        // print(state.runtimeType);
        if (state is AnimalFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is NewAnimalData) {
          _showSuccessDialog(context);
        }
      }, builder: (context, state) {
        if (state is AnimalLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }

        return Form(
          key: _key,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  animal != null
                      ? CachedImage(
                          imageUrl: animal!.avatar, width: 100, height: 100)
                      : const SizedBox(),
                  animal != null
                      ? TextField(
                          enabled: false,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'ID',
                            filled: false,
                            isDense: true,
                          ),
                          controller: _idController,
                          autocorrect: false,
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      filled: false,
                      isDense: true,
                    ),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || (value.isEmpty)) {
                        return 'Name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  animal != null
                      ? TextField(
                          enabled: false,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Created Date',
                            filled: false,
                            isDense: true,
                          ),
                          controller: _createAtController,
                          keyboardType: TextInputType.datetime,
                          autocorrect: false,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
