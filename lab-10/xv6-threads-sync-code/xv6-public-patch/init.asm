
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 10 09 00 00       	push   $0x910
  1b:	e8 b4 03 00 00       	call   3d4 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 10 09 00 00       	push   $0x910
  33:	e8 a4 03 00 00       	call   3dc <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 10 09 00 00       	push   $0x910
  45:	e8 8a 03 00 00       	call   3d4 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 b5 03 00 00       	call   40c <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 a8 03 00 00       	call   40c <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 18 09 00 00       	push   $0x918
  6f:	6a 01                	push   $0x1
  71:	e8 e1 04 00 00       	call   557 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 0e 03 00 00       	call   38c <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 2b 09 00 00       	push   $0x92b
  8f:	6a 01                	push   $0x1
  91:	e8 c1 04 00 00       	call   557 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 f6 02 00 00       	call   394 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 e8 0c 00 00       	push   $0xce8
  ac:	68 0d 09 00 00       	push   $0x90d
  b1:	e8 16 03 00 00       	call   3cc <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 3e 09 00 00       	push   $0x93e
  c1:	6a 01                	push   $0x1
  c3:	e8 8f 04 00 00       	call   557 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 c4 02 00 00       	call   394 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 54 09 00 00       	push   $0x954
  d8:	6a 01                	push   $0x1
  da:	e8 78 04 00 00       	call   557 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 b5 02 00 00       	call   39c <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
    printf(1, "init: starting sh\n");
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
 137:	8d 42 01             	lea    0x1(%edx),%eax
 13a:	89 45 0c             	mov    %eax,0xc(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	8d 48 01             	lea    0x1(%eax),%ecx
 143:	89 4d 08             	mov    %ecx,0x8(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(const char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	push   0xc(%ebp)
 1c7:	ff 75 08             	push   0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 83 01 00 00       	call   3ac <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	39 45 0c             	cmp    %eax,0xc(%ebp)
 264:	7f b3                	jg     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
      break;
 268:	90                   	nop
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(const char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	push   0x8(%ebp)
 287:	e8 48 01 00 00       	call   3d4 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	push   0xc(%ebp)
 2a5:	ff 75 f4             	push   -0xc(%ebp)
 2a8:	e8 3f 01 00 00       	call   3ec <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	push   -0xc(%ebp)
 2b9:	e8 fe 00 00 00       	call   3bc <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32a:	8d 42 01             	lea    0x1(%edx),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
 333:	8d 48 01             	lea    0x1(%eax),%ecx
 336:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp

}
 353:	90                   	nop
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    

00000356 <acquireLock>:

void acquireLock(struct lock* l) {
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp

}
 359:	90                   	nop
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <releaseLock>:

void releaseLock(struct lock* l) {
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp

}
 35f:	90                   	nop
 360:	5d                   	pop    %ebp
 361:	c3                   	ret    

00000362 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp

}
 365:	90                   	nop
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp

}
 36b:	90                   	nop
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    

0000036e <broadcast>:

void broadcast(struct condvar* cv) {
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp

}
 371:	90                   	nop
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <signal>:

void signal(struct condvar* cv) {
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp

}
 377:	90                   	nop
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <semInit>:

void semInit(struct semaphore* s, int initVal) {
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp

}
 37d:	90                   	nop
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <semUp>:

void semUp(struct semaphore* s) {
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp

}
 383:	90                   	nop
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    

00000386 <semDown>:

void semDown(struct semaphore* s) {
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp

}
 389:	90                   	nop
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    

0000038c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <exit>:
SYSCALL(exit)
 394:	b8 02 00 00 00       	mov    $0x2,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <wait>:
SYSCALL(wait)
 39c:	b8 03 00 00 00       	mov    $0x3,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <pipe>:
SYSCALL(pipe)
 3a4:	b8 04 00 00 00       	mov    $0x4,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <read>:
SYSCALL(read)
 3ac:	b8 05 00 00 00       	mov    $0x5,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <write>:
SYSCALL(write)
 3b4:	b8 10 00 00 00       	mov    $0x10,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <close>:
SYSCALL(close)
 3bc:	b8 15 00 00 00       	mov    $0x15,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <kill>:
SYSCALL(kill)
 3c4:	b8 06 00 00 00       	mov    $0x6,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exec>:
SYSCALL(exec)
 3cc:	b8 07 00 00 00       	mov    $0x7,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <open>:
SYSCALL(open)
 3d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mknod>:
SYSCALL(mknod)
 3dc:	b8 11 00 00 00       	mov    $0x11,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <unlink>:
SYSCALL(unlink)
 3e4:	b8 12 00 00 00       	mov    $0x12,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <fstat>:
SYSCALL(fstat)
 3ec:	b8 08 00 00 00       	mov    $0x8,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <link>:
SYSCALL(link)
 3f4:	b8 13 00 00 00       	mov    $0x13,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mkdir>:
SYSCALL(mkdir)
 3fc:	b8 14 00 00 00       	mov    $0x14,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <chdir>:
SYSCALL(chdir)
 404:	b8 09 00 00 00       	mov    $0x9,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <dup>:
SYSCALL(dup)
 40c:	b8 0a 00 00 00       	mov    $0xa,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <getpid>:
SYSCALL(getpid)
 414:	b8 0b 00 00 00       	mov    $0xb,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sbrk>:
SYSCALL(sbrk)
 41c:	b8 0c 00 00 00       	mov    $0xc,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sleep>:
SYSCALL(sleep)
 424:	b8 0d 00 00 00       	mov    $0xd,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <uptime>:
SYSCALL(uptime)
 42c:	b8 0e 00 00 00       	mov    $0xe,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <thread_create>:
SYSCALL(thread_create)
 434:	b8 16 00 00 00       	mov    $0x16,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <thread_exit>:
SYSCALL(thread_exit)
 43c:	b8 17 00 00 00       	mov    $0x17,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <thread_join>:
SYSCALL(thread_join)
 444:	b8 18 00 00 00       	mov    $0x18,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <waitpid>:
SYSCALL(waitpid)
 44c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <barrier_init>:
SYSCALL(barrier_init)
 454:	b8 1f 00 00 00       	mov    $0x1f,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <barrier_check>:
SYSCALL(barrier_check)
 45c:	b8 20 00 00 00       	mov    $0x20,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <sleepChan>:
SYSCALL(sleepChan)
 464:	b8 24 00 00 00       	mov    $0x24,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getChannel>:
SYSCALL(getChannel)
 46c:	b8 25 00 00 00       	mov    $0x25,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <sigChan>:
SYSCALL(sigChan)
 474:	b8 26 00 00 00       	mov    $0x26,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <sigOneChan>:
 47c:	b8 27 00 00 00       	mov    $0x27,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 18             	sub    $0x18,%esp
 48a:	8b 45 0c             	mov    0xc(%ebp),%eax
 48d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 490:	83 ec 04             	sub    $0x4,%esp
 493:	6a 01                	push   $0x1
 495:	8d 45 f4             	lea    -0xc(%ebp),%eax
 498:	50                   	push   %eax
 499:	ff 75 08             	push   0x8(%ebp)
 49c:	e8 13 ff ff ff       	call   3b4 <write>
 4a1:	83 c4 10             	add    $0x10,%esp
}
 4a4:	90                   	nop
 4a5:	c9                   	leave  
 4a6:	c3                   	ret    

000004a7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b8:	74 17                	je     4d1 <printint+0x2a>
 4ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4be:	79 11                	jns    4d1 <printint+0x2a>
    neg = 1;
 4c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ca:	f7 d8                	neg    %eax
 4cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cf:	eb 06                	jmp    4d7 <printint+0x30>
  } else {
    x = xx;
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4de:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e4:	ba 00 00 00 00       	mov    $0x0,%edx
 4e9:	f7 f1                	div    %ecx
 4eb:	89 d1                	mov    %edx,%ecx
 4ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f0:	8d 50 01             	lea    0x1(%eax),%edx
 4f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f6:	0f b6 91 f0 0c 00 00 	movzbl 0xcf0(%ecx),%edx
 4fd:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 501:	8b 4d 10             	mov    0x10(%ebp),%ecx
 504:	8b 45 ec             	mov    -0x14(%ebp),%eax
 507:	ba 00 00 00 00       	mov    $0x0,%edx
 50c:	f7 f1                	div    %ecx
 50e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 511:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 515:	75 c7                	jne    4de <printint+0x37>
  if(neg)
 517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51b:	74 2d                	je     54a <printint+0xa3>
    buf[i++] = '-';
 51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 520:	8d 50 01             	lea    0x1(%eax),%edx
 523:	89 55 f4             	mov    %edx,-0xc(%ebp)
 526:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52b:	eb 1d                	jmp    54a <printint+0xa3>
    putc(fd, buf[i]);
 52d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	01 d0                	add    %edx,%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	push   0x8(%ebp)
 542:	e8 3d ff ff ff       	call   484 <putc>
 547:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 54a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 54e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 552:	79 d9                	jns    52d <printint+0x86>
}
 554:	90                   	nop
 555:	c9                   	leave  
 556:	c3                   	ret    

00000557 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 557:	55                   	push   %ebp
 558:	89 e5                	mov    %esp,%ebp
 55a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 564:	8d 45 0c             	lea    0xc(%ebp),%eax
 567:	83 c0 04             	add    $0x4,%eax
 56a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 574:	e9 59 01 00 00       	jmp    6d2 <printf+0x17b>
    c = fmt[i] & 0xff;
 579:	8b 55 0c             	mov    0xc(%ebp),%edx
 57c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57f:	01 d0                	add    %edx,%eax
 581:	0f b6 00             	movzbl (%eax),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	25 ff 00 00 00       	and    $0xff,%eax
 58c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 593:	75 2c                	jne    5c1 <printf+0x6a>
      if(c == '%'){
 595:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 599:	75 0c                	jne    5a7 <printf+0x50>
        state = '%';
 59b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a2:	e9 27 01 00 00       	jmp    6ce <printf+0x177>
      } else {
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	83 ec 08             	sub    $0x8,%esp
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	push   0x8(%ebp)
 5b4:	e8 cb fe ff ff       	call   484 <putc>
 5b9:	83 c4 10             	add    $0x10,%esp
 5bc:	e9 0d 01 00 00       	jmp    6ce <printf+0x177>
      }
    } else if(state == '%'){
 5c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c5:	0f 85 03 01 00 00    	jne    6ce <printf+0x177>
      if(c == 'd'){
 5cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5cf:	75 1e                	jne    5ef <printf+0x98>
        printint(fd, *ap, 10, 1);
 5d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	6a 01                	push   $0x1
 5d8:	6a 0a                	push   $0xa
 5da:	50                   	push   %eax
 5db:	ff 75 08             	push   0x8(%ebp)
 5de:	e8 c4 fe ff ff       	call   4a7 <printint>
 5e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ea:	e9 d8 00 00 00       	jmp    6c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5f3:	74 06                	je     5fb <printf+0xa4>
 5f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f9:	75 1e                	jne    619 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	6a 00                	push   $0x0
 602:	6a 10                	push   $0x10
 604:	50                   	push   %eax
 605:	ff 75 08             	push   0x8(%ebp)
 608:	e8 9a fe ff ff       	call   4a7 <printint>
 60d:	83 c4 10             	add    $0x10,%esp
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 614:	e9 ae 00 00 00       	jmp    6c7 <printf+0x170>
      } else if(c == 's'){
 619:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 61d:	75 43                	jne    662 <printf+0x10b>
        s = (char*)*ap;
 61f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 627:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 62b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62f:	75 25                	jne    656 <printf+0xff>
          s = "(null)";
 631:	c7 45 f4 5d 09 00 00 	movl   $0x95d,-0xc(%ebp)
        while(*s != 0){
 638:	eb 1c                	jmp    656 <printf+0xff>
          putc(fd, *s);
 63a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	83 ec 08             	sub    $0x8,%esp
 646:	50                   	push   %eax
 647:	ff 75 08             	push   0x8(%ebp)
 64a:	e8 35 fe ff ff       	call   484 <putc>
 64f:	83 c4 10             	add    $0x10,%esp
          s++;
 652:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 656:	8b 45 f4             	mov    -0xc(%ebp),%eax
 659:	0f b6 00             	movzbl (%eax),%eax
 65c:	84 c0                	test   %al,%al
 65e:	75 da                	jne    63a <printf+0xe3>
 660:	eb 65                	jmp    6c7 <printf+0x170>
        }
      } else if(c == 'c'){
 662:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 666:	75 1d                	jne    685 <printf+0x12e>
        putc(fd, *ap);
 668:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	83 ec 08             	sub    $0x8,%esp
 673:	50                   	push   %eax
 674:	ff 75 08             	push   0x8(%ebp)
 677:	e8 08 fe ff ff       	call   484 <putc>
 67c:	83 c4 10             	add    $0x10,%esp
        ap++;
 67f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 683:	eb 42                	jmp    6c7 <printf+0x170>
      } else if(c == '%'){
 685:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 689:	75 17                	jne    6a2 <printf+0x14b>
        putc(fd, c);
 68b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	83 ec 08             	sub    $0x8,%esp
 694:	50                   	push   %eax
 695:	ff 75 08             	push   0x8(%ebp)
 698:	e8 e7 fd ff ff       	call   484 <putc>
 69d:	83 c4 10             	add    $0x10,%esp
 6a0:	eb 25                	jmp    6c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a2:	83 ec 08             	sub    $0x8,%esp
 6a5:	6a 25                	push   $0x25
 6a7:	ff 75 08             	push   0x8(%ebp)
 6aa:	e8 d5 fd ff ff       	call   484 <putc>
 6af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	83 ec 08             	sub    $0x8,%esp
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	push   0x8(%ebp)
 6bf:	e8 c0 fd ff ff       	call   484 <putc>
 6c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	01 d0                	add    %edx,%eax
 6da:	0f b6 00             	movzbl (%eax),%eax
 6dd:	84 c0                	test   %al,%al
 6df:	0f 85 94 fe ff ff    	jne    579 <printf+0x22>
    }
  }
}
 6e5:	90                   	nop
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	83 e8 08             	sub    $0x8,%eax
 6f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f7:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 6fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ff:	eb 24                	jmp    725 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 709:	72 12                	jb     71d <free+0x35>
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 711:	77 24                	ja     737 <free+0x4f>
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 71b:	72 1a                	jb     737 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	89 45 fc             	mov    %eax,-0x4(%ebp)
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72b:	76 d4                	jbe    701 <free+0x19>
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 735:	73 ca                	jae    701 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	01 c2                	add    %eax,%edx
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	39 c2                	cmp    %eax,%edx
 750:	75 24                	jne    776 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	8b 50 04             	mov    0x4(%eax),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	01 c2                	add    %eax,%edx
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	8b 10                	mov    (%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 10                	mov    %edx,(%eax)
 774:	eb 0a                	jmp    780 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	01 d0                	add    %edx,%eax
 792:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 795:	75 20                	jne    7b7 <free+0xcf>
    p->s.size += bp->s.size;
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 50 04             	mov    0x4(%eax),%edx
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	01 c2                	add    %eax,%edx
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	8b 10                	mov    (%eax),%edx
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	89 10                	mov    %edx,(%eax)
 7b5:	eb 08                	jmp    7bf <free+0xd7>
  } else
    p->s.ptr = bp;
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7bd:	89 10                	mov    %edx,(%eax)
  freep = p;
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 7c7:	90                   	nop
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    

000007ca <morecore>:

static Header*
morecore(uint nu)
{
 7ca:	55                   	push   %ebp
 7cb:	89 e5                	mov    %esp,%ebp
 7cd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d7:	77 07                	ja     7e0 <morecore+0x16>
    nu = 4096;
 7d9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	c1 e0 03             	shl    $0x3,%eax
 7e6:	83 ec 0c             	sub    $0xc,%esp
 7e9:	50                   	push   %eax
 7ea:	e8 2d fc ff ff       	call   41c <sbrk>
 7ef:	83 c4 10             	add    $0x10,%esp
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f9:	75 07                	jne    802 <morecore+0x38>
    return 0;
 7fb:	b8 00 00 00 00       	mov    $0x0,%eax
 800:	eb 26                	jmp    828 <morecore+0x5e>
  hp = (Header*)p;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	8b 55 08             	mov    0x8(%ebp),%edx
 80e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	83 c0 08             	add    $0x8,%eax
 817:	83 ec 0c             	sub    $0xc,%esp
 81a:	50                   	push   %eax
 81b:	e8 c8 fe ff ff       	call   6e8 <free>
 820:	83 c4 10             	add    $0x10,%esp
  return freep;
 823:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 828:	c9                   	leave  
 829:	c3                   	ret    

0000082a <malloc>:

void*
malloc(uint nbytes)
{
 82a:	55                   	push   %ebp
 82b:	89 e5                	mov    %esp,%ebp
 82d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 830:	8b 45 08             	mov    0x8(%ebp),%eax
 833:	83 c0 07             	add    $0x7,%eax
 836:	c1 e8 03             	shr    $0x3,%eax
 839:	83 c0 01             	add    $0x1,%eax
 83c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83f:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 844:	89 45 f0             	mov    %eax,-0x10(%ebp)
 847:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 84b:	75 23                	jne    870 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84d:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 85c:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 861:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 866:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 86d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 881:	77 4d                	ja     8d0 <malloc+0xa6>
      if(p->s.size == nunits)
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 40 04             	mov    0x4(%eax),%eax
 889:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 88c:	75 0c                	jne    89a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	8b 10                	mov    (%eax),%edx
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	89 10                	mov    %edx,(%eax)
 898:	eb 26                	jmp    8c0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a3:	89 c2                	mov    %eax,%edx
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 40 04             	mov    0x4(%eax),%eax
 8b1:	c1 e0 03             	shl    $0x3,%eax
 8b4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8bd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	83 c0 08             	add    $0x8,%eax
 8ce:	eb 3b                	jmp    90b <malloc+0xe1>
    }
    if(p == freep)
 8d0:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 8d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d8:	75 1e                	jne    8f8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8da:	83 ec 0c             	sub    $0xc,%esp
 8dd:	ff 75 ec             	push   -0x14(%ebp)
 8e0:	e8 e5 fe ff ff       	call   7ca <morecore>
 8e5:	83 c4 10             	add    $0x10,%esp
 8e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ef:	75 07                	jne    8f8 <malloc+0xce>
        return 0;
 8f1:	b8 00 00 00 00       	mov    $0x0,%eax
 8f6:	eb 13                	jmp    90b <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 00                	mov    (%eax),%eax
 903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 906:	e9 6d ff ff ff       	jmp    878 <malloc+0x4e>
  }
}
 90b:	c9                   	leave  
 90c:	c3                   	ret    
