
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 80 08 00 00       	push   $0x880
  1e:	6a 02                	push   $0x2
  20:	e8 a5 04 00 00       	call   4ca <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 da 02 00 00       	call   307 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 20 03 00 00       	call   367 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 93 08 00 00       	push   $0x893
  65:	6a 02                	push   $0x2
  67:	e8 5e 04 00 00       	call   4ca <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 93 02 00 00       	call   307 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 42 01             	lea    0x1(%edx),%eax
  ad:	89 45 0c             	mov    %eax,0xc(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 48 01             	lea    0x1(%eax),%ecx
  b6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(const char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	push   0xc(%ebp)
 13a:	ff 75 08             	push   0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 83 01 00 00       	call   31f <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d7:	7f b3                	jg     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	push   0x8(%ebp)
 1fa:	e8 48 01 00 00       	call   347 <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 f4             	push   -0xc(%ebp)
 21b:	e8 3f 01 00 00       	call   35f <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	push   -0xc(%ebp)
 22c:	e8 fe 00 00 00       	call   32f <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 42 01             	lea    0x1(%edx),%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 48 01             	lea    0x1(%eax),%ecx
 2a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp

}
 2c6:	90                   	nop
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <acquireLock>:

void acquireLock(struct lock* l) {
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp

}
 2cc:	90                   	nop
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    

000002cf <releaseLock>:

void releaseLock(struct lock* l) {
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp

}
 2d2:	90                   	nop
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret    

000002d5 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp

}
 2d8:	90                   	nop
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 2db:	55                   	push   %ebp
 2dc:	89 e5                	mov    %esp,%ebp

}
 2de:	90                   	nop
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    

000002e1 <broadcast>:

void broadcast(struct condvar* cv) {
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp

}
 2e4:	90                   	nop
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    

000002e7 <signal>:

void signal(struct condvar* cv) {
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp

}
 2ea:	90                   	nop
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <semInit>:

void semInit(struct semaphore* s, int initVal) {
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp

}
 2f0:	90                   	nop
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    

000002f3 <semUp>:

void semUp(struct semaphore* s) {
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp

}
 2f6:	90                   	nop
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret    

000002f9 <semDown>:

void semDown(struct semaphore* s) {
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp

}
 2fc:	90                   	nop
 2fd:	5d                   	pop    %ebp
 2fe:	c3                   	ret    

000002ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ff:	b8 01 00 00 00       	mov    $0x1,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exit>:
SYSCALL(exit)
 307:	b8 02 00 00 00       	mov    $0x2,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <wait>:
SYSCALL(wait)
 30f:	b8 03 00 00 00       	mov    $0x3,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <pipe>:
SYSCALL(pipe)
 317:	b8 04 00 00 00       	mov    $0x4,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <read>:
SYSCALL(read)
 31f:	b8 05 00 00 00       	mov    $0x5,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <write>:
SYSCALL(write)
 327:	b8 10 00 00 00       	mov    $0x10,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <close>:
SYSCALL(close)
 32f:	b8 15 00 00 00       	mov    $0x15,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <kill>:
SYSCALL(kill)
 337:	b8 06 00 00 00       	mov    $0x6,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <exec>:
SYSCALL(exec)
 33f:	b8 07 00 00 00       	mov    $0x7,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <open>:
SYSCALL(open)
 347:	b8 0f 00 00 00       	mov    $0xf,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <mknod>:
SYSCALL(mknod)
 34f:	b8 11 00 00 00       	mov    $0x11,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <unlink>:
SYSCALL(unlink)
 357:	b8 12 00 00 00       	mov    $0x12,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <fstat>:
SYSCALL(fstat)
 35f:	b8 08 00 00 00       	mov    $0x8,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <link>:
SYSCALL(link)
 367:	b8 13 00 00 00       	mov    $0x13,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <mkdir>:
SYSCALL(mkdir)
 36f:	b8 14 00 00 00       	mov    $0x14,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <chdir>:
SYSCALL(chdir)
 377:	b8 09 00 00 00       	mov    $0x9,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <dup>:
SYSCALL(dup)
 37f:	b8 0a 00 00 00       	mov    $0xa,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <getpid>:
SYSCALL(getpid)
 387:	b8 0b 00 00 00       	mov    $0xb,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <sbrk>:
SYSCALL(sbrk)
 38f:	b8 0c 00 00 00       	mov    $0xc,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <sleep>:
SYSCALL(sleep)
 397:	b8 0d 00 00 00       	mov    $0xd,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <uptime>:
SYSCALL(uptime)
 39f:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <thread_create>:
SYSCALL(thread_create)
 3a7:	b8 16 00 00 00       	mov    $0x16,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <thread_exit>:
SYSCALL(thread_exit)
 3af:	b8 17 00 00 00       	mov    $0x17,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <thread_join>:
SYSCALL(thread_join)
 3b7:	b8 18 00 00 00       	mov    $0x18,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <waitpid>:
SYSCALL(waitpid)
 3bf:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <barrier_init>:
SYSCALL(barrier_init)
 3c7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <barrier_check>:
SYSCALL(barrier_check)
 3cf:	b8 20 00 00 00       	mov    $0x20,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <sleepChan>:
SYSCALL(sleepChan)
 3d7:	b8 24 00 00 00       	mov    $0x24,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <getChannel>:
SYSCALL(getChannel)
 3df:	b8 25 00 00 00       	mov    $0x25,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <sigChan>:
SYSCALL(sigChan)
 3e7:	b8 26 00 00 00       	mov    $0x26,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <sigOneChan>:
 3ef:	b8 27 00 00 00       	mov    $0x27,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 18             	sub    $0x18,%esp
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 403:	83 ec 04             	sub    $0x4,%esp
 406:	6a 01                	push   $0x1
 408:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40b:	50                   	push   %eax
 40c:	ff 75 08             	push   0x8(%ebp)
 40f:	e8 13 ff ff ff       	call   327 <write>
 414:	83 c4 10             	add    $0x10,%esp
}
 417:	90                   	nop
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 427:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42b:	74 17                	je     444 <printint+0x2a>
 42d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 431:	79 11                	jns    444 <printint+0x2a>
    neg = 1;
 433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	f7 d8                	neg    %eax
 43f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 442:	eb 06                	jmp    44a <printint+0x30>
  } else {
    x = xx;
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 451:	8b 4d 10             	mov    0x10(%ebp),%ecx
 454:	8b 45 ec             	mov    -0x14(%ebp),%eax
 457:	ba 00 00 00 00       	mov    $0x0,%edx
 45c:	f7 f1                	div    %ecx
 45e:	89 d1                	mov    %edx,%ecx
 460:	8b 45 f4             	mov    -0xc(%ebp),%eax
 463:	8d 50 01             	lea    0x1(%eax),%edx
 466:	89 55 f4             	mov    %edx,-0xc(%ebp)
 469:	0f b6 91 38 0c 00 00 	movzbl 0xc38(%ecx),%edx
 470:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 474:	8b 4d 10             	mov    0x10(%ebp),%ecx
 477:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47a:	ba 00 00 00 00       	mov    $0x0,%edx
 47f:	f7 f1                	div    %ecx
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
 484:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 488:	75 c7                	jne    451 <printint+0x37>
  if(neg)
 48a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48e:	74 2d                	je     4bd <printint+0xa3>
    buf[i++] = '-';
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	8d 50 01             	lea    0x1(%eax),%edx
 496:	89 55 f4             	mov    %edx,-0xc(%ebp)
 499:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 49e:	eb 1d                	jmp    4bd <printint+0xa3>
    putc(fd, buf[i]);
 4a0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	01 d0                	add    %edx,%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	83 ec 08             	sub    $0x8,%esp
 4b1:	50                   	push   %eax
 4b2:	ff 75 08             	push   0x8(%ebp)
 4b5:	e8 3d ff ff ff       	call   3f7 <putc>
 4ba:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4bd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c5:	79 d9                	jns    4a0 <printint+0x86>
}
 4c7:	90                   	nop
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4ca:	55                   	push   %ebp
 4cb:	89 e5                	mov    %esp,%ebp
 4cd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4da:	83 c0 04             	add    $0x4,%eax
 4dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e7:	e9 59 01 00 00       	jmp    645 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ec:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f2:	01 d0                	add    %edx,%eax
 4f4:	0f b6 00             	movzbl (%eax),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	25 ff 00 00 00       	and    $0xff,%eax
 4ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 502:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 506:	75 2c                	jne    534 <printf+0x6a>
      if(c == '%'){
 508:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50c:	75 0c                	jne    51a <printf+0x50>
        state = '%';
 50e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 515:	e9 27 01 00 00       	jmp    641 <printf+0x177>
      } else {
        putc(fd, c);
 51a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51d:	0f be c0             	movsbl %al,%eax
 520:	83 ec 08             	sub    $0x8,%esp
 523:	50                   	push   %eax
 524:	ff 75 08             	push   0x8(%ebp)
 527:	e8 cb fe ff ff       	call   3f7 <putc>
 52c:	83 c4 10             	add    $0x10,%esp
 52f:	e9 0d 01 00 00       	jmp    641 <printf+0x177>
      }
    } else if(state == '%'){
 534:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 538:	0f 85 03 01 00 00    	jne    641 <printf+0x177>
      if(c == 'd'){
 53e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 542:	75 1e                	jne    562 <printf+0x98>
        printint(fd, *ap, 10, 1);
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 00                	mov    (%eax),%eax
 549:	6a 01                	push   $0x1
 54b:	6a 0a                	push   $0xa
 54d:	50                   	push   %eax
 54e:	ff 75 08             	push   0x8(%ebp)
 551:	e8 c4 fe ff ff       	call   41a <printint>
 556:	83 c4 10             	add    $0x10,%esp
        ap++;
 559:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55d:	e9 d8 00 00 00       	jmp    63a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 562:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 566:	74 06                	je     56e <printf+0xa4>
 568:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56c:	75 1e                	jne    58c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	6a 00                	push   $0x0
 575:	6a 10                	push   $0x10
 577:	50                   	push   %eax
 578:	ff 75 08             	push   0x8(%ebp)
 57b:	e8 9a fe ff ff       	call   41a <printint>
 580:	83 c4 10             	add    $0x10,%esp
        ap++;
 583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 587:	e9 ae 00 00 00       	jmp    63a <printf+0x170>
      } else if(c == 's'){
 58c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 590:	75 43                	jne    5d5 <printf+0x10b>
        s = (char*)*ap;
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 59a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a2:	75 25                	jne    5c9 <printf+0xff>
          s = "(null)";
 5a4:	c7 45 f4 a7 08 00 00 	movl   $0x8a7,-0xc(%ebp)
        while(*s != 0){
 5ab:	eb 1c                	jmp    5c9 <printf+0xff>
          putc(fd, *s);
 5ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	83 ec 08             	sub    $0x8,%esp
 5b9:	50                   	push   %eax
 5ba:	ff 75 08             	push   0x8(%ebp)
 5bd:	e8 35 fe ff ff       	call   3f7 <putc>
 5c2:	83 c4 10             	add    $0x10,%esp
          s++;
 5c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	84 c0                	test   %al,%al
 5d1:	75 da                	jne    5ad <printf+0xe3>
 5d3:	eb 65                	jmp    63a <printf+0x170>
        }
      } else if(c == 'c'){
 5d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d9:	75 1d                	jne    5f8 <printf+0x12e>
        putc(fd, *ap);
 5db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	83 ec 08             	sub    $0x8,%esp
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	push   0x8(%ebp)
 5ea:	e8 08 fe ff ff       	call   3f7 <putc>
 5ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	eb 42                	jmp    63a <printf+0x170>
      } else if(c == '%'){
 5f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fc:	75 17                	jne    615 <printf+0x14b>
        putc(fd, c);
 5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	83 ec 08             	sub    $0x8,%esp
 607:	50                   	push   %eax
 608:	ff 75 08             	push   0x8(%ebp)
 60b:	e8 e7 fd ff ff       	call   3f7 <putc>
 610:	83 c4 10             	add    $0x10,%esp
 613:	eb 25                	jmp    63a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 615:	83 ec 08             	sub    $0x8,%esp
 618:	6a 25                	push   $0x25
 61a:	ff 75 08             	push   0x8(%ebp)
 61d:	e8 d5 fd ff ff       	call   3f7 <putc>
 622:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	push   0x8(%ebp)
 632:	e8 c0 fd ff ff       	call   3f7 <putc>
 637:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 63a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 641:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 645:	8b 55 0c             	mov    0xc(%ebp),%edx
 648:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64b:	01 d0                	add    %edx,%eax
 64d:	0f b6 00             	movzbl (%eax),%eax
 650:	84 c0                	test   %al,%al
 652:	0f 85 94 fe ff ff    	jne    4ec <printf+0x22>
    }
  }
}
 658:	90                   	nop
 659:	c9                   	leave  
 65a:	c3                   	ret    

0000065b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	83 e8 08             	sub    $0x8,%eax
 667:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	a1 54 0c 00 00       	mov    0xc54,%eax
 66f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 672:	eb 24                	jmp    698 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 67c:	72 12                	jb     690 <free+0x35>
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 684:	77 24                	ja     6aa <free+0x4f>
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68e:	72 1a                	jb     6aa <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	89 45 fc             	mov    %eax,-0x4(%ebp)
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69e:	76 d4                	jbe    674 <free+0x19>
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a8:	73 ca                	jae    674 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	01 c2                	add    %eax,%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	39 c2                	cmp    %eax,%edx
 6c3:	75 24                	jne    6e9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 50 04             	mov    0x4(%eax),%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 0a                	jmp    6f3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 10                	mov    (%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 40 04             	mov    0x4(%eax),%eax
 6f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 708:	75 20                	jne    72a <free+0xcf>
    p->s.size += bp->s.size;
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	8b 40 04             	mov    0x4(%eax),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
 728:	eb 08                	jmp    732 <free+0xd7>
  } else
    p->s.ptr = bp;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 730:	89 10                	mov    %edx,(%eax)
  freep = p;
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	a3 54 0c 00 00       	mov    %eax,0xc54
}
 73a:	90                   	nop
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <morecore>:

static Header*
morecore(uint nu)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 743:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74a:	77 07                	ja     753 <morecore+0x16>
    nu = 4096;
 74c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	c1 e0 03             	shl    $0x3,%eax
 759:	83 ec 0c             	sub    $0xc,%esp
 75c:	50                   	push   %eax
 75d:	e8 2d fc ff ff       	call   38f <sbrk>
 762:	83 c4 10             	add    $0x10,%esp
 765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 768:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76c:	75 07                	jne    775 <morecore+0x38>
    return 0;
 76e:	b8 00 00 00 00       	mov    $0x0,%eax
 773:	eb 26                	jmp    79b <morecore+0x5e>
  hp = (Header*)p;
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77e:	8b 55 08             	mov    0x8(%ebp),%edx
 781:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	83 c0 08             	add    $0x8,%eax
 78a:	83 ec 0c             	sub    $0xc,%esp
 78d:	50                   	push   %eax
 78e:	e8 c8 fe ff ff       	call   65b <free>
 793:	83 c4 10             	add    $0x10,%esp
  return freep;
 796:	a1 54 0c 00 00       	mov    0xc54,%eax
}
 79b:	c9                   	leave  
 79c:	c3                   	ret    

0000079d <malloc>:

void*
malloc(uint nbytes)
{
 79d:	55                   	push   %ebp
 79e:	89 e5                	mov    %esp,%ebp
 7a0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	83 c0 07             	add    $0x7,%eax
 7a9:	c1 e8 03             	shr    $0x3,%eax
 7ac:	83 c0 01             	add    $0x1,%eax
 7af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b2:	a1 54 0c 00 00       	mov    0xc54,%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7be:	75 23                	jne    7e3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 45 f0 4c 0c 00 00 	movl   $0xc4c,-0x10(%ebp)
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	a3 54 0c 00 00       	mov    %eax,0xc54
 7cf:	a1 54 0c 00 00       	mov    0xc54,%eax
 7d4:	a3 4c 0c 00 00       	mov    %eax,0xc4c
    base.s.size = 0;
 7d9:	c7 05 50 0c 00 00 00 	movl   $0x0,0xc50
 7e0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f4:	77 4d                	ja     843 <malloc+0xa6>
      if(p->s.size == nunits)
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ff:	75 0c                	jne    80d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 10                	mov    (%eax),%edx
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	89 10                	mov    %edx,(%eax)
 80b:	eb 26                	jmp    833 <malloc+0x96>
      else {
        p->s.size -= nunits;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	2b 45 ec             	sub    -0x14(%ebp),%eax
 816:	89 c2                	mov    %eax,%edx
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	c1 e0 03             	shl    $0x3,%eax
 827:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 830:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	a3 54 0c 00 00       	mov    %eax,0xc54
      return (void*)(p + 1);
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	83 c0 08             	add    $0x8,%eax
 841:	eb 3b                	jmp    87e <malloc+0xe1>
    }
    if(p == freep)
 843:	a1 54 0c 00 00       	mov    0xc54,%eax
 848:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84b:	75 1e                	jne    86b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 84d:	83 ec 0c             	sub    $0xc,%esp
 850:	ff 75 ec             	push   -0x14(%ebp)
 853:	e8 e5 fe ff ff       	call   73d <morecore>
 858:	83 c4 10             	add    $0x10,%esp
 85b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 862:	75 07                	jne    86b <malloc+0xce>
        return 0;
 864:	b8 00 00 00 00       	mov    $0x0,%eax
 869:	eb 13                	jmp    87e <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 879:	e9 6d ff ff ff       	jmp    7eb <malloc+0x4e>
  }
}
 87e:	c9                   	leave  
 87f:	c3                   	ret    
