
_t_threads:     file format elf32-i386


Disassembly of section .text:

00000000 <thread1>:
#include "user.h"

void* thread1(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Thread 1 created %d\n", *(int*)arg);
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	8b 00                	mov    (%eax),%eax
   b:	83 ec 04             	sub    $0x4,%esp
   e:	50                   	push   %eax
   f:	68 ff 08 00 00       	push   $0x8ff
  14:	6a 01                	push   $0x1
  16:	e8 2e 05 00 00       	call   549 <printf>
  1b:	83 c4 10             	add    $0x10,%esp
    int* argPtr = (int*)arg;
  1e:	8b 45 08             	mov    0x8(%ebp),%eax
  21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *argPtr = (*argPtr + 1);
  24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  27:	8b 00                	mov    (%eax),%eax
  29:	8d 50 01             	lea    0x1(%eax),%edx
  2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2f:	89 10                	mov    %edx,(%eax)

    exit();
  31:	e8 50 03 00 00       	call   386 <exit>

00000036 <thread2>:
    return 0;
}

void* thread2(void* arg){
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	83 ec 08             	sub    $0x8,%esp
    printf(1, "Thread 2 created %d\n", *(int*)arg);
  3c:	8b 45 08             	mov    0x8(%ebp),%eax
  3f:	8b 00                	mov    (%eax),%eax
  41:	83 ec 04             	sub    $0x4,%esp
  44:	50                   	push   %eax
  45:	68 14 09 00 00       	push   $0x914
  4a:	6a 01                	push   $0x1
  4c:	e8 f8 04 00 00       	call   549 <printf>
  51:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  54:	e8 d5 03 00 00       	call   42e <thread_exit>
    return 0;
  59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  5e:	c9                   	leave  
  5f:	c3                   	ret    

00000060 <main>:

int main(){
  60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  64:	83 e4 f0             	and    $0xfffffff0,%esp
  67:	ff 71 fc             	push   -0x4(%ecx)
  6a:	55                   	push   %ebp
  6b:	89 e5                	mov    %esp,%ebp
  6d:	51                   	push   %ecx
  6e:	83 ec 14             	sub    $0x14,%esp
    printf(1, "Hello World\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 29 09 00 00       	push   $0x929
  79:	6a 01                	push   $0x1
  7b:	e8 c9 04 00 00       	call   549 <printf>
  80:	83 c4 10             	add    $0x10,%esp
    int x = 10;
  83:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)
    uint tid1, tid2;
    // printf(1, "PID = %d\n", getpid());
    
    thread_create(&tid1, thread1, (void*)&x);
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  90:	50                   	push   %eax
  91:	68 00 00 00 00       	push   $0x0
  96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  99:	50                   	push   %eax
  9a:	e8 87 03 00 00       	call   426 <thread_create>
  9f:	83 c4 10             	add    $0x10,%esp
    // printf(1, "Thread one done.\n");

    thread_create(&tid2, thread2, (void*)&x);
  a2:	83 ec 04             	sub    $0x4,%esp
  a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  a8:	50                   	push   %eax
  a9:	68 36 00 00 00       	push   $0x36
  ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  b1:	50                   	push   %eax
  b2:	e8 6f 03 00 00       	call   426 <thread_create>
  b7:	83 c4 10             	add    $0x10,%esp
    // printf(1, "Thread two done.\n");

    thread_join(tid2);
  ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 70 03 00 00       	call   436 <thread_join>
  c6:	83 c4 10             	add    $0x10,%esp
    thread_join(tid1);
  c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	50                   	push   %eax
  d0:	e8 61 03 00 00       	call   436 <thread_join>
  d5:	83 c4 10             	add    $0x10,%esp
    printf(1,"Value of x = %d\n",x);
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	83 ec 04             	sub    $0x4,%esp
  de:	50                   	push   %eax
  df:	68 36 09 00 00       	push   $0x936
  e4:	6a 01                	push   $0x1
  e6:	e8 5e 04 00 00       	call   549 <printf>
  eb:	83 c4 10             	add    $0x10,%esp
    // printf(1, "Main Thread exitting\n");

    exit();
  ee:	e8 93 02 00 00       	call   386 <exit>

000000f3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  f6:	57                   	push   %edi
  f7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  fb:	8b 55 10             	mov    0x10(%ebp),%edx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	89 cb                	mov    %ecx,%ebx
 103:	89 df                	mov    %ebx,%edi
 105:	89 d1                	mov    %edx,%ecx
 107:	fc                   	cld    
 108:	f3 aa                	rep stos %al,%es:(%edi)
 10a:	89 ca                	mov    %ecx,%edx
 10c:	89 fb                	mov    %edi,%ebx
 10e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 111:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 114:	90                   	nop
 115:	5b                   	pop    %ebx
 116:	5f                   	pop    %edi
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 125:	90                   	nop
 126:	8b 55 0c             	mov    0xc(%ebp),%edx
 129:	8d 42 01             	lea    0x1(%edx),%eax
 12c:	89 45 0c             	mov    %eax,0xc(%ebp)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	8d 48 01             	lea    0x1(%eax),%ecx
 135:	89 4d 08             	mov    %ecx,0x8(%ebp)
 138:	0f b6 12             	movzbl (%edx),%edx
 13b:	88 10                	mov    %dl,(%eax)
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	84 c0                	test   %al,%al
 142:	75 e2                	jne    126 <strcpy+0xd>
    ;
  return os;
 144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 147:	c9                   	leave  
 148:	c3                   	ret    

00000149 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 14c:	eb 08                	jmp    156 <strcmp+0xd>
    p++, q++;
 14e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 152:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	74 10                	je     170 <strcmp+0x27>
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	0f b6 10             	movzbl (%eax),%edx
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	38 c2                	cmp    %al,%dl
 16e:	74 de                	je     14e <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	0f b6 d0             	movzbl %al,%edx
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	0f b6 c0             	movzbl %al,%eax
 182:	29 c2                	sub    %eax,%edx
 184:	89 d0                	mov    %edx,%eax
}
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    

00000188 <strlen>:

uint
strlen(const char *s)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 18e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 195:	eb 04                	jmp    19b <strlen+0x13>
 197:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 19b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 ed                	jne    197 <strlen+0xf>
    ;
  return n;
 1aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <memset>:

void*
memset(void *dst, int c, uint n)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b2:	8b 45 10             	mov    0x10(%ebp),%eax
 1b5:	50                   	push   %eax
 1b6:	ff 75 0c             	push   0xc(%ebp)
 1b9:	ff 75 08             	push   0x8(%ebp)
 1bc:	e8 32 ff ff ff       	call   f3 <stosb>
 1c1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <strchr>:

char*
strchr(const char *s, char c)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 04             	sub    $0x4,%esp
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d5:	eb 14                	jmp    1eb <strchr+0x22>
    if(*s == c)
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	0f b6 00             	movzbl (%eax),%eax
 1dd:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1e0:	75 05                	jne    1e7 <strchr+0x1e>
      return (char*)s;
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	eb 13                	jmp    1fa <strchr+0x31>
  for(; *s; s++)
 1e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	0f b6 00             	movzbl (%eax),%eax
 1f1:	84 c0                	test   %al,%al
 1f3:	75 e2                	jne    1d7 <strchr+0xe>
  return 0;
 1f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <gets>:

char*
gets(char *buf, int max)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 202:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 209:	eb 42                	jmp    24d <gets+0x51>
    cc = read(0, &c, 1);
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	6a 01                	push   $0x1
 210:	8d 45 ef             	lea    -0x11(%ebp),%eax
 213:	50                   	push   %eax
 214:	6a 00                	push   $0x0
 216:	e8 83 01 00 00       	call   39e <read>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 225:	7e 33                	jle    25a <gets+0x5e>
      break;
    buf[i++] = c;
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	8d 50 01             	lea    0x1(%eax),%edx
 22d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 230:	89 c2                	mov    %eax,%edx
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	01 c2                	add    %eax,%edx
 237:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 241:	3c 0a                	cmp    $0xa,%al
 243:	74 16                	je     25b <gets+0x5f>
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	3c 0d                	cmp    $0xd,%al
 24b:	74 0e                	je     25b <gets+0x5f>
  for(i=0; i+1 < max; ){
 24d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 250:	83 c0 01             	add    $0x1,%eax
 253:	39 45 0c             	cmp    %eax,0xc(%ebp)
 256:	7f b3                	jg     20b <gets+0xf>
 258:	eb 01                	jmp    25b <gets+0x5f>
      break;
 25a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 25b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	01 d0                	add    %edx,%eax
 263:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 266:	8b 45 08             	mov    0x8(%ebp),%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <stat>:

int
stat(const char *n, struct stat *st)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 271:	83 ec 08             	sub    $0x8,%esp
 274:	6a 00                	push   $0x0
 276:	ff 75 08             	push   0x8(%ebp)
 279:	e8 48 01 00 00       	call   3c6 <open>
 27e:	83 c4 10             	add    $0x10,%esp
 281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 288:	79 07                	jns    291 <stat+0x26>
    return -1;
 28a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28f:	eb 25                	jmp    2b6 <stat+0x4b>
  r = fstat(fd, st);
 291:	83 ec 08             	sub    $0x8,%esp
 294:	ff 75 0c             	push   0xc(%ebp)
 297:	ff 75 f4             	push   -0xc(%ebp)
 29a:	e8 3f 01 00 00       	call   3de <fstat>
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a5:	83 ec 0c             	sub    $0xc,%esp
 2a8:	ff 75 f4             	push   -0xc(%ebp)
 2ab:	e8 fe 00 00 00       	call   3ae <close>
 2b0:	83 c4 10             	add    $0x10,%esp
  return r;
 2b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c5:	eb 25                	jmp    2ec <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ca:	89 d0                	mov    %edx,%eax
 2cc:	c1 e0 02             	shl    $0x2,%eax
 2cf:	01 d0                	add    %edx,%eax
 2d1:	01 c0                	add    %eax,%eax
 2d3:	89 c1                	mov    %eax,%ecx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8d 50 01             	lea    0x1(%eax),%edx
 2db:	89 55 08             	mov    %edx,0x8(%ebp)
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	0f be c0             	movsbl %al,%eax
 2e4:	01 c8                	add    %ecx,%eax
 2e6:	83 e8 30             	sub    $0x30,%eax
 2e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 2f                	cmp    $0x2f,%al
 2f4:	7e 0a                	jle    300 <atoi+0x48>
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 39                	cmp    $0x39,%al
 2fe:	7e c7                	jle    2c7 <atoi+0xf>
  return n;
 300:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
 308:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 311:	8b 45 0c             	mov    0xc(%ebp),%eax
 314:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 317:	eb 17                	jmp    330 <memmove+0x2b>
    *dst++ = *src++;
 319:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31c:	8d 42 01             	lea    0x1(%edx),%eax
 31f:	89 45 f8             	mov    %eax,-0x8(%ebp)
 322:	8b 45 fc             	mov    -0x4(%ebp),%eax
 325:	8d 48 01             	lea    0x1(%eax),%ecx
 328:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 32b:	0f b6 12             	movzbl (%edx),%edx
 32e:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 330:	8b 45 10             	mov    0x10(%ebp),%eax
 333:	8d 50 ff             	lea    -0x1(%eax),%edx
 336:	89 55 10             	mov    %edx,0x10(%ebp)
 339:	85 c0                	test   %eax,%eax
 33b:	7f dc                	jg     319 <memmove+0x14>
  return vdst;
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp

}
 345:	90                   	nop
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    

00000348 <acquireLock>:

void acquireLock(struct lock* l) {
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp

}
 34b:	90                   	nop
 34c:	5d                   	pop    %ebp
 34d:	c3                   	ret    

0000034e <releaseLock>:

void releaseLock(struct lock* l) {
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp

}
 351:	90                   	nop
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    

00000354 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp

}
 357:	90                   	nop
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    

0000035a <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp

}
 35d:	90                   	nop
 35e:	5d                   	pop    %ebp
 35f:	c3                   	ret    

00000360 <broadcast>:

void broadcast(struct condvar* cv) {
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp

}
 363:	90                   	nop
 364:	5d                   	pop    %ebp
 365:	c3                   	ret    

00000366 <signal>:

void signal(struct condvar* cv) {
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp

}
 369:	90                   	nop
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <semInit>:

void semInit(struct semaphore* s, int initVal) {
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp

}
 36f:	90                   	nop
 370:	5d                   	pop    %ebp
 371:	c3                   	ret    

00000372 <semUp>:

void semUp(struct semaphore* s) {
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp

}
 375:	90                   	nop
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    

00000378 <semDown>:

void semDown(struct semaphore* s) {
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp

}
 37b:	90                   	nop
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    

0000037e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37e:	b8 01 00 00 00       	mov    $0x1,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <exit>:
SYSCALL(exit)
 386:	b8 02 00 00 00       	mov    $0x2,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <wait>:
SYSCALL(wait)
 38e:	b8 03 00 00 00       	mov    $0x3,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <pipe>:
SYSCALL(pipe)
 396:	b8 04 00 00 00       	mov    $0x4,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <read>:
SYSCALL(read)
 39e:	b8 05 00 00 00       	mov    $0x5,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <write>:
SYSCALL(write)
 3a6:	b8 10 00 00 00       	mov    $0x10,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <close>:
SYSCALL(close)
 3ae:	b8 15 00 00 00       	mov    $0x15,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <kill>:
SYSCALL(kill)
 3b6:	b8 06 00 00 00       	mov    $0x6,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <exec>:
SYSCALL(exec)
 3be:	b8 07 00 00 00       	mov    $0x7,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <open>:
SYSCALL(open)
 3c6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mknod>:
SYSCALL(mknod)
 3ce:	b8 11 00 00 00       	mov    $0x11,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <unlink>:
SYSCALL(unlink)
 3d6:	b8 12 00 00 00       	mov    $0x12,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <fstat>:
SYSCALL(fstat)
 3de:	b8 08 00 00 00       	mov    $0x8,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <link>:
SYSCALL(link)
 3e6:	b8 13 00 00 00       	mov    $0x13,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <mkdir>:
SYSCALL(mkdir)
 3ee:	b8 14 00 00 00       	mov    $0x14,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <chdir>:
SYSCALL(chdir)
 3f6:	b8 09 00 00 00       	mov    $0x9,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <dup>:
SYSCALL(dup)
 3fe:	b8 0a 00 00 00       	mov    $0xa,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <getpid>:
SYSCALL(getpid)
 406:	b8 0b 00 00 00       	mov    $0xb,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <sbrk>:
SYSCALL(sbrk)
 40e:	b8 0c 00 00 00       	mov    $0xc,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <sleep>:
SYSCALL(sleep)
 416:	b8 0d 00 00 00       	mov    $0xd,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <uptime>:
SYSCALL(uptime)
 41e:	b8 0e 00 00 00       	mov    $0xe,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <thread_create>:
SYSCALL(thread_create)
 426:	b8 16 00 00 00       	mov    $0x16,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <thread_exit>:
SYSCALL(thread_exit)
 42e:	b8 17 00 00 00       	mov    $0x17,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <thread_join>:
SYSCALL(thread_join)
 436:	b8 18 00 00 00       	mov    $0x18,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <waitpid>:
SYSCALL(waitpid)
 43e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <barrier_init>:
SYSCALL(barrier_init)
 446:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <barrier_check>:
SYSCALL(barrier_check)
 44e:	b8 20 00 00 00       	mov    $0x20,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <sleepChan>:
SYSCALL(sleepChan)
 456:	b8 24 00 00 00       	mov    $0x24,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <getChannel>:
SYSCALL(getChannel)
 45e:	b8 25 00 00 00       	mov    $0x25,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <sigChan>:
SYSCALL(sigChan)
 466:	b8 26 00 00 00       	mov    $0x26,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <sigOneChan>:
 46e:	b8 27 00 00 00       	mov    $0x27,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	83 ec 18             	sub    $0x18,%esp
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 482:	83 ec 04             	sub    $0x4,%esp
 485:	6a 01                	push   $0x1
 487:	8d 45 f4             	lea    -0xc(%ebp),%eax
 48a:	50                   	push   %eax
 48b:	ff 75 08             	push   0x8(%ebp)
 48e:	e8 13 ff ff ff       	call   3a6 <write>
 493:	83 c4 10             	add    $0x10,%esp
}
 496:	90                   	nop
 497:	c9                   	leave  
 498:	c3                   	ret    

00000499 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 499:	55                   	push   %ebp
 49a:	89 e5                	mov    %esp,%ebp
 49c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 49f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4aa:	74 17                	je     4c3 <printint+0x2a>
 4ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b0:	79 11                	jns    4c3 <printint+0x2a>
    neg = 1;
 4b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	f7 d8                	neg    %eax
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c1:	eb 06                	jmp    4c9 <printint+0x30>
  } else {
    x = xx;
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	ba 00 00 00 00       	mov    $0x0,%edx
 4db:	f7 f1                	div    %ecx
 4dd:	89 d1                	mov    %edx,%ecx
 4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e2:	8d 50 01             	lea    0x1(%eax),%edx
 4e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e8:	0f b6 91 10 0d 00 00 	movzbl 0xd10(%ecx),%edx
 4ef:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f9:	ba 00 00 00 00       	mov    $0x0,%edx
 4fe:	f7 f1                	div    %ecx
 500:	89 45 ec             	mov    %eax,-0x14(%ebp)
 503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 507:	75 c7                	jne    4d0 <printint+0x37>
  if(neg)
 509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50d:	74 2d                	je     53c <printint+0xa3>
    buf[i++] = '-';
 50f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 512:	8d 50 01             	lea    0x1(%eax),%edx
 515:	89 55 f4             	mov    %edx,-0xc(%ebp)
 518:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 51d:	eb 1d                	jmp    53c <printint+0xa3>
    putc(fd, buf[i]);
 51f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 522:	8b 45 f4             	mov    -0xc(%ebp),%eax
 525:	01 d0                	add    %edx,%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	push   0x8(%ebp)
 534:	e8 3d ff ff ff       	call   476 <putc>
 539:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 53c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 544:	79 d9                	jns    51f <printint+0x86>
}
 546:	90                   	nop
 547:	c9                   	leave  
 548:	c3                   	ret    

00000549 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 549:	55                   	push   %ebp
 54a:	89 e5                	mov    %esp,%ebp
 54c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 556:	8d 45 0c             	lea    0xc(%ebp),%eax
 559:	83 c0 04             	add    $0x4,%eax
 55c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 566:	e9 59 01 00 00       	jmp    6c4 <printf+0x17b>
    c = fmt[i] & 0xff;
 56b:	8b 55 0c             	mov    0xc(%ebp),%edx
 56e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 571:	01 d0                	add    %edx,%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	25 ff 00 00 00       	and    $0xff,%eax
 57e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 581:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 585:	75 2c                	jne    5b3 <printf+0x6a>
      if(c == '%'){
 587:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58b:	75 0c                	jne    599 <printf+0x50>
        state = '%';
 58d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 594:	e9 27 01 00 00       	jmp    6c0 <printf+0x177>
      } else {
        putc(fd, c);
 599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	push   0x8(%ebp)
 5a6:	e8 cb fe ff ff       	call   476 <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
 5ae:	e9 0d 01 00 00       	jmp    6c0 <printf+0x177>
      }
    } else if(state == '%'){
 5b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b7:	0f 85 03 01 00 00    	jne    6c0 <printf+0x177>
      if(c == 'd'){
 5bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5c1:	75 1e                	jne    5e1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	6a 01                	push   $0x1
 5ca:	6a 0a                	push   $0xa
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	push   0x8(%ebp)
 5d0:	e8 c4 fe ff ff       	call   499 <printint>
 5d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dc:	e9 d8 00 00 00       	jmp    6b9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5e1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e5:	74 06                	je     5ed <printf+0xa4>
 5e7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5eb:	75 1e                	jne    60b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	6a 00                	push   $0x0
 5f4:	6a 10                	push   $0x10
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	push   0x8(%ebp)
 5fa:	e8 9a fe ff ff       	call   499 <printint>
 5ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 602:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 606:	e9 ae 00 00 00       	jmp    6b9 <printf+0x170>
      } else if(c == 's'){
 60b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60f:	75 43                	jne    654 <printf+0x10b>
        s = (char*)*ap;
 611:	8b 45 e8             	mov    -0x18(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 619:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 621:	75 25                	jne    648 <printf+0xff>
          s = "(null)";
 623:	c7 45 f4 47 09 00 00 	movl   $0x947,-0xc(%ebp)
        while(*s != 0){
 62a:	eb 1c                	jmp    648 <printf+0xff>
          putc(fd, *s);
 62c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62f:	0f b6 00             	movzbl (%eax),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	push   0x8(%ebp)
 63c:	e8 35 fe ff ff       	call   476 <putc>
 641:	83 c4 10             	add    $0x10,%esp
          s++;
 644:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 648:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64b:	0f b6 00             	movzbl (%eax),%eax
 64e:	84 c0                	test   %al,%al
 650:	75 da                	jne    62c <printf+0xe3>
 652:	eb 65                	jmp    6b9 <printf+0x170>
        }
      } else if(c == 'c'){
 654:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 658:	75 1d                	jne    677 <printf+0x12e>
        putc(fd, *ap);
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	83 ec 08             	sub    $0x8,%esp
 665:	50                   	push   %eax
 666:	ff 75 08             	push   0x8(%ebp)
 669:	e8 08 fe ff ff       	call   476 <putc>
 66e:	83 c4 10             	add    $0x10,%esp
        ap++;
 671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 675:	eb 42                	jmp    6b9 <printf+0x170>
      } else if(c == '%'){
 677:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67b:	75 17                	jne    694 <printf+0x14b>
        putc(fd, c);
 67d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 680:	0f be c0             	movsbl %al,%eax
 683:	83 ec 08             	sub    $0x8,%esp
 686:	50                   	push   %eax
 687:	ff 75 08             	push   0x8(%ebp)
 68a:	e8 e7 fd ff ff       	call   476 <putc>
 68f:	83 c4 10             	add    $0x10,%esp
 692:	eb 25                	jmp    6b9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 694:	83 ec 08             	sub    $0x8,%esp
 697:	6a 25                	push   $0x25
 699:	ff 75 08             	push   0x8(%ebp)
 69c:	e8 d5 fd ff ff       	call   476 <putc>
 6a1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a7:	0f be c0             	movsbl %al,%eax
 6aa:	83 ec 08             	sub    $0x8,%esp
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	push   0x8(%ebp)
 6b1:	e8 c0 fd ff ff       	call   476 <putc>
 6b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ca:	01 d0                	add    %edx,%eax
 6cc:	0f b6 00             	movzbl (%eax),%eax
 6cf:	84 c0                	test   %al,%al
 6d1:	0f 85 94 fe ff ff    	jne    56b <printf+0x22>
    }
  }
}
 6d7:	90                   	nop
 6d8:	c9                   	leave  
 6d9:	c3                   	ret    

000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	55                   	push   %ebp
 6db:	89 e5                	mov    %esp,%ebp
 6dd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	83 e8 08             	sub    $0x8,%eax
 6e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e9:	a1 2c 0d 00 00       	mov    0xd2c,%eax
 6ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f1:	eb 24                	jmp    717 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6fb:	72 12                	jb     70f <free+0x35>
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 703:	77 24                	ja     729 <free+0x4f>
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 70d:	72 1a                	jb     729 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	89 45 fc             	mov    %eax,-0x4(%ebp)
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71d:	76 d4                	jbe    6f3 <free+0x19>
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 727:	73 ca                	jae    6f3 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	01 c2                	add    %eax,%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	39 c2                	cmp    %eax,%edx
 742:	75 24                	jne    768 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	8b 50 04             	mov    0x4(%eax),%edx
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	01 c2                	add    %eax,%edx
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 00                	mov    (%eax),%eax
 75f:	8b 10                	mov    (%eax),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	89 10                	mov    %edx,(%eax)
 766:	eb 0a                	jmp    772 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 10                	mov    (%eax),%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	01 d0                	add    %edx,%eax
 784:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 787:	75 20                	jne    7a9 <free+0xcf>
    p->s.size += bp->s.size;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 50 04             	mov    0x4(%eax),%edx
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	01 c2                	add    %eax,%edx
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	89 10                	mov    %edx,(%eax)
 7a7:	eb 08                	jmp    7b1 <free+0xd7>
  } else
    p->s.ptr = bp;
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7af:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	a3 2c 0d 00 00       	mov    %eax,0xd2c
}
 7b9:	90                   	nop
 7ba:	c9                   	leave  
 7bb:	c3                   	ret    

000007bc <morecore>:

static Header*
morecore(uint nu)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c9:	77 07                	ja     7d2 <morecore+0x16>
    nu = 4096;
 7cb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	c1 e0 03             	shl    $0x3,%eax
 7d8:	83 ec 0c             	sub    $0xc,%esp
 7db:	50                   	push   %eax
 7dc:	e8 2d fc ff ff       	call   40e <sbrk>
 7e1:	83 c4 10             	add    $0x10,%esp
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7eb:	75 07                	jne    7f4 <morecore+0x38>
    return 0;
 7ed:	b8 00 00 00 00       	mov    $0x0,%eax
 7f2:	eb 26                	jmp    81a <morecore+0x5e>
  hp = (Header*)p;
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fd:	8b 55 08             	mov    0x8(%ebp),%edx
 800:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	83 c0 08             	add    $0x8,%eax
 809:	83 ec 0c             	sub    $0xc,%esp
 80c:	50                   	push   %eax
 80d:	e8 c8 fe ff ff       	call   6da <free>
 812:	83 c4 10             	add    $0x10,%esp
  return freep;
 815:	a1 2c 0d 00 00       	mov    0xd2c,%eax
}
 81a:	c9                   	leave  
 81b:	c3                   	ret    

0000081c <malloc>:

void*
malloc(uint nbytes)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	8b 45 08             	mov    0x8(%ebp),%eax
 825:	83 c0 07             	add    $0x7,%eax
 828:	c1 e8 03             	shr    $0x3,%eax
 82b:	83 c0 01             	add    $0x1,%eax
 82e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 831:	a1 2c 0d 00 00       	mov    0xd2c,%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
 839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83d:	75 23                	jne    862 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83f:	c7 45 f0 24 0d 00 00 	movl   $0xd24,-0x10(%ebp)
 846:	8b 45 f0             	mov    -0x10(%ebp),%eax
 849:	a3 2c 0d 00 00       	mov    %eax,0xd2c
 84e:	a1 2c 0d 00 00       	mov    0xd2c,%eax
 853:	a3 24 0d 00 00       	mov    %eax,0xd24
    base.s.size = 0;
 858:	c7 05 28 0d 00 00 00 	movl   $0x0,0xd28
 85f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	8b 40 04             	mov    0x4(%eax),%eax
 870:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 873:	77 4d                	ja     8c2 <malloc+0xa6>
      if(p->s.size == nunits)
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 87e:	75 0c                	jne    88c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	8b 10                	mov    (%eax),%edx
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	89 10                	mov    %edx,(%eax)
 88a:	eb 26                	jmp    8b2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	2b 45 ec             	sub    -0x14(%ebp),%eax
 895:	89 c2                	mov    %eax,%edx
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	8b 40 04             	mov    0x4(%eax),%eax
 8a3:	c1 e0 03             	shl    $0x3,%eax
 8a6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8af:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	a3 2c 0d 00 00       	mov    %eax,0xd2c
      return (void*)(p + 1);
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	83 c0 08             	add    $0x8,%eax
 8c0:	eb 3b                	jmp    8fd <malloc+0xe1>
    }
    if(p == freep)
 8c2:	a1 2c 0d 00 00       	mov    0xd2c,%eax
 8c7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ca:	75 1e                	jne    8ea <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8cc:	83 ec 0c             	sub    $0xc,%esp
 8cf:	ff 75 ec             	push   -0x14(%ebp)
 8d2:	e8 e5 fe ff ff       	call   7bc <morecore>
 8d7:	83 c4 10             	add    $0x10,%esp
 8da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e1:	75 07                	jne    8ea <malloc+0xce>
        return 0;
 8e3:	b8 00 00 00 00       	mov    $0x0,%eax
 8e8:	eb 13                	jmp    8fd <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f8:	e9 6d ff ff ff       	jmp    86a <malloc+0x4e>
  }
}
 8fd:	c9                   	leave  
 8fe:	c3                   	ret    
