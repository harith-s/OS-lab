
_t_sleepwake:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp

    int openChan = getChannel();
  11:	e8 de 03 00 00       	call   3f4 <getChannel>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = fork();
  19:	e8 f6 02 00 00       	call   314 <fork>
  1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (ret == 0) {
  21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  25:	75 23                	jne    4a <main+0x4a>
        sleep(200);
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	68 c8 00 00 00       	push   $0xc8
  2f:	e8 78 03 00 00       	call   3ac <sleep>
  34:	83 c4 10             	add    $0x10,%esp
        sigChan(openChan);
  37:	83 ec 0c             	sub    $0xc,%esp
  3a:	ff 75 f4             	push   -0xc(%ebp)
  3d:	e8 ba 03 00 00       	call   3fc <sigChan>
  42:	83 c4 10             	add    $0x10,%esp
        exit();
  45:	e8 d2 02 00 00       	call   31c <exit>
    }
    else {
        printf(1,"going to sleep on channel %d\n",openChan);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 f4             	push   -0xc(%ebp)
  50:	68 95 08 00 00       	push   $0x895
  55:	6a 01                	push   $0x1
  57:	e8 83 04 00 00       	call   4df <printf>
  5c:	83 c4 10             	add    $0x10,%esp
        sleepChan(openChan);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	ff 75 f4             	push   -0xc(%ebp)
  65:	e8 82 03 00 00       	call   3ec <sleepChan>
  6a:	83 c4 10             	add    $0x10,%esp
        printf(1,"Woken up by child\n");
  6d:	83 ec 08             	sub    $0x8,%esp
  70:	68 b3 08 00 00       	push   $0x8b3
  75:	6a 01                	push   $0x1
  77:	e8 63 04 00 00       	call   4df <printf>
  7c:	83 c4 10             	add    $0x10,%esp
        wait();
  7f:	e8 a0 02 00 00       	call   324 <wait>
    }
    exit();
  84:	e8 93 02 00 00       	call   31c <exit>

00000089 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  8c:	57                   	push   %edi
  8d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  91:	8b 55 10             	mov    0x10(%ebp),%edx
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	89 cb                	mov    %ecx,%ebx
  99:	89 df                	mov    %ebx,%edi
  9b:	89 d1                	mov    %edx,%ecx
  9d:	fc                   	cld    
  9e:	f3 aa                	rep stos %al,%es:(%edi)
  a0:	89 ca                	mov    %ecx,%edx
  a2:	89 fb                	mov    %edi,%ebx
  a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  aa:	90                   	nop
  ab:	5b                   	pop    %ebx
  ac:	5f                   	pop    %edi
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  bb:	90                   	nop
  bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  bf:	8d 42 01             	lea    0x1(%edx),%eax
  c2:	89 45 0c             	mov    %eax,0xc(%ebp)
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	8d 48 01             	lea    0x1(%eax),%ecx
  cb:	89 4d 08             	mov    %ecx,0x8(%ebp)
  ce:	0f b6 12             	movzbl (%edx),%edx
  d1:	88 10                	mov    %dl,(%eax)
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	84 c0                	test   %al,%al
  d8:	75 e2                	jne    bc <strcpy+0xd>
    ;
  return os;
  da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dd:	c9                   	leave  
  de:	c3                   	ret    

000000df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e2:	eb 08                	jmp    ec <strcmp+0xd>
    p++, q++;
  e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	84 c0                	test   %al,%al
  f4:	74 10                	je     106 <strcmp+0x27>
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 10             	movzbl (%eax),%edx
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	38 c2                	cmp    %al,%dl
 104:	74 de                	je     e4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	0f b6 d0             	movzbl %al,%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	0f b6 c0             	movzbl %al,%eax
 118:	29 c2                	sub    %eax,%edx
 11a:	89 d0                	mov    %edx,%eax
}
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    

0000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12b:	eb 04                	jmp    131 <strlen+0x13>
 12d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 131:	8b 55 fc             	mov    -0x4(%ebp),%edx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	01 d0                	add    %edx,%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	84 c0                	test   %al,%al
 13e:	75 ed                	jne    12d <strlen+0xf>
    ;
  return n;
 140:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <memset>:

void*
memset(void *dst, int c, uint n)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	50                   	push   %eax
 14c:	ff 75 0c             	push   0xc(%ebp)
 14f:	ff 75 08             	push   0x8(%ebp)
 152:	e8 32 ff ff ff       	call   89 <stosb>
 157:	83 c4 0c             	add    $0xc,%esp
  return dst;
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strchr>:

char*
strchr(const char *s, char c)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	83 ec 04             	sub    $0x4,%esp
 165:	8b 45 0c             	mov    0xc(%ebp),%eax
 168:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16b:	eb 14                	jmp    181 <strchr+0x22>
    if(*s == c)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	38 45 fc             	cmp    %al,-0x4(%ebp)
 176:	75 05                	jne    17d <strchr+0x1e>
      return (char*)s;
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	eb 13                	jmp    190 <strchr+0x31>
  for(; *s; s++)
 17d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strchr+0xe>
  return 0;
 18b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <gets>:

char*
gets(char *buf, int max)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19f:	eb 42                	jmp    1e3 <gets+0x51>
    cc = read(0, &c, 1);
 1a1:	83 ec 04             	sub    $0x4,%esp
 1a4:	6a 01                	push   $0x1
 1a6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a9:	50                   	push   %eax
 1aa:	6a 00                	push   $0x0
 1ac:	e8 83 01 00 00       	call   334 <read>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bb:	7e 33                	jle    1f0 <gets+0x5e>
      break;
    buf[i++] = c;
 1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c0:	8d 50 01             	lea    0x1(%eax),%edx
 1c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c6:	89 c2                	mov    %eax,%edx
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	01 c2                	add    %eax,%edx
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d7:	3c 0a                	cmp    $0xa,%al
 1d9:	74 16                	je     1f1 <gets+0x5f>
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0d                	cmp    $0xd,%al
 1e1:	74 0e                	je     1f1 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e6:	83 c0 01             	add    $0x1,%eax
 1e9:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ec:	7f b3                	jg     1a1 <gets+0xf>
 1ee:	eb 01                	jmp    1f1 <gets+0x5f>
      break;
 1f0:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stat>:

int
stat(const char *n, struct stat *st)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	6a 00                	push   $0x0
 20c:	ff 75 08             	push   0x8(%ebp)
 20f:	e8 48 01 00 00       	call   35c <open>
 214:	83 c4 10             	add    $0x10,%esp
 217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21e:	79 07                	jns    227 <stat+0x26>
    return -1;
 220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 225:	eb 25                	jmp    24c <stat+0x4b>
  r = fstat(fd, st);
 227:	83 ec 08             	sub    $0x8,%esp
 22a:	ff 75 0c             	push   0xc(%ebp)
 22d:	ff 75 f4             	push   -0xc(%ebp)
 230:	e8 3f 01 00 00       	call   374 <fstat>
 235:	83 c4 10             	add    $0x10,%esp
 238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23b:	83 ec 0c             	sub    $0xc,%esp
 23e:	ff 75 f4             	push   -0xc(%ebp)
 241:	e8 fe 00 00 00       	call   344 <close>
 246:	83 c4 10             	add    $0x10,%esp
  return r;
 249:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <atoi>:

int
atoi(const char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25b:	eb 25                	jmp    282 <atoi+0x34>
    n = n*10 + *s++ - '0';
 25d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	c1 e0 02             	shl    $0x2,%eax
 265:	01 d0                	add    %edx,%eax
 267:	01 c0                	add    %eax,%eax
 269:	89 c1                	mov    %eax,%ecx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	8d 50 01             	lea    0x1(%eax),%edx
 271:	89 55 08             	mov    %edx,0x8(%ebp)
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	0f be c0             	movsbl %al,%eax
 27a:	01 c8                	add    %ecx,%eax
 27c:	83 e8 30             	sub    $0x30,%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	3c 2f                	cmp    $0x2f,%al
 28a:	7e 0a                	jle    296 <atoi+0x48>
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	0f b6 00             	movzbl (%eax),%eax
 292:	3c 39                	cmp    $0x39,%al
 294:	7e c7                	jle    25d <atoi+0xf>
  return n;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ad:	eb 17                	jmp    2c6 <memmove+0x2b>
    *dst++ = *src++;
 2af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b2:	8d 42 01             	lea    0x1(%edx),%eax
 2b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2bb:	8d 48 01             	lea    0x1(%eax),%ecx
 2be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2c1:	0f b6 12             	movzbl (%edx),%edx
 2c4:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2c6:	8b 45 10             	mov    0x10(%ebp),%eax
 2c9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2cc:	89 55 10             	mov    %edx,0x10(%ebp)
 2cf:	85 c0                	test   %eax,%eax
 2d1:	7f dc                	jg     2af <memmove+0x14>
  return vdst;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp

}
 2db:	90                   	nop
 2dc:	5d                   	pop    %ebp
 2dd:	c3                   	ret    

000002de <acquireLock>:

void acquireLock(struct lock* l) {
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp

}
 2e1:	90                   	nop
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret    

000002e4 <releaseLock>:

void releaseLock(struct lock* l) {
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp

}
 2e7:	90                   	nop
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp

}
 2ed:	90                   	nop
 2ee:	5d                   	pop    %ebp
 2ef:	c3                   	ret    

000002f0 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp

}
 2f3:	90                   	nop
 2f4:	5d                   	pop    %ebp
 2f5:	c3                   	ret    

000002f6 <broadcast>:

void broadcast(struct condvar* cv) {
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp

}
 2f9:	90                   	nop
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret    

000002fc <signal>:

void signal(struct condvar* cv) {
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp

}
 2ff:	90                   	nop
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp

}
 305:	90                   	nop
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    

00000308 <semUp>:

void semUp(struct semaphore* s) {
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp

}
 30b:	90                   	nop
 30c:	5d                   	pop    %ebp
 30d:	c3                   	ret    

0000030e <semDown>:

void semDown(struct semaphore* s) {
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp

}
 311:	90                   	nop
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    

00000314 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <exit>:
SYSCALL(exit)
 31c:	b8 02 00 00 00       	mov    $0x2,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <wait>:
SYSCALL(wait)
 324:	b8 03 00 00 00       	mov    $0x3,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <pipe>:
SYSCALL(pipe)
 32c:	b8 04 00 00 00       	mov    $0x4,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <read>:
SYSCALL(read)
 334:	b8 05 00 00 00       	mov    $0x5,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <write>:
SYSCALL(write)
 33c:	b8 10 00 00 00       	mov    $0x10,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <close>:
SYSCALL(close)
 344:	b8 15 00 00 00       	mov    $0x15,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <kill>:
SYSCALL(kill)
 34c:	b8 06 00 00 00       	mov    $0x6,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <exec>:
SYSCALL(exec)
 354:	b8 07 00 00 00       	mov    $0x7,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <open>:
SYSCALL(open)
 35c:	b8 0f 00 00 00       	mov    $0xf,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <mknod>:
SYSCALL(mknod)
 364:	b8 11 00 00 00       	mov    $0x11,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <unlink>:
SYSCALL(unlink)
 36c:	b8 12 00 00 00       	mov    $0x12,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <fstat>:
SYSCALL(fstat)
 374:	b8 08 00 00 00       	mov    $0x8,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <link>:
SYSCALL(link)
 37c:	b8 13 00 00 00       	mov    $0x13,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <mkdir>:
SYSCALL(mkdir)
 384:	b8 14 00 00 00       	mov    $0x14,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <chdir>:
SYSCALL(chdir)
 38c:	b8 09 00 00 00       	mov    $0x9,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <dup>:
SYSCALL(dup)
 394:	b8 0a 00 00 00       	mov    $0xa,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <getpid>:
SYSCALL(getpid)
 39c:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <sbrk>:
SYSCALL(sbrk)
 3a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <sleep>:
SYSCALL(sleep)
 3ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <uptime>:
SYSCALL(uptime)
 3b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <thread_create>:
SYSCALL(thread_create)
 3bc:	b8 16 00 00 00       	mov    $0x16,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <thread_exit>:
SYSCALL(thread_exit)
 3c4:	b8 17 00 00 00       	mov    $0x17,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <thread_join>:
SYSCALL(thread_join)
 3cc:	b8 18 00 00 00       	mov    $0x18,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <waitpid>:
SYSCALL(waitpid)
 3d4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <barrier_init>:
SYSCALL(barrier_init)
 3dc:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <barrier_check>:
SYSCALL(barrier_check)
 3e4:	b8 20 00 00 00       	mov    $0x20,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <sleepChan>:
SYSCALL(sleepChan)
 3ec:	b8 24 00 00 00       	mov    $0x24,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getChannel>:
SYSCALL(getChannel)
 3f4:	b8 25 00 00 00       	mov    $0x25,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sigChan>:
SYSCALL(sigChan)
 3fc:	b8 26 00 00 00       	mov    $0x26,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sigOneChan>:
 404:	b8 27 00 00 00       	mov    $0x27,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 18             	sub    $0x18,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 418:	83 ec 04             	sub    $0x4,%esp
 41b:	6a 01                	push   $0x1
 41d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 420:	50                   	push   %eax
 421:	ff 75 08             	push   0x8(%ebp)
 424:	e8 13 ff ff ff       	call   33c <write>
 429:	83 c4 10             	add    $0x10,%esp
}
 42c:	90                   	nop
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 440:	74 17                	je     459 <printint+0x2a>
 442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 446:	79 11                	jns    459 <printint+0x2a>
    neg = 1;
 448:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	f7 d8                	neg    %eax
 454:	89 45 ec             	mov    %eax,-0x14(%ebp)
 457:	eb 06                	jmp    45f <printint+0x30>
  } else {
    x = xx;
 459:	8b 45 0c             	mov    0xc(%ebp),%eax
 45c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 466:	8b 4d 10             	mov    0x10(%ebp),%ecx
 469:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46c:	ba 00 00 00 00       	mov    $0x0,%edx
 471:	f7 f1                	div    %ecx
 473:	89 d1                	mov    %edx,%ecx
 475:	8b 45 f4             	mov    -0xc(%ebp),%eax
 478:	8d 50 01             	lea    0x1(%eax),%edx
 47b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47e:	0f b6 91 54 0c 00 00 	movzbl 0xc54(%ecx),%edx
 485:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 489:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48f:	ba 00 00 00 00       	mov    $0x0,%edx
 494:	f7 f1                	div    %ecx
 496:	89 45 ec             	mov    %eax,-0x14(%ebp)
 499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49d:	75 c7                	jne    466 <printint+0x37>
  if(neg)
 49f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a3:	74 2d                	je     4d2 <printint+0xa3>
    buf[i++] = '-';
 4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a8:	8d 50 01             	lea    0x1(%eax),%edx
 4ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ae:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b3:	eb 1d                	jmp    4d2 <printint+0xa3>
    putc(fd, buf[i]);
 4b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	0f b6 00             	movzbl (%eax),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	83 ec 08             	sub    $0x8,%esp
 4c6:	50                   	push   %eax
 4c7:	ff 75 08             	push   0x8(%ebp)
 4ca:	e8 3d ff ff ff       	call   40c <putc>
 4cf:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4da:	79 d9                	jns    4b5 <printint+0x86>
}
 4dc:	90                   	nop
 4dd:	c9                   	leave  
 4de:	c3                   	ret    

000004df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4df:	55                   	push   %ebp
 4e0:	89 e5                	mov    %esp,%ebp
 4e2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ec:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ef:	83 c0 04             	add    $0x4,%eax
 4f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4fc:	e9 59 01 00 00       	jmp    65a <printf+0x17b>
    c = fmt[i] & 0xff;
 501:	8b 55 0c             	mov    0xc(%ebp),%edx
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
 507:	01 d0                	add    %edx,%eax
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	25 ff 00 00 00       	and    $0xff,%eax
 514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 517:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51b:	75 2c                	jne    549 <printf+0x6a>
      if(c == '%'){
 51d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 521:	75 0c                	jne    52f <printf+0x50>
        state = '%';
 523:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52a:	e9 27 01 00 00       	jmp    656 <printf+0x177>
      } else {
        putc(fd, c);
 52f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	83 ec 08             	sub    $0x8,%esp
 538:	50                   	push   %eax
 539:	ff 75 08             	push   0x8(%ebp)
 53c:	e8 cb fe ff ff       	call   40c <putc>
 541:	83 c4 10             	add    $0x10,%esp
 544:	e9 0d 01 00 00       	jmp    656 <printf+0x177>
      }
    } else if(state == '%'){
 549:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54d:	0f 85 03 01 00 00    	jne    656 <printf+0x177>
      if(c == 'd'){
 553:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 557:	75 1e                	jne    577 <printf+0x98>
        printint(fd, *ap, 10, 1);
 559:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55c:	8b 00                	mov    (%eax),%eax
 55e:	6a 01                	push   $0x1
 560:	6a 0a                	push   $0xa
 562:	50                   	push   %eax
 563:	ff 75 08             	push   0x8(%ebp)
 566:	e8 c4 fe ff ff       	call   42f <printint>
 56b:	83 c4 10             	add    $0x10,%esp
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	e9 d8 00 00 00       	jmp    64f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 577:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57b:	74 06                	je     583 <printf+0xa4>
 57d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 581:	75 1e                	jne    5a1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	6a 00                	push   $0x0
 58a:	6a 10                	push   $0x10
 58c:	50                   	push   %eax
 58d:	ff 75 08             	push   0x8(%ebp)
 590:	e8 9a fe ff ff       	call   42f <printint>
 595:	83 c4 10             	add    $0x10,%esp
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	e9 ae 00 00 00       	jmp    64f <printf+0x170>
      } else if(c == 's'){
 5a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a5:	75 43                	jne    5ea <printf+0x10b>
        s = (char*)*ap;
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b7:	75 25                	jne    5de <printf+0xff>
          s = "(null)";
 5b9:	c7 45 f4 c6 08 00 00 	movl   $0x8c6,-0xc(%ebp)
        while(*s != 0){
 5c0:	eb 1c                	jmp    5de <printf+0xff>
          putc(fd, *s);
 5c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	push   0x8(%ebp)
 5d2:	e8 35 fe ff ff       	call   40c <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
          s++;
 5da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	84 c0                	test   %al,%al
 5e6:	75 da                	jne    5c2 <printf+0xe3>
 5e8:	eb 65                	jmp    64f <printf+0x170>
        }
      } else if(c == 'c'){
 5ea:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ee:	75 1d                	jne    60d <printf+0x12e>
        putc(fd, *ap);
 5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 ec 08             	sub    $0x8,%esp
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	push   0x8(%ebp)
 5ff:	e8 08 fe ff ff       	call   40c <putc>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	eb 42                	jmp    64f <printf+0x170>
      } else if(c == '%'){
 60d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 611:	75 17                	jne    62a <printf+0x14b>
        putc(fd, c);
 613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	push   0x8(%ebp)
 620:	e8 e7 fd ff ff       	call   40c <putc>
 625:	83 c4 10             	add    $0x10,%esp
 628:	eb 25                	jmp    64f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	6a 25                	push   $0x25
 62f:	ff 75 08             	push   0x8(%ebp)
 632:	e8 d5 fd ff ff       	call   40c <putc>
 637:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63d:	0f be c0             	movsbl %al,%eax
 640:	83 ec 08             	sub    $0x8,%esp
 643:	50                   	push   %eax
 644:	ff 75 08             	push   0x8(%ebp)
 647:	e8 c0 fd ff ff       	call   40c <putc>
 64c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 64f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 656:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65a:	8b 55 0c             	mov    0xc(%ebp),%edx
 65d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 660:	01 d0                	add    %edx,%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	84 c0                	test   %al,%al
 667:	0f 85 94 fe ff ff    	jne    501 <printf+0x22>
    }
  }
}
 66d:	90                   	nop
 66e:	c9                   	leave  
 66f:	c3                   	ret    

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	83 e8 08             	sub    $0x8,%eax
 67c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67f:	a1 70 0c 00 00       	mov    0xc70,%eax
 684:	89 45 fc             	mov    %eax,-0x4(%ebp)
 687:	eb 24                	jmp    6ad <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 691:	72 12                	jb     6a5 <free+0x35>
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 699:	77 24                	ja     6bf <free+0x4f>
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a3:	72 1a                	jb     6bf <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b3:	76 d4                	jbe    689 <free+0x19>
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6bd:	73 ca                	jae    689 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	01 c2                	add    %eax,%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	39 c2                	cmp    %eax,%edx
 6d8:	75 24                	jne    6fe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	01 c2                	add    %eax,%edx
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 0a                	jmp    708 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 10                	mov    (%eax),%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 71d:	75 20                	jne    73f <free+0xcf>
    p->s.size += bp->s.size;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 50 04             	mov    0x4(%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	89 10                	mov    %edx,(%eax)
 73d:	eb 08                	jmp    747 <free+0xd7>
  } else
    p->s.ptr = bp;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 55 f8             	mov    -0x8(%ebp),%edx
 745:	89 10                	mov    %edx,(%eax)
  freep = p;
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	a3 70 0c 00 00       	mov    %eax,0xc70
}
 74f:	90                   	nop
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <morecore>:

static Header*
morecore(uint nu)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 758:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75f:	77 07                	ja     768 <morecore+0x16>
    nu = 4096;
 761:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	c1 e0 03             	shl    $0x3,%eax
 76e:	83 ec 0c             	sub    $0xc,%esp
 771:	50                   	push   %eax
 772:	e8 2d fc ff ff       	call   3a4 <sbrk>
 777:	83 c4 10             	add    $0x10,%esp
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 781:	75 07                	jne    78a <morecore+0x38>
    return 0;
 783:	b8 00 00 00 00       	mov    $0x0,%eax
 788:	eb 26                	jmp    7b0 <morecore+0x5e>
  hp = (Header*)p;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	8b 55 08             	mov    0x8(%ebp),%edx
 796:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	83 c0 08             	add    $0x8,%eax
 79f:	83 ec 0c             	sub    $0xc,%esp
 7a2:	50                   	push   %eax
 7a3:	e8 c8 fe ff ff       	call   670 <free>
 7a8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ab:	a1 70 0c 00 00       	mov    0xc70,%eax
}
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <malloc>:

void*
malloc(uint nbytes)
{
 7b2:	55                   	push   %ebp
 7b3:	89 e5                	mov    %esp,%ebp
 7b5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	83 c0 07             	add    $0x7,%eax
 7be:	c1 e8 03             	shr    $0x3,%eax
 7c1:	83 c0 01             	add    $0x1,%eax
 7c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c7:	a1 70 0c 00 00       	mov    0xc70,%eax
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d3:	75 23                	jne    7f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d5:	c7 45 f0 68 0c 00 00 	movl   $0xc68,-0x10(%ebp)
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 70 0c 00 00       	mov    %eax,0xc70
 7e4:	a1 70 0c 00 00       	mov    0xc70,%eax
 7e9:	a3 68 0c 00 00       	mov    %eax,0xc68
    base.s.size = 0;
 7ee:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 7f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 809:	77 4d                	ja     858 <malloc+0xa6>
      if(p->s.size == nunits)
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 814:	75 0c                	jne    822 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
 820:	eb 26                	jmp    848 <malloc+0x96>
      else {
        p->s.size -= nunits;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82b:	89 c2                	mov    %eax,%edx
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	c1 e0 03             	shl    $0x3,%eax
 83c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 55 ec             	mov    -0x14(%ebp),%edx
 845:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	a3 70 0c 00 00       	mov    %eax,0xc70
      return (void*)(p + 1);
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	83 c0 08             	add    $0x8,%eax
 856:	eb 3b                	jmp    893 <malloc+0xe1>
    }
    if(p == freep)
 858:	a1 70 0c 00 00       	mov    0xc70,%eax
 85d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 860:	75 1e                	jne    880 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 862:	83 ec 0c             	sub    $0xc,%esp
 865:	ff 75 ec             	push   -0x14(%ebp)
 868:	e8 e5 fe ff ff       	call   752 <morecore>
 86d:	83 c4 10             	add    $0x10,%esp
 870:	89 45 f4             	mov    %eax,-0xc(%ebp)
 873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 877:	75 07                	jne    880 <malloc+0xce>
        return 0;
 879:	b8 00 00 00 00       	mov    $0x0,%eax
 87e:	eb 13                	jmp    893 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 45 f0             	mov    %eax,-0x10(%ebp)
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 00                	mov    (%eax),%eax
 88b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88e:	e9 6d ff ff ff       	jmp    800 <malloc+0x4e>
  }
}
 893:	c9                   	leave  
 894:	c3                   	ret    
