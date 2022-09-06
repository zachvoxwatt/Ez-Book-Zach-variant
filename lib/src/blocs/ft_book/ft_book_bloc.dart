import 'package:bloc/bloc.dart';
import 'package:ez_book/src/services/repositories/ping.dart';
import 'package:meta/meta.dart';

import '../../models/book.dart';
import '../../services/repositories/book.dart';

part 'ft_book_event.dart';
part 'ft_book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookRepository repo;
  BookBloc({required this.repo}) : super(BookInitial()) {
    on<BookLoadEvent>(onLoad);
  }

  void onLoad(BookLoadEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    var hasConnection = await PingRepository.pingServer();
    await Future.delayed(const Duration(seconds: 2));
    if (hasConnection) {
      List<Book> results = await repo.getBooks();
      if (results[0] is BookError) {
        emit(BookErrorForbidden());
        return;
      }
      emit(BookPollSuccess());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(BookLoaded(books: results));
      return;
    } else {
      emit(BookErrorNoConnection());
    }
  }
}
