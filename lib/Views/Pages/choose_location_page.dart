import 'package:ecommerce/Models/location_item_model.dart';
import 'package:ecommerce/View_Models/choose_location_cubit/choose_location_cubit.dart';
import 'package:ecommerce/Views/Widgets/location_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  final TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChooseLocationCubit>(context);
    Widget IconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(),
            Text(
              'Choose Location',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    prefixIcon: IconNavbar('assets/icons/location.png'),
                    suffixIcon:
                        BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
                          bloc: cubit,
                          buildWhen: (previous, current) =>
                              current is AddingLocation ||
                              current is LocationAdded ||
                              current is LocationAddedFailure,
                          listenWhen: (previous, current) =>
                              current is LocationAdded ||
                              current is ConfirmLocationLoaded,
                          listener: (context, state) {
                            if (state is LocationAdded) {
                              locationController.clear();
                            } else if (state is ConfirmLocationLoaded) {
                              Navigator.of(context).pop();
                            }
                          },
                          builder: (context, state) {
                            if (state is AddingLocation) {
                              return Center(
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation(
                                      Color(0XFFEDF8E9),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return IconButton(
                              onPressed: () {
                                if (locationController.text.isNotEmpty) {
                                  cubit.addLocation(locationController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Enter Your Location'),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        ),
                    hintText: 'Write Location: City-Country',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Color(0XFF41AB5D).withOpacity(0.15),
                    ),
                    fillColor: Color(0XFFEDF8E9).withOpacity(0.15),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      current is FetchingLocations ||
                      current is FetchedLocations ||
                      current is FetchLocationsFailure ||
                      current is LocationChosen,
                  builder: (context, state) {
                    if (state is FetchingLocations) {
                      return Center(
                        child: Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(
                              Color(0XFFEDF8E9),
                            ),
                          ),
                        ),
                      );
                    } else if (state is FetchedLocations ||
                        state is LocationChosen) {
                      // Get locations from either FetchedLocations or from cubit directly
                      final locationInformation = state is FetchedLocations
                          ? state.locations
                          : locations; // Use the global locations list

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: locationInformation.length,
                        itemBuilder: (context, index) {
                          final location = locationInformation[index];

                          // Check if this location is selected by comparing IDs
                          final isSelected =
                              cubit.selectedLocationId == location.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: LocationItemWidget(
                              borderColor: isSelected
                                  ? Color(0XFF41AB5D)
                                  : Theme.of(context).primaryColor,
                              borderWidth: isSelected ? 3.0 : 1.0,
                              onTap: () {
                                cubit.selectLocation(location.id);
                              },
                              location: location,
                            ),
                          );
                        },
                      );
                    } else if (state is FetchLocationsFailure) {
                      return Center(child: Text(state.errorMessage));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is ConfirmLocationLoading ||
                        current is ConfirmLocationLoaded ||
                        current is ConfirmLocationFailure,
                    builder: (context, state) {
                      if (state is ConfirmLocationLoading) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Color(0XFFEDF8E9),
                          ),
                          onPressed: () {
                            cubit.confirmLocation();
                          },
                          child: Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation(
                                Color(0XFFEDF8E9),
                              ),
                            ),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Color(0XFFEDF8E9),
                        ),
                        onPressed: () {
                          cubit.confirmLocation();
                        },
                        child: Text('Confirm', style: TextStyle(fontSize: 20)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
