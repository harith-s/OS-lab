
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 0c             	push   0xc(%ebp)
   c:	e8 97 01 00 00       	call   1a8 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	ff 75 0c             	push   0xc(%ebp)
  1b:	ff 75 08             	push   0x8(%ebp)
  1e:	e8 a3 03 00 00       	call   3c6 <write>
  23:	83 c4 10             	add    $0x10,%esp
}
  26:	90                   	nop
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	68 98 04 00 00       	push   $0x498
  37:	6a 01                	push   $0x1
  39:	e8 c2 ff ff ff       	call   0 <printf>
  3e:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  48:	eb 1d                	jmp    67 <forktest+0x3e>
    pid = fork();
  4a:	e8 4f 03 00 00       	call   39e <fork>
  4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  56:	78 1a                	js     72 <forktest+0x49>
      break;
    if(pid == 0)
  58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5c:	75 05                	jne    63 <forktest+0x3a>
      exit();
  5e:	e8 43 03 00 00       	call   3a6 <exit>
  for(n=0; n<N; n++){
  63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  67:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  6e:	7e da                	jle    4a <forktest+0x21>
  70:	eb 01                	jmp    73 <forktest+0x4a>
      break;
  72:	90                   	nop
  }

  if(n == N){
  73:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7a:	75 40                	jne    bc <forktest+0x93>
    printf(1, "fork claimed to work N times!\n", N);
  7c:	83 ec 04             	sub    $0x4,%esp
  7f:	68 e8 03 00 00       	push   $0x3e8
  84:	68 a4 04 00 00       	push   $0x4a4
  89:	6a 01                	push   $0x1
  8b:	e8 70 ff ff ff       	call   0 <printf>
  90:	83 c4 10             	add    $0x10,%esp
    exit();
  93:	e8 0e 03 00 00       	call   3a6 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
  98:	e8 11 03 00 00       	call   3ae <wait>
  9d:	85 c0                	test   %eax,%eax
  9f:	79 17                	jns    b8 <forktest+0x8f>
      printf(1, "wait stopped early\n");
  a1:	83 ec 08             	sub    $0x8,%esp
  a4:	68 c3 04 00 00       	push   $0x4c3
  a9:	6a 01                	push   $0x1
  ab:	e8 50 ff ff ff       	call   0 <printf>
  b0:	83 c4 10             	add    $0x10,%esp
      exit();
  b3:	e8 ee 02 00 00       	call   3a6 <exit>
  for(; n > 0; n--){
  b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c0:	7f d6                	jg     98 <forktest+0x6f>
    }
  }

  if(wait() != -1){
  c2:	e8 e7 02 00 00       	call   3ae <wait>
  c7:	83 f8 ff             	cmp    $0xffffffff,%eax
  ca:	74 17                	je     e3 <forktest+0xba>
    printf(1, "wait got too many\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 d7 04 00 00       	push   $0x4d7
  d4:	6a 01                	push   $0x1
  d6:	e8 25 ff ff ff       	call   0 <printf>
  db:	83 c4 10             	add    $0x10,%esp
    exit();
  de:	e8 c3 02 00 00       	call   3a6 <exit>
  }

  printf(1, "fork test OK\n");
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	68 ea 04 00 00       	push   $0x4ea
  eb:	6a 01                	push   $0x1
  ed:	e8 0e ff ff ff       	call   0 <printf>
  f2:	83 c4 10             	add    $0x10,%esp
}
  f5:	90                   	nop
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <main>:

int
main(void)
{
  f8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fc:	83 e4 f0             	and    $0xfffffff0,%esp
  ff:	ff 71 fc             	push   -0x4(%ecx)
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	51                   	push   %ecx
 106:	83 ec 04             	sub    $0x4,%esp
  forktest();
 109:	e8 1b ff ff ff       	call   29 <forktest>
  exit();
 10e:	e8 93 02 00 00       	call   3a6 <exit>

00000113 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 118:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11b:	8b 55 10             	mov    0x10(%ebp),%edx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	89 cb                	mov    %ecx,%ebx
 123:	89 df                	mov    %ebx,%edi
 125:	89 d1                	mov    %edx,%ecx
 127:	fc                   	cld    
 128:	f3 aa                	rep stos %al,%es:(%edi)
 12a:	89 ca                	mov    %ecx,%edx
 12c:	89 fb                	mov    %edi,%ebx
 12e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 131:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 134:	90                   	nop
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 55 0c             	mov    0xc(%ebp),%edx
 149:	8d 42 01             	lea    0x1(%edx),%eax
 14c:	89 45 0c             	mov    %eax,0xc(%ebp)
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 48 01             	lea    0x1(%eax),%ecx
 155:	89 4d 08             	mov    %ecx,0x8(%ebp)
 158:	0f b6 12             	movzbl (%edx),%edx
 15b:	88 10                	mov    %dl,(%eax)
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	84 c0                	test   %al,%al
 162:	75 e2                	jne    146 <strcpy+0xd>
    ;
  return os;
 164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16c:	eb 08                	jmp    176 <strcmp+0xd>
    p++, q++;
 16e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 172:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	84 c0                	test   %al,%al
 17e:	74 10                	je     190 <strcmp+0x27>
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 10             	movzbl (%eax),%edx
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	38 c2                	cmp    %al,%dl
 18e:	74 de                	je     16e <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	0f b6 d0             	movzbl %al,%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 c0             	movzbl %al,%eax
 1a2:	29 c2                	sub    %eax,%edx
 1a4:	89 d0                	mov    %edx,%eax
}
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret    

000001a8 <strlen>:

uint
strlen(const char *s)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b5:	eb 04                	jmp    1bb <strlen+0x13>
 1b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 d0                	add    %edx,%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	75 ed                	jne    1b7 <strlen+0xf>
    ;
  return n;
 1ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d2:	8b 45 10             	mov    0x10(%ebp),%eax
 1d5:	50                   	push   %eax
 1d6:	ff 75 0c             	push   0xc(%ebp)
 1d9:	ff 75 08             	push   0x8(%ebp)
 1dc:	e8 32 ff ff ff       	call   113 <stosb>
 1e1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <strchr>:

char*
strchr(const char *s, char c)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 04             	sub    $0x4,%esp
 1ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f5:	eb 14                	jmp    20b <strchr+0x22>
    if(*s == c)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	38 45 fc             	cmp    %al,-0x4(%ebp)
 200:	75 05                	jne    207 <strchr+0x1e>
      return (char*)s;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	eb 13                	jmp    21a <strchr+0x31>
  for(; *s; s++)
 207:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	84 c0                	test   %al,%al
 213:	75 e2                	jne    1f7 <strchr+0xe>
  return 0;
 215:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 229:	eb 42                	jmp    26d <gets+0x51>
    cc = read(0, &c, 1);
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	6a 01                	push   $0x1
 230:	8d 45 ef             	lea    -0x11(%ebp),%eax
 233:	50                   	push   %eax
 234:	6a 00                	push   $0x0
 236:	e8 83 01 00 00       	call   3be <read>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 245:	7e 33                	jle    27a <gets+0x5e>
      break;
    buf[i++] = c;
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 250:	89 c2                	mov    %eax,%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 c2                	add    %eax,%edx
 257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 261:	3c 0a                	cmp    $0xa,%al
 263:	74 16                	je     27b <gets+0x5f>
 265:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 269:	3c 0d                	cmp    $0xd,%al
 26b:	74 0e                	je     27b <gets+0x5f>
  for(i=0; i+1 < max; ){
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	83 c0 01             	add    $0x1,%eax
 273:	39 45 0c             	cmp    %eax,0xc(%ebp)
 276:	7f b3                	jg     22b <gets+0xf>
 278:	eb 01                	jmp    27b <gets+0x5f>
      break;
 27a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 27b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	01 d0                	add    %edx,%eax
 283:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 286:	8b 45 08             	mov    0x8(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <stat>:

int
stat(const char *n, struct stat *st)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 291:	83 ec 08             	sub    $0x8,%esp
 294:	6a 00                	push   $0x0
 296:	ff 75 08             	push   0x8(%ebp)
 299:	e8 48 01 00 00       	call   3e6 <open>
 29e:	83 c4 10             	add    $0x10,%esp
 2a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a8:	79 07                	jns    2b1 <stat+0x26>
    return -1;
 2aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2af:	eb 25                	jmp    2d6 <stat+0x4b>
  r = fstat(fd, st);
 2b1:	83 ec 08             	sub    $0x8,%esp
 2b4:	ff 75 0c             	push   0xc(%ebp)
 2b7:	ff 75 f4             	push   -0xc(%ebp)
 2ba:	e8 3f 01 00 00       	call   3fe <fstat>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c5:	83 ec 0c             	sub    $0xc,%esp
 2c8:	ff 75 f4             	push   -0xc(%ebp)
 2cb:	e8 fe 00 00 00       	call   3ce <close>
 2d0:	83 c4 10             	add    $0x10,%esp
  return r;
 2d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <atoi>:

int
atoi(const char *s)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e5:	eb 25                	jmp    30c <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ea:	89 d0                	mov    %edx,%eax
 2ec:	c1 e0 02             	shl    $0x2,%eax
 2ef:	01 d0                	add    %edx,%eax
 2f1:	01 c0                	add    %eax,%eax
 2f3:	89 c1                	mov    %eax,%ecx
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	8d 50 01             	lea    0x1(%eax),%edx
 2fb:	89 55 08             	mov    %edx,0x8(%ebp)
 2fe:	0f b6 00             	movzbl (%eax),%eax
 301:	0f be c0             	movsbl %al,%eax
 304:	01 c8                	add    %ecx,%eax
 306:	83 e8 30             	sub    $0x30,%eax
 309:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	3c 2f                	cmp    $0x2f,%al
 314:	7e 0a                	jle    320 <atoi+0x48>
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	3c 39                	cmp    $0x39,%al
 31e:	7e c7                	jle    2e7 <atoi+0xf>
  return n;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 337:	eb 17                	jmp    350 <memmove+0x2b>
    *dst++ = *src++;
 339:	8b 55 f8             	mov    -0x8(%ebp),%edx
 33c:	8d 42 01             	lea    0x1(%edx),%eax
 33f:	89 45 f8             	mov    %eax,-0x8(%ebp)
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	8d 48 01             	lea    0x1(%eax),%ecx
 348:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 34b:	0f b6 12             	movzbl (%edx),%edx
 34e:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 350:	8b 45 10             	mov    0x10(%ebp),%eax
 353:	8d 50 ff             	lea    -0x1(%eax),%edx
 356:	89 55 10             	mov    %edx,0x10(%ebp)
 359:	85 c0                	test   %eax,%eax
 35b:	7f dc                	jg     339 <memmove+0x14>
  return vdst;
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp

}
 365:	90                   	nop
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <acquireLock>:

void acquireLock(struct lock* l) {
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp

}
 36b:	90                   	nop
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    

0000036e <releaseLock>:

void releaseLock(struct lock* l) {
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp

}
 371:	90                   	nop
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp

}
 377:	90                   	nop
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp

}
 37d:	90                   	nop
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <broadcast>:

void broadcast(struct condvar* cv) {
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp

}
 383:	90                   	nop
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    

00000386 <signal>:

void signal(struct condvar* cv) {
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp

}
 389:	90                   	nop
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    

0000038c <semInit>:

void semInit(struct semaphore* s, int initVal) {
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp

}
 38f:	90                   	nop
 390:	5d                   	pop    %ebp
 391:	c3                   	ret    

00000392 <semUp>:

void semUp(struct semaphore* s) {
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp

}
 395:	90                   	nop
 396:	5d                   	pop    %ebp
 397:	c3                   	ret    

00000398 <semDown>:

void semDown(struct semaphore* s) {
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp

}
 39b:	90                   	nop
 39c:	5d                   	pop    %ebp
 39d:	c3                   	ret    

0000039e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39e:	b8 01 00 00 00       	mov    $0x1,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <exit>:
SYSCALL(exit)
 3a6:	b8 02 00 00 00       	mov    $0x2,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <wait>:
SYSCALL(wait)
 3ae:	b8 03 00 00 00       	mov    $0x3,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <pipe>:
SYSCALL(pipe)
 3b6:	b8 04 00 00 00       	mov    $0x4,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <read>:
SYSCALL(read)
 3be:	b8 05 00 00 00       	mov    $0x5,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <write>:
SYSCALL(write)
 3c6:	b8 10 00 00 00       	mov    $0x10,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <close>:
SYSCALL(close)
 3ce:	b8 15 00 00 00       	mov    $0x15,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <kill>:
SYSCALL(kill)
 3d6:	b8 06 00 00 00       	mov    $0x6,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <exec>:
SYSCALL(exec)
 3de:	b8 07 00 00 00       	mov    $0x7,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <open>:
SYSCALL(open)
 3e6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <mknod>:
SYSCALL(mknod)
 3ee:	b8 11 00 00 00       	mov    $0x11,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <unlink>:
SYSCALL(unlink)
 3f6:	b8 12 00 00 00       	mov    $0x12,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <fstat>:
SYSCALL(fstat)
 3fe:	b8 08 00 00 00       	mov    $0x8,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <link>:
SYSCALL(link)
 406:	b8 13 00 00 00       	mov    $0x13,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <mkdir>:
SYSCALL(mkdir)
 40e:	b8 14 00 00 00       	mov    $0x14,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <chdir>:
SYSCALL(chdir)
 416:	b8 09 00 00 00       	mov    $0x9,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <dup>:
SYSCALL(dup)
 41e:	b8 0a 00 00 00       	mov    $0xa,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <getpid>:
SYSCALL(getpid)
 426:	b8 0b 00 00 00       	mov    $0xb,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <sbrk>:
SYSCALL(sbrk)
 42e:	b8 0c 00 00 00       	mov    $0xc,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <sleep>:
SYSCALL(sleep)
 436:	b8 0d 00 00 00       	mov    $0xd,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <uptime>:
SYSCALL(uptime)
 43e:	b8 0e 00 00 00       	mov    $0xe,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <thread_create>:
SYSCALL(thread_create)
 446:	b8 16 00 00 00       	mov    $0x16,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <thread_exit>:
SYSCALL(thread_exit)
 44e:	b8 17 00 00 00       	mov    $0x17,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <thread_join>:
SYSCALL(thread_join)
 456:	b8 18 00 00 00       	mov    $0x18,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <waitpid>:
SYSCALL(waitpid)
 45e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <barrier_init>:
SYSCALL(barrier_init)
 466:	b8 1f 00 00 00       	mov    $0x1f,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <barrier_check>:
SYSCALL(barrier_check)
 46e:	b8 20 00 00 00       	mov    $0x20,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <sleepChan>:
SYSCALL(sleepChan)
 476:	b8 24 00 00 00       	mov    $0x24,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <getChannel>:
SYSCALL(getChannel)
 47e:	b8 25 00 00 00       	mov    $0x25,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <sigChan>:
SYSCALL(sigChan)
 486:	b8 26 00 00 00       	mov    $0x26,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <sigOneChan>:
 48e:	b8 27 00 00 00       	mov    $0x27,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    
