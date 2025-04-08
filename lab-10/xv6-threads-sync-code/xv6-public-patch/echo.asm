
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	39 03                	cmp    %eax,(%ebx)
  25:	7e 07                	jle    2e <main+0x2e>
  27:	ba 71 08 00 00       	mov    $0x871,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 73 08 00 00       	mov    $0x873,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 75 08 00 00       	push   $0x875
  4b:	6a 01                	push   $0x1
  4d:	e8 69 04 00 00       	call   4bb <printf>
  52:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
  exit();
  60:	e8 93 02 00 00       	call   2f8 <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 55 0c             	mov    0xc(%ebp),%edx
  9b:	8d 42 01             	lea    0x1(%edx),%eax
  9e:	89 45 0c             	mov    %eax,0xc(%ebp)
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	8d 48 01             	lea    0x1(%eax),%ecx
  a7:	89 4d 08             	mov    %ecx,0x8(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	push   0xc(%ebp)
 12b:	ff 75 08             	push   0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 45 fc             	cmp    %al,-0x4(%ebp)
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 83 01 00 00       	call   310 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1c8:	7f b3                	jg     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
      break;
 1cc:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(const char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	push   0x8(%ebp)
 1eb:	e8 48 01 00 00       	call   338 <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	push   0xc(%ebp)
 209:	ff 75 f4             	push   -0xc(%ebp)
 20c:	e8 3f 01 00 00       	call   350 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	push   -0xc(%ebp)
 21d:	e8 fe 00 00 00       	call   320 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28e:	8d 42 01             	lea    0x1(%edx),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
 294:	8b 45 fc             	mov    -0x4(%ebp),%eax
 297:	8d 48 01             	lea    0x1(%eax),%ecx
 29a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp

}
 2b7:	90                   	nop
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    

000002ba <acquireLock>:

void acquireLock(struct lock* l) {
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp

}
 2bd:	90                   	nop
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <releaseLock>:

void releaseLock(struct lock* l) {
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp

}
 2c3:	90                   	nop
 2c4:	5d                   	pop    %ebp
 2c5:	c3                   	ret    

000002c6 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp

}
 2c9:	90                   	nop
 2ca:	5d                   	pop    %ebp
 2cb:	c3                   	ret    

000002cc <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp

}
 2cf:	90                   	nop
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret    

000002d2 <broadcast>:

void broadcast(struct condvar* cv) {
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp

}
 2d5:	90                   	nop
 2d6:	5d                   	pop    %ebp
 2d7:	c3                   	ret    

000002d8 <signal>:

void signal(struct condvar* cv) {
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp

}
 2db:	90                   	nop
 2dc:	5d                   	pop    %ebp
 2dd:	c3                   	ret    

000002de <semInit>:

void semInit(struct semaphore* s, int initVal) {
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp

}
 2e1:	90                   	nop
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret    

000002e4 <semUp>:

void semUp(struct semaphore* s) {
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp

}
 2e7:	90                   	nop
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <semDown>:

void semDown(struct semaphore* s) {
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp

}
 2ed:	90                   	nop
 2ee:	5d                   	pop    %ebp
 2ef:	c3                   	ret    

000002f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exit>:
SYSCALL(exit)
 2f8:	b8 02 00 00 00       	mov    $0x2,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <wait>:
SYSCALL(wait)
 300:	b8 03 00 00 00       	mov    $0x3,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <pipe>:
SYSCALL(pipe)
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <read>:
SYSCALL(read)
 310:	b8 05 00 00 00       	mov    $0x5,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <write>:
SYSCALL(write)
 318:	b8 10 00 00 00       	mov    $0x10,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <close>:
SYSCALL(close)
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kill>:
SYSCALL(kill)
 328:	b8 06 00 00 00       	mov    $0x6,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exec>:
SYSCALL(exec)
 330:	b8 07 00 00 00       	mov    $0x7,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <open>:
SYSCALL(open)
 338:	b8 0f 00 00 00       	mov    $0xf,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mknod>:
SYSCALL(mknod)
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <unlink>:
SYSCALL(unlink)
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <fstat>:
SYSCALL(fstat)
 350:	b8 08 00 00 00       	mov    $0x8,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <link>:
SYSCALL(link)
 358:	b8 13 00 00 00       	mov    $0x13,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mkdir>:
SYSCALL(mkdir)
 360:	b8 14 00 00 00       	mov    $0x14,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <chdir>:
SYSCALL(chdir)
 368:	b8 09 00 00 00       	mov    $0x9,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup>:
SYSCALL(dup)
 370:	b8 0a 00 00 00       	mov    $0xa,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getpid>:
SYSCALL(getpid)
 378:	b8 0b 00 00 00       	mov    $0xb,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sbrk>:
SYSCALL(sbrk)
 380:	b8 0c 00 00 00       	mov    $0xc,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sleep>:
SYSCALL(sleep)
 388:	b8 0d 00 00 00       	mov    $0xd,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <uptime>:
SYSCALL(uptime)
 390:	b8 0e 00 00 00       	mov    $0xe,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <thread_create>:
SYSCALL(thread_create)
 398:	b8 16 00 00 00       	mov    $0x16,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <thread_exit>:
SYSCALL(thread_exit)
 3a0:	b8 17 00 00 00       	mov    $0x17,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <thread_join>:
SYSCALL(thread_join)
 3a8:	b8 18 00 00 00       	mov    $0x18,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <waitpid>:
SYSCALL(waitpid)
 3b0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <barrier_init>:
SYSCALL(barrier_init)
 3b8:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <barrier_check>:
SYSCALL(barrier_check)
 3c0:	b8 20 00 00 00       	mov    $0x20,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <sleepChan>:
SYSCALL(sleepChan)
 3c8:	b8 24 00 00 00       	mov    $0x24,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getChannel>:
SYSCALL(getChannel)
 3d0:	b8 25 00 00 00       	mov    $0x25,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <sigChan>:
SYSCALL(sigChan)
 3d8:	b8 26 00 00 00       	mov    $0x26,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sigOneChan>:
 3e0:	b8 27 00 00 00       	mov    $0x27,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 18             	sub    $0x18,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f4:	83 ec 04             	sub    $0x4,%esp
 3f7:	6a 01                	push   $0x1
 3f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fc:	50                   	push   %eax
 3fd:	ff 75 08             	push   0x8(%ebp)
 400:	e8 13 ff ff ff       	call   318 <write>
 405:	83 c4 10             	add    $0x10,%esp
}
 408:	90                   	nop
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 418:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41c:	74 17                	je     435 <printint+0x2a>
 41e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 422:	79 11                	jns    435 <printint+0x2a>
    neg = 1;
 424:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	f7 d8                	neg    %eax
 430:	89 45 ec             	mov    %eax,-0x14(%ebp)
 433:	eb 06                	jmp    43b <printint+0x30>
  } else {
    x = xx;
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 442:	8b 4d 10             	mov    0x10(%ebp),%ecx
 445:	8b 45 ec             	mov    -0x14(%ebp),%eax
 448:	ba 00 00 00 00       	mov    $0x0,%edx
 44d:	f7 f1                	div    %ecx
 44f:	89 d1                	mov    %edx,%ecx
 451:	8b 45 f4             	mov    -0xc(%ebp),%eax
 454:	8d 50 01             	lea    0x1(%eax),%edx
 457:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45a:	0f b6 91 0c 0c 00 00 	movzbl 0xc0c(%ecx),%edx
 461:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 465:	8b 4d 10             	mov    0x10(%ebp),%ecx
 468:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46b:	ba 00 00 00 00       	mov    $0x0,%edx
 470:	f7 f1                	div    %ecx
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 c7                	jne    442 <printint+0x37>
  if(neg)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	74 2d                	je     4ae <printint+0xa3>
    buf[i++] = '-';
 481:	8b 45 f4             	mov    -0xc(%ebp),%eax
 484:	8d 50 01             	lea    0x1(%eax),%edx
 487:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48f:	eb 1d                	jmp    4ae <printint+0xa3>
    putc(fd, buf[i]);
 491:	8d 55 dc             	lea    -0x24(%ebp),%edx
 494:	8b 45 f4             	mov    -0xc(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	0f be c0             	movsbl %al,%eax
 49f:	83 ec 08             	sub    $0x8,%esp
 4a2:	50                   	push   %eax
 4a3:	ff 75 08             	push   0x8(%ebp)
 4a6:	e8 3d ff ff ff       	call   3e8 <putc>
 4ab:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4ae:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b6:	79 d9                	jns    491 <printint+0x86>
}
 4b8:	90                   	nop
 4b9:	c9                   	leave  
 4ba:	c3                   	ret    

000004bb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cb:	83 c0 04             	add    $0x4,%eax
 4ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d8:	e9 59 01 00 00       	jmp    636 <printf+0x17b>
    c = fmt[i] & 0xff;
 4dd:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e3:	01 d0                	add    %edx,%eax
 4e5:	0f b6 00             	movzbl (%eax),%eax
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	25 ff 00 00 00       	and    $0xff,%eax
 4f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f7:	75 2c                	jne    525 <printf+0x6a>
      if(c == '%'){
 4f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fd:	75 0c                	jne    50b <printf+0x50>
        state = '%';
 4ff:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 506:	e9 27 01 00 00       	jmp    632 <printf+0x177>
      } else {
        putc(fd, c);
 50b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50e:	0f be c0             	movsbl %al,%eax
 511:	83 ec 08             	sub    $0x8,%esp
 514:	50                   	push   %eax
 515:	ff 75 08             	push   0x8(%ebp)
 518:	e8 cb fe ff ff       	call   3e8 <putc>
 51d:	83 c4 10             	add    $0x10,%esp
 520:	e9 0d 01 00 00       	jmp    632 <printf+0x177>
      }
    } else if(state == '%'){
 525:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 529:	0f 85 03 01 00 00    	jne    632 <printf+0x177>
      if(c == 'd'){
 52f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 533:	75 1e                	jne    553 <printf+0x98>
        printint(fd, *ap, 10, 1);
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	6a 01                	push   $0x1
 53c:	6a 0a                	push   $0xa
 53e:	50                   	push   %eax
 53f:	ff 75 08             	push   0x8(%ebp)
 542:	e8 c4 fe ff ff       	call   40b <printint>
 547:	83 c4 10             	add    $0x10,%esp
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54e:	e9 d8 00 00 00       	jmp    62b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 553:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 557:	74 06                	je     55f <printf+0xa4>
 559:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55d:	75 1e                	jne    57d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	6a 00                	push   $0x0
 566:	6a 10                	push   $0x10
 568:	50                   	push   %eax
 569:	ff 75 08             	push   0x8(%ebp)
 56c:	e8 9a fe ff ff       	call   40b <printint>
 571:	83 c4 10             	add    $0x10,%esp
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	e9 ae 00 00 00       	jmp    62b <printf+0x170>
      } else if(c == 's'){
 57d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 581:	75 43                	jne    5c6 <printf+0x10b>
        s = (char*)*ap;
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 593:	75 25                	jne    5ba <printf+0xff>
          s = "(null)";
 595:	c7 45 f4 7a 08 00 00 	movl   $0x87a,-0xc(%ebp)
        while(*s != 0){
 59c:	eb 1c                	jmp    5ba <printf+0xff>
          putc(fd, *s);
 59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a1:	0f b6 00             	movzbl (%eax),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	83 ec 08             	sub    $0x8,%esp
 5aa:	50                   	push   %eax
 5ab:	ff 75 08             	push   0x8(%ebp)
 5ae:	e8 35 fe ff ff       	call   3e8 <putc>
 5b3:	83 c4 10             	add    $0x10,%esp
          s++;
 5b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	84 c0                	test   %al,%al
 5c2:	75 da                	jne    59e <printf+0xe3>
 5c4:	eb 65                	jmp    62b <printf+0x170>
        }
      } else if(c == 'c'){
 5c6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ca:	75 1d                	jne    5e9 <printf+0x12e>
        putc(fd, *ap);
 5cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	push   0x8(%ebp)
 5db:	e8 08 fe ff ff       	call   3e8 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e7:	eb 42                	jmp    62b <printf+0x170>
      } else if(c == '%'){
 5e9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ed:	75 17                	jne    606 <printf+0x14b>
        putc(fd, c);
 5ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	83 ec 08             	sub    $0x8,%esp
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	push   0x8(%ebp)
 5fc:	e8 e7 fd ff ff       	call   3e8 <putc>
 601:	83 c4 10             	add    $0x10,%esp
 604:	eb 25                	jmp    62b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 606:	83 ec 08             	sub    $0x8,%esp
 609:	6a 25                	push   $0x25
 60b:	ff 75 08             	push   0x8(%ebp)
 60e:	e8 d5 fd ff ff       	call   3e8 <putc>
 613:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	50                   	push   %eax
 620:	ff 75 08             	push   0x8(%ebp)
 623:	e8 c0 fd ff ff       	call   3e8 <putc>
 628:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 632:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 636:	8b 55 0c             	mov    0xc(%ebp),%edx
 639:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	84 c0                	test   %al,%al
 643:	0f 85 94 fe ff ff    	jne    4dd <printf+0x22>
    }
  }
}
 649:	90                   	nop
 64a:	c9                   	leave  
 64b:	c3                   	ret    

0000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	55                   	push   %ebp
 64d:	89 e5                	mov    %esp,%ebp
 64f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 652:	8b 45 08             	mov    0x8(%ebp),%eax
 655:	83 e8 08             	sub    $0x8,%eax
 658:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65b:	a1 28 0c 00 00       	mov    0xc28,%eax
 660:	89 45 fc             	mov    %eax,-0x4(%ebp)
 663:	eb 24                	jmp    689 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66d:	72 12                	jb     681 <free+0x35>
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 675:	77 24                	ja     69b <free+0x4f>
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 67f:	72 1a                	jb     69b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	89 45 fc             	mov    %eax,-0x4(%ebp)
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68f:	76 d4                	jbe    665 <free+0x19>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 699:	73 ca                	jae    665 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	8b 40 04             	mov    0x4(%eax),%eax
 6a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	01 c2                	add    %eax,%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	39 c2                	cmp    %eax,%edx
 6b4:	75 24                	jne    6da <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 50 04             	mov    0x4(%eax),%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	8b 40 04             	mov    0x4(%eax),%eax
 6c4:	01 c2                	add    %eax,%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
 6d8:	eb 0a                	jmp    6e4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 10                	mov    (%eax),%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 40 04             	mov    0x4(%eax),%eax
 6ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	01 d0                	add    %edx,%eax
 6f6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6f9:	75 20                	jne    71b <free+0xcf>
    p->s.size += bp->s.size;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 50 04             	mov    0x4(%eax),%edx
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	8b 10                	mov    (%eax),%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	89 10                	mov    %edx,(%eax)
 719:	eb 08                	jmp    723 <free+0xd7>
  } else
    p->s.ptr = bp;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 721:	89 10                	mov    %edx,(%eax)
  freep = p;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 72b:	90                   	nop
 72c:	c9                   	leave  
 72d:	c3                   	ret    

0000072e <morecore>:

static Header*
morecore(uint nu)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 734:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73b:	77 07                	ja     744 <morecore+0x16>
    nu = 4096;
 73d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	c1 e0 03             	shl    $0x3,%eax
 74a:	83 ec 0c             	sub    $0xc,%esp
 74d:	50                   	push   %eax
 74e:	e8 2d fc ff ff       	call   380 <sbrk>
 753:	83 c4 10             	add    $0x10,%esp
 756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 759:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 75d:	75 07                	jne    766 <morecore+0x38>
    return 0;
 75f:	b8 00 00 00 00       	mov    $0x0,%eax
 764:	eb 26                	jmp    78c <morecore+0x5e>
  hp = (Header*)p;
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	8b 55 08             	mov    0x8(%ebp),%edx
 772:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	83 c0 08             	add    $0x8,%eax
 77b:	83 ec 0c             	sub    $0xc,%esp
 77e:	50                   	push   %eax
 77f:	e8 c8 fe ff ff       	call   64c <free>
 784:	83 c4 10             	add    $0x10,%esp
  return freep;
 787:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 78c:	c9                   	leave  
 78d:	c3                   	ret    

0000078e <malloc>:

void*
malloc(uint nbytes)
{
 78e:	55                   	push   %ebp
 78f:	89 e5                	mov    %esp,%ebp
 791:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	83 c0 07             	add    $0x7,%eax
 79a:	c1 e8 03             	shr    $0x3,%eax
 79d:	83 c0 01             	add    $0x1,%eax
 7a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a3:	a1 28 0c 00 00       	mov    0xc28,%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7af:	75 23                	jne    7d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b1:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 7b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bb:	a3 28 0c 00 00       	mov    %eax,0xc28
 7c0:	a1 28 0c 00 00       	mov    0xc28,%eax
 7c5:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 7ca:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 7d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7e5:	77 4d                	ja     834 <malloc+0xa6>
      if(p->s.size == nunits)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f0:	75 0c                	jne    7fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 10                	mov    (%eax),%edx
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	89 10                	mov    %edx,(%eax)
 7fc:	eb 26                	jmp    824 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	2b 45 ec             	sub    -0x14(%ebp),%eax
 807:	89 c2                	mov    %eax,%edx
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	c1 e0 03             	shl    $0x3,%eax
 818:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 821:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	83 c0 08             	add    $0x8,%eax
 832:	eb 3b                	jmp    86f <malloc+0xe1>
    }
    if(p == freep)
 834:	a1 28 0c 00 00       	mov    0xc28,%eax
 839:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 83c:	75 1e                	jne    85c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 83e:	83 ec 0c             	sub    $0xc,%esp
 841:	ff 75 ec             	push   -0x14(%ebp)
 844:	e8 e5 fe ff ff       	call   72e <morecore>
 849:	83 c4 10             	add    $0x10,%esp
 84c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 853:	75 07                	jne    85c <malloc+0xce>
        return 0;
 855:	b8 00 00 00 00       	mov    $0x0,%eax
 85a:	eb 13                	jmp    86f <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86a:	e9 6d ff ff ff       	jmp    7dc <malloc+0x4e>
  }
}
 86f:	c9                   	leave  
 870:	c3                   	ret    
