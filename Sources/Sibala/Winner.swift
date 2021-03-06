//
/* 
 *		Created by 游宗諭 in 2021/3/7
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
class Winner: CustomStringConvertible {
    init(winnerName: String?, category: Category) {
        self.winnerName = winnerName
        self.category = category
    }
    
    
    let winnerName: String?
    let category: Category
    var description: String {
        "\(winnerName!) wins. \(category.description)"
    }
}
class NullWinner: Winner {
    convenience init() {
        self.init(winnerName:nil, category: .noPoint)
    }
    override var description: String {"Tie."}
}
