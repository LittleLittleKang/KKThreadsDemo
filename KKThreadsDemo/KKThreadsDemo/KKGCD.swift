//
//  KKGCD.swift
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/6/30.
//  Copyright © 2020 看影成痴. All rights reserved.
//

import Foundation

class KKGCD: NSObject {
    
    // 同步执行 + 串行队列
    @objc func syncSerial() {
        
        print("start, \(Thread.current)")
        
        // 二选一
//        let queue = DispatchQueue(label: "com.KKThreadsDemo.syncSerialQueue")
        let queue = DispatchQueue(label: "com.KKThreadsDemo.syncConcurrentQueue", attributes: .init(rawValue: 0))
        for i in 0..<5 {
            queue.sync {
                print("\(i), \(Thread.current)")
            }
        }
        
        print("end, \(Thread.current)")
    }
    
    
    // 同步执行 + 并发队列
    @objc func syncConcurrent() {
        
        print("start, \(Thread.current)")
        
        // 二选一
//        let queue = DispatchQueue(label: "com.KKThreadsDemo.syncConcurrentQueue", attributes: .concurrent)
        let queue = DispatchQueue(label: "com.KKThreadsDemo.syncConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none)
        for i in 0..<5 {
            queue.sync {
                print("\(i), \(Thread.current)")
            }
        }
        
        print("end, \(Thread.current)")
    }
    
    
    // 异步执行 + 串行队列
    @objc func asyncSerial() {
        
        print("start, \(Thread.current)")
                
        // 二选一
        let queue = DispatchQueue(label: "com.KKThreadsDemo.asyncSerialQueue")
//        let queue = DispatchQueue(label: "com.KKThreadsDemo.asyncSerialQueue", attributes: .init(rawValue: 0))
        for i in 0..<5 {
            queue.async {
                print("\(i), \(Thread.current)")
            }
        }
        
        print("end, \(Thread.current)")
    }
    
    // 异步执行 + 并发队列
    @objc func asyncConcurrent() {
        
        print("start, \(Thread.current)")
                
        // 二选一
//        let queue = DispatchQueue(label: "com.KKThreadsDemo.asyncConcurrentQueue", attributes: .concurrent)
        let queue = DispatchQueue(label: "com.KKThreadsDemo.asyncConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none)
        for i in 0..<5 {
            queue.async {
                print("\(i), \(Thread.current)")
            }
        }
        
        print("end, \(Thread.current)")
    }
    
    
    // 同步执行 + 主队列
    @objc func syncMain() {
        
        // 在非主线程中使用
        DispatchQueue.global().async {
            
            print("start, \(Thread.current)")

            for i in 0..<5 {
                DispatchQueue.main.sync {
                    print("\(i), \(Thread.current)")
                }
            }
            
            print("end, \(Thread.current)")
        }
    }
    
    
    // 异执行 + 主队列
    @objc func asyncMain() {
        
        // 可在任意线程中使用
        DispatchQueue.global().async {
            
            print("start, \(Thread.current)")

            for i in 0..<5 {
                DispatchQueue.main.async {
                    print("\(i), \(Thread.current)")
                }
            }
            
            print("end, \(Thread.current)")
        }
    }
    
}

