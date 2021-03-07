//
/*
 *		Created by 游宗諭 in 2021/3/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import Foundation

extension Player {
    static let nullPlayer = Player(name: "", category: .noPoint)
}

extension Player {
    var toWinner: Winner {
        Winner(winnerName: name, category: categroy)
    }
}

class Winner: CustomStringConvertible {
    init(winnerName: String, category: Player.Category) {
        self.winnerName = winnerName
        self.category = category
    }

    private let winnerName: String
    private let category: Player.Category
    var description: String {
        if category == .noPoint {
            return "Tie."
        }
        return "\(winnerName) wins. \(category.description)"
    }
}
