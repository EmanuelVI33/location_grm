import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';
import 'package:location_grm/feactures/mapa/presentation/delegates/search_edificio_delegate.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/markers_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/storage/local_storage_provider.dart';

class SearchDestino extends ConsumerStatefulWidget {
  final String hintText;

  const SearchDestino({super.key, required this.hintText});

  @override
  SearchInputState createState() => SearchInputState(hintText: hintText);
}

class SearchInputState extends ConsumerState<SearchDestino> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  final String hintText;

  SearchInputState({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: IconButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(),
                  ),
              icon: const Icon(Icons.mic),
              color: Colors.grey[700]),
        ),
        textInputAction: TextInputAction.search,
        // onChanged: onChanged,
        onTap: () async {
          focusNode.unfocus();

          final localStorageRep = ref.read(localStorageRepositoryProvider);

          Edificio? edificio = await showSearch<Edificio?>(
            context: context,
            delegate: SearchEdifioDelegate(
              label: 'Buscar origen',
              searchEdificio: localStorageRep.getEdificio,
            ),
          );

          if (edificio != null) {
            final point = LatLng(edificio.latitud, edificio.longitud);
            ref.read(markersProvider.notifier).addOrigen(point);
            controller.text = edificio.descripcion;
          }
        },
      ),
    );
  }
}


// class SearchInput extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final void Function(String)? onChanged;

//   const SearchInput({
//     Key? key,
//     required this.controller,
//     this.onChanged,
//     required this.hintText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: BorderSide(color: Colors.grey.shade400),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: BorderSide(color: Colors.grey.shade400),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: const BorderSide(color: Colors.blue),
//           ),
//           suffixIcon: const Icon(Icons.search, color: Colors.grey),
//         ),
//         textInputAction: TextInputAction.search,
//         // onSubmitted: onSubmitted,
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
