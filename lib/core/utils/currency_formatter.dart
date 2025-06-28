class CurrencyFormatter {
  static String format(double amount, String currency) {
    try {
      String formattedAmount = amount.toStringAsFixed(0);
      switch (currency) {
        case 'RUB':
          return '$formattedAmount ₽';
        case 'USD':
          return '\$$formattedAmount';
        case 'EUR':
          return '$formattedAmount €';
        default:
          return '$formattedAmount $currency';
      }
    } catch (e) {
      return '$amount $currency';
    }
  }
}
