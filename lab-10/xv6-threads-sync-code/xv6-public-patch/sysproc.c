#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
/////////////////// New addition ///////////////////////
#include "barrier.h"
/////////////////// End of new addition ///////////////////////

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

/////////////////// New addition ///////////////////////
int sys_thread_create(void){
  char* ptid;
  char* fptr;
  char* pargs;
  int pos = 0;
  argptr(0, &ptid, sizeof(int*));
  pos += sizeof(int*) / 4;
  argptr(pos, &fptr, sizeof(void*));
  pos += sizeof(void*) / 4;
  argptr(pos, &pargs, sizeof(void *));

  uint * tid = (uint *) ptid;
  void * func_ptr = (void *)fptr;
  void * arg_ptr = (void *)pargs;

  thread_create(tid, func_ptr, arg_ptr);
  return -1;
}

int sys_thread_exit(void){
  return thread_exit();
}

int sys_thread_join(void){
  int tid;
  if (argint(0, &tid) < 0)
    return -1;
  // cprintf("here\n");
  return thread_join((uint)tid);
  // return 0;
}

int sys_barrier_init(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
  
  return barrier_init(n);
}

int sys_barrier_check(void)
{
  return barrier_check();
}

int sys_waitpid(void)
{
  int pid;
  if (argint(0, &pid) < 0){
    return -1;
  }

  return waitpid(pid);
}

////////////////// End of new addition /////////////////
/////////// Parts D and E of threads lab/////////
int sys_sleepChan(void) {
  int arg;
  if (argint(0, &arg) < 0){
    return -1;
  }

  return sleepChan(arg);
}

int sys_getChannel(void) {
  return getChannel();
}

int sys_sigChan(void) {
  int arg;
  if (argint(0, &arg) < 0){
    return -1;
  }
  return sigChan(arg);
}

int sys_sigOneChan(void) {
  int arg;
  if (argint(0, &arg) < 0){
    return -1;
  }
  return sigOneChan(arg);
}
/////////// End of Parts D and E of threads lab/////////

