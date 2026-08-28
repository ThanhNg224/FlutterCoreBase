import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) async* {
  final connectivity = Connectivity();
  final initial = await connectivity.checkConnectivity();
  yield !initial.contains(ConnectivityResult.none);
  yield* connectivity.onConnectivityChanged
      .map((List<ConnectivityResult> results) => !results.contains(ConnectivityResult.none))
      .distinct();
}
