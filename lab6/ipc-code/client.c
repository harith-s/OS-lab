#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>



#define SOCKET_PATH "server_socket"

int main(){

    struct sockaddr_un serv_addr;
    bzero((char *)&serv_addr, sizeof(serv_addr));

    serv_addr.sun_family = AF_UNIX;
    strcpy(serv_addr.sun_path, SOCKET_PATH);

    int sfd = socket(AF_UNIX, SOCK_DGRAM, 0);

    char buffer[300];
    bzero(buffer, sizeof(buffer));
    
    printf("HIIIIII\n");
    FILE * fp = fopen("./text.txt", "r");

    char c;
    c = getc(fp);

    if (c == EOF && !(feof(fp)) == EOF){
        printf("Unable to open file.\n");
    }
    int i = 0;
    while(c != EOF){
        buffer[i] = c;
        i++;
        if (i == 255){
            buffer[i] = 0;
            sendto(sfd, buffer, strlen(buffer), 0, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
            bzero(buffer,256);
            i = 0;
        }
        c = getc(fp);
    }
    buffer[i] = 0;
    sendto(sfd, buffer, strlen(buffer), 0, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

    bzero(buffer, 256);
    buffer[0] = 4;
    sendto(sfd, buffer, strlen(buffer), 0, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    
}