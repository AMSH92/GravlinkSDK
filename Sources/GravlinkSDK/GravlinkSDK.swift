// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GravlinkSDK

public struct SDK {
    private static var isAPIKeyValid = false
    
  
    public static func configure(apiKey: String) {
        
    }
    
    private static func checkAPIKey() -> Bool {
        if !isAPIKeyValid {
            print("Please Provide API KEY")
        }
        return isAPIKeyValid
    }
    
    public static func start() {
        guard checkAPIKey() else {return}
        print("Hello WORLD")
    }
    
    
}
