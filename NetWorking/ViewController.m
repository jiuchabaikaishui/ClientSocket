//
//  ViewController.m
//  NetWorking
//
//  Created by 綦 on 17/3/13.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>

@property (assign, nonatomic, getter=isRead) BOOL read;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dataPath = [documentStr stringByAppendingPathComponent:@"data.txt"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dataPath]) {
        self.read = YES;
        NSLog(@"string:%@", [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil]);
        
        NSInputStream *inStream = [[NSInputStream alloc] initWithFileAtPath:dataPath];
        [inStream setDelegate:self];
        [inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inStream open];
    }
    else
    {
        if ([manager createFileAtPath:dataPath contents:nil attributes:nil]) {
            self.read = NO;
            NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:dataPath append:YES];
            [outStream setDelegate:self];
            [outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [outStream open];
        }
        else
        {
            NSLog(@"文件创建失败！");
        }
    }
}

#pragma mark - <NSStreamDelegate>代理方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if (self.read) {
        NSInputStream *inStream = (NSInputStream *)aStream;
        switch (eventCode) {
            case NSStreamEventHasBytesAvailable:
            {
                uint8_t data[1024];
                [inStream read:data maxLength:1024];
                printf("%s", data);
                [inStream close];
                [inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                inStream = nil;
            }
                break;
            case NSStreamEventEndEncountered:
            {
                [inStream close];
                [inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                inStream = nil;
            }
                break;
                
            default:
                break;
        }
    }
    else{
        NSOutputStream *outStream = (NSOutputStream *)aStream;
        switch (eventCode) {
            case NSStreamEventHasSpaceAvailable:
            {
                uint8_t data[] = "{name:'张三', age:10}";
                [outStream write:data maxLength:strlen((char *)data)];
                [outStream close];
                [outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                outStream = nil;
            }
                break;
            case NSStreamEventEndEncountered:
            {
                [outStream close];
                [outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                outStream = nil;
            }
                break;
                
            default:
                break;
        }
    }
}


@end
