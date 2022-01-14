//
//  Logger.swift
//  ShareLogs
//
//  Created by Nitin Aggarwal on 14/01/22.
//

import UIKit
import CocoaLumberjackSwift

var Log: Logger { Logger.shared }

class Logger: NSObject {
    
    // MARK: - Properties
    static let shared = Logger()
    private static let logEnabled = true
    
    enum LogLevel: String {
        case verbose = "[VERBOSE 📋]"
        case info = "[INFO ℹ️]"
        case warn = "[WARN ⚠️]"
        case error = "[ERROR 🔴]"
        case debug = "[DEBUG 🐛]"
    }
    
    let fileLogger: DDFileLogger = {
        let logger = DDFileLogger()
        logger.rollingFrequency = 60 * 60 * 24 // 24 hours
        logger.logFileManager.maximumNumberOfLogFiles = 7
        logger.logFormatter = LogFormatter.shared
        logger.maximumFileSize = 1024 * 1024 // 1 MB
        return logger
    }()
    
    
    // MARK: - Initializer
    override init() {
        super.init()
        
        // Add OS Logger
        DDOSLogger.sharedInstance.logFormatter = LogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)
        
        /*
         These tie into the log level just as you would expect
         If you set the log level to DDLogLevelError, then you will only see Error statements.
         If you set the log level to DDLogLevelWarn, then you will only see Error and Warn statements.
         If you set the log level to DDLogLevelInfo, you'll see Error, Warn and Info statements.
         If you set the log level to DDLogLevelDebug, you'll see Error, Warn, Info and Debug statements.
         If you set the log level to DDLogLevelVerbose, you'll see all DDLog statements.
         If you set the log level to DDLogLevelOff, you won't see any DDLog statements.
         ref: https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/GettingStarted.md
         */
        DDLog.add(fileLogger, with: .info)
    }
    
    
    // MARK: - Methods
    func p(_ object: Any, type: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        if Logger.logEnabled {
            let loggedMessage = "[\((file as NSString).lastPathComponent)(\(function): \(line)]  \(type.rawValue) \(object)"
            switch type {
            case .info: DDLogInfo(loggedMessage)
            case .error: DDLogError(loggedMessage)
            case .verbose: DDLogVerbose(loggedMessage)
            case .warn: DDLogWarn(loggedMessage)
            case .debug: DDLogDebug(loggedMessage)
            }
        }
    }
}

// MARK: - Networking Logs
extension Logger {
    
    func logStartRequest(_ request: URLRequest) {
        let body = request.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "Nil"
        let requestUrl = request.url?.absoluteString ?? "Nil"
        let networkRequest = """
            ⚡️⚡️⚡️⚡️ REQUEST ⚡️⚡️⚡️⚡️
            ⚡️⚡️⚡️⚡️ URL -> \(requestUrl)
            ⚡️⚡️⚡️⚡️ METHOD -> \(String(describing: request.httpMethod))
            ⚡️⚡️⚡️⚡️ BODY -> \(body)
            ⚡️⚡️⚡️⚡️ HEADERS -> \(String(describing: request.allHTTPHeaderFields))
            ⚡️⚡️⚡️⚡️ ---------------------- ⚡️⚡️⚡️⚡️
        """
        Log.p(networkRequest, type: .info)
    }
    
    func logEndRequest(_ response: URLResponse?, data: Data?, error: Error?) {
        var statusCode = 0
        if let httpUrlResponse = response as? HTTPURLResponse {
            statusCode = httpUrlResponse.statusCode
        }
        
        let networkResponse = """
        ⚡️⚡️⚡️⚡️ RESPONSE ⚡️⚡️⚡️⚡️
        ⚡️⚡️⚡️⚡️ URL -> \(response?.url?.absoluteString ?? "NIL")
        ⚡️⚡️⚡️⚡️ STATUS CODE -> \(statusCode)
        ⚡️⚡️⚡️⚡️ DATA -> \(data?.dictionary ?? [:])
        ⚡️⚡️⚡️⚡️ ERROR -> \(String(describing: error))
        ⚡️⚡️⚡️⚡️ ---------------------- ⚡️⚡️⚡️⚡️
    """
        Log.p(networkResponse, type: .info)
    }
}


// MARK: - Supported Class
class LogFormatter: NSObject, DDLogFormatter {
    
    static let shared = LogFormatter()
    
    func format(message logMessage: DDLogMessage) -> String? {
        logMessage.message
    }
}

extension Data {
    
    var dictionary: [String: Any]? {
        do {
            let responseData = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
            return responseData
        } catch {
            return nil
        }
    }
}
