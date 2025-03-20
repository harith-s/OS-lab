/**
 * Simple program demonstrating shared memory in POSIX systems.
 *
 * This is the producer process that writes to the shared memory region.
 *
 * Figure 3.17
 *
 * @author Silberschatz, Galvin, and Gagne
 * Operating System Concepts  - Ninth Edition
 * Copyright John Wiley & Sons - 2013
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/msg.h>
#include <signal.h>

#define TOTAL_SIZE 100


int cmsgid;
int pmsgid;


struct msg_buffer {
    long msg_type;
    char msg_text[100];
} sent_msg;

struct msgg_buffer {
    long msg_type;
    char msg_text[100];
} rcvd_msg;

int find_size(int offset){
	int size = 0;
	while(offset > 0){
		size++;
		offset = offset / 10;
	}
	return size;
}
void itos(int offset, char * str){
	int size = find_size(offset);
	int i = size - 1;
	// printf("%d\n", size);
	while(offset > 0){
		str[i] = offset % 10 + '0';
		offset = offset / 10;
	// printf("Char: %s\n", str);
		i--;
	}
	str[size] = 0;

}

void signal_handler(int sig){
	if (msgctl(cmsgid, IPC_RMID, NULL) == -1){
		printf("Consumer msg queue remove failed.\n");
	}
	if (msgctl(pmsgid, IPC_RMID, NULL) == -1){
		printf("Producer msg queue remove failed.\n");
	}
	exit(1);
}
int main()
{
	signal(SIGINT, signal_handler);
	const int SIZE = 4096;
	const char *name = "diff_shared";
	const char *empty= "freeeee";
	const char *msg= "OSisFUN";
	int msg_len = strlen(msg);
	int available[512];
	

	for (int i = 0; i < 512; i++){
		available[i] = i;
	}
	
	int shm_fd;
	void *ptr;

	/* create the shared memory segment */
	shm_fd = shm_open(name, O_CREAT | O_RDWR, 0666);

	/* configure the size of the shared memory segment */
	ftruncate(shm_fd, SIZE);

	/* now map the shared memory segment in the address space of the process */
	ptr = mmap(0,SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);

	if (ptr == MAP_FAILED) {
		printf("Map failed\n");
		exit(-1);
	}

	void * start = ptr;
	
	key_t key_prod;
	key_t key_cons;

	key_prod = ftok("prod", 100);
	key_cons = ftok("cons", 100);


	pmsgid = msgget(key_prod, 0666 | IPC_CREAT);
	cmsgid = msgget(key_cons, 0666 | IPC_CREAT);

    sent_msg.msg_type = 1;

	strcpy(sent_msg.msg_text, "STARTED");


	msgsnd(pmsgid, &sent_msg, sizeof(sent_msg), 0);
	printf("Data send is : %s \n", sent_msg.msg_text);


	msgrcv(cmsgid, &rcvd_msg, sizeof(rcvd_msg), 2, 0);
	printf("Data Received is : %s \n", rcvd_msg.msg_text);


	for (int i = 0; i < TOTAL_SIZE; i++){

		sent_msg.msg_text[0] = msg_len + '0';
		char str_off[10];
		
		int offset = available[i % 512];
		if (offset == -1){
			msgrcv(cmsgid, &rcvd_msg, sizeof(rcvd_msg), 2, 0);
			printf("Freed up data offset is : %s \n", rcvd_msg.msg_text);
			offset = atoi(rcvd_msg.msg_text);
		}
		else	
			available[i % 512] = -1;
		
		ptr = start + offset * 8;
		itos(offset, str_off);
		strcpy(sent_msg.msg_text + 1, str_off);
		msgsnd(pmsgid, &sent_msg, sizeof(sent_msg), 0);
		printf("Data send is : %s\n", sent_msg.msg_text);
		sprintf(ptr,"%s",msg);		
	}	

	


	return 0;
}
