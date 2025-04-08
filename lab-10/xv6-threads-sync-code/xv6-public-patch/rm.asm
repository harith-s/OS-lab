
_rm:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 9c 08 00 00       	push   $0x89c
  21:	6a 02                	push   $0x2
  23:	e8 be 04 00 00       	call   4e6 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 f3 02 00 00       	call   323 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 20 03 00 00       	call   373 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 b0 08 00 00       	push   $0x8b0
  74:	6a 02                	push   $0x2
  76:	e8 6b 04 00 00       	call   4e6 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
    }
  }

  exit();
  8b:	e8 93 02 00 00       	call   323 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  c6:	8d 42 01             	lea    0x1(%edx),%eax
  c9:	89 45 0c             	mov    %eax,0xc(%ebp)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8d 48 01             	lea    0x1(%eax),%ecx
  d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave  
  e5:	c3                   	ret    

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c0             	movzbl %al,%eax
 11f:	29 c2                	sub    %eax,%edx
 121:	89 d0                	mov    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(const char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	push   0xc(%ebp)
 156:	ff 75 08             	push   0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 45 fc             	cmp    %al,-0x4(%ebp)
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 83 01 00 00       	call   33b <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f3:	7f b3                	jg     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(const char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	push   0x8(%ebp)
 216:	e8 48 01 00 00       	call   363 <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	push   0xc(%ebp)
 234:	ff 75 f4             	push   -0xc(%ebp)
 237:	e8 3f 01 00 00       	call   37b <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	push   -0xc(%ebp)
 248:	e8 fe 00 00 00       	call   34b <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 25                	jmp    289 <atoi+0x34>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c1                	mov    %eax,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8d 50 01             	lea    0x1(%eax),%edx
 278:	89 55 08             	mov    %edx,0x8(%ebp)
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f be c0             	movsbl %al,%eax
 281:	01 c8                	add    %ecx,%eax
 283:	83 e8 30             	sub    $0x30,%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x48>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c7                	jle    264 <atoi+0xf>
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 17                	jmp    2cd <memmove+0x2b>
    *dst++ = *src++;
 2b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b9:	8d 42 01             	lea    0x1(%edx),%eax
 2bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c2:	8d 48 01             	lea    0x1(%eax),%ecx
 2c5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2cd:	8b 45 10             	mov    0x10(%ebp),%eax
 2d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d3:	89 55 10             	mov    %edx,0x10(%ebp)
 2d6:	85 c0                	test   %eax,%eax
 2d8:	7f dc                	jg     2b6 <memmove+0x14>
  return vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp

}
 2e2:	90                   	nop
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    

000002e5 <acquireLock>:

void acquireLock(struct lock* l) {
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp

}
 2e8:	90                   	nop
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <releaseLock>:

void releaseLock(struct lock* l) {
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp

}
 2ee:	90                   	nop
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    

000002f1 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp

}
 2f4:	90                   	nop
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    

000002f7 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp

}
 2fa:	90                   	nop
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    

000002fd <broadcast>:

void broadcast(struct condvar* cv) {
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp

}
 300:	90                   	nop
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    

00000303 <signal>:

void signal(struct condvar* cv) {
 303:	55                   	push   %ebp
 304:	89 e5                	mov    %esp,%ebp

}
 306:	90                   	nop
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    

00000309 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp

}
 30c:	90                   	nop
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret    

0000030f <semUp>:

void semUp(struct semaphore* s) {
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp

}
 312:	90                   	nop
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    

00000315 <semDown>:

void semDown(struct semaphore* s) {
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp

}
 318:	90                   	nop
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    

0000031b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31b:	b8 01 00 00 00       	mov    $0x1,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exit>:
SYSCALL(exit)
 323:	b8 02 00 00 00       	mov    $0x2,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <wait>:
SYSCALL(wait)
 32b:	b8 03 00 00 00       	mov    $0x3,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <pipe>:
SYSCALL(pipe)
 333:	b8 04 00 00 00       	mov    $0x4,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <read>:
SYSCALL(read)
 33b:	b8 05 00 00 00       	mov    $0x5,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <write>:
SYSCALL(write)
 343:	b8 10 00 00 00       	mov    $0x10,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <close>:
SYSCALL(close)
 34b:	b8 15 00 00 00       	mov    $0x15,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <kill>:
SYSCALL(kill)
 353:	b8 06 00 00 00       	mov    $0x6,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <exec>:
SYSCALL(exec)
 35b:	b8 07 00 00 00       	mov    $0x7,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <open>:
SYSCALL(open)
 363:	b8 0f 00 00 00       	mov    $0xf,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mknod>:
SYSCALL(mknod)
 36b:	b8 11 00 00 00       	mov    $0x11,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <unlink>:
SYSCALL(unlink)
 373:	b8 12 00 00 00       	mov    $0x12,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <fstat>:
SYSCALL(fstat)
 37b:	b8 08 00 00 00       	mov    $0x8,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <link>:
SYSCALL(link)
 383:	b8 13 00 00 00       	mov    $0x13,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mkdir>:
SYSCALL(mkdir)
 38b:	b8 14 00 00 00       	mov    $0x14,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <chdir>:
SYSCALL(chdir)
 393:	b8 09 00 00 00       	mov    $0x9,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <dup>:
SYSCALL(dup)
 39b:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getpid>:
SYSCALL(getpid)
 3a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <sbrk>:
SYSCALL(sbrk)
 3ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <sleep>:
SYSCALL(sleep)
 3b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <uptime>:
SYSCALL(uptime)
 3bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <thread_create>:
SYSCALL(thread_create)
 3c3:	b8 16 00 00 00       	mov    $0x16,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <thread_exit>:
SYSCALL(thread_exit)
 3cb:	b8 17 00 00 00       	mov    $0x17,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <thread_join>:
SYSCALL(thread_join)
 3d3:	b8 18 00 00 00       	mov    $0x18,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <waitpid>:
SYSCALL(waitpid)
 3db:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <barrier_init>:
SYSCALL(barrier_init)
 3e3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <barrier_check>:
SYSCALL(barrier_check)
 3eb:	b8 20 00 00 00       	mov    $0x20,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sleepChan>:
SYSCALL(sleepChan)
 3f3:	b8 24 00 00 00       	mov    $0x24,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <getChannel>:
SYSCALL(getChannel)
 3fb:	b8 25 00 00 00       	mov    $0x25,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <sigChan>:
SYSCALL(sigChan)
 403:	b8 26 00 00 00       	mov    $0x26,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sigOneChan>:
 40b:	b8 27 00 00 00       	mov    $0x27,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	83 ec 18             	sub    $0x18,%esp
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	6a 01                	push   $0x1
 424:	8d 45 f4             	lea    -0xc(%ebp),%eax
 427:	50                   	push   %eax
 428:	ff 75 08             	push   0x8(%ebp)
 42b:	e8 13 ff ff ff       	call   343 <write>
 430:	83 c4 10             	add    $0x10,%esp
}
 433:	90                   	nop
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 443:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 447:	74 17                	je     460 <printint+0x2a>
 449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44d:	79 11                	jns    460 <printint+0x2a>
    neg = 1;
 44f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	f7 d8                	neg    %eax
 45b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45e:	eb 06                	jmp    466 <printint+0x30>
  } else {
    x = xx;
 460:	8b 45 0c             	mov    0xc(%ebp),%eax
 463:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 470:	8b 45 ec             	mov    -0x14(%ebp),%eax
 473:	ba 00 00 00 00       	mov    $0x0,%edx
 478:	f7 f1                	div    %ecx
 47a:	89 d1                	mov    %edx,%ecx
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	8d 50 01             	lea    0x1(%eax),%edx
 482:	89 55 f4             	mov    %edx,-0xc(%ebp)
 485:	0f b6 91 58 0c 00 00 	movzbl 0xc58(%ecx),%edx
 48c:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 490:	8b 4d 10             	mov    0x10(%ebp),%ecx
 493:	8b 45 ec             	mov    -0x14(%ebp),%eax
 496:	ba 00 00 00 00       	mov    $0x0,%edx
 49b:	f7 f1                	div    %ecx
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a4:	75 c7                	jne    46d <printint+0x37>
  if(neg)
 4a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4aa:	74 2d                	je     4d9 <printint+0xa3>
    buf[i++] = '-';
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	8d 50 01             	lea    0x1(%eax),%edx
 4b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ba:	eb 1d                	jmp    4d9 <printint+0xa3>
    putc(fd, buf[i]);
 4bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c2:	01 d0                	add    %edx,%eax
 4c4:	0f b6 00             	movzbl (%eax),%eax
 4c7:	0f be c0             	movsbl %al,%eax
 4ca:	83 ec 08             	sub    $0x8,%esp
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	push   0x8(%ebp)
 4d1:	e8 3d ff ff ff       	call   413 <putc>
 4d6:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4d9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e1:	79 d9                	jns    4bc <printint+0x86>
}
 4e3:	90                   	nop
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f6:	83 c0 04             	add    $0x4,%eax
 4f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 503:	e9 59 01 00 00       	jmp    661 <printf+0x17b>
    c = fmt[i] & 0xff;
 508:	8b 55 0c             	mov    0xc(%ebp),%edx
 50b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50e:	01 d0                	add    %edx,%eax
 510:	0f b6 00             	movzbl (%eax),%eax
 513:	0f be c0             	movsbl %al,%eax
 516:	25 ff 00 00 00       	and    $0xff,%eax
 51b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 522:	75 2c                	jne    550 <printf+0x6a>
      if(c == '%'){
 524:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 528:	75 0c                	jne    536 <printf+0x50>
        state = '%';
 52a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 531:	e9 27 01 00 00       	jmp    65d <printf+0x177>
      } else {
        putc(fd, c);
 536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 539:	0f be c0             	movsbl %al,%eax
 53c:	83 ec 08             	sub    $0x8,%esp
 53f:	50                   	push   %eax
 540:	ff 75 08             	push   0x8(%ebp)
 543:	e8 cb fe ff ff       	call   413 <putc>
 548:	83 c4 10             	add    $0x10,%esp
 54b:	e9 0d 01 00 00       	jmp    65d <printf+0x177>
      }
    } else if(state == '%'){
 550:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 554:	0f 85 03 01 00 00    	jne    65d <printf+0x177>
      if(c == 'd'){
 55a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55e:	75 1e                	jne    57e <printf+0x98>
        printint(fd, *ap, 10, 1);
 560:	8b 45 e8             	mov    -0x18(%ebp),%eax
 563:	8b 00                	mov    (%eax),%eax
 565:	6a 01                	push   $0x1
 567:	6a 0a                	push   $0xa
 569:	50                   	push   %eax
 56a:	ff 75 08             	push   0x8(%ebp)
 56d:	e8 c4 fe ff ff       	call   436 <printint>
 572:	83 c4 10             	add    $0x10,%esp
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 579:	e9 d8 00 00 00       	jmp    656 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 582:	74 06                	je     58a <printf+0xa4>
 584:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 588:	75 1e                	jne    5a8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	6a 00                	push   $0x0
 591:	6a 10                	push   $0x10
 593:	50                   	push   %eax
 594:	ff 75 08             	push   0x8(%ebp)
 597:	e8 9a fe ff ff       	call   436 <printint>
 59c:	83 c4 10             	add    $0x10,%esp
        ap++;
 59f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a3:	e9 ae 00 00 00       	jmp    656 <printf+0x170>
      } else if(c == 's'){
 5a8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ac:	75 43                	jne    5f1 <printf+0x10b>
        s = (char*)*ap;
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5be:	75 25                	jne    5e5 <printf+0xff>
          s = "(null)";
 5c0:	c7 45 f4 c9 08 00 00 	movl   $0x8c9,-0xc(%ebp)
        while(*s != 0){
 5c7:	eb 1c                	jmp    5e5 <printf+0xff>
          putc(fd, *s);
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	83 ec 08             	sub    $0x8,%esp
 5d5:	50                   	push   %eax
 5d6:	ff 75 08             	push   0x8(%ebp)
 5d9:	e8 35 fe ff ff       	call   413 <putc>
 5de:	83 c4 10             	add    $0x10,%esp
          s++;
 5e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	84 c0                	test   %al,%al
 5ed:	75 da                	jne    5c9 <printf+0xe3>
 5ef:	eb 65                	jmp    656 <printf+0x170>
        }
      } else if(c == 'c'){
 5f1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f5:	75 1d                	jne    614 <printf+0x12e>
        putc(fd, *ap);
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	83 ec 08             	sub    $0x8,%esp
 602:	50                   	push   %eax
 603:	ff 75 08             	push   0x8(%ebp)
 606:	e8 08 fe ff ff       	call   413 <putc>
 60b:	83 c4 10             	add    $0x10,%esp
        ap++;
 60e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 612:	eb 42                	jmp    656 <printf+0x170>
      } else if(c == '%'){
 614:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 618:	75 17                	jne    631 <printf+0x14b>
        putc(fd, c);
 61a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	83 ec 08             	sub    $0x8,%esp
 623:	50                   	push   %eax
 624:	ff 75 08             	push   0x8(%ebp)
 627:	e8 e7 fd ff ff       	call   413 <putc>
 62c:	83 c4 10             	add    $0x10,%esp
 62f:	eb 25                	jmp    656 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 631:	83 ec 08             	sub    $0x8,%esp
 634:	6a 25                	push   $0x25
 636:	ff 75 08             	push   0x8(%ebp)
 639:	e8 d5 fd ff ff       	call   413 <putc>
 63e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 644:	0f be c0             	movsbl %al,%eax
 647:	83 ec 08             	sub    $0x8,%esp
 64a:	50                   	push   %eax
 64b:	ff 75 08             	push   0x8(%ebp)
 64e:	e8 c0 fd ff ff       	call   413 <putc>
 653:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 656:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 65d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 661:	8b 55 0c             	mov    0xc(%ebp),%edx
 664:	8b 45 f0             	mov    -0x10(%ebp),%eax
 667:	01 d0                	add    %edx,%eax
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	84 c0                	test   %al,%al
 66e:	0f 85 94 fe ff ff    	jne    508 <printf+0x22>
    }
  }
}
 674:	90                   	nop
 675:	c9                   	leave  
 676:	c3                   	ret    

00000677 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 677:	55                   	push   %ebp
 678:	89 e5                	mov    %esp,%ebp
 67a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	83 e8 08             	sub    $0x8,%eax
 683:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 686:	a1 74 0c 00 00       	mov    0xc74,%eax
 68b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68e:	eb 24                	jmp    6b4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 698:	72 12                	jb     6ac <free+0x35>
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a0:	77 24                	ja     6c6 <free+0x4f>
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6aa:	72 1a                	jb     6c6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ba:	76 d4                	jbe    690 <free+0x19>
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c4:	73 ca                	jae    690 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	01 c2                	add    %eax,%edx
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	39 c2                	cmp    %eax,%edx
 6df:	75 24                	jne    705 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 50 04             	mov    0x4(%eax),%edx
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	8b 40 04             	mov    0x4(%eax),%eax
 6ef:	01 c2                	add    %eax,%edx
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	8b 10                	mov    (%eax),%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	89 10                	mov    %edx,(%eax)
 703:	eb 0a                	jmp    70f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 10                	mov    (%eax),%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 40 04             	mov    0x4(%eax),%eax
 715:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	01 d0                	add    %edx,%eax
 721:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 724:	75 20                	jne    746 <free+0xcf>
    p->s.size += bp->s.size;
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 50 04             	mov    0x4(%eax),%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	01 c2                	add    %eax,%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
 744:	eb 08                	jmp    74e <free+0xd7>
  } else
    p->s.ptr = bp;
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74c:	89 10                	mov    %edx,(%eax)
  freep = p;
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	a3 74 0c 00 00       	mov    %eax,0xc74
}
 756:	90                   	nop
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <morecore>:

static Header*
morecore(uint nu)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 766:	77 07                	ja     76f <morecore+0x16>
    nu = 4096;
 768:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	c1 e0 03             	shl    $0x3,%eax
 775:	83 ec 0c             	sub    $0xc,%esp
 778:	50                   	push   %eax
 779:	e8 2d fc ff ff       	call   3ab <sbrk>
 77e:	83 c4 10             	add    $0x10,%esp
 781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 784:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 788:	75 07                	jne    791 <morecore+0x38>
    return 0;
 78a:	b8 00 00 00 00       	mov    $0x0,%eax
 78f:	eb 26                	jmp    7b7 <morecore+0x5e>
  hp = (Header*)p;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	8b 55 08             	mov    0x8(%ebp),%edx
 79d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	83 c0 08             	add    $0x8,%eax
 7a6:	83 ec 0c             	sub    $0xc,%esp
 7a9:	50                   	push   %eax
 7aa:	e8 c8 fe ff ff       	call   677 <free>
 7af:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b2:	a1 74 0c 00 00       	mov    0xc74,%eax
}
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    

000007b9 <malloc>:

void*
malloc(uint nbytes)
{
 7b9:	55                   	push   %ebp
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bf:	8b 45 08             	mov    0x8(%ebp),%eax
 7c2:	83 c0 07             	add    $0x7,%eax
 7c5:	c1 e8 03             	shr    $0x3,%eax
 7c8:	83 c0 01             	add    $0x1,%eax
 7cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ce:	a1 74 0c 00 00       	mov    0xc74,%eax
 7d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7da:	75 23                	jne    7ff <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7dc:	c7 45 f0 6c 0c 00 00 	movl   $0xc6c,-0x10(%ebp)
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	a3 74 0c 00 00       	mov    %eax,0xc74
 7eb:	a1 74 0c 00 00       	mov    0xc74,%eax
 7f0:	a3 6c 0c 00 00       	mov    %eax,0xc6c
    base.s.size = 0;
 7f5:	c7 05 70 0c 00 00 00 	movl   $0x0,0xc70
 7fc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 40 04             	mov    0x4(%eax),%eax
 80d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 810:	77 4d                	ja     85f <malloc+0xa6>
      if(p->s.size == nunits)
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 40 04             	mov    0x4(%eax),%eax
 818:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 81b:	75 0c                	jne    829 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 10                	mov    (%eax),%edx
 822:	8b 45 f0             	mov    -0x10(%ebp),%eax
 825:	89 10                	mov    %edx,(%eax)
 827:	eb 26                	jmp    84f <malloc+0x96>
      else {
        p->s.size -= nunits;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 832:	89 c2                	mov    %eax,%edx
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 40 04             	mov    0x4(%eax),%eax
 840:	c1 e0 03             	shl    $0x3,%eax
 843:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 852:	a3 74 0c 00 00       	mov    %eax,0xc74
      return (void*)(p + 1);
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	83 c0 08             	add    $0x8,%eax
 85d:	eb 3b                	jmp    89a <malloc+0xe1>
    }
    if(p == freep)
 85f:	a1 74 0c 00 00       	mov    0xc74,%eax
 864:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 867:	75 1e                	jne    887 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 869:	83 ec 0c             	sub    $0xc,%esp
 86c:	ff 75 ec             	push   -0x14(%ebp)
 86f:	e8 e5 fe ff ff       	call   759 <morecore>
 874:	83 c4 10             	add    $0x10,%esp
 877:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87e:	75 07                	jne    887 <malloc+0xce>
        return 0;
 880:	b8 00 00 00 00       	mov    $0x0,%eax
 885:	eb 13                	jmp    89a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 895:	e9 6d ff ff ff       	jmp    807 <malloc+0x4e>
  }
}
 89a:	c9                   	leave  
 89b:	c3                   	ret    
