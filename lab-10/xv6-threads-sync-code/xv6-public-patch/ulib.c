#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"

// #include "defs.h"

int channel = 0;

char *
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    ;
  return os;
}

int strcmp(const char *p, const char *q)
{
  while (*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint strlen(const char *s)
{
  int n;

  for (n = 0; s[n]; n++)
    ;
  return n;
}

void *
memset(void *dst, int c, uint n)
{
  stosb(dst, c, n);
  return dst;
}

char *
strchr(const char *s, char c)
{
  for (; *s; s++)
    if (*s == c)
      return (char *)s;
  return 0;
}

char *
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;)
  {
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if (fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int atoi(const char *s)
{
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    n = n * 10 + *s++ - '0';
  return n;
}

void *
memmove(void *vdst, const void *vsrc, int n)
{
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while (n-- > 0)
    *dst++ = *src++;
  return vdst;
}

/////////// New additions for Parts D and E of threads lab /////////
void initiateLock(struct lock *l)
{
  l->isInitiated = 1;
  l->lockvar = 0;
}

void acquireLock(struct lock *l)
{
  if (l->isInitiated == 1)
  {
    while (xchg((uint *)&(l->lockvar), 1) != 0);
    // printf(1, "got lock bro: %d\n", l->lockvar);
  }
}

void releaseLock(struct lock *l)
{
  if (l->isInitiated == 1)
  {
    l->lockvar = 0;
    // printf(1, "released lock bro: %d\n", l->lockvar);

  }
}

void initiateCondVar(struct condvar *cv)
{
  cv->isInitiated = 1;
  cv->var = getChannel();
}

void condWait(struct condvar *cv, struct lock *l)
{
  if (cv->isInitiated && l->isInitiated){
    releaseLock(l);
    sleepChan(cv->var);
    acquireLock(l);
  }
}

void broadcast(struct condvar *cv)
{
  sigChan(cv->var);
}

void signal(struct condvar *cv)
{
  sigOneChan(cv->var);

}

void semInit(struct semaphore *s, int initVal)
{
  s->isInitiated = 1;
  initiateCondVar(&s->cv);
  initiateLock(&s->l);
  s->ctr = initVal;
}

void semUp(struct semaphore *s)
{
  acquireLock(&s->l);
  s->ctr++;
  signal(&s->cv);
  releaseLock(&s->l);
}

void semDown(struct semaphore *s)
{

  acquireLock(&s->l);
  s->ctr--;
  if (s->ctr < 0){
    condWait(&s->cv, &s->l);
  }
  releaseLock(&s->l);

}

/////////// End of New additions for Parts D and E of threads lab/////////
