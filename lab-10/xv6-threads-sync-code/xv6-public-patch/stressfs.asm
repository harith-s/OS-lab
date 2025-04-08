
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 5e 09 00 00       	push   $0x95e
  30:	6a 01                	push   $0x1
  32:	e8 71 05 00 00       	call   5a8 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 7c 03 00 00       	call   3dd <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	push   -0xc(%ebp)
  78:	68 71 09 00 00       	push   $0x971
  7d:	6a 01                	push   $0x1
  7f:	e8 24 05 00 00       	call   5a8 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 7f 03 00 00       	call   425 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	push   -0x10(%ebp)
  c7:	e8 39 03 00 00       	call   405 <write>
  cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	push   -0x10(%ebp)
  df:	e8 29 03 00 00       	call   40d <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 7b 09 00 00       	push   $0x97b
  ef:	6a 01                	push   $0x1
  f1:	e8 b2 04 00 00       	call   5a8 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 1e 03 00 00       	call   425 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	push   -0x10(%ebp)
 128:	e8 d0 02 00 00       	call   3fd <read>
 12d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	push   -0x10(%ebp)
 140:	e8 c8 02 00 00       	call   40d <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 a0 02 00 00       	call   3ed <wait>

  exit();
 14d:	e8 93 02 00 00       	call   3e5 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 55 0c             	mov    0xc(%ebp),%edx
 188:	8d 42 01             	lea    0x1(%edx),%eax
 18b:	89 45 0c             	mov    %eax,0xc(%ebp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	8d 48 01             	lea    0x1(%eax),%ecx
 194:	89 4d 08             	mov    %ecx,0x8(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(const char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 08             	push   0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 83 01 00 00       	call   3fd <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2b5:	7f b3                	jg     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
      break;
 2b9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(const char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	push   0x8(%ebp)
 2d8:	e8 48 01 00 00       	call   425 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	push   0xc(%ebp)
 2f6:	ff 75 f4             	push   -0xc(%ebp)
 2f9:	e8 3f 01 00 00       	call   43d <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	push   -0xc(%ebp)
 30a:	e8 fe 00 00 00       	call   40d <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37b:	8d 42 01             	lea    0x1(%edx),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 381:	8b 45 fc             	mov    -0x4(%ebp),%eax
 384:	8d 48 01             	lea    0x1(%eax),%ecx
 387:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp

}
 3a4:	90                   	nop
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    

000003a7 <acquireLock>:

void acquireLock(struct lock* l) {
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp

}
 3aa:	90                   	nop
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    

000003ad <releaseLock>:

void releaseLock(struct lock* l) {
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp

}
 3b0:	90                   	nop
 3b1:	5d                   	pop    %ebp
 3b2:	c3                   	ret    

000003b3 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp

}
 3b6:	90                   	nop
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    

000003b9 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp

}
 3bc:	90                   	nop
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret    

000003bf <broadcast>:

void broadcast(struct condvar* cv) {
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp

}
 3c2:	90                   	nop
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    

000003c5 <signal>:

void signal(struct condvar* cv) {
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp

}
 3c8:	90                   	nop
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <semInit>:

void semInit(struct semaphore* s, int initVal) {
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp

}
 3ce:	90                   	nop
 3cf:	5d                   	pop    %ebp
 3d0:	c3                   	ret    

000003d1 <semUp>:

void semUp(struct semaphore* s) {
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp

}
 3d4:	90                   	nop
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    

000003d7 <semDown>:

void semDown(struct semaphore* s) {
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp

}
 3da:	90                   	nop
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    

000003dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3dd:	b8 01 00 00 00       	mov    $0x1,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <exit>:
SYSCALL(exit)
 3e5:	b8 02 00 00 00       	mov    $0x2,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <wait>:
SYSCALL(wait)
 3ed:	b8 03 00 00 00       	mov    $0x3,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <pipe>:
SYSCALL(pipe)
 3f5:	b8 04 00 00 00       	mov    $0x4,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <read>:
SYSCALL(read)
 3fd:	b8 05 00 00 00       	mov    $0x5,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <write>:
SYSCALL(write)
 405:	b8 10 00 00 00       	mov    $0x10,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <close>:
SYSCALL(close)
 40d:	b8 15 00 00 00       	mov    $0x15,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <kill>:
SYSCALL(kill)
 415:	b8 06 00 00 00       	mov    $0x6,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <exec>:
SYSCALL(exec)
 41d:	b8 07 00 00 00       	mov    $0x7,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <open>:
SYSCALL(open)
 425:	b8 0f 00 00 00       	mov    $0xf,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <mknod>:
SYSCALL(mknod)
 42d:	b8 11 00 00 00       	mov    $0x11,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <unlink>:
SYSCALL(unlink)
 435:	b8 12 00 00 00       	mov    $0x12,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <fstat>:
SYSCALL(fstat)
 43d:	b8 08 00 00 00       	mov    $0x8,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <link>:
SYSCALL(link)
 445:	b8 13 00 00 00       	mov    $0x13,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <mkdir>:
SYSCALL(mkdir)
 44d:	b8 14 00 00 00       	mov    $0x14,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <chdir>:
SYSCALL(chdir)
 455:	b8 09 00 00 00       	mov    $0x9,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <dup>:
SYSCALL(dup)
 45d:	b8 0a 00 00 00       	mov    $0xa,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <getpid>:
SYSCALL(getpid)
 465:	b8 0b 00 00 00       	mov    $0xb,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <sbrk>:
SYSCALL(sbrk)
 46d:	b8 0c 00 00 00       	mov    $0xc,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <sleep>:
SYSCALL(sleep)
 475:	b8 0d 00 00 00       	mov    $0xd,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <uptime>:
SYSCALL(uptime)
 47d:	b8 0e 00 00 00       	mov    $0xe,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <thread_create>:
SYSCALL(thread_create)
 485:	b8 16 00 00 00       	mov    $0x16,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <thread_exit>:
SYSCALL(thread_exit)
 48d:	b8 17 00 00 00       	mov    $0x17,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <thread_join>:
SYSCALL(thread_join)
 495:	b8 18 00 00 00       	mov    $0x18,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <waitpid>:
SYSCALL(waitpid)
 49d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <barrier_init>:
SYSCALL(barrier_init)
 4a5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <barrier_check>:
SYSCALL(barrier_check)
 4ad:	b8 20 00 00 00       	mov    $0x20,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <sleepChan>:
SYSCALL(sleepChan)
 4b5:	b8 24 00 00 00       	mov    $0x24,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <getChannel>:
SYSCALL(getChannel)
 4bd:	b8 25 00 00 00       	mov    $0x25,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <sigChan>:
SYSCALL(sigChan)
 4c5:	b8 26 00 00 00       	mov    $0x26,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <sigOneChan>:
 4cd:	b8 27 00 00 00       	mov    $0x27,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 18             	sub    $0x18,%esp
 4db:	8b 45 0c             	mov    0xc(%ebp),%eax
 4de:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e1:	83 ec 04             	sub    $0x4,%esp
 4e4:	6a 01                	push   $0x1
 4e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	push   0x8(%ebp)
 4ed:	e8 13 ff ff ff       	call   405 <write>
 4f2:	83 c4 10             	add    $0x10,%esp
}
 4f5:	90                   	nop
 4f6:	c9                   	leave  
 4f7:	c3                   	ret    

000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 505:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 509:	74 17                	je     522 <printint+0x2a>
 50b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 50f:	79 11                	jns    522 <printint+0x2a>
    neg = 1;
 511:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	f7 d8                	neg    %eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 520:	eb 06                	jmp    528 <printint+0x30>
  } else {
    x = xx;
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 52f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 532:	8b 45 ec             	mov    -0x14(%ebp),%eax
 535:	ba 00 00 00 00       	mov    $0x0,%edx
 53a:	f7 f1                	div    %ecx
 53c:	89 d1                	mov    %edx,%ecx
 53e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 541:	8d 50 01             	lea    0x1(%eax),%edx
 544:	89 55 f4             	mov    %edx,-0xc(%ebp)
 547:	0f b6 91 0c 0d 00 00 	movzbl 0xd0c(%ecx),%edx
 54e:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 552:	8b 4d 10             	mov    0x10(%ebp),%ecx
 555:	8b 45 ec             	mov    -0x14(%ebp),%eax
 558:	ba 00 00 00 00       	mov    $0x0,%edx
 55d:	f7 f1                	div    %ecx
 55f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 562:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 566:	75 c7                	jne    52f <printint+0x37>
  if(neg)
 568:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56c:	74 2d                	je     59b <printint+0xa3>
    buf[i++] = '-';
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	8d 50 01             	lea    0x1(%eax),%edx
 574:	89 55 f4             	mov    %edx,-0xc(%ebp)
 577:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 57c:	eb 1d                	jmp    59b <printint+0xa3>
    putc(fd, buf[i]);
 57e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	01 d0                	add    %edx,%eax
 586:	0f b6 00             	movzbl (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	50                   	push   %eax
 590:	ff 75 08             	push   0x8(%ebp)
 593:	e8 3d ff ff ff       	call   4d5 <putc>
 598:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 59b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 59f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a3:	79 d9                	jns    57e <printint+0x86>
}
 5a5:	90                   	nop
 5a6:	c9                   	leave  
 5a7:	c3                   	ret    

000005a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a8:	55                   	push   %ebp
 5a9:	89 e5                	mov    %esp,%ebp
 5ab:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b8:	83 c0 04             	add    $0x4,%eax
 5bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c5:	e9 59 01 00 00       	jmp    723 <printf+0x17b>
    c = fmt[i] & 0xff;
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	25 ff 00 00 00       	and    $0xff,%eax
 5dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e4:	75 2c                	jne    612 <printf+0x6a>
      if(c == '%'){
 5e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ea:	75 0c                	jne    5f8 <printf+0x50>
        state = '%';
 5ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f3:	e9 27 01 00 00       	jmp    71f <printf+0x177>
      } else {
        putc(fd, c);
 5f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fb:	0f be c0             	movsbl %al,%eax
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	50                   	push   %eax
 602:	ff 75 08             	push   0x8(%ebp)
 605:	e8 cb fe ff ff       	call   4d5 <putc>
 60a:	83 c4 10             	add    $0x10,%esp
 60d:	e9 0d 01 00 00       	jmp    71f <printf+0x177>
      }
    } else if(state == '%'){
 612:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 616:	0f 85 03 01 00 00    	jne    71f <printf+0x177>
      if(c == 'd'){
 61c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 620:	75 1e                	jne    640 <printf+0x98>
        printint(fd, *ap, 10, 1);
 622:	8b 45 e8             	mov    -0x18(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	6a 01                	push   $0x1
 629:	6a 0a                	push   $0xa
 62b:	50                   	push   %eax
 62c:	ff 75 08             	push   0x8(%ebp)
 62f:	e8 c4 fe ff ff       	call   4f8 <printint>
 634:	83 c4 10             	add    $0x10,%esp
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63b:	e9 d8 00 00 00       	jmp    718 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 640:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 644:	74 06                	je     64c <printf+0xa4>
 646:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 64a:	75 1e                	jne    66a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 64c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	6a 00                	push   $0x0
 653:	6a 10                	push   $0x10
 655:	50                   	push   %eax
 656:	ff 75 08             	push   0x8(%ebp)
 659:	e8 9a fe ff ff       	call   4f8 <printint>
 65e:	83 c4 10             	add    $0x10,%esp
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 665:	e9 ae 00 00 00       	jmp    718 <printf+0x170>
      } else if(c == 's'){
 66a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 66e:	75 43                	jne    6b3 <printf+0x10b>
        s = (char*)*ap;
 670:	8b 45 e8             	mov    -0x18(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 678:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 67c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 680:	75 25                	jne    6a7 <printf+0xff>
          s = "(null)";
 682:	c7 45 f4 81 09 00 00 	movl   $0x981,-0xc(%ebp)
        while(*s != 0){
 689:	eb 1c                	jmp    6a7 <printf+0xff>
          putc(fd, *s);
 68b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68e:	0f b6 00             	movzbl (%eax),%eax
 691:	0f be c0             	movsbl %al,%eax
 694:	83 ec 08             	sub    $0x8,%esp
 697:	50                   	push   %eax
 698:	ff 75 08             	push   0x8(%ebp)
 69b:	e8 35 fe ff ff       	call   4d5 <putc>
 6a0:	83 c4 10             	add    $0x10,%esp
          s++;
 6a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6aa:	0f b6 00             	movzbl (%eax),%eax
 6ad:	84 c0                	test   %al,%al
 6af:	75 da                	jne    68b <printf+0xe3>
 6b1:	eb 65                	jmp    718 <printf+0x170>
        }
      } else if(c == 'c'){
 6b3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b7:	75 1d                	jne    6d6 <printf+0x12e>
        putc(fd, *ap);
 6b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	0f be c0             	movsbl %al,%eax
 6c1:	83 ec 08             	sub    $0x8,%esp
 6c4:	50                   	push   %eax
 6c5:	ff 75 08             	push   0x8(%ebp)
 6c8:	e8 08 fe ff ff       	call   4d5 <putc>
 6cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d4:	eb 42                	jmp    718 <printf+0x170>
      } else if(c == '%'){
 6d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6da:	75 17                	jne    6f3 <printf+0x14b>
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	83 ec 08             	sub    $0x8,%esp
 6e5:	50                   	push   %eax
 6e6:	ff 75 08             	push   0x8(%ebp)
 6e9:	e8 e7 fd ff ff       	call   4d5 <putc>
 6ee:	83 c4 10             	add    $0x10,%esp
 6f1:	eb 25                	jmp    718 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f3:	83 ec 08             	sub    $0x8,%esp
 6f6:	6a 25                	push   $0x25
 6f8:	ff 75 08             	push   0x8(%ebp)
 6fb:	e8 d5 fd ff ff       	call   4d5 <putc>
 700:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 706:	0f be c0             	movsbl %al,%eax
 709:	83 ec 08             	sub    $0x8,%esp
 70c:	50                   	push   %eax
 70d:	ff 75 08             	push   0x8(%ebp)
 710:	e8 c0 fd ff ff       	call   4d5 <putc>
 715:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 718:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 71f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 723:	8b 55 0c             	mov    0xc(%ebp),%edx
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	01 d0                	add    %edx,%eax
 72b:	0f b6 00             	movzbl (%eax),%eax
 72e:	84 c0                	test   %al,%al
 730:	0f 85 94 fe ff ff    	jne    5ca <printf+0x22>
    }
  }
}
 736:	90                   	nop
 737:	c9                   	leave  
 738:	c3                   	ret    

00000739 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 739:	55                   	push   %ebp
 73a:	89 e5                	mov    %esp,%ebp
 73c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	83 e8 08             	sub    $0x8,%eax
 745:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	a1 28 0d 00 00       	mov    0xd28,%eax
 74d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 750:	eb 24                	jmp    776 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 75a:	72 12                	jb     76e <free+0x35>
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 762:	77 24                	ja     788 <free+0x4f>
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 76c:	72 1a                	jb     788 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	89 45 fc             	mov    %eax,-0x4(%ebp)
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77c:	76 d4                	jbe    752 <free+0x19>
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 00                	mov    (%eax),%eax
 783:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 786:	73 ca                	jae    752 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	01 c2                	add    %eax,%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	39 c2                	cmp    %eax,%edx
 7a1:	75 24                	jne    7c7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 50 04             	mov    0x4(%eax),%edx
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	01 c2                	add    %eax,%edx
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	8b 10                	mov    (%eax),%edx
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	89 10                	mov    %edx,(%eax)
 7c5:	eb 0a                	jmp    7d1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 10                	mov    (%eax),%edx
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	01 d0                	add    %edx,%eax
 7e3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7e6:	75 20                	jne    808 <free+0xcf>
    p->s.size += bp->s.size;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 50 04             	mov    0x4(%eax),%edx
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	01 c2                	add    %eax,%edx
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ff:	8b 10                	mov    (%eax),%edx
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	89 10                	mov    %edx,(%eax)
 806:	eb 08                	jmp    810 <free+0xd7>
  } else
    p->s.ptr = bp;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80e:	89 10                	mov    %edx,(%eax)
  freep = p;
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	a3 28 0d 00 00       	mov    %eax,0xd28
}
 818:	90                   	nop
 819:	c9                   	leave  
 81a:	c3                   	ret    

0000081b <morecore>:

static Header*
morecore(uint nu)
{
 81b:	55                   	push   %ebp
 81c:	89 e5                	mov    %esp,%ebp
 81e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 821:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 828:	77 07                	ja     831 <morecore+0x16>
    nu = 4096;
 82a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 831:	8b 45 08             	mov    0x8(%ebp),%eax
 834:	c1 e0 03             	shl    $0x3,%eax
 837:	83 ec 0c             	sub    $0xc,%esp
 83a:	50                   	push   %eax
 83b:	e8 2d fc ff ff       	call   46d <sbrk>
 840:	83 c4 10             	add    $0x10,%esp
 843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 846:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 84a:	75 07                	jne    853 <morecore+0x38>
    return 0;
 84c:	b8 00 00 00 00       	mov    $0x0,%eax
 851:	eb 26                	jmp    879 <morecore+0x5e>
  hp = (Header*)p;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	8b 55 08             	mov    0x8(%ebp),%edx
 85f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	83 c0 08             	add    $0x8,%eax
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	50                   	push   %eax
 86c:	e8 c8 fe ff ff       	call   739 <free>
 871:	83 c4 10             	add    $0x10,%esp
  return freep;
 874:	a1 28 0d 00 00       	mov    0xd28,%eax
}
 879:	c9                   	leave  
 87a:	c3                   	ret    

0000087b <malloc>:

void*
malloc(uint nbytes)
{
 87b:	55                   	push   %ebp
 87c:	89 e5                	mov    %esp,%ebp
 87e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 881:	8b 45 08             	mov    0x8(%ebp),%eax
 884:	83 c0 07             	add    $0x7,%eax
 887:	c1 e8 03             	shr    $0x3,%eax
 88a:	83 c0 01             	add    $0x1,%eax
 88d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 890:	a1 28 0d 00 00       	mov    0xd28,%eax
 895:	89 45 f0             	mov    %eax,-0x10(%ebp)
 898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89c:	75 23                	jne    8c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 89e:	c7 45 f0 20 0d 00 00 	movl   $0xd20,-0x10(%ebp)
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	a3 28 0d 00 00       	mov    %eax,0xd28
 8ad:	a1 28 0d 00 00       	mov    0xd28,%eax
 8b2:	a3 20 0d 00 00       	mov    %eax,0xd20
    base.s.size = 0;
 8b7:	c7 05 24 0d 00 00 00 	movl   $0x0,0xd24
 8be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8d2:	77 4d                	ja     921 <malloc+0xa6>
      if(p->s.size == nunits)
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8dd:	75 0c                	jne    8eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 10                	mov    (%eax),%edx
 8e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e7:	89 10                	mov    %edx,(%eax)
 8e9:	eb 26                	jmp    911 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8f4:	89 c2                	mov    %eax,%edx
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	c1 e0 03             	shl    $0x3,%eax
 905:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 90e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	a3 28 0d 00 00       	mov    %eax,0xd28
      return (void*)(p + 1);
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	83 c0 08             	add    $0x8,%eax
 91f:	eb 3b                	jmp    95c <malloc+0xe1>
    }
    if(p == freep)
 921:	a1 28 0d 00 00       	mov    0xd28,%eax
 926:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 929:	75 1e                	jne    949 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 92b:	83 ec 0c             	sub    $0xc,%esp
 92e:	ff 75 ec             	push   -0x14(%ebp)
 931:	e8 e5 fe ff ff       	call   81b <morecore>
 936:	83 c4 10             	add    $0x10,%esp
 939:	89 45 f4             	mov    %eax,-0xc(%ebp)
 93c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 940:	75 07                	jne    949 <malloc+0xce>
        return 0;
 942:	b8 00 00 00 00       	mov    $0x0,%eax
 947:	eb 13                	jmp    95c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 957:	e9 6d ff ff ff       	jmp    8c9 <malloc+0x4e>
  }
}
 95c:	c9                   	leave  
 95d:	c3                   	ret    
