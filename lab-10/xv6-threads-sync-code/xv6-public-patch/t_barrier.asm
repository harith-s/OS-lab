
_t_barrier:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
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
  int ret1, ret2;

  barrier_init(3);
  11:	83 ec 0c             	sub    $0xc,%esp
  14:	6a 03                	push   $0x3
  16:	e8 2d 04 00 00       	call   448 <barrier_init>
  1b:	83 c4 10             	add    $0x10,%esp
  ret1 = fork();
  1e:	e8 5d 03 00 00       	call   380 <fork>
  23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ret1 == 0)
  26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2a:	75 3b                	jne    67 <main+0x67>
    {
       
      sleep(10);
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	6a 0a                	push   $0xa
  31:	e8 e2 03 00 00       	call   418 <sleep>
  36:	83 c4 10             	add    $0x10,%esp

      printf(1, "Child 1 at barrier\n");
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	68 01 09 00 00       	push   $0x901
  41:	6a 01                	push   $0x1
  43:	e8 03 05 00 00       	call   54b <printf>
  48:	83 c4 10             	add    $0x10,%esp
      barrier_check();
  4b:	e8 00 04 00 00       	call   450 <barrier_check>
      printf(1, "Child 1 cleared barrier\n");
  50:	83 ec 08             	sub    $0x8,%esp
  53:	68 15 09 00 00       	push   $0x915
  58:	6a 01                	push   $0x1
  5a:	e8 ec 04 00 00       	call   54b <printf>
  5f:	83 c4 10             	add    $0x10,%esp

      exit();
  62:	e8 21 03 00 00       	call   388 <exit>
    }
  else
    {
      ret2 = fork();
  67:	e8 14 03 00 00       	call   380 <fork>
  6c:	89 45 f0             	mov    %eax,-0x10(%ebp)

      if(ret2 == 0)
  6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  73:	75 3b                	jne    b0 <main+0xb0>
	{
	  sleep(20);
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	6a 14                	push   $0x14
  7a:	e8 99 03 00 00       	call   418 <sleep>
  7f:	83 c4 10             	add    $0x10,%esp
	  printf(1, "Child 2 at barrier\n");
  82:	83 ec 08             	sub    $0x8,%esp
  85:	68 2e 09 00 00       	push   $0x92e
  8a:	6a 01                	push   $0x1
  8c:	e8 ba 04 00 00       	call   54b <printf>
  91:	83 c4 10             	add    $0x10,%esp
	  barrier_check();
  94:	e8 b7 03 00 00       	call   450 <barrier_check>
	  printf(1, "Child 2 cleared barrier\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 42 09 00 00       	push   $0x942
  a1:	6a 01                	push   $0x1
  a3:	e8 a3 04 00 00       	call   54b <printf>
  a8:	83 c4 10             	add    $0x10,%esp

	  exit();
  ab:	e8 d8 02 00 00       	call   388 <exit>
	}
      else
	{
    sleep(30);
  b0:	83 ec 0c             	sub    $0xc,%esp
  b3:	6a 1e                	push   $0x1e
  b5:	e8 5e 03 00 00       	call   418 <sleep>
  ba:	83 c4 10             	add    $0x10,%esp
	  printf(1, "Parent at barrier\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 5b 09 00 00       	push   $0x95b
  c5:	6a 01                	push   $0x1
  c7:	e8 7f 04 00 00       	call   54b <printf>
  cc:	83 c4 10             	add    $0x10,%esp
	  barrier_check();
  cf:	e8 7c 03 00 00       	call   450 <barrier_check>
	  printf(1, "Parent cleared barrier\n");
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 6e 09 00 00       	push   $0x96e
  dc:	6a 01                	push   $0x1
  de:	e8 68 04 00 00       	call   54b <printf>
  e3:	83 c4 10             	add    $0x10,%esp

	  wait();
  e6:	e8 a5 02 00 00       	call   390 <wait>
	  wait();
  eb:	e8 a0 02 00 00       	call   390 <wait>
	  exit();
  f0:	e8 93 02 00 00       	call   388 <exit>

000000f5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  f8:	57                   	push   %edi
  f9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  fd:	8b 55 10             	mov    0x10(%ebp),%edx
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	89 cb                	mov    %ecx,%ebx
 105:	89 df                	mov    %ebx,%edi
 107:	89 d1                	mov    %edx,%ecx
 109:	fc                   	cld    
 10a:	f3 aa                	rep stos %al,%es:(%edi)
 10c:	89 ca                	mov    %ecx,%edx
 10e:	89 fb                	mov    %edi,%ebx
 110:	89 5d 08             	mov    %ebx,0x8(%ebp)
 113:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 116:	90                   	nop
 117:	5b                   	pop    %ebx
 118:	5f                   	pop    %edi
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 127:	90                   	nop
 128:	8b 55 0c             	mov    0xc(%ebp),%edx
 12b:	8d 42 01             	lea    0x1(%edx),%eax
 12e:	89 45 0c             	mov    %eax,0xc(%ebp)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 48 01             	lea    0x1(%eax),%ecx
 137:	89 4d 08             	mov    %ecx,0x8(%ebp)
 13a:	0f b6 12             	movzbl (%edx),%edx
 13d:	88 10                	mov    %dl,(%eax)
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 e2                	jne    128 <strcpy+0xd>
    ;
  return os;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 14e:	eb 08                	jmp    158 <strcmp+0xd>
    p++, q++;
 150:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 154:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	84 c0                	test   %al,%al
 160:	74 10                	je     172 <strcmp+0x27>
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 10             	movzbl (%eax),%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	38 c2                	cmp    %al,%dl
 170:	74 de                	je     150 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	0f b6 d0             	movzbl %al,%edx
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	0f b6 c0             	movzbl %al,%eax
 184:	29 c2                	sub    %eax,%edx
 186:	89 d0                	mov    %edx,%eax
}
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    

0000018a <strlen>:

uint
strlen(const char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 197:	eb 04                	jmp    19d <strlen+0x13>
 199:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 19d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	01 d0                	add    %edx,%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	84 c0                	test   %al,%al
 1aa:	75 ed                	jne    199 <strlen+0xf>
    ;
  return n;
 1ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b4:	8b 45 10             	mov    0x10(%ebp),%eax
 1b7:	50                   	push   %eax
 1b8:	ff 75 0c             	push   0xc(%ebp)
 1bb:	ff 75 08             	push   0x8(%ebp)
 1be:	e8 32 ff ff ff       	call   f5 <stosb>
 1c3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <strchr>:

char*
strchr(const char *s, char c)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 04             	sub    $0x4,%esp
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d7:	eb 14                	jmp    1ed <strchr+0x22>
    if(*s == c)
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 00             	movzbl (%eax),%eax
 1df:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1e2:	75 05                	jne    1e9 <strchr+0x1e>
      return (char*)s;
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	eb 13                	jmp    1fc <strchr+0x31>
  for(; *s; s++)
 1e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	0f b6 00             	movzbl (%eax),%eax
 1f3:	84 c0                	test   %al,%al
 1f5:	75 e2                	jne    1d9 <strchr+0xe>
  return 0;
 1f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fc:	c9                   	leave  
 1fd:	c3                   	ret    

000001fe <gets>:

char*
gets(char *buf, int max)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20b:	eb 42                	jmp    24f <gets+0x51>
    cc = read(0, &c, 1);
 20d:	83 ec 04             	sub    $0x4,%esp
 210:	6a 01                	push   $0x1
 212:	8d 45 ef             	lea    -0x11(%ebp),%eax
 215:	50                   	push   %eax
 216:	6a 00                	push   $0x0
 218:	e8 83 01 00 00       	call   3a0 <read>
 21d:	83 c4 10             	add    $0x10,%esp
 220:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 223:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 227:	7e 33                	jle    25c <gets+0x5e>
      break;
    buf[i++] = c;
 229:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22c:	8d 50 01             	lea    0x1(%eax),%edx
 22f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 232:	89 c2                	mov    %eax,%edx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	01 c2                	add    %eax,%edx
 239:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 243:	3c 0a                	cmp    $0xa,%al
 245:	74 16                	je     25d <gets+0x5f>
 247:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24b:	3c 0d                	cmp    $0xd,%al
 24d:	74 0e                	je     25d <gets+0x5f>
  for(i=0; i+1 < max; ){
 24f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 252:	83 c0 01             	add    $0x1,%eax
 255:	39 45 0c             	cmp    %eax,0xc(%ebp)
 258:	7f b3                	jg     20d <gets+0xf>
 25a:	eb 01                	jmp    25d <gets+0x5f>
      break;
 25c:	90                   	nop
      break;
  }
  buf[i] = '\0';
 25d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	01 d0                	add    %edx,%eax
 265:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <stat>:

int
stat(const char *n, struct stat *st)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 273:	83 ec 08             	sub    $0x8,%esp
 276:	6a 00                	push   $0x0
 278:	ff 75 08             	push   0x8(%ebp)
 27b:	e8 48 01 00 00       	call   3c8 <open>
 280:	83 c4 10             	add    $0x10,%esp
 283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28a:	79 07                	jns    293 <stat+0x26>
    return -1;
 28c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 291:	eb 25                	jmp    2b8 <stat+0x4b>
  r = fstat(fd, st);
 293:	83 ec 08             	sub    $0x8,%esp
 296:	ff 75 0c             	push   0xc(%ebp)
 299:	ff 75 f4             	push   -0xc(%ebp)
 29c:	e8 3f 01 00 00       	call   3e0 <fstat>
 2a1:	83 c4 10             	add    $0x10,%esp
 2a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	ff 75 f4             	push   -0xc(%ebp)
 2ad:	e8 fe 00 00 00       	call   3b0 <close>
 2b2:	83 c4 10             	add    $0x10,%esp
  return r;
 2b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <atoi>:

int
atoi(const char *s)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c7:	eb 25                	jmp    2ee <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cc:	89 d0                	mov    %edx,%eax
 2ce:	c1 e0 02             	shl    $0x2,%eax
 2d1:	01 d0                	add    %edx,%eax
 2d3:	01 c0                	add    %eax,%eax
 2d5:	89 c1                	mov    %eax,%ecx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8d 50 01             	lea    0x1(%eax),%edx
 2dd:	89 55 08             	mov    %edx,0x8(%ebp)
 2e0:	0f b6 00             	movzbl (%eax),%eax
 2e3:	0f be c0             	movsbl %al,%eax
 2e6:	01 c8                	add    %ecx,%eax
 2e8:	83 e8 30             	sub    $0x30,%eax
 2eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	3c 2f                	cmp    $0x2f,%al
 2f6:	7e 0a                	jle    302 <atoi+0x48>
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	3c 39                	cmp    $0x39,%al
 300:	7e c7                	jle    2c9 <atoi+0xf>
  return n;
 302:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 319:	eb 17                	jmp    332 <memmove+0x2b>
    *dst++ = *src++;
 31b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31e:	8d 42 01             	lea    0x1(%edx),%eax
 321:	89 45 f8             	mov    %eax,-0x8(%ebp)
 324:	8b 45 fc             	mov    -0x4(%ebp),%eax
 327:	8d 48 01             	lea    0x1(%eax),%ecx
 32a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 32d:	0f b6 12             	movzbl (%edx),%edx
 330:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 332:	8b 45 10             	mov    0x10(%ebp),%eax
 335:	8d 50 ff             	lea    -0x1(%eax),%edx
 338:	89 55 10             	mov    %edx,0x10(%ebp)
 33b:	85 c0                	test   %eax,%eax
 33d:	7f dc                	jg     31b <memmove+0x14>
  return vdst;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp

}
 347:	90                   	nop
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    

0000034a <acquireLock>:

void acquireLock(struct lock* l) {
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp

}
 34d:	90                   	nop
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <releaseLock>:

void releaseLock(struct lock* l) {
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp

}
 353:	90                   	nop
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    

00000356 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp

}
 359:	90                   	nop
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp

}
 35f:	90                   	nop
 360:	5d                   	pop    %ebp
 361:	c3                   	ret    

00000362 <broadcast>:

void broadcast(struct condvar* cv) {
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp

}
 365:	90                   	nop
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <signal>:

void signal(struct condvar* cv) {
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp

}
 36b:	90                   	nop
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    

0000036e <semInit>:

void semInit(struct semaphore* s, int initVal) {
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp

}
 371:	90                   	nop
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <semUp>:

void semUp(struct semaphore* s) {
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp

}
 377:	90                   	nop
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <semDown>:

void semDown(struct semaphore* s) {
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp

}
 37d:	90                   	nop
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <thread_create>:
SYSCALL(thread_create)
 428:	b8 16 00 00 00       	mov    $0x16,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <thread_exit>:
SYSCALL(thread_exit)
 430:	b8 17 00 00 00       	mov    $0x17,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <thread_join>:
SYSCALL(thread_join)
 438:	b8 18 00 00 00       	mov    $0x18,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <waitpid>:
SYSCALL(waitpid)
 440:	b8 1e 00 00 00       	mov    $0x1e,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <barrier_init>:
SYSCALL(barrier_init)
 448:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <barrier_check>:
SYSCALL(barrier_check)
 450:	b8 20 00 00 00       	mov    $0x20,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <sleepChan>:
SYSCALL(sleepChan)
 458:	b8 24 00 00 00       	mov    $0x24,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <getChannel>:
SYSCALL(getChannel)
 460:	b8 25 00 00 00       	mov    $0x25,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <sigChan>:
SYSCALL(sigChan)
 468:	b8 26 00 00 00       	mov    $0x26,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <sigOneChan>:
 470:	b8 27 00 00 00       	mov    $0x27,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 18             	sub    $0x18,%esp
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 484:	83 ec 04             	sub    $0x4,%esp
 487:	6a 01                	push   $0x1
 489:	8d 45 f4             	lea    -0xc(%ebp),%eax
 48c:	50                   	push   %eax
 48d:	ff 75 08             	push   0x8(%ebp)
 490:	e8 13 ff ff ff       	call   3a8 <write>
 495:	83 c4 10             	add    $0x10,%esp
}
 498:	90                   	nop
 499:	c9                   	leave  
 49a:	c3                   	ret    

0000049b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49b:	55                   	push   %ebp
 49c:	89 e5                	mov    %esp,%ebp
 49e:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ac:	74 17                	je     4c5 <printint+0x2a>
 4ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b2:	79 11                	jns    4c5 <printint+0x2a>
    neg = 1;
 4b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4be:	f7 d8                	neg    %eax
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c3:	eb 06                	jmp    4cb <printint+0x30>
  } else {
    x = xx;
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d8:	ba 00 00 00 00       	mov    $0x0,%edx
 4dd:	f7 f1                	div    %ecx
 4df:	89 d1                	mov    %edx,%ecx
 4e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e4:	8d 50 01             	lea    0x1(%eax),%edx
 4e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ea:	0f b6 91 14 0d 00 00 	movzbl 0xd14(%ecx),%edx
 4f1:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fb:	ba 00 00 00 00       	mov    $0x0,%edx
 500:	f7 f1                	div    %ecx
 502:	89 45 ec             	mov    %eax,-0x14(%ebp)
 505:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 509:	75 c7                	jne    4d2 <printint+0x37>
  if(neg)
 50b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50f:	74 2d                	je     53e <printint+0xa3>
    buf[i++] = '-';
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	8d 50 01             	lea    0x1(%eax),%edx
 517:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 51f:	eb 1d                	jmp    53e <printint+0xa3>
    putc(fd, buf[i]);
 521:	8d 55 dc             	lea    -0x24(%ebp),%edx
 524:	8b 45 f4             	mov    -0xc(%ebp),%eax
 527:	01 d0                	add    %edx,%eax
 529:	0f b6 00             	movzbl (%eax),%eax
 52c:	0f be c0             	movsbl %al,%eax
 52f:	83 ec 08             	sub    $0x8,%esp
 532:	50                   	push   %eax
 533:	ff 75 08             	push   0x8(%ebp)
 536:	e8 3d ff ff ff       	call   478 <putc>
 53b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 53e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 546:	79 d9                	jns    521 <printint+0x86>
}
 548:	90                   	nop
 549:	c9                   	leave  
 54a:	c3                   	ret    

0000054b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 54b:	55                   	push   %ebp
 54c:	89 e5                	mov    %esp,%ebp
 54e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 551:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 558:	8d 45 0c             	lea    0xc(%ebp),%eax
 55b:	83 c0 04             	add    $0x4,%eax
 55e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 561:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 568:	e9 59 01 00 00       	jmp    6c6 <printf+0x17b>
    c = fmt[i] & 0xff;
 56d:	8b 55 0c             	mov    0xc(%ebp),%edx
 570:	8b 45 f0             	mov    -0x10(%ebp),%eax
 573:	01 d0                	add    %edx,%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	25 ff 00 00 00       	and    $0xff,%eax
 580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 583:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 587:	75 2c                	jne    5b5 <printf+0x6a>
      if(c == '%'){
 589:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58d:	75 0c                	jne    59b <printf+0x50>
        state = '%';
 58f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 596:	e9 27 01 00 00       	jmp    6c2 <printf+0x177>
      } else {
        putc(fd, c);
 59b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	push   0x8(%ebp)
 5a8:	e8 cb fe ff ff       	call   478 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
 5b0:	e9 0d 01 00 00       	jmp    6c2 <printf+0x177>
      }
    } else if(state == '%'){
 5b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b9:	0f 85 03 01 00 00    	jne    6c2 <printf+0x177>
      if(c == 'd'){
 5bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5c3:	75 1e                	jne    5e3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	6a 01                	push   $0x1
 5cc:	6a 0a                	push   $0xa
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	push   0x8(%ebp)
 5d2:	e8 c4 fe ff ff       	call   49b <printint>
 5d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5de:	e9 d8 00 00 00       	jmp    6bb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e7:	74 06                	je     5ef <printf+0xa4>
 5e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ed:	75 1e                	jne    60d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	6a 00                	push   $0x0
 5f6:	6a 10                	push   $0x10
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	push   0x8(%ebp)
 5fc:	e8 9a fe ff ff       	call   49b <printint>
 601:	83 c4 10             	add    $0x10,%esp
        ap++;
 604:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 608:	e9 ae 00 00 00       	jmp    6bb <printf+0x170>
      } else if(c == 's'){
 60d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 611:	75 43                	jne    656 <printf+0x10b>
        s = (char*)*ap;
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 623:	75 25                	jne    64a <printf+0xff>
          s = "(null)";
 625:	c7 45 f4 86 09 00 00 	movl   $0x986,-0xc(%ebp)
        while(*s != 0){
 62c:	eb 1c                	jmp    64a <printf+0xff>
          putc(fd, *s);
 62e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	0f be c0             	movsbl %al,%eax
 637:	83 ec 08             	sub    $0x8,%esp
 63a:	50                   	push   %eax
 63b:	ff 75 08             	push   0x8(%ebp)
 63e:	e8 35 fe ff ff       	call   478 <putc>
 643:	83 c4 10             	add    $0x10,%esp
          s++;
 646:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 64a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64d:	0f b6 00             	movzbl (%eax),%eax
 650:	84 c0                	test   %al,%al
 652:	75 da                	jne    62e <printf+0xe3>
 654:	eb 65                	jmp    6bb <printf+0x170>
        }
      } else if(c == 'c'){
 656:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65a:	75 1d                	jne    679 <printf+0x12e>
        putc(fd, *ap);
 65c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	push   0x8(%ebp)
 66b:	e8 08 fe ff ff       	call   478 <putc>
 670:	83 c4 10             	add    $0x10,%esp
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 677:	eb 42                	jmp    6bb <printf+0x170>
      } else if(c == '%'){
 679:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67d:	75 17                	jne    696 <printf+0x14b>
        putc(fd, c);
 67f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	83 ec 08             	sub    $0x8,%esp
 688:	50                   	push   %eax
 689:	ff 75 08             	push   0x8(%ebp)
 68c:	e8 e7 fd ff ff       	call   478 <putc>
 691:	83 c4 10             	add    $0x10,%esp
 694:	eb 25                	jmp    6bb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 696:	83 ec 08             	sub    $0x8,%esp
 699:	6a 25                	push   $0x25
 69b:	ff 75 08             	push   0x8(%ebp)
 69e:	e8 d5 fd ff ff       	call   478 <putc>
 6a3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	83 ec 08             	sub    $0x8,%esp
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	push   0x8(%ebp)
 6b3:	e8 c0 fd ff ff       	call   478 <putc>
 6b8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6c2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cc:	01 d0                	add    %edx,%eax
 6ce:	0f b6 00             	movzbl (%eax),%eax
 6d1:	84 c0                	test   %al,%al
 6d3:	0f 85 94 fe ff ff    	jne    56d <printf+0x22>
    }
  }
}
 6d9:	90                   	nop
 6da:	c9                   	leave  
 6db:	c3                   	ret    

000006dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	83 e8 08             	sub    $0x8,%eax
 6e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6eb:	a1 30 0d 00 00       	mov    0xd30,%eax
 6f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f3:	eb 24                	jmp    719 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6fd:	72 12                	jb     711 <free+0x35>
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 24                	ja     72b <free+0x4f>
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 70f:	72 1a                	jb     72b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	89 45 fc             	mov    %eax,-0x4(%ebp)
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71f:	76 d4                	jbe    6f5 <free+0x19>
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 729:	73 ca                	jae    6f5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	01 c2                	add    %eax,%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	39 c2                	cmp    %eax,%edx
 744:	75 24                	jne    76a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 50 04             	mov    0x4(%eax),%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	01 c2                	add    %eax,%edx
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
 768:	eb 0a                	jmp    774 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 10                	mov    (%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	01 d0                	add    %edx,%eax
 786:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 789:	75 20                	jne    7ab <free+0xcf>
    p->s.size += bp->s.size;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 50 04             	mov    0x4(%eax),%edx
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	01 c2                	add    %eax,%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 08                	jmp    7b3 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	a3 30 0d 00 00       	mov    %eax,0xd30
}
 7bb:	90                   	nop
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    

000007be <morecore>:

static Header*
morecore(uint nu)
{
 7be:	55                   	push   %ebp
 7bf:	89 e5                	mov    %esp,%ebp
 7c1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cb:	77 07                	ja     7d4 <morecore+0x16>
    nu = 4096;
 7cd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	c1 e0 03             	shl    $0x3,%eax
 7da:	83 ec 0c             	sub    $0xc,%esp
 7dd:	50                   	push   %eax
 7de:	e8 2d fc ff ff       	call   410 <sbrk>
 7e3:	83 c4 10             	add    $0x10,%esp
 7e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ed:	75 07                	jne    7f6 <morecore+0x38>
    return 0;
 7ef:	b8 00 00 00 00       	mov    $0x0,%eax
 7f4:	eb 26                	jmp    81c <morecore+0x5e>
  hp = (Header*)p;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	8b 55 08             	mov    0x8(%ebp),%edx
 802:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	83 c0 08             	add    $0x8,%eax
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	50                   	push   %eax
 80f:	e8 c8 fe ff ff       	call   6dc <free>
 814:	83 c4 10             	add    $0x10,%esp
  return freep;
 817:	a1 30 0d 00 00       	mov    0xd30,%eax
}
 81c:	c9                   	leave  
 81d:	c3                   	ret    

0000081e <malloc>:

void*
malloc(uint nbytes)
{
 81e:	55                   	push   %ebp
 81f:	89 e5                	mov    %esp,%ebp
 821:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	8b 45 08             	mov    0x8(%ebp),%eax
 827:	83 c0 07             	add    $0x7,%eax
 82a:	c1 e8 03             	shr    $0x3,%eax
 82d:	83 c0 01             	add    $0x1,%eax
 830:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 833:	a1 30 0d 00 00       	mov    0xd30,%eax
 838:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83f:	75 23                	jne    864 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 841:	c7 45 f0 28 0d 00 00 	movl   $0xd28,-0x10(%ebp)
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	a3 30 0d 00 00       	mov    %eax,0xd30
 850:	a1 30 0d 00 00       	mov    0xd30,%eax
 855:	a3 28 0d 00 00       	mov    %eax,0xd28
    base.s.size = 0;
 85a:	c7 05 2c 0d 00 00 00 	movl   $0x0,0xd2c
 861:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 40 04             	mov    0x4(%eax),%eax
 872:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 875:	77 4d                	ja     8c4 <malloc+0xa6>
      if(p->s.size == nunits)
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 880:	75 0c                	jne    88e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 10                	mov    (%eax),%edx
 887:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88a:	89 10                	mov    %edx,(%eax)
 88c:	eb 26                	jmp    8b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	8b 40 04             	mov    0x4(%eax),%eax
 894:	2b 45 ec             	sub    -0x14(%ebp),%eax
 897:	89 c2                	mov    %eax,%edx
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	c1 e0 03             	shl    $0x3,%eax
 8a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	a3 30 0d 00 00       	mov    %eax,0xd30
      return (void*)(p + 1);
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	83 c0 08             	add    $0x8,%eax
 8c2:	eb 3b                	jmp    8ff <malloc+0xe1>
    }
    if(p == freep)
 8c4:	a1 30 0d 00 00       	mov    0xd30,%eax
 8c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8cc:	75 1e                	jne    8ec <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ce:	83 ec 0c             	sub    $0xc,%esp
 8d1:	ff 75 ec             	push   -0x14(%ebp)
 8d4:	e8 e5 fe ff ff       	call   7be <morecore>
 8d9:	83 c4 10             	add    $0x10,%esp
 8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e3:	75 07                	jne    8ec <malloc+0xce>
        return 0;
 8e5:	b8 00 00 00 00       	mov    $0x0,%eax
 8ea:	eb 13                	jmp    8ff <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 00                	mov    (%eax),%eax
 8f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8fa:	e9 6d ff ff ff       	jmp    86c <malloc+0x4e>
  }
}
 8ff:	c9                   	leave  
 900:	c3                   	ret    
