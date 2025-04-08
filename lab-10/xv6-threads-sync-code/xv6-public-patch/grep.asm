
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 c0 0f 00 00       	add    $0xfc0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 c0 0f 00 00 	movl   $0xfc0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	push   -0x10(%ebp)
  38:	ff 75 08             	push   0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	push   -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 7f 05 00 00       	call   5e9 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	push   -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  8f:	81 7d f0 c0 0f 00 00 	cmpl   $0xfc0,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba c0 0f 00 00       	mov    $0xfc0,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	push   -0xc(%ebp)
  b8:	ff 75 f0             	push   -0x10(%ebp)
  bb:	68 c0 0f 00 00       	push   $0xfc0
  c0:	e8 83 04 00 00       	call   548 <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 c0 0f 00 00       	add    $0xfc0,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	push   0xc(%ebp)
  e6:	e8 f6 04 00 00       	call   5e1 <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	push   -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 44 0b 00 00       	push   $0xb44
 11f:	6a 02                	push   $0x2
 121:	e8 66 06 00 00       	call   78c <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 9b 04 00 00       	call   5c9 <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	push   -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 78 04 00 00       	call   5c9 <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 93 04 00 00       	call   609 <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 64 0b 00 00       	push   $0xb64
 19c:	6a 01                	push   $0x1
 19e:	e8 e9 05 00 00       	call   78c <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 1e 04 00 00       	call   5c9 <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	push   -0x14(%ebp)
 1b1:	ff 75 f0             	push   -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	push   -0x14(%ebp)
 1c2:	e8 2a 04 00 00       	call   5f1 <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
  }
  exit();
 1d5:	e8 ef 03 00 00       	call   5c9 <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	push   0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	push   0xc(%ebp)
 207:	ff 75 08             	push   0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	push   0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	push   0x10(%ebp)
 2f5:	ff 75 0c             	push   0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	39 45 08             	cmp    %eax,0x8(%ebp)
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 55 0c             	mov    0xc(%ebp),%edx
 36c:	8d 42 01             	lea    0x1(%edx),%eax
 36f:	89 45 0c             	mov    %eax,0xc(%ebp)
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	8d 48 01             	lea    0x1(%eax),%ecx
 378:	89 4d 08             	mov    %ecx,0x8(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(const char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	push   0xc(%ebp)
 3fc:	ff 75 08             	push   0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	38 45 fc             	cmp    %al,-0x4(%ebp)
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 83 01 00 00       	call   5e1 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	39 45 0c             	cmp    %eax,0xc(%ebp)
 499:	7f b3                	jg     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
      break;
 49d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(const char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	push   0x8(%ebp)
 4bc:	e8 48 01 00 00       	call   609 <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	push   0xc(%ebp)
 4da:	ff 75 f4             	push   -0xc(%ebp)
 4dd:	e8 3f 01 00 00       	call   621 <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	push   -0xc(%ebp)
 4ee:	e8 fe 00 00 00       	call   5f1 <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 508:	eb 25                	jmp    52f <atoi+0x34>
    n = n*10 + *s++ - '0';
 50a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 50d:	89 d0                	mov    %edx,%eax
 50f:	c1 e0 02             	shl    $0x2,%eax
 512:	01 d0                	add    %edx,%eax
 514:	01 c0                	add    %eax,%eax
 516:	89 c1                	mov    %eax,%ecx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 08             	mov    %edx,0x8(%ebp)
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	01 c8                	add    %ecx,%eax
 529:	83 e8 30             	sub    $0x30,%eax
 52c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	3c 2f                	cmp    $0x2f,%al
 537:	7e 0a                	jle    543 <atoi+0x48>
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	3c 39                	cmp    $0x39,%al
 541:	7e c7                	jle    50a <atoi+0xf>
  return n;
 543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 546:	c9                   	leave  
 547:	c3                   	ret    

00000548 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 55a:	eb 17                	jmp    573 <memmove+0x2b>
    *dst++ = *src++;
 55c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 55f:	8d 42 01             	lea    0x1(%edx),%eax
 562:	89 45 f8             	mov    %eax,-0x8(%ebp)
 565:	8b 45 fc             	mov    -0x4(%ebp),%eax
 568:	8d 48 01             	lea    0x1(%eax),%ecx
 56b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 56e:	0f b6 12             	movzbl (%edx),%edx
 571:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 573:	8b 45 10             	mov    0x10(%ebp),%eax
 576:	8d 50 ff             	lea    -0x1(%eax),%edx
 579:	89 55 10             	mov    %edx,0x10(%ebp)
 57c:	85 c0                	test   %eax,%eax
 57e:	7f dc                	jg     55c <memmove+0x14>
  return vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
}
 583:	c9                   	leave  
 584:	c3                   	ret    

00000585 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 585:	55                   	push   %ebp
 586:	89 e5                	mov    %esp,%ebp

}
 588:	90                   	nop
 589:	5d                   	pop    %ebp
 58a:	c3                   	ret    

0000058b <acquireLock>:

void acquireLock(struct lock* l) {
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp

}
 58e:	90                   	nop
 58f:	5d                   	pop    %ebp
 590:	c3                   	ret    

00000591 <releaseLock>:

void releaseLock(struct lock* l) {
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp

}
 594:	90                   	nop
 595:	5d                   	pop    %ebp
 596:	c3                   	ret    

00000597 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp

}
 59a:	90                   	nop
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    

0000059d <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 59d:	55                   	push   %ebp
 59e:	89 e5                	mov    %esp,%ebp

}
 5a0:	90                   	nop
 5a1:	5d                   	pop    %ebp
 5a2:	c3                   	ret    

000005a3 <broadcast>:

void broadcast(struct condvar* cv) {
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp

}
 5a6:	90                   	nop
 5a7:	5d                   	pop    %ebp
 5a8:	c3                   	ret    

000005a9 <signal>:

void signal(struct condvar* cv) {
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp

}
 5ac:	90                   	nop
 5ad:	5d                   	pop    %ebp
 5ae:	c3                   	ret    

000005af <semInit>:

void semInit(struct semaphore* s, int initVal) {
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp

}
 5b2:	90                   	nop
 5b3:	5d                   	pop    %ebp
 5b4:	c3                   	ret    

000005b5 <semUp>:

void semUp(struct semaphore* s) {
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp

}
 5b8:	90                   	nop
 5b9:	5d                   	pop    %ebp
 5ba:	c3                   	ret    

000005bb <semDown>:

void semDown(struct semaphore* s) {
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp

}
 5be:	90                   	nop
 5bf:	5d                   	pop    %ebp
 5c0:	c3                   	ret    

000005c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c1:	b8 01 00 00 00       	mov    $0x1,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <exit>:
SYSCALL(exit)
 5c9:	b8 02 00 00 00       	mov    $0x2,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <wait>:
SYSCALL(wait)
 5d1:	b8 03 00 00 00       	mov    $0x3,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <pipe>:
SYSCALL(pipe)
 5d9:	b8 04 00 00 00       	mov    $0x4,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <read>:
SYSCALL(read)
 5e1:	b8 05 00 00 00       	mov    $0x5,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <write>:
SYSCALL(write)
 5e9:	b8 10 00 00 00       	mov    $0x10,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <close>:
SYSCALL(close)
 5f1:	b8 15 00 00 00       	mov    $0x15,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <kill>:
SYSCALL(kill)
 5f9:	b8 06 00 00 00       	mov    $0x6,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <exec>:
SYSCALL(exec)
 601:	b8 07 00 00 00       	mov    $0x7,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <open>:
SYSCALL(open)
 609:	b8 0f 00 00 00       	mov    $0xf,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <mknod>:
SYSCALL(mknod)
 611:	b8 11 00 00 00       	mov    $0x11,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <unlink>:
SYSCALL(unlink)
 619:	b8 12 00 00 00       	mov    $0x12,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <fstat>:
SYSCALL(fstat)
 621:	b8 08 00 00 00       	mov    $0x8,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <link>:
SYSCALL(link)
 629:	b8 13 00 00 00       	mov    $0x13,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <mkdir>:
SYSCALL(mkdir)
 631:	b8 14 00 00 00       	mov    $0x14,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <chdir>:
SYSCALL(chdir)
 639:	b8 09 00 00 00       	mov    $0x9,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <dup>:
SYSCALL(dup)
 641:	b8 0a 00 00 00       	mov    $0xa,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <getpid>:
SYSCALL(getpid)
 649:	b8 0b 00 00 00       	mov    $0xb,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <sbrk>:
SYSCALL(sbrk)
 651:	b8 0c 00 00 00       	mov    $0xc,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <sleep>:
SYSCALL(sleep)
 659:	b8 0d 00 00 00       	mov    $0xd,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <uptime>:
SYSCALL(uptime)
 661:	b8 0e 00 00 00       	mov    $0xe,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <thread_create>:
SYSCALL(thread_create)
 669:	b8 16 00 00 00       	mov    $0x16,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <thread_exit>:
SYSCALL(thread_exit)
 671:	b8 17 00 00 00       	mov    $0x17,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <thread_join>:
SYSCALL(thread_join)
 679:	b8 18 00 00 00       	mov    $0x18,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <waitpid>:
SYSCALL(waitpid)
 681:	b8 1e 00 00 00       	mov    $0x1e,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <barrier_init>:
SYSCALL(barrier_init)
 689:	b8 1f 00 00 00       	mov    $0x1f,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <barrier_check>:
SYSCALL(barrier_check)
 691:	b8 20 00 00 00       	mov    $0x20,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <sleepChan>:
SYSCALL(sleepChan)
 699:	b8 24 00 00 00       	mov    $0x24,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <getChannel>:
SYSCALL(getChannel)
 6a1:	b8 25 00 00 00       	mov    $0x25,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <sigChan>:
SYSCALL(sigChan)
 6a9:	b8 26 00 00 00       	mov    $0x26,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <sigOneChan>:
 6b1:	b8 27 00 00 00       	mov    $0x27,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b9:	55                   	push   %ebp
 6ba:	89 e5                	mov    %esp,%ebp
 6bc:	83 ec 18             	sub    $0x18,%esp
 6bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6c5:	83 ec 04             	sub    $0x4,%esp
 6c8:	6a 01                	push   $0x1
 6ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6cd:	50                   	push   %eax
 6ce:	ff 75 08             	push   0x8(%ebp)
 6d1:	e8 13 ff ff ff       	call   5e9 <write>
 6d6:	83 c4 10             	add    $0x10,%esp
}
 6d9:	90                   	nop
 6da:	c9                   	leave  
 6db:	c3                   	ret    

000006dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ed:	74 17                	je     706 <printint+0x2a>
 6ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f3:	79 11                	jns    706 <printint+0x2a>
    neg = 1;
 6f5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ff:	f7 d8                	neg    %eax
 701:	89 45 ec             	mov    %eax,-0x14(%ebp)
 704:	eb 06                	jmp    70c <printint+0x30>
  } else {
    x = xx;
 706:	8b 45 0c             	mov    0xc(%ebp),%eax
 709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 70c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 713:	8b 4d 10             	mov    0x10(%ebp),%ecx
 716:	8b 45 ec             	mov    -0x14(%ebp),%eax
 719:	ba 00 00 00 00       	mov    $0x0,%edx
 71e:	f7 f1                	div    %ecx
 720:	89 d1                	mov    %edx,%ecx
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	8d 50 01             	lea    0x1(%eax),%edx
 728:	89 55 f4             	mov    %edx,-0xc(%ebp)
 72b:	0f b6 91 8c 0f 00 00 	movzbl 0xf8c(%ecx),%edx
 732:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 736:	8b 4d 10             	mov    0x10(%ebp),%ecx
 739:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73c:	ba 00 00 00 00       	mov    $0x0,%edx
 741:	f7 f1                	div    %ecx
 743:	89 45 ec             	mov    %eax,-0x14(%ebp)
 746:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74a:	75 c7                	jne    713 <printint+0x37>
  if(neg)
 74c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 750:	74 2d                	je     77f <printint+0xa3>
    buf[i++] = '-';
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8d 50 01             	lea    0x1(%eax),%edx
 758:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 760:	eb 1d                	jmp    77f <printint+0xa3>
    putc(fd, buf[i]);
 762:	8d 55 dc             	lea    -0x24(%ebp),%edx
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	01 d0                	add    %edx,%eax
 76a:	0f b6 00             	movzbl (%eax),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	83 ec 08             	sub    $0x8,%esp
 773:	50                   	push   %eax
 774:	ff 75 08             	push   0x8(%ebp)
 777:	e8 3d ff ff ff       	call   6b9 <putc>
 77c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 77f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 787:	79 d9                	jns    762 <printint+0x86>
}
 789:	90                   	nop
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 792:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 799:	8d 45 0c             	lea    0xc(%ebp),%eax
 79c:	83 c0 04             	add    $0x4,%eax
 79f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a9:	e9 59 01 00 00       	jmp    907 <printf+0x17b>
    c = fmt[i] & 0xff;
 7ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	01 d0                	add    %edx,%eax
 7b6:	0f b6 00             	movzbl (%eax),%eax
 7b9:	0f be c0             	movsbl %al,%eax
 7bc:	25 ff 00 00 00       	and    $0xff,%eax
 7c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c8:	75 2c                	jne    7f6 <printf+0x6a>
      if(c == '%'){
 7ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ce:	75 0c                	jne    7dc <printf+0x50>
        state = '%';
 7d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d7:	e9 27 01 00 00       	jmp    903 <printf+0x177>
      } else {
        putc(fd, c);
 7dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7df:	0f be c0             	movsbl %al,%eax
 7e2:	83 ec 08             	sub    $0x8,%esp
 7e5:	50                   	push   %eax
 7e6:	ff 75 08             	push   0x8(%ebp)
 7e9:	e8 cb fe ff ff       	call   6b9 <putc>
 7ee:	83 c4 10             	add    $0x10,%esp
 7f1:	e9 0d 01 00 00       	jmp    903 <printf+0x177>
      }
    } else if(state == '%'){
 7f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7fa:	0f 85 03 01 00 00    	jne    903 <printf+0x177>
      if(c == 'd'){
 800:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 804:	75 1e                	jne    824 <printf+0x98>
        printint(fd, *ap, 10, 1);
 806:	8b 45 e8             	mov    -0x18(%ebp),%eax
 809:	8b 00                	mov    (%eax),%eax
 80b:	6a 01                	push   $0x1
 80d:	6a 0a                	push   $0xa
 80f:	50                   	push   %eax
 810:	ff 75 08             	push   0x8(%ebp)
 813:	e8 c4 fe ff ff       	call   6dc <printint>
 818:	83 c4 10             	add    $0x10,%esp
        ap++;
 81b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81f:	e9 d8 00 00 00       	jmp    8fc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 824:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 828:	74 06                	je     830 <printf+0xa4>
 82a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 82e:	75 1e                	jne    84e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 830:	8b 45 e8             	mov    -0x18(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	6a 00                	push   $0x0
 837:	6a 10                	push   $0x10
 839:	50                   	push   %eax
 83a:	ff 75 08             	push   0x8(%ebp)
 83d:	e8 9a fe ff ff       	call   6dc <printint>
 842:	83 c4 10             	add    $0x10,%esp
        ap++;
 845:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 849:	e9 ae 00 00 00       	jmp    8fc <printf+0x170>
      } else if(c == 's'){
 84e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 852:	75 43                	jne    897 <printf+0x10b>
        s = (char*)*ap;
 854:	8b 45 e8             	mov    -0x18(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 85c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 864:	75 25                	jne    88b <printf+0xff>
          s = "(null)";
 866:	c7 45 f4 7a 0b 00 00 	movl   $0xb7a,-0xc(%ebp)
        while(*s != 0){
 86d:	eb 1c                	jmp    88b <printf+0xff>
          putc(fd, *s);
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	0f b6 00             	movzbl (%eax),%eax
 875:	0f be c0             	movsbl %al,%eax
 878:	83 ec 08             	sub    $0x8,%esp
 87b:	50                   	push   %eax
 87c:	ff 75 08             	push   0x8(%ebp)
 87f:	e8 35 fe ff ff       	call   6b9 <putc>
 884:	83 c4 10             	add    $0x10,%esp
          s++;
 887:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	0f b6 00             	movzbl (%eax),%eax
 891:	84 c0                	test   %al,%al
 893:	75 da                	jne    86f <printf+0xe3>
 895:	eb 65                	jmp    8fc <printf+0x170>
        }
      } else if(c == 'c'){
 897:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 89b:	75 1d                	jne    8ba <printf+0x12e>
        putc(fd, *ap);
 89d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	0f be c0             	movsbl %al,%eax
 8a5:	83 ec 08             	sub    $0x8,%esp
 8a8:	50                   	push   %eax
 8a9:	ff 75 08             	push   0x8(%ebp)
 8ac:	e8 08 fe ff ff       	call   6b9 <putc>
 8b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b8:	eb 42                	jmp    8fc <printf+0x170>
      } else if(c == '%'){
 8ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8be:	75 17                	jne    8d7 <printf+0x14b>
        putc(fd, c);
 8c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c3:	0f be c0             	movsbl %al,%eax
 8c6:	83 ec 08             	sub    $0x8,%esp
 8c9:	50                   	push   %eax
 8ca:	ff 75 08             	push   0x8(%ebp)
 8cd:	e8 e7 fd ff ff       	call   6b9 <putc>
 8d2:	83 c4 10             	add    $0x10,%esp
 8d5:	eb 25                	jmp    8fc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d7:	83 ec 08             	sub    $0x8,%esp
 8da:	6a 25                	push   $0x25
 8dc:	ff 75 08             	push   0x8(%ebp)
 8df:	e8 d5 fd ff ff       	call   6b9 <putc>
 8e4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ea:	0f be c0             	movsbl %al,%eax
 8ed:	83 ec 08             	sub    $0x8,%esp
 8f0:	50                   	push   %eax
 8f1:	ff 75 08             	push   0x8(%ebp)
 8f4:	e8 c0 fd ff ff       	call   6b9 <putc>
 8f9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 903:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 907:	8b 55 0c             	mov    0xc(%ebp),%edx
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	01 d0                	add    %edx,%eax
 90f:	0f b6 00             	movzbl (%eax),%eax
 912:	84 c0                	test   %al,%al
 914:	0f 85 94 fe ff ff    	jne    7ae <printf+0x22>
    }
  }
}
 91a:	90                   	nop
 91b:	c9                   	leave  
 91c:	c3                   	ret    

0000091d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91d:	55                   	push   %ebp
 91e:	89 e5                	mov    %esp,%ebp
 920:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 923:	8b 45 08             	mov    0x8(%ebp),%eax
 926:	83 e8 08             	sub    $0x8,%eax
 929:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	a1 a8 0f 00 00       	mov    0xfa8,%eax
 931:	89 45 fc             	mov    %eax,-0x4(%ebp)
 934:	eb 24                	jmp    95a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 93e:	72 12                	jb     952 <free+0x35>
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 946:	77 24                	ja     96c <free+0x4f>
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 950:	72 1a                	jb     96c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 00                	mov    (%eax),%eax
 957:	89 45 fc             	mov    %eax,-0x4(%ebp)
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 960:	76 d4                	jbe    936 <free+0x19>
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 96a:	73 ca                	jae    936 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	8b 40 04             	mov    0x4(%eax),%eax
 972:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 979:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97c:	01 c2                	add    %eax,%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	39 c2                	cmp    %eax,%edx
 985:	75 24                	jne    9ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	8b 50 04             	mov    0x4(%eax),%edx
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	01 c2                	add    %eax,%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	8b 10                	mov    (%eax),%edx
 9a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a7:	89 10                	mov    %edx,(%eax)
 9a9:	eb 0a                	jmp    9b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	8b 10                	mov    (%eax),%edx
 9b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 40 04             	mov    0x4(%eax),%eax
 9bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	01 d0                	add    %edx,%eax
 9c7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9ca:	75 20                	jne    9ec <free+0xcf>
    p->s.size += bp->s.size;
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 50 04             	mov    0x4(%eax),%edx
 9d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	01 c2                	add    %eax,%edx
 9da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e3:	8b 10                	mov    (%eax),%edx
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	89 10                	mov    %edx,(%eax)
 9ea:	eb 08                	jmp    9f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f7:	a3 a8 0f 00 00       	mov    %eax,0xfa8
}
 9fc:	90                   	nop
 9fd:	c9                   	leave  
 9fe:	c3                   	ret    

000009ff <morecore>:

static Header*
morecore(uint nu)
{
 9ff:	55                   	push   %ebp
 a00:	89 e5                	mov    %esp,%ebp
 a02:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a05:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a0c:	77 07                	ja     a15 <morecore+0x16>
    nu = 4096;
 a0e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a15:	8b 45 08             	mov    0x8(%ebp),%eax
 a18:	c1 e0 03             	shl    $0x3,%eax
 a1b:	83 ec 0c             	sub    $0xc,%esp
 a1e:	50                   	push   %eax
 a1f:	e8 2d fc ff ff       	call   651 <sbrk>
 a24:	83 c4 10             	add    $0x10,%esp
 a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a2a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a2e:	75 07                	jne    a37 <morecore+0x38>
    return 0;
 a30:	b8 00 00 00 00       	mov    $0x0,%eax
 a35:	eb 26                	jmp    a5d <morecore+0x5e>
  hp = (Header*)p;
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a40:	8b 55 08             	mov    0x8(%ebp),%edx
 a43:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a49:	83 c0 08             	add    $0x8,%eax
 a4c:	83 ec 0c             	sub    $0xc,%esp
 a4f:	50                   	push   %eax
 a50:	e8 c8 fe ff ff       	call   91d <free>
 a55:	83 c4 10             	add    $0x10,%esp
  return freep;
 a58:	a1 a8 0f 00 00       	mov    0xfa8,%eax
}
 a5d:	c9                   	leave  
 a5e:	c3                   	ret    

00000a5f <malloc>:

void*
malloc(uint nbytes)
{
 a5f:	55                   	push   %ebp
 a60:	89 e5                	mov    %esp,%ebp
 a62:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	83 c0 07             	add    $0x7,%eax
 a6b:	c1 e8 03             	shr    $0x3,%eax
 a6e:	83 c0 01             	add    $0x1,%eax
 a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a74:	a1 a8 0f 00 00       	mov    0xfa8,%eax
 a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a80:	75 23                	jne    aa5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a82:	c7 45 f0 a0 0f 00 00 	movl   $0xfa0,-0x10(%ebp)
 a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8c:	a3 a8 0f 00 00       	mov    %eax,0xfa8
 a91:	a1 a8 0f 00 00       	mov    0xfa8,%eax
 a96:	a3 a0 0f 00 00       	mov    %eax,0xfa0
    base.s.size = 0;
 a9b:	c7 05 a4 0f 00 00 00 	movl   $0x0,0xfa4
 aa2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	8b 40 04             	mov    0x4(%eax),%eax
 ab3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ab6:	77 4d                	ja     b05 <malloc+0xa6>
      if(p->s.size == nunits)
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ac1:	75 0c                	jne    acf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 10                	mov    (%eax),%edx
 ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acb:	89 10                	mov    %edx,(%eax)
 acd:	eb 26                	jmp    af5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8b 40 04             	mov    0x4(%eax),%eax
 ad5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad8:	89 c2                	mov    %eax,%edx
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae3:	8b 40 04             	mov    0x4(%eax),%eax
 ae6:	c1 e0 03             	shl    $0x3,%eax
 ae9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 af2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af8:	a3 a8 0f 00 00       	mov    %eax,0xfa8
      return (void*)(p + 1);
 afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b00:	83 c0 08             	add    $0x8,%eax
 b03:	eb 3b                	jmp    b40 <malloc+0xe1>
    }
    if(p == freep)
 b05:	a1 a8 0f 00 00       	mov    0xfa8,%eax
 b0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b0d:	75 1e                	jne    b2d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b0f:	83 ec 0c             	sub    $0xc,%esp
 b12:	ff 75 ec             	push   -0x14(%ebp)
 b15:	e8 e5 fe ff ff       	call   9ff <morecore>
 b1a:	83 c4 10             	add    $0x10,%esp
 b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b24:	75 07                	jne    b2d <malloc+0xce>
        return 0;
 b26:	b8 00 00 00 00       	mov    $0x0,%eax
 b2b:	eb 13                	jmp    b40 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b36:	8b 00                	mov    (%eax),%eax
 b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b3b:	e9 6d ff ff ff       	jmp    aad <malloc+0x4e>
  }
}
 b40:	c9                   	leave  
 b41:	c3                   	ret    
