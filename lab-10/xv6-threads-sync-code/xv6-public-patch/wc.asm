
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 00 0e 00 00       	add    $0xe00,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 00 0e 00 00       	add    $0xe00,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 c9 09 00 00       	push   $0x9c9
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 00 0e 00 00       	push   $0xe00
  98:	ff 75 08             	push   0x8(%ebp)
  9b:	e8 c8 03 00 00       	call   468 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 cf 09 00 00       	push   $0x9cf
  be:	6a 01                	push   $0x1
  c0:	e8 4e 05 00 00       	call   613 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 83 03 00 00       	call   450 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	push   0xc(%ebp)
  d3:	ff 75 e8             	push   -0x18(%ebp)
  d6:	ff 75 ec             	push   -0x14(%ebp)
  d9:	ff 75 f0             	push   -0x10(%ebp)
  dc:	68 df 09 00 00       	push   $0x9df
  e1:	6a 01                	push   $0x1
  e3:	e8 2b 05 00 00       	call   613 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	push   -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 ec 09 00 00       	push   $0x9ec
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 32 03 00 00       	call   450 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 4a 03 00 00       	call   490 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 ed 09 00 00       	push   $0x9ed
 16c:	6a 01                	push   $0x1
 16e:	e8 a0 04 00 00       	call   613 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 d5 02 00 00       	call   450 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	push   -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	push   -0x10(%ebp)
 1a1:	e8 d2 02 00 00       	call   478 <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
  }
  exit();
 1b8:	e8 93 02 00 00       	call   450 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f3:	8d 42 01             	lea    0x1(%edx),%eax
 1f6:	89 45 0c             	mov    %eax,0xc(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8d 48 01             	lea    0x1(%eax),%ecx
 1ff:	89 4d 08             	mov    %ecx,0x8(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	push   0xc(%ebp)
 283:	ff 75 08             	push   0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 83 01 00 00       	call   468 <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 320:	7f b3                	jg     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
      break;
 324:	90                   	nop
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(const char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	push   0x8(%ebp)
 343:	e8 48 01 00 00       	call   490 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	push   0xc(%ebp)
 361:	ff 75 f4             	push   -0xc(%ebp)
 364:	e8 3f 01 00 00       	call   4a8 <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	push   -0xc(%ebp)
 375:	e8 fe 00 00 00       	call   478 <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e6:	8d 42 01             	lea    0x1(%edx),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ef:	8d 48 01             	lea    0x1(%eax),%ecx
 3f2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp

}
 40f:	90                   	nop
 410:	5d                   	pop    %ebp
 411:	c3                   	ret    

00000412 <acquireLock>:

void acquireLock(struct lock* l) {
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp

}
 415:	90                   	nop
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    

00000418 <releaseLock>:

void releaseLock(struct lock* l) {
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp

}
 41b:	90                   	nop
 41c:	5d                   	pop    %ebp
 41d:	c3                   	ret    

0000041e <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp

}
 421:	90                   	nop
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    

00000424 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp

}
 427:	90                   	nop
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <broadcast>:

void broadcast(struct condvar* cv) {
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp

}
 42d:	90                   	nop
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    

00000430 <signal>:

void signal(struct condvar* cv) {
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp

}
 433:	90                   	nop
 434:	5d                   	pop    %ebp
 435:	c3                   	ret    

00000436 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp

}
 439:	90                   	nop
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    

0000043c <semUp>:

void semUp(struct semaphore* s) {
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp

}
 43f:	90                   	nop
 440:	5d                   	pop    %ebp
 441:	c3                   	ret    

00000442 <semDown>:

void semDown(struct semaphore* s) {
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp

}
 445:	90                   	nop
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    

00000448 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 448:	b8 01 00 00 00       	mov    $0x1,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <exit>:
SYSCALL(exit)
 450:	b8 02 00 00 00       	mov    $0x2,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <wait>:
SYSCALL(wait)
 458:	b8 03 00 00 00       	mov    $0x3,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <pipe>:
SYSCALL(pipe)
 460:	b8 04 00 00 00       	mov    $0x4,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <read>:
SYSCALL(read)
 468:	b8 05 00 00 00       	mov    $0x5,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <write>:
SYSCALL(write)
 470:	b8 10 00 00 00       	mov    $0x10,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <close>:
SYSCALL(close)
 478:	b8 15 00 00 00       	mov    $0x15,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <kill>:
SYSCALL(kill)
 480:	b8 06 00 00 00       	mov    $0x6,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <exec>:
SYSCALL(exec)
 488:	b8 07 00 00 00       	mov    $0x7,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <open>:
SYSCALL(open)
 490:	b8 0f 00 00 00       	mov    $0xf,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mknod>:
SYSCALL(mknod)
 498:	b8 11 00 00 00       	mov    $0x11,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <unlink>:
SYSCALL(unlink)
 4a0:	b8 12 00 00 00       	mov    $0x12,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <fstat>:
SYSCALL(fstat)
 4a8:	b8 08 00 00 00       	mov    $0x8,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <link>:
SYSCALL(link)
 4b0:	b8 13 00 00 00       	mov    $0x13,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <mkdir>:
SYSCALL(mkdir)
 4b8:	b8 14 00 00 00       	mov    $0x14,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chdir>:
SYSCALL(chdir)
 4c0:	b8 09 00 00 00       	mov    $0x9,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <dup>:
SYSCALL(dup)
 4c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getpid>:
SYSCALL(getpid)
 4d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sbrk>:
SYSCALL(sbrk)
 4d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <sleep>:
SYSCALL(sleep)
 4e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <uptime>:
SYSCALL(uptime)
 4e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <thread_create>:
SYSCALL(thread_create)
 4f0:	b8 16 00 00 00       	mov    $0x16,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <thread_exit>:
SYSCALL(thread_exit)
 4f8:	b8 17 00 00 00       	mov    $0x17,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <thread_join>:
SYSCALL(thread_join)
 500:	b8 18 00 00 00       	mov    $0x18,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <waitpid>:
SYSCALL(waitpid)
 508:	b8 1e 00 00 00       	mov    $0x1e,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <barrier_init>:
SYSCALL(barrier_init)
 510:	b8 1f 00 00 00       	mov    $0x1f,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <barrier_check>:
SYSCALL(barrier_check)
 518:	b8 20 00 00 00       	mov    $0x20,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <sleepChan>:
SYSCALL(sleepChan)
 520:	b8 24 00 00 00       	mov    $0x24,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <getChannel>:
SYSCALL(getChannel)
 528:	b8 25 00 00 00       	mov    $0x25,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <sigChan>:
SYSCALL(sigChan)
 530:	b8 26 00 00 00       	mov    $0x26,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <sigOneChan>:
 538:	b8 27 00 00 00       	mov    $0x27,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 18             	sub    $0x18,%esp
 546:	8b 45 0c             	mov    0xc(%ebp),%eax
 549:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 54c:	83 ec 04             	sub    $0x4,%esp
 54f:	6a 01                	push   $0x1
 551:	8d 45 f4             	lea    -0xc(%ebp),%eax
 554:	50                   	push   %eax
 555:	ff 75 08             	push   0x8(%ebp)
 558:	e8 13 ff ff ff       	call   470 <write>
 55d:	83 c4 10             	add    $0x10,%esp
}
 560:	90                   	nop
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
 566:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 569:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 570:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 574:	74 17                	je     58d <printint+0x2a>
 576:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 57a:	79 11                	jns    58d <printint+0x2a>
    neg = 1;
 57c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 583:	8b 45 0c             	mov    0xc(%ebp),%eax
 586:	f7 d8                	neg    %eax
 588:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58b:	eb 06                	jmp    593 <printint+0x30>
  } else {
    x = xx;
 58d:	8b 45 0c             	mov    0xc(%ebp),%eax
 590:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 593:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 59a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 59d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a0:	ba 00 00 00 00       	mov    $0x0,%edx
 5a5:	f7 f1                	div    %ecx
 5a7:	89 d1                	mov    %edx,%ecx
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	8d 50 01             	lea    0x1(%eax),%edx
 5af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b2:	0f b6 91 b0 0d 00 00 	movzbl 0xdb0(%ecx),%edx
 5b9:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c3:	ba 00 00 00 00       	mov    $0x0,%edx
 5c8:	f7 f1                	div    %ecx
 5ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d1:	75 c7                	jne    59a <printint+0x37>
  if(neg)
 5d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d7:	74 2d                	je     606 <printint+0xa3>
    buf[i++] = '-';
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	8d 50 01             	lea    0x1(%eax),%edx
 5df:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e7:	eb 1d                	jmp    606 <printint+0xa3>
    putc(fd, buf[i]);
 5e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ef:	01 d0                	add    %edx,%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	83 ec 08             	sub    $0x8,%esp
 5fa:	50                   	push   %eax
 5fb:	ff 75 08             	push   0x8(%ebp)
 5fe:	e8 3d ff ff ff       	call   540 <putc>
 603:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 606:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 60a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60e:	79 d9                	jns    5e9 <printint+0x86>
}
 610:	90                   	nop
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 613:	55                   	push   %ebp
 614:	89 e5                	mov    %esp,%ebp
 616:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 619:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 620:	8d 45 0c             	lea    0xc(%ebp),%eax
 623:	83 c0 04             	add    $0x4,%eax
 626:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 629:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 630:	e9 59 01 00 00       	jmp    78e <printf+0x17b>
    c = fmt[i] & 0xff;
 635:	8b 55 0c             	mov    0xc(%ebp),%edx
 638:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63b:	01 d0                	add    %edx,%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	25 ff 00 00 00       	and    $0xff,%eax
 648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 64b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64f:	75 2c                	jne    67d <printf+0x6a>
      if(c == '%'){
 651:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 655:	75 0c                	jne    663 <printf+0x50>
        state = '%';
 657:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 65e:	e9 27 01 00 00       	jmp    78a <printf+0x177>
      } else {
        putc(fd, c);
 663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	83 ec 08             	sub    $0x8,%esp
 66c:	50                   	push   %eax
 66d:	ff 75 08             	push   0x8(%ebp)
 670:	e8 cb fe ff ff       	call   540 <putc>
 675:	83 c4 10             	add    $0x10,%esp
 678:	e9 0d 01 00 00       	jmp    78a <printf+0x177>
      }
    } else if(state == '%'){
 67d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 681:	0f 85 03 01 00 00    	jne    78a <printf+0x177>
      if(c == 'd'){
 687:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 68b:	75 1e                	jne    6ab <printf+0x98>
        printint(fd, *ap, 10, 1);
 68d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	6a 01                	push   $0x1
 694:	6a 0a                	push   $0xa
 696:	50                   	push   %eax
 697:	ff 75 08             	push   0x8(%ebp)
 69a:	e8 c4 fe ff ff       	call   563 <printint>
 69f:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a6:	e9 d8 00 00 00       	jmp    783 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ab:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6af:	74 06                	je     6b7 <printf+0xa4>
 6b1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b5:	75 1e                	jne    6d5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	6a 00                	push   $0x0
 6be:	6a 10                	push   $0x10
 6c0:	50                   	push   %eax
 6c1:	ff 75 08             	push   0x8(%ebp)
 6c4:	e8 9a fe ff ff       	call   563 <printint>
 6c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d0:	e9 ae 00 00 00       	jmp    783 <printf+0x170>
      } else if(c == 's'){
 6d5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d9:	75 43                	jne    71e <printf+0x10b>
        s = (char*)*ap;
 6db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6eb:	75 25                	jne    712 <printf+0xff>
          s = "(null)";
 6ed:	c7 45 f4 01 0a 00 00 	movl   $0xa01,-0xc(%ebp)
        while(*s != 0){
 6f4:	eb 1c                	jmp    712 <printf+0xff>
          putc(fd, *s);
 6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	83 ec 08             	sub    $0x8,%esp
 702:	50                   	push   %eax
 703:	ff 75 08             	push   0x8(%ebp)
 706:	e8 35 fe ff ff       	call   540 <putc>
 70b:	83 c4 10             	add    $0x10,%esp
          s++;
 70e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	0f b6 00             	movzbl (%eax),%eax
 718:	84 c0                	test   %al,%al
 71a:	75 da                	jne    6f6 <printf+0xe3>
 71c:	eb 65                	jmp    783 <printf+0x170>
        }
      } else if(c == 'c'){
 71e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 722:	75 1d                	jne    741 <printf+0x12e>
        putc(fd, *ap);
 724:	8b 45 e8             	mov    -0x18(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	83 ec 08             	sub    $0x8,%esp
 72f:	50                   	push   %eax
 730:	ff 75 08             	push   0x8(%ebp)
 733:	e8 08 fe ff ff       	call   540 <putc>
 738:	83 c4 10             	add    $0x10,%esp
        ap++;
 73b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73f:	eb 42                	jmp    783 <printf+0x170>
      } else if(c == '%'){
 741:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 745:	75 17                	jne    75e <printf+0x14b>
        putc(fd, c);
 747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74a:	0f be c0             	movsbl %al,%eax
 74d:	83 ec 08             	sub    $0x8,%esp
 750:	50                   	push   %eax
 751:	ff 75 08             	push   0x8(%ebp)
 754:	e8 e7 fd ff ff       	call   540 <putc>
 759:	83 c4 10             	add    $0x10,%esp
 75c:	eb 25                	jmp    783 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75e:	83 ec 08             	sub    $0x8,%esp
 761:	6a 25                	push   $0x25
 763:	ff 75 08             	push   0x8(%ebp)
 766:	e8 d5 fd ff ff       	call   540 <putc>
 76b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 76e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 771:	0f be c0             	movsbl %al,%eax
 774:	83 ec 08             	sub    $0x8,%esp
 777:	50                   	push   %eax
 778:	ff 75 08             	push   0x8(%ebp)
 77b:	e8 c0 fd ff ff       	call   540 <putc>
 780:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 783:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 78a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 78e:	8b 55 0c             	mov    0xc(%ebp),%edx
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	01 d0                	add    %edx,%eax
 796:	0f b6 00             	movzbl (%eax),%eax
 799:	84 c0                	test   %al,%al
 79b:	0f 85 94 fe ff ff    	jne    635 <printf+0x22>
    }
  }
}
 7a1:	90                   	nop
 7a2:	c9                   	leave  
 7a3:	c3                   	ret    

000007a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a4:	55                   	push   %ebp
 7a5:	89 e5                	mov    %esp,%ebp
 7a7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7aa:	8b 45 08             	mov    0x8(%ebp),%eax
 7ad:	83 e8 08             	sub    $0x8,%eax
 7b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b3:	a1 e8 0d 00 00       	mov    0xde8,%eax
 7b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bb:	eb 24                	jmp    7e1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7c5:	72 12                	jb     7d9 <free+0x35>
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cd:	77 24                	ja     7f3 <free+0x4f>
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7d7:	72 1a                	jb     7f3 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e7:	76 d4                	jbe    7bd <free+0x19>
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7f1:	73 ca                	jae    7bd <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	01 c2                	add    %eax,%edx
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	39 c2                	cmp    %eax,%edx
 80c:	75 24                	jne    832 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 80e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 811:	8b 50 04             	mov    0x4(%eax),%edx
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	8b 00                	mov    (%eax),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	01 c2                	add    %eax,%edx
 81e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 821:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	8b 10                	mov    (%eax),%edx
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	89 10                	mov    %edx,(%eax)
 830:	eb 0a                	jmp    83c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 832:	8b 45 fc             	mov    -0x4(%ebp),%eax
 835:	8b 10                	mov    (%eax),%edx
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	01 d0                	add    %edx,%eax
 84e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 851:	75 20                	jne    873 <free+0xcf>
    p->s.size += bp->s.size;
 853:	8b 45 fc             	mov    -0x4(%ebp),%eax
 856:	8b 50 04             	mov    0x4(%eax),%edx
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	01 c2                	add    %eax,%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 867:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86a:	8b 10                	mov    (%eax),%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	89 10                	mov    %edx,(%eax)
 871:	eb 08                	jmp    87b <free+0xd7>
  } else
    p->s.ptr = bp;
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 55 f8             	mov    -0x8(%ebp),%edx
 879:	89 10                	mov    %edx,(%eax)
  freep = p;
 87b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87e:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 883:	90                   	nop
 884:	c9                   	leave  
 885:	c3                   	ret    

00000886 <morecore>:

static Header*
morecore(uint nu)
{
 886:	55                   	push   %ebp
 887:	89 e5                	mov    %esp,%ebp
 889:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 893:	77 07                	ja     89c <morecore+0x16>
    nu = 4096;
 895:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89c:	8b 45 08             	mov    0x8(%ebp),%eax
 89f:	c1 e0 03             	shl    $0x3,%eax
 8a2:	83 ec 0c             	sub    $0xc,%esp
 8a5:	50                   	push   %eax
 8a6:	e8 2d fc ff ff       	call   4d8 <sbrk>
 8ab:	83 c4 10             	add    $0x10,%esp
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b5:	75 07                	jne    8be <morecore+0x38>
    return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb 26                	jmp    8e4 <morecore+0x5e>
  hp = (Header*)p;
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	8b 55 08             	mov    0x8(%ebp),%edx
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	83 c0 08             	add    $0x8,%eax
 8d3:	83 ec 0c             	sub    $0xc,%esp
 8d6:	50                   	push   %eax
 8d7:	e8 c8 fe ff ff       	call   7a4 <free>
 8dc:	83 c4 10             	add    $0x10,%esp
  return freep;
 8df:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 8e4:	c9                   	leave  
 8e5:	c3                   	ret    

000008e6 <malloc>:

void*
malloc(uint nbytes)
{
 8e6:	55                   	push   %ebp
 8e7:	89 e5                	mov    %esp,%ebp
 8e9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	83 c0 07             	add    $0x7,%eax
 8f2:	c1 e8 03             	shr    $0x3,%eax
 8f5:	83 c0 01             	add    $0x1,%eax
 8f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fb:	a1 e8 0d 00 00       	mov    0xde8,%eax
 900:	89 45 f0             	mov    %eax,-0x10(%ebp)
 903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 907:	75 23                	jne    92c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 909:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 910:	8b 45 f0             	mov    -0x10(%ebp),%eax
 913:	a3 e8 0d 00 00       	mov    %eax,0xde8
 918:	a1 e8 0d 00 00       	mov    0xde8,%eax
 91d:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 922:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 929:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92f:	8b 00                	mov    (%eax),%eax
 931:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	8b 40 04             	mov    0x4(%eax),%eax
 93a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 93d:	77 4d                	ja     98c <malloc+0xa6>
      if(p->s.size == nunits)
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 948:	75 0c                	jne    956 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 10                	mov    (%eax),%edx
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	89 10                	mov    %edx,(%eax)
 954:	eb 26                	jmp    97c <malloc+0x96>
      else {
        p->s.size -= nunits;
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95f:	89 c2                	mov    %eax,%edx
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	8b 40 04             	mov    0x4(%eax),%eax
 96d:	c1 e0 03             	shl    $0x3,%eax
 970:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	8b 55 ec             	mov    -0x14(%ebp),%edx
 979:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97f:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	83 c0 08             	add    $0x8,%eax
 98a:	eb 3b                	jmp    9c7 <malloc+0xe1>
    }
    if(p == freep)
 98c:	a1 e8 0d 00 00       	mov    0xde8,%eax
 991:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 994:	75 1e                	jne    9b4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 996:	83 ec 0c             	sub    $0xc,%esp
 999:	ff 75 ec             	push   -0x14(%ebp)
 99c:	e8 e5 fe ff ff       	call   886 <morecore>
 9a1:	83 c4 10             	add    $0x10,%esp
 9a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ab:	75 07                	jne    9b4 <malloc+0xce>
        return 0;
 9ad:	b8 00 00 00 00       	mov    $0x0,%eax
 9b2:	eb 13                	jmp    9c7 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c2:	e9 6d ff ff ff       	jmp    934 <malloc+0x4e>
  }
}
 9c7:	c9                   	leave  
 9c8:	c3                   	ret    
