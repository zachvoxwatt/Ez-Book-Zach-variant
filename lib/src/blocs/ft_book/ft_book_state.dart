part of 'ft_book_bloc.dart';

@immutable
abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookErrorNoConnection extends BookState {}

class BookErrorForbidden extends BookState {}

class BookPollSuccess extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  BookLoaded({required this.books});
}
