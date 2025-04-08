
_t_waitpid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int ret;
  
  ret = fork();
  11:	e8 2a 03 00 00       	call   340 <fork>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ret == 0)
  19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1d:	75 12                	jne    31 <main+0x31>
  {
    sleep(10);
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 0a                	push   $0xa
  24:	e8 af 03 00 00       	call   3d8 <sleep>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 17 03 00 00       	call   348 <exit>
  }
  else
  {
    int retwait = waitpid(ret+1);
  31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	83 ec 0c             	sub    $0xc,%esp
  3a:	50                   	push   %eax
  3b:	e8 c0 03 00 00       	call   400 <waitpid>
  40:	83 c4 10             	add    $0x10,%esp
  43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1, "return value of wrong waitpid %d\n", retwait);
  46:	83 ec 04             	sub    $0x4,%esp
  49:	ff 75 f0             	push   -0x10(%ebp)
  4c:	68 c4 08 00 00       	push   $0x8c4
  51:	6a 01                	push   $0x1
  53:	e8 b3 04 00 00       	call   50b <printf>
  58:	83 c4 10             	add    $0x10,%esp

    retwait = waitpid(ret);
  5b:	83 ec 0c             	sub    $0xc,%esp
  5e:	ff 75 f4             	push   -0xc(%ebp)
  61:	e8 9a 03 00 00       	call   400 <waitpid>
  66:	83 c4 10             	add    $0x10,%esp
  69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1, "return value of correct waitpid %d\n", retwait);
  6c:	83 ec 04             	sub    $0x4,%esp
  6f:	ff 75 f0             	push   -0x10(%ebp)
  72:	68 e8 08 00 00       	push   $0x8e8
  77:	6a 01                	push   $0x1
  79:	e8 8d 04 00 00       	call   50b <printf>
  7e:	83 c4 10             	add    $0x10,%esp
    
    retwait = wait();
  81:	e8 ca 02 00 00       	call   350 <wait>
  86:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1, "return value of wait %d\n", retwait);
  89:	83 ec 04             	sub    $0x4,%esp
  8c:	ff 75 f0             	push   -0x10(%ebp)
  8f:	68 0c 09 00 00       	push   $0x90c
  94:	6a 01                	push   $0x1
  96:	e8 70 04 00 00       	call   50b <printf>
  9b:	83 c4 10             	add    $0x10,%esp
    
    printf(1, "child reaped\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 25 09 00 00       	push   $0x925
  a6:	6a 01                	push   $0x1
  a8:	e8 5e 04 00 00       	call   50b <printf>
  ad:	83 c4 10             	add    $0x10,%esp
    exit();
  b0:	e8 93 02 00 00       	call   348 <exit>

000000b5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bd:	8b 55 10             	mov    0x10(%ebp),%edx
  c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  c3:	89 cb                	mov    %ecx,%ebx
  c5:	89 df                	mov    %ebx,%edi
  c7:	89 d1                	mov    %edx,%ecx
  c9:	fc                   	cld    
  ca:	f3 aa                	rep stos %al,%es:(%edi)
  cc:	89 ca                	mov    %ecx,%edx
  ce:	89 fb                	mov    %edi,%ebx
  d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d6:	90                   	nop
  d7:	5b                   	pop    %ebx
  d8:	5f                   	pop    %edi
  d9:	5d                   	pop    %ebp
  da:	c3                   	ret    

000000db <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e7:	90                   	nop
  e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  eb:	8d 42 01             	lea    0x1(%edx),%eax
  ee:	89 45 0c             	mov    %eax,0xc(%ebp)
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	8d 48 01             	lea    0x1(%eax),%ecx
  f7:	89 4d 08             	mov    %ecx,0x8(%ebp)
  fa:	0f b6 12             	movzbl (%edx),%edx
  fd:	88 10                	mov    %dl,(%eax)
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	84 c0                	test   %al,%al
 104:	75 e2                	jne    e8 <strcpy+0xd>
    ;
  return os;
 106:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 109:	c9                   	leave  
 10a:	c3                   	ret    

0000010b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 10e:	eb 08                	jmp    118 <strcmp+0xd>
    p++, q++;
 110:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 114:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	74 10                	je     132 <strcmp+0x27>
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 10             	movzbl (%eax),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	38 c2                	cmp    %al,%dl
 130:	74 de                	je     110 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	0f b6 00             	movzbl (%eax),%eax
 138:	0f b6 d0             	movzbl %al,%edx
 13b:	8b 45 0c             	mov    0xc(%ebp),%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	0f b6 c0             	movzbl %al,%eax
 144:	29 c2                	sub    %eax,%edx
 146:	89 d0                	mov    %edx,%eax
}
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 157:	eb 04                	jmp    15d <strlen+0x13>
 159:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	01 d0                	add    %edx,%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	75 ed                	jne    159 <strlen+0xf>
    ;
  return n;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <memset>:

void*
memset(void *dst, int c, uint n)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 174:	8b 45 10             	mov    0x10(%ebp),%eax
 177:	50                   	push   %eax
 178:	ff 75 0c             	push   0xc(%ebp)
 17b:	ff 75 08             	push   0x8(%ebp)
 17e:	e8 32 ff ff ff       	call   b5 <stosb>
 183:	83 c4 0c             	add    $0xc,%esp
  return dst;
 186:	8b 45 08             	mov    0x8(%ebp),%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <strchr>:

char*
strchr(const char *s, char c)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	83 ec 04             	sub    $0x4,%esp
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 197:	eb 14                	jmp    1ad <strchr+0x22>
    if(*s == c)
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1a2:	75 05                	jne    1a9 <strchr+0x1e>
      return (char*)s;
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	eb 13                	jmp    1bc <strchr+0x31>
  for(; *s; s++)
 1a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	84 c0                	test   %al,%al
 1b5:	75 e2                	jne    199 <strchr+0xe>
  return 0;
 1b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <gets>:

char*
gets(char *buf, int max)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1cb:	eb 42                	jmp    20f <gets+0x51>
    cc = read(0, &c, 1);
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	6a 01                	push   $0x1
 1d2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d5:	50                   	push   %eax
 1d6:	6a 00                	push   $0x0
 1d8:	e8 83 01 00 00       	call   360 <read>
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e7:	7e 33                	jle    21c <gets+0x5e>
      break;
    buf[i++] = c;
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	8d 50 01             	lea    0x1(%eax),%edx
 1ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f2:	89 c2                	mov    %eax,%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 c2                	add    %eax,%edx
 1f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 203:	3c 0a                	cmp    $0xa,%al
 205:	74 16                	je     21d <gets+0x5f>
 207:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20b:	3c 0d                	cmp    $0xd,%al
 20d:	74 0e                	je     21d <gets+0x5f>
  for(i=0; i+1 < max; ){
 20f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 212:	83 c0 01             	add    $0x1,%eax
 215:	39 45 0c             	cmp    %eax,0xc(%ebp)
 218:	7f b3                	jg     1cd <gets+0xf>
 21a:	eb 01                	jmp    21d <gets+0x5f>
      break;
 21c:	90                   	nop
      break;
  }
  buf[i] = '\0';
 21d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	01 d0                	add    %edx,%eax
 225:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 228:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <stat>:

int
stat(const char *n, struct stat *st)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 233:	83 ec 08             	sub    $0x8,%esp
 236:	6a 00                	push   $0x0
 238:	ff 75 08             	push   0x8(%ebp)
 23b:	e8 48 01 00 00       	call   388 <open>
 240:	83 c4 10             	add    $0x10,%esp
 243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24a:	79 07                	jns    253 <stat+0x26>
    return -1;
 24c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 251:	eb 25                	jmp    278 <stat+0x4b>
  r = fstat(fd, st);
 253:	83 ec 08             	sub    $0x8,%esp
 256:	ff 75 0c             	push   0xc(%ebp)
 259:	ff 75 f4             	push   -0xc(%ebp)
 25c:	e8 3f 01 00 00       	call   3a0 <fstat>
 261:	83 c4 10             	add    $0x10,%esp
 264:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 267:	83 ec 0c             	sub    $0xc,%esp
 26a:	ff 75 f4             	push   -0xc(%ebp)
 26d:	e8 fe 00 00 00       	call   370 <close>
 272:	83 c4 10             	add    $0x10,%esp
  return r;
 275:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <atoi>:

int
atoi(const char *s)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 287:	eb 25                	jmp    2ae <atoi+0x34>
    n = n*10 + *s++ - '0';
 289:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28c:	89 d0                	mov    %edx,%eax
 28e:	c1 e0 02             	shl    $0x2,%eax
 291:	01 d0                	add    %edx,%eax
 293:	01 c0                	add    %eax,%eax
 295:	89 c1                	mov    %eax,%ecx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 08             	mov    %edx,0x8(%ebp)
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	0f be c0             	movsbl %al,%eax
 2a6:	01 c8                	add    %ecx,%eax
 2a8:	83 e8 30             	sub    $0x30,%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 2f                	cmp    $0x2f,%al
 2b6:	7e 0a                	jle    2c2 <atoi+0x48>
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	3c 39                	cmp    $0x39,%al
 2c0:	7e c7                	jle    289 <atoi+0xf>
  return n;
 2c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2d9:	eb 17                	jmp    2f2 <memmove+0x2b>
    *dst++ = *src++;
 2db:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2de:	8d 42 01             	lea    0x1(%edx),%eax
 2e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e7:	8d 48 01             	lea    0x1(%eax),%ecx
 2ea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ed:	0f b6 12             	movzbl (%edx),%edx
 2f0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2f2:	8b 45 10             	mov    0x10(%ebp),%eax
 2f5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2f8:	89 55 10             	mov    %edx,0x10(%ebp)
 2fb:	85 c0                	test   %eax,%eax
 2fd:	7f dc                	jg     2db <memmove+0x14>
  return vdst;
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 302:	c9                   	leave  
 303:	c3                   	ret    

00000304 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp

}
 307:	90                   	nop
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    

0000030a <acquireLock>:

void acquireLock(struct lock* l) {
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp

}
 30d:	90                   	nop
 30e:	5d                   	pop    %ebp
 30f:	c3                   	ret    

00000310 <releaseLock>:

void releaseLock(struct lock* l) {
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp

}
 313:	90                   	nop
 314:	5d                   	pop    %ebp
 315:	c3                   	ret    

00000316 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 316:	55                   	push   %ebp
 317:	89 e5                	mov    %esp,%ebp

}
 319:	90                   	nop
 31a:	5d                   	pop    %ebp
 31b:	c3                   	ret    

0000031c <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp

}
 31f:	90                   	nop
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    

00000322 <broadcast>:

void broadcast(struct condvar* cv) {
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp

}
 325:	90                   	nop
 326:	5d                   	pop    %ebp
 327:	c3                   	ret    

00000328 <signal>:

void signal(struct condvar* cv) {
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp

}
 32b:	90                   	nop
 32c:	5d                   	pop    %ebp
 32d:	c3                   	ret    

0000032e <semInit>:

void semInit(struct semaphore* s, int initVal) {
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp

}
 331:	90                   	nop
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    

00000334 <semUp>:

void semUp(struct semaphore* s) {
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp

}
 337:	90                   	nop
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    

0000033a <semDown>:

void semDown(struct semaphore* s) {
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp

}
 33d:	90                   	nop
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    

00000340 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 340:	b8 01 00 00 00       	mov    $0x1,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <exit>:
SYSCALL(exit)
 348:	b8 02 00 00 00       	mov    $0x2,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <wait>:
SYSCALL(wait)
 350:	b8 03 00 00 00       	mov    $0x3,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <pipe>:
SYSCALL(pipe)
 358:	b8 04 00 00 00       	mov    $0x4,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <read>:
SYSCALL(read)
 360:	b8 05 00 00 00       	mov    $0x5,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <write>:
SYSCALL(write)
 368:	b8 10 00 00 00       	mov    $0x10,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <close>:
SYSCALL(close)
 370:	b8 15 00 00 00       	mov    $0x15,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <kill>:
SYSCALL(kill)
 378:	b8 06 00 00 00       	mov    $0x6,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <exec>:
SYSCALL(exec)
 380:	b8 07 00 00 00       	mov    $0x7,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <open>:
SYSCALL(open)
 388:	b8 0f 00 00 00       	mov    $0xf,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mknod>:
SYSCALL(mknod)
 390:	b8 11 00 00 00       	mov    $0x11,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <unlink>:
SYSCALL(unlink)
 398:	b8 12 00 00 00       	mov    $0x12,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <fstat>:
SYSCALL(fstat)
 3a0:	b8 08 00 00 00       	mov    $0x8,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <link>:
SYSCALL(link)
 3a8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mkdir>:
SYSCALL(mkdir)
 3b0:	b8 14 00 00 00       	mov    $0x14,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <chdir>:
SYSCALL(chdir)
 3b8:	b8 09 00 00 00       	mov    $0x9,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <dup>:
SYSCALL(dup)
 3c0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getpid>:
SYSCALL(getpid)
 3c8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <sbrk>:
SYSCALL(sbrk)
 3d0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <sleep>:
SYSCALL(sleep)
 3d8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <uptime>:
SYSCALL(uptime)
 3e0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <thread_create>:
SYSCALL(thread_create)
 3e8:	b8 16 00 00 00       	mov    $0x16,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <thread_exit>:
SYSCALL(thread_exit)
 3f0:	b8 17 00 00 00       	mov    $0x17,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <thread_join>:
SYSCALL(thread_join)
 3f8:	b8 18 00 00 00       	mov    $0x18,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <waitpid>:
SYSCALL(waitpid)
 400:	b8 1e 00 00 00       	mov    $0x1e,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <barrier_init>:
SYSCALL(barrier_init)
 408:	b8 1f 00 00 00       	mov    $0x1f,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <barrier_check>:
SYSCALL(barrier_check)
 410:	b8 20 00 00 00       	mov    $0x20,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleepChan>:
SYSCALL(sleepChan)
 418:	b8 24 00 00 00       	mov    $0x24,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getChannel>:
SYSCALL(getChannel)
 420:	b8 25 00 00 00       	mov    $0x25,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sigChan>:
SYSCALL(sigChan)
 428:	b8 26 00 00 00       	mov    $0x26,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sigOneChan>:
 430:	b8 27 00 00 00       	mov    $0x27,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 18             	sub    $0x18,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 444:	83 ec 04             	sub    $0x4,%esp
 447:	6a 01                	push   $0x1
 449:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44c:	50                   	push   %eax
 44d:	ff 75 08             	push   0x8(%ebp)
 450:	e8 13 ff ff ff       	call   368 <write>
 455:	83 c4 10             	add    $0x10,%esp
}
 458:	90                   	nop
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 468:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46c:	74 17                	je     485 <printint+0x2a>
 46e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 472:	79 11                	jns    485 <printint+0x2a>
    neg = 1;
 474:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	f7 d8                	neg    %eax
 480:	89 45 ec             	mov    %eax,-0x14(%ebp)
 483:	eb 06                	jmp    48b <printint+0x30>
  } else {
    x = xx;
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 492:	8b 4d 10             	mov    0x10(%ebp),%ecx
 495:	8b 45 ec             	mov    -0x14(%ebp),%eax
 498:	ba 00 00 00 00       	mov    $0x0,%edx
 49d:	f7 f1                	div    %ecx
 49f:	89 d1                	mov    %edx,%ecx
 4a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a4:	8d 50 01             	lea    0x1(%eax),%edx
 4a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4aa:	0f b6 91 c0 0c 00 00 	movzbl 0xcc0(%ecx),%edx
 4b1:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bb:	ba 00 00 00 00       	mov    $0x0,%edx
 4c0:	f7 f1                	div    %ecx
 4c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c9:	75 c7                	jne    492 <printint+0x37>
  if(neg)
 4cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cf:	74 2d                	je     4fe <printint+0xa3>
    buf[i++] = '-';
 4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d4:	8d 50 01             	lea    0x1(%eax),%edx
 4d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4df:	eb 1d                	jmp    4fe <printint+0xa3>
    putc(fd, buf[i]);
 4e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	0f b6 00             	movzbl (%eax),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	83 ec 08             	sub    $0x8,%esp
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	push   0x8(%ebp)
 4f6:	e8 3d ff ff ff       	call   438 <putc>
 4fb:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 506:	79 d9                	jns    4e1 <printint+0x86>
}
 508:	90                   	nop
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 518:	8d 45 0c             	lea    0xc(%ebp),%eax
 51b:	83 c0 04             	add    $0x4,%eax
 51e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 528:	e9 59 01 00 00       	jmp    686 <printf+0x17b>
    c = fmt[i] & 0xff;
 52d:	8b 55 0c             	mov    0xc(%ebp),%edx
 530:	8b 45 f0             	mov    -0x10(%ebp),%eax
 533:	01 d0                	add    %edx,%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	25 ff 00 00 00       	and    $0xff,%eax
 540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 547:	75 2c                	jne    575 <printf+0x6a>
      if(c == '%'){
 549:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54d:	75 0c                	jne    55b <printf+0x50>
        state = '%';
 54f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 556:	e9 27 01 00 00       	jmp    682 <printf+0x177>
      } else {
        putc(fd, c);
 55b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	83 ec 08             	sub    $0x8,%esp
 564:	50                   	push   %eax
 565:	ff 75 08             	push   0x8(%ebp)
 568:	e8 cb fe ff ff       	call   438 <putc>
 56d:	83 c4 10             	add    $0x10,%esp
 570:	e9 0d 01 00 00       	jmp    682 <printf+0x177>
      }
    } else if(state == '%'){
 575:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 579:	0f 85 03 01 00 00    	jne    682 <printf+0x177>
      if(c == 'd'){
 57f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 583:	75 1e                	jne    5a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	6a 01                	push   $0x1
 58c:	6a 0a                	push   $0xa
 58e:	50                   	push   %eax
 58f:	ff 75 08             	push   0x8(%ebp)
 592:	e8 c4 fe ff ff       	call   45b <printint>
 597:	83 c4 10             	add    $0x10,%esp
        ap++;
 59a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59e:	e9 d8 00 00 00       	jmp    67b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a7:	74 06                	je     5af <printf+0xa4>
 5a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ad:	75 1e                	jne    5cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	6a 00                	push   $0x0
 5b6:	6a 10                	push   $0x10
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	push   0x8(%ebp)
 5bc:	e8 9a fe ff ff       	call   45b <printint>
 5c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c8:	e9 ae 00 00 00       	jmp    67b <printf+0x170>
      } else if(c == 's'){
 5cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d1:	75 43                	jne    616 <printf+0x10b>
        s = (char*)*ap;
 5d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e3:	75 25                	jne    60a <printf+0xff>
          s = "(null)";
 5e5:	c7 45 f4 33 09 00 00 	movl   $0x933,-0xc(%ebp)
        while(*s != 0){
 5ec:	eb 1c                	jmp    60a <printf+0xff>
          putc(fd, *s);
 5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	83 ec 08             	sub    $0x8,%esp
 5fa:	50                   	push   %eax
 5fb:	ff 75 08             	push   0x8(%ebp)
 5fe:	e8 35 fe ff ff       	call   438 <putc>
 603:	83 c4 10             	add    $0x10,%esp
          s++;
 606:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	84 c0                	test   %al,%al
 612:	75 da                	jne    5ee <printf+0xe3>
 614:	eb 65                	jmp    67b <printf+0x170>
        }
      } else if(c == 'c'){
 616:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61a:	75 1d                	jne    639 <printf+0x12e>
        putc(fd, *ap);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	83 ec 08             	sub    $0x8,%esp
 627:	50                   	push   %eax
 628:	ff 75 08             	push   0x8(%ebp)
 62b:	e8 08 fe ff ff       	call   438 <putc>
 630:	83 c4 10             	add    $0x10,%esp
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 637:	eb 42                	jmp    67b <printf+0x170>
      } else if(c == '%'){
 639:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63d:	75 17                	jne    656 <printf+0x14b>
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	83 ec 08             	sub    $0x8,%esp
 648:	50                   	push   %eax
 649:	ff 75 08             	push   0x8(%ebp)
 64c:	e8 e7 fd ff ff       	call   438 <putc>
 651:	83 c4 10             	add    $0x10,%esp
 654:	eb 25                	jmp    67b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 656:	83 ec 08             	sub    $0x8,%esp
 659:	6a 25                	push   $0x25
 65b:	ff 75 08             	push   0x8(%ebp)
 65e:	e8 d5 fd ff ff       	call   438 <putc>
 663:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	push   0x8(%ebp)
 673:	e8 c0 fd ff ff       	call   438 <putc>
 678:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 67b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 682:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 686:	8b 55 0c             	mov    0xc(%ebp),%edx
 689:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	0f b6 00             	movzbl (%eax),%eax
 691:	84 c0                	test   %al,%al
 693:	0f 85 94 fe ff ff    	jne    52d <printf+0x22>
    }
  }
}
 699:	90                   	nop
 69a:	c9                   	leave  
 69b:	c3                   	ret    

0000069c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	83 e8 08             	sub    $0x8,%eax
 6a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ab:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 6b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b3:	eb 24                	jmp    6d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6bd:	72 12                	jb     6d1 <free+0x35>
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c5:	77 24                	ja     6eb <free+0x4f>
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6cf:	72 1a                	jb     6eb <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6df:	76 d4                	jbe    6b5 <free+0x19>
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6e9:	73 ca                	jae    6b5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	8b 40 04             	mov    0x4(%eax),%eax
 6f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	01 c2                	add    %eax,%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	39 c2                	cmp    %eax,%edx
 704:	75 24                	jne    72a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	8b 50 04             	mov    0x4(%eax),%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
 728:	eb 0a                	jmp    734 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 40 04             	mov    0x4(%eax),%eax
 73a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 749:	75 20                	jne    76b <free+0xcf>
    p->s.size += bp->s.size;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 50 04             	mov    0x4(%eax),%edx
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	8b 40 04             	mov    0x4(%eax),%eax
 757:	01 c2                	add    %eax,%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	8b 10                	mov    (%eax),%edx
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	89 10                	mov    %edx,(%eax)
 769:	eb 08                	jmp    773 <free+0xd7>
  } else
    p->s.ptr = bp;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 771:	89 10                	mov    %edx,(%eax)
  freep = p;
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	a3 dc 0c 00 00       	mov    %eax,0xcdc
}
 77b:	90                   	nop
 77c:	c9                   	leave  
 77d:	c3                   	ret    

0000077e <morecore>:

static Header*
morecore(uint nu)
{
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 784:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78b:	77 07                	ja     794 <morecore+0x16>
    nu = 4096;
 78d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	c1 e0 03             	shl    $0x3,%eax
 79a:	83 ec 0c             	sub    $0xc,%esp
 79d:	50                   	push   %eax
 79e:	e8 2d fc ff ff       	call   3d0 <sbrk>
 7a3:	83 c4 10             	add    $0x10,%esp
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ad:	75 07                	jne    7b6 <morecore+0x38>
    return 0;
 7af:	b8 00 00 00 00       	mov    $0x0,%eax
 7b4:	eb 26                	jmp    7dc <morecore+0x5e>
  hp = (Header*)p;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	8b 55 08             	mov    0x8(%ebp),%edx
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	83 c0 08             	add    $0x8,%eax
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	50                   	push   %eax
 7cf:	e8 c8 fe ff ff       	call   69c <free>
 7d4:	83 c4 10             	add    $0x10,%esp
  return freep;
 7d7:	a1 dc 0c 00 00       	mov    0xcdc,%eax
}
 7dc:	c9                   	leave  
 7dd:	c3                   	ret    

000007de <malloc>:

void*
malloc(uint nbytes)
{
 7de:	55                   	push   %ebp
 7df:	89 e5                	mov    %esp,%ebp
 7e1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	83 c0 07             	add    $0x7,%eax
 7ea:	c1 e8 03             	shr    $0x3,%eax
 7ed:	83 c0 01             	add    $0x1,%eax
 7f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f3:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 7f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ff:	75 23                	jne    824 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 801:	c7 45 f0 d4 0c 00 00 	movl   $0xcd4,-0x10(%ebp)
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	a3 dc 0c 00 00       	mov    %eax,0xcdc
 810:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 815:	a3 d4 0c 00 00       	mov    %eax,0xcd4
    base.s.size = 0;
 81a:	c7 05 d8 0c 00 00 00 	movl   $0x0,0xcd8
 821:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 835:	77 4d                	ja     884 <malloc+0xa6>
      if(p->s.size == nunits)
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 840:	75 0c                	jne    84e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 10                	mov    (%eax),%edx
 847:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84a:	89 10                	mov    %edx,(%eax)
 84c:	eb 26                	jmp    874 <malloc+0x96>
      else {
        p->s.size -= nunits;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	2b 45 ec             	sub    -0x14(%ebp),%eax
 857:	89 c2                	mov    %eax,%edx
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 40 04             	mov    0x4(%eax),%eax
 865:	c1 e0 03             	shl    $0x3,%eax
 868:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 871:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	a3 dc 0c 00 00       	mov    %eax,0xcdc
      return (void*)(p + 1);
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	83 c0 08             	add    $0x8,%eax
 882:	eb 3b                	jmp    8bf <malloc+0xe1>
    }
    if(p == freep)
 884:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 889:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 88c:	75 1e                	jne    8ac <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 88e:	83 ec 0c             	sub    $0xc,%esp
 891:	ff 75 ec             	push   -0x14(%ebp)
 894:	e8 e5 fe ff ff       	call   77e <morecore>
 899:	83 c4 10             	add    $0x10,%esp
 89c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 89f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a3:	75 07                	jne    8ac <malloc+0xce>
        return 0;
 8a5:	b8 00 00 00 00       	mov    $0x0,%eax
 8aa:	eb 13                	jmp    8bf <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ba:	e9 6d ff ff ff       	jmp    82c <malloc+0x4e>
  }
}
 8bf:	c9                   	leave  
 8c0:	c3                   	ret    
