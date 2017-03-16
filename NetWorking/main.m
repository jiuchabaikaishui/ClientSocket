//
//  main.m
//  NetWorking
//
//  Created by 綦 on 17/3/13.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#include <string.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        struct sockaddr_in server_addr;
//        server_addr.sin_len = sizeof(struct sockaddr_in);
//        server_addr.sin_family = AF_INET;
//        server_addr.sin_port = htons(11332);
//        server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
//        bzero(&(server_addr.sin_zero), 8);
//        
//        int server_socket = socket(AF_INET, SOCK_STREAM, 0);
//        if (server_socket == -1) {
//            perror("socket error");
//            
//            return 1;
//        }
//        
//        char receive_msg[1024];
//        char reply_msg[1024];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//        });
//        if (connect(server_socket, (struct sockaddr*)&server_addr, sizeof(struct sockaddr_in)) == 0) {
//            //connect 成功之后，其实系统将你创建的socket绑定到一个系统分配的端口上，且其为全相关，包含服务器端的信息，可以用来和服务器端进行通信。
//            
//            while (1) {
//                bzero(receive_msg, 1024);
////                long byte_num = recv(server_socket, receive_msg, 1024, 0);
////                receive_msg[byte_num] = '\0';
////                printf("server said:%s\n", receive_msg);
//                
//                bzero(reply_msg, 1024);
////                printf("replay:");
////                scanf("%s", reply_msg);
//                reply_msg = "你好啊！";
//                if (send(server_socket, &server_addr, 1024, 0) == -1) {
//                    perror("send error!");
//                    
//                    return 1;
//                }
//            }
//        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
