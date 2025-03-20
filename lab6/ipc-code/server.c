#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <string.h>
#include <unistd.h>

#define SOCKET_PATH "server_socket"

int main(){

    struct sockaddr_un serv_addr, cl_addr;
    bzero((char *)&serv_addr, sizeof(serv_addr));

    serv_addr.sun_family = AF_UNIX;
    strcpy(serv_addr.sun_path, SOCKET_PATH);

    int sfd = socket(AF_UNIX, SOCK_DGRAM, 0);
    int len = sizeof(cl_addr);

    if (bind(sfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) 
        printf("Server binding failed\n");

    char buffer[256];

    printf("Server ready!\n");
    while(true){
        bzero(buffer, sizeof(buffer));
        recvfrom(sfd, buffer, 256, 0, (struct sockaddr *)&cl_addr, &len);
        if (buffer[0] == 4) break;
        printf("%s", buffer);

    }
    unlink(SOCKET_PATH);


}