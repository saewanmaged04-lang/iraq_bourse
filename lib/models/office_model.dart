// lib/models/office_model.dart

class StaffMember {
  final String name, phone;
  const StaffMember({required this.name, required this.phone});
}

class OfficeModel {
  final String id, name, city, address, phone, openTime, closeTime, emoji;
  final List<String> services, reviews;
  final List<StaffMember> staff;
  final double rating;
  final int reviewCount;
  final bool isOpen;

  const OfficeModel({
    required this.id, required this.name, required this.city,
    required this.address, required this.phone, required this.openTime,
    required this.closeTime, required this.services, required this.rating,
    required this.reviewCount, required this.isOpen, required this.emoji,
    required this.reviews, required this.staff,
  });
}

// --- زانیاری نوسینگەکان ---
final List<OfficeModel> allOffices = [
  const OfficeModel(
    id: '1', name: 'نوسینگەی ڕاستگۆ', city: 'سلێمانی', address: 'شەقامی مەولەوی', phone: '07701234567',
    openTime: '08:00', closeTime: '18:00', emoji: '🏢', services: ['حەوالە', 'کڕین و فرۆشتن'],
    rating: 4.8, reviewCount: 120, isOpen: true, reviews: ['باشترین مامەڵە', 'خێرا و جێی متمانە'],
    staff: [
      StaffMember(name: 'ئاوات سدیق', phone: '07701234567'),
      StaffMember(name: 'هیوا کەریم', phone: '07709876543'),
    ],
  ),
  const OfficeModel(
    id: '2', name: 'کۆمپانیای بازاڕی ناوەندی', city: 'هەولێر', address: 'بەرامبەر قەڵا', phone: '07501234567',
    openTime: '09:00', closeTime: '17:00', emoji: '🏛️', services: ['کڕین و فرۆشتن', 'گۆڕینەوەی خێرا'],
    rating: 4.5, reviewCount: 85, isOpen: true, reviews: ['نرخیان زۆر گونجاوە'],
    staff: [
      StaffMember(name: 'سۆران ڕەشید', phone: '07501234567'),
      StaffMember(name: 'دیلان عەزیز', phone: '07507654321'),
    ],
  ),
];