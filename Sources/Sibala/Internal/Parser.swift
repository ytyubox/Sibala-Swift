//
/* 
 *		Created by 游宗諭 in 2021/3/7
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
enum GameParser {
    private static let KPLAYER_SEPARATOR = "  "
    private static let KPLAYER_NAMESEPARATOR = ":"
    private static let KPLAYER_DICESEPARATOR:Character = " "
    typealias APlayerInputFormat = String
    typealias AplayerInputStructure = (name: String, dices: String)
    static func getPlayersStringStructure(gameInput input: String) -> [AplayerInputStructure] {
        getPlayersStringArray(fromgameInput: input)
            .map(getAPlayerStringStructure(aplayerInput:))
    }
    private static func getPlayersStringArray(fromgameInput input: String) -> [APlayerInputFormat] {
        input.components(separatedBy: KPLAYER_SEPARATOR)
    }
    private static func getAPlayerStringStructure(aplayerInput input: APlayerInputFormat) -> AplayerInputStructure {
        let components = input.components(separatedBy: KPLAYER_NAMESEPARATOR)
        assert(components.count == 2)
        let (name, originDices) = (components[0], components[1])
        let dices = originDices.filter{$0 != KPLAYER_DICESEPARATOR}
        return (name: name, dices)
        
    }
}
