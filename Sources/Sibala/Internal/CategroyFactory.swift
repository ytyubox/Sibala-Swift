//
/*
 *		Created by 游宗諭 in 2021/3/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import Foundation
typealias Count = Int
private let setOfDiceCountToFactorys: [Count: _CategoryFactory] =
    [
        1: AllTheSameKindFactory(),
        2: NoPointOrNormalFactory(),
        3: NormalPointFactory(),
        4: NoPointFactory(),
    ]

func CategroyFactory(dices: Dices) -> Player.Category {
    let group = Dictionary(grouping: dices.values, by: { $0 }).mapValues(\.count)
    let factory = setOfDiceCountToFactorys[group.count]!
    return factory.make(group: group)
}

private protocol _CategoryFactory {
    typealias Group = [Int: Int]
    typealias Outpout = Player.Category
    func make(group: Group) -> Outpout
}

private struct NoPointFactory: _CategoryFactory {
    func make(group: Group) -> Outpout {
        assert(group.count == 4)
        return .noPoint
    }
}

private struct NoPointOrNormalFactory: _CategoryFactory {
    func make(group: Group) -> Outpout {
        assert(group.count == 2)
        if group.allSatisfy({ (_, v) -> Bool in v == 2 }) {
            let max = group.keys.max()!
            return .normal(point: max * 2, dominator: max)
        } else {
            return .noPoint
        }
    }
}

private struct NormalPointFactory: _CategoryFactory {
    func make(group: Group) -> Outpout {
        assert(group.count == 3)
        let filterGroup = group
            .filter { _, v in v == 1 }
        return .normal(point: filterGroup
            .reduce(0) { $0 + $1.key },
            dominator: filterGroup.keys.max()!)
    }
}

private struct AllTheSameKindFactory: _CategoryFactory {
    func make(group: Group) -> Outpout {
        assert(group.count == 1)
        return .allTheSameKind(maxValue: group.keys.first!)
    }
}
