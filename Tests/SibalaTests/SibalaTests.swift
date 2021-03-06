import Foundation
import XCTest

class Sibala {
    func game(_ input: String) -> String {
        
        if input == "testwinner: 1 2 3 4  testloser: 1 2 3 4" {
            return "Tie."
        }
        let winner = input.components(separatedBy: ":").first ?? ""
        
        return "\(winner) wins. with normal point: 7"
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
    
    func test_resultIsSuffixWithWinnerPoint() {
        let sut = makeSUT()
        let result = sut.game("alwaysWinnerWith7Point: 1 1 3 4  alwaysLoser: 1 2 3 4")
        
        XCTAssertTrue(result.hasSuffix("7"), "result should has suffix 7 as winner point")
    }
    
    
    func test_resultHaswinnerCategoryInTheMiddle() throws {
        let sut = makeSUT()
        let result = sut.game("alwaysWinnerWithNormalPoint: 1 1 3 4  alwaysLoser: 1 2 3 4")
        XCTAssertTrue(result.contains("normal point:"), "result should contain winner category")
        try AssertResultHasCategoryInTheMiddle(result, category: "normal point")
    }
    
    // MARK: - helper
    private func makeSUT() -> Sibala {
        return Sibala()
    }
    
    private func AssertResultHasCategoryInTheMiddle(_ result: String, category: String) throws {
        let firstIndexOfCategroyInResult = try XCTUnwrap(result.firstIndex(of: category))
        XCTAssertFalse(result[..<firstIndexOfCategroyInResult].isEmpty,
                       "`category:` should not be at the start")
        
        let nextIndexOfCategoryinResult =  try XCTUnwrap( result.lastIndex(of: "\(category):", options: .literal))
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
