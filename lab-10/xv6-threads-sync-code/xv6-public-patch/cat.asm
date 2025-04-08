
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 31                	jmp    39 <cat+0x39>
    if (write(1, buf, n) != n) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 60 0d 00 00       	push   $0xd60
  13:	6a 01                	push   $0x1
  15:	e8 c4 03 00 00       	call   3de <write>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  20:	74 17                	je     39 <cat+0x39>
      printf(1, "cat: write error\n");
  22:	83 ec 08             	sub    $0x8,%esp
  25:	68 37 09 00 00       	push   $0x937
  2a:	6a 01                	push   $0x1
  2c:	e8 50 05 00 00       	call   581 <printf>
  31:	83 c4 10             	add    $0x10,%esp
      exit();
  34:	e8 85 03 00 00       	call   3be <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	68 00 02 00 00       	push   $0x200
  41:	68 60 0d 00 00       	push   $0xd60
  46:	ff 75 08             	push   0x8(%ebp)
  49:	e8 88 03 00 00       	call   3d6 <read>
  4e:	83 c4 10             	add    $0x10,%esp
  51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  58:	7f ae                	jg     8 <cat+0x8>
    }
  }
  if(n < 0){
  5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5e:	79 17                	jns    77 <cat+0x77>
    printf(1, "cat: read error\n");
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 49 09 00 00       	push   $0x949
  68:	6a 01                	push   $0x1
  6a:	e8 12 05 00 00       	call   581 <printf>
  6f:	83 c4 10             	add    $0x10,%esp
    exit();
  72:	e8 47 03 00 00       	call   3be <exit>
  }
}
  77:	90                   	nop
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <main>:

int
main(int argc, char *argv[])
{
  7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7e:	83 e4 f0             	and    $0xfffffff0,%esp
  81:	ff 71 fc             	push   -0x4(%ecx)
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	51                   	push   %ecx
  89:	83 ec 10             	sub    $0x10,%esp
  8c:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  8e:	83 3b 01             	cmpl   $0x1,(%ebx)
  91:	7f 12                	jg     a5 <main+0x2b>
    cat(0);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	6a 00                	push   $0x0
  98:	e8 63 ff ff ff       	call   0 <cat>
  9d:	83 c4 10             	add    $0x10,%esp
    exit();
  a0:	e8 19 03 00 00       	call   3be <exit>
  }

  for(i = 1; i < argc; i++){
  a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  ac:	eb 71                	jmp    11f <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  b8:	8b 43 04             	mov    0x4(%ebx),%eax
  bb:	01 d0                	add    %edx,%eax
  bd:	8b 00                	mov    (%eax),%eax
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	6a 00                	push   $0x0
  c4:	50                   	push   %eax
  c5:	e8 34 03 00 00       	call   3fe <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  d4:	79 29                	jns    ff <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e0:	8b 43 04             	mov    0x4(%ebx),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 00                	mov    (%eax),%eax
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	50                   	push   %eax
  eb:	68 5a 09 00 00       	push   $0x95a
  f0:	6a 01                	push   $0x1
  f2:	e8 8a 04 00 00       	call   581 <printf>
  f7:	83 c4 10             	add    $0x10,%esp
      exit();
  fa:	e8 bf 02 00 00       	call   3be <exit>
    }
    cat(fd);
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	ff 75 f0             	push   -0x10(%ebp)
 105:	e8 f6 fe ff ff       	call   0 <cat>
 10a:	83 c4 10             	add    $0x10,%esp
    close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 75 f0             	push   -0x10(%ebp)
 113:	e8 ce 02 00 00       	call   3e6 <close>
 118:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 11b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 11f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 122:	3b 03                	cmp    (%ebx),%eax
 124:	7c 88                	jl     ae <main+0x34>
  }
  exit();
 126:	e8 93 02 00 00       	call   3be <exit>

0000012b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 55 10             	mov    0x10(%ebp),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 cb                	mov    %ecx,%ebx
 13b:	89 df                	mov    %ebx,%edi
 13d:	89 d1                	mov    %edx,%ecx
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
 142:	89 ca                	mov    %ecx,%edx
 144:	89 fb                	mov    %edi,%ebx
 146:	89 5d 08             	mov    %ebx,0x8(%ebp)
 149:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14c:	90                   	nop
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15d:	90                   	nop
 15e:	8b 55 0c             	mov    0xc(%ebp),%edx
 161:	8d 42 01             	lea    0x1(%edx),%eax
 164:	89 45 0c             	mov    %eax,0xc(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8d 48 01             	lea    0x1(%eax),%ecx
 16d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
    ;
  return os;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 184:	eb 08                	jmp    18e <strcmp+0xd>
    p++, q++;
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c0             	movzbl %al,%eax
 1ba:	29 c2                	sub    %eax,%edx
 1bc:	89 d0                	mov    %edx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strlen>:

uint
strlen(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
    ;
  return n;
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ea:	8b 45 10             	mov    0x10(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	ff 75 0c             	push   0xc(%ebp)
 1f1:	ff 75 08             	push   0x8(%ebp)
 1f4:	e8 32 ff ff ff       	call   12b <stosb>
 1f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strchr>:

char*
strchr(const char *s, char c)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x22>
    if(*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x1e>
      return (char*)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x31>
  for(; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0xe>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 241:	eb 42                	jmp    285 <gets+0x51>
    cc = read(0, &c, 1);
 243:	83 ec 04             	sub    $0x4,%esp
 246:	6a 01                	push   $0x1
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	6a 00                	push   $0x0
 24e:	e8 83 01 00 00       	call   3d6 <read>
 253:	83 c4 10             	add    $0x10,%esp
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 33                	jle    292 <gets+0x5e>
      break;
    buf[i++] = c;
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 f4             	mov    %edx,-0xc(%ebp)
 268:	89 c2                	mov    %eax,%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 c2                	add    %eax,%edx
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 16                	je     293 <gets+0x5f>
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0d                	cmp    $0xd,%al
 283:	74 0e                	je     293 <gets+0x5f>
  for(i=0; i+1 < max; ){
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	83 c0 01             	add    $0x1,%eax
 28b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28e:	7f b3                	jg     243 <gets+0xf>
 290:	eb 01                	jmp    293 <gets+0x5f>
      break;
 292:	90                   	nop
      break;
  }
  buf[i] = '\0';
 293:	8b 55 f4             	mov    -0xc(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	push   0x8(%ebp)
 2b1:	e8 48 01 00 00       	call   3fe <open>
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x26>
    return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 25                	jmp    2ee <stat+0x4b>
  r = fstat(fd, st);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 0c             	push   0xc(%ebp)
 2cf:	ff 75 f4             	push   -0xc(%ebp)
 2d2:	e8 3f 01 00 00       	call   416 <fstat>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	83 ec 0c             	sub    $0xc,%esp
 2e0:	ff 75 f4             	push   -0xc(%ebp)
 2e3:	e8 fe 00 00 00       	call   3e6 <close>
 2e8:	83 c4 10             	add    $0x10,%esp
  return r;
 2eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fd:	eb 25                	jmp    324 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 302:	89 d0                	mov    %edx,%eax
 304:	c1 e0 02             	shl    $0x2,%eax
 307:	01 d0                	add    %edx,%eax
 309:	01 c0                	add    %eax,%eax
 30b:	89 c1                	mov    %eax,%ecx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 08             	mov    %edx,0x8(%ebp)
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2f                	cmp    $0x2f,%al
 32c:	7e 0a                	jle    338 <atoi+0x48>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 39                	cmp    $0x39,%al
 336:	7e c7                	jle    2ff <atoi+0xf>
  return n;
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33b:	c9                   	leave  
 33c:	c3                   	ret    

0000033d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34f:	eb 17                	jmp    368 <memmove+0x2b>
    *dst++ = *src++;
 351:	8b 55 f8             	mov    -0x8(%ebp),%edx
 354:	8d 42 01             	lea    0x1(%edx),%eax
 357:	89 45 f8             	mov    %eax,-0x8(%ebp)
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35d:	8d 48 01             	lea    0x1(%eax),%ecx
 360:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 363:	0f b6 12             	movzbl (%edx),%edx
 366:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 368:	8b 45 10             	mov    0x10(%ebp),%eax
 36b:	8d 50 ff             	lea    -0x1(%eax),%edx
 36e:	89 55 10             	mov    %edx,0x10(%ebp)
 371:	85 c0                	test   %eax,%eax
 373:	7f dc                	jg     351 <memmove+0x14>
  return vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
}
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp

}
 37d:	90                   	nop
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <acquireLock>:

void acquireLock(struct lock* l) {
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp

}
 383:	90                   	nop
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    

00000386 <releaseLock>:

void releaseLock(struct lock* l) {
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp

}
 389:	90                   	nop
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    

0000038c <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp

}
 38f:	90                   	nop
 390:	5d                   	pop    %ebp
 391:	c3                   	ret    

00000392 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp

}
 395:	90                   	nop
 396:	5d                   	pop    %ebp
 397:	c3                   	ret    

00000398 <broadcast>:

void broadcast(struct condvar* cv) {
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp

}
 39b:	90                   	nop
 39c:	5d                   	pop    %ebp
 39d:	c3                   	ret    

0000039e <signal>:

void signal(struct condvar* cv) {
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp

}
 3a1:	90                   	nop
 3a2:	5d                   	pop    %ebp
 3a3:	c3                   	ret    

000003a4 <semInit>:

void semInit(struct semaphore* s, int initVal) {
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp

}
 3a7:	90                   	nop
 3a8:	5d                   	pop    %ebp
 3a9:	c3                   	ret    

000003aa <semUp>:

void semUp(struct semaphore* s) {
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp

}
 3ad:	90                   	nop
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    

000003b0 <semDown>:

void semDown(struct semaphore* s) {
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp

}
 3b3:	90                   	nop
 3b4:	5d                   	pop    %ebp
 3b5:	c3                   	ret    

000003b6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b6:	b8 01 00 00 00       	mov    $0x1,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <exit>:
SYSCALL(exit)
 3be:	b8 02 00 00 00       	mov    $0x2,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <wait>:
SYSCALL(wait)
 3c6:	b8 03 00 00 00       	mov    $0x3,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <pipe>:
SYSCALL(pipe)
 3ce:	b8 04 00 00 00       	mov    $0x4,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <read>:
SYSCALL(read)
 3d6:	b8 05 00 00 00       	mov    $0x5,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <write>:
SYSCALL(write)
 3de:	b8 10 00 00 00       	mov    $0x10,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <close>:
SYSCALL(close)
 3e6:	b8 15 00 00 00       	mov    $0x15,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <kill>:
SYSCALL(kill)
 3ee:	b8 06 00 00 00       	mov    $0x6,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <exec>:
SYSCALL(exec)
 3f6:	b8 07 00 00 00       	mov    $0x7,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <open>:
SYSCALL(open)
 3fe:	b8 0f 00 00 00       	mov    $0xf,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <mknod>:
SYSCALL(mknod)
 406:	b8 11 00 00 00       	mov    $0x11,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <unlink>:
SYSCALL(unlink)
 40e:	b8 12 00 00 00       	mov    $0x12,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <fstat>:
SYSCALL(fstat)
 416:	b8 08 00 00 00       	mov    $0x8,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <link>:
SYSCALL(link)
 41e:	b8 13 00 00 00       	mov    $0x13,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <mkdir>:
SYSCALL(mkdir)
 426:	b8 14 00 00 00       	mov    $0x14,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <chdir>:
SYSCALL(chdir)
 42e:	b8 09 00 00 00       	mov    $0x9,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <dup>:
SYSCALL(dup)
 436:	b8 0a 00 00 00       	mov    $0xa,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <getpid>:
SYSCALL(getpid)
 43e:	b8 0b 00 00 00       	mov    $0xb,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <sbrk>:
SYSCALL(sbrk)
 446:	b8 0c 00 00 00       	mov    $0xc,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <sleep>:
SYSCALL(sleep)
 44e:	b8 0d 00 00 00       	mov    $0xd,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <uptime>:
SYSCALL(uptime)
 456:	b8 0e 00 00 00       	mov    $0xe,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <thread_create>:
SYSCALL(thread_create)
 45e:	b8 16 00 00 00       	mov    $0x16,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <thread_exit>:
SYSCALL(thread_exit)
 466:	b8 17 00 00 00       	mov    $0x17,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <thread_join>:
SYSCALL(thread_join)
 46e:	b8 18 00 00 00       	mov    $0x18,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <waitpid>:
SYSCALL(waitpid)
 476:	b8 1e 00 00 00       	mov    $0x1e,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <barrier_init>:
SYSCALL(barrier_init)
 47e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <barrier_check>:
SYSCALL(barrier_check)
 486:	b8 20 00 00 00       	mov    $0x20,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <sleepChan>:
SYSCALL(sleepChan)
 48e:	b8 24 00 00 00       	mov    $0x24,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <getChannel>:
SYSCALL(getChannel)
 496:	b8 25 00 00 00       	mov    $0x25,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <sigChan>:
SYSCALL(sigChan)
 49e:	b8 26 00 00 00       	mov    $0x26,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <sigOneChan>:
 4a6:	b8 27 00 00 00       	mov    $0x27,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
 4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ba:	83 ec 04             	sub    $0x4,%esp
 4bd:	6a 01                	push   $0x1
 4bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c2:	50                   	push   %eax
 4c3:	ff 75 08             	push   0x8(%ebp)
 4c6:	e8 13 ff ff ff       	call   3de <write>
 4cb:	83 c4 10             	add    $0x10,%esp
}
 4ce:	90                   	nop
 4cf:	c9                   	leave  
 4d0:	c3                   	ret    

000004d1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d1:	55                   	push   %ebp
 4d2:	89 e5                	mov    %esp,%ebp
 4d4:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e2:	74 17                	je     4fb <printint+0x2a>
 4e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e8:	79 11                	jns    4fb <printint+0x2a>
    neg = 1;
 4ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f4:	f7 d8                	neg    %eax
 4f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f9:	eb 06                	jmp    501 <printint+0x30>
  } else {
    x = xx;
 4fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 501:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 508:	8b 4d 10             	mov    0x10(%ebp),%ecx
 50b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50e:	ba 00 00 00 00       	mov    $0x0,%edx
 513:	f7 f1                	div    %ecx
 515:	89 d1                	mov    %edx,%ecx
 517:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51a:	8d 50 01             	lea    0x1(%eax),%edx
 51d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 520:	0f b6 91 20 0d 00 00 	movzbl 0xd20(%ecx),%edx
 527:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 52b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 531:	ba 00 00 00 00       	mov    $0x0,%edx
 536:	f7 f1                	div    %ecx
 538:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53f:	75 c7                	jne    508 <printint+0x37>
  if(neg)
 541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 545:	74 2d                	je     574 <printint+0xa3>
    buf[i++] = '-';
 547:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54a:	8d 50 01             	lea    0x1(%eax),%edx
 54d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 550:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 555:	eb 1d                	jmp    574 <printint+0xa3>
    putc(fd, buf[i]);
 557:	8d 55 dc             	lea    -0x24(%ebp),%edx
 55a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55d:	01 d0                	add    %edx,%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	push   0x8(%ebp)
 56c:	e8 3d ff ff ff       	call   4ae <putc>
 571:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 574:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57c:	79 d9                	jns    557 <printint+0x86>
}
 57e:	90                   	nop
 57f:	c9                   	leave  
 580:	c3                   	ret    

00000581 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 0c             	lea    0xc(%ebp),%eax
 591:	83 c0 04             	add    $0x4,%eax
 594:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59e:	e9 59 01 00 00       	jmp    6fc <printf+0x17b>
    c = fmt[i] & 0xff;
 5a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a9:	01 d0                	add    %edx,%eax
 5ab:	0f b6 00             	movzbl (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	25 ff 00 00 00       	and    $0xff,%eax
 5b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 2c                	jne    5eb <printf+0x6a>
      if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 0c                	jne    5d1 <printf+0x50>
        state = '%';
 5c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cc:	e9 27 01 00 00       	jmp    6f8 <printf+0x177>
      } else {
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	50                   	push   %eax
 5db:	ff 75 08             	push   0x8(%ebp)
 5de:	e8 cb fe ff ff       	call   4ae <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	e9 0d 01 00 00       	jmp    6f8 <printf+0x177>
      }
    } else if(state == '%'){
 5eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ef:	0f 85 03 01 00 00    	jne    6f8 <printf+0x177>
      if(c == 'd'){
 5f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f9:	75 1e                	jne    619 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	6a 01                	push   $0x1
 602:	6a 0a                	push   $0xa
 604:	50                   	push   %eax
 605:	ff 75 08             	push   0x8(%ebp)
 608:	e8 c4 fe ff ff       	call   4d1 <printint>
 60d:	83 c4 10             	add    $0x10,%esp
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 614:	e9 d8 00 00 00       	jmp    6f1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 619:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61d:	74 06                	je     625 <printf+0xa4>
 61f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 623:	75 1e                	jne    643 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 625:	8b 45 e8             	mov    -0x18(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	6a 00                	push   $0x0
 62c:	6a 10                	push   $0x10
 62e:	50                   	push   %eax
 62f:	ff 75 08             	push   0x8(%ebp)
 632:	e8 9a fe ff ff       	call   4d1 <printint>
 637:	83 c4 10             	add    $0x10,%esp
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	e9 ae 00 00 00       	jmp    6f1 <printf+0x170>
      } else if(c == 's'){
 643:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 647:	75 43                	jne    68c <printf+0x10b>
        s = (char*)*ap;
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 659:	75 25                	jne    680 <printf+0xff>
          s = "(null)";
 65b:	c7 45 f4 6f 09 00 00 	movl   $0x96f,-0xc(%ebp)
        while(*s != 0){
 662:	eb 1c                	jmp    680 <printf+0xff>
          putc(fd, *s);
 664:	8b 45 f4             	mov    -0xc(%ebp),%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	0f be c0             	movsbl %al,%eax
 66d:	83 ec 08             	sub    $0x8,%esp
 670:	50                   	push   %eax
 671:	ff 75 08             	push   0x8(%ebp)
 674:	e8 35 fe ff ff       	call   4ae <putc>
 679:	83 c4 10             	add    $0x10,%esp
          s++;
 67c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 680:	8b 45 f4             	mov    -0xc(%ebp),%eax
 683:	0f b6 00             	movzbl (%eax),%eax
 686:	84 c0                	test   %al,%al
 688:	75 da                	jne    664 <printf+0xe3>
 68a:	eb 65                	jmp    6f1 <printf+0x170>
        }
      } else if(c == 'c'){
 68c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 690:	75 1d                	jne    6af <printf+0x12e>
        putc(fd, *ap);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	83 ec 08             	sub    $0x8,%esp
 69d:	50                   	push   %eax
 69e:	ff 75 08             	push   0x8(%ebp)
 6a1:	e8 08 fe ff ff       	call   4ae <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ad:	eb 42                	jmp    6f1 <printf+0x170>
      } else if(c == '%'){
 6af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b3:	75 17                	jne    6cc <printf+0x14b>
        putc(fd, c);
 6b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b8:	0f be c0             	movsbl %al,%eax
 6bb:	83 ec 08             	sub    $0x8,%esp
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	push   0x8(%ebp)
 6c2:	e8 e7 fd ff ff       	call   4ae <putc>
 6c7:	83 c4 10             	add    $0x10,%esp
 6ca:	eb 25                	jmp    6f1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	6a 25                	push   $0x25
 6d1:	ff 75 08             	push   0x8(%ebp)
 6d4:	e8 d5 fd ff ff       	call   4ae <putc>
 6d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	83 ec 08             	sub    $0x8,%esp
 6e5:	50                   	push   %eax
 6e6:	ff 75 08             	push   0x8(%ebp)
 6e9:	e8 c0 fd ff ff       	call   4ae <putc>
 6ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	84 c0                	test   %al,%al
 709:	0f 85 94 fe ff ff    	jne    5a3 <printf+0x22>
    }
  }
}
 70f:	90                   	nop
 710:	c9                   	leave  
 711:	c3                   	ret    

00000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	83 e8 08             	sub    $0x8,%eax
 71e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 48 0d 00 00       	mov    0xd48,%eax
 726:	89 45 fc             	mov    %eax,-0x4(%ebp)
 729:	eb 24                	jmp    74f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 733:	72 12                	jb     747 <free+0x35>
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73b:	77 24                	ja     761 <free+0x4f>
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 745:	72 1a                	jb     761 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	76 d4                	jbe    72b <free+0x19>
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 75f:	73 ca                	jae    72b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	01 c2                	add    %eax,%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	39 c2                	cmp    %eax,%edx
 77a:	75 24                	jne    7a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	8b 50 04             	mov    0x4(%eax),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	01 c2                	add    %eax,%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	89 10                	mov    %edx,(%eax)
 79e:	eb 0a                	jmp    7aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	01 d0                	add    %edx,%eax
 7bc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7bf:	75 20                	jne    7e1 <free+0xcf>
    p->s.size += bp->s.size;
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 50 04             	mov    0x4(%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	01 c2                	add    %eax,%edx
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
 7df:	eb 08                	jmp    7e9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	a3 48 0d 00 00       	mov    %eax,0xd48
}
 7f1:	90                   	nop
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <morecore>:

static Header*
morecore(uint nu)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 801:	77 07                	ja     80a <morecore+0x16>
    nu = 4096;
 803:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	c1 e0 03             	shl    $0x3,%eax
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	50                   	push   %eax
 814:	e8 2d fc ff ff       	call   446 <sbrk>
 819:	83 c4 10             	add    $0x10,%esp
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 823:	75 07                	jne    82c <morecore+0x38>
    return 0;
 825:	b8 00 00 00 00       	mov    $0x0,%eax
 82a:	eb 26                	jmp    852 <morecore+0x5e>
  hp = (Header*)p;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	8b 55 08             	mov    0x8(%ebp),%edx
 838:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	83 c0 08             	add    $0x8,%eax
 841:	83 ec 0c             	sub    $0xc,%esp
 844:	50                   	push   %eax
 845:	e8 c8 fe ff ff       	call   712 <free>
 84a:	83 c4 10             	add    $0x10,%esp
  return freep;
 84d:	a1 48 0d 00 00       	mov    0xd48,%eax
}
 852:	c9                   	leave  
 853:	c3                   	ret    

00000854 <malloc>:

void*
malloc(uint nbytes)
{
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	83 c0 07             	add    $0x7,%eax
 860:	c1 e8 03             	shr    $0x3,%eax
 863:	83 c0 01             	add    $0x1,%eax
 866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 869:	a1 48 0d 00 00       	mov    0xd48,%eax
 86e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 871:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 875:	75 23                	jne    89a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 877:	c7 45 f0 40 0d 00 00 	movl   $0xd40,-0x10(%ebp)
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	a3 48 0d 00 00       	mov    %eax,0xd48
 886:	a1 48 0d 00 00       	mov    0xd48,%eax
 88b:	a3 40 0d 00 00       	mov    %eax,0xd40
    base.s.size = 0;
 890:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
 897:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8ab:	77 4d                	ja     8fa <malloc+0xa6>
      if(p->s.size == nunits)
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8b6:	75 0c                	jne    8c4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 10                	mov    (%eax),%edx
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	89 10                	mov    %edx,(%eax)
 8c2:	eb 26                	jmp    8ea <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8cd:	89 c2                	mov    %eax,%edx
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	c1 e0 03             	shl    $0x3,%eax
 8de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	a3 48 0d 00 00       	mov    %eax,0xd48
      return (void*)(p + 1);
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	83 c0 08             	add    $0x8,%eax
 8f8:	eb 3b                	jmp    935 <malloc+0xe1>
    }
    if(p == freep)
 8fa:	a1 48 0d 00 00       	mov    0xd48,%eax
 8ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 902:	75 1e                	jne    922 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 904:	83 ec 0c             	sub    $0xc,%esp
 907:	ff 75 ec             	push   -0x14(%ebp)
 90a:	e8 e5 fe ff ff       	call   7f4 <morecore>
 90f:	83 c4 10             	add    $0x10,%esp
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
 915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 919:	75 07                	jne    922 <malloc+0xce>
        return 0;
 91b:	b8 00 00 00 00       	mov    $0x0,%eax
 920:	eb 13                	jmp    935 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	89 45 f0             	mov    %eax,-0x10(%ebp)
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 930:	e9 6d ff ff ff       	jmp    8a2 <malloc+0x4e>
  }
}
 935:	c9                   	leave  
 936:	c3                   	ret    
