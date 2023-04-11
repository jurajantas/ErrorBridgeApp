//
//  ViewController.swift
//  ErrorBridgeApp
//
//  Created by Juraj Antas on 05/04/2023.
//

/*
 Code for reproducing crash when 'something' is dealocated sooner than it should be.
 This is minimal required code to reproduce the bug, taken from much bigger project.
 DispatchQueue.main.asyncAfter is used to simulate network request.
 
 -[__SwiftNativeNSError release]: message sent to deallocated instance 0x600001442fd0
 
    Project is created in Xcode 14.2, scene management is deleted as we want it to run on iOS12 as well.
    Error only happens on iOS12.x, tested on 12.4 simulator
    Error does not happen on 13.7 simulator and up. Everything there runs as expected.
    remember: if you use 'po' in LLDB console, printed object is retained.
*/

import UIKit

struct AuthError: LocalizedError {
    var localizedDescription: String { "unauthorized" }
}

enum NetworkError: LocalizedError {
    case noInternet
    case unknown
    
    public static func error(from error: NSError?) -> NetworkError {
        //this 'error as? NetworkError' is causing release, retain count goes to 0, object is deleted and later used, resulting in crash. But why?
        if let customError = error as? NetworkError {
            return customError
        }
        
        return .unknown
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        giveMeSomeResult { result in
            switch result {
            case .success(let success):
                print("\(success)")
            case .failure(let failure):
                _ = NetworkError.error(from: failure as NSError)
                print("\(failure)")
            }
        }
    }
    
    func giveMeSomeResult(completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            completion( .failure( AuthError() ) )
        }
    }

}

