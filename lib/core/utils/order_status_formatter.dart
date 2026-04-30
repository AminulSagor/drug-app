String orderStatusShowingAs(String status) {
  final normalized = normalizeOrderStatus(status);

  switch (normalized) {
    case 'pending':
      return 'pending';
    case 'canceled':
    case 'cancelled':
      return 'canceled';
    case 'confirmed':
      return 'confirmed';
    case 'delivered':
      return 'delivered';
    case 'processing':
      return 'processing';
    case 'ready_for_pickup':
    case 'readyforpickup':
      return 'packed';
    case 'on_way':
    case 'onway':
    case 'on_delivery':
      return 'on way';
    case 'returned':
      return 'returned';
    default:
      return normalized.replaceAll('_', ' ');
  }
}

String normalizeOrderStatus(String status) {
  return status.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}
