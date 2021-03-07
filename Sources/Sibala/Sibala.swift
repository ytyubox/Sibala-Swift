public enum Sibala {
    public static func game(_ input: String) -> String {
        let parsedPlayerStrings = GameParser.getPlayersStringStructure(gameInput: input)
        let players = parsedPlayerStrings.map(Player.init(APlayerString:))
        let winner = computeWhichPlayerWin(players: players)
        return winner.description
    }

    private static func computeWhichPlayerWin(players: [Player]) -> Winner {
        players.reduce(Player.nullPlayer, max).toWinner
    }
}
