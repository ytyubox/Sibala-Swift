import Foundation
import XCTest

class Sibala {
    func game(_ input: String) -> String {
        
        let players = input
            .components(separatedBy: "  ")
            .map(Player.init(APlayerString: ))
        let winner = computeForWinner(players: players)
        return winner.description
    }
    private func computeForWinner(players: [Player]) -> Winner {
        players.reduce(NullWinner()) {
            lastWinner, nextPlayer in
            compare(winner: lastWinner, player: nextPlayer)
        }
    }
    private func compare(winner: Winner, player: Player) -> Winner {
        switch true {
        case winner.category == player.categroy:
            return NullWinner()
        case winner.category < player.categroy:
            return Winner(winnerName: player.name, point: player.categroy.getValue(), category: player.categroy)
        default: return winner
        }
    }
}
class Winner: CustomStringConvertible {
    internal init(winnerName: String?, point: Int?, category: Category) {
        self.winnerName = winnerName
        self.point = point
        self.category = category
    }
    
    
    let winnerName: String?
    let point: Int?
    let category: Category
    var description: String {
        "\(winnerName!) wins. \(category.description)"
    }
}
class NullWinner: Winner {
    convenience init() {
        self.init(winnerName:nil, point: nil, category: .noPoint)
    }
    override var description: String {"Tie."}
}

struct Player:Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy.isLess(than: rhs.categroy)
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.categroy == rhs.categroy
    }
    
    internal init<S>(name: S, dices: Dices) where S: StringProtocol {
        self.name = name.description
        self.dices = dices
    }
    init(APlayerString input: String) {
        let splited = input.split(separator: ":")
        assert(splited.count == 2)
        self.init(name: splited[0], dices: Dices(input: splited[1]))
    }
    
    let name: String
    let dices: Dices
    var categroy: Category {
        Category(dices: dices)
    }
}
struct Dices {
    internal init(values: [Int]) {
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

enum Category: Comparable,CustomStringConvertible {
    init(dices: Dices) {
        let group = Dictionary(grouping: dices.values, by: {$0})
        if group.count == dices.values.count {
            self = .noPoint
        } else if group.count == 1 {
            self = .allTheSameKind(maxValue: dices.values.first!)
        } else if group.count == 3 {
            self = .normal(point: group
                            .filter({k,v in v.count == 1})
                            .reduce(0) {$0 + $1.key}
            )
        }else {
            fatalError("dices case not define:\(dices)")
        }
    }
    
    
    case noPoint
    case normal(point:Int)
    case allTheSameKind(maxValue: Int)
    
    func isLess(than other: Category) -> Bool {
        switch (self, other) {
        case (.noPoint, .noPoint): return false
        case (.noPoint, .normal): return false
        case (.noPoint, .allTheSameKind): return false
        case (.normal, .noPoint): return true
        case (.normal, .allTheSameKind): return false
        case (.allTheSameKind, .noPoint): return true
        case (.allTheSameKind, .normal): return true
        case let ( .normal(point: lhs), .normal(point: rhs)): return lhs < rhs
        case let ( .allTheSameKind(maxValue: lhs), .allTheSameKind(maxValue:  rhs)): return lhs < rhs
            
        }
    }
    var description: String {
        switch self {
        case .noPoint:
           return ""
        case .normal(point: let point):
            return "normal point: \(point)"
        case .allTheSameKind(maxValue: let maxValue):
            return "all the same kind: \(maxValue)"
        }
    }
    func getValue() -> Int {
        switch self {
        case .noPoint:
            fatalError("no point have no value")
        case .normal(point: let point):
            return point
        case .allTheSameKind(maxValue: let maxValue):
            return maxValue
        }
    }
}

final class SibalaTests: XCTestCase {
    
    func test_TiewhenBothNoPoint() {
        let sut = makeSUT()
        
        let result = sut.game("testwinner: 1 2 3 4  testloser: 1 2 3 4")
        
        XCTAssertEqual(result, "Tie.")
    }
    
    func test_resultIsPrefixWithWinnerName() {
        let sut = makeSUT()
        let result = sut.game("alwaysWinner: 1 1 3 4  alwaysLoser: 1 2 3 4")
        
        
        XCTAssertTrue(result.hasPrefix("alwaysWinner"), "`alwaysWinner` should be at prefix of result: \(result)")
    }
    
    func test_resultIsSuffixWithWinnerPoint() {
        let sut = makeSUT()
        let result = sut.game("alwaysWinnerWith7Point: 1 1 3 4  alwaysLoser: 1 2 3 4")
        
        XCTAssertEqual(result.last?.isNumber, true, "Should has suffix 7 as winner point in result: \(result)")
    }
    
    
    func test_resultHaswinnerCategoryInTheMiddle() throws {
        let sut = makeSUT()
        let result = sut.game("alwaysWinnerWithNormalPoint: 1 1 3 4  alwaysLoser: 1 2 3 4")
        XCTAssertTrue(result.contains("normal point:"), "Should contain winner category in result: \(result)")
        try AssertResultHasCategoryInTheMiddle(result, category: "normal point")
    }
    
    // MARK: - helper
    private func makeSUT() -> Sibala {
        return Sibala()
    }
    
    private func AssertResultHasCategoryInTheMiddle(_ result: String, category: String) throws {
        let firstIndexOfCategroyInResult = try XCTUnwrap(result.firstIndex(of: category), "category `\(category)` should be in the result: \(result)")
        XCTAssertFalse(result[..<firstIndexOfCategroyInResult].isEmpty,
                       "`category:` should not be at the start")
        
        let nextIndexOfCategoryinResult =  try XCTUnwrap( result.lastIndex(of: "\(category):"))
        XCTAssertFalse(result[nextIndexOfCategoryinResult...].isEmpty,
                       "`category:` should not be at the end")
    }
    
}


private extension StringProtocol {
    func firstIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func lastIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
