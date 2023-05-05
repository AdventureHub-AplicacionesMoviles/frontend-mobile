import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/season_provider.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key, required this.token}) : super(key: key);
  final String? token;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

enum Character { group, private }

class _FilterScreenState extends State<FilterScreen> {
  Character? _character = Character.group;
  double _currentSliderValue = 20;
  double _currentSliderValue1 = 1;

  @override
  void initState() {
    super.initState();
    getData();
    // getDataD();
  }

  // Future getDataD() async {
  //   final destinationProvider = Provider.of<DestinationProvider>(
  //     context,
  //     listen: false,
  //   );
  //   if (destinationProvider.destinations.isEmpty) {
  //     await destinationProvider.getDetination(widget.token);
  //   }
  // }

  Future getData() async {
    final seasonProvider = Provider.of<SeasonProvider>(
      context,
      listen: false,
    );
    if (seasonProvider.seasons.isEmpty) {
      await seasonProvider.getSeasons(widget.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinationProvider =
        Provider.of<DestinationProvider>(context, listen: false);
    final destinations = destinationProvider.destinations;
    final seasonPorvider = Provider.of<SeasonProvider>(context, listen: false);
    final seasons = seasonPorvider.seasons;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Filters',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                'Price',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Slider(
                value: _currentSliderValue,
                max: 1000,
                divisions: 500,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Destination',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your destination',
                ),
              ),
              const SizedBox(height: 15),
              // const Text(
              //   'Destinations',
              //   textAlign: TextAlign.left,
              //   style: TextStyle(fontSize: 16, color: Colors.black),
              // ),
              // const SizedBox(height: 5),
              // ValueListenableBuilder(
              //   valueListenable: ValueNotifier(_character),
              //   builder: (ct, value, _) => DropdownSearch<String>(
              //       items: destinations.map((e) => e.name).toList(),
              //       onChanged: print,
              //       selectedItem: "Seleccionar"),
              // ),
              const SizedBox(height: 15),
              const Text(
                'Seasons',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 5),
              DropdownSearch<String>(
                  items: seasons.map((e) => e.name).toList(),
                  onChanged: print,
                  selectedItem: "Seleccionar"),
              const SizedBox(height: 15),

              Container(
                  color: const Color.fromRGBO(252, 71, 71, 1),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
