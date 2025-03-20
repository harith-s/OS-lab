all: prod cons
	./prod

prod: shm-posix-producer-orig.c
	gcc -g -o prod shm-posix-producer-orig.c -lrt
cons: shm-posix-consumer-orig.c
	gcc -g -o cons shm-posix-consumer-orig.c -lrt


clean:
	rm prod cons
	
.PHONY: clean
