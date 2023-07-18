import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/core/constans/constants.dart';
import 'package:location_grm/feactures/core/utils/speech_to_text.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/markers_provider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

class SearchOrigen extends ConsumerStatefulWidget {
  final String hintText;

  const SearchOrigen({super.key, required this.hintText});

  @override
  SearchOrigenState createState() => SearchOrigenState(hintText: hintText);
}

class SearchOrigenState extends ConsumerState<SearchOrigen> {
  TextEditingController controller = TextEditingController();
  FocusNode origenFocusNode = FocusNode();
  String location = "Search Location";

  final String hintText;

  SearchOrigenState({
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
          controller: controller,
          focusNode: origenFocusNode,
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
                onPressed: () {},
                icon: const Icon(Icons.mic),
                color: Colors.grey[700]),
          ),
          textInputAction: TextInputAction.search,
          // onChanged: onChanged,
          onTap: () async {
            var place = await PlacesAutocomplete.show(
                // hint: '',
                startText: 'Monumento',
                context: context,
                apiKey: google_api_key,
                mode: Mode.overlay,
                types: [],
                language: 'es',
                strictbounds: false,
                components: [
                  Component(Component.country, 'bol'),
                ],
                //google_map_webservice package
                onError: (err) {
                  print(err);
                });

            if (place != null) {
              location = place.description.toString();

              location = place.description.toString();

              //form google_maps_webservice package
              final plist = GoogleMapsPlaces(
                apiKey: google_api_key,
                apiHeaders: await const GoogleApiHeaders().getHeaders(),
                //from google_api_headers package
              );

              String placeid = place.placeId ?? "0";
              final detail = await plist.getDetailsByPlaceId(placeid);
              final geometry = detail.result.geometry!;
              final lat = geometry.location.lat;
              final lang = geometry.location.lng;
              var newlatlang = LatLng(lat, lang);

              ref.read(markersProvider.notifier).addDestino(newlatlang);

              controller.text = detail.result.name;
              origenFocusNode.unfocus();
            }
          }),
    );
  }
}
