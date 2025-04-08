
_t_sem2:     file format elf32-i386


Disassembly of section .text:

00000000 <thread1>:
int CHILDSEM=0;
int PARENTSEM=1;

struct semaphore s1, s2;

void* thread1(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
    semDown(&s1);
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	68 88 0e 00 00       	push   $0xe88
   e:	e8 38 04 00 00       	call   44b <semDown>
  13:	83 c4 10             	add    $0x10,%esp
    printf(1, "I am thread 1\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 d4 09 00 00       	push   $0x9d4
  1e:	6a 01                	push   $0x1
  20:	e8 f7 05 00 00       	call   61c <printf>
  25:	83 c4 10             	add    $0x10,%esp
    semUp(&s2);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	68 a0 0e 00 00       	push   $0xea0
  30:	e8 10 04 00 00       	call   445 <semUp>
  35:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  38:	e8 c4 04 00 00       	call   501 <thread_exit>
    return 0;
  3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  42:	c9                   	leave  
  43:	c3                   	ret    

00000044 <thread2>:

void* thread2(void* arg){
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	83 ec 08             	sub    $0x8,%esp
    semDown(&s1);
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	68 88 0e 00 00       	push   $0xe88
  52:	e8 f4 03 00 00       	call   44b <semDown>
  57:	83 c4 10             	add    $0x10,%esp
    printf(1, "I am thread 2\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 e3 09 00 00       	push   $0x9e3
  62:	6a 01                	push   $0x1
  64:	e8 b3 05 00 00       	call   61c <printf>
  69:	83 c4 10             	add    $0x10,%esp
    semUp(&s2);
  6c:	83 ec 0c             	sub    $0xc,%esp
  6f:	68 a0 0e 00 00       	push   $0xea0
  74:	e8 cc 03 00 00       	call   445 <semUp>
  79:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  7c:	e8 80 04 00 00       	call   501 <thread_exit>
    return 0;
  81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  86:	c9                   	leave  
  87:	c3                   	ret    

00000088 <thread3>:

void* thread3(void* arg){
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	83 ec 08             	sub    $0x8,%esp
    sleep(2);
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	6a 02                	push   $0x2
  93:	e8 51 04 00 00       	call   4e9 <sleep>
  98:	83 c4 10             	add    $0x10,%esp

    //inspite of the sleep, parent should print first
    printf(1, "I am thread3 and I should print first\n");
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 f4 09 00 00       	push   $0x9f4
  a3:	6a 01                	push   $0x1
  a5:	e8 72 05 00 00       	call   61c <printf>
  aa:	83 c4 10             	add    $0x10,%esp

    semUp(&s1);
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	68 88 0e 00 00       	push   $0xe88
  b5:	e8 8b 03 00 00       	call   445 <semUp>
  ba:	83 c4 10             	add    $0x10,%esp
    semDown(&s2);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	68 a0 0e 00 00       	push   $0xea0
  c5:	e8 81 03 00 00       	call   44b <semDown>
  ca:	83 c4 10             	add    $0x10,%esp

    printf(1, "Only one other thread has printed by now\n");
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 1c 0a 00 00       	push   $0xa1c
  d5:	6a 01                	push   $0x1
  d7:	e8 40 05 00 00       	call   61c <printf>
  dc:	83 c4 10             	add    $0x10,%esp

    semUp(&s1);
  df:	83 ec 0c             	sub    $0xc,%esp
  e2:	68 88 0e 00 00       	push   $0xe88
  e7:	e8 59 03 00 00       	call   445 <semUp>
  ec:	83 c4 10             	add    $0x10,%esp
    semDown(&s2);
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	68 a0 0e 00 00       	push   $0xea0
  f7:	e8 4f 03 00 00       	call   44b <semDown>
  fc:	83 c4 10             	add    $0x10,%esp
    printf(1, "Both the other threads have printed by now\n");
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	68 48 0a 00 00       	push   $0xa48
 107:	6a 01                	push   $0x1
 109:	e8 0e 05 00 00       	call   61c <printf>
 10e:	83 c4 10             	add    $0x10,%esp

    thread_exit();
 111:	e8 eb 03 00 00       	call   501 <thread_exit>
    return 0;
 116:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <main>:

int main()
{
 11d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 121:	83 e4 f0             	and    $0xfffffff0,%esp
 124:	ff 71 fc             	push   -0x4(%ecx)
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	51                   	push   %ecx
 12b:	83 ec 14             	sub    $0x14,%esp
    semInit(&s1,0);
 12e:	83 ec 08             	sub    $0x8,%esp
 131:	6a 00                	push   $0x0
 133:	68 88 0e 00 00       	push   $0xe88
 138:	e8 02 03 00 00       	call   43f <semInit>
 13d:	83 c4 10             	add    $0x10,%esp
    semInit(&s2,0);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	6a 00                	push   $0x0
 145:	68 a0 0e 00 00       	push   $0xea0
 14a:	e8 f0 02 00 00       	call   43f <semInit>
 14f:	83 c4 10             	add    $0x10,%esp
  
    uint tid1, tid2, tid3;
    thread_create(&tid1, thread1, 0);
 152:	83 ec 04             	sub    $0x4,%esp
 155:	6a 00                	push   $0x0
 157:	68 00 00 00 00       	push   $0x0
 15c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 15f:	50                   	push   %eax
 160:	e8 94 03 00 00       	call   4f9 <thread_create>
 165:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid2, thread2, 0);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	6a 00                	push   $0x0
 16d:	68 44 00 00 00       	push   $0x44
 172:	8d 45 f0             	lea    -0x10(%ebp),%eax
 175:	50                   	push   %eax
 176:	e8 7e 03 00 00       	call   4f9 <thread_create>
 17b:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid3, thread3, 0);
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	6a 00                	push   $0x0
 183:	68 88 00 00 00       	push   $0x88
 188:	8d 45 ec             	lea    -0x14(%ebp),%eax
 18b:	50                   	push   %eax
 18c:	e8 68 03 00 00       	call   4f9 <thread_create>
 191:	83 c4 10             	add    $0x10,%esp

    thread_join(tid1);
 194:	8b 45 f4             	mov    -0xc(%ebp),%eax
 197:	83 ec 0c             	sub    $0xc,%esp
 19a:	50                   	push   %eax
 19b:	e8 69 03 00 00       	call   509 <thread_join>
 1a0:	83 c4 10             	add    $0x10,%esp
    thread_join(tid2);
 1a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a6:	83 ec 0c             	sub    $0xc,%esp
 1a9:	50                   	push   %eax
 1aa:	e8 5a 03 00 00       	call   509 <thread_join>
 1af:	83 c4 10             	add    $0x10,%esp
    thread_join(tid3);
 1b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1b5:	83 ec 0c             	sub    $0xc,%esp
 1b8:	50                   	push   %eax
 1b9:	e8 4b 03 00 00       	call   509 <thread_join>
 1be:	83 c4 10             	add    $0x10,%esp

    exit();
 1c1:	e8 93 02 00 00       	call   459 <exit>

000001c6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	57                   	push   %edi
 1ca:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ce:	8b 55 10             	mov    0x10(%ebp),%edx
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 cb                	mov    %ecx,%ebx
 1d6:	89 df                	mov    %ebx,%edi
 1d8:	89 d1                	mov    %edx,%ecx
 1da:	fc                   	cld    
 1db:	f3 aa                	rep stos %al,%es:(%edi)
 1dd:	89 ca                	mov    %ecx,%edx
 1df:	89 fb                	mov    %edi,%ebx
 1e1:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e7:	90                   	nop
 1e8:	5b                   	pop    %ebx
 1e9:	5f                   	pop    %edi
 1ea:	5d                   	pop    %ebp
 1eb:	c3                   	ret    

000001ec <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f8:	90                   	nop
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 42 01             	lea    0x1(%edx),%eax
 1ff:	89 45 0c             	mov    %eax,0xc(%ebp)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8d 48 01             	lea    0x1(%eax),%ecx
 208:	89 4d 08             	mov    %ecx,0x8(%ebp)
 20b:	0f b6 12             	movzbl (%edx),%edx
 20e:	88 10                	mov    %dl,(%eax)
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	84 c0                	test   %al,%al
 215:	75 e2                	jne    1f9 <strcpy+0xd>
    ;
  return os;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21f:	eb 08                	jmp    229 <strcmp+0xd>
    p++, q++;
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	74 10                	je     243 <strcmp+0x27>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 10             	movzbl (%eax),%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	38 c2                	cmp    %al,%dl
 241:	74 de                	je     221 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 d0             	movzbl %al,%edx
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	0f b6 c0             	movzbl %al,%eax
 255:	29 c2                	sub    %eax,%edx
 257:	89 d0                	mov    %edx,%eax
}
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    

0000025b <strlen>:

uint
strlen(const char *s)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 268:	eb 04                	jmp    26e <strlen+0x13>
 26a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	01 d0                	add    %edx,%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	84 c0                	test   %al,%al
 27b:	75 ed                	jne    26a <strlen+0xf>
    ;
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memset>:

void*
memset(void *dst, int c, uint n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 285:	8b 45 10             	mov    0x10(%ebp),%eax
 288:	50                   	push   %eax
 289:	ff 75 0c             	push   0xc(%ebp)
 28c:	ff 75 08             	push   0x8(%ebp)
 28f:	e8 32 ff ff ff       	call   1c6 <stosb>
 294:	83 c4 0c             	add    $0xc,%esp
  return dst;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <strchr>:

char*
strchr(const char *s, char c)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 04             	sub    $0x4,%esp
 2a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a8:	eb 14                	jmp    2be <strchr+0x22>
    if(*s == c)
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2b3:	75 05                	jne    2ba <strchr+0x1e>
      return (char*)s;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	eb 13                	jmp    2cd <strchr+0x31>
  for(; *s; s++)
 2ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	84 c0                	test   %al,%al
 2c6:	75 e2                	jne    2aa <strchr+0xe>
  return 0;
 2c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cd:	c9                   	leave  
 2ce:	c3                   	ret    

000002cf <gets>:

char*
gets(char *buf, int max)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2dc:	eb 42                	jmp    320 <gets+0x51>
    cc = read(0, &c, 1);
 2de:	83 ec 04             	sub    $0x4,%esp
 2e1:	6a 01                	push   $0x1
 2e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e6:	50                   	push   %eax
 2e7:	6a 00                	push   $0x0
 2e9:	e8 83 01 00 00       	call   471 <read>
 2ee:	83 c4 10             	add    $0x10,%esp
 2f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f8:	7e 33                	jle    32d <gets+0x5e>
      break;
    buf[i++] = c;
 2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 55 f4             	mov    %edx,-0xc(%ebp)
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 16                	je     32e <gets+0x5f>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0e                	je     32e <gets+0x5f>
  for(i=0; i+1 < max; ){
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	39 45 0c             	cmp    %eax,0xc(%ebp)
 329:	7f b3                	jg     2de <gets+0xf>
 32b:	eb 01                	jmp    32e <gets+0x5f>
      break;
 32d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 32e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	01 d0                	add    %edx,%eax
 336:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33c:	c9                   	leave  
 33d:	c3                   	ret    

0000033e <stat>:

int
stat(const char *n, struct stat *st)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 344:	83 ec 08             	sub    $0x8,%esp
 347:	6a 00                	push   $0x0
 349:	ff 75 08             	push   0x8(%ebp)
 34c:	e8 48 01 00 00       	call   499 <open>
 351:	83 c4 10             	add    $0x10,%esp
 354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35b:	79 07                	jns    364 <stat+0x26>
    return -1;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	eb 25                	jmp    389 <stat+0x4b>
  r = fstat(fd, st);
 364:	83 ec 08             	sub    $0x8,%esp
 367:	ff 75 0c             	push   0xc(%ebp)
 36a:	ff 75 f4             	push   -0xc(%ebp)
 36d:	e8 3f 01 00 00       	call   4b1 <fstat>
 372:	83 c4 10             	add    $0x10,%esp
 375:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 378:	83 ec 0c             	sub    $0xc,%esp
 37b:	ff 75 f4             	push   -0xc(%ebp)
 37e:	e8 fe 00 00 00       	call   481 <close>
 383:	83 c4 10             	add    $0x10,%esp
  return r;
 386:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 389:	c9                   	leave  
 38a:	c3                   	ret    

0000038b <atoi>:

int
atoi(const char *s)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 398:	eb 25                	jmp    3bf <atoi+0x34>
    n = n*10 + *s++ - '0';
 39a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39d:	89 d0                	mov    %edx,%eax
 39f:	c1 e0 02             	shl    $0x2,%eax
 3a2:	01 d0                	add    %edx,%eax
 3a4:	01 c0                	add    %eax,%eax
 3a6:	89 c1                	mov    %eax,%ecx
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	8d 50 01             	lea    0x1(%eax),%edx
 3ae:	89 55 08             	mov    %edx,0x8(%ebp)
 3b1:	0f b6 00             	movzbl (%eax),%eax
 3b4:	0f be c0             	movsbl %al,%eax
 3b7:	01 c8                	add    %ecx,%eax
 3b9:	83 e8 30             	sub    $0x30,%eax
 3bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 2f                	cmp    $0x2f,%al
 3c7:	7e 0a                	jle    3d3 <atoi+0x48>
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 39                	cmp    $0x39,%al
 3d1:	7e c7                	jle    39a <atoi+0xf>
  return n;
 3d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ea:	eb 17                	jmp    403 <memmove+0x2b>
    *dst++ = *src++;
 3ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ef:	8d 42 01             	lea    0x1(%edx),%eax
 3f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f8:	8d 48 01             	lea    0x1(%eax),%ecx
 3fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3fe:	0f b6 12             	movzbl (%edx),%edx
 401:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 403:	8b 45 10             	mov    0x10(%ebp),%eax
 406:	8d 50 ff             	lea    -0x1(%eax),%edx
 409:	89 55 10             	mov    %edx,0x10(%ebp)
 40c:	85 c0                	test   %eax,%eax
 40e:	7f dc                	jg     3ec <memmove+0x14>
  return vdst;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp

}
 418:	90                   	nop
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    

0000041b <acquireLock>:

void acquireLock(struct lock* l) {
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp

}
 41e:	90                   	nop
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    

00000421 <releaseLock>:

void releaseLock(struct lock* l) {
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp

}
 424:	90                   	nop
 425:	5d                   	pop    %ebp
 426:	c3                   	ret    

00000427 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp

}
 42a:	90                   	nop
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    

0000042d <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp

}
 430:	90                   	nop
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    

00000433 <broadcast>:

void broadcast(struct condvar* cv) {
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp

}
 436:	90                   	nop
 437:	5d                   	pop    %ebp
 438:	c3                   	ret    

00000439 <signal>:

void signal(struct condvar* cv) {
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp

}
 43c:	90                   	nop
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret    

0000043f <semInit>:

void semInit(struct semaphore* s, int initVal) {
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp

}
 442:	90                   	nop
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    

00000445 <semUp>:

void semUp(struct semaphore* s) {
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp

}
 448:	90                   	nop
 449:	5d                   	pop    %ebp
 44a:	c3                   	ret    

0000044b <semDown>:

void semDown(struct semaphore* s) {
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp

}
 44e:	90                   	nop
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret    

00000451 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 451:	b8 01 00 00 00       	mov    $0x1,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <exit>:
SYSCALL(exit)
 459:	b8 02 00 00 00       	mov    $0x2,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <wait>:
SYSCALL(wait)
 461:	b8 03 00 00 00       	mov    $0x3,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <pipe>:
SYSCALL(pipe)
 469:	b8 04 00 00 00       	mov    $0x4,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <read>:
SYSCALL(read)
 471:	b8 05 00 00 00       	mov    $0x5,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <write>:
SYSCALL(write)
 479:	b8 10 00 00 00       	mov    $0x10,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <close>:
SYSCALL(close)
 481:	b8 15 00 00 00       	mov    $0x15,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <kill>:
SYSCALL(kill)
 489:	b8 06 00 00 00       	mov    $0x6,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <exec>:
SYSCALL(exec)
 491:	b8 07 00 00 00       	mov    $0x7,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <open>:
SYSCALL(open)
 499:	b8 0f 00 00 00       	mov    $0xf,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mknod>:
SYSCALL(mknod)
 4a1:	b8 11 00 00 00       	mov    $0x11,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <unlink>:
SYSCALL(unlink)
 4a9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <fstat>:
SYSCALL(fstat)
 4b1:	b8 08 00 00 00       	mov    $0x8,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <link>:
SYSCALL(link)
 4b9:	b8 13 00 00 00       	mov    $0x13,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mkdir>:
SYSCALL(mkdir)
 4c1:	b8 14 00 00 00       	mov    $0x14,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <chdir>:
SYSCALL(chdir)
 4c9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <dup>:
SYSCALL(dup)
 4d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getpid>:
SYSCALL(getpid)
 4d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sbrk>:
SYSCALL(sbrk)
 4e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sleep>:
SYSCALL(sleep)
 4e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <uptime>:
SYSCALL(uptime)
 4f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <thread_create>:
SYSCALL(thread_create)
 4f9:	b8 16 00 00 00       	mov    $0x16,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <thread_exit>:
SYSCALL(thread_exit)
 501:	b8 17 00 00 00       	mov    $0x17,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <thread_join>:
SYSCALL(thread_join)
 509:	b8 18 00 00 00       	mov    $0x18,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <waitpid>:
SYSCALL(waitpid)
 511:	b8 1e 00 00 00       	mov    $0x1e,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <barrier_init>:
SYSCALL(barrier_init)
 519:	b8 1f 00 00 00       	mov    $0x1f,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <barrier_check>:
SYSCALL(barrier_check)
 521:	b8 20 00 00 00       	mov    $0x20,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <sleepChan>:
SYSCALL(sleepChan)
 529:	b8 24 00 00 00       	mov    $0x24,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <getChannel>:
SYSCALL(getChannel)
 531:	b8 25 00 00 00       	mov    $0x25,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <sigChan>:
SYSCALL(sigChan)
 539:	b8 26 00 00 00       	mov    $0x26,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <sigOneChan>:
 541:	b8 27 00 00 00       	mov    $0x27,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 549:	55                   	push   %ebp
 54a:	89 e5                	mov    %esp,%ebp
 54c:	83 ec 18             	sub    $0x18,%esp
 54f:	8b 45 0c             	mov    0xc(%ebp),%eax
 552:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 555:	83 ec 04             	sub    $0x4,%esp
 558:	6a 01                	push   $0x1
 55a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 55d:	50                   	push   %eax
 55e:	ff 75 08             	push   0x8(%ebp)
 561:	e8 13 ff ff ff       	call   479 <write>
 566:	83 c4 10             	add    $0x10,%esp
}
 569:	90                   	nop
 56a:	c9                   	leave  
 56b:	c3                   	ret    

0000056c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 579:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 57d:	74 17                	je     596 <printint+0x2a>
 57f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 583:	79 11                	jns    596 <printint+0x2a>
    neg = 1;
 585:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 58c:	8b 45 0c             	mov    0xc(%ebp),%eax
 58f:	f7 d8                	neg    %eax
 591:	89 45 ec             	mov    %eax,-0x14(%ebp)
 594:	eb 06                	jmp    59c <printint+0x30>
  } else {
    x = xx;
 596:	8b 45 0c             	mov    0xc(%ebp),%eax
 599:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 59c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a9:	ba 00 00 00 00       	mov    $0x0,%edx
 5ae:	f7 f1                	div    %ecx
 5b0:	89 d1                	mov    %edx,%ecx
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	8d 50 01             	lea    0x1(%eax),%edx
 5b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5bb:	0f b6 91 64 0e 00 00 	movzbl 0xe64(%ecx),%edx
 5c2:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5cc:	ba 00 00 00 00       	mov    $0x0,%edx
 5d1:	f7 f1                	div    %ecx
 5d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5da:	75 c7                	jne    5a3 <printint+0x37>
  if(neg)
 5dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5e0:	74 2d                	je     60f <printint+0xa3>
    buf[i++] = '-';
 5e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e5:	8d 50 01             	lea    0x1(%eax),%edx
 5e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5f0:	eb 1d                	jmp    60f <printint+0xa3>
    putc(fd, buf[i]);
 5f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	01 d0                	add    %edx,%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	0f be c0             	movsbl %al,%eax
 600:	83 ec 08             	sub    $0x8,%esp
 603:	50                   	push   %eax
 604:	ff 75 08             	push   0x8(%ebp)
 607:	e8 3d ff ff ff       	call   549 <putc>
 60c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 60f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 617:	79 d9                	jns    5f2 <printint+0x86>
}
 619:	90                   	nop
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 622:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 629:	8d 45 0c             	lea    0xc(%ebp),%eax
 62c:	83 c0 04             	add    $0x4,%eax
 62f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 632:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 639:	e9 59 01 00 00       	jmp    797 <printf+0x17b>
    c = fmt[i] & 0xff;
 63e:	8b 55 0c             	mov    0xc(%ebp),%edx
 641:	8b 45 f0             	mov    -0x10(%ebp),%eax
 644:	01 d0                	add    %edx,%eax
 646:	0f b6 00             	movzbl (%eax),%eax
 649:	0f be c0             	movsbl %al,%eax
 64c:	25 ff 00 00 00       	and    $0xff,%eax
 651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 654:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 658:	75 2c                	jne    686 <printf+0x6a>
      if(c == '%'){
 65a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65e:	75 0c                	jne    66c <printf+0x50>
        state = '%';
 660:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 667:	e9 27 01 00 00       	jmp    793 <printf+0x177>
      } else {
        putc(fd, c);
 66c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66f:	0f be c0             	movsbl %al,%eax
 672:	83 ec 08             	sub    $0x8,%esp
 675:	50                   	push   %eax
 676:	ff 75 08             	push   0x8(%ebp)
 679:	e8 cb fe ff ff       	call   549 <putc>
 67e:	83 c4 10             	add    $0x10,%esp
 681:	e9 0d 01 00 00       	jmp    793 <printf+0x177>
      }
    } else if(state == '%'){
 686:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 68a:	0f 85 03 01 00 00    	jne    793 <printf+0x177>
      if(c == 'd'){
 690:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 694:	75 1e                	jne    6b4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 696:	8b 45 e8             	mov    -0x18(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	6a 01                	push   $0x1
 69d:	6a 0a                	push   $0xa
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	push   0x8(%ebp)
 6a3:	e8 c4 fe ff ff       	call   56c <printint>
 6a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6af:	e9 d8 00 00 00       	jmp    78c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b8:	74 06                	je     6c0 <printf+0xa4>
 6ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6be:	75 1e                	jne    6de <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	6a 00                	push   $0x0
 6c7:	6a 10                	push   $0x10
 6c9:	50                   	push   %eax
 6ca:	ff 75 08             	push   0x8(%ebp)
 6cd:	e8 9a fe ff ff       	call   56c <printint>
 6d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d9:	e9 ae 00 00 00       	jmp    78c <printf+0x170>
      } else if(c == 's'){
 6de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e2:	75 43                	jne    727 <printf+0x10b>
        s = (char*)*ap;
 6e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f4:	75 25                	jne    71b <printf+0xff>
          s = "(null)";
 6f6:	c7 45 f4 74 0a 00 00 	movl   $0xa74,-0xc(%ebp)
        while(*s != 0){
 6fd:	eb 1c                	jmp    71b <printf+0xff>
          putc(fd, *s);
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	0f b6 00             	movzbl (%eax),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	50                   	push   %eax
 70c:	ff 75 08             	push   0x8(%ebp)
 70f:	e8 35 fe ff ff       	call   549 <putc>
 714:	83 c4 10             	add    $0x10,%esp
          s++;
 717:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	0f b6 00             	movzbl (%eax),%eax
 721:	84 c0                	test   %al,%al
 723:	75 da                	jne    6ff <printf+0xe3>
 725:	eb 65                	jmp    78c <printf+0x170>
        }
      } else if(c == 'c'){
 727:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72b:	75 1d                	jne    74a <printf+0x12e>
        putc(fd, *ap);
 72d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	0f be c0             	movsbl %al,%eax
 735:	83 ec 08             	sub    $0x8,%esp
 738:	50                   	push   %eax
 739:	ff 75 08             	push   0x8(%ebp)
 73c:	e8 08 fe ff ff       	call   549 <putc>
 741:	83 c4 10             	add    $0x10,%esp
        ap++;
 744:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 748:	eb 42                	jmp    78c <printf+0x170>
      } else if(c == '%'){
 74a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74e:	75 17                	jne    767 <printf+0x14b>
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	83 ec 08             	sub    $0x8,%esp
 759:	50                   	push   %eax
 75a:	ff 75 08             	push   0x8(%ebp)
 75d:	e8 e7 fd ff ff       	call   549 <putc>
 762:	83 c4 10             	add    $0x10,%esp
 765:	eb 25                	jmp    78c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 767:	83 ec 08             	sub    $0x8,%esp
 76a:	6a 25                	push   $0x25
 76c:	ff 75 08             	push   0x8(%ebp)
 76f:	e8 d5 fd ff ff       	call   549 <putc>
 774:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77a:	0f be c0             	movsbl %al,%eax
 77d:	83 ec 08             	sub    $0x8,%esp
 780:	50                   	push   %eax
 781:	ff 75 08             	push   0x8(%ebp)
 784:	e8 c0 fd ff ff       	call   549 <putc>
 789:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 78c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 793:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 797:	8b 55 0c             	mov    0xc(%ebp),%edx
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	01 d0                	add    %edx,%eax
 79f:	0f b6 00             	movzbl (%eax),%eax
 7a2:	84 c0                	test   %al,%al
 7a4:	0f 85 94 fe ff ff    	jne    63e <printf+0x22>
    }
  }
}
 7aa:	90                   	nop
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	83 e8 08             	sub    $0x8,%eax
 7b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	a1 84 0e 00 00       	mov    0xe84,%eax
 7c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c4:	eb 24                	jmp    7ea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7ce:	72 12                	jb     7e2 <free+0x35>
 7d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d6:	77 24                	ja     7fc <free+0x4f>
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7e0:	72 1a                	jb     7fc <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f0:	76 d4                	jbe    7c6 <free+0x19>
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7fa:	73 ca                	jae    7c6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	01 c2                	add    %eax,%edx
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	39 c2                	cmp    %eax,%edx
 815:	75 24                	jne    83b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 50 04             	mov    0x4(%eax),%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	8b 40 04             	mov    0x4(%eax),%eax
 825:	01 c2                	add    %eax,%edx
 827:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	8b 10                	mov    (%eax),%edx
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	89 10                	mov    %edx,(%eax)
 839:	eb 0a                	jmp    845 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 10                	mov    (%eax),%edx
 840:	8b 45 f8             	mov    -0x8(%ebp),%eax
 843:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 40 04             	mov    0x4(%eax),%eax
 84b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	01 d0                	add    %edx,%eax
 857:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 85a:	75 20                	jne    87c <free+0xcf>
    p->s.size += bp->s.size;
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	8b 50 04             	mov    0x4(%eax),%edx
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	01 c2                	add    %eax,%edx
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	8b 10                	mov    (%eax),%edx
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	89 10                	mov    %edx,(%eax)
 87a:	eb 08                	jmp    884 <free+0xd7>
  } else
    p->s.ptr = bp;
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 882:	89 10                	mov    %edx,(%eax)
  freep = p;
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	a3 84 0e 00 00       	mov    %eax,0xe84
}
 88c:	90                   	nop
 88d:	c9                   	leave  
 88e:	c3                   	ret    

0000088f <morecore>:

static Header*
morecore(uint nu)
{
 88f:	55                   	push   %ebp
 890:	89 e5                	mov    %esp,%ebp
 892:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 895:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89c:	77 07                	ja     8a5 <morecore+0x16>
    nu = 4096;
 89e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	c1 e0 03             	shl    $0x3,%eax
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	50                   	push   %eax
 8af:	e8 2d fc ff ff       	call   4e1 <sbrk>
 8b4:	83 c4 10             	add    $0x10,%esp
 8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8be:	75 07                	jne    8c7 <morecore+0x38>
    return 0;
 8c0:	b8 00 00 00 00       	mov    $0x0,%eax
 8c5:	eb 26                	jmp    8ed <morecore+0x5e>
  hp = (Header*)p;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 55 08             	mov    0x8(%ebp),%edx
 8d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	83 c0 08             	add    $0x8,%eax
 8dc:	83 ec 0c             	sub    $0xc,%esp
 8df:	50                   	push   %eax
 8e0:	e8 c8 fe ff ff       	call   7ad <free>
 8e5:	83 c4 10             	add    $0x10,%esp
  return freep;
 8e8:	a1 84 0e 00 00       	mov    0xe84,%eax
}
 8ed:	c9                   	leave  
 8ee:	c3                   	ret    

000008ef <malloc>:

void*
malloc(uint nbytes)
{
 8ef:	55                   	push   %ebp
 8f0:	89 e5                	mov    %esp,%ebp
 8f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f5:	8b 45 08             	mov    0x8(%ebp),%eax
 8f8:	83 c0 07             	add    $0x7,%eax
 8fb:	c1 e8 03             	shr    $0x3,%eax
 8fe:	83 c0 01             	add    $0x1,%eax
 901:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 904:	a1 84 0e 00 00       	mov    0xe84,%eax
 909:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 910:	75 23                	jne    935 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 912:	c7 45 f0 7c 0e 00 00 	movl   $0xe7c,-0x10(%ebp)
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	a3 84 0e 00 00       	mov    %eax,0xe84
 921:	a1 84 0e 00 00       	mov    0xe84,%eax
 926:	a3 7c 0e 00 00       	mov    %eax,0xe7c
    base.s.size = 0;
 92b:	c7 05 80 0e 00 00 00 	movl   $0x0,0xe80
 932:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 935:	8b 45 f0             	mov    -0x10(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 946:	77 4d                	ja     995 <malloc+0xa6>
      if(p->s.size == nunits)
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 40 04             	mov    0x4(%eax),%eax
 94e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 951:	75 0c                	jne    95f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 10                	mov    (%eax),%edx
 958:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95b:	89 10                	mov    %edx,(%eax)
 95d:	eb 26                	jmp    985 <malloc+0x96>
      else {
        p->s.size -= nunits;
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	8b 40 04             	mov    0x4(%eax),%eax
 965:	2b 45 ec             	sub    -0x14(%ebp),%eax
 968:	89 c2                	mov    %eax,%edx
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 40 04             	mov    0x4(%eax),%eax
 976:	c1 e0 03             	shl    $0x3,%eax
 979:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 982:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 985:	8b 45 f0             	mov    -0x10(%ebp),%eax
 988:	a3 84 0e 00 00       	mov    %eax,0xe84
      return (void*)(p + 1);
 98d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 990:	83 c0 08             	add    $0x8,%eax
 993:	eb 3b                	jmp    9d0 <malloc+0xe1>
    }
    if(p == freep)
 995:	a1 84 0e 00 00       	mov    0xe84,%eax
 99a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99d:	75 1e                	jne    9bd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 99f:	83 ec 0c             	sub    $0xc,%esp
 9a2:	ff 75 ec             	push   -0x14(%ebp)
 9a5:	e8 e5 fe ff ff       	call   88f <morecore>
 9aa:	83 c4 10             	add    $0x10,%esp
 9ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b4:	75 07                	jne    9bd <malloc+0xce>
        return 0;
 9b6:	b8 00 00 00 00       	mov    $0x0,%eax
 9bb:	eb 13                	jmp    9d0 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9cb:	e9 6d ff ff ff       	jmp    93d <malloc+0x4e>
  }
}
 9d0:	c9                   	leave  
 9d1:	c3                   	ret    
