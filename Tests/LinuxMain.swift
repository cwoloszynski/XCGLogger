#if os(Linux)

import XCTest
@testable import XCGLoggerTests

XCTMain([
    testCase(XCGLoggerTests.allTests),
])

#endif
