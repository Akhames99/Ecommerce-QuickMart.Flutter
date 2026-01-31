import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/location_item_model.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());

  final locationServices = LocationServicesImpl();
  final authServices = AuthServicesImpl();

  /// Stored locations list
  List<LocationItemModel> locations = [];

  String? selectedLocationId;
  LocationItemModel? selectedLocation;

  // ================= FETCH =================

  Future<void> fetchLocations() async {
    emit(FetchingLocations());

    try {
      final currentUser = authServices.currentUser();
      final fetched = await locationServices.fetchLocations(currentUser!.uid);

      locations = fetched;

      for (var location in locations) {
        if (location.isChosen) {
          selectedLocationId = location.id;
          selectedLocation = location;
        }
      }

      if (locations.isNotEmpty) {
        selectedLocationId ??= locations.first.id;
        selectedLocation ??= locations.first;
      }

      emit(FetchedLocations(locations: locations));

      if (selectedLocation != null) {
        emit(LocationChosen(selectedLocation!));
      }
    } catch (e) {
      emit(FetchLocationsFailure(errorMessage: e.toString()));
    }
  }

  // ================= ADD =================

  Future<void> addLocation(String locationText) async {
    emit(AddingLocation());

    try {
      final splittedLocations = locationText.split('-');

      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedLocations[0],
        country: splittedLocations[1],
      );

      final currentUser = authServices.currentUser();

      await locationServices.setLocation(locationItem, currentUser!.uid);

      emit(LocationAdded());

      // Refresh list
      final fetched = await locationServices.fetchLocations(currentUser.uid);

      locations = fetched;

      emit(FetchedLocations(locations: locations));
    } catch (e) {
      emit(LocationAddedFailure(errorMessage: e.toString()));
    }
  }

  // ================= SELECT =================

  /// Select locally — NO DB call
  void selectLocation(LocationItemModel location) {
    selectedLocationId = location.id;
    selectedLocation = location;

    emit(LocationChosen(location));
  }

  // ================= CONFIRM =================

  Future<void> confirmLocation() async {
    emit(ConfirmLocationLoading());

    try {
      final currentUser = authServices.currentUser();

      final previousChosenLocations = await locationServices.fetchLocations(
        currentUser!.uid,
        true,
      );

      if (previousChosenLocations.isNotEmpty) {
        final previousLocation = previousChosenLocations.first.copyWith(
          isChosen: false,
        );

        await locationServices.setLocation(previousLocation, currentUser.uid);
      }

      final updatedSelected = selectedLocation!.copyWith(isChosen: true);

      await locationServices.setLocation(updatedSelected, currentUser.uid);

      emit(ConfirmLocationLoaded());
    } catch (e) {
      emit(ConfirmLocationFailure(errorMessage: e.toString()));
    }
  }
}
