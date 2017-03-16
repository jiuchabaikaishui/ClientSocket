//
//  ViewController.m
//  Client_StreamSocket
//
//  Created by 綦 on 17/3/15.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (strong, nonatomic) UILabel *msgLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startSocket:@"127.0.0.1" andPort:11332];
}

- (void)startSocket:(NSString *)address andPort:(int)port
{
    CFReadStreamRef readRef;
    CFWriteStreamRef writeRef;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)address, port, &readRef, &writeRef);
    
    NSInputStream *inputStream = (__bridge NSInputStream *)readRef;
    NSOutputStream *outputStream = (__bridge NSOutputStream *)writeRef;
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    self.outputStream = outputStream;
}

- (IBAction)sendMsg:(UIButton *)sender {
    if (sender.currentTitle > 0) {
        const char *output = sender.currentTitle.UTF8String;
        [self.outputStream write:(const uint8_t *)output maxLength:strlen(output)];
    }
}

- (void)showMessage:(NSString *)msg
{
    if (!self.msgLabel) {
        UIFont *font = [UIFont systemFontOfSize:14];
        UIColor *color = [UIColor blackColor];
        UIColor *backColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = color;
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = backColor;
        self.msgLabel = label;
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat W = screenW - 16;
    CGSize size = [msg boundingRectWithSize:CGSizeMake(W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.msgLabel.font} context:nil].size;
    W = size.width;
    CGFloat H = size.height;
    CGFloat X = (screenW - W)/2;
    CGFloat Y = (screenH - H)/2;
    
    self.msgLabel.frame = CGRectMake(X, Y, W, H);
    self.msgLabel.text = msg;
    [self.view addSubview:self.msgLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.msgLabel removeFromSuperview];
    });
}

#pragma mark - <NSStreamDelegate>代理方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
        {
            uint8_t buf[1024];
            NSInteger len = 0;
            NSInputStream *inputStream = (NSInputStream *)aStream;
            len = [inputStream read:buf maxLength:1024];
            if (len) {
                [self showMessage:[NSString stringWithCString:(const char *)buf encoding:NSUTF8StringEncoding]];
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
            break;
        case NSStreamEventErrorOccurred:
        {
            [aStream close];
            break;
        }
        case NSStreamEventEndEncountered:
        {
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
            break;
        }
            
        default:
            break;
    }
}

@end
