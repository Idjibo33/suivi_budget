import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'solde_event.dart';
part 'solde_state.dart';

class SoldeBloc extends Bloc<SoldeEvent, SoldeState> {
  SoldeBloc() : super(SoldeInitial()) {
    on<SoldeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
