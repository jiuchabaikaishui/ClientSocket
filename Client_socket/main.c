//
//  main.c
//  Client_socket
//
//  Created by 綦 on 17/3/13.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#include <stdio.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#include <string.h>

int main(int argc, const char * argv[]) {
    /*
     BSD socket:完全由c语言实现，并且可以在Objective-C代码中使用。
     优点：
        不同平台中易于移植
     缺点：
        无法访问操作系统内建的网络特性（比如系统范围的VPN）。
        更糟糕的是初始化socket连接并不会自动打开设备的Wi-Fi或是蜂窝网络，无线网络会智能的关闭以节省电池电量，任何通信连接都会失败，除非其他网络进程激活了无线网。
     
     CFNetwork对BSD Socket的分装可以激活设备的无线网，所以几乎所有场景都建议使用CFNetwork而不是BSD Socket.
    */
    struct sockaddr_in server_addr;
    server_addr.sin_len = sizeof(struct sockaddr_in);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(11332);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    bzero(&(server_addr.sin_zero), 8);
    
    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket error");
        
        return 1;
    }
    
    char receive_msg[1024];
    char reply_msg[1024];
    
    if (connect(server_socket, (struct sockaddr*)&server_addr, sizeof(struct sockaddr_in)) == 0) {
        //connect 成功之后，其实系统将你创建的socket绑定到一个系统分配的端口上，且其为全相关，包含服务器端的信息，可以用来和服务器端进行通信。
        
        while (1) {
            bzero(reply_msg, 1024);
            printf("replay:");
            scanf("%s", reply_msg);
            if (send(server_socket, reply_msg, 1024, 0) == -1) {
                perror("send error!");
                
                return 1;
            }
            
            bzero(receive_msg, 1024);
            long byte_num = recv(server_socket, receive_msg, 1024, 0);
            receive_msg[byte_num] = '\0';
            printf("server said:%s\n", receive_msg);
        }
    }
    
    return 0;
}
