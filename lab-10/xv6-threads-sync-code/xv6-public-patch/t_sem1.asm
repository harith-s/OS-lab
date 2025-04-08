
_t_sem1:     file format elf32-i386


Disassembly of section .text:

00000000 <thread2>:
struct all{
    int* x;
    struct semaphore *s;
};

void* thread2(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    struct all* t = (struct all*) arg;
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1,"Gonna acquire semaphore\n");
   c:	83 ec 08             	sub    $0x8,%esp
   f:	68 38 09 00 00       	push   $0x938
  14:	6a 01                	push   $0x1
  16:	e8 67 05 00 00       	call   582 <printf>
  1b:	83 c4 10             	add    $0x10,%esp
    semDown(t->s);
  1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  21:	8b 40 04             	mov    0x4(%eax),%eax
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	50                   	push   %eax
  28:	e8 84 03 00 00       	call   3b1 <semDown>
  2d:	83 c4 10             	add    $0x10,%esp
    printf(1,"Acquired semaphore successfully\n");
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 54 09 00 00       	push   $0x954
  38:	6a 01                	push   $0x1
  3a:	e8 43 05 00 00       	call   582 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
    int* argPtr = t->x;
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	8b 00                	mov    (%eax),%eax
  47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    *argPtr = (*argPtr + 1);
  4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4d:	8b 00                	mov    (%eax),%eax
  4f:	8d 50 01             	lea    0x1(%eax),%edx
  52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  55:	89 10                	mov    %edx,(%eax)
    semUp(t->s);
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	8b 40 04             	mov    0x4(%eax),%eax
  5d:	83 ec 0c             	sub    $0xc,%esp
  60:	50                   	push   %eax
  61:	e8 45 03 00 00       	call   3ab <semUp>
  66:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  69:	e8 f9 03 00 00       	call   467 <thread_exit>
    return 0;
  6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  73:	c9                   	leave  
  74:	c3                   	ret    

00000075 <main>:

int main(){
  75:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  79:	83 e4 f0             	and    $0xfffffff0,%esp
  7c:	ff 71 fc             	push   -0x4(%ecx)
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  82:	51                   	push   %ecx
  83:	83 ec 34             	sub    $0x34,%esp
    struct semaphore s;
    semInit(&s,1);
  86:	83 ec 08             	sub    $0x8,%esp
  89:	6a 01                	push   $0x1
  8b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8e:	50                   	push   %eax
  8f:	e8 11 03 00 00       	call   3a5 <semInit>
  94:	83 c4 10             	add    $0x10,%esp
    printf(1, "Hello World\n");
  97:	83 ec 08             	sub    $0x8,%esp
  9a:	68 75 09 00 00       	push   $0x975
  9f:	6a 01                	push   $0x1
  a1:	e8 dc 04 00 00       	call   582 <printf>
  a6:	83 c4 10             	add    $0x10,%esp
    int x = 10;
  a9:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    struct all a;
    a.x = &x;
  b0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    a.s = &s;
  b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint tid1;
    semDown(&s);
  bc:	83 ec 0c             	sub    $0xc,%esp
  bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  c2:	50                   	push   %eax
  c3:	e8 e9 02 00 00       	call   3b1 <semDown>
  c8:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid1,thread2,(void*)&a);
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	68 00 00 00 00       	push   $0x0
  d7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  da:	50                   	push   %eax
  db:	e8 7f 03 00 00       	call   45f <thread_create>
  e0:	83 c4 10             	add    $0x10,%esp
    sleep(200);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	68 c8 00 00 00       	push   $0xc8
  eb:	e8 5f 03 00 00       	call   44f <sleep>
  f0:	83 c4 10             	add    $0x10,%esp
    semUp(&s);
  f3:	83 ec 0c             	sub    $0xc,%esp
  f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  f9:	50                   	push   %eax
  fa:	e8 ac 02 00 00       	call   3ab <semUp>
  ff:	83 c4 10             	add    $0x10,%esp
    thread_join(tid1);
 102:	8b 45 d0             	mov    -0x30(%ebp),%eax
 105:	83 ec 0c             	sub    $0xc,%esp
 108:	50                   	push   %eax
 109:	e8 61 03 00 00       	call   46f <thread_join>
 10e:	83 c4 10             	add    $0x10,%esp
    printf(1,"Value of x = %d\n",x);
 111:	8b 45 dc             	mov    -0x24(%ebp),%eax
 114:	83 ec 04             	sub    $0x4,%esp
 117:	50                   	push   %eax
 118:	68 82 09 00 00       	push   $0x982
 11d:	6a 01                	push   $0x1
 11f:	e8 5e 04 00 00       	call   582 <printf>
 124:	83 c4 10             	add    $0x10,%esp
    exit();
 127:	e8 93 02 00 00       	call   3bf <exit>

0000012c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
 134:	8b 55 10             	mov    0x10(%ebp),%edx
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	89 cb                	mov    %ecx,%ebx
 13c:	89 df                	mov    %ebx,%edi
 13e:	89 d1                	mov    %edx,%ecx
 140:	fc                   	cld    
 141:	f3 aa                	rep stos %al,%es:(%edi)
 143:	89 ca                	mov    %ecx,%edx
 145:	89 fb                	mov    %edi,%ebx
 147:	89 5d 08             	mov    %ebx,0x8(%ebp)
 14a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14d:	90                   	nop
 14e:	5b                   	pop    %ebx
 14f:	5f                   	pop    %edi
 150:	5d                   	pop    %ebp
 151:	c3                   	ret    

00000152 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15e:	90                   	nop
 15f:	8b 55 0c             	mov    0xc(%ebp),%edx
 162:	8d 42 01             	lea    0x1(%edx),%eax
 165:	89 45 0c             	mov    %eax,0xc(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	8d 48 01             	lea    0x1(%eax),%ecx
 16e:	89 4d 08             	mov    %ecx,0x8(%ebp)
 171:	0f b6 12             	movzbl (%edx),%edx
 174:	88 10                	mov    %dl,(%eax)
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 e2                	jne    15f <strcpy+0xd>
    ;
  return os;
 17d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 185:	eb 08                	jmp    18f <strcmp+0xd>
    p++, q++;
 187:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	84 c0                	test   %al,%al
 197:	74 10                	je     1a9 <strcmp+0x27>
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 10             	movzbl (%eax),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	0f b6 00             	movzbl (%eax),%eax
 1a5:	38 c2                	cmp    %al,%dl
 1a7:	74 de                	je     187 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	0f b6 d0             	movzbl %al,%edx
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	0f b6 c0             	movzbl %al,%eax
 1bb:	29 c2                	sub    %eax,%edx
 1bd:	89 d0                	mov    %edx,%eax
}
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    

000001c1 <strlen>:

uint
strlen(const char *s)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ce:	eb 04                	jmp    1d4 <strlen+0x13>
 1d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	01 d0                	add    %edx,%eax
 1dc:	0f b6 00             	movzbl (%eax),%eax
 1df:	84 c0                	test   %al,%al
 1e1:	75 ed                	jne    1d0 <strlen+0xf>
    ;
  return n;
 1e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1eb:	8b 45 10             	mov    0x10(%ebp),%eax
 1ee:	50                   	push   %eax
 1ef:	ff 75 0c             	push   0xc(%ebp)
 1f2:	ff 75 08             	push   0x8(%ebp)
 1f5:	e8 32 ff ff ff       	call   12c <stosb>
 1fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 04             	sub    $0x4,%esp
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20e:	eb 14                	jmp    224 <strchr+0x22>
    if(*s == c)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	38 45 fc             	cmp    %al,-0x4(%ebp)
 219:	75 05                	jne    220 <strchr+0x1e>
      return (char*)s;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	eb 13                	jmp    233 <strchr+0x31>
  for(; *s; s++)
 220:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 e2                	jne    210 <strchr+0xe>
  return 0;
 22e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <gets>:

char*
gets(char *buf, int max)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 242:	eb 42                	jmp    286 <gets+0x51>
    cc = read(0, &c, 1);
 244:	83 ec 04             	sub    $0x4,%esp
 247:	6a 01                	push   $0x1
 249:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24c:	50                   	push   %eax
 24d:	6a 00                	push   $0x0
 24f:	e8 83 01 00 00       	call   3d7 <read>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25e:	7e 33                	jle    293 <gets+0x5e>
      break;
    buf[i++] = c;
 260:	8b 45 f4             	mov    -0xc(%ebp),%eax
 263:	8d 50 01             	lea    0x1(%eax),%edx
 266:	89 55 f4             	mov    %edx,-0xc(%ebp)
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 c2                	add    %eax,%edx
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 276:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27a:	3c 0a                	cmp    $0xa,%al
 27c:	74 16                	je     294 <gets+0x5f>
 27e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 282:	3c 0d                	cmp    $0xd,%al
 284:	74 0e                	je     294 <gets+0x5f>
  for(i=0; i+1 < max; ){
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28f:	7f b3                	jg     244 <gets+0xf>
 291:	eb 01                	jmp    294 <gets+0x5f>
      break;
 293:	90                   	nop
      break;
  }
  buf[i] = '\0';
 294:	8b 55 f4             	mov    -0xc(%ebp),%edx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	01 d0                	add    %edx,%eax
 29c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	83 ec 08             	sub    $0x8,%esp
 2ad:	6a 00                	push   $0x0
 2af:	ff 75 08             	push   0x8(%ebp)
 2b2:	e8 48 01 00 00       	call   3ff <open>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c1:	79 07                	jns    2ca <stat+0x26>
    return -1;
 2c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c8:	eb 25                	jmp    2ef <stat+0x4b>
  r = fstat(fd, st);
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	ff 75 0c             	push   0xc(%ebp)
 2d0:	ff 75 f4             	push   -0xc(%ebp)
 2d3:	e8 3f 01 00 00       	call   417 <fstat>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2de:	83 ec 0c             	sub    $0xc,%esp
 2e1:	ff 75 f4             	push   -0xc(%ebp)
 2e4:	e8 fe 00 00 00       	call   3e7 <close>
 2e9:	83 c4 10             	add    $0x10,%esp
  return r;
 2ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <atoi>:

int
atoi(const char *s)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fe:	eb 25                	jmp    325 <atoi+0x34>
    n = n*10 + *s++ - '0';
 300:	8b 55 fc             	mov    -0x4(%ebp),%edx
 303:	89 d0                	mov    %edx,%eax
 305:	c1 e0 02             	shl    $0x2,%eax
 308:	01 d0                	add    %edx,%eax
 30a:	01 c0                	add    %eax,%eax
 30c:	89 c1                	mov    %eax,%ecx
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	8d 50 01             	lea    0x1(%eax),%edx
 314:	89 55 08             	mov    %edx,0x8(%ebp)
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	0f be c0             	movsbl %al,%eax
 31d:	01 c8                	add    %ecx,%eax
 31f:	83 e8 30             	sub    $0x30,%eax
 322:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	3c 2f                	cmp    $0x2f,%al
 32d:	7e 0a                	jle    339 <atoi+0x48>
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	0f b6 00             	movzbl (%eax),%eax
 335:	3c 39                	cmp    $0x39,%al
 337:	7e c7                	jle    300 <atoi+0xf>
  return n;
 339:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33c:	c9                   	leave  
 33d:	c3                   	ret    

0000033e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 350:	eb 17                	jmp    369 <memmove+0x2b>
    *dst++ = *src++;
 352:	8b 55 f8             	mov    -0x8(%ebp),%edx
 355:	8d 42 01             	lea    0x1(%edx),%eax
 358:	89 45 f8             	mov    %eax,-0x8(%ebp)
 35b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35e:	8d 48 01             	lea    0x1(%eax),%ecx
 361:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 364:	0f b6 12             	movzbl (%edx),%edx
 367:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 369:	8b 45 10             	mov    0x10(%ebp),%eax
 36c:	8d 50 ff             	lea    -0x1(%eax),%edx
 36f:	89 55 10             	mov    %edx,0x10(%ebp)
 372:	85 c0                	test   %eax,%eax
 374:	7f dc                	jg     352 <memmove+0x14>
  return vdst;
 376:	8b 45 08             	mov    0x8(%ebp),%eax
}
 379:	c9                   	leave  
 37a:	c3                   	ret    

0000037b <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp

}
 37e:	90                   	nop
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <acquireLock>:

void acquireLock(struct lock* l) {
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp

}
 384:	90                   	nop
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    

00000387 <releaseLock>:

void releaseLock(struct lock* l) {
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp

}
 38a:	90                   	nop
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    

0000038d <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp

}
 390:	90                   	nop
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    

00000393 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 393:	55                   	push   %ebp
 394:	89 e5                	mov    %esp,%ebp

}
 396:	90                   	nop
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    

00000399 <broadcast>:

void broadcast(struct condvar* cv) {
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp

}
 39c:	90                   	nop
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    

0000039f <signal>:

void signal(struct condvar* cv) {
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp

}
 3a2:	90                   	nop
 3a3:	5d                   	pop    %ebp
 3a4:	c3                   	ret    

000003a5 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp

}
 3a8:	90                   	nop
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    

000003ab <semUp>:

void semUp(struct semaphore* s) {
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp

}
 3ae:	90                   	nop
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    

000003b1 <semDown>:

void semDown(struct semaphore* s) {
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp

}
 3b4:	90                   	nop
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    

000003b7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b7:	b8 01 00 00 00       	mov    $0x1,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <exit>:
SYSCALL(exit)
 3bf:	b8 02 00 00 00       	mov    $0x2,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <wait>:
SYSCALL(wait)
 3c7:	b8 03 00 00 00       	mov    $0x3,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <pipe>:
SYSCALL(pipe)
 3cf:	b8 04 00 00 00       	mov    $0x4,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <read>:
SYSCALL(read)
 3d7:	b8 05 00 00 00       	mov    $0x5,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <write>:
SYSCALL(write)
 3df:	b8 10 00 00 00       	mov    $0x10,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <close>:
SYSCALL(close)
 3e7:	b8 15 00 00 00       	mov    $0x15,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <kill>:
SYSCALL(kill)
 3ef:	b8 06 00 00 00       	mov    $0x6,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <exec>:
SYSCALL(exec)
 3f7:	b8 07 00 00 00       	mov    $0x7,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <open>:
SYSCALL(open)
 3ff:	b8 0f 00 00 00       	mov    $0xf,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <mknod>:
SYSCALL(mknod)
 407:	b8 11 00 00 00       	mov    $0x11,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <unlink>:
SYSCALL(unlink)
 40f:	b8 12 00 00 00       	mov    $0x12,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <fstat>:
SYSCALL(fstat)
 417:	b8 08 00 00 00       	mov    $0x8,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <link>:
SYSCALL(link)
 41f:	b8 13 00 00 00       	mov    $0x13,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <mkdir>:
SYSCALL(mkdir)
 427:	b8 14 00 00 00       	mov    $0x14,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <chdir>:
SYSCALL(chdir)
 42f:	b8 09 00 00 00       	mov    $0x9,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <dup>:
SYSCALL(dup)
 437:	b8 0a 00 00 00       	mov    $0xa,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <getpid>:
SYSCALL(getpid)
 43f:	b8 0b 00 00 00       	mov    $0xb,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <sbrk>:
SYSCALL(sbrk)
 447:	b8 0c 00 00 00       	mov    $0xc,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <sleep>:
SYSCALL(sleep)
 44f:	b8 0d 00 00 00       	mov    $0xd,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <uptime>:
SYSCALL(uptime)
 457:	b8 0e 00 00 00       	mov    $0xe,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <thread_create>:
SYSCALL(thread_create)
 45f:	b8 16 00 00 00       	mov    $0x16,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <thread_exit>:
SYSCALL(thread_exit)
 467:	b8 17 00 00 00       	mov    $0x17,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <thread_join>:
SYSCALL(thread_join)
 46f:	b8 18 00 00 00       	mov    $0x18,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <waitpid>:
SYSCALL(waitpid)
 477:	b8 1e 00 00 00       	mov    $0x1e,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <barrier_init>:
SYSCALL(barrier_init)
 47f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <barrier_check>:
SYSCALL(barrier_check)
 487:	b8 20 00 00 00       	mov    $0x20,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <sleepChan>:
SYSCALL(sleepChan)
 48f:	b8 24 00 00 00       	mov    $0x24,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <getChannel>:
SYSCALL(getChannel)
 497:	b8 25 00 00 00       	mov    $0x25,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <sigChan>:
SYSCALL(sigChan)
 49f:	b8 26 00 00 00       	mov    $0x26,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <sigOneChan>:
 4a7:	b8 27 00 00 00       	mov    $0x27,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4af:	55                   	push   %ebp
 4b0:	89 e5                	mov    %esp,%ebp
 4b2:	83 ec 18             	sub    $0x18,%esp
 4b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4bb:	83 ec 04             	sub    $0x4,%esp
 4be:	6a 01                	push   $0x1
 4c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c3:	50                   	push   %eax
 4c4:	ff 75 08             	push   0x8(%ebp)
 4c7:	e8 13 ff ff ff       	call   3df <write>
 4cc:	83 c4 10             	add    $0x10,%esp
}
 4cf:	90                   	nop
 4d0:	c9                   	leave  
 4d1:	c3                   	ret    

000004d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e3:	74 17                	je     4fc <printint+0x2a>
 4e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e9:	79 11                	jns    4fc <printint+0x2a>
    neg = 1;
 4eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	f7 d8                	neg    %eax
 4f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fa:	eb 06                	jmp    502 <printint+0x30>
  } else {
    x = xx;
 4fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 509:	8b 4d 10             	mov    0x10(%ebp),%ecx
 50c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50f:	ba 00 00 00 00       	mov    $0x0,%edx
 514:	f7 f1                	div    %ecx
 516:	89 d1                	mov    %edx,%ecx
 518:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 521:	0f b6 91 40 0d 00 00 	movzbl 0xd40(%ecx),%edx
 528:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 52c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 532:	ba 00 00 00 00       	mov    $0x0,%edx
 537:	f7 f1                	div    %ecx
 539:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 540:	75 c7                	jne    509 <printint+0x37>
  if(neg)
 542:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 546:	74 2d                	je     575 <printint+0xa3>
    buf[i++] = '-';
 548:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54b:	8d 50 01             	lea    0x1(%eax),%edx
 54e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 551:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 556:	eb 1d                	jmp    575 <printint+0xa3>
    putc(fd, buf[i]);
 558:	8d 55 dc             	lea    -0x24(%ebp),%edx
 55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55e:	01 d0                	add    %edx,%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	83 ec 08             	sub    $0x8,%esp
 569:	50                   	push   %eax
 56a:	ff 75 08             	push   0x8(%ebp)
 56d:	e8 3d ff ff ff       	call   4af <putc>
 572:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 575:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57d:	79 d9                	jns    558 <printint+0x86>
}
 57f:	90                   	nop
 580:	c9                   	leave  
 581:	c3                   	ret    

00000582 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58f:	8d 45 0c             	lea    0xc(%ebp),%eax
 592:	83 c0 04             	add    $0x4,%eax
 595:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59f:	e9 59 01 00 00       	jmp    6fd <printf+0x17b>
    c = fmt[i] & 0xff;
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	25 ff 00 00 00       	and    $0xff,%eax
 5b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5be:	75 2c                	jne    5ec <printf+0x6a>
      if(c == '%'){
 5c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c4:	75 0c                	jne    5d2 <printf+0x50>
        state = '%';
 5c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cd:	e9 27 01 00 00       	jmp    6f9 <printf+0x177>
      } else {
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	push   0x8(%ebp)
 5df:	e8 cb fe ff ff       	call   4af <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	e9 0d 01 00 00       	jmp    6f9 <printf+0x177>
      }
    } else if(state == '%'){
 5ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f0:	0f 85 03 01 00 00    	jne    6f9 <printf+0x177>
      if(c == 'd'){
 5f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fa:	75 1e                	jne    61a <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	6a 01                	push   $0x1
 603:	6a 0a                	push   $0xa
 605:	50                   	push   %eax
 606:	ff 75 08             	push   0x8(%ebp)
 609:	e8 c4 fe ff ff       	call   4d2 <printint>
 60e:	83 c4 10             	add    $0x10,%esp
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 615:	e9 d8 00 00 00       	jmp    6f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 61a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61e:	74 06                	je     626 <printf+0xa4>
 620:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 624:	75 1e                	jne    644 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	6a 00                	push   $0x0
 62d:	6a 10                	push   $0x10
 62f:	50                   	push   %eax
 630:	ff 75 08             	push   0x8(%ebp)
 633:	e8 9a fe ff ff       	call   4d2 <printint>
 638:	83 c4 10             	add    $0x10,%esp
        ap++;
 63b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63f:	e9 ae 00 00 00       	jmp    6f2 <printf+0x170>
      } else if(c == 's'){
 644:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 648:	75 43                	jne    68d <printf+0x10b>
        s = (char*)*ap;
 64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65a:	75 25                	jne    681 <printf+0xff>
          s = "(null)";
 65c:	c7 45 f4 93 09 00 00 	movl   $0x993,-0xc(%ebp)
        while(*s != 0){
 663:	eb 1c                	jmp    681 <printf+0xff>
          putc(fd, *s);
 665:	8b 45 f4             	mov    -0xc(%ebp),%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	50                   	push   %eax
 672:	ff 75 08             	push   0x8(%ebp)
 675:	e8 35 fe ff ff       	call   4af <putc>
 67a:	83 c4 10             	add    $0x10,%esp
          s++;
 67d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	0f b6 00             	movzbl (%eax),%eax
 687:	84 c0                	test   %al,%al
 689:	75 da                	jne    665 <printf+0xe3>
 68b:	eb 65                	jmp    6f2 <printf+0x170>
        }
      } else if(c == 'c'){
 68d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 691:	75 1d                	jne    6b0 <printf+0x12e>
        putc(fd, *ap);
 693:	8b 45 e8             	mov    -0x18(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	push   0x8(%ebp)
 6a2:	e8 08 fe ff ff       	call   4af <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ae:	eb 42                	jmp    6f2 <printf+0x170>
      } else if(c == '%'){
 6b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b4:	75 17                	jne    6cd <printf+0x14b>
        putc(fd, c);
 6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	83 ec 08             	sub    $0x8,%esp
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	push   0x8(%ebp)
 6c3:	e8 e7 fd ff ff       	call   4af <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	eb 25                	jmp    6f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	6a 25                	push   $0x25
 6d2:	ff 75 08             	push   0x8(%ebp)
 6d5:	e8 d5 fd ff ff       	call   4af <putc>
 6da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e0:	0f be c0             	movsbl %al,%eax
 6e3:	83 ec 08             	sub    $0x8,%esp
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	push   0x8(%ebp)
 6ea:	e8 c0 fd ff ff       	call   4af <putc>
 6ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	0f b6 00             	movzbl (%eax),%eax
 708:	84 c0                	test   %al,%al
 70a:	0f 85 94 fe ff ff    	jne    5a4 <printf+0x22>
    }
  }
}
 710:	90                   	nop
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	83 e8 08             	sub    $0x8,%eax
 71f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 727:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72a:	eb 24                	jmp    750 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 734:	72 12                	jb     748 <free+0x35>
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73c:	77 24                	ja     762 <free+0x4f>
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 746:	72 1a                	jb     762 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 756:	76 d4                	jbe    72c <free+0x19>
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 760:	73 ca                	jae    72c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	01 c2                	add    %eax,%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	39 c2                	cmp    %eax,%edx
 77b:	75 24                	jne    7a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 780:	8b 50 04             	mov    0x4(%eax),%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 0a                	jmp    7ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	01 d0                	add    %edx,%eax
 7bd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7c0:	75 20                	jne    7e2 <free+0xcf>
    p->s.size += bp->s.size;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	01 c2                	add    %eax,%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 08                	jmp    7ea <free+0xd7>
  } else
    p->s.ptr = bp;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	a3 5c 0d 00 00       	mov    %eax,0xd5c
}
 7f2:	90                   	nop
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <morecore>:

static Header*
morecore(uint nu)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 802:	77 07                	ja     80b <morecore+0x16>
    nu = 4096;
 804:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	83 ec 0c             	sub    $0xc,%esp
 814:	50                   	push   %eax
 815:	e8 2d fc ff ff       	call   447 <sbrk>
 81a:	83 c4 10             	add    $0x10,%esp
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 820:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 824:	75 07                	jne    82d <morecore+0x38>
    return 0;
 826:	b8 00 00 00 00       	mov    $0x0,%eax
 82b:	eb 26                	jmp    853 <morecore+0x5e>
  hp = (Header*)p;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	8b 55 08             	mov    0x8(%ebp),%edx
 839:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	83 c0 08             	add    $0x8,%eax
 842:	83 ec 0c             	sub    $0xc,%esp
 845:	50                   	push   %eax
 846:	e8 c8 fe ff ff       	call   713 <free>
 84b:	83 c4 10             	add    $0x10,%esp
  return freep;
 84e:	a1 5c 0d 00 00       	mov    0xd5c,%eax
}
 853:	c9                   	leave  
 854:	c3                   	ret    

00000855 <malloc>:

void*
malloc(uint nbytes)
{
 855:	55                   	push   %ebp
 856:	89 e5                	mov    %esp,%ebp
 858:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85b:	8b 45 08             	mov    0x8(%ebp),%eax
 85e:	83 c0 07             	add    $0x7,%eax
 861:	c1 e8 03             	shr    $0x3,%eax
 864:	83 c0 01             	add    $0x1,%eax
 867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86a:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 86f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 876:	75 23                	jne    89b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 878:	c7 45 f0 54 0d 00 00 	movl   $0xd54,-0x10(%ebp)
 87f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 882:	a3 5c 0d 00 00       	mov    %eax,0xd5c
 887:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 88c:	a3 54 0d 00 00       	mov    %eax,0xd54
    base.s.size = 0;
 891:	c7 05 58 0d 00 00 00 	movl   $0x0,0xd58
 898:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	8b 00                	mov    (%eax),%eax
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 40 04             	mov    0x4(%eax),%eax
 8a9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8ac:	77 4d                	ja     8fb <malloc+0xa6>
      if(p->s.size == nunits)
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8b7:	75 0c                	jne    8c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 10                	mov    (%eax),%edx
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	89 10                	mov    %edx,(%eax)
 8c3:	eb 26                	jmp    8eb <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	8b 40 04             	mov    0x4(%eax),%eax
 8cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ce:	89 c2                	mov    %eax,%edx
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	c1 e0 03             	shl    $0x3,%eax
 8df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	a3 5c 0d 00 00       	mov    %eax,0xd5c
      return (void*)(p + 1);
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	83 c0 08             	add    $0x8,%eax
 8f9:	eb 3b                	jmp    936 <malloc+0xe1>
    }
    if(p == freep)
 8fb:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 900:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 903:	75 1e                	jne    923 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 905:	83 ec 0c             	sub    $0xc,%esp
 908:	ff 75 ec             	push   -0x14(%ebp)
 90b:	e8 e5 fe ff ff       	call   7f5 <morecore>
 910:	83 c4 10             	add    $0x10,%esp
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
 916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91a:	75 07                	jne    923 <malloc+0xce>
        return 0;
 91c:	b8 00 00 00 00       	mov    $0x0,%eax
 921:	eb 13                	jmp    936 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	89 45 f0             	mov    %eax,-0x10(%ebp)
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 931:	e9 6d ff ff ff       	jmp    8a3 <malloc+0x4e>
  }
}
 936:	c9                   	leave  
 937:	c3                   	ret    
