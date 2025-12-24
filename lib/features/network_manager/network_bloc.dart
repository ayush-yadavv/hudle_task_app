import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void _observe(NetworkObserve event, Emitter<NetworkState> emit) async {
    try {
      final results = await _connectivity.checkConnectivity();
      bool isConnected = results.any((r) => r != ConnectivityResult.none);
      add(NetworkNotify(isConnected: isConnected));
    } catch (_) {
      add(NetworkNotify(isConnected: false));
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      bool isConnected = results.any((r) => r != ConnectivityResult.none);
      add(NetworkNotify(isConnected: isConnected));
    });
  }

  void _notifyStatus(NetworkNotify event, Emitter<NetworkState> emit) {
    if (event.isConnected) {
      emit(NetworkSuccess());
    } else {
      emit(NetworkFailure());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
