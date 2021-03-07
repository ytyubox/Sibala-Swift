//
/*
 *		Created by 游宗諭 in 2021/3/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import Foundation
struct Player {
    let name: String
    let categroy: Category
    init<S>(name: S, category: Category) where S: StringProtocol {
        self.name = name.description
        categroy = category
    }

    init<S>(name: S, dices: Dices) where S: StringProtocol {
        self.init(name: name, category: CategroyFactory(dices: dices))
    }

    public init(APlayerString input: GameParser.AplayerInputStructure) {
        let (name, dicesString) = input
        self.init(
            name: name,
            dices: Dices(input: dicesString)
        )
    }
}

struct Dices {
    init(values: [Int]) {
        self.values = values
    }

    init<S>(input: S) where S: StringProtocol {
        let list = input.compactMap {
            Int($0.description)
        }
        assert(list.count == 4)
        self.init(values: list)
    }

    let values: [Int]
}

extension Player: Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy < rhs.categroy
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy == rhs.categroy
    }
}
