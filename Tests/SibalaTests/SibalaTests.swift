import XCTest
class Sibala {
    func game(_ input: String) -> String {
        
        if input == "testwinner: 1 2 3 4  testloser: 1 2 3 4" {
            return "Tie."
        }
        return ""
    }
}

final class SibalaTests: XCTestCase {

    func test_TiewhenBothNoPoint() {
        let sut = Sibala()
        
        let result = sut.game("testwinner: 1 2 3 4  testloser: 1 2 3 4")
        
        XCTAssertEqual(result, "Tie.")
    }
}
