enum Player { player1, player2 }

class Marble {
  final Player player;
  Marble(this.player);

  Marble clone() {
    return Marble(player);
  }

  Map<String, dynamic> toJson() {
    return {
      'player': player == Player.player1 ? 'player1' : 'player2',
    };
  }

  factory Marble.fromJson(Map<String, dynamic> json) {
    return Marble(
      json['player'] == 'player1' ? Player.player1 : Player.player2,
    );
  }
}
