
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	push   0x8(%ebp)
   d:	e8 c9 03 00 00       	call   3db <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	push   -0xc(%ebp)
  41:	e8 95 03 00 00       	call   3db <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	push   -0xc(%ebp)
  59:	e8 7d 03 00 00       	call   3db <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	push   -0xc(%ebp)
  68:	68 94 0f 00 00       	push   $0xf94
  6d:	e8 e6 04 00 00       	call   558 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	push   -0xc(%ebp)
  7b:	e8 5b 03 00 00       	call   3db <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	push   -0xc(%ebp)
  92:	e8 44 03 00 00       	call   3db <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 94 0f 00 00       	add    $0xf94,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 94 0f 00 00       	mov    $0xf94,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	push   0x8(%ebp)
  cc:	e8 48 05 00 00       	call   619 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	push   0x8(%ebp)
  e3:	68 52 0b 00 00       	push   $0xb52
  e8:	6a 02                	push   $0x2
  ea:	e8 ad 06 00 00       	call   79c <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }

  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	push   -0x1c(%ebp)
 104:	e8 28 05 00 00       	call   631 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	push   0x8(%ebp)
 116:	68 66 0b 00 00       	push   $0xb66
 11b:	6a 02                	push   $0x2
 11d:	e8 7a 06 00 00       	call   79c <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	push   -0x1c(%ebp)
 12b:	e8 d1 04 00 00       	call   601 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }

  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	push   0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 7a 0b 00 00       	push   $0xb7a
 17e:	6a 01                	push   $0x1
 180:	e8 17 06 00 00       	call   79c <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	push   0x8(%ebp)
 193:	e8 43 02 00 00       	call   3db <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 87 0b 00 00       	push   $0xb87
 1ad:	6a 01                	push   $0x1
 1af:	e8 e8 05 00 00       	call   79c <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	push   0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9e 01 00 00       	call   36c <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fb 01 00 00       	call   3db <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	push   -0x20(%ebp)
 224:	e8 2f 03 00 00       	call   558 <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 73 02 00 00       	call   4be <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 66 0b 00 00       	push   $0xb66
 261:	6a 01                	push   $0x1
 263:	e8 34 05 00 00       	call   79c <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 7a 0b 00 00       	push   $0xb7a
 2a1:	6a 01                	push   $0x1
 2a3:	e8 f4 04 00 00       	call   79c <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	push   -0x1c(%ebp)
 2ba:	e8 32 03 00 00       	call   5f1 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	push   -0x1c(%ebp)
 2d2:	e8 2a 03 00 00       	call   601 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	push   -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 9a 0b 00 00       	push   $0xb9a
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 c9 02 00 00       	call   5d9 <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
  exit();
 341:	e8 93 02 00 00       	call   5d9 <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	90                   	nop
 368:	5b                   	pop    %ebx
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 378:	90                   	nop
 379:	8b 55 0c             	mov    0xc(%ebp),%edx
 37c:	8d 42 01             	lea    0x1(%edx),%eax
 37f:	89 45 0c             	mov    %eax,0xc(%ebp)
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	8d 48 01             	lea    0x1(%eax),%ecx
 388:	89 4d 08             	mov    %ecx,0x8(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strcpy+0xd>
    ;
  return os;
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39f:	eb 08                	jmp    3a9 <strcmp+0xd>
    p++, q++;
 3a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 10                	je     3c3 <strcmp+0x27>
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 10             	movzbl (%eax),%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	38 c2                	cmp    %al,%dl
 3c1:	74 de                	je     3a1 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	0f b6 d0             	movzbl %al,%edx
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	0f b6 c0             	movzbl %al,%eax
 3d5:	29 c2                	sub    %eax,%edx
 3d7:	89 d0                	mov    %edx,%eax
}
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <strlen>:

uint
strlen(const char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e8:	eb 04                	jmp    3ee <strlen+0x13>
 3ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	75 ed                	jne    3ea <strlen+0xf>
    ;
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 0c             	push   0xc(%ebp)
 40c:	ff 75 08             	push   0x8(%ebp)
 40f:	e8 32 ff ff ff       	call   346 <stosb>
 414:	83 c4 0c             	add    $0xc,%esp
  return dst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 428:	eb 14                	jmp    43e <strchr+0x22>
    if(*s == c)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	38 45 fc             	cmp    %al,-0x4(%ebp)
 433:	75 05                	jne    43a <strchr+0x1e>
      return (char*)s;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	eb 13                	jmp    44d <strchr+0x31>
  for(; *s; s++)
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strchr+0xe>
  return 0;
 448:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <gets>:

char*
gets(char *buf, int max)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45c:	eb 42                	jmp    4a0 <gets+0x51>
    cc = read(0, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 ef             	lea    -0x11(%ebp),%eax
 466:	50                   	push   %eax
 467:	6a 00                	push   $0x0
 469:	e8 83 01 00 00       	call   5f1 <read>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	7e 33                	jle    4ad <gets+0x5e>
      break;
    buf[i++] = c;
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 c2                	add    %eax,%edx
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 16                	je     4ae <gets+0x5f>
 498:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49c:	3c 0d                	cmp    $0xd,%al
 49e:	74 0e                	je     4ae <gets+0x5f>
  for(i=0; i+1 < max; ){
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	83 c0 01             	add    $0x1,%eax
 4a6:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4a9:	7f b3                	jg     45e <gets+0xf>
 4ab:	eb 01                	jmp    4ae <gets+0x5f>
      break;
 4ad:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	c9                   	leave  
 4bd:	c3                   	ret    

000004be <stat>:

int
stat(const char *n, struct stat *st)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	push   0x8(%ebp)
 4cc:	e8 48 01 00 00       	call   619 <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x26>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4b>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	push   0xc(%ebp)
 4ea:	ff 75 f4             	push   -0xc(%ebp)
 4ed:	e8 3f 01 00 00       	call   631 <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	push   -0xc(%ebp)
 4fe:	e8 fe 00 00 00       	call   601 <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 518:	eb 25                	jmp    53f <atoi+0x34>
    n = n*10 + *s++ - '0';
 51a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51d:	89 d0                	mov    %edx,%eax
 51f:	c1 e0 02             	shl    $0x2,%eax
 522:	01 d0                	add    %edx,%eax
 524:	01 c0                	add    %eax,%eax
 526:	89 c1                	mov    %eax,%ecx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	8d 50 01             	lea    0x1(%eax),%edx
 52e:	89 55 08             	mov    %edx,0x8(%ebp)
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	01 c8                	add    %ecx,%eax
 539:	83 e8 30             	sub    $0x30,%eax
 53c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	3c 2f                	cmp    $0x2f,%al
 547:	7e 0a                	jle    553 <atoi+0x48>
 549:	8b 45 08             	mov    0x8(%ebp),%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	3c 39                	cmp    $0x39,%al
 551:	7e c7                	jle    51a <atoi+0xf>
  return n;
 553:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 556:	c9                   	leave  
 557:	c3                   	ret    

00000558 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 564:	8b 45 0c             	mov    0xc(%ebp),%eax
 567:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 56a:	eb 17                	jmp    583 <memmove+0x2b>
    *dst++ = *src++;
 56c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 56f:	8d 42 01             	lea    0x1(%edx),%eax
 572:	89 45 f8             	mov    %eax,-0x8(%ebp)
 575:	8b 45 fc             	mov    -0x4(%ebp),%eax
 578:	8d 48 01             	lea    0x1(%eax),%ecx
 57b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 57e:	0f b6 12             	movzbl (%edx),%edx
 581:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 583:	8b 45 10             	mov    0x10(%ebp),%eax
 586:	8d 50 ff             	lea    -0x1(%eax),%edx
 589:	89 55 10             	mov    %edx,0x10(%ebp)
 58c:	85 c0                	test   %eax,%eax
 58e:	7f dc                	jg     56c <memmove+0x14>
  return vdst;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp

}
 598:	90                   	nop
 599:	5d                   	pop    %ebp
 59a:	c3                   	ret    

0000059b <acquireLock>:

void acquireLock(struct lock* l) {
 59b:	55                   	push   %ebp
 59c:	89 e5                	mov    %esp,%ebp

}
 59e:	90                   	nop
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret    

000005a1 <releaseLock>:

void releaseLock(struct lock* l) {
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp

}
 5a4:	90                   	nop
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    

000005a7 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp

}
 5aa:	90                   	nop
 5ab:	5d                   	pop    %ebp
 5ac:	c3                   	ret    

000005ad <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
 5ad:	55                   	push   %ebp
 5ae:	89 e5                	mov    %esp,%ebp

}
 5b0:	90                   	nop
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    

000005b3 <broadcast>:

void broadcast(struct condvar* cv) {
 5b3:	55                   	push   %ebp
 5b4:	89 e5                	mov    %esp,%ebp

}
 5b6:	90                   	nop
 5b7:	5d                   	pop    %ebp
 5b8:	c3                   	ret    

000005b9 <signal>:

void signal(struct condvar* cv) {
 5b9:	55                   	push   %ebp
 5ba:	89 e5                	mov    %esp,%ebp

}
 5bc:	90                   	nop
 5bd:	5d                   	pop    %ebp
 5be:	c3                   	ret    

000005bf <semInit>:

void semInit(struct semaphore* s, int initVal) {
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp

}
 5c2:	90                   	nop
 5c3:	5d                   	pop    %ebp
 5c4:	c3                   	ret    

000005c5 <semUp>:

void semUp(struct semaphore* s) {
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp

}
 5c8:	90                   	nop
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret    

000005cb <semDown>:

void semDown(struct semaphore* s) {
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp

}
 5ce:	90                   	nop
 5cf:	5d                   	pop    %ebp
 5d0:	c3                   	ret    

000005d1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5d1:	b8 01 00 00 00       	mov    $0x1,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <exit>:
SYSCALL(exit)
 5d9:	b8 02 00 00 00       	mov    $0x2,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <wait>:
SYSCALL(wait)
 5e1:	b8 03 00 00 00       	mov    $0x3,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <pipe>:
SYSCALL(pipe)
 5e9:	b8 04 00 00 00       	mov    $0x4,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <read>:
SYSCALL(read)
 5f1:	b8 05 00 00 00       	mov    $0x5,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <write>:
SYSCALL(write)
 5f9:	b8 10 00 00 00       	mov    $0x10,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <close>:
SYSCALL(close)
 601:	b8 15 00 00 00       	mov    $0x15,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <kill>:
SYSCALL(kill)
 609:	b8 06 00 00 00       	mov    $0x6,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <exec>:
SYSCALL(exec)
 611:	b8 07 00 00 00       	mov    $0x7,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <open>:
SYSCALL(open)
 619:	b8 0f 00 00 00       	mov    $0xf,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <mknod>:
SYSCALL(mknod)
 621:	b8 11 00 00 00       	mov    $0x11,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <unlink>:
SYSCALL(unlink)
 629:	b8 12 00 00 00       	mov    $0x12,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <fstat>:
SYSCALL(fstat)
 631:	b8 08 00 00 00       	mov    $0x8,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <link>:
SYSCALL(link)
 639:	b8 13 00 00 00       	mov    $0x13,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <mkdir>:
SYSCALL(mkdir)
 641:	b8 14 00 00 00       	mov    $0x14,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <chdir>:
SYSCALL(chdir)
 649:	b8 09 00 00 00       	mov    $0x9,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <dup>:
SYSCALL(dup)
 651:	b8 0a 00 00 00       	mov    $0xa,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <getpid>:
SYSCALL(getpid)
 659:	b8 0b 00 00 00       	mov    $0xb,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <sbrk>:
SYSCALL(sbrk)
 661:	b8 0c 00 00 00       	mov    $0xc,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <sleep>:
SYSCALL(sleep)
 669:	b8 0d 00 00 00       	mov    $0xd,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <uptime>:
SYSCALL(uptime)
 671:	b8 0e 00 00 00       	mov    $0xe,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <thread_create>:
SYSCALL(thread_create)
 679:	b8 16 00 00 00       	mov    $0x16,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <thread_exit>:
SYSCALL(thread_exit)
 681:	b8 17 00 00 00       	mov    $0x17,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <thread_join>:
SYSCALL(thread_join)
 689:	b8 18 00 00 00       	mov    $0x18,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <waitpid>:
SYSCALL(waitpid)
 691:	b8 1e 00 00 00       	mov    $0x1e,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <barrier_init>:
SYSCALL(barrier_init)
 699:	b8 1f 00 00 00       	mov    $0x1f,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <barrier_check>:
SYSCALL(barrier_check)
 6a1:	b8 20 00 00 00       	mov    $0x20,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <sleepChan>:
SYSCALL(sleepChan)
 6a9:	b8 24 00 00 00       	mov    $0x24,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <getChannel>:
SYSCALL(getChannel)
 6b1:	b8 25 00 00 00       	mov    $0x25,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <sigChan>:
SYSCALL(sigChan)
 6b9:	b8 26 00 00 00       	mov    $0x26,%eax
 6be:	cd 40                	int    $0x40
 6c0:	c3                   	ret    

000006c1 <sigOneChan>:
 6c1:	b8 27 00 00 00       	mov    $0x27,%eax
 6c6:	cd 40                	int    $0x40
 6c8:	c3                   	ret    

000006c9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	83 ec 18             	sub    $0x18,%esp
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6d5:	83 ec 04             	sub    $0x4,%esp
 6d8:	6a 01                	push   $0x1
 6da:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	push   0x8(%ebp)
 6e1:	e8 13 ff ff ff       	call   5f9 <write>
 6e6:	83 c4 10             	add    $0x10,%esp
}
 6e9:	90                   	nop
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    

000006ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6fd:	74 17                	je     716 <printint+0x2a>
 6ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 703:	79 11                	jns    716 <printint+0x2a>
    neg = 1;
 705:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 70c:	8b 45 0c             	mov    0xc(%ebp),%eax
 70f:	f7 d8                	neg    %eax
 711:	89 45 ec             	mov    %eax,-0x14(%ebp)
 714:	eb 06                	jmp    71c <printint+0x30>
  } else {
    x = xx;
 716:	8b 45 0c             	mov    0xc(%ebp),%eax
 719:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 71c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 723:	8b 4d 10             	mov    0x10(%ebp),%ecx
 726:	8b 45 ec             	mov    -0x14(%ebp),%eax
 729:	ba 00 00 00 00       	mov    $0x0,%edx
 72e:	f7 f1                	div    %ecx
 730:	89 d1                	mov    %edx,%ecx
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	8d 50 01             	lea    0x1(%eax),%edx
 738:	89 55 f4             	mov    %edx,-0xc(%ebp)
 73b:	0f b6 91 80 0f 00 00 	movzbl 0xf80(%ecx),%edx
 742:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 746:	8b 4d 10             	mov    0x10(%ebp),%ecx
 749:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74c:	ba 00 00 00 00       	mov    $0x0,%edx
 751:	f7 f1                	div    %ecx
 753:	89 45 ec             	mov    %eax,-0x14(%ebp)
 756:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 75a:	75 c7                	jne    723 <printint+0x37>
  if(neg)
 75c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 760:	74 2d                	je     78f <printint+0xa3>
    buf[i++] = '-';
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8d 50 01             	lea    0x1(%eax),%edx
 768:	89 55 f4             	mov    %edx,-0xc(%ebp)
 76b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 770:	eb 1d                	jmp    78f <printint+0xa3>
    putc(fd, buf[i]);
 772:	8d 55 dc             	lea    -0x24(%ebp),%edx
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	0f b6 00             	movzbl (%eax),%eax
 77d:	0f be c0             	movsbl %al,%eax
 780:	83 ec 08             	sub    $0x8,%esp
 783:	50                   	push   %eax
 784:	ff 75 08             	push   0x8(%ebp)
 787:	e8 3d ff ff ff       	call   6c9 <putc>
 78c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 78f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 797:	79 d9                	jns    772 <printint+0x86>
}
 799:	90                   	nop
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7a9:	8d 45 0c             	lea    0xc(%ebp),%eax
 7ac:	83 c0 04             	add    $0x4,%eax
 7af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7b9:	e9 59 01 00 00       	jmp    917 <printf+0x17b>
    c = fmt[i] & 0xff;
 7be:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	01 d0                	add    %edx,%eax
 7c6:	0f b6 00             	movzbl (%eax),%eax
 7c9:	0f be c0             	movsbl %al,%eax
 7cc:	25 ff 00 00 00       	and    $0xff,%eax
 7d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d8:	75 2c                	jne    806 <printf+0x6a>
      if(c == '%'){
 7da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7de:	75 0c                	jne    7ec <printf+0x50>
        state = '%';
 7e0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7e7:	e9 27 01 00 00       	jmp    913 <printf+0x177>
      } else {
        putc(fd, c);
 7ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	83 ec 08             	sub    $0x8,%esp
 7f5:	50                   	push   %eax
 7f6:	ff 75 08             	push   0x8(%ebp)
 7f9:	e8 cb fe ff ff       	call   6c9 <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	e9 0d 01 00 00       	jmp    913 <printf+0x177>
      }
    } else if(state == '%'){
 806:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 80a:	0f 85 03 01 00 00    	jne    913 <printf+0x177>
      if(c == 'd'){
 810:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 814:	75 1e                	jne    834 <printf+0x98>
        printint(fd, *ap, 10, 1);
 816:	8b 45 e8             	mov    -0x18(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	6a 01                	push   $0x1
 81d:	6a 0a                	push   $0xa
 81f:	50                   	push   %eax
 820:	ff 75 08             	push   0x8(%ebp)
 823:	e8 c4 fe ff ff       	call   6ec <printint>
 828:	83 c4 10             	add    $0x10,%esp
        ap++;
 82b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82f:	e9 d8 00 00 00       	jmp    90c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 834:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 838:	74 06                	je     840 <printf+0xa4>
 83a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 83e:	75 1e                	jne    85e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 840:	8b 45 e8             	mov    -0x18(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	6a 00                	push   $0x0
 847:	6a 10                	push   $0x10
 849:	50                   	push   %eax
 84a:	ff 75 08             	push   0x8(%ebp)
 84d:	e8 9a fe ff ff       	call   6ec <printint>
 852:	83 c4 10             	add    $0x10,%esp
        ap++;
 855:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 859:	e9 ae 00 00 00       	jmp    90c <printf+0x170>
      } else if(c == 's'){
 85e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 862:	75 43                	jne    8a7 <printf+0x10b>
        s = (char*)*ap;
 864:	8b 45 e8             	mov    -0x18(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 86c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 874:	75 25                	jne    89b <printf+0xff>
          s = "(null)";
 876:	c7 45 f4 9c 0b 00 00 	movl   $0xb9c,-0xc(%ebp)
        while(*s != 0){
 87d:	eb 1c                	jmp    89b <printf+0xff>
          putc(fd, *s);
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	0f b6 00             	movzbl (%eax),%eax
 885:	0f be c0             	movsbl %al,%eax
 888:	83 ec 08             	sub    $0x8,%esp
 88b:	50                   	push   %eax
 88c:	ff 75 08             	push   0x8(%ebp)
 88f:	e8 35 fe ff ff       	call   6c9 <putc>
 894:	83 c4 10             	add    $0x10,%esp
          s++;
 897:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	0f b6 00             	movzbl (%eax),%eax
 8a1:	84 c0                	test   %al,%al
 8a3:	75 da                	jne    87f <printf+0xe3>
 8a5:	eb 65                	jmp    90c <printf+0x170>
        }
      } else if(c == 'c'){
 8a7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8ab:	75 1d                	jne    8ca <printf+0x12e>
        putc(fd, *ap);
 8ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	0f be c0             	movsbl %al,%eax
 8b5:	83 ec 08             	sub    $0x8,%esp
 8b8:	50                   	push   %eax
 8b9:	ff 75 08             	push   0x8(%ebp)
 8bc:	e8 08 fe ff ff       	call   6c9 <putc>
 8c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c8:	eb 42                	jmp    90c <printf+0x170>
      } else if(c == '%'){
 8ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ce:	75 17                	jne    8e7 <printf+0x14b>
        putc(fd, c);
 8d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d3:	0f be c0             	movsbl %al,%eax
 8d6:	83 ec 08             	sub    $0x8,%esp
 8d9:	50                   	push   %eax
 8da:	ff 75 08             	push   0x8(%ebp)
 8dd:	e8 e7 fd ff ff       	call   6c9 <putc>
 8e2:	83 c4 10             	add    $0x10,%esp
 8e5:	eb 25                	jmp    90c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8e7:	83 ec 08             	sub    $0x8,%esp
 8ea:	6a 25                	push   $0x25
 8ec:	ff 75 08             	push   0x8(%ebp)
 8ef:	e8 d5 fd ff ff       	call   6c9 <putc>
 8f4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8fa:	0f be c0             	movsbl %al,%eax
 8fd:	83 ec 08             	sub    $0x8,%esp
 900:	50                   	push   %eax
 901:	ff 75 08             	push   0x8(%ebp)
 904:	e8 c0 fd ff ff       	call   6c9 <putc>
 909:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 90c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 913:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 917:	8b 55 0c             	mov    0xc(%ebp),%edx
 91a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91d:	01 d0                	add    %edx,%eax
 91f:	0f b6 00             	movzbl (%eax),%eax
 922:	84 c0                	test   %al,%al
 924:	0f 85 94 fe ff ff    	jne    7be <printf+0x22>
    }
  }
}
 92a:	90                   	nop
 92b:	c9                   	leave  
 92c:	c3                   	ret    

0000092d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92d:	55                   	push   %ebp
 92e:	89 e5                	mov    %esp,%ebp
 930:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 933:	8b 45 08             	mov    0x8(%ebp),%eax
 936:	83 e8 08             	sub    $0x8,%eax
 939:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93c:	a1 ac 0f 00 00       	mov    0xfac,%eax
 941:	89 45 fc             	mov    %eax,-0x4(%ebp)
 944:	eb 24                	jmp    96a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	8b 00                	mov    (%eax),%eax
 94b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 94e:	72 12                	jb     962 <free+0x35>
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 956:	77 24                	ja     97c <free+0x4f>
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	8b 00                	mov    (%eax),%eax
 95d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 960:	72 1a                	jb     97c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	89 45 fc             	mov    %eax,-0x4(%ebp)
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 970:	76 d4                	jbe    946 <free+0x19>
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 00                	mov    (%eax),%eax
 977:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 97a:	73 ca                	jae    946 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 97c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97f:	8b 40 04             	mov    0x4(%eax),%eax
 982:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 989:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98c:	01 c2                	add    %eax,%edx
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	39 c2                	cmp    %eax,%edx
 995:	75 24                	jne    9bb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	8b 50 04             	mov    0x4(%eax),%edx
 99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	01 c2                	add    %eax,%edx
 9a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9aa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	8b 00                	mov    (%eax),%eax
 9b2:	8b 10                	mov    (%eax),%edx
 9b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b7:	89 10                	mov    %edx,(%eax)
 9b9:	eb 0a                	jmp    9c5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 10                	mov    (%eax),%edx
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	8b 40 04             	mov    0x4(%eax),%eax
 9cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d5:	01 d0                	add    %edx,%eax
 9d7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9da:	75 20                	jne    9fc <free+0xcf>
    p->s.size += bp->s.size;
 9dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9df:	8b 50 04             	mov    0x4(%eax),%edx
 9e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e5:	8b 40 04             	mov    0x4(%eax),%eax
 9e8:	01 c2                	add    %eax,%edx
 9ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ed:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f3:	8b 10                	mov    (%eax),%edx
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	89 10                	mov    %edx,(%eax)
 9fa:	eb 08                	jmp    a04 <free+0xd7>
  } else
    p->s.ptr = bp;
 9fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a02:	89 10                	mov    %edx,(%eax)
  freep = p;
 a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a07:	a3 ac 0f 00 00       	mov    %eax,0xfac
}
 a0c:	90                   	nop
 a0d:	c9                   	leave  
 a0e:	c3                   	ret    

00000a0f <morecore>:

static Header*
morecore(uint nu)
{
 a0f:	55                   	push   %ebp
 a10:	89 e5                	mov    %esp,%ebp
 a12:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a15:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a1c:	77 07                	ja     a25 <morecore+0x16>
    nu = 4096;
 a1e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a25:	8b 45 08             	mov    0x8(%ebp),%eax
 a28:	c1 e0 03             	shl    $0x3,%eax
 a2b:	83 ec 0c             	sub    $0xc,%esp
 a2e:	50                   	push   %eax
 a2f:	e8 2d fc ff ff       	call   661 <sbrk>
 a34:	83 c4 10             	add    $0x10,%esp
 a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a3e:	75 07                	jne    a47 <morecore+0x38>
    return 0;
 a40:	b8 00 00 00 00       	mov    $0x0,%eax
 a45:	eb 26                	jmp    a6d <morecore+0x5e>
  hp = (Header*)p;
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a50:	8b 55 08             	mov    0x8(%ebp),%edx
 a53:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a59:	83 c0 08             	add    $0x8,%eax
 a5c:	83 ec 0c             	sub    $0xc,%esp
 a5f:	50                   	push   %eax
 a60:	e8 c8 fe ff ff       	call   92d <free>
 a65:	83 c4 10             	add    $0x10,%esp
  return freep;
 a68:	a1 ac 0f 00 00       	mov    0xfac,%eax
}
 a6d:	c9                   	leave  
 a6e:	c3                   	ret    

00000a6f <malloc>:

void*
malloc(uint nbytes)
{
 a6f:	55                   	push   %ebp
 a70:	89 e5                	mov    %esp,%ebp
 a72:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a75:	8b 45 08             	mov    0x8(%ebp),%eax
 a78:	83 c0 07             	add    $0x7,%eax
 a7b:	c1 e8 03             	shr    $0x3,%eax
 a7e:	83 c0 01             	add    $0x1,%eax
 a81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a84:	a1 ac 0f 00 00       	mov    0xfac,%eax
 a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a90:	75 23                	jne    ab5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a92:	c7 45 f0 a4 0f 00 00 	movl   $0xfa4,-0x10(%ebp)
 a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9c:	a3 ac 0f 00 00       	mov    %eax,0xfac
 aa1:	a1 ac 0f 00 00       	mov    0xfac,%eax
 aa6:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    base.s.size = 0;
 aab:	c7 05 a8 0f 00 00 00 	movl   $0x0,0xfa8
 ab2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab8:	8b 00                	mov    (%eax),%eax
 aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 40 04             	mov    0x4(%eax),%eax
 ac3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ac6:	77 4d                	ja     b15 <malloc+0xa6>
      if(p->s.size == nunits)
 ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acb:	8b 40 04             	mov    0x4(%eax),%eax
 ace:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ad1:	75 0c                	jne    adf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad6:	8b 10                	mov    (%eax),%edx
 ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 adb:	89 10                	mov    %edx,(%eax)
 add:	eb 26                	jmp    b05 <malloc+0x96>
      else {
        p->s.size -= nunits;
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ae8:	89 c2                	mov    %eax,%edx
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 40 04             	mov    0x4(%eax),%eax
 af6:	c1 e0 03             	shl    $0x3,%eax
 af9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b02:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b08:	a3 ac 0f 00 00       	mov    %eax,0xfac
      return (void*)(p + 1);
 b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b10:	83 c0 08             	add    $0x8,%eax
 b13:	eb 3b                	jmp    b50 <malloc+0xe1>
    }
    if(p == freep)
 b15:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b1d:	75 1e                	jne    b3d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b1f:	83 ec 0c             	sub    $0xc,%esp
 b22:	ff 75 ec             	push   -0x14(%ebp)
 b25:	e8 e5 fe ff ff       	call   a0f <morecore>
 b2a:	83 c4 10             	add    $0x10,%esp
 b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b34:	75 07                	jne    b3d <malloc+0xce>
        return 0;
 b36:	b8 00 00 00 00       	mov    $0x0,%eax
 b3b:	eb 13                	jmp    b50 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b46:	8b 00                	mov    (%eax),%eax
 b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b4b:	e9 6d ff ff ff       	jmp    abd <malloc+0x4e>
  }
}
 b50:	c9                   	leave  
 b51:	c3                   	ret    
