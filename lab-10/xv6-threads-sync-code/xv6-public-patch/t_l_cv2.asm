
_t_l_cv2:     file format elf32-i386


Disassembly of section .text:

00000000 <toggle1>:
#include "user.h"

struct lock l;
struct condvar cv;

void* toggle1(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    acquireLock(&l);
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	68 c8 0d 00 00       	push   $0xdc8
   e:	e8 ea 03 00 00       	call   3fd <acquireLock>
  13:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i < 10; i++) {
  16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1d:	eb 4e                	jmp    6d <toggle1+0x6d>
        while(*(int*)arg == 1){
            condWait(&cv, &l);
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 c8 0d 00 00       	push   $0xdc8
  27:	68 c0 0d 00 00       	push   $0xdc0
  2c:	e8 de 03 00 00       	call   40f <condWait>
  31:	83 c4 10             	add    $0x10,%esp
        while(*(int*)arg == 1){
  34:	8b 45 08             	mov    0x8(%ebp),%eax
  37:	8b 00                	mov    (%eax),%eax
  39:	83 f8 01             	cmp    $0x1,%eax
  3c:	74 e1                	je     1f <toggle1+0x1f>
        }
        printf(1, "I am thread 1\n");
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	68 b4 09 00 00       	push   $0x9b4
  46:	6a 01                	push   $0x1
  48:	e8 b1 05 00 00       	call   5fe <printf>
  4d:	83 c4 10             	add    $0x10,%esp
        *(int*)arg = 1;
  50:	8b 45 08             	mov    0x8(%ebp),%eax
  53:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        broadcast(&cv);
  59:	83 ec 0c             	sub    $0xc,%esp
  5c:	68 c0 0d 00 00       	push   $0xdc0
  61:	e8 af 03 00 00       	call   415 <broadcast>
  66:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i < 10; i++) {
  69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  71:	7e c1                	jle    34 <toggle1+0x34>
    }
    releaseLock(&l);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	68 c8 0d 00 00       	push   $0xdc8
  7b:	e8 83 03 00 00       	call   403 <releaseLock>
  80:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  83:	e8 5b 04 00 00       	call   4e3 <thread_exit>
    return 0;
  88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8d:	c9                   	leave  
  8e:	c3                   	ret    

0000008f <toggle2>:

void* toggle2(void* arg){
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	83 ec 18             	sub    $0x18,%esp
    acquireLock(&l);
  95:	83 ec 0c             	sub    $0xc,%esp
  98:	68 c8 0d 00 00       	push   $0xdc8
  9d:	e8 5b 03 00 00       	call   3fd <acquireLock>
  a2:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i < 10; i++) {
  a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ac:	eb 4d                	jmp    fb <toggle2+0x6c>
        while(*(int*)arg == 0){
            condWait(&cv, &l);
  ae:	83 ec 08             	sub    $0x8,%esp
  b1:	68 c8 0d 00 00       	push   $0xdc8
  b6:	68 c0 0d 00 00       	push   $0xdc0
  bb:	e8 4f 03 00 00       	call   40f <condWait>
  c0:	83 c4 10             	add    $0x10,%esp
        while(*(int*)arg == 0){
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8b 00                	mov    (%eax),%eax
  c8:	85 c0                	test   %eax,%eax
  ca:	74 e2                	je     ae <toggle2+0x1f>
        }
        printf(1, "I am thread 2\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 c3 09 00 00       	push   $0x9c3
  d4:	6a 01                	push   $0x1
  d6:	e8 23 05 00 00       	call   5fe <printf>
  db:	83 c4 10             	add    $0x10,%esp
        *(int*)arg = 0;
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        broadcast(&cv);
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	68 c0 0d 00 00       	push   $0xdc0
  ef:	e8 21 03 00 00       	call   415 <broadcast>
  f4:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i < 10; i++) {
  f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  fb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  ff:	7e c2                	jle    c3 <toggle2+0x34>
    }
    releaseLock(&l);
 101:	83 ec 0c             	sub    $0xc,%esp
 104:	68 c8 0d 00 00       	push   $0xdc8
 109:	e8 f5 02 00 00       	call   403 <releaseLock>
 10e:	83 c4 10             	add    $0x10,%esp
    thread_exit();
 111:	e8 cd 03 00 00       	call   4e3 <thread_exit>
    return 0;
 116:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <main>:

int main()
{
 11d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 121:	83 e4 f0             	and    $0xfffffff0,%esp
 124:	ff 71 fc             	push   -0x4(%ecx)
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	51                   	push   %ecx
 12b:	83 ec 14             	sub    $0x14,%esp
	initiateLock(&l);
 12e:	83 ec 0c             	sub    $0xc,%esp
 131:	68 c8 0d 00 00       	push   $0xdc8
 136:	e8 bc 02 00 00       	call   3f7 <initiateLock>
 13b:	83 c4 10             	add    $0x10,%esp
    initiateCondVar(&cv);
 13e:	83 ec 0c             	sub    $0xc,%esp
 141:	68 c0 0d 00 00       	push   $0xdc0
 146:	e8 be 02 00 00       	call   409 <initiateCondVar>
 14b:	83 c4 10             	add    $0x10,%esp
    int x = 0;
 14e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    uint tid1, tid2;
    thread_create(&tid1, toggle1, (void*)&x);
 155:	83 ec 04             	sub    $0x4,%esp
 158:	8d 45 f4             	lea    -0xc(%ebp),%eax
 15b:	50                   	push   %eax
 15c:	68 00 00 00 00       	push   $0x0
 161:	8d 45 f0             	lea    -0x10(%ebp),%eax
 164:	50                   	push   %eax
 165:	e8 71 03 00 00       	call   4db <thread_create>
 16a:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid2, toggle2, (void*)&x);
 16d:	83 ec 04             	sub    $0x4,%esp
 170:	8d 45 f4             	lea    -0xc(%ebp),%eax
 173:	50                   	push   %eax
 174:	68 8f 00 00 00       	push   $0x8f
 179:	8d 45 ec             	lea    -0x14(%ebp),%eax
 17c:	50                   	push   %eax
 17d:	e8 59 03 00 00       	call   4db <thread_create>
 182:	83 c4 10             	add    $0x10,%esp
    thread_join(tid1);
 185:	8b 45 f0             	mov    -0x10(%ebp),%eax
 188:	83 ec 0c             	sub    $0xc,%esp
 18b:	50                   	push   %eax
 18c:	e8 5a 03 00 00       	call   4eb <thread_join>
 191:	83 c4 10             	add    $0x10,%esp
    thread_join(tid2);
 194:	8b 45 ec             	mov    -0x14(%ebp),%eax
 197:	83 ec 0c             	sub    $0xc,%esp
 19a:	50                   	push   %eax
 19b:	e8 4b 03 00 00       	call   4eb <thread_join>
 1a0:	83 c4 10             	add    $0x10,%esp

    exit();
 1a3:	e8 93 02 00 00       	call   43b <exit>

000001a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	57                   	push   %edi
 1ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b0:	8b 55 10             	mov    0x10(%ebp),%edx
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	89 cb                	mov    %ecx,%ebx
 1b8:	89 df                	mov    %ebx,%edi
 1ba:	89 d1                	mov    %edx,%ecx
 1bc:	fc                   	cld    
 1bd:	f3 aa                	rep stos %al,%es:(%edi)
 1bf:	89 ca                	mov    %ecx,%edx
 1c1:	89 fb                	mov    %edi,%ebx
 1c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1c9:	90                   	nop
 1ca:	5b                   	pop    %ebx
 1cb:	5f                   	pop    %edi
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret    

000001ce <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1da:	90                   	nop
 1db:	8b 55 0c             	mov    0xc(%ebp),%edx
 1de:	8d 42 01             	lea    0x1(%edx),%eax
 1e1:	89 45 0c             	mov    %eax,0xc(%ebp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8d 48 01             	lea    0x1(%eax),%ecx
 1ea:	89 4d 08             	mov    %ecx,0x8(%ebp)
 1ed:	0f b6 12             	movzbl (%edx),%edx
 1f0:	88 10                	mov    %dl,(%eax)
 1f2:	0f b6 00             	movzbl (%eax),%eax
 1f5:	84 c0                	test   %al,%al
 1f7:	75 e2                	jne    1db <strcpy+0xd>
    ;
  return os;
 1f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fc:	c9                   	leave  
 1fd:	c3                   	ret    

000001fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 201:	eb 08                	jmp    20b <strcmp+0xd>
    p++, q++;
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	84 c0                	test   %al,%al
 213:	74 10                	je     225 <strcmp+0x27>
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 10             	movzbl (%eax),%edx
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	38 c2                	cmp    %al,%dl
 223:	74 de                	je     203 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	0f b6 d0             	movzbl %al,%edx
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	0f b6 c0             	movzbl %al,%eax
 237:	29 c2                	sub    %eax,%edx
 239:	89 d0                	mov    %edx,%eax
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    

0000023d <strlen>:

uint
strlen(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 24a:	eb 04                	jmp    250 <strlen+0x13>
 24c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 250:	8b 55 fc             	mov    -0x4(%ebp),%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 d0                	add    %edx,%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 ed                	jne    24c <strlen+0xf>
    ;
  return n;
 25f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <memset>:

void*
memset(void *dst, int c, uint n)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 267:	8b 45 10             	mov    0x10(%ebp),%eax
 26a:	50                   	push   %eax
 26b:	ff 75 0c             	push   0xc(%ebp)
 26e:	ff 75 08             	push   0x8(%ebp)
 271:	e8 32 ff ff ff       	call   1a8 <stosb>
 276:	83 c4 0c             	add    $0xc,%esp
  return dst;
 279:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <strchr>:

char*
strchr(const char *s, char c)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 04             	sub    $0x4,%esp
 284:	8b 45 0c             	mov    0xc(%ebp),%eax
 287:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 28a:	eb 14                	jmp    2a0 <strchr+0x22>
    if(*s == c)
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	0f b6 00             	movzbl (%eax),%eax
 292:	38 45 fc             	cmp    %al,-0x4(%ebp)
 295:	75 05                	jne    29c <strchr+0x1e>
      return (char*)s;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	eb 13                	jmp    2af <strchr+0x31>
  for(; *s; s++)
 29c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	75 e2                	jne    28c <strchr+0xe>
  return 0;
 2aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2af:	c9                   	leave  
 2b0:	c3                   	ret    

000002b1 <gets>:

char*
gets(char *buf, int max)
{
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2be:	eb 42                	jmp    302 <gets+0x51>
    cc = read(0, &c, 1);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	6a 01                	push   $0x1
 2c5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2c8:	50                   	push   %eax
 2c9:	6a 00                	push   $0x0
 2cb:	e8 83 01 00 00       	call   453 <read>
 2d0:	83 c4 10             	add    $0x10,%esp
 2d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2da:	7e 33                	jle    30f <gets+0x5e>
      break;
    buf[i++] = c;
 2dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2e5:	89 c2                	mov    %eax,%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	01 c2                	add    %eax,%edx
 2ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2f2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f6:	3c 0a                	cmp    $0xa,%al
 2f8:	74 16                	je     310 <gets+0x5f>
 2fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2fe:	3c 0d                	cmp    $0xd,%al
 300:	74 0e                	je     310 <gets+0x5f>
  for(i=0; i+1 < max; ){
 302:	8b 45 f4             	mov    -0xc(%ebp),%eax
 305:	83 c0 01             	add    $0x1,%eax
 308:	39 45 0c             	cmp    %eax,0xc(%ebp)
 30b:	7f b3                	jg     2c0 <gets+0xf>
 30d:	eb 01                	jmp    310 <gets+0x5f>
      break;
 30f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 310:	8b 55 f4             	mov    -0xc(%ebp),%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	01 d0                	add    %edx,%eax
 318:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31e:	c9                   	leave  
 31f:	c3                   	ret    

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 326:	83 ec 08             	sub    $0x8,%esp
 329:	6a 00                	push   $0x0
 32b:	ff 75 08             	push   0x8(%ebp)
 32e:	e8 48 01 00 00       	call   47b <open>
 333:	83 c4 10             	add    $0x10,%esp
 336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 33d:	79 07                	jns    346 <stat+0x26>
    return -1;
 33f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 344:	eb 25                	jmp    36b <stat+0x4b>
  r = fstat(fd, st);
 346:	83 ec 08             	sub    $0x8,%esp
 349:	ff 75 0c             	push   0xc(%ebp)
 34c:	ff 75 f4             	push   -0xc(%ebp)
 34f:	e8 3f 01 00 00       	call   493 <fstat>
 354:	83 c4 10             	add    $0x10,%esp
 357:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35a:	83 ec 0c             	sub    $0xc,%esp
 35d:	ff 75 f4             	push   -0xc(%ebp)
 360:	e8 fe 00 00 00       	call   463 <close>
 365:	83 c4 10             	add    $0x10,%esp
  return r;
 368:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <atoi>:

int
atoi(const char *s)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 37a:	eb 25                	jmp    3a1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 37c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37f:	89 d0                	mov    %edx,%eax
 381:	c1 e0 02             	shl    $0x2,%eax
 384:	01 d0                	add    %edx,%eax
 386:	01 c0                	add    %eax,%eax
 388:	89 c1                	mov    %eax,%ecx
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	8d 50 01             	lea    0x1(%eax),%edx
 390:	89 55 08             	mov    %edx,0x8(%ebp)
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	0f be c0             	movsbl %al,%eax
 399:	01 c8                	add    %ecx,%eax
 39b:	83 e8 30             	sub    $0x30,%eax
 39e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	3c 2f                	cmp    $0x2f,%al
 3a9:	7e 0a                	jle    3b5 <atoi+0x48>
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 00             	movzbl (%eax),%eax
 3b1:	3c 39                	cmp    $0x39,%al
 3b3:	7e c7                	jle    37c <atoi+0xf>
  return n;
 3b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3cc:	eb 17                	jmp    3e5 <memmove+0x2b>
    *dst++ = *src++;
 3ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d1:	8d 42 01             	lea    0x1(%edx),%eax
 3d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3da:	8d 48 01             	lea    0x1(%eax),%ecx
 3dd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3e0:	0f b6 12             	movzbl (%edx),%edx
 3e3:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3e5:	8b 45 10             	mov    0x10(%ebp),%eax
 3e8:	8d 50 ff             	lea    -0x1(%eax),%edx
 3eb:	89 55 10             	mov    %edx,0x10(%ebp)
 3ee:	85 c0                	test   %eax,%eax
 3f0:	7f dc                	jg     3ce <memmove+0x14>
  return vdst;
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp

}
 3fa:	90                   	nop
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    

000003fd <acquireLock>:

void acquireLock(struct lock* l) {
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp

}
 400:	90                   	nop
 401:	5d                   	pop    %ebp
 402:	c3                   	ret    

00000403 <releaseLock>:

void releaseLock(struct lock* l) {
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp

}
 406:	90                   	nop
 407:	5d                   	pop    %ebp
 408:	c3                   	ret    

00000409 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp

}
 40c:	90                   	nop
 40d:	5d                   	pop    %ebp
 40e:	c3                   	ret    

0000040f <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp

}
 412:	90                   	nop
 413:	5d                   	pop    %ebp
 414:	c3                   	ret    

00000415 <broadcast>:

void broadcast(struct condvar* cv) {
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp

}
 418:	90                   	nop
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    

0000041b <signal>:

void signal(struct condvar* cv) {
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp

}
 41e:	90                   	nop
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    

00000421 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp

}
 424:	90                   	nop
 425:	5d                   	pop    %ebp
 426:	c3                   	ret    

00000427 <semUp>:

void semUp(struct semaphore* s) {
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp

}
 42a:	90                   	nop
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    

0000042d <semDown>:

void semDown(struct semaphore* s) {
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp

}
 430:	90                   	nop
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    

00000433 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 433:	b8 01 00 00 00       	mov    $0x1,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <exit>:
SYSCALL(exit)
 43b:	b8 02 00 00 00       	mov    $0x2,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <wait>:
SYSCALL(wait)
 443:	b8 03 00 00 00       	mov    $0x3,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <pipe>:
SYSCALL(pipe)
 44b:	b8 04 00 00 00       	mov    $0x4,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <read>:
SYSCALL(read)
 453:	b8 05 00 00 00       	mov    $0x5,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <write>:
SYSCALL(write)
 45b:	b8 10 00 00 00       	mov    $0x10,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <close>:
SYSCALL(close)
 463:	b8 15 00 00 00       	mov    $0x15,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <kill>:
SYSCALL(kill)
 46b:	b8 06 00 00 00       	mov    $0x6,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <exec>:
SYSCALL(exec)
 473:	b8 07 00 00 00       	mov    $0x7,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <open>:
SYSCALL(open)
 47b:	b8 0f 00 00 00       	mov    $0xf,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mknod>:
SYSCALL(mknod)
 483:	b8 11 00 00 00       	mov    $0x11,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <unlink>:
SYSCALL(unlink)
 48b:	b8 12 00 00 00       	mov    $0x12,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <fstat>:
SYSCALL(fstat)
 493:	b8 08 00 00 00       	mov    $0x8,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <link>:
SYSCALL(link)
 49b:	b8 13 00 00 00       	mov    $0x13,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <mkdir>:
SYSCALL(mkdir)
 4a3:	b8 14 00 00 00       	mov    $0x14,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <chdir>:
SYSCALL(chdir)
 4ab:	b8 09 00 00 00       	mov    $0x9,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <dup>:
SYSCALL(dup)
 4b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <getpid>:
SYSCALL(getpid)
 4bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sbrk>:
SYSCALL(sbrk)
 4c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <sleep>:
SYSCALL(sleep)
 4cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <uptime>:
SYSCALL(uptime)
 4d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <thread_create>:
SYSCALL(thread_create)
 4db:	b8 16 00 00 00       	mov    $0x16,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <thread_exit>:
SYSCALL(thread_exit)
 4e3:	b8 17 00 00 00       	mov    $0x17,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <thread_join>:
SYSCALL(thread_join)
 4eb:	b8 18 00 00 00       	mov    $0x18,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <waitpid>:
SYSCALL(waitpid)
 4f3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <barrier_init>:
SYSCALL(barrier_init)
 4fb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <barrier_check>:
SYSCALL(barrier_check)
 503:	b8 20 00 00 00       	mov    $0x20,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <sleepChan>:
SYSCALL(sleepChan)
 50b:	b8 24 00 00 00       	mov    $0x24,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <getChannel>:
SYSCALL(getChannel)
 513:	b8 25 00 00 00       	mov    $0x25,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <sigChan>:
SYSCALL(sigChan)
 51b:	b8 26 00 00 00       	mov    $0x26,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <sigOneChan>:
 523:	b8 27 00 00 00       	mov    $0x27,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	83 ec 18             	sub    $0x18,%esp
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 537:	83 ec 04             	sub    $0x4,%esp
 53a:	6a 01                	push   $0x1
 53c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 53f:	50                   	push   %eax
 540:	ff 75 08             	push   0x8(%ebp)
 543:	e8 13 ff ff ff       	call   45b <write>
 548:	83 c4 10             	add    $0x10,%esp
}
 54b:	90                   	nop
 54c:	c9                   	leave  
 54d:	c3                   	ret    

0000054e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 554:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 55b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 55f:	74 17                	je     578 <printint+0x2a>
 561:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 565:	79 11                	jns    578 <printint+0x2a>
    neg = 1;
 567:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 56e:	8b 45 0c             	mov    0xc(%ebp),%eax
 571:	f7 d8                	neg    %eax
 573:	89 45 ec             	mov    %eax,-0x14(%ebp)
 576:	eb 06                	jmp    57e <printint+0x30>
  } else {
    x = xx;
 578:	8b 45 0c             	mov    0xc(%ebp),%eax
 57b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 57e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 585:	8b 4d 10             	mov    0x10(%ebp),%ecx
 588:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58b:	ba 00 00 00 00       	mov    $0x0,%edx
 590:	f7 f1                	div    %ecx
 592:	89 d1                	mov    %edx,%ecx
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8d 50 01             	lea    0x1(%eax),%edx
 59a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 59d:	0f b6 91 a0 0d 00 00 	movzbl 0xda0(%ecx),%edx
 5a4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ae:	ba 00 00 00 00       	mov    $0x0,%edx
 5b3:	f7 f1                	div    %ecx
 5b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bc:	75 c7                	jne    585 <printint+0x37>
  if(neg)
 5be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c2:	74 2d                	je     5f1 <printint+0xa3>
    buf[i++] = '-';
 5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c7:	8d 50 01             	lea    0x1(%eax),%edx
 5ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5cd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d2:	eb 1d                	jmp    5f1 <printint+0xa3>
    putc(fd, buf[i]);
 5d4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5da:	01 d0                	add    %edx,%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	push   0x8(%ebp)
 5e9:	e8 3d ff ff ff       	call   52b <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5f1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f9:	79 d9                	jns    5d4 <printint+0x86>
}
 5fb:	90                   	nop
 5fc:	c9                   	leave  
 5fd:	c3                   	ret    

000005fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5fe:	55                   	push   %ebp
 5ff:	89 e5                	mov    %esp,%ebp
 601:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 604:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 60b:	8d 45 0c             	lea    0xc(%ebp),%eax
 60e:	83 c0 04             	add    $0x4,%eax
 611:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 614:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 61b:	e9 59 01 00 00       	jmp    779 <printf+0x17b>
    c = fmt[i] & 0xff;
 620:	8b 55 0c             	mov    0xc(%ebp),%edx
 623:	8b 45 f0             	mov    -0x10(%ebp),%eax
 626:	01 d0                	add    %edx,%eax
 628:	0f b6 00             	movzbl (%eax),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	25 ff 00 00 00       	and    $0xff,%eax
 633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 636:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63a:	75 2c                	jne    668 <printf+0x6a>
      if(c == '%'){
 63c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 640:	75 0c                	jne    64e <printf+0x50>
        state = '%';
 642:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 649:	e9 27 01 00 00       	jmp    775 <printf+0x177>
      } else {
        putc(fd, c);
 64e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	push   0x8(%ebp)
 65b:	e8 cb fe ff ff       	call   52b <putc>
 660:	83 c4 10             	add    $0x10,%esp
 663:	e9 0d 01 00 00       	jmp    775 <printf+0x177>
      }
    } else if(state == '%'){
 668:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 66c:	0f 85 03 01 00 00    	jne    775 <printf+0x177>
      if(c == 'd'){
 672:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 676:	75 1e                	jne    696 <printf+0x98>
        printint(fd, *ap, 10, 1);
 678:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	6a 01                	push   $0x1
 67f:	6a 0a                	push   $0xa
 681:	50                   	push   %eax
 682:	ff 75 08             	push   0x8(%ebp)
 685:	e8 c4 fe ff ff       	call   54e <printint>
 68a:	83 c4 10             	add    $0x10,%esp
        ap++;
 68d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 691:	e9 d8 00 00 00       	jmp    76e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 696:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 69a:	74 06                	je     6a2 <printf+0xa4>
 69c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a0:	75 1e                	jne    6c0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	6a 00                	push   $0x0
 6a9:	6a 10                	push   $0x10
 6ab:	50                   	push   %eax
 6ac:	ff 75 08             	push   0x8(%ebp)
 6af:	e8 9a fe ff ff       	call   54e <printint>
 6b4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bb:	e9 ae 00 00 00       	jmp    76e <printf+0x170>
      } else if(c == 's'){
 6c0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c4:	75 43                	jne    709 <printf+0x10b>
        s = (char*)*ap;
 6c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d6:	75 25                	jne    6fd <printf+0xff>
          s = "(null)";
 6d8:	c7 45 f4 d2 09 00 00 	movl   $0x9d2,-0xc(%ebp)
        while(*s != 0){
 6df:	eb 1c                	jmp    6fd <printf+0xff>
          putc(fd, *s);
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	0f be c0             	movsbl %al,%eax
 6ea:	83 ec 08             	sub    $0x8,%esp
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	push   0x8(%ebp)
 6f1:	e8 35 fe ff ff       	call   52b <putc>
 6f6:	83 c4 10             	add    $0x10,%esp
          s++;
 6f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	0f b6 00             	movzbl (%eax),%eax
 703:	84 c0                	test   %al,%al
 705:	75 da                	jne    6e1 <printf+0xe3>
 707:	eb 65                	jmp    76e <printf+0x170>
        }
      } else if(c == 'c'){
 709:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 70d:	75 1d                	jne    72c <printf+0x12e>
        putc(fd, *ap);
 70f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	0f be c0             	movsbl %al,%eax
 717:	83 ec 08             	sub    $0x8,%esp
 71a:	50                   	push   %eax
 71b:	ff 75 08             	push   0x8(%ebp)
 71e:	e8 08 fe ff ff       	call   52b <putc>
 723:	83 c4 10             	add    $0x10,%esp
        ap++;
 726:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72a:	eb 42                	jmp    76e <printf+0x170>
      } else if(c == '%'){
 72c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 730:	75 17                	jne    749 <printf+0x14b>
        putc(fd, c);
 732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 735:	0f be c0             	movsbl %al,%eax
 738:	83 ec 08             	sub    $0x8,%esp
 73b:	50                   	push   %eax
 73c:	ff 75 08             	push   0x8(%ebp)
 73f:	e8 e7 fd ff ff       	call   52b <putc>
 744:	83 c4 10             	add    $0x10,%esp
 747:	eb 25                	jmp    76e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 749:	83 ec 08             	sub    $0x8,%esp
 74c:	6a 25                	push   $0x25
 74e:	ff 75 08             	push   0x8(%ebp)
 751:	e8 d5 fd ff ff       	call   52b <putc>
 756:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	83 ec 08             	sub    $0x8,%esp
 762:	50                   	push   %eax
 763:	ff 75 08             	push   0x8(%ebp)
 766:	e8 c0 fd ff ff       	call   52b <putc>
 76b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 76e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 775:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 779:	8b 55 0c             	mov    0xc(%ebp),%edx
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	01 d0                	add    %edx,%eax
 781:	0f b6 00             	movzbl (%eax),%eax
 784:	84 c0                	test   %al,%al
 786:	0f 85 94 fe ff ff    	jne    620 <printf+0x22>
    }
  }
}
 78c:	90                   	nop
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	83 e8 08             	sub    $0x8,%eax
 79b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 7a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a6:	eb 24                	jmp    7cc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7b0:	72 12                	jb     7c4 <free+0x35>
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b8:	77 24                	ja     7de <free+0x4f>
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7c2:	72 1a                	jb     7de <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d2:	76 d4                	jbe    7a8 <free+0x19>
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7dc:	73 ca                	jae    7a8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	01 c2                	add    %eax,%edx
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	39 c2                	cmp    %eax,%edx
 7f7:	75 24                	jne    81d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	8b 50 04             	mov    0x4(%eax),%edx
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	01 c2                	add    %eax,%edx
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 0a                	jmp    827 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 10                	mov    (%eax),%edx
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	01 d0                	add    %edx,%eax
 839:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 83c:	75 20                	jne    85e <free+0xcf>
    p->s.size += bp->s.size;
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 50 04             	mov    0x4(%eax),%edx
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	01 c2                	add    %eax,%edx
 84c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 45 f8             	mov    -0x8(%ebp),%eax
 855:	8b 10                	mov    (%eax),%edx
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	89 10                	mov    %edx,(%eax)
 85c:	eb 08                	jmp    866 <free+0xd7>
  } else
    p->s.ptr = bp;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 55 f8             	mov    -0x8(%ebp),%edx
 864:	89 10                	mov    %edx,(%eax)
  freep = p;
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	a3 bc 0d 00 00       	mov    %eax,0xdbc
}
 86e:	90                   	nop
 86f:	c9                   	leave  
 870:	c3                   	ret    

00000871 <morecore>:

static Header*
morecore(uint nu)
{
 871:	55                   	push   %ebp
 872:	89 e5                	mov    %esp,%ebp
 874:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 877:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 87e:	77 07                	ja     887 <morecore+0x16>
    nu = 4096;
 880:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 887:	8b 45 08             	mov    0x8(%ebp),%eax
 88a:	c1 e0 03             	shl    $0x3,%eax
 88d:	83 ec 0c             	sub    $0xc,%esp
 890:	50                   	push   %eax
 891:	e8 2d fc ff ff       	call   4c3 <sbrk>
 896:	83 c4 10             	add    $0x10,%esp
 899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 89c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a0:	75 07                	jne    8a9 <morecore+0x38>
    return 0;
 8a2:	b8 00 00 00 00       	mov    $0x0,%eax
 8a7:	eb 26                	jmp    8cf <morecore+0x5e>
  hp = (Header*)p;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	8b 55 08             	mov    0x8(%ebp),%edx
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	83 c0 08             	add    $0x8,%eax
 8be:	83 ec 0c             	sub    $0xc,%esp
 8c1:	50                   	push   %eax
 8c2:	e8 c8 fe ff ff       	call   78f <free>
 8c7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ca:	a1 bc 0d 00 00       	mov    0xdbc,%eax
}
 8cf:	c9                   	leave  
 8d0:	c3                   	ret    

000008d1 <malloc>:

void*
malloc(uint nbytes)
{
 8d1:	55                   	push   %ebp
 8d2:	89 e5                	mov    %esp,%ebp
 8d4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d7:	8b 45 08             	mov    0x8(%ebp),%eax
 8da:	83 c0 07             	add    $0x7,%eax
 8dd:	c1 e8 03             	shr    $0x3,%eax
 8e0:	83 c0 01             	add    $0x1,%eax
 8e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8e6:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 8eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f2:	75 23                	jne    917 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f4:	c7 45 f0 b4 0d 00 00 	movl   $0xdb4,-0x10(%ebp)
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	a3 bc 0d 00 00       	mov    %eax,0xdbc
 903:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 908:	a3 b4 0d 00 00       	mov    %eax,0xdb4
    base.s.size = 0;
 90d:	c7 05 b8 0d 00 00 00 	movl   $0x0,0xdb8
 914:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 917:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 928:	77 4d                	ja     977 <malloc+0xa6>
      if(p->s.size == nunits)
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	8b 40 04             	mov    0x4(%eax),%eax
 930:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 933:	75 0c                	jne    941 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 10                	mov    (%eax),%edx
 93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93d:	89 10                	mov    %edx,(%eax)
 93f:	eb 26                	jmp    967 <malloc+0x96>
      else {
        p->s.size -= nunits;
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	2b 45 ec             	sub    -0x14(%ebp),%eax
 94a:	89 c2                	mov    %eax,%edx
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	8b 40 04             	mov    0x4(%eax),%eax
 958:	c1 e0 03             	shl    $0x3,%eax
 95b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 55 ec             	mov    -0x14(%ebp),%edx
 964:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 967:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96a:	a3 bc 0d 00 00       	mov    %eax,0xdbc
      return (void*)(p + 1);
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	83 c0 08             	add    $0x8,%eax
 975:	eb 3b                	jmp    9b2 <malloc+0xe1>
    }
    if(p == freep)
 977:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 97c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 97f:	75 1e                	jne    99f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 981:	83 ec 0c             	sub    $0xc,%esp
 984:	ff 75 ec             	push   -0x14(%ebp)
 987:	e8 e5 fe ff ff       	call   871 <morecore>
 98c:	83 c4 10             	add    $0x10,%esp
 98f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 996:	75 07                	jne    99f <malloc+0xce>
        return 0;
 998:	b8 00 00 00 00       	mov    $0x0,%eax
 99d:	eb 13                	jmp    9b2 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9ad:	e9 6d ff ff ff       	jmp    91f <malloc+0x4e>
  }
}
 9b2:	c9                   	leave  
 9b3:	c3                   	ret    
