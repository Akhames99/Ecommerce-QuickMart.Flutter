part of 'choose_location_cubit.dart';

sealed class ChooseLocationState {}

final class ChooseLocationInitial extends ChooseLocationState {}

final class FetchingLocations extends ChooseLocationState {}

final class FetchedLocations extends ChooseLocationState {
  final List<LocationItemModel> locations;

  FetchedLocations({required this.locations});
}

final class FetchLocationsFailure extends ChooseLocationState {
  final String errorMessage;

  FetchLocationsFailure({required this.errorMessage});
}

final class AddingLocation extends ChooseLocationState {}

final class LocationAdded extends ChooseLocationState {}

final class LocationAddedFailure extends ChooseLocationState {
  final String errorMessage;

  LocationAddedFailure({required this.errorMessage});
}

final class LocationChosen extends ChooseLocationState {
  final LocationItemModel location;

  LocationChosen(this.location);
}

final class ConfirmLocationLoading extends ChooseLocationState {}

final class ConfirmLocationLoaded extends ChooseLocationState {}

final class ConfirmLocationFailure extends ChooseLocationState {
  final String errorMessage;

  ConfirmLocationFailure({required this.errorMessage});
}
