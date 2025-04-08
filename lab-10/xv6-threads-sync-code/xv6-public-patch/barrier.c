/*----------xv6 sync lab----------*/
#include "types.h"
#include "x86.h"
#include "spinlock.h"
#include "defs.h"
#include "barrier.h"

//define any variables needed here

int barrier_count;
int N;
struct spinlock block;


int
barrier_init(int n)
{
  barrier_count = n;
  N = n;
  initlock(&block, "barrier-lock");
  return 0;

}

int
barrier_check(void)
{
  acquire(&block);
  if (barrier_count == 1){
    for (int i = 0; i < N; i++){
      wakeup(&barrier_count);
    } 
    barrier_count = N;
  }
  else{
    barrier_count--;
    sleep(&barrier_count, &block);
  }
  release(&block);
  return 0;
}

/*----------xv6 sync lock end----------*/
