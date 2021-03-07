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
    
    init<S>(name: S, dices: Dices) where S: StringProtocol {
        self.name = name.description
        self.categroy = CategroyFactory(dices: dices)
    }
    public init(APlayerString input: String) {
        let splited = input.split(separator: ":")
        assert(splited.count == 2)
        let (name, dicesString) = (splited[0], splited[1])
        self.init(
            name: name,
            dices: Dices(input: dicesString))
    }
}

struct Dices {
    init(values: [Int]) {
        self.values = values
    }
    
    init<S>(input: S) where S: StringProtocol{
        let list = input
            .components(separatedBy: " ")
            .compactMap(Int.init)
        assert(list.count == 4)
        self.init( values: list) 
    }
    let values:[Int]
}

extension Player: Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy < rhs.categroy
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy == rhs.categroy
    }
}
