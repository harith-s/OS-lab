
_t_l_cv1:     file format elf32-i386


Disassembly of section .text:

00000000 <thread2>:
    int* x;
    struct lock *l;
    struct condvar* cv;
};

void* thread2(void* arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    // printf(1, "Thread 2 created %d\n", *(int*)arg);
    struct all* t = (struct all*) arg;
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1,"Gonna acquire lock\n");
   c:	83 ec 08             	sub    $0x8,%esp
   f:	68 70 09 00 00       	push   $0x970
  14:	6a 01                	push   $0x1
  16:	e8 9f 05 00 00       	call   5ba <printf>
  1b:	83 c4 10             	add    $0x10,%esp
    acquireLock(t->l);
  1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  21:	8b 40 04             	mov    0x4(%eax),%eax
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	50                   	push   %eax
  28:	e8 8c 03 00 00       	call   3b9 <acquireLock>
  2d:	83 c4 10             	add    $0x10,%esp
    printf(1,"Acquired lock successfully\n");
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 84 09 00 00       	push   $0x984
  38:	6a 01                	push   $0x1
  3a:	e8 7b 05 00 00       	call   5ba <printf>
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
    broadcast(t->cv);
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	8b 40 08             	mov    0x8(%eax),%eax
  5d:	83 ec 0c             	sub    $0xc,%esp
  60:	50                   	push   %eax
  61:	e8 6b 03 00 00       	call   3d1 <broadcast>
  66:	83 c4 10             	add    $0x10,%esp
    releaseLock(t->l);
  69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6c:	8b 40 04             	mov    0x4(%eax),%eax
  6f:	83 ec 0c             	sub    $0xc,%esp
  72:	50                   	push   %eax
  73:	e8 47 03 00 00       	call   3bf <releaseLock>
  78:	83 c4 10             	add    $0x10,%esp
    thread_exit();
  7b:	e8 1f 04 00 00       	call   49f <thread_exit>
    return 0;
  80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  85:	c9                   	leave  
  86:	c3                   	ret    

00000087 <main>:

int main(){
  87:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  8b:	83 e4 f0             	and    $0xfffffff0,%esp
  8e:	ff 71 fc             	push   -0x4(%ecx)
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	51                   	push   %ecx
  95:	83 ec 34             	sub    $0x34,%esp
    struct lock l;
    struct condvar cv;
    printf(1, "Hello World\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 a0 09 00 00       	push   $0x9a0
  a0:	6a 01                	push   $0x1
  a2:	e8 13 05 00 00       	call   5ba <printf>
  a7:	83 c4 10             	add    $0x10,%esp
    int x = 10;
  aa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
    struct all a;
    a.x = &x;
  b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    a.l = &l;
  b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
    a.cv = &cv;
  bd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint tid1;
    initiateLock(&l);
  c3:	83 ec 0c             	sub    $0xc,%esp
  c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  c9:	50                   	push   %eax
  ca:	e8 e4 02 00 00       	call   3b3 <initiateLock>
  cf:	83 c4 10             	add    $0x10,%esp
    initiateCondVar(&cv);
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  d8:	50                   	push   %eax
  d9:	e8 e7 02 00 00       	call   3c5 <initiateCondVar>
  de:	83 c4 10             	add    $0x10,%esp
    acquireLock(&l);
  e1:	83 ec 0c             	sub    $0xc,%esp
  e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  e7:	50                   	push   %eax
  e8:	e8 cc 02 00 00       	call   3b9 <acquireLock>
  ed:	83 c4 10             	add    $0x10,%esp
    thread_create(&tid1,thread2,(void*)&a);
  f0:	83 ec 04             	sub    $0x4,%esp
  f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  f6:	50                   	push   %eax
  f7:	68 00 00 00 00       	push   $0x0
  fc:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  ff:	50                   	push   %eax
 100:	e8 92 03 00 00       	call   497 <thread_create>
 105:	83 c4 10             	add    $0x10,%esp
    sleep(200);
 108:	83 ec 0c             	sub    $0xc,%esp
 10b:	68 c8 00 00 00       	push   $0xc8
 110:	e8 72 03 00 00       	call   487 <sleep>
 115:	83 c4 10             	add    $0x10,%esp
    condWait(&cv,&l);
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	8d 45 f0             	lea    -0x10(%ebp),%eax
 11e:	50                   	push   %eax
 11f:	8d 45 e8             	lea    -0x18(%ebp),%eax
 122:	50                   	push   %eax
 123:	e8 a3 02 00 00       	call   3cb <condWait>
 128:	83 c4 10             	add    $0x10,%esp
    releaseLock(&l);
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	8d 45 f0             	lea    -0x10(%ebp),%eax
 131:	50                   	push   %eax
 132:	e8 88 02 00 00       	call   3bf <releaseLock>
 137:	83 c4 10             	add    $0x10,%esp
    thread_join(tid1);
 13a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 13d:	83 ec 0c             	sub    $0xc,%esp
 140:	50                   	push   %eax
 141:	e8 61 03 00 00       	call   4a7 <thread_join>
 146:	83 c4 10             	add    $0x10,%esp
    printf(1,"Value of x = %d\n",x);
 149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	50                   	push   %eax
 150:	68 ad 09 00 00       	push   $0x9ad
 155:	6a 01                	push   $0x1
 157:	e8 5e 04 00 00       	call   5ba <printf>
 15c:	83 c4 10             	add    $0x10,%esp
    exit();
 15f:	e8 93 02 00 00       	call   3f7 <exit>

00000164 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	57                   	push   %edi
 168:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 169:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16c:	8b 55 10             	mov    0x10(%ebp),%edx
 16f:	8b 45 0c             	mov    0xc(%ebp),%eax
 172:	89 cb                	mov    %ecx,%ebx
 174:	89 df                	mov    %ebx,%edi
 176:	89 d1                	mov    %edx,%ecx
 178:	fc                   	cld    
 179:	f3 aa                	rep stos %al,%es:(%edi)
 17b:	89 ca                	mov    %ecx,%edx
 17d:	89 fb                	mov    %edi,%ebx
 17f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 182:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 185:	90                   	nop
 186:	5b                   	pop    %ebx
 187:	5f                   	pop    %edi
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    

0000018a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 196:	90                   	nop
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
 19a:	8d 42 01             	lea    0x1(%edx),%eax
 19d:	89 45 0c             	mov    %eax,0xc(%ebp)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	8d 48 01             	lea    0x1(%eax),%ecx
 1a6:	89 4d 08             	mov    %ecx,0x8(%ebp)
 1a9:	0f b6 12             	movzbl (%edx),%edx
 1ac:	88 10                	mov    %dl,(%eax)
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 e2                	jne    197 <strcpy+0xd>
    ;
  return os;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1bd:	eb 08                	jmp    1c7 <strcmp+0xd>
    p++, q++;
 1bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	74 10                	je     1e1 <strcmp+0x27>
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	0f b6 10             	movzbl (%eax),%edx
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	0f b6 00             	movzbl (%eax),%eax
 1dd:	38 c2                	cmp    %al,%dl
 1df:	74 de                	je     1bf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	0f b6 d0             	movzbl %al,%edx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	0f b6 c0             	movzbl %al,%eax
 1f3:	29 c2                	sub    %eax,%edx
 1f5:	89 d0                	mov    %edx,%eax
}
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strlen>:

uint
strlen(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 206:	eb 04                	jmp    20c <strlen+0x13>
 208:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 20c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	01 d0                	add    %edx,%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 ed                	jne    208 <strlen+0xf>
    ;
  return n;
 21b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 223:	8b 45 10             	mov    0x10(%ebp),%eax
 226:	50                   	push   %eax
 227:	ff 75 0c             	push   0xc(%ebp)
 22a:	ff 75 08             	push   0x8(%ebp)
 22d:	e8 32 ff ff ff       	call   164 <stosb>
 232:	83 c4 0c             	add    $0xc,%esp
  return dst;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <strchr>:

char*
strchr(const char *s, char c)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 04             	sub    $0x4,%esp
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 246:	eb 14                	jmp    25c <strchr+0x22>
    if(*s == c)
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 251:	75 05                	jne    258 <strchr+0x1e>
      return (char*)s;
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	eb 13                	jmp    26b <strchr+0x31>
  for(; *s; s++)
 258:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	84 c0                	test   %al,%al
 264:	75 e2                	jne    248 <strchr+0xe>
  return 0;
 266:	b8 00 00 00 00       	mov    $0x0,%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <gets>:

char*
gets(char *buf, int max)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 273:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 27a:	eb 42                	jmp    2be <gets+0x51>
    cc = read(0, &c, 1);
 27c:	83 ec 04             	sub    $0x4,%esp
 27f:	6a 01                	push   $0x1
 281:	8d 45 ef             	lea    -0x11(%ebp),%eax
 284:	50                   	push   %eax
 285:	6a 00                	push   $0x0
 287:	e8 83 01 00 00       	call   40f <read>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 292:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 296:	7e 33                	jle    2cb <gets+0x5e>
      break;
    buf[i++] = c;
 298:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2a1:	89 c2                	mov    %eax,%edx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	01 c2                	add    %eax,%edx
 2a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ac:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b2:	3c 0a                	cmp    $0xa,%al
 2b4:	74 16                	je     2cc <gets+0x5f>
 2b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ba:	3c 0d                	cmp    $0xd,%al
 2bc:	74 0e                	je     2cc <gets+0x5f>
  for(i=0; i+1 < max; ){
 2be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c1:	83 c0 01             	add    $0x1,%eax
 2c4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2c7:	7f b3                	jg     27c <gets+0xf>
 2c9:	eb 01                	jmp    2cc <gets+0x5f>
      break;
 2cb:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	01 d0                	add    %edx,%eax
 2d4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <stat>:

int
stat(const char *n, struct stat *st)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	83 ec 08             	sub    $0x8,%esp
 2e5:	6a 00                	push   $0x0
 2e7:	ff 75 08             	push   0x8(%ebp)
 2ea:	e8 48 01 00 00       	call   437 <open>
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f9:	79 07                	jns    302 <stat+0x26>
    return -1;
 2fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 300:	eb 25                	jmp    327 <stat+0x4b>
  r = fstat(fd, st);
 302:	83 ec 08             	sub    $0x8,%esp
 305:	ff 75 0c             	push   0xc(%ebp)
 308:	ff 75 f4             	push   -0xc(%ebp)
 30b:	e8 3f 01 00 00       	call   44f <fstat>
 310:	83 c4 10             	add    $0x10,%esp
 313:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 316:	83 ec 0c             	sub    $0xc,%esp
 319:	ff 75 f4             	push   -0xc(%ebp)
 31c:	e8 fe 00 00 00       	call   41f <close>
 321:	83 c4 10             	add    $0x10,%esp
  return r;
 324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 327:	c9                   	leave  
 328:	c3                   	ret    

00000329 <atoi>:

int
atoi(const char *s)
{
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
 32c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 32f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 336:	eb 25                	jmp    35d <atoi+0x34>
    n = n*10 + *s++ - '0';
 338:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33b:	89 d0                	mov    %edx,%eax
 33d:	c1 e0 02             	shl    $0x2,%eax
 340:	01 d0                	add    %edx,%eax
 342:	01 c0                	add    %eax,%eax
 344:	89 c1                	mov    %eax,%ecx
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 08             	mov    %edx,0x8(%ebp)
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	0f be c0             	movsbl %al,%eax
 355:	01 c8                	add    %ecx,%eax
 357:	83 e8 30             	sub    $0x30,%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	0f b6 00             	movzbl (%eax),%eax
 363:	3c 2f                	cmp    $0x2f,%al
 365:	7e 0a                	jle    371 <atoi+0x48>
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	3c 39                	cmp    $0x39,%al
 36f:	7e c7                	jle    338 <atoi+0xf>
  return n;
 371:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 374:	c9                   	leave  
 375:	c3                   	ret    

00000376 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 388:	eb 17                	jmp    3a1 <memmove+0x2b>
    *dst++ = *src++;
 38a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38d:	8d 42 01             	lea    0x1(%edx),%eax
 390:	89 45 f8             	mov    %eax,-0x8(%ebp)
 393:	8b 45 fc             	mov    -0x4(%ebp),%eax
 396:	8d 48 01             	lea    0x1(%eax),%ecx
 399:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 39c:	0f b6 12             	movzbl (%edx),%edx
 39f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3a1:	8b 45 10             	mov    0x10(%ebp),%eax
 3a4:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a7:	89 55 10             	mov    %edx,0x10(%ebp)
 3aa:	85 c0                	test   %eax,%eax
 3ac:	7f dc                	jg     38a <memmove+0x14>
  return vdst;
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp

}
 3b6:	90                   	nop
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    

000003b9 <acquireLock>:

void acquireLock(struct lock* l) {
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp

}
 3bc:	90                   	nop
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret    

000003bf <releaseLock>:

void releaseLock(struct lock* l) {
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp

}
 3c2:	90                   	nop
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    

000003c5 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp

}
 3c8:	90                   	nop
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp

}
 3ce:	90                   	nop
 3cf:	5d                   	pop    %ebp
 3d0:	c3                   	ret    

000003d1 <broadcast>:

void broadcast(struct condvar* cv) {
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp

}
 3d4:	90                   	nop
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    

000003d7 <signal>:

void signal(struct condvar* cv) {
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp

}
 3da:	90                   	nop
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    

000003dd <semInit>:

void semInit(struct semaphore* s, int initVal) {
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp

}
 3e0:	90                   	nop
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    

000003e3 <semUp>:

void semUp(struct semaphore* s) {
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp

}
 3e6:	90                   	nop
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    

000003e9 <semDown>:

void semDown(struct semaphore* s) {
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp

}
 3ec:	90                   	nop
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    

000003ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ef:	b8 01 00 00 00       	mov    $0x1,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <exit>:
SYSCALL(exit)
 3f7:	b8 02 00 00 00       	mov    $0x2,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <wait>:
SYSCALL(wait)
 3ff:	b8 03 00 00 00       	mov    $0x3,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <pipe>:
SYSCALL(pipe)
 407:	b8 04 00 00 00       	mov    $0x4,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <read>:
SYSCALL(read)
 40f:	b8 05 00 00 00       	mov    $0x5,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <write>:
SYSCALL(write)
 417:	b8 10 00 00 00       	mov    $0x10,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <close>:
SYSCALL(close)
 41f:	b8 15 00 00 00       	mov    $0x15,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <kill>:
SYSCALL(kill)
 427:	b8 06 00 00 00       	mov    $0x6,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <exec>:
SYSCALL(exec)
 42f:	b8 07 00 00 00       	mov    $0x7,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <open>:
SYSCALL(open)
 437:	b8 0f 00 00 00       	mov    $0xf,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <mknod>:
SYSCALL(mknod)
 43f:	b8 11 00 00 00       	mov    $0x11,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <unlink>:
SYSCALL(unlink)
 447:	b8 12 00 00 00       	mov    $0x12,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <fstat>:
SYSCALL(fstat)
 44f:	b8 08 00 00 00       	mov    $0x8,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <link>:
SYSCALL(link)
 457:	b8 13 00 00 00       	mov    $0x13,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <mkdir>:
SYSCALL(mkdir)
 45f:	b8 14 00 00 00       	mov    $0x14,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <chdir>:
SYSCALL(chdir)
 467:	b8 09 00 00 00       	mov    $0x9,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <dup>:
SYSCALL(dup)
 46f:	b8 0a 00 00 00       	mov    $0xa,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <getpid>:
SYSCALL(getpid)
 477:	b8 0b 00 00 00       	mov    $0xb,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <sbrk>:
SYSCALL(sbrk)
 47f:	b8 0c 00 00 00       	mov    $0xc,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <sleep>:
SYSCALL(sleep)
 487:	b8 0d 00 00 00       	mov    $0xd,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <uptime>:
SYSCALL(uptime)
 48f:	b8 0e 00 00 00       	mov    $0xe,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <thread_create>:
SYSCALL(thread_create)
 497:	b8 16 00 00 00       	mov    $0x16,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <thread_exit>:
SYSCALL(thread_exit)
 49f:	b8 17 00 00 00       	mov    $0x17,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <thread_join>:
SYSCALL(thread_join)
 4a7:	b8 18 00 00 00       	mov    $0x18,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <waitpid>:
SYSCALL(waitpid)
 4af:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <barrier_init>:
SYSCALL(barrier_init)
 4b7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <barrier_check>:
SYSCALL(barrier_check)
 4bf:	b8 20 00 00 00       	mov    $0x20,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <sleepChan>:
SYSCALL(sleepChan)
 4c7:	b8 24 00 00 00       	mov    $0x24,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <getChannel>:
SYSCALL(getChannel)
 4cf:	b8 25 00 00 00       	mov    $0x25,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <sigChan>:
SYSCALL(sigChan)
 4d7:	b8 26 00 00 00       	mov    $0x26,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <sigOneChan>:
 4df:	b8 27 00 00 00       	mov    $0x27,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	83 ec 18             	sub    $0x18,%esp
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f3:	83 ec 04             	sub    $0x4,%esp
 4f6:	6a 01                	push   $0x1
 4f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fb:	50                   	push   %eax
 4fc:	ff 75 08             	push   0x8(%ebp)
 4ff:	e8 13 ff ff ff       	call   417 <write>
 504:	83 c4 10             	add    $0x10,%esp
}
 507:	90                   	nop
 508:	c9                   	leave  
 509:	c3                   	ret    

0000050a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50a:	55                   	push   %ebp
 50b:	89 e5                	mov    %esp,%ebp
 50d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 517:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51b:	74 17                	je     534 <printint+0x2a>
 51d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 521:	79 11                	jns    534 <printint+0x2a>
    neg = 1;
 523:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	f7 d8                	neg    %eax
 52f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 532:	eb 06                	jmp    53a <printint+0x30>
  } else {
    x = xx;
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 541:	8b 4d 10             	mov    0x10(%ebp),%ecx
 544:	8b 45 ec             	mov    -0x14(%ebp),%eax
 547:	ba 00 00 00 00       	mov    $0x0,%edx
 54c:	f7 f1                	div    %ecx
 54e:	89 d1                	mov    %edx,%ecx
 550:	8b 45 f4             	mov    -0xc(%ebp),%eax
 553:	8d 50 01             	lea    0x1(%eax),%edx
 556:	89 55 f4             	mov    %edx,-0xc(%ebp)
 559:	0f b6 91 6c 0d 00 00 	movzbl 0xd6c(%ecx),%edx
 560:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 564:	8b 4d 10             	mov    0x10(%ebp),%ecx
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 f1                	div    %ecx
 571:	89 45 ec             	mov    %eax,-0x14(%ebp)
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 c7                	jne    541 <printint+0x37>
  if(neg)
 57a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57e:	74 2d                	je     5ad <printint+0xa3>
    buf[i++] = '-';
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	8d 50 01             	lea    0x1(%eax),%edx
 586:	89 55 f4             	mov    %edx,-0xc(%ebp)
 589:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 58e:	eb 1d                	jmp    5ad <printint+0xa3>
    putc(fd, buf[i]);
 590:	8d 55 dc             	lea    -0x24(%ebp),%edx
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	0f b6 00             	movzbl (%eax),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	push   0x8(%ebp)
 5a5:	e8 3d ff ff ff       	call   4e7 <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b5:	79 d9                	jns    590 <printint+0x86>
}
 5b7:	90                   	nop
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c7:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ca:	83 c0 04             	add    $0x4,%eax
 5cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d7:	e9 59 01 00 00       	jmp    735 <printf+0x17b>
    c = fmt[i] & 0xff;
 5dc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e2:	01 d0                	add    %edx,%eax
 5e4:	0f b6 00             	movzbl (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	25 ff 00 00 00       	and    $0xff,%eax
 5ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f6:	75 2c                	jne    624 <printf+0x6a>
      if(c == '%'){
 5f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fc:	75 0c                	jne    60a <printf+0x50>
        state = '%';
 5fe:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 605:	e9 27 01 00 00       	jmp    731 <printf+0x177>
      } else {
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 ec 08             	sub    $0x8,%esp
 613:	50                   	push   %eax
 614:	ff 75 08             	push   0x8(%ebp)
 617:	e8 cb fe ff ff       	call   4e7 <putc>
 61c:	83 c4 10             	add    $0x10,%esp
 61f:	e9 0d 01 00 00       	jmp    731 <printf+0x177>
      }
    } else if(state == '%'){
 624:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 628:	0f 85 03 01 00 00    	jne    731 <printf+0x177>
      if(c == 'd'){
 62e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 632:	75 1e                	jne    652 <printf+0x98>
        printint(fd, *ap, 10, 1);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	6a 01                	push   $0x1
 63b:	6a 0a                	push   $0xa
 63d:	50                   	push   %eax
 63e:	ff 75 08             	push   0x8(%ebp)
 641:	e8 c4 fe ff ff       	call   50a <printint>
 646:	83 c4 10             	add    $0x10,%esp
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64d:	e9 d8 00 00 00       	jmp    72a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 652:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 656:	74 06                	je     65e <printf+0xa4>
 658:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65c:	75 1e                	jne    67c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 65e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	6a 00                	push   $0x0
 665:	6a 10                	push   $0x10
 667:	50                   	push   %eax
 668:	ff 75 08             	push   0x8(%ebp)
 66b:	e8 9a fe ff ff       	call   50a <printint>
 670:	83 c4 10             	add    $0x10,%esp
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 677:	e9 ae 00 00 00       	jmp    72a <printf+0x170>
      } else if(c == 's'){
 67c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 680:	75 43                	jne    6c5 <printf+0x10b>
        s = (char*)*ap;
 682:	8b 45 e8             	mov    -0x18(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 692:	75 25                	jne    6b9 <printf+0xff>
          s = "(null)";
 694:	c7 45 f4 be 09 00 00 	movl   $0x9be,-0xc(%ebp)
        while(*s != 0){
 69b:	eb 1c                	jmp    6b9 <printf+0xff>
          putc(fd, *s);
 69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a0:	0f b6 00             	movzbl (%eax),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	83 ec 08             	sub    $0x8,%esp
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	push   0x8(%ebp)
 6ad:	e8 35 fe ff ff       	call   4e7 <putc>
 6b2:	83 c4 10             	add    $0x10,%esp
          s++;
 6b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bc:	0f b6 00             	movzbl (%eax),%eax
 6bf:	84 c0                	test   %al,%al
 6c1:	75 da                	jne    69d <printf+0xe3>
 6c3:	eb 65                	jmp    72a <printf+0x170>
        }
      } else if(c == 'c'){
 6c5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c9:	75 1d                	jne    6e8 <printf+0x12e>
        putc(fd, *ap);
 6cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	0f be c0             	movsbl %al,%eax
 6d3:	83 ec 08             	sub    $0x8,%esp
 6d6:	50                   	push   %eax
 6d7:	ff 75 08             	push   0x8(%ebp)
 6da:	e8 08 fe ff ff       	call   4e7 <putc>
 6df:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e6:	eb 42                	jmp    72a <printf+0x170>
      } else if(c == '%'){
 6e8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ec:	75 17                	jne    705 <printf+0x14b>
        putc(fd, c);
 6ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	83 ec 08             	sub    $0x8,%esp
 6f7:	50                   	push   %eax
 6f8:	ff 75 08             	push   0x8(%ebp)
 6fb:	e8 e7 fd ff ff       	call   4e7 <putc>
 700:	83 c4 10             	add    $0x10,%esp
 703:	eb 25                	jmp    72a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 705:	83 ec 08             	sub    $0x8,%esp
 708:	6a 25                	push   $0x25
 70a:	ff 75 08             	push   0x8(%ebp)
 70d:	e8 d5 fd ff ff       	call   4e7 <putc>
 712:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 718:	0f be c0             	movsbl %al,%eax
 71b:	83 ec 08             	sub    $0x8,%esp
 71e:	50                   	push   %eax
 71f:	ff 75 08             	push   0x8(%ebp)
 722:	e8 c0 fd ff ff       	call   4e7 <putc>
 727:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 72a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 731:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 735:	8b 55 0c             	mov    0xc(%ebp),%edx
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	01 d0                	add    %edx,%eax
 73d:	0f b6 00             	movzbl (%eax),%eax
 740:	84 c0                	test   %al,%al
 742:	0f 85 94 fe ff ff    	jne    5dc <printf+0x22>
    }
  }
}
 748:	90                   	nop
 749:	c9                   	leave  
 74a:	c3                   	ret    

0000074b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74b:	55                   	push   %ebp
 74c:	89 e5                	mov    %esp,%ebp
 74e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	83 e8 08             	sub    $0x8,%eax
 757:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	a1 88 0d 00 00       	mov    0xd88,%eax
 75f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 762:	eb 24                	jmp    788 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 76c:	72 12                	jb     780 <free+0x35>
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 774:	77 24                	ja     79a <free+0x4f>
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 77e:	72 1a                	jb     79a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	89 45 fc             	mov    %eax,-0x4(%ebp)
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78e:	76 d4                	jbe    764 <free+0x19>
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 798:	73 ca                	jae    764 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	01 c2                	add    %eax,%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	39 c2                	cmp    %eax,%edx
 7b3:	75 24                	jne    7d9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	8b 50 04             	mov    0x4(%eax),%edx
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	01 c2                	add    %eax,%edx
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	8b 10                	mov    (%eax),%edx
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	89 10                	mov    %edx,(%eax)
 7d7:	eb 0a                	jmp    7e3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 40 04             	mov    0x4(%eax),%eax
 7e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	01 d0                	add    %edx,%eax
 7f5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7f8:	75 20                	jne    81a <free+0xcf>
    p->s.size += bp->s.size;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	01 c2                	add    %eax,%edx
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 80e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 811:	8b 10                	mov    (%eax),%edx
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	89 10                	mov    %edx,(%eax)
 818:	eb 08                	jmp    822 <free+0xd7>
  } else
    p->s.ptr = bp;
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 820:	89 10                	mov    %edx,(%eax)
  freep = p;
 822:	8b 45 fc             	mov    -0x4(%ebp),%eax
 825:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 82a:	90                   	nop
 82b:	c9                   	leave  
 82c:	c3                   	ret    

0000082d <morecore>:

static Header*
morecore(uint nu)
{
 82d:	55                   	push   %ebp
 82e:	89 e5                	mov    %esp,%ebp
 830:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 833:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83a:	77 07                	ja     843 <morecore+0x16>
    nu = 4096;
 83c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	c1 e0 03             	shl    $0x3,%eax
 849:	83 ec 0c             	sub    $0xc,%esp
 84c:	50                   	push   %eax
 84d:	e8 2d fc ff ff       	call   47f <sbrk>
 852:	83 c4 10             	add    $0x10,%esp
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85c:	75 07                	jne    865 <morecore+0x38>
    return 0;
 85e:	b8 00 00 00 00       	mov    $0x0,%eax
 863:	eb 26                	jmp    88b <morecore+0x5e>
  hp = (Header*)p;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86e:	8b 55 08             	mov    0x8(%ebp),%edx
 871:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	83 c0 08             	add    $0x8,%eax
 87a:	83 ec 0c             	sub    $0xc,%esp
 87d:	50                   	push   %eax
 87e:	e8 c8 fe ff ff       	call   74b <free>
 883:	83 c4 10             	add    $0x10,%esp
  return freep;
 886:	a1 88 0d 00 00       	mov    0xd88,%eax
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <malloc>:

void*
malloc(uint nbytes)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	83 c0 07             	add    $0x7,%eax
 899:	c1 e8 03             	shr    $0x3,%eax
 89c:	83 c0 01             	add    $0x1,%eax
 89f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a2:	a1 88 0d 00 00       	mov    0xd88,%eax
 8a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ae:	75 23                	jne    8d3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b0:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	a3 88 0d 00 00       	mov    %eax,0xd88
 8bf:	a1 88 0d 00 00       	mov    0xd88,%eax
 8c4:	a3 80 0d 00 00       	mov    %eax,0xd80
    base.s.size = 0;
 8c9:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 8d0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	8b 40 04             	mov    0x4(%eax),%eax
 8e1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8e4:	77 4d                	ja     933 <malloc+0xa6>
      if(p->s.size == nunits)
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8ef:	75 0c                	jne    8fd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 10                	mov    (%eax),%edx
 8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f9:	89 10                	mov    %edx,(%eax)
 8fb:	eb 26                	jmp    923 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	2b 45 ec             	sub    -0x14(%ebp),%eax
 906:	89 c2                	mov    %eax,%edx
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	c1 e0 03             	shl    $0x3,%eax
 917:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 920:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 923:	8b 45 f0             	mov    -0x10(%ebp),%eax
 926:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	83 c0 08             	add    $0x8,%eax
 931:	eb 3b                	jmp    96e <malloc+0xe1>
    }
    if(p == freep)
 933:	a1 88 0d 00 00       	mov    0xd88,%eax
 938:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93b:	75 1e                	jne    95b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 93d:	83 ec 0c             	sub    $0xc,%esp
 940:	ff 75 ec             	push   -0x14(%ebp)
 943:	e8 e5 fe ff ff       	call   82d <morecore>
 948:	83 c4 10             	add    $0x10,%esp
 94b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 952:	75 07                	jne    95b <malloc+0xce>
        return 0;
 954:	b8 00 00 00 00       	mov    $0x0,%eax
 959:	eb 13                	jmp    96e <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 969:	e9 6d ff ff ff       	jmp    8db <malloc+0x4e>
  }
}
 96e:	c9                   	leave  
 96f:	c3                   	ret    
