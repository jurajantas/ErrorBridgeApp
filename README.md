# ErrorBridgeApp


 Code for reproducing crash when 'something' is dealocated sooner than it should be.
 This is minimal required code to reproduce the bug, taken from much bigger project.
 DispatchQueue.main.asyncAfter is used to simulate network request.
 
 -[__SwiftNativeNSError release]: message sent to deallocated instance 0x600001442fd0
 
    Project is created in Xcode 14.2, scene management is deleted as we want it to run on iOS12 as well.
    Error only happens on iOS12.x, tested on 12.4 simulator
    Error does not happen on 13.7 simulator and up. Everything there runs as expected.
    remember: if you use 'po' in LLDB console, printed object is retained.
