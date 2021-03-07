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
        self.categroy = CategroyFactory(dices: dices)
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
    
}
