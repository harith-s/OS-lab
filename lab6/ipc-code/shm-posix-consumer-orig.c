/**
 * Simple program demonstrating shared memory in POSIX systems.
 *
 * This is the consumer process
 *
 * Figure 3.18
 *
 * @author Gagne, Galvin, Silberschatz
 * Operating System Concepts - Ninth Edition
 * Copyright John Wiley & Sons - 2013
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/msg.h>
#include <stdbool.h>
#include <string.h>
#include <signal.h>



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
	while(offset > 0){
		str[i] = offset % 10 + '0';
		offset = offset / 10;
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

	const char *name = "diff_shared";
	const int SIZE = 4096;
	const char *empty= "freeeee";

	int shm_fd;
	void *ptr;
	int i;

	shm_fd = shm_open(name, O_RDWR, 0666);
	if (shm_fd == -1) {
		printf("shared memory failed\n");
		exit(-1);
	}
	/* now map the shared memory segment in the address space of the process */
	ptr = mmap(0,SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	if (ptr == MAP_FAILED) {
		printf("Map failed\n");
		exit(-1);
	}

	void * start = ptr;
	sprintf(ptr,"%s",empty);

	key_t key_prod;
	key_t key_cons;

	key_prod = ftok("prod", 100);
	key_cons = ftok("cons", 100);


	pmsgid = msgget(key_prod, 0666);
	cmsgid = msgget(key_cons, 0666);

    sent_msg.msg_type = 2;

	msgrcv(pmsgid, &rcvd_msg, sizeof(rcvd_msg), 1, 0);

	printf("here\n");
    printf("Data Received is : %s \n", 
                    rcvd_msg.msg_text);

	strcpy(sent_msg.msg_text, "RECEIVED");

	msgsnd(cmsgid, &sent_msg, sizeof(sent_msg), 0);
	printf("Data send is : %s \n", sent_msg.msg_text);

	
	// /* now read from the shared memory region */
	while(true){

		msgrcv(pmsgid, &rcvd_msg, sizeof(rcvd_msg), 1, 0);
		int num_chars = rcvd_msg.msg_text[0] - '0';
		int offset = atoi(rcvd_msg.msg_text + 1);

		ptr = start + offset * 8;

		printf("Offset: %d\n", atoi(rcvd_msg.msg_text + 1));
		printf("%.7s\n", (char *)ptr);
		char str_off[10];

		sprintf(ptr,"%s", empty);

		itos(offset, str_off);
		strcpy(sent_msg.msg_text, str_off);
		msgsnd(cmsgid, &sent_msg, sizeof(sent_msg), 0);
		sleep(1);

	}

	/* remove the shared memory segment */
	if (shm_unlink(name) == -1) {
		printf("Error removing %s\n",name);
		exit(-1);
	}

	return 0;
}
