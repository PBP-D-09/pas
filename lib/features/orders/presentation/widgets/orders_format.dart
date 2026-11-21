/// Format Rupiah seperti di web: 45000 -> "Rp 45.000".
String formatRupiah(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${amount < 0 ? '-' : ''}Rp $buffer';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Format tanggal seperti di web: "20 Nov 2026, 14:05".
String formatOrderDate(DateTime? value) {
  if (value == null) return '';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${value.day} ${_months[value.month - 1]} ${value.year}, '
      '${two(value.hour)}:${two(value.minute)}';
}

/// "20 Nov" untuk label rentang tanggal kustom.
String formatShortDate(DateTime value) =>
    '${value.day} ${_months[value.month - 1]}';
