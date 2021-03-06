import Sibala
import XCTest

final class SibalaTests: XCTestCase {
    
    func test_TiewhenBothNoPoint() {
        let sut = makeSUT(input: "testwinner: 1 2 3 4  testloser: 1 2 3 4")
        
        XCTAssertEqual(sut, "Tie.")
    }
    
    func test_AmyWinWhenBothNormal() {
        let sut = makeSUT(input: "Amy: 2 2 4 1  Lin:3 3 2 1")
        
        XCTAssertEqual(sut, "Amy wins. normal point: 5")
    }
    
    func test_LinWinWhenBothNormal() {
        let sut = makeSUT(input: "Amy:3 3 2 1  Lin:2 2 4 1")
        
        XCTAssertEqual(sut, "Lin wins. normal point: 5")
    }
    
    func test_AmyWinWhenBothNormalWithTwoPair() {
        let sut = makeSUT(input: "Amy: 2 2 3 3  Lin:1 1 2 2")
        
        XCTAssertEqual(sut, "Amy wins. normal point: 6")
    }
    
    func test_LinWinWhenBothNormalWthTwoPair() {
        let sut = makeSUT(input: "Amy: 2 2 1 1  Lin:3 3 2 2")

        XCTAssertEqual(sut, "Lin wins. normal point: 6")
    }
    
    func test_AmyWinWhenItsCateroyIsAllButTheOtherIsNormal() {
        let sut = makeSUT(input: "Amy: 3 3 3 3  Lin:1 1 2 2")
        
        XCTAssertEqual(sut, "Amy wins. all the same kind: 3")
    }
    
    func test_LinWinWhenItsCateroyIsAllButTheOtherIsNormal() {
        let sut = makeSUT(input: "Amy: 2 2 1 1  Lin:3 3 3 3")

        XCTAssertEqual(sut, "Lin wins. all the same kind: 3")
    }

    func test_AmyWinWhenBothNomalWithSamePointButBiggerValue() {
        let sut = makeSUT(input: "Amy: 2 2 1 6  Lin:6 6 3 4")
        
        XCTAssertEqual(sut, "Amy wins. normal point: 7")
    }
    
    func test_LinWinWhenBothNomalWithSamePointButBiggerValue() {
        let sut = makeSUT(input: "Amy: 6 6 3 4  Lin:2 2 1 6")

        XCTAssertEqual(sut, "Lin wins. normal point: 7")
    }
    func test_BothNoPointSinceItAllHaveTheSameDice3Times() {
        let sut = makeSUT(input: "Amy: 3 3 3 4  Lin:2 2 2 6")

        XCTAssertEqual(sut, "Tie.")
        
    }

    func test_resultIsPrefixWithWinnerName() {
        let sut = makeSUT(input: "alwaysWinner: 1 1 3 4  alwaysLoser: 1 2 3 4")
        
        
        XCTAssertTrue(sut.hasPrefix("alwaysWinner"), "`alwaysWinner` should be at prefix of result: \(sut)")
    }
    
    func test_resultIsSuffixWithWinnerPoint() {
        let sut = makeSUT(input:"alwaysWinnerWith7Point: 1 1 3 4  alwaysLoser: 1 2 3 4")
        
        XCTAssertEqual(sut.last?.isNumber, true, "Should has suffix 7 as winner point in result: \(sut)")
    }
    
    
    func test_resultHaswinnerCategoryInTheMiddle() throws {
        let sut = makeSUT(input: "alwaysWinnerWithNormalPoint: 1 1 3 4  alwaysLoser: 1 2 3 4")
        XCTAssertTrue(sut.contains("normal point:"), "Should contain winner category in result: \(sut)")
        try AssertResultHasCategoryInTheMiddle(sut, category: "normal point")
    }
    
    // MARK: - helper
    private func makeSUT(input: String) -> String {
        return Sibala.game(input)
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
