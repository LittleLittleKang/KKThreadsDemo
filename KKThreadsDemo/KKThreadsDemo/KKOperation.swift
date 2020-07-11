//
//  KKOperation.swift
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/7/2.
//  Copyright © 2020 看影成痴. All rights reserved.
//

import Foundation


class KKOperation: NSObject {
    
    //MARK: - 使用 BlockOperation (block)

    @objc func useBlockOperation() {
        
        let operation = BlockOperation.init {
            print("\(#function), thread:\(Thread.current)")
        }
        operation.start()
    }
        
    //---------------------------------------------------------------------------------------------------
    //log:
    //useBlockOperation(), thread:<NSThread: 0x600003f78000>{number = 1, name = main}
        

    //MARK: - 使用 自定义Operation (重写main)
    @objc func useCustomOperation() {
        
        let operation = CustomOperation.init()
        operation.start()
    }
        
    //---------------------------------------------------------------------------------------------------
    //log:
    //main(), thread:<NSThread: 0x600003ec8cc0>{number = 1, name = main}
}


class CustomOperation: Operation {
    
    override func main() {
        print("\(#function), thread:\(Thread.current)")
    }
}



