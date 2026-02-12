class ContestData {
  final String title;
  final int coins;
  final String type;
  final double prizePool;
  final String entryFees;
  final int joined;
  final int totalSpots;

  ContestData({
    required this.title,
    required this.coins,
    required this.type,
    required this.prizePool,
    required this.entryFees,
    required this.joined,
    required this.totalSpots,
  });
}

class gridData {
  final String stockName;

  final String fieldName;
  final String price;
  final String stockCount;

  gridData({
    required this.stockName,
    required this.fieldName,
    required this.price,
    required this.stockCount,
  });
}
