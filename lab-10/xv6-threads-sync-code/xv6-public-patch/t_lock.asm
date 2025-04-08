
_t_lock:     file format elf32-i386


Disassembly of section .text:

00000000 <count>:
#include "user.h"

struct lock l;
void* count(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    for(int i=0; i<1000000; i++)
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 31                	jmp    40 <count+0x40>
	{	
		acquireLock(&l);
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	68 d4 0c 00 00       	push   $0xcd4
  17:	e8 1f 03 00 00       	call   33b <acquireLock>
  1c:	83 c4 10             	add    $0x10,%esp
		*(int*)arg = *(int*)arg + 1;
  1f:	8b 45 08             	mov    0x8(%ebp),%eax
  22:	8b 00                	mov    (%eax),%eax
  24:	8d 50 01             	lea    0x1(%eax),%edx
  27:	8b 45 08             	mov    0x8(%ebp),%eax
  2a:	89 10                	mov    %edx,(%eax)
		releaseLock(&l);
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	68 d4 0c 00 00       	push   $0xcd4
  34:	e8 08 03 00 00       	call   341 <releaseLock>
  39:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i<1000000; i++)
  3c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  40:	81 7d f4 3f 42 0f 00 	cmpl   $0xf423f,-0xc(%ebp)
  47:	7e c6                	jle    f <count+0xf>
	}
    thread_exit();
  49:	e8 d3 03 00 00       	call   421 <thread_exit>
    return 0;
  4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  53:	c9                   	leave  
  54:	c3                   	ret    

00000055 <main>:

int main()
{
  55:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  59:	83 e4 f0             	and    $0xfffffff0,%esp
  5c:	ff 71 fc             	push   -0x4(%ecx)
  5f:	55                   	push   %ebp
  60:	89 e5                	mov    %esp,%ebp
  62:	51                   	push   %ecx
  63:	83 ec 14             	sub    $0x14,%esp
	int x;
    initiateLock(&l);
  66:	83 ec 0c             	sub    $0xc,%esp
  69:	68 d4 0c 00 00       	push   $0xcd4
  6e:	e8 c2 02 00 00       	call   335 <initiateLock>
  73:	83 c4 10             	add    $0x10,%esp
	// two threads increment the same counter 10000 times each
	uint tid1, tid2;

	x = 0;
  76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    thread_create(&tid1, count, (void*)&x);
  7d:	83 ec 04             	sub    $0x4,%esp
  80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  83:	50                   	push   %eax
  84:	68 00 00 00 00       	push   $0x0
  89:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8c:	50                   	push   %eax
  8d:	e8 87 03 00 00       	call   419 <thread_create>
  92:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid2, count, (void*)&x);
  95:	83 ec 04             	sub    $0x4,%esp
  98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  9b:	50                   	push   %eax
  9c:	68 00 00 00 00       	push   $0x0
  a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  a4:	50                   	push   %eax
  a5:	e8 6f 03 00 00       	call   419 <thread_create>
  aa:	83 c4 10             	add    $0x10,%esp
    thread_join(tid1);
  ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b0:	83 ec 0c             	sub    $0xc,%esp
  b3:	50                   	push   %eax
  b4:	e8 70 03 00 00       	call   429 <thread_join>
  b9:	83 c4 10             	add    $0x10,%esp
    thread_join(tid2);
  bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  bf:	83 ec 0c             	sub    $0xc,%esp
  c2:	50                   	push   %eax
  c3:	e8 61 03 00 00       	call   429 <thread_join>
  c8:	83 c4 10             	add    $0x10,%esp

    printf(1, "Final value of x: %d\n", x);
  cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ce:	83 ec 04             	sub    $0x4,%esp
  d1:	50                   	push   %eax
  d2:	68 f2 08 00 00       	push   $0x8f2
  d7:	6a 01                	push   $0x1
  d9:	e8 5e 04 00 00       	call   53c <printf>
  de:	83 c4 10             	add    $0x10,%esp
    exit();
  e1:	e8 93 02 00 00       	call   379 <exit>

000000e6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	57                   	push   %edi
  ea:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ee:	8b 55 10             	mov    0x10(%ebp),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	89 cb                	mov    %ecx,%ebx
  f6:	89 df                	mov    %ebx,%edi
  f8:	89 d1                	mov    %edx,%ecx
  fa:	fc                   	cld    
  fb:	f3 aa                	rep stos %al,%es:(%edi)
  fd:	89 ca                	mov    %ecx,%edx
  ff:	89 fb                	mov    %edi,%ebx
 101:	89 5d 08             	mov    %ebx,0x8(%ebp)
 104:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 107:	90                   	nop
 108:	5b                   	pop    %ebx
 109:	5f                   	pop    %edi
 10a:	5d                   	pop    %ebp
 10b:	c3                   	ret    

0000010c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 118:	90                   	nop
 119:	8b 55 0c             	mov    0xc(%ebp),%edx
 11c:	8d 42 01             	lea    0x1(%edx),%eax
 11f:	89 45 0c             	mov    %eax,0xc(%ebp)
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	8d 48 01             	lea    0x1(%eax),%ecx
 128:	89 4d 08             	mov    %ecx,0x8(%ebp)
 12b:	0f b6 12             	movzbl (%edx),%edx
 12e:	88 10                	mov    %dl,(%eax)
 130:	0f b6 00             	movzbl (%eax),%eax
 133:	84 c0                	test   %al,%al
 135:	75 e2                	jne    119 <strcpy+0xd>
    ;
  return os;
 137:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 13f:	eb 08                	jmp    149 <strcmp+0xd>
    p++, q++;
 141:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 145:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	84 c0                	test   %al,%al
 151:	74 10                	je     163 <strcmp+0x27>
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 10             	movzbl (%eax),%edx
 159:	8b 45 0c             	mov    0xc(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	38 c2                	cmp    %al,%dl
 161:	74 de                	je     141 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	0f b6 d0             	movzbl %al,%edx
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	0f b6 c0             	movzbl %al,%eax
 175:	29 c2                	sub    %eax,%edx
 177:	89 d0                	mov    %edx,%eax
}
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    

0000017b <strlen>:

uint
strlen(const char *s)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 181:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 188:	eb 04                	jmp    18e <strlen+0x13>
 18a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 18e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	01 d0                	add    %edx,%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	84 c0                	test   %al,%al
 19b:	75 ed                	jne    18a <strlen+0xf>
    ;
  return n;
 19d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a0:	c9                   	leave  
 1a1:	c3                   	ret    

000001a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1a5:	8b 45 10             	mov    0x10(%ebp),%eax
 1a8:	50                   	push   %eax
 1a9:	ff 75 0c             	push   0xc(%ebp)
 1ac:	ff 75 08             	push   0x8(%ebp)
 1af:	e8 32 ff ff ff       	call   e6 <stosb>
 1b4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ba:	c9                   	leave  
 1bb:	c3                   	ret    

000001bc <strchr>:

char*
strchr(const char *s, char c)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	83 ec 04             	sub    $0x4,%esp
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c8:	eb 14                	jmp    1de <strchr+0x22>
    if(*s == c)
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1d3:	75 05                	jne    1da <strchr+0x1e>
      return (char*)s;
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	eb 13                	jmp    1ed <strchr+0x31>
  for(; *s; s++)
 1da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	0f b6 00             	movzbl (%eax),%eax
 1e4:	84 c0                	test   %al,%al
 1e6:	75 e2                	jne    1ca <strchr+0xe>
  return 0;
 1e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <gets>:

char*
gets(char *buf, int max)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fc:	eb 42                	jmp    240 <gets+0x51>
    cc = read(0, &c, 1);
 1fe:	83 ec 04             	sub    $0x4,%esp
 201:	6a 01                	push   $0x1
 203:	8d 45 ef             	lea    -0x11(%ebp),%eax
 206:	50                   	push   %eax
 207:	6a 00                	push   $0x0
 209:	e8 83 01 00 00       	call   391 <read>
 20e:	83 c4 10             	add    $0x10,%esp
 211:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 214:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 218:	7e 33                	jle    24d <gets+0x5e>
      break;
    buf[i++] = c;
 21a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21d:	8d 50 01             	lea    0x1(%eax),%edx
 220:	89 55 f4             	mov    %edx,-0xc(%ebp)
 223:	89 c2                	mov    %eax,%edx
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	01 c2                	add    %eax,%edx
 22a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 230:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 234:	3c 0a                	cmp    $0xa,%al
 236:	74 16                	je     24e <gets+0x5f>
 238:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23c:	3c 0d                	cmp    $0xd,%al
 23e:	74 0e                	je     24e <gets+0x5f>
  for(i=0; i+1 < max; ){
 240:	8b 45 f4             	mov    -0xc(%ebp),%eax
 243:	83 c0 01             	add    $0x1,%eax
 246:	39 45 0c             	cmp    %eax,0xc(%ebp)
 249:	7f b3                	jg     1fe <gets+0xf>
 24b:	eb 01                	jmp    24e <gets+0x5f>
      break;
 24d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 24e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	01 d0                	add    %edx,%eax
 256:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 259:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25c:	c9                   	leave  
 25d:	c3                   	ret    

0000025e <stat>:

int
stat(const char *n, struct stat *st)
{
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 264:	83 ec 08             	sub    $0x8,%esp
 267:	6a 00                	push   $0x0
 269:	ff 75 08             	push   0x8(%ebp)
 26c:	e8 48 01 00 00       	call   3b9 <open>
 271:	83 c4 10             	add    $0x10,%esp
 274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27b:	79 07                	jns    284 <stat+0x26>
    return -1;
 27d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 282:	eb 25                	jmp    2a9 <stat+0x4b>
  r = fstat(fd, st);
 284:	83 ec 08             	sub    $0x8,%esp
 287:	ff 75 0c             	push   0xc(%ebp)
 28a:	ff 75 f4             	push   -0xc(%ebp)
 28d:	e8 3f 01 00 00       	call   3d1 <fstat>
 292:	83 c4 10             	add    $0x10,%esp
 295:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 298:	83 ec 0c             	sub    $0xc,%esp
 29b:	ff 75 f4             	push   -0xc(%ebp)
 29e:	e8 fe 00 00 00       	call   3a1 <close>
 2a3:	83 c4 10             	add    $0x10,%esp
  return r;
 2a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <atoi>:

int
atoi(const char *s)
{
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b8:	eb 25                	jmp    2df <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2bd:	89 d0                	mov    %edx,%eax
 2bf:	c1 e0 02             	shl    $0x2,%eax
 2c2:	01 d0                	add    %edx,%eax
 2c4:	01 c0                	add    %eax,%eax
 2c6:	89 c1                	mov    %eax,%ecx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	8d 50 01             	lea    0x1(%eax),%edx
 2ce:	89 55 08             	mov    %edx,0x8(%ebp)
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	0f be c0             	movsbl %al,%eax
 2d7:	01 c8                	add    %ecx,%eax
 2d9:	83 e8 30             	sub    $0x30,%eax
 2dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	3c 2f                	cmp    $0x2f,%al
 2e7:	7e 0a                	jle    2f3 <atoi+0x48>
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 39                	cmp    $0x39,%al
 2f1:	7e c7                	jle    2ba <atoi+0xf>
  return n;
 2f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 304:	8b 45 0c             	mov    0xc(%ebp),%eax
 307:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 30a:	eb 17                	jmp    323 <memmove+0x2b>
    *dst++ = *src++;
 30c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30f:	8d 42 01             	lea    0x1(%edx),%eax
 312:	89 45 f8             	mov    %eax,-0x8(%ebp)
 315:	8b 45 fc             	mov    -0x4(%ebp),%eax
 318:	8d 48 01             	lea    0x1(%eax),%ecx
 31b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 31e:	0f b6 12             	movzbl (%edx),%edx
 321:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 323:	8b 45 10             	mov    0x10(%ebp),%eax
 326:	8d 50 ff             	lea    -0x1(%eax),%edx
 329:	89 55 10             	mov    %edx,0x10(%ebp)
 32c:	85 c0                	test   %eax,%eax
 32e:	7f dc                	jg     30c <memmove+0x14>
  return vdst;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp

}
 338:	90                   	nop
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    

0000033b <acquireLock>:

void acquireLock(struct lock* l) {
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp

}
 33e:	90                   	nop
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    

00000341 <releaseLock>:

void releaseLock(struct lock* l) {
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp

}
 344:	90                   	nop
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    

00000347 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp

}
 34a:	90                   	nop
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    

0000034d <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp

}
 350:	90                   	nop
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    

00000353 <broadcast>:

void broadcast(struct condvar* cv) {
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp

}
 356:	90                   	nop
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    

00000359 <signal>:

void signal(struct condvar* cv) {
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp

}
 35c:	90                   	nop
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    

0000035f <semInit>:

void semInit(struct semaphore* s, int initVal) {
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp

}
 362:	90                   	nop
 363:	5d                   	pop    %ebp
 364:	c3                   	ret    

00000365 <semUp>:

void semUp(struct semaphore* s) {
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp

}
 368:	90                   	nop
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <semDown>:

void semDown(struct semaphore* s) {
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp

}
 36e:	90                   	nop
 36f:	5d                   	pop    %ebp
 370:	c3                   	ret    

00000371 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 371:	b8 01 00 00 00       	mov    $0x1,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <exit>:
SYSCALL(exit)
 379:	b8 02 00 00 00       	mov    $0x2,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <wait>:
SYSCALL(wait)
 381:	b8 03 00 00 00       	mov    $0x3,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <pipe>:
SYSCALL(pipe)
 389:	b8 04 00 00 00       	mov    $0x4,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <read>:
SYSCALL(read)
 391:	b8 05 00 00 00       	mov    $0x5,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <write>:
SYSCALL(write)
 399:	b8 10 00 00 00       	mov    $0x10,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <close>:
SYSCALL(close)
 3a1:	b8 15 00 00 00       	mov    $0x15,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <kill>:
SYSCALL(kill)
 3a9:	b8 06 00 00 00       	mov    $0x6,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <exec>:
SYSCALL(exec)
 3b1:	b8 07 00 00 00       	mov    $0x7,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <open>:
SYSCALL(open)
 3b9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <mknod>:
SYSCALL(mknod)
 3c1:	b8 11 00 00 00       	mov    $0x11,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <unlink>:
SYSCALL(unlink)
 3c9:	b8 12 00 00 00       	mov    $0x12,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <fstat>:
SYSCALL(fstat)
 3d1:	b8 08 00 00 00       	mov    $0x8,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <link>:
SYSCALL(link)
 3d9:	b8 13 00 00 00       	mov    $0x13,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <mkdir>:
SYSCALL(mkdir)
 3e1:	b8 14 00 00 00       	mov    $0x14,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <chdir>:
SYSCALL(chdir)
 3e9:	b8 09 00 00 00       	mov    $0x9,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <dup>:
SYSCALL(dup)
 3f1:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <getpid>:
SYSCALL(getpid)
 3f9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <sbrk>:
SYSCALL(sbrk)
 401:	b8 0c 00 00 00       	mov    $0xc,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <sleep>:
SYSCALL(sleep)
 409:	b8 0d 00 00 00       	mov    $0xd,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <uptime>:
SYSCALL(uptime)
 411:	b8 0e 00 00 00       	mov    $0xe,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <thread_create>:
SYSCALL(thread_create)
 419:	b8 16 00 00 00       	mov    $0x16,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <thread_exit>:
SYSCALL(thread_exit)
 421:	b8 17 00 00 00       	mov    $0x17,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <thread_join>:
SYSCALL(thread_join)
 429:	b8 18 00 00 00       	mov    $0x18,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <waitpid>:
SYSCALL(waitpid)
 431:	b8 1e 00 00 00       	mov    $0x1e,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <barrier_init>:
SYSCALL(barrier_init)
 439:	b8 1f 00 00 00       	mov    $0x1f,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <barrier_check>:
SYSCALL(barrier_check)
 441:	b8 20 00 00 00       	mov    $0x20,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <sleepChan>:
SYSCALL(sleepChan)
 449:	b8 24 00 00 00       	mov    $0x24,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <getChannel>:
SYSCALL(getChannel)
 451:	b8 25 00 00 00       	mov    $0x25,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <sigChan>:
SYSCALL(sigChan)
 459:	b8 26 00 00 00       	mov    $0x26,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <sigOneChan>:
 461:	b8 27 00 00 00       	mov    $0x27,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 18             	sub    $0x18,%esp
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 475:	83 ec 04             	sub    $0x4,%esp
 478:	6a 01                	push   $0x1
 47a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47d:	50                   	push   %eax
 47e:	ff 75 08             	push   0x8(%ebp)
 481:	e8 13 ff ff ff       	call   399 <write>
 486:	83 c4 10             	add    $0x10,%esp
}
 489:	90                   	nop
 48a:	c9                   	leave  
 48b:	c3                   	ret    

0000048c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 492:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 499:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49d:	74 17                	je     4b6 <printint+0x2a>
 49f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a3:	79 11                	jns    4b6 <printint+0x2a>
    neg = 1;
 4a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 4af:	f7 d8                	neg    %eax
 4b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b4:	eb 06                	jmp    4bc <printint+0x30>
  } else {
    x = xx;
 4b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ce:	f7 f1                	div    %ecx
 4d0:	89 d1                	mov    %edx,%ecx
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	8d 50 01             	lea    0x1(%eax),%edx
 4d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4db:	0f b6 91 b4 0c 00 00 	movzbl 0xcb4(%ecx),%edx
 4e2:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ec:	ba 00 00 00 00       	mov    $0x0,%edx
 4f1:	f7 f1                	div    %ecx
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fa:	75 c7                	jne    4c3 <printint+0x37>
  if(neg)
 4fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 500:	74 2d                	je     52f <printint+0xa3>
    buf[i++] = '-';
 502:	8b 45 f4             	mov    -0xc(%ebp),%eax
 505:	8d 50 01             	lea    0x1(%eax),%edx
 508:	89 55 f4             	mov    %edx,-0xc(%ebp)
 50b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 510:	eb 1d                	jmp    52f <printint+0xa3>
    putc(fd, buf[i]);
 512:	8d 55 dc             	lea    -0x24(%ebp),%edx
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	01 d0                	add    %edx,%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	0f be c0             	movsbl %al,%eax
 520:	83 ec 08             	sub    $0x8,%esp
 523:	50                   	push   %eax
 524:	ff 75 08             	push   0x8(%ebp)
 527:	e8 3d ff ff ff       	call   469 <putc>
 52c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 52f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	79 d9                	jns    512 <printint+0x86>
}
 539:	90                   	nop
 53a:	c9                   	leave  
 53b:	c3                   	ret    

0000053c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 542:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 549:	8d 45 0c             	lea    0xc(%ebp),%eax
 54c:	83 c0 04             	add    $0x4,%eax
 54f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 559:	e9 59 01 00 00       	jmp    6b7 <printf+0x17b>
    c = fmt[i] & 0xff;
 55e:	8b 55 0c             	mov    0xc(%ebp),%edx
 561:	8b 45 f0             	mov    -0x10(%ebp),%eax
 564:	01 d0                	add    %edx,%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	25 ff 00 00 00       	and    $0xff,%eax
 571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 2c                	jne    5a6 <printf+0x6a>
      if(c == '%'){
 57a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57e:	75 0c                	jne    58c <printf+0x50>
        state = '%';
 580:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 587:	e9 27 01 00 00       	jmp    6b3 <printf+0x177>
      } else {
        putc(fd, c);
 58c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	push   0x8(%ebp)
 599:	e8 cb fe ff ff       	call   469 <putc>
 59e:	83 c4 10             	add    $0x10,%esp
 5a1:	e9 0d 01 00 00       	jmp    6b3 <printf+0x177>
      }
    } else if(state == '%'){
 5a6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5aa:	0f 85 03 01 00 00    	jne    6b3 <printf+0x177>
      if(c == 'd'){
 5b0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b4:	75 1e                	jne    5d4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	6a 01                	push   $0x1
 5bd:	6a 0a                	push   $0xa
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	push   0x8(%ebp)
 5c3:	e8 c4 fe ff ff       	call   48c <printint>
 5c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cf:	e9 d8 00 00 00       	jmp    6ac <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d8:	74 06                	je     5e0 <printf+0xa4>
 5da:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5de:	75 1e                	jne    5fe <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e3:	8b 00                	mov    (%eax),%eax
 5e5:	6a 00                	push   $0x0
 5e7:	6a 10                	push   $0x10
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	push   0x8(%ebp)
 5ed:	e8 9a fe ff ff       	call   48c <printint>
 5f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f9:	e9 ae 00 00 00       	jmp    6ac <printf+0x170>
      } else if(c == 's'){
 5fe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 602:	75 43                	jne    647 <printf+0x10b>
        s = (char*)*ap;
 604:	8b 45 e8             	mov    -0x18(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 614:	75 25                	jne    63b <printf+0xff>
          s = "(null)";
 616:	c7 45 f4 08 09 00 00 	movl   $0x908,-0xc(%ebp)
        while(*s != 0){
 61d:	eb 1c                	jmp    63b <printf+0xff>
          putc(fd, *s);
 61f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 622:	0f b6 00             	movzbl (%eax),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	83 ec 08             	sub    $0x8,%esp
 62b:	50                   	push   %eax
 62c:	ff 75 08             	push   0x8(%ebp)
 62f:	e8 35 fe ff ff       	call   469 <putc>
 634:	83 c4 10             	add    $0x10,%esp
          s++;
 637:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 63b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	84 c0                	test   %al,%al
 643:	75 da                	jne    61f <printf+0xe3>
 645:	eb 65                	jmp    6ac <printf+0x170>
        }
      } else if(c == 'c'){
 647:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64b:	75 1d                	jne    66a <printf+0x12e>
        putc(fd, *ap);
 64d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	0f be c0             	movsbl %al,%eax
 655:	83 ec 08             	sub    $0x8,%esp
 658:	50                   	push   %eax
 659:	ff 75 08             	push   0x8(%ebp)
 65c:	e8 08 fe ff ff       	call   469 <putc>
 661:	83 c4 10             	add    $0x10,%esp
        ap++;
 664:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 668:	eb 42                	jmp    6ac <printf+0x170>
      } else if(c == '%'){
 66a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66e:	75 17                	jne    687 <printf+0x14b>
        putc(fd, c);
 670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 673:	0f be c0             	movsbl %al,%eax
 676:	83 ec 08             	sub    $0x8,%esp
 679:	50                   	push   %eax
 67a:	ff 75 08             	push   0x8(%ebp)
 67d:	e8 e7 fd ff ff       	call   469 <putc>
 682:	83 c4 10             	add    $0x10,%esp
 685:	eb 25                	jmp    6ac <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 687:	83 ec 08             	sub    $0x8,%esp
 68a:	6a 25                	push   $0x25
 68c:	ff 75 08             	push   0x8(%ebp)
 68f:	e8 d5 fd ff ff       	call   469 <putc>
 694:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 ec 08             	sub    $0x8,%esp
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	push   0x8(%ebp)
 6a4:	e8 c0 fd ff ff       	call   469 <putc>
 6a9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	84 c0                	test   %al,%al
 6c4:	0f 85 94 fe ff ff    	jne    55e <printf+0x22>
    }
  }
}
 6ca:	90                   	nop
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	83 e8 08             	sub    $0x8,%eax
 6d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	a1 d0 0c 00 00       	mov    0xcd0,%eax
 6e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e4:	eb 24                	jmp    70a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6ee:	72 12                	jb     702 <free+0x35>
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f6:	77 24                	ja     71c <free+0x4f>
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 700:	72 1a                	jb     71c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 710:	76 d4                	jbe    6e6 <free+0x19>
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 71a:	73 ca                	jae    6e6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	39 c2                	cmp    %eax,%edx
 735:	75 24                	jne    75b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 50 04             	mov    0x4(%eax),%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	8b 40 04             	mov    0x4(%eax),%eax
 745:	01 c2                	add    %eax,%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	8b 10                	mov    (%eax),%edx
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	89 10                	mov    %edx,(%eax)
 759:	eb 0a                	jmp    765 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 10                	mov    (%eax),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	01 d0                	add    %edx,%eax
 777:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 77a:	75 20                	jne    79c <free+0xcf>
    p->s.size += bp->s.size;
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 50 04             	mov    0x4(%eax),%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	8b 40 04             	mov    0x4(%eax),%eax
 788:	01 c2                	add    %eax,%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	8b 10                	mov    (%eax),%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	89 10                	mov    %edx,(%eax)
 79a:	eb 08                	jmp    7a4 <free+0xd7>
  } else
    p->s.ptr = bp;
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a2:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	a3 d0 0c 00 00       	mov    %eax,0xcd0
}
 7ac:	90                   	nop
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <morecore>:

static Header*
morecore(uint nu)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bc:	77 07                	ja     7c5 <morecore+0x16>
    nu = 4096;
 7be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	c1 e0 03             	shl    $0x3,%eax
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	50                   	push   %eax
 7cf:	e8 2d fc ff ff       	call   401 <sbrk>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7de:	75 07                	jne    7e7 <morecore+0x38>
    return 0;
 7e0:	b8 00 00 00 00       	mov    $0x0,%eax
 7e5:	eb 26                	jmp    80d <morecore+0x5e>
  hp = (Header*)p;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 55 08             	mov    0x8(%ebp),%edx
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	83 c0 08             	add    $0x8,%eax
 7fc:	83 ec 0c             	sub    $0xc,%esp
 7ff:	50                   	push   %eax
 800:	e8 c8 fe ff ff       	call   6cd <free>
 805:	83 c4 10             	add    $0x10,%esp
  return freep;
 808:	a1 d0 0c 00 00       	mov    0xcd0,%eax
}
 80d:	c9                   	leave  
 80e:	c3                   	ret    

0000080f <malloc>:

void*
malloc(uint nbytes)
{
 80f:	55                   	push   %ebp
 810:	89 e5                	mov    %esp,%ebp
 812:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	83 c0 07             	add    $0x7,%eax
 81b:	c1 e8 03             	shr    $0x3,%eax
 81e:	83 c0 01             	add    $0x1,%eax
 821:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 824:	a1 d0 0c 00 00       	mov    0xcd0,%eax
 829:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 830:	75 23                	jne    855 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 832:	c7 45 f0 c8 0c 00 00 	movl   $0xcc8,-0x10(%ebp)
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	a3 d0 0c 00 00       	mov    %eax,0xcd0
 841:	a1 d0 0c 00 00       	mov    0xcd0,%eax
 846:	a3 c8 0c 00 00       	mov    %eax,0xcc8
    base.s.size = 0;
 84b:	c7 05 cc 0c 00 00 00 	movl   $0x0,0xccc
 852:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 866:	77 4d                	ja     8b5 <malloc+0xa6>
      if(p->s.size == nunits)
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 871:	75 0c                	jne    87f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	89 10                	mov    %edx,(%eax)
 87d:	eb 26                	jmp    8a5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	2b 45 ec             	sub    -0x14(%ebp),%eax
 888:	89 c2                	mov    %eax,%edx
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	c1 e0 03             	shl    $0x3,%eax
 899:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	a3 d0 0c 00 00       	mov    %eax,0xcd0
      return (void*)(p + 1);
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	83 c0 08             	add    $0x8,%eax
 8b3:	eb 3b                	jmp    8f0 <malloc+0xe1>
    }
    if(p == freep)
 8b5:	a1 d0 0c 00 00       	mov    0xcd0,%eax
 8ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bd:	75 1e                	jne    8dd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8bf:	83 ec 0c             	sub    $0xc,%esp
 8c2:	ff 75 ec             	push   -0x14(%ebp)
 8c5:	e8 e5 fe ff ff       	call   7af <morecore>
 8ca:	83 c4 10             	add    $0x10,%esp
 8cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d4:	75 07                	jne    8dd <malloc+0xce>
        return 0;
 8d6:	b8 00 00 00 00       	mov    $0x0,%eax
 8db:	eb 13                	jmp    8f0 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 00                	mov    (%eax),%eax
 8e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8eb:	e9 6d ff ff ff       	jmp    85d <malloc+0x4e>
  }
}
 8f0:	c9                   	leave  
 8f1:	c3                   	ret    
