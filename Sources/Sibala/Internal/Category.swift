//
/*
 *		Created by 游宗諭 in 2021/3/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import Foundation
extension Player {
    enum Category {
        case noPoint
        case normal(point: Int, dominator: Int)
        case allTheSameKind(maxValue: Int)
    }
}

extension Player.Category: Comparable {}

extension Player.Category: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noPoint:
            return "its a no point, not a winner"
        case let .allTheSameKind(maxValue: maxValue):
            return "all the same kind: \(maxValue)"
        case .normal(point: let point, dominator: _):
            return "normal point: \(point)"
        }
    }
}
