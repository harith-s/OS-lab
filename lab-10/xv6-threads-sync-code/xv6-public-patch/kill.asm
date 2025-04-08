
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 7e 08 00 00       	push   $0x87e
  21:	6a 02                	push   $0x2
  23:	e8 a0 04 00 00       	call   4c8 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 d5 02 00 00       	call   305 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 d6 02 00 00       	call   335 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 93 02 00 00       	call   305 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(const char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	push   0xc(%ebp)
 138:	ff 75 08             	push   0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 83 01 00 00       	call   31d <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	push   0x8(%ebp)
 1f8:	e8 48 01 00 00       	call   345 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	ff 75 f4             	push   -0xc(%ebp)
 219:	e8 3f 01 00 00       	call   35d <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	push   -0xc(%ebp)
 22a:	e8 fe 00 00 00       	call   32d <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp

}
 2c4:	90                   	nop
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    

000002c7 <acquireLock>:

void acquireLock(struct lock* l) {
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp

}
 2ca:	90                   	nop
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    

000002cd <releaseLock>:

void releaseLock(struct lock* l) {
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp

}
 2d0:	90                   	nop
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    

000002d3 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp

}
 2d6:	90                   	nop
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    

000002d9 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp

}
 2dc:	90                   	nop
 2dd:	5d                   	pop    %ebp
 2de:	c3                   	ret    

000002df <broadcast>:

void broadcast(struct condvar* cv) {
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp

}
 2e2:	90                   	nop
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    

000002e5 <signal>:

void signal(struct condvar* cv) {
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp

}
 2e8:	90                   	nop
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <semInit>:

void semInit(struct semaphore* s, int initVal) {
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp

}
 2ee:	90                   	nop
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    

000002f1 <semUp>:

void semUp(struct semaphore* s) {
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp

}
 2f4:	90                   	nop
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    

000002f7 <semDown>:

void semDown(struct semaphore* s) {
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp

}
 2fa:	90                   	nop
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    

000002fd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fd:	b8 01 00 00 00       	mov    $0x1,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <exit>:
SYSCALL(exit)
 305:	b8 02 00 00 00       	mov    $0x2,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <wait>:
SYSCALL(wait)
 30d:	b8 03 00 00 00       	mov    $0x3,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <pipe>:
SYSCALL(pipe)
 315:	b8 04 00 00 00       	mov    $0x4,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <read>:
SYSCALL(read)
 31d:	b8 05 00 00 00       	mov    $0x5,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <write>:
SYSCALL(write)
 325:	b8 10 00 00 00       	mov    $0x10,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <close>:
SYSCALL(close)
 32d:	b8 15 00 00 00       	mov    $0x15,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <kill>:
SYSCALL(kill)
 335:	b8 06 00 00 00       	mov    $0x6,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <exec>:
SYSCALL(exec)
 33d:	b8 07 00 00 00       	mov    $0x7,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <open>:
SYSCALL(open)
 345:	b8 0f 00 00 00       	mov    $0xf,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mknod>:
SYSCALL(mknod)
 34d:	b8 11 00 00 00       	mov    $0x11,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <unlink>:
SYSCALL(unlink)
 355:	b8 12 00 00 00       	mov    $0x12,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <fstat>:
SYSCALL(fstat)
 35d:	b8 08 00 00 00       	mov    $0x8,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <link>:
SYSCALL(link)
 365:	b8 13 00 00 00       	mov    $0x13,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <mkdir>:
SYSCALL(mkdir)
 36d:	b8 14 00 00 00       	mov    $0x14,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <chdir>:
SYSCALL(chdir)
 375:	b8 09 00 00 00       	mov    $0x9,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <dup>:
SYSCALL(dup)
 37d:	b8 0a 00 00 00       	mov    $0xa,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <getpid>:
SYSCALL(getpid)
 385:	b8 0b 00 00 00       	mov    $0xb,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <sbrk>:
SYSCALL(sbrk)
 38d:	b8 0c 00 00 00       	mov    $0xc,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <sleep>:
SYSCALL(sleep)
 395:	b8 0d 00 00 00       	mov    $0xd,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <uptime>:
SYSCALL(uptime)
 39d:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <thread_create>:
SYSCALL(thread_create)
 3a5:	b8 16 00 00 00       	mov    $0x16,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <thread_exit>:
SYSCALL(thread_exit)
 3ad:	b8 17 00 00 00       	mov    $0x17,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <thread_join>:
SYSCALL(thread_join)
 3b5:	b8 18 00 00 00       	mov    $0x18,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <waitpid>:
SYSCALL(waitpid)
 3bd:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <barrier_init>:
SYSCALL(barrier_init)
 3c5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <barrier_check>:
SYSCALL(barrier_check)
 3cd:	b8 20 00 00 00       	mov    $0x20,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <sleepChan>:
SYSCALL(sleepChan)
 3d5:	b8 24 00 00 00       	mov    $0x24,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getChannel>:
SYSCALL(getChannel)
 3dd:	b8 25 00 00 00       	mov    $0x25,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sigChan>:
SYSCALL(sigChan)
 3e5:	b8 26 00 00 00       	mov    $0x26,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <sigOneChan>:
 3ed:	b8 27 00 00 00       	mov    $0x27,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 18             	sub    $0x18,%esp
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 401:	83 ec 04             	sub    $0x4,%esp
 404:	6a 01                	push   $0x1
 406:	8d 45 f4             	lea    -0xc(%ebp),%eax
 409:	50                   	push   %eax
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 13 ff ff ff       	call   325 <write>
 412:	83 c4 10             	add    $0x10,%esp
}
 415:	90                   	nop
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 41e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 425:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 429:	74 17                	je     442 <printint+0x2a>
 42b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 42f:	79 11                	jns    442 <printint+0x2a>
    neg = 1;
 431:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	f7 d8                	neg    %eax
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 440:	eb 06                	jmp    448 <printint+0x30>
  } else {
    x = xx;
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 44f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 452:	8b 45 ec             	mov    -0x14(%ebp),%eax
 455:	ba 00 00 00 00       	mov    $0x0,%edx
 45a:	f7 f1                	div    %ecx
 45c:	89 d1                	mov    %edx,%ecx
 45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 461:	8d 50 01             	lea    0x1(%eax),%edx
 464:	89 55 f4             	mov    %edx,-0xc(%ebp)
 467:	0f b6 91 24 0c 00 00 	movzbl 0xc24(%ecx),%edx
 46e:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 472:	8b 4d 10             	mov    0x10(%ebp),%ecx
 475:	8b 45 ec             	mov    -0x14(%ebp),%eax
 478:	ba 00 00 00 00       	mov    $0x0,%edx
 47d:	f7 f1                	div    %ecx
 47f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 486:	75 c7                	jne    44f <printint+0x37>
  if(neg)
 488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48c:	74 2d                	je     4bb <printint+0xa3>
    buf[i++] = '-';
 48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 491:	8d 50 01             	lea    0x1(%eax),%edx
 494:	89 55 f4             	mov    %edx,-0xc(%ebp)
 497:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 49c:	eb 1d                	jmp    4bb <printint+0xa3>
    putc(fd, buf[i]);
 49e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	0f b6 00             	movzbl (%eax),%eax
 4a9:	0f be c0             	movsbl %al,%eax
 4ac:	83 ec 08             	sub    $0x8,%esp
 4af:	50                   	push   %eax
 4b0:	ff 75 08             	push   0x8(%ebp)
 4b3:	e8 3d ff ff ff       	call   3f5 <putc>
 4b8:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c3:	79 d9                	jns    49e <printint+0x86>
}
 4c5:	90                   	nop
 4c6:	c9                   	leave  
 4c7:	c3                   	ret    

000004c8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d8:	83 c0 04             	add    $0x4,%eax
 4db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e5:	e9 59 01 00 00       	jmp    643 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f0:	01 d0                	add    %edx,%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	25 ff 00 00 00       	and    $0xff,%eax
 4fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 500:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 504:	75 2c                	jne    532 <printf+0x6a>
      if(c == '%'){
 506:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50a:	75 0c                	jne    518 <printf+0x50>
        state = '%';
 50c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 513:	e9 27 01 00 00       	jmp    63f <printf+0x177>
      } else {
        putc(fd, c);
 518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	83 ec 08             	sub    $0x8,%esp
 521:	50                   	push   %eax
 522:	ff 75 08             	push   0x8(%ebp)
 525:	e8 cb fe ff ff       	call   3f5 <putc>
 52a:	83 c4 10             	add    $0x10,%esp
 52d:	e9 0d 01 00 00       	jmp    63f <printf+0x177>
      }
    } else if(state == '%'){
 532:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 536:	0f 85 03 01 00 00    	jne    63f <printf+0x177>
      if(c == 'd'){
 53c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 540:	75 1e                	jne    560 <printf+0x98>
        printint(fd, *ap, 10, 1);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	6a 01                	push   $0x1
 549:	6a 0a                	push   $0xa
 54b:	50                   	push   %eax
 54c:	ff 75 08             	push   0x8(%ebp)
 54f:	e8 c4 fe ff ff       	call   418 <printint>
 554:	83 c4 10             	add    $0x10,%esp
        ap++;
 557:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55b:	e9 d8 00 00 00       	jmp    638 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 560:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 564:	74 06                	je     56c <printf+0xa4>
 566:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56a:	75 1e                	jne    58a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	6a 00                	push   $0x0
 573:	6a 10                	push   $0x10
 575:	50                   	push   %eax
 576:	ff 75 08             	push   0x8(%ebp)
 579:	e8 9a fe ff ff       	call   418 <printint>
 57e:	83 c4 10             	add    $0x10,%esp
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	e9 ae 00 00 00       	jmp    638 <printf+0x170>
      } else if(c == 's'){
 58a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58e:	75 43                	jne    5d3 <printf+0x10b>
        s = (char*)*ap;
 590:	8b 45 e8             	mov    -0x18(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a0:	75 25                	jne    5c7 <printf+0xff>
          s = "(null)";
 5a2:	c7 45 f4 92 08 00 00 	movl   $0x892,-0xc(%ebp)
        while(*s != 0){
 5a9:	eb 1c                	jmp    5c7 <printf+0xff>
          putc(fd, *s);
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	83 ec 08             	sub    $0x8,%esp
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	push   0x8(%ebp)
 5bb:	e8 35 fe ff ff       	call   3f5 <putc>
 5c0:	83 c4 10             	add    $0x10,%esp
          s++;
 5c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	84 c0                	test   %al,%al
 5cf:	75 da                	jne    5ab <printf+0xe3>
 5d1:	eb 65                	jmp    638 <printf+0x170>
        }
      } else if(c == 'c'){
 5d3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d7:	75 1d                	jne    5f6 <printf+0x12e>
        putc(fd, *ap);
 5d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	push   0x8(%ebp)
 5e8:	e8 08 fe ff ff       	call   3f5 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	eb 42                	jmp    638 <printf+0x170>
      } else if(c == '%'){
 5f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fa:	75 17                	jne    613 <printf+0x14b>
        putc(fd, c);
 5fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ff:	0f be c0             	movsbl %al,%eax
 602:	83 ec 08             	sub    $0x8,%esp
 605:	50                   	push   %eax
 606:	ff 75 08             	push   0x8(%ebp)
 609:	e8 e7 fd ff ff       	call   3f5 <putc>
 60e:	83 c4 10             	add    $0x10,%esp
 611:	eb 25                	jmp    638 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 613:	83 ec 08             	sub    $0x8,%esp
 616:	6a 25                	push   $0x25
 618:	ff 75 08             	push   0x8(%ebp)
 61b:	e8 d5 fd ff ff       	call   3f5 <putc>
 620:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	83 ec 08             	sub    $0x8,%esp
 62c:	50                   	push   %eax
 62d:	ff 75 08             	push   0x8(%ebp)
 630:	e8 c0 fd ff ff       	call   3f5 <putc>
 635:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 638:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 63f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 643:	8b 55 0c             	mov    0xc(%ebp),%edx
 646:	8b 45 f0             	mov    -0x10(%ebp),%eax
 649:	01 d0                	add    %edx,%eax
 64b:	0f b6 00             	movzbl (%eax),%eax
 64e:	84 c0                	test   %al,%al
 650:	0f 85 94 fe ff ff    	jne    4ea <printf+0x22>
    }
  }
}
 656:	90                   	nop
 657:	c9                   	leave  
 658:	c3                   	ret    

00000659 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	83 e8 08             	sub    $0x8,%eax
 665:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	a1 40 0c 00 00       	mov    0xc40,%eax
 66d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 670:	eb 24                	jmp    696 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 67a:	72 12                	jb     68e <free+0x35>
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	77 24                	ja     6a8 <free+0x4f>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68c:	72 1a                	jb     6a8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69c:	76 d4                	jbe    672 <free+0x19>
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a6:	73 ca                	jae    672 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	39 c2                	cmp    %eax,%edx
 6c1:	75 24                	jne    6e7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	01 c2                	add    %eax,%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 0a                	jmp    6f1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 40 04             	mov    0x4(%eax),%eax
 6f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 706:	75 20                	jne    728 <free+0xcf>
    p->s.size += bp->s.size;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 10                	mov    (%eax),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 10                	mov    %edx,(%eax)
 726:	eb 08                	jmp    730 <free+0xd7>
  } else
    p->s.ptr = bp;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72e:	89 10                	mov    %edx,(%eax)
  freep = p;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 738:	90                   	nop
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <morecore>:

static Header*
morecore(uint nu)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 741:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 748:	77 07                	ja     751 <morecore+0x16>
    nu = 4096;
 74a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	c1 e0 03             	shl    $0x3,%eax
 757:	83 ec 0c             	sub    $0xc,%esp
 75a:	50                   	push   %eax
 75b:	e8 2d fc ff ff       	call   38d <sbrk>
 760:	83 c4 10             	add    $0x10,%esp
 763:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 766:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76a:	75 07                	jne    773 <morecore+0x38>
    return 0;
 76c:	b8 00 00 00 00       	mov    $0x0,%eax
 771:	eb 26                	jmp    799 <morecore+0x5e>
  hp = (Header*)p;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 779:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77c:	8b 55 08             	mov    0x8(%ebp),%edx
 77f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	83 c0 08             	add    $0x8,%eax
 788:	83 ec 0c             	sub    $0xc,%esp
 78b:	50                   	push   %eax
 78c:	e8 c8 fe ff ff       	call   659 <free>
 791:	83 c4 10             	add    $0x10,%esp
  return freep;
 794:	a1 40 0c 00 00       	mov    0xc40,%eax
}
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <malloc>:

void*
malloc(uint nbytes)
{
 79b:	55                   	push   %ebp
 79c:	89 e5                	mov    %esp,%ebp
 79e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	83 c0 07             	add    $0x7,%eax
 7a7:	c1 e8 03             	shr    $0x3,%eax
 7aa:	83 c0 01             	add    $0x1,%eax
 7ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b0:	a1 40 0c 00 00       	mov    0xc40,%eax
 7b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bc:	75 23                	jne    7e1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7be:	c7 45 f0 38 0c 00 00 	movl   $0xc38,-0x10(%ebp)
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 40 0c 00 00       	mov    %eax,0xc40
 7cd:	a1 40 0c 00 00       	mov    0xc40,%eax
 7d2:	a3 38 0c 00 00       	mov    %eax,0xc38
    base.s.size = 0;
 7d7:	c7 05 3c 0c 00 00 00 	movl   $0x0,0xc3c
 7de:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f2:	77 4d                	ja     841 <malloc+0xa6>
      if(p->s.size == nunits)
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7fd:	75 0c                	jne    80b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 10                	mov    (%eax),%edx
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	89 10                	mov    %edx,(%eax)
 809:	eb 26                	jmp    831 <malloc+0x96>
      else {
        p->s.size -= nunits;
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	2b 45 ec             	sub    -0x14(%ebp),%eax
 814:	89 c2                	mov    %eax,%edx
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	c1 e0 03             	shl    $0x3,%eax
 825:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	a3 40 0c 00 00       	mov    %eax,0xc40
      return (void*)(p + 1);
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	83 c0 08             	add    $0x8,%eax
 83f:	eb 3b                	jmp    87c <malloc+0xe1>
    }
    if(p == freep)
 841:	a1 40 0c 00 00       	mov    0xc40,%eax
 846:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 849:	75 1e                	jne    869 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	ff 75 ec             	push   -0x14(%ebp)
 851:	e8 e5 fe ff ff       	call   73b <morecore>
 856:	83 c4 10             	add    $0x10,%esp
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 860:	75 07                	jne    869 <malloc+0xce>
        return 0;
 862:	b8 00 00 00 00       	mov    $0x0,%eax
 867:	eb 13                	jmp    87c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 00                	mov    (%eax),%eax
 874:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 877:	e9 6d ff ff ff       	jmp    7e9 <malloc+0x4e>
  }
}
 87c:	c9                   	leave  
 87d:	c3                   	ret    
