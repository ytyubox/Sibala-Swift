//
/* 
 *		Created by 游宗諭 in 2021/3/7
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
struct Player:Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy < rhs.categroy
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy == rhs.categroy
    }
    
    init<S>(name: S, dices: Dices) where S: StringProtocol {
        self.name = name.description
        self.dices = dices
        self.categroy = Category(dices: dices)
    }
    public init(APlayerString input: String) {
        let splited = input.split(separator: ":")
        assert(splited.count == 2)
        self.init(name: splited[0], dices: Dices(input: splited[1]))
    }
    
    let name: String
    let dices: Dices
    let categroy: Category
    
    struct Dices {
        init(values: [Int]) {
            self.values = values
        }
        
        init<S>(input: S) where S: StringProtocol{
            self.init(
                values: input
                    .components(separatedBy: " ")
                    .compactMap(Int.init))
        }
        let values:[Int]
    }
    
    enum Category{
        private typealias Count = Int
        private static let factorys: [Count:CategoryFactory] =
            [
                1: AllTheSameKindFactory(),
                2: NoPointOrNormalFactory(),
                3: NormalPointFactory(),
                4: NoPointFactory(),
                
            ]
        init(dices: Dices) {
            let group = Dictionary(grouping: dices.values, by: {$0}).mapValues(\.count)
            let factory = Self.factorys[group.count]!
            self = factory.make(group: group)
        }
        
        
        case noPoint
        case normal(point:Int, dominator: Int)
        case allTheSameKind(maxValue: Int)
        
    }
}
protocol CategoryFactory {
    typealias Group = [Int: Int]
    typealias Outpout = Player.Category
    func make(group: Group) -> Outpout
}
struct NoPointFactory:CategoryFactory {
    func make(group: Group) -> Outpout {
        .noPoint
    }
}
struct NoPointOrNormalFactory: CategoryFactory {
    func make(group: Group) -> Outpout {
        assert(group.count == 2)
        if group.allSatisfy({ (k,v) -> Bool in v == 2 }) {
            let max = group.keys.max()!
            return .normal(point: max  * 2, dominator: max)
        }
        else {
            return .noPoint
        }
    }
}
struct AllTheSameKindFactory: CategoryFactory {
    func make(group: Group) -> Outpout {
        .allTheSameKind(maxValue: group.keys.first!)
    }
}
struct NormalPointFactory: CategoryFactory {
    func make(group: Group) -> Outpout {
        let filterGroup =  group
            .filter({k,v in v == 1})
        return .normal(point: filterGroup
                        .reduce(0) {$0 + $1.key},
                       dominator: filterGroup.keys.max()!
        )
    }
}

extension Player.Category: Comparable { }

extension Player.Category:CustomStringConvertible {
    public var description: String {
        switch self {
        case .noPoint:
            return "its a no point, not a winner"
        case .allTheSameKind(maxValue: let maxValue):
            return "all the same kind: \(maxValue)"
        case .normal(point: let point, dominator: _):
            return "normal point: \(point)"
        }
    }
    
}
