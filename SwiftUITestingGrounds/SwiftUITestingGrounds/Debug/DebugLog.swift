//
//  DebugLog.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 11/7/24.
//

import Foundation

extension Date {
    var display: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

enum DebugLog {
    case line(_: String)
    case obj(_: String, _: Any)
    case error(_: Error)
    case errorWithDesc(_: String, _: Error)
    case url(_: String)
    case any(_: Any)
    case date(_: NSDate)
}

postfix operator /

postfix func / (target: DebugLog?) {
    guard let target = target else { return }

    func log<T>(_ emoji: String, _ string: String = "", _ object: T) {
        #if DEBUG
        print(emoji + "\(string)→" + " " + "\(object)")
        #endif
    }

    switch target {
        case .line(let line):
            log("✏️", Date().display, line)
            
        case .obj(let string, let obj):
            log("📦", string, obj)
            
        case .error(let error):
            log("❗️❗️❗️", "", error)
            
        case .errorWithDesc(let desc, let error):
            log("❗️❗️❗️", desc, error)
            
        case .url(let url):
            log("🔗", "", url)
            
        case .any(let any):
            log("⚪️", "", any)
            
        case .date(let date):
            log("⏰", "", date)
    }
}
