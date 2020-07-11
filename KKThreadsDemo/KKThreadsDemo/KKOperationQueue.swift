//
//  KKOperationQueue.swift
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/7/9.
//  Copyright © 2020 看影成痴. All rights reserved.
//

import Foundation


class KKOperationQueue: NSObject {
    
    @objc func addOperationsToQueue() {
        
        let operationQueue = OperationQueue.init()
            
        // 1 addOperation(_ op: Operation)
        let op1 = BlockOperation.init {
            print("op1, thread:\(Thread.current)")
        }
        operationQueue.addOperation(op1)
        
        
        // 2 addOperations(_ ops: [Operation], waitUntilFinished wait: Bool)
        let op2 = BlockOperation.init {
            print("op2, thread:\(Thread.current)")
        }
        let op3 = BlockOperation.init {
            print("op3, thread:\(Thread.current)")
        }
        let op4 = BlockOperation.init {
            print("op4, thread:\(Thread.current)")
        }
        operationQueue.addOperations([op2, op3, op4], waitUntilFinished: true)
        
        
        // 3 addOperation(_ block: @escaping () -> Void)
        operationQueue.addOperation {
            print("block, thread:\(Thread.current)")
        }
        

        // 4 addBarrierBlock(_ barrier: @escaping () -> Void)
        operationQueue.addBarrierBlock {
            print("barrier, thread:\(Thread.current)")
        }
        
    }
}
