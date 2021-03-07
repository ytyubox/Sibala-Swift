public enum Sibala {
    public static func game(_ input: String) -> String {
        let players =
            GameParser
            .getPlayersStringStructure(gameInput: input)
            .map(Player.init(APlayerString:))
        let winner = computeForWinner(players: players)
        return winner.description
    }

    private static func computeForWinner(players: [Player]) -> Winner {
        players.reduce(NullWinner()) {
            lastWinner, nextPlayer in
            compare(winner: lastWinner, player: nextPlayer)
        }
    }

    private static func compare(winner: Winner, player: Player) -> Winner {
        switch true {
        case winner.category == player.categroy:
            return NullWinner()
        case winner.category < player.categroy:
            return Winner(
                winnerName: player.name,
                category: player.categroy
            )
        default: return winner
        }
    }
}
