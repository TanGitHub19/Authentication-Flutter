import 'package:auth_flutter/models/booking_model.dart';
import 'package:auth_flutter/repositories/booking_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepo bookingRepo;
  BookingBloc(this.bookingRepo) : super(BookingInitial()) {
    on<GetBooking>((event, emit) async {
      try {
        emit(RequestLoading());
        final bookings = await bookingRepo.getAllBooking();
        emit(RequestLoaded(bookings));
      } catch (e) {
        emit(RequestError('Failed to fetch bookings $e'));
      }
    });
    on<GetBookingById>((event, emit) async {
      emit(RequestLoading());
      final booking = await bookingRepo.getBookingById(event.id);
      emit(RequestLoadedById(booking));
    });

    on<AcceptBooking>((event, emit) async {
      emit(RequestLoading());
      final booking = await bookingRepo.acceptBooking(event.bookingId);
      emit(RequestLoadedById(booking));
    });

    on<RejectBooking>((event, emit) async {
      emit(RequestLoading());
      final booking = await bookingRepo.rejectBooking(event.bookingId);
      emit(RequestLoadedById(booking));
    });

    on<GetAllPendingBooking>((event, emit) async {
      try {
        emit(RequestLoading());
        final pendingBookings = await bookingRepo.getAllPendingBooking();
        emit(RequestPendingLoaded(pendingBookings));
      } catch (e) {
        emit(RequestError('Failed to fetch bookings $e'));
      }
    });
  }
}
