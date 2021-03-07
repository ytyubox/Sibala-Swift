public enum Sibala {
    public static func game(_ input: String) -> String {
        let players =
            GameParser
            .getPlayersStringStructure(gameInput: input)
            .map(Player.init(APlayerString:))
        let winner = computeWhichPlayerWin(players: players)
        return winner.toWinner.description
    }

    private static func computeWhichPlayerWin(players: [Player]) -> Player {
        players.reduce(Player.nullPlayer, max)
    }
}
