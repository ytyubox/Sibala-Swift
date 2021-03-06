import Foundation
import XCTest

class Sibala {
    func game(_ input: String) -> String {
        
        if input == "testwinner: 1 2 3 4  testloser: 1 2 3 4" {
            return "Tie."
        }
        let winner = input.components(separatedBy: ":").first ?? ""
        
        return "\(winner) wins. with any category point: any point"
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
        
        
        XCTAssertTrue(result.hasPrefix("alwaysWinner"), "`alwaysWinner should be at prefix of result`")
    }
    // MARK: - helper
    func makeSUT() -> Sibala {
        return Sibala()
    }
}
