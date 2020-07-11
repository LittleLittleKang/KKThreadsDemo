//
//  ViewController.m
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/6/29.
//  Copyright © 2020 看影成痴. All rights reserved.
//

#import "ViewController.h"
#import "KKThreadsDemo-Swift.h"
#import "MyOperation.h"
#import <pthread.h>

@interface ViewController () {
    
    pthread_t       m_threadID;
}

@property (nonatomic, assign)   int value;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* ------ Thread ------ */
    
//    KKThread *thread = [[KKThread alloc] init];
    
//    [self startThread];
//    [thread startThread];
    
    
    /* ------ GCD ------ */
    
//    KKGCD *swiftGcd = [[KKGCD alloc] init];
    
//    [self syncSerial];
//    [swiftGcd syncSerial];
    
//    [self syncConcurrent];
//    [swiftGcd syncConcurrent];
    
//    [self asyncSerial];
//    [swiftGcd asyncSerial];
    
//    [self asyncConcurrent];
//    [swiftGcd asyncConcurrent];
    
//    [self syncMain];
//    [swiftGcd syncMain];
    
//    [self asyncMain];
//    [swiftGcd asyncMain];
    
//    [self deadlock];
    
    
    /* ------ Operation ------ */
//    KKOperation *swiftOperation = [[KKOperation alloc] init];
    
//    [self useInvocationOperation];
    
//    [self useBlockOperation];
//    [swiftOperation useBlockOperation];
    
//    [self useCustomOperation];
//    [swiftOperation useCustomOperation];
    
//    // 异步执行
//    [self asyncOperation];
    
    
    /* ------ OperationQueue ------ */

//    KKOperationQueue *swiftOperationQueue = [[KKOperationQueue alloc] init];
    
    // 添加任务到队列
//    [self addOperationsToQueue];
//    [swiftOperationQueue addOperationsToQueue];
    
    // 设置maxConcurrentOperationCount
//    [self setOperationCount];
    
//    [self callMainQueue];
    
    
    /* ------ Pthreads ------ */
    
    // 创建线程
//    [self createPthread];
//    sleep(1);
//    // 手动取消线程
//    [self cancelThread];
    
    // 线程同步
//    [self syncPthread];
}

- (void)startThread {
    
    [NSThread detachNewThreadSelector:@selector(changeValue) toTarget:self withObject:nil];
}


- (void)changeValue {
    
    NSLog(@"%s thread:%@, value=%d", __func__, [NSThread currentThread], self.value);
    
    self.value = 10;
        
    // 调用主线程
    [self performSelectorOnMainThread:@selector(logValue) withObject:nil waitUntilDone:NO];
}


- (void)logValue {
    
    NSLog(@"%s thread:%@, value=%d", __func__, [NSThread currentThread], self.value);
}


// 同步执行 + 串行队列
- (void)syncSerial {
    
    NSLog(@"start, %@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.KKThreadsDemo.syncSerialQueue", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<5; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d, %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"end, %@", [NSThread currentThread]);
}


// 同步执行 + 并发队列
- (void)syncConcurrent {
    
    NSLog(@"start, %@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.KKThreadsDemo.syncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<5; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d, %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"end, %@", [NSThread currentThread]);
}


// 异步执行 + 串行队列
- (void)asyncSerial {
    
#if 0
    NSLog(@"start, %@", [NSThread currentThread]);

    dispatch_queue_t queue = dispatch_queue_create("com.KKThreadsDemo.asyncSerialQueue", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d, %@", i, [NSThread currentThread]);
        });
    }

    NSLog(@"end, %@", [NSThread currentThread]);
    
#else
    
    /* ------ 如果添加到当前线程对应的队列, 则不开启新线程 ------ */
    dispatch_queue_t queue = dispatch_queue_create("com.KKThreadsDemo.asyncSerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        NSLog(@"start, %@", [NSThread currentThread]);
        
        for (int i=0; i<5; i++) {
            dispatch_async(queue, ^{
                NSLog(@"%d, %@", i, [NSThread currentThread]);
            });
        }
        
        NSLog(@"end, %@", [NSThread currentThread]);
    });
#endif
}


// 异步执行 + 并发队列
- (void)asyncConcurrent {
    
    NSLog(@"start, %@", [NSThread currentThread]);

    dispatch_queue_t queue = dispatch_queue_create("com.KKThreadsDemo.asyncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d, %@", i, [NSThread currentThread]);
        });
    }

    NSLog(@"end, %@", [NSThread currentThread]);
}


// 同步执行 + 主队列
- (void)syncMain {
    
    // 在非主线程中使用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start, %@", [NSThread currentThread]);

        for (int i=0; i<5; i++) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%d, %@", i, [NSThread currentThread]);
            });
        }

        NSLog(@"end, %@", [NSThread currentThread]);
    });
}


// 异步执行 + 主队列
- (void)asyncMain {
    
    // 可在任意线程中使用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start, %@", [NSThread currentThread]);

        for (int i=0; i<5; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%d, %@", i, [NSThread currentThread]);
            });
        }

        NSLog(@"end, %@", [NSThread currentThread]);
    });
}


// 死锁 (主线程里调用)
- (void)deadlock {
    
    // 死锁1
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    

    // 死锁2
    dispatch_queue_t queue2 = dispatch_queue_create("com.KKThreadsDemo.deadlockQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue2, ^{

        NSLog(@"start, %@", [NSThread currentThread]);

        dispatch_sync(queue2, ^{
            NSLog(@"1, %@", [NSThread currentThread]);
        });

        NSLog(@"end, %@", [NSThread currentThread]);
    });
    
    
    // 死锁3
    dispatch_queue_t queue3 = dispatch_queue_create("com.KKThreadsDemo.deadlockQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue3, ^{

        NSLog(@"start, %@", [NSThread currentThread]);

        dispatch_sync(dispatch_get_main_queue(), ^{

            NSLog(@"1, %@", [NSThread currentThread]);

            dispatch_sync(queue3, ^{
                NSLog(@"2, %@", [NSThread currentThread]);
            });
        });

        NSLog(@"end, %@", [NSThread currentThread]);
    });
    
    
    // 死锁4
    dispatch_queue_t queue4 = dispatch_queue_create("com.KKThreadsDemo.deadlockQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue4, ^{

        NSLog(@"start, %@", [NSThread currentThread]);

        dispatch_barrier_sync(queue4, ^{
            NSLog(@"1 %@", [NSThread currentThread]);
        });
        
        NSLog(@"end %@", [NSThread currentThread]);
    });
}


#pragma mark - NSInvocationOperation

// 使用 NSInvocationOperation
- (void)useInvocationOperation {
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doInvocationOperation) object:nil];
    [operation start];
}

// 任务
- (void)doInvocationOperation {
    
    NSLog(@"%s, thread:%@", __func__, [NSThread currentThread]);
}

//---------------------------------------------------------------------------------------------------
//log:
//-[ViewController doInvocationOperation], thread:<NSThread: 0x6000017ec2c0>{number = 1, name = main}


#pragma mark - NSBlockOperation

// 使用 NSBlockOperation
- (void)useBlockOperation {
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"%s, thread:%@", __func__, [NSThread currentThread]);
    }];
    
    [operation start];
}

//---------------------------------------------------------------------------------------------------
//log:
//-[ViewController useBlockOperation]_block_invoke, thread:<NSThread: 0x600000760100>{number = 1, name = main}


#pragma mark - 自定义Operation

- (void)useCustomOperation {
    
    MyOperation *operation = [[MyOperation alloc] init];
    [operation start];
}

//---------------------------------------------------------------------------------------------------
//log:
//-[MyOperation main], thread:<NSThread: 0x600000618280>{number = 1, name = main}


#pragma mark - 异步执行

- (void)asyncOperation {
    
    MyOperation *operation = [[MyOperation alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [operation start];
    });
    
    [operation waitUntilFinished];
    
    NSLog(@"isExecuting:%d", operation.isExecuting);
}

//---------------------------------------------------------------------------------------------------

//log:
//1, -[MyOperation main], thread:<NSThread: 0x600002340b00>{number = 6, name = (null)}
//isExecuting:0
//2, -[MyOperation main], thread:<NSThread: 0x600002340b00>{number = 6, name = (null)}


#pragma mark - 添加任务到队列

- (void)addOperationsToQueue {
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    // 1 addOperation:
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1 thread:%@", [NSThread currentThread]);
    }] ;
    [operationQueue addOperation:op1];

    // 2 addOperations:waitUntilFinished:
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2 thread:%@", [NSThread currentThread]);
    }] ;
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3 thread:%@", [NSThread currentThread]);
    }] ;
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op4 thread:%@", [NSThread currentThread]);
    }] ;
    [operationQueue addOperations:@[op2, op3, op4] waitUntilFinished:YES];
    NSLog(@"queue finished");

    // 3 addOperationWithBlock:
    [operationQueue addOperationWithBlock:^{
        NSLog(@"block thread:%@", [NSThread currentThread]);
    }];

    // 4 addBarrierBlock:
    [operationQueue addBarrierBlock:^{
        NSLog(@"barrier thread:%@", [NSThread currentThread]);
    }];

//---------------------------------------------------------------------------------------------------
//log:
//op2 thread:<NSThread: 0x600002ec7c80>{number = 6, name = (null)}
//op4 thread:<NSThread: 0x600002eaf180>{number = 4, name = (null)}
//op1 thread:<NSThread: 0x600002ed77c0>{number = 5, name = (null)}
//op3 thread:<NSThread: 0x600002eaf140>{number = 3, name = (null)}
//queue finished
//block thread:<NSThread: 0x600002ec7c80>{number = 6, name = (null)}
}


#pragma mark - 设置maxConcurrentOperationCount

- (void)setOperationCount {
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    NSLog(@"start");
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1 thread:%@", [NSThread currentThread]);
    }] ;
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2 thread:%@", [NSThread currentThread]);
    }] ;
    
    [op1 addDependency:op2];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3 thread:%@", [NSThread currentThread]);
    }] ;
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op4 thread:%@", [NSThread currentThread]);
    }] ;
    
    /**
     -1, 默认值, 并发队列;
     =0, 不执行任何操作;
     =1, 串行队列;
     <0, 除-1默认值外, 其他负值均报错;
     >1, 并发队列, 如果数值过大, 最终并发数由系统决定.
     */
    operationQueue.maxConcurrentOperationCount = 1;
    [operationQueue addOperations:@[op1, op2, op3, op4] waitUntilFinished:YES];
    
    NSLog(@"end");
}


#pragma mark - 线程间通信

- (void)callMainQueue {
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [operationQueue addOperationWithBlock:^{
        
        NSLog(@"block, thread:%@", [NSThread currentThread]);
        
        // call main queue
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            
            NSLog(@"main, thread:%@", [NSThread currentThread]);
        }];
    }];
}


#pragma mark - Pthreads

// 创建线程
- (void)createPthread {
    
    /**
     参数1: 线程ID
     参数2: 线程属性, 一般为NULL
     参数3: 新线程入口函数
     参数4: 入口函数的参数
     */
    int ret = pthread_create(&m_threadID, NULL, myThread, NULL);
    if (ret != 0) {
        NSLog(@"!!! 创建失败 err:%d", ret);
        return;
    }
    
    // 分离线程 (自动管理资源)
    pthread_detach(m_threadID);
}


// 线程入口函数
void *myThread(void *param)
{
    NSLog(@"1, %s, thread:%@", __func__, [NSThread currentThread]);
    
    sleep(3);
    
    NSLog(@"2, %s, thread:%@", __func__, [NSThread currentThread]);
    
//    pthread_exit(NULL);   // 这里作用与return差不多
    return NULL;
}


// 取消线程
- (void)cancelThread {
    
    pthread_cancel(m_threadID);     // 取消线程
//    pthread_join(m_threadID, NULL); // 如已分离线程则不需此步骤
}


#pragma mark - Pthread线程同步


pthread_mutex_t m_mutex;    // 互斥锁
int m_count;                // 测试数


- (void)syncPthread {
    
    pthread_mutex_init(&m_mutex, NULL);             // 创建锁
    
    pthread_t pth1,pth2;
    pthread_create(&pth1, NULL, thread1, NULL);     // 创建线程1
    pthread_create(&pth2, NULL, thread2, NULL);     // 创建线程2
    pthread_join(pth1, NULL);                       // 等待回收线程1
    pthread_join(pth2, NULL);                       // 等待回收线程2
        
    pthread_mutex_destroy(&m_mutex);                // 销毁锁
}


void *thread1(void *arg)
{
    for (int i=0; i<10; i++)
    {
        pthread_mutex_lock(&m_mutex);
        NSLog(@"%s, count=%d", __func__, m_count);
        m_count++;
        pthread_mutex_unlock(&m_mutex);
        sleep(1);
    }
    NSLog(@"%s, end", __func__);
        
    return NULL;
}


void* thread2(void *arg)
{
    for (int i=0; i<10; i++)
    {
        pthread_mutex_lock(&m_mutex);
        NSLog(@"%s, count=%d", __func__, m_count);
        m_count++;
        pthread_mutex_unlock(&m_mutex);
        sleep(2);
    }
    NSLog(@"%s, end", __func__);
        
    return NULL;
}


@end
