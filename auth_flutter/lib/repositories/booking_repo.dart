import 'package:auth_flutter/models/booking_model.dart';

abstract class BookingRepo {
  Future<List<Booking>> getAllBooking();
  Future<Booking> getBookingById(String id);
  Future<Booking> acceptBooking(String id);
  Future<Booking> rejectBooking(String id);
  Future<List<Booking>> getAllPendingBooking();
}
