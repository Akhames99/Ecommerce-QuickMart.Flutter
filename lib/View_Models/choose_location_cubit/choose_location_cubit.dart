import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/location_item_model.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());

  String selectedLocationId = locations.first.id;
  void fetchLocations() {
    emit(FetchingLocations());
    Future.delayed(Duration(seconds: 1), () {
      emit(FetchedLocations(locations: locations));
    });
  }

  void addLocation(String Location) {
    emit(AddingLocation());
    Future.delayed(Duration(seconds: 1), () {
      final splittedLocations = Location.split('-');
      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedLocations[0],
        country: splittedLocations[1],
      );
      locations.add(locationItem);
      emit(LocationAdded());
      emit(FetchedLocations(locations: locations));
    });
  }

  void selectLocation(String id) {
    selectedLocationId = id;
    final chosenLocation = locations.firstWhere(
      (location) => location.id == selectedLocationId,
    );
    emit(LocationChosen(chosenLocation));
  }

  void confirmLocation() {
    emit(ConfirmLocationLoading());
    Future.delayed(Duration(seconds: 1), () {
      var chosenLocation = locations.firstWhere(
        (location) => location.id == selectedLocationId,
      );
      var previousLocation = locations.firstWhere(
        (location) => location.isChosen == true,
        orElse: () => locations.first,
      );
      previousLocation = previousLocation.copyWith(isChosen: false);
      chosenLocation = chosenLocation.copyWith(isChosen: true);
      final previousIndex = locations.indexWhere(
        (location) => location.id == previousLocation.id,
      );
      final chosenIndex = locations.indexWhere(
        (location) => location.id == chosenLocation.id,
      );
      locations[previousIndex] = previousLocation;
      locations[chosenIndex] = chosenLocation;
      emit(ConfirmLocationLoaded());
    });
  }
}
