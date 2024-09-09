part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {}

class RequestLoading extends BookingState {}

class RequestLoaded extends BookingState {
  final List<Booking> bookings;


  const RequestLoaded(this.bookings);

  @override
  List<Object> get props => [bookings ];
}

class RequestLoadedById extends BookingState {
  final Booking booking;

  const RequestLoadedById(this.booking);

  @override
  List<Object> get props => [booking];
}


class RequestError extends BookingState {
  final String error;

  const RequestError(this.error);

  @override
  List<Object> get props => [error];
}

class RequestPendingLoaded extends BookingState {
  final List<Booking> pendingBookings;

  const RequestPendingLoaded(this.pendingBookings);

  @override
  List<Object> get props => [pendingBookings];
}
