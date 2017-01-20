//
//  SyslogDestination.swift
//  GotYourBackServer
//
//  Created by Charlie Woloszynski on 1/12/17.
//
//

import Dispatch
import Foundation
import libc

open class SyslogDestination: BaseDestination {
    open var logQueue: DispatchQueue? = nil
    
    /// Option: whether or not to output the date the log was created (Always false for this destination)
    open override var showDate: Bool {
        get {
            return false
        }
        set {
            // ignored, syslog adds the date, so we always want showDate to be false in this subclass
        }
    }
    
    var identifierPointer: UnsafeMutablePointer<Int8>
    
    public init(identifier: String) {
        
        // openlog needs access to an const char * value that lasts during the call 
        // but the normal Swift behavior to ensure that the const char * lasts only as
        // long as the function call.  So, we need to create that const char * equivalent 
        // in code
        
        let utf = identifier.utf8
        let length = utf.count
        self.identifierPointer = UnsafeMutablePointer<Int8>.allocate(capacity: length+1)
        let temp = UnsafePointer<Int8>(identifier)

        memcpy(self.identifierPointer, temp, length)
        self.identifierPointer[length] = 0 // zero terminate
        openlog(self.identifierPointer, 0, LOG_USER)
    }
    
    deinit {
        closelog()
    }

    open override func output(logDetails: LogDetails, message: String) {
        
        let outputClosure = {
            var logDetails = logDetails
            var message = message
            
            // Apply filters, if any indicate we should drop the message, we abort before doing the actual logging
            if self.shouldExclude(logDetails: &logDetails, message: &message) {
                return
            }
            
            self.applyFormatters(logDetails: &logDetails, message: &message)
            
            let syslogLevel = self.mappedLevel(logDetails.level)
            withVaList([]) { vsyslog(syslogLevel, message, $0) }
        }
        
        if let logQueue = logQueue {
            logQueue.async(execute: outputClosure)
        }
        else {
            outputClosure()
        }
    }
    
    func mappedLevel(_ level: XCGLogger.Level) -> Int32 {
        switch (level) {
        case .severe: return LOG_ERR
        case .warning: return LOG_WARNING
        case .info: return LOG_INFO
        case .debug: return LOG_DEBUG
        case .verbose: return LOG_DEBUG
        default:
            return LOG_DEBUG
        }
    }

}
