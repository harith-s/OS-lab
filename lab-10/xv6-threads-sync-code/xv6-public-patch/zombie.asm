
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 a1 02 00 00       	call   2b7 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 2b 03 00 00       	call   34f <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 93 02 00 00       	call   2bf <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 42 01             	lea    0x1(%edx),%eax
  65:	89 45 0c             	mov    %eax,0xc(%ebp)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8d 48 01             	lea    0x1(%eax),%ecx
  6e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(const char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	push   0xc(%ebp)
  f2:	ff 75 08             	push   0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 45 fc             	cmp    %al,-0x4(%ebp)
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 83 01 00 00       	call   2d7 <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18f:	7f b3                	jg     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
      break;
 193:	90                   	nop
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	push   0x8(%ebp)
 1b2:	e8 48 01 00 00       	call   2ff <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	push   0xc(%ebp)
 1d0:	ff 75 f4             	push   -0xc(%ebp)
 1d3:	e8 3f 01 00 00       	call   317 <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	push   -0xc(%ebp)
 1e4:	e8 fe 00 00 00       	call   2e7 <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 55 f8             	mov    -0x8(%ebp),%edx
 255:	8d 42 01             	lea    0x1(%edx),%eax
 258:	89 45 f8             	mov    %eax,-0x8(%ebp)
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25e:	8d 48 01             	lea    0x1(%eax),%ecx
 261:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp

}
 27e:	90                   	nop
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    

00000281 <acquireLock>:

void acquireLock(struct lock* l) {
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp

}
 284:	90                   	nop
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    

00000287 <releaseLock>:

void releaseLock(struct lock* l) {
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp

}
 28a:	90                   	nop
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    

0000028d <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp

}
 290:	90                   	nop
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    

00000293 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp

}
 296:	90                   	nop
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    

00000299 <broadcast>:

void broadcast(struct condvar* cv) {
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp

}
 29c:	90                   	nop
 29d:	5d                   	pop    %ebp
 29e:	c3                   	ret    

0000029f <signal>:

void signal(struct condvar* cv) {
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp

}
 2a2:	90                   	nop
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret    

000002a5 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp

}
 2a8:	90                   	nop
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <semUp>:

void semUp(struct semaphore* s) {
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp

}
 2ae:	90                   	nop
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    

000002b1 <semDown>:

void semDown(struct semaphore* s) {
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp

}
 2b4:	90                   	nop
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    

000002b7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b7:	b8 01 00 00 00       	mov    $0x1,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <exit>:
SYSCALL(exit)
 2bf:	b8 02 00 00 00       	mov    $0x2,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <wait>:
SYSCALL(wait)
 2c7:	b8 03 00 00 00       	mov    $0x3,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <pipe>:
SYSCALL(pipe)
 2cf:	b8 04 00 00 00       	mov    $0x4,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <read>:
SYSCALL(read)
 2d7:	b8 05 00 00 00       	mov    $0x5,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <write>:
SYSCALL(write)
 2df:	b8 10 00 00 00       	mov    $0x10,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <close>:
SYSCALL(close)
 2e7:	b8 15 00 00 00       	mov    $0x15,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <kill>:
SYSCALL(kill)
 2ef:	b8 06 00 00 00       	mov    $0x6,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <exec>:
SYSCALL(exec)
 2f7:	b8 07 00 00 00       	mov    $0x7,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <open>:
SYSCALL(open)
 2ff:	b8 0f 00 00 00       	mov    $0xf,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <mknod>:
SYSCALL(mknod)
 307:	b8 11 00 00 00       	mov    $0x11,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <unlink>:
SYSCALL(unlink)
 30f:	b8 12 00 00 00       	mov    $0x12,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <fstat>:
SYSCALL(fstat)
 317:	b8 08 00 00 00       	mov    $0x8,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <link>:
SYSCALL(link)
 31f:	b8 13 00 00 00       	mov    $0x13,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <mkdir>:
SYSCALL(mkdir)
 327:	b8 14 00 00 00       	mov    $0x14,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <chdir>:
SYSCALL(chdir)
 32f:	b8 09 00 00 00       	mov    $0x9,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <dup>:
SYSCALL(dup)
 337:	b8 0a 00 00 00       	mov    $0xa,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <getpid>:
SYSCALL(getpid)
 33f:	b8 0b 00 00 00       	mov    $0xb,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <sbrk>:
SYSCALL(sbrk)
 347:	b8 0c 00 00 00       	mov    $0xc,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sleep>:
SYSCALL(sleep)
 34f:	b8 0d 00 00 00       	mov    $0xd,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <uptime>:
SYSCALL(uptime)
 357:	b8 0e 00 00 00       	mov    $0xe,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <thread_create>:
SYSCALL(thread_create)
 35f:	b8 16 00 00 00       	mov    $0x16,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <thread_exit>:
SYSCALL(thread_exit)
 367:	b8 17 00 00 00       	mov    $0x17,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <thread_join>:
SYSCALL(thread_join)
 36f:	b8 18 00 00 00       	mov    $0x18,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <waitpid>:
SYSCALL(waitpid)
 377:	b8 1e 00 00 00       	mov    $0x1e,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <barrier_init>:
SYSCALL(barrier_init)
 37f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <barrier_check>:
SYSCALL(barrier_check)
 387:	b8 20 00 00 00       	mov    $0x20,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <sleepChan>:
SYSCALL(sleepChan)
 38f:	b8 24 00 00 00       	mov    $0x24,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <getChannel>:
SYSCALL(getChannel)
 397:	b8 25 00 00 00       	mov    $0x25,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sigChan>:
SYSCALL(sigChan)
 39f:	b8 26 00 00 00       	mov    $0x26,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <sigOneChan>:
 3a7:	b8 27 00 00 00       	mov    $0x27,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 18             	sub    $0x18,%esp
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	6a 01                	push   $0x1
 3c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c3:	50                   	push   %eax
 3c4:	ff 75 08             	push   0x8(%ebp)
 3c7:	e8 13 ff ff ff       	call   2df <write>
 3cc:	83 c4 10             	add    $0x10,%esp
}
 3cf:	90                   	nop
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e3:	74 17                	je     3fc <printint+0x2a>
 3e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e9:	79 11                	jns    3fc <printint+0x2a>
    neg = 1;
 3eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	f7 d8                	neg    %eax
 3f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fa:	eb 06                	jmp    402 <printint+0x30>
  } else {
    x = xx;
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 409:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
 414:	f7 f1                	div    %ecx
 416:	89 d1                	mov    %edx,%ecx
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	8d 50 01             	lea    0x1(%eax),%edx
 41e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 421:	0f b6 91 c4 0b 00 00 	movzbl 0xbc4(%ecx),%edx
 428:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 42c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 42f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 432:	ba 00 00 00 00       	mov    $0x0,%edx
 437:	f7 f1                	div    %ecx
 439:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 440:	75 c7                	jne    409 <printint+0x37>
  if(neg)
 442:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 446:	74 2d                	je     475 <printint+0xa3>
    buf[i++] = '-';
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	8d 50 01             	lea    0x1(%eax),%edx
 44e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 451:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 456:	eb 1d                	jmp    475 <printint+0xa3>
    putc(fd, buf[i]);
 458:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45e:	01 d0                	add    %edx,%eax
 460:	0f b6 00             	movzbl (%eax),%eax
 463:	0f be c0             	movsbl %al,%eax
 466:	83 ec 08             	sub    $0x8,%esp
 469:	50                   	push   %eax
 46a:	ff 75 08             	push   0x8(%ebp)
 46d:	e8 3d ff ff ff       	call   3af <putc>
 472:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 475:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47d:	79 d9                	jns    458 <printint+0x86>
}
 47f:	90                   	nop
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 488:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48f:	8d 45 0c             	lea    0xc(%ebp),%eax
 492:	83 c0 04             	add    $0x4,%eax
 495:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49f:	e9 59 01 00 00       	jmp    5fd <printf+0x17b>
    c = fmt[i] & 0xff;
 4a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	25 ff 00 00 00       	and    $0xff,%eax
 4b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4be:	75 2c                	jne    4ec <printf+0x6a>
      if(c == '%'){
 4c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c4:	75 0c                	jne    4d2 <printf+0x50>
        state = '%';
 4c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cd:	e9 27 01 00 00       	jmp    5f9 <printf+0x177>
      } else {
        putc(fd, c);
 4d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	83 ec 08             	sub    $0x8,%esp
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	push   0x8(%ebp)
 4df:	e8 cb fe ff ff       	call   3af <putc>
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	e9 0d 01 00 00       	jmp    5f9 <printf+0x177>
      }
    } else if(state == '%'){
 4ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f0:	0f 85 03 01 00 00    	jne    5f9 <printf+0x177>
      if(c == 'd'){
 4f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fa:	75 1e                	jne    51a <printf+0x98>
        printint(fd, *ap, 10, 1);
 4fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ff:	8b 00                	mov    (%eax),%eax
 501:	6a 01                	push   $0x1
 503:	6a 0a                	push   $0xa
 505:	50                   	push   %eax
 506:	ff 75 08             	push   0x8(%ebp)
 509:	e8 c4 fe ff ff       	call   3d2 <printint>
 50e:	83 c4 10             	add    $0x10,%esp
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 515:	e9 d8 00 00 00       	jmp    5f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 51a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51e:	74 06                	je     526 <printf+0xa4>
 520:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 524:	75 1e                	jne    544 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	6a 00                	push   $0x0
 52d:	6a 10                	push   $0x10
 52f:	50                   	push   %eax
 530:	ff 75 08             	push   0x8(%ebp)
 533:	e8 9a fe ff ff       	call   3d2 <printint>
 538:	83 c4 10             	add    $0x10,%esp
        ap++;
 53b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53f:	e9 ae 00 00 00       	jmp    5f2 <printf+0x170>
      } else if(c == 's'){
 544:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 548:	75 43                	jne    58d <printf+0x10b>
        s = (char*)*ap;
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55a:	75 25                	jne    581 <printf+0xff>
          s = "(null)";
 55c:	c7 45 f4 38 08 00 00 	movl   $0x838,-0xc(%ebp)
        while(*s != 0){
 563:	eb 1c                	jmp    581 <printf+0xff>
          putc(fd, *s);
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	83 ec 08             	sub    $0x8,%esp
 571:	50                   	push   %eax
 572:	ff 75 08             	push   0x8(%ebp)
 575:	e8 35 fe ff ff       	call   3af <putc>
 57a:	83 c4 10             	add    $0x10,%esp
          s++;
 57d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	84 c0                	test   %al,%al
 589:	75 da                	jne    565 <printf+0xe3>
 58b:	eb 65                	jmp    5f2 <printf+0x170>
        }
      } else if(c == 'c'){
 58d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 591:	75 1d                	jne    5b0 <printf+0x12e>
        putc(fd, *ap);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	push   0x8(%ebp)
 5a2:	e8 08 fe ff ff       	call   3af <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	eb 42                	jmp    5f2 <printf+0x170>
      } else if(c == '%'){
 5b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b4:	75 17                	jne    5cd <printf+0x14b>
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	83 ec 08             	sub    $0x8,%esp
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	push   0x8(%ebp)
 5c3:	e8 e7 fd ff ff       	call   3af <putc>
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	eb 25                	jmp    5f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	6a 25                	push   $0x25
 5d2:	ff 75 08             	push   0x8(%ebp)
 5d5:	e8 d5 fd ff ff       	call   3af <putc>
 5da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	83 ec 08             	sub    $0x8,%esp
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	push   0x8(%ebp)
 5ea:	e8 c0 fd ff ff       	call   3af <putc>
 5ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 600:	8b 45 f0             	mov    -0x10(%ebp),%eax
 603:	01 d0                	add    %edx,%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	84 c0                	test   %al,%al
 60a:	0f 85 94 fe ff ff    	jne    4a4 <printf+0x22>
    }
  }
}
 610:	90                   	nop
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 613:	55                   	push   %ebp
 614:	89 e5                	mov    %esp,%ebp
 616:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
 61c:	83 e8 08             	sub    $0x8,%eax
 61f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 622:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 627:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62a:	eb 24                	jmp    650 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 634:	72 12                	jb     648 <free+0x35>
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63c:	77 24                	ja     662 <free+0x4f>
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 646:	72 1a                	jb     662 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 656:	76 d4                	jbe    62c <free+0x19>
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 660:	73 ca                	jae    62c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 40 04             	mov    0x4(%eax),%eax
 668:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	01 c2                	add    %eax,%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	39 c2                	cmp    %eax,%edx
 67b:	75 24                	jne    6a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	8b 50 04             	mov    0x4(%eax),%edx
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	8b 40 04             	mov    0x4(%eax),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 10                	mov    %edx,(%eax)
 69f:	eb 0a                	jmp    6ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 10                	mov    (%eax),%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 40 04             	mov    0x4(%eax),%eax
 6b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	01 d0                	add    %edx,%eax
 6bd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c0:	75 20                	jne    6e2 <free+0xcf>
    p->s.size += bp->s.size;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 40 04             	mov    0x4(%eax),%eax
 6ce:	01 c2                	add    %eax,%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
 6e0:	eb 08                	jmp    6ea <free+0xd7>
  } else
    p->s.ptr = bp;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 6f2:	90                   	nop
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <morecore>:

static Header*
morecore(uint nu)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 702:	77 07                	ja     70b <morecore+0x16>
    nu = 4096;
 704:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	c1 e0 03             	shl    $0x3,%eax
 711:	83 ec 0c             	sub    $0xc,%esp
 714:	50                   	push   %eax
 715:	e8 2d fc ff ff       	call   347 <sbrk>
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 720:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 724:	75 07                	jne    72d <morecore+0x38>
    return 0;
 726:	b8 00 00 00 00       	mov    $0x0,%eax
 72b:	eb 26                	jmp    753 <morecore+0x5e>
  hp = (Header*)p;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 55 08             	mov    0x8(%ebp),%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	83 c0 08             	add    $0x8,%eax
 742:	83 ec 0c             	sub    $0xc,%esp
 745:	50                   	push   %eax
 746:	e8 c8 fe ff ff       	call   613 <free>
 74b:	83 c4 10             	add    $0x10,%esp
  return freep;
 74e:	a1 e0 0b 00 00       	mov    0xbe0,%eax
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <malloc>:

void*
malloc(uint nbytes)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	83 c0 07             	add    $0x7,%eax
 761:	c1 e8 03             	shr    $0x3,%eax
 764:	83 c0 01             	add    $0x1,%eax
 767:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76a:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 76f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 772:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 776:	75 23                	jne    79b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 778:	c7 45 f0 d8 0b 00 00 	movl   $0xbd8,-0x10(%ebp)
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 e0 0b 00 00       	mov    %eax,0xbe0
 787:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 78c:	a3 d8 0b 00 00       	mov    %eax,0xbd8
    base.s.size = 0;
 791:	c7 05 dc 0b 00 00 00 	movl   $0x0,0xbdc
 798:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ac:	77 4d                	ja     7fb <malloc+0xa6>
      if(p->s.size == nunits)
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7b7:	75 0c                	jne    7c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 10                	mov    (%eax),%edx
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	89 10                	mov    %edx,(%eax)
 7c3:	eb 26                	jmp    7eb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ce:	89 c2                	mov    %eax,%edx
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	8b 40 04             	mov    0x4(%eax),%eax
 7dc:	c1 e0 03             	shl    $0x3,%eax
 7df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	a3 e0 0b 00 00       	mov    %eax,0xbe0
      return (void*)(p + 1);
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	83 c0 08             	add    $0x8,%eax
 7f9:	eb 3b                	jmp    836 <malloc+0xe1>
    }
    if(p == freep)
 7fb:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 800:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 803:	75 1e                	jne    823 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 805:	83 ec 0c             	sub    $0xc,%esp
 808:	ff 75 ec             	push   -0x14(%ebp)
 80b:	e8 e5 fe ff ff       	call   6f5 <morecore>
 810:	83 c4 10             	add    $0x10,%esp
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
 816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81a:	75 07                	jne    823 <malloc+0xce>
        return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 13                	jmp    836 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 831:	e9 6d ff ff ff       	jmp    7a3 <malloc+0x4e>
  }
}
 836:	c9                   	leave  
 837:	c3                   	ret    
