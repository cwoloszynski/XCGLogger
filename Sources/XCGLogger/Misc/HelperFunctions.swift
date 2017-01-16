//
//  HelperFunctions.swift
//  XCGLogger: https://github.com/DaveWoodCom/XCGLogger
//
//  Created by Dave Wood on 2014-06-06.
//  Copyright © 2014 Dave Wood, Cerebral Gardens.
//  Some rights reserved: https://github.com/DaveWoodCom/XCGLogger/blob/master/LICENSE.txt
//

import Foundation

/// Extract the type name from the given object
///
/// - parameter someObject: the object for which you need the type name
///
/// - returns: the type name of the object
func extractTypeName(_ someObject: Any) -> String {
    return (someObject is Any.Type) ? "\(someObject)" : "\(type(of: someObject))"
}

