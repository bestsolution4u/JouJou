import 'package:joujou_lounge/bloc_data/base_bloc.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';

class NoteBloc extends BaseBloc<String> {

  Stream<String> get notes => fetcher.stream;

  fetchNotes() async {
    String notes = await MetaRepository.getMetaValue("note");
    fetcher.sink.add(notes);
  }
}