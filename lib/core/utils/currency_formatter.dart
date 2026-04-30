String formatMoney(dynamic value) {
  if (value == null) return '0';

  if (value is num) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }

  final text = value.toString().trim();
  if (text.isEmpty) return '0';

  final parsed = num.tryParse(text);
  if (parsed != null) {
    return parsed % 1 == 0
        ? parsed.toInt().toString()
        : parsed.toStringAsFixed(2);
  }

  final numericPattern = RegExp(r'-?\d+(?:\.\d+)?');
  if (!numericPattern.hasMatch(text)) return text;

  return text.replaceAllMapped(numericPattern, (match) {
    final number = num.tryParse(match.group(0) ?? '');
    if (number == null) return match.group(0)!;

    return number % 1 == 0
        ? number.toInt().toString()
        : number.toStringAsFixed(2);
  });
}
