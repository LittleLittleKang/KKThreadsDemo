//
//  KKThread.swift
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/6/29.
//  Copyright © 2020 看影成痴. All rights reserved.
//

import Foundation


class KKThread: NSObject {
    
    var value: Int = 0
    
    
    @objc func startThread() {
        
        Thread.detachNewThreadSelector(#selector(changeValue), toTarget: self, with: nil)
    }
    
    
    @objc func changeValue() {
        
        print("\(#function), thread:\(Thread.current), value=\(self.value)")
        
        self.value = 5
        
        // 调用主线程
        self.performSelector(onMainThread: #selector(logValue), with: nil, waitUntilDone: false)
    }
    
    
    @objc func logValue() {
        
        print("\(#function), thread:\(Thread.current), value=\(self.value)")
    }
}
