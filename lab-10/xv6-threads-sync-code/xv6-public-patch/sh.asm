
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:

// Execute cmd.  Never returns.
__attribute__((noreturn))
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 e1 0e 00 00       	call   ef2 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 98 14 00 00 	mov    0x1498(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 6c 14 00 00       	push   $0x146c
      2c:	e8 4c 03 00 00       	call   37d <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 a9 0e 00 00       	call   ef2 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 cb 0e 00 00       	call   f2a <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 73 14 00 00       	push   $0x1473
      71:	6a 02                	push   $0x2
      73:	e8 3d 10 00 00       	call   10b5 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 aa 01 00 00       	jmp    22a <runcmd+0x22a>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 e8             	mov    %eax,-0x18(%ebp)
    close(rcmd->fd);
      86:	8b 45 e8             	mov    -0x18(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 85 0e 00 00       	call   f1a <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 e8             	mov    -0x18(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 84 0e 00 00       	call   f32 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 83 14 00 00       	push   $0x1483
      c4:	6a 02                	push   $0x2
      c6:	e8 ea 0f 00 00       	call   10b5 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 1f 0e 00 00       	call   ef2 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e2:	8b 45 08             	mov    0x8(%ebp),%eax
      e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fork1() == 0)
      e8:	e8 b0 02 00 00       	call   39d <fork1>
      ed:	85 c0                	test   %eax,%eax
      ef:	75 0f                	jne    100 <runcmd+0x100>
      runcmd(lcmd->left);
      f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
      f4:	8b 40 04             	mov    0x4(%eax),%eax
      f7:	83 ec 0c             	sub    $0xc,%esp
      fa:	50                   	push   %eax
      fb:	e8 00 ff ff ff       	call   0 <runcmd>
    wait();
     100:	e8 f5 0d 00 00       	call   efa <wait>
    runcmd(lcmd->right);
     105:	8b 45 f0             	mov    -0x10(%ebp),%eax
     108:	8b 40 08             	mov    0x8(%eax),%eax
     10b:	83 ec 0c             	sub    $0xc,%esp
     10e:	50                   	push   %eax
     10f:	e8 ec fe ff ff       	call   0 <runcmd>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     114:	8b 45 08             	mov    0x8(%ebp),%eax
     117:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pipe(p) < 0)
     11a:	83 ec 0c             	sub    $0xc,%esp
     11d:	8d 45 dc             	lea    -0x24(%ebp),%eax
     120:	50                   	push   %eax
     121:	e8 dc 0d 00 00       	call   f02 <pipe>
     126:	83 c4 10             	add    $0x10,%esp
     129:	85 c0                	test   %eax,%eax
     12b:	79 10                	jns    13d <runcmd+0x13d>
      panic("pipe");
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	68 93 14 00 00       	push   $0x1493
     135:	e8 43 02 00 00       	call   37d <panic>
     13a:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     13d:	e8 5b 02 00 00       	call   39d <fork1>
     142:	85 c0                	test   %eax,%eax
     144:	75 49                	jne    18f <runcmd+0x18f>
      close(1);
     146:	83 ec 0c             	sub    $0xc,%esp
     149:	6a 01                	push   $0x1
     14b:	e8 ca 0d 00 00       	call   f1a <close>
     150:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     153:	8b 45 e0             	mov    -0x20(%ebp),%eax
     156:	83 ec 0c             	sub    $0xc,%esp
     159:	50                   	push   %eax
     15a:	e8 0b 0e 00 00       	call   f6a <dup>
     15f:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     162:	8b 45 dc             	mov    -0x24(%ebp),%eax
     165:	83 ec 0c             	sub    $0xc,%esp
     168:	50                   	push   %eax
     169:	e8 ac 0d 00 00       	call   f1a <close>
     16e:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     171:	8b 45 e0             	mov    -0x20(%ebp),%eax
     174:	83 ec 0c             	sub    $0xc,%esp
     177:	50                   	push   %eax
     178:	e8 9d 0d 00 00       	call   f1a <close>
     17d:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     180:	8b 45 ec             	mov    -0x14(%ebp),%eax
     183:	8b 40 04             	mov    0x4(%eax),%eax
     186:	83 ec 0c             	sub    $0xc,%esp
     189:	50                   	push   %eax
     18a:	e8 71 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     18f:	e8 09 02 00 00       	call   39d <fork1>
     194:	85 c0                	test   %eax,%eax
     196:	75 49                	jne    1e1 <runcmd+0x1e1>
      close(0);
     198:	83 ec 0c             	sub    $0xc,%esp
     19b:	6a 00                	push   $0x0
     19d:	e8 78 0d 00 00       	call   f1a <close>
     1a2:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a8:	83 ec 0c             	sub    $0xc,%esp
     1ab:	50                   	push   %eax
     1ac:	e8 b9 0d 00 00       	call   f6a <dup>
     1b1:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1b7:	83 ec 0c             	sub    $0xc,%esp
     1ba:	50                   	push   %eax
     1bb:	e8 5a 0d 00 00       	call   f1a <close>
     1c0:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1c6:	83 ec 0c             	sub    $0xc,%esp
     1c9:	50                   	push   %eax
     1ca:	e8 4b 0d 00 00       	call   f1a <close>
     1cf:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1d5:	8b 40 08             	mov    0x8(%eax),%eax
     1d8:	83 ec 0c             	sub    $0xc,%esp
     1db:	50                   	push   %eax
     1dc:	e8 1f fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e4:	83 ec 0c             	sub    $0xc,%esp
     1e7:	50                   	push   %eax
     1e8:	e8 2d 0d 00 00       	call   f1a <close>
     1ed:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1f3:	83 ec 0c             	sub    $0xc,%esp
     1f6:	50                   	push   %eax
     1f7:	e8 1e 0d 00 00       	call   f1a <close>
     1fc:	83 c4 10             	add    $0x10,%esp
    wait();
     1ff:	e8 f6 0c 00 00       	call   efa <wait>
    wait();
     204:	e8 f1 0c 00 00       	call   efa <wait>
    break;
     209:	eb 1f                	jmp    22a <runcmd+0x22a>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     20b:	8b 45 08             	mov    0x8(%ebp),%eax
     20e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fork1() == 0)
     211:	e8 87 01 00 00       	call   39d <fork1>
     216:	85 c0                	test   %eax,%eax
     218:	75 0f                	jne    229 <runcmd+0x229>
      runcmd(bcmd->cmd);
     21a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     21d:	8b 40 04             	mov    0x4(%eax),%eax
     220:	83 ec 0c             	sub    $0xc,%esp
     223:	50                   	push   %eax
     224:	e8 d7 fd ff ff       	call   0 <runcmd>
    break;
     229:	90                   	nop
  }
  exit();
     22a:	e8 c3 0c 00 00       	call   ef2 <exit>

0000022f <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     22f:	55                   	push   %ebp
     230:	89 e5                	mov    %esp,%ebp
     232:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     235:	83 ec 08             	sub    $0x8,%esp
     238:	68 b0 14 00 00       	push   $0x14b0
     23d:	6a 02                	push   $0x2
     23f:	e8 71 0e 00 00       	call   10b5 <printf>
     244:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     247:	8b 45 0c             	mov    0xc(%ebp),%eax
     24a:	83 ec 04             	sub    $0x4,%esp
     24d:	50                   	push   %eax
     24e:	6a 00                	push   $0x0
     250:	ff 75 08             	push   0x8(%ebp)
     253:	e8 c3 0a 00 00       	call   d1b <memset>
     258:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     25b:	83 ec 08             	sub    $0x8,%esp
     25e:	ff 75 0c             	push   0xc(%ebp)
     261:	ff 75 08             	push   0x8(%ebp)
     264:	e8 ff 0a 00 00       	call   d68 <gets>
     269:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     26c:	8b 45 08             	mov    0x8(%ebp),%eax
     26f:	0f b6 00             	movzbl (%eax),%eax
     272:	84 c0                	test   %al,%al
     274:	75 07                	jne    27d <getcmd+0x4e>
    return -1;
     276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     27b:	eb 05                	jmp    282 <getcmd+0x53>
  return 0;
     27d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     282:	c9                   	leave  
     283:	c3                   	ret    

00000284 <main>:

int
main(void)
{
     284:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     288:	83 e4 f0             	and    $0xfffffff0,%esp
     28b:	ff 71 fc             	push   -0x4(%ecx)
     28e:	55                   	push   %ebp
     28f:	89 e5                	mov    %esp,%ebp
     291:	51                   	push   %ecx
     292:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     295:	eb 16                	jmp    2ad <main+0x29>
    if(fd >= 3){
     297:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     29b:	7e 10                	jle    2ad <main+0x29>
      close(fd);
     29d:	83 ec 0c             	sub    $0xc,%esp
     2a0:	ff 75 f4             	push   -0xc(%ebp)
     2a3:	e8 72 0c 00 00       	call   f1a <close>
     2a8:	83 c4 10             	add    $0x10,%esp
      break;
     2ab:	eb 1b                	jmp    2c8 <main+0x44>
  while((fd = open("console", O_RDWR)) >= 0){
     2ad:	83 ec 08             	sub    $0x8,%esp
     2b0:	6a 02                	push   $0x2
     2b2:	68 b3 14 00 00       	push   $0x14b3
     2b7:	e8 76 0c 00 00       	call   f32 <open>
     2bc:	83 c4 10             	add    $0x10,%esp
     2bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2c6:	79 cf                	jns    297 <main+0x13>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2c8:	e9 91 00 00 00       	jmp    35e <main+0xda>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2cd:	0f b6 05 60 1b 00 00 	movzbl 0x1b60,%eax
     2d4:	3c 63                	cmp    $0x63,%al
     2d6:	75 5f                	jne    337 <main+0xb3>
     2d8:	0f b6 05 61 1b 00 00 	movzbl 0x1b61,%eax
     2df:	3c 64                	cmp    $0x64,%al
     2e1:	75 54                	jne    337 <main+0xb3>
     2e3:	0f b6 05 62 1b 00 00 	movzbl 0x1b62,%eax
     2ea:	3c 20                	cmp    $0x20,%al
     2ec:	75 49                	jne    337 <main+0xb3>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2ee:	83 ec 0c             	sub    $0xc,%esp
     2f1:	68 60 1b 00 00       	push   $0x1b60
     2f6:	e8 f9 09 00 00       	call   cf4 <strlen>
     2fb:	83 c4 10             	add    $0x10,%esp
     2fe:	83 e8 01             	sub    $0x1,%eax
     301:	c6 80 60 1b 00 00 00 	movb   $0x0,0x1b60(%eax)
      if(chdir(buf+3) < 0)
     308:	b8 63 1b 00 00       	mov    $0x1b63,%eax
     30d:	83 ec 0c             	sub    $0xc,%esp
     310:	50                   	push   %eax
     311:	e8 4c 0c 00 00       	call   f62 <chdir>
     316:	83 c4 10             	add    $0x10,%esp
     319:	85 c0                	test   %eax,%eax
     31b:	79 41                	jns    35e <main+0xda>
        printf(2, "cannot cd %s\n", buf+3);
     31d:	b8 63 1b 00 00       	mov    $0x1b63,%eax
     322:	83 ec 04             	sub    $0x4,%esp
     325:	50                   	push   %eax
     326:	68 bb 14 00 00       	push   $0x14bb
     32b:	6a 02                	push   $0x2
     32d:	e8 83 0d 00 00       	call   10b5 <printf>
     332:	83 c4 10             	add    $0x10,%esp
      continue;
     335:	eb 27                	jmp    35e <main+0xda>
    }
    if(fork1() == 0)
     337:	e8 61 00 00 00       	call   39d <fork1>
     33c:	85 c0                	test   %eax,%eax
     33e:	75 19                	jne    359 <main+0xd5>
      runcmd(parsecmd(buf));
     340:	83 ec 0c             	sub    $0xc,%esp
     343:	68 60 1b 00 00       	push   $0x1b60
     348:	e8 a8 03 00 00       	call   6f5 <parsecmd>
     34d:	83 c4 10             	add    $0x10,%esp
     350:	83 ec 0c             	sub    $0xc,%esp
     353:	50                   	push   %eax
     354:	e8 a7 fc ff ff       	call   0 <runcmd>
    wait();
     359:	e8 9c 0b 00 00       	call   efa <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     35e:	83 ec 08             	sub    $0x8,%esp
     361:	6a 64                	push   $0x64
     363:	68 60 1b 00 00       	push   $0x1b60
     368:	e8 c2 fe ff ff       	call   22f <getcmd>
     36d:	83 c4 10             	add    $0x10,%esp
     370:	85 c0                	test   %eax,%eax
     372:	0f 89 55 ff ff ff    	jns    2cd <main+0x49>
  }
  exit();
     378:	e8 75 0b 00 00       	call   ef2 <exit>

0000037d <panic>:
}

void
panic(char *s)
{
     37d:	55                   	push   %ebp
     37e:	89 e5                	mov    %esp,%ebp
     380:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     383:	83 ec 04             	sub    $0x4,%esp
     386:	ff 75 08             	push   0x8(%ebp)
     389:	68 c9 14 00 00       	push   $0x14c9
     38e:	6a 02                	push   $0x2
     390:	e8 20 0d 00 00       	call   10b5 <printf>
     395:	83 c4 10             	add    $0x10,%esp
  exit();
     398:	e8 55 0b 00 00       	call   ef2 <exit>

0000039d <fork1>:
}

int
fork1(void)
{
     39d:	55                   	push   %ebp
     39e:	89 e5                	mov    %esp,%ebp
     3a0:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     3a3:	e8 42 0b 00 00       	call   eea <fork>
     3a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3af:	75 10                	jne    3c1 <fork1+0x24>
    panic("fork");
     3b1:	83 ec 0c             	sub    $0xc,%esp
     3b4:	68 cd 14 00 00       	push   $0x14cd
     3b9:	e8 bf ff ff ff       	call   37d <panic>
     3be:	83 c4 10             	add    $0x10,%esp
  return pid;
     3c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3c4:	c9                   	leave  
     3c5:	c3                   	ret    

000003c6 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3c6:	55                   	push   %ebp
     3c7:	89 e5                	mov    %esp,%ebp
     3c9:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3cc:	83 ec 0c             	sub    $0xc,%esp
     3cf:	6a 54                	push   $0x54
     3d1:	e8 b2 0f 00 00       	call   1388 <malloc>
     3d6:	83 c4 10             	add    $0x10,%esp
     3d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3dc:	83 ec 04             	sub    $0x4,%esp
     3df:	6a 54                	push   $0x54
     3e1:	6a 00                	push   $0x0
     3e3:	ff 75 f4             	push   -0xc(%ebp)
     3e6:	e8 30 09 00 00       	call   d1b <memset>
     3eb:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     3ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3f1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3fa:	c9                   	leave  
     3fb:	c3                   	ret    

000003fc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3fc:	55                   	push   %ebp
     3fd:	89 e5                	mov    %esp,%ebp
     3ff:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     402:	83 ec 0c             	sub    $0xc,%esp
     405:	6a 18                	push   $0x18
     407:	e8 7c 0f 00 00       	call   1388 <malloc>
     40c:	83 c4 10             	add    $0x10,%esp
     40f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     412:	83 ec 04             	sub    $0x4,%esp
     415:	6a 18                	push   $0x18
     417:	6a 00                	push   $0x0
     419:	ff 75 f4             	push   -0xc(%ebp)
     41c:	e8 fa 08 00 00       	call   d1b <memset>
     421:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     424:	8b 45 f4             	mov    -0xc(%ebp),%eax
     427:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     430:	8b 55 08             	mov    0x8(%ebp),%edx
     433:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     436:	8b 45 f4             	mov    -0xc(%ebp),%eax
     439:	8b 55 0c             	mov    0xc(%ebp),%edx
     43c:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     442:	8b 55 10             	mov    0x10(%ebp),%edx
     445:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     448:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44b:	8b 55 14             	mov    0x14(%ebp),%edx
     44e:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     451:	8b 45 f4             	mov    -0xc(%ebp),%eax
     454:	8b 55 18             	mov    0x18(%ebp),%edx
     457:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     45d:	c9                   	leave  
     45e:	c3                   	ret    

0000045f <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     45f:	55                   	push   %ebp
     460:	89 e5                	mov    %esp,%ebp
     462:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     465:	83 ec 0c             	sub    $0xc,%esp
     468:	6a 0c                	push   $0xc
     46a:	e8 19 0f 00 00       	call   1388 <malloc>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     475:	83 ec 04             	sub    $0x4,%esp
     478:	6a 0c                	push   $0xc
     47a:	6a 00                	push   $0x0
     47c:	ff 75 f4             	push   -0xc(%ebp)
     47f:	e8 97 08 00 00       	call   d1b <memset>
     484:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     487:	8b 45 f4             	mov    -0xc(%ebp),%eax
     48a:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     490:	8b 45 f4             	mov    -0xc(%ebp),%eax
     493:	8b 55 08             	mov    0x8(%ebp),%edx
     496:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     499:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49c:	8b 55 0c             	mov    0xc(%ebp),%edx
     49f:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4a5:	c9                   	leave  
     4a6:	c3                   	ret    

000004a7 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4a7:	55                   	push   %ebp
     4a8:	89 e5                	mov    %esp,%ebp
     4aa:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4ad:	83 ec 0c             	sub    $0xc,%esp
     4b0:	6a 0c                	push   $0xc
     4b2:	e8 d1 0e 00 00       	call   1388 <malloc>
     4b7:	83 c4 10             	add    $0x10,%esp
     4ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4bd:	83 ec 04             	sub    $0x4,%esp
     4c0:	6a 0c                	push   $0xc
     4c2:	6a 00                	push   $0x0
     4c4:	ff 75 f4             	push   -0xc(%ebp)
     4c7:	e8 4f 08 00 00       	call   d1b <memset>
     4cc:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d2:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4db:	8b 55 08             	mov    0x8(%ebp),%edx
     4de:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e4:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e7:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4ed:	c9                   	leave  
     4ee:	c3                   	ret    

000004ef <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4ef:	55                   	push   %ebp
     4f0:	89 e5                	mov    %esp,%ebp
     4f2:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f5:	83 ec 0c             	sub    $0xc,%esp
     4f8:	6a 08                	push   $0x8
     4fa:	e8 89 0e 00 00       	call   1388 <malloc>
     4ff:	83 c4 10             	add    $0x10,%esp
     502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     505:	83 ec 04             	sub    $0x4,%esp
     508:	6a 08                	push   $0x8
     50a:	6a 00                	push   $0x0
     50c:	ff 75 f4             	push   -0xc(%ebp)
     50f:	e8 07 08 00 00       	call   d1b <memset>
     514:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     517:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51a:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     520:	8b 45 f4             	mov    -0xc(%ebp),%eax
     523:	8b 55 08             	mov    0x8(%ebp),%edx
     526:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     529:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     52c:	c9                   	leave  
     52d:	c3                   	ret    

0000052e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     52e:	55                   	push   %ebp
     52f:	89 e5                	mov    %esp,%ebp
     531:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     534:	8b 45 08             	mov    0x8(%ebp),%eax
     537:	8b 00                	mov    (%eax),%eax
     539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     53c:	eb 04                	jmp    542 <gettoken+0x14>
    s++;
     53e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     542:	8b 45 f4             	mov    -0xc(%ebp),%eax
     545:	3b 45 0c             	cmp    0xc(%ebp),%eax
     548:	73 1e                	jae    568 <gettoken+0x3a>
     54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54d:	0f b6 00             	movzbl (%eax),%eax
     550:	0f be c0             	movsbl %al,%eax
     553:	83 ec 08             	sub    $0x8,%esp
     556:	50                   	push   %eax
     557:	68 24 1b 00 00       	push   $0x1b24
     55c:	e8 d4 07 00 00       	call   d35 <strchr>
     561:	83 c4 10             	add    $0x10,%esp
     564:	85 c0                	test   %eax,%eax
     566:	75 d6                	jne    53e <gettoken+0x10>
  if(q)
     568:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     56c:	74 08                	je     576 <gettoken+0x48>
    *q = s;
     56e:	8b 45 10             	mov    0x10(%ebp),%eax
     571:	8b 55 f4             	mov    -0xc(%ebp),%edx
     574:	89 10                	mov    %edx,(%eax)
  ret = *s;
     576:	8b 45 f4             	mov    -0xc(%ebp),%eax
     579:	0f b6 00             	movzbl (%eax),%eax
     57c:	0f be c0             	movsbl %al,%eax
     57f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     582:	8b 45 f4             	mov    -0xc(%ebp),%eax
     585:	0f b6 00             	movzbl (%eax),%eax
     588:	0f be c0             	movsbl %al,%eax
     58b:	83 f8 29             	cmp    $0x29,%eax
     58e:	7f 14                	jg     5a4 <gettoken+0x76>
     590:	83 f8 28             	cmp    $0x28,%eax
     593:	7d 28                	jge    5bd <gettoken+0x8f>
     595:	85 c0                	test   %eax,%eax
     597:	0f 84 94 00 00 00    	je     631 <gettoken+0x103>
     59d:	83 f8 26             	cmp    $0x26,%eax
     5a0:	74 1b                	je     5bd <gettoken+0x8f>
     5a2:	eb 3a                	jmp    5de <gettoken+0xb0>
     5a4:	83 f8 3e             	cmp    $0x3e,%eax
     5a7:	74 1a                	je     5c3 <gettoken+0x95>
     5a9:	83 f8 3e             	cmp    $0x3e,%eax
     5ac:	7f 0a                	jg     5b8 <gettoken+0x8a>
     5ae:	83 e8 3b             	sub    $0x3b,%eax
     5b1:	83 f8 01             	cmp    $0x1,%eax
     5b4:	77 28                	ja     5de <gettoken+0xb0>
     5b6:	eb 05                	jmp    5bd <gettoken+0x8f>
     5b8:	83 f8 7c             	cmp    $0x7c,%eax
     5bb:	75 21                	jne    5de <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c1:	eb 75                	jmp    638 <gettoken+0x10a>
  case '>':
    s++;
     5c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ca:	0f b6 00             	movzbl (%eax),%eax
     5cd:	3c 3e                	cmp    $0x3e,%al
     5cf:	75 63                	jne    634 <gettoken+0x106>
      ret = '+';
     5d1:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5dc:	eb 56                	jmp    634 <gettoken+0x106>
  default:
    ret = 'a';
     5de:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e5:	eb 04                	jmp    5eb <gettoken+0xbd>
      s++;
     5e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f1:	73 44                	jae    637 <gettoken+0x109>
     5f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f6:	0f b6 00             	movzbl (%eax),%eax
     5f9:	0f be c0             	movsbl %al,%eax
     5fc:	83 ec 08             	sub    $0x8,%esp
     5ff:	50                   	push   %eax
     600:	68 24 1b 00 00       	push   $0x1b24
     605:	e8 2b 07 00 00       	call   d35 <strchr>
     60a:	83 c4 10             	add    $0x10,%esp
     60d:	85 c0                	test   %eax,%eax
     60f:	75 26                	jne    637 <gettoken+0x109>
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	0f b6 00             	movzbl (%eax),%eax
     617:	0f be c0             	movsbl %al,%eax
     61a:	83 ec 08             	sub    $0x8,%esp
     61d:	50                   	push   %eax
     61e:	68 2c 1b 00 00       	push   $0x1b2c
     623:	e8 0d 07 00 00       	call   d35 <strchr>
     628:	83 c4 10             	add    $0x10,%esp
     62b:	85 c0                	test   %eax,%eax
     62d:	74 b8                	je     5e7 <gettoken+0xb9>
    break;
     62f:	eb 06                	jmp    637 <gettoken+0x109>
    break;
     631:	90                   	nop
     632:	eb 04                	jmp    638 <gettoken+0x10a>
    break;
     634:	90                   	nop
     635:	eb 01                	jmp    638 <gettoken+0x10a>
    break;
     637:	90                   	nop
  }
  if(eq)
     638:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     63c:	74 0e                	je     64c <gettoken+0x11e>
    *eq = s;
     63e:	8b 45 14             	mov    0x14(%ebp),%eax
     641:	8b 55 f4             	mov    -0xc(%ebp),%edx
     644:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     646:	eb 04                	jmp    64c <gettoken+0x11e>
    s++;
     648:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     64c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     652:	73 1e                	jae    672 <gettoken+0x144>
     654:	8b 45 f4             	mov    -0xc(%ebp),%eax
     657:	0f b6 00             	movzbl (%eax),%eax
     65a:	0f be c0             	movsbl %al,%eax
     65d:	83 ec 08             	sub    $0x8,%esp
     660:	50                   	push   %eax
     661:	68 24 1b 00 00       	push   $0x1b24
     666:	e8 ca 06 00 00       	call   d35 <strchr>
     66b:	83 c4 10             	add    $0x10,%esp
     66e:	85 c0                	test   %eax,%eax
     670:	75 d6                	jne    648 <gettoken+0x11a>
  *ps = s;
     672:	8b 45 08             	mov    0x8(%ebp),%eax
     675:	8b 55 f4             	mov    -0xc(%ebp),%edx
     678:	89 10                	mov    %edx,(%eax)
  return ret;
     67a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67d:	c9                   	leave  
     67e:	c3                   	ret    

0000067f <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67f:	55                   	push   %ebp
     680:	89 e5                	mov    %esp,%ebp
     682:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     685:	8b 45 08             	mov    0x8(%ebp),%eax
     688:	8b 00                	mov    (%eax),%eax
     68a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68d:	eb 04                	jmp    693 <peek+0x14>
    s++;
     68f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     693:	8b 45 f4             	mov    -0xc(%ebp),%eax
     696:	3b 45 0c             	cmp    0xc(%ebp),%eax
     699:	73 1e                	jae    6b9 <peek+0x3a>
     69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69e:	0f b6 00             	movzbl (%eax),%eax
     6a1:	0f be c0             	movsbl %al,%eax
     6a4:	83 ec 08             	sub    $0x8,%esp
     6a7:	50                   	push   %eax
     6a8:	68 24 1b 00 00       	push   $0x1b24
     6ad:	e8 83 06 00 00       	call   d35 <strchr>
     6b2:	83 c4 10             	add    $0x10,%esp
     6b5:	85 c0                	test   %eax,%eax
     6b7:	75 d6                	jne    68f <peek+0x10>
  *ps = s;
     6b9:	8b 45 08             	mov    0x8(%ebp),%eax
     6bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bf:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c4:	0f b6 00             	movzbl (%eax),%eax
     6c7:	84 c0                	test   %al,%al
     6c9:	74 23                	je     6ee <peek+0x6f>
     6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ce:	0f b6 00             	movzbl (%eax),%eax
     6d1:	0f be c0             	movsbl %al,%eax
     6d4:	83 ec 08             	sub    $0x8,%esp
     6d7:	50                   	push   %eax
     6d8:	ff 75 10             	push   0x10(%ebp)
     6db:	e8 55 06 00 00       	call   d35 <strchr>
     6e0:	83 c4 10             	add    $0x10,%esp
     6e3:	85 c0                	test   %eax,%eax
     6e5:	74 07                	je     6ee <peek+0x6f>
     6e7:	b8 01 00 00 00       	mov    $0x1,%eax
     6ec:	eb 05                	jmp    6f3 <peek+0x74>
     6ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f3:	c9                   	leave  
     6f4:	c3                   	ret    

000006f5 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f5:	55                   	push   %ebp
     6f6:	89 e5                	mov    %esp,%ebp
     6f8:	53                   	push   %ebx
     6f9:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6ff:	8b 45 08             	mov    0x8(%ebp),%eax
     702:	83 ec 0c             	sub    $0xc,%esp
     705:	50                   	push   %eax
     706:	e8 e9 05 00 00       	call   cf4 <strlen>
     70b:	83 c4 10             	add    $0x10,%esp
     70e:	01 d8                	add    %ebx,%eax
     710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     713:	83 ec 08             	sub    $0x8,%esp
     716:	ff 75 f4             	push   -0xc(%ebp)
     719:	8d 45 08             	lea    0x8(%ebp),%eax
     71c:	50                   	push   %eax
     71d:	e8 61 00 00 00       	call   783 <parseline>
     722:	83 c4 10             	add    $0x10,%esp
     725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     728:	83 ec 04             	sub    $0x4,%esp
     72b:	68 d2 14 00 00       	push   $0x14d2
     730:	ff 75 f4             	push   -0xc(%ebp)
     733:	8d 45 08             	lea    0x8(%ebp),%eax
     736:	50                   	push   %eax
     737:	e8 43 ff ff ff       	call   67f <peek>
     73c:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     73f:	8b 45 08             	mov    0x8(%ebp),%eax
     742:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     745:	74 26                	je     76d <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     747:	8b 45 08             	mov    0x8(%ebp),%eax
     74a:	83 ec 04             	sub    $0x4,%esp
     74d:	50                   	push   %eax
     74e:	68 d3 14 00 00       	push   $0x14d3
     753:	6a 02                	push   $0x2
     755:	e8 5b 09 00 00       	call   10b5 <printf>
     75a:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     75d:	83 ec 0c             	sub    $0xc,%esp
     760:	68 e2 14 00 00       	push   $0x14e2
     765:	e8 13 fc ff ff       	call   37d <panic>
     76a:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     76d:	83 ec 0c             	sub    $0xc,%esp
     770:	ff 75 f0             	push   -0x10(%ebp)
     773:	e8 eb 03 00 00       	call   b63 <nulterminate>
     778:	83 c4 10             	add    $0x10,%esp
  return cmd;
     77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     77e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     781:	c9                   	leave  
     782:	c3                   	ret    

00000783 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     783:	55                   	push   %ebp
     784:	89 e5                	mov    %esp,%ebp
     786:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     789:	83 ec 08             	sub    $0x8,%esp
     78c:	ff 75 0c             	push   0xc(%ebp)
     78f:	ff 75 08             	push   0x8(%ebp)
     792:	e8 99 00 00 00       	call   830 <parsepipe>
     797:	83 c4 10             	add    $0x10,%esp
     79a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     79d:	eb 23                	jmp    7c2 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     79f:	6a 00                	push   $0x0
     7a1:	6a 00                	push   $0x0
     7a3:	ff 75 0c             	push   0xc(%ebp)
     7a6:	ff 75 08             	push   0x8(%ebp)
     7a9:	e8 80 fd ff ff       	call   52e <gettoken>
     7ae:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7b1:	83 ec 0c             	sub    $0xc,%esp
     7b4:	ff 75 f4             	push   -0xc(%ebp)
     7b7:	e8 33 fd ff ff       	call   4ef <backcmd>
     7bc:	83 c4 10             	add    $0x10,%esp
     7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7c2:	83 ec 04             	sub    $0x4,%esp
     7c5:	68 e9 14 00 00       	push   $0x14e9
     7ca:	ff 75 0c             	push   0xc(%ebp)
     7cd:	ff 75 08             	push   0x8(%ebp)
     7d0:	e8 aa fe ff ff       	call   67f <peek>
     7d5:	83 c4 10             	add    $0x10,%esp
     7d8:	85 c0                	test   %eax,%eax
     7da:	75 c3                	jne    79f <parseline+0x1c>
  }
  if(peek(ps, es, ";")){
     7dc:	83 ec 04             	sub    $0x4,%esp
     7df:	68 eb 14 00 00       	push   $0x14eb
     7e4:	ff 75 0c             	push   0xc(%ebp)
     7e7:	ff 75 08             	push   0x8(%ebp)
     7ea:	e8 90 fe ff ff       	call   67f <peek>
     7ef:	83 c4 10             	add    $0x10,%esp
     7f2:	85 c0                	test   %eax,%eax
     7f4:	74 35                	je     82b <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     7f6:	6a 00                	push   $0x0
     7f8:	6a 00                	push   $0x0
     7fa:	ff 75 0c             	push   0xc(%ebp)
     7fd:	ff 75 08             	push   0x8(%ebp)
     800:	e8 29 fd ff ff       	call   52e <gettoken>
     805:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     808:	83 ec 08             	sub    $0x8,%esp
     80b:	ff 75 0c             	push   0xc(%ebp)
     80e:	ff 75 08             	push   0x8(%ebp)
     811:	e8 6d ff ff ff       	call   783 <parseline>
     816:	83 c4 10             	add    $0x10,%esp
     819:	83 ec 08             	sub    $0x8,%esp
     81c:	50                   	push   %eax
     81d:	ff 75 f4             	push   -0xc(%ebp)
     820:	e8 82 fc ff ff       	call   4a7 <listcmd>
     825:	83 c4 10             	add    $0x10,%esp
     828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     82e:	c9                   	leave  
     82f:	c3                   	ret    

00000830 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     836:	83 ec 08             	sub    $0x8,%esp
     839:	ff 75 0c             	push   0xc(%ebp)
     83c:	ff 75 08             	push   0x8(%ebp)
     83f:	e8 ec 01 00 00       	call   a30 <parseexec>
     844:	83 c4 10             	add    $0x10,%esp
     847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     84a:	83 ec 04             	sub    $0x4,%esp
     84d:	68 ed 14 00 00       	push   $0x14ed
     852:	ff 75 0c             	push   0xc(%ebp)
     855:	ff 75 08             	push   0x8(%ebp)
     858:	e8 22 fe ff ff       	call   67f <peek>
     85d:	83 c4 10             	add    $0x10,%esp
     860:	85 c0                	test   %eax,%eax
     862:	74 35                	je     899 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     864:	6a 00                	push   $0x0
     866:	6a 00                	push   $0x0
     868:	ff 75 0c             	push   0xc(%ebp)
     86b:	ff 75 08             	push   0x8(%ebp)
     86e:	e8 bb fc ff ff       	call   52e <gettoken>
     873:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     876:	83 ec 08             	sub    $0x8,%esp
     879:	ff 75 0c             	push   0xc(%ebp)
     87c:	ff 75 08             	push   0x8(%ebp)
     87f:	e8 ac ff ff ff       	call   830 <parsepipe>
     884:	83 c4 10             	add    $0x10,%esp
     887:	83 ec 08             	sub    $0x8,%esp
     88a:	50                   	push   %eax
     88b:	ff 75 f4             	push   -0xc(%ebp)
     88e:	e8 cc fb ff ff       	call   45f <pipecmd>
     893:	83 c4 10             	add    $0x10,%esp
     896:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     899:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     89c:	c9                   	leave  
     89d:	c3                   	ret    

0000089e <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     89e:	55                   	push   %ebp
     89f:	89 e5                	mov    %esp,%ebp
     8a1:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8a4:	e9 b6 00 00 00       	jmp    95f <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     8a9:	6a 00                	push   $0x0
     8ab:	6a 00                	push   $0x0
     8ad:	ff 75 10             	push   0x10(%ebp)
     8b0:	ff 75 0c             	push   0xc(%ebp)
     8b3:	e8 76 fc ff ff       	call   52e <gettoken>
     8b8:	83 c4 10             	add    $0x10,%esp
     8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8be:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8c1:	50                   	push   %eax
     8c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8c5:	50                   	push   %eax
     8c6:	ff 75 10             	push   0x10(%ebp)
     8c9:	ff 75 0c             	push   0xc(%ebp)
     8cc:	e8 5d fc ff ff       	call   52e <gettoken>
     8d1:	83 c4 10             	add    $0x10,%esp
     8d4:	83 f8 61             	cmp    $0x61,%eax
     8d7:	74 10                	je     8e9 <parseredirs+0x4b>
      panic("missing file for redirection");
     8d9:	83 ec 0c             	sub    $0xc,%esp
     8dc:	68 ef 14 00 00       	push   $0x14ef
     8e1:	e8 97 fa ff ff       	call   37d <panic>
     8e6:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ec:	83 f8 3c             	cmp    $0x3c,%eax
     8ef:	74 0c                	je     8fd <parseredirs+0x5f>
     8f1:	83 f8 3e             	cmp    $0x3e,%eax
     8f4:	74 26                	je     91c <parseredirs+0x7e>
     8f6:	83 f8 2b             	cmp    $0x2b,%eax
     8f9:	74 43                	je     93e <parseredirs+0xa0>
     8fb:	eb 62                	jmp    95f <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     8fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
     900:	8b 45 f0             	mov    -0x10(%ebp),%eax
     903:	83 ec 0c             	sub    $0xc,%esp
     906:	6a 00                	push   $0x0
     908:	6a 00                	push   $0x0
     90a:	52                   	push   %edx
     90b:	50                   	push   %eax
     90c:	ff 75 08             	push   0x8(%ebp)
     90f:	e8 e8 fa ff ff       	call   3fc <redircmd>
     914:	83 c4 20             	add    $0x20,%esp
     917:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     91a:	eb 43                	jmp    95f <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     91c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     922:	83 ec 0c             	sub    $0xc,%esp
     925:	6a 01                	push   $0x1
     927:	68 01 02 00 00       	push   $0x201
     92c:	52                   	push   %edx
     92d:	50                   	push   %eax
     92e:	ff 75 08             	push   0x8(%ebp)
     931:	e8 c6 fa ff ff       	call   3fc <redircmd>
     936:	83 c4 20             	add    $0x20,%esp
     939:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     93c:	eb 21                	jmp    95f <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     93e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     941:	8b 45 f0             	mov    -0x10(%ebp),%eax
     944:	83 ec 0c             	sub    $0xc,%esp
     947:	6a 01                	push   $0x1
     949:	68 01 02 00 00       	push   $0x201
     94e:	52                   	push   %edx
     94f:	50                   	push   %eax
     950:	ff 75 08             	push   0x8(%ebp)
     953:	e8 a4 fa ff ff       	call   3fc <redircmd>
     958:	83 c4 20             	add    $0x20,%esp
     95b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     95e:	90                   	nop
  while(peek(ps, es, "<>")){
     95f:	83 ec 04             	sub    $0x4,%esp
     962:	68 0c 15 00 00       	push   $0x150c
     967:	ff 75 10             	push   0x10(%ebp)
     96a:	ff 75 0c             	push   0xc(%ebp)
     96d:	e8 0d fd ff ff       	call   67f <peek>
     972:	83 c4 10             	add    $0x10,%esp
     975:	85 c0                	test   %eax,%eax
     977:	0f 85 2c ff ff ff    	jne    8a9 <parseredirs+0xb>
    }
  }
  return cmd;
     97d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     980:	c9                   	leave  
     981:	c3                   	ret    

00000982 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     982:	55                   	push   %ebp
     983:	89 e5                	mov    %esp,%ebp
     985:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     988:	83 ec 04             	sub    $0x4,%esp
     98b:	68 0f 15 00 00       	push   $0x150f
     990:	ff 75 0c             	push   0xc(%ebp)
     993:	ff 75 08             	push   0x8(%ebp)
     996:	e8 e4 fc ff ff       	call   67f <peek>
     99b:	83 c4 10             	add    $0x10,%esp
     99e:	85 c0                	test   %eax,%eax
     9a0:	75 10                	jne    9b2 <parseblock+0x30>
    panic("parseblock");
     9a2:	83 ec 0c             	sub    $0xc,%esp
     9a5:	68 11 15 00 00       	push   $0x1511
     9aa:	e8 ce f9 ff ff       	call   37d <panic>
     9af:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9b2:	6a 00                	push   $0x0
     9b4:	6a 00                	push   $0x0
     9b6:	ff 75 0c             	push   0xc(%ebp)
     9b9:	ff 75 08             	push   0x8(%ebp)
     9bc:	e8 6d fb ff ff       	call   52e <gettoken>
     9c1:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9c4:	83 ec 08             	sub    $0x8,%esp
     9c7:	ff 75 0c             	push   0xc(%ebp)
     9ca:	ff 75 08             	push   0x8(%ebp)
     9cd:	e8 b1 fd ff ff       	call   783 <parseline>
     9d2:	83 c4 10             	add    $0x10,%esp
     9d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9d8:	83 ec 04             	sub    $0x4,%esp
     9db:	68 1c 15 00 00       	push   $0x151c
     9e0:	ff 75 0c             	push   0xc(%ebp)
     9e3:	ff 75 08             	push   0x8(%ebp)
     9e6:	e8 94 fc ff ff       	call   67f <peek>
     9eb:	83 c4 10             	add    $0x10,%esp
     9ee:	85 c0                	test   %eax,%eax
     9f0:	75 10                	jne    a02 <parseblock+0x80>
    panic("syntax - missing )");
     9f2:	83 ec 0c             	sub    $0xc,%esp
     9f5:	68 1e 15 00 00       	push   $0x151e
     9fa:	e8 7e f9 ff ff       	call   37d <panic>
     9ff:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a02:	6a 00                	push   $0x0
     a04:	6a 00                	push   $0x0
     a06:	ff 75 0c             	push   0xc(%ebp)
     a09:	ff 75 08             	push   0x8(%ebp)
     a0c:	e8 1d fb ff ff       	call   52e <gettoken>
     a11:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a14:	83 ec 04             	sub    $0x4,%esp
     a17:	ff 75 0c             	push   0xc(%ebp)
     a1a:	ff 75 08             	push   0x8(%ebp)
     a1d:	ff 75 f4             	push   -0xc(%ebp)
     a20:	e8 79 fe ff ff       	call   89e <parseredirs>
     a25:	83 c4 10             	add    $0x10,%esp
     a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a2e:	c9                   	leave  
     a2f:	c3                   	ret    

00000a30 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a30:	55                   	push   %ebp
     a31:	89 e5                	mov    %esp,%ebp
     a33:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     a36:	83 ec 04             	sub    $0x4,%esp
     a39:	68 0f 15 00 00       	push   $0x150f
     a3e:	ff 75 0c             	push   0xc(%ebp)
     a41:	ff 75 08             	push   0x8(%ebp)
     a44:	e8 36 fc ff ff       	call   67f <peek>
     a49:	83 c4 10             	add    $0x10,%esp
     a4c:	85 c0                	test   %eax,%eax
     a4e:	74 16                	je     a66 <parseexec+0x36>
    return parseblock(ps, es);
     a50:	83 ec 08             	sub    $0x8,%esp
     a53:	ff 75 0c             	push   0xc(%ebp)
     a56:	ff 75 08             	push   0x8(%ebp)
     a59:	e8 24 ff ff ff       	call   982 <parseblock>
     a5e:	83 c4 10             	add    $0x10,%esp
     a61:	e9 fb 00 00 00       	jmp    b61 <parseexec+0x131>

  ret = execcmd();
     a66:	e8 5b f9 ff ff       	call   3c6 <execcmd>
     a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a71:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     a7b:	83 ec 04             	sub    $0x4,%esp
     a7e:	ff 75 0c             	push   0xc(%ebp)
     a81:	ff 75 08             	push   0x8(%ebp)
     a84:	ff 75 f0             	push   -0x10(%ebp)
     a87:	e8 12 fe ff ff       	call   89e <parseredirs>
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     a92:	e9 87 00 00 00       	jmp    b1e <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     a97:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a9a:	50                   	push   %eax
     a9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     a9e:	50                   	push   %eax
     a9f:	ff 75 0c             	push   0xc(%ebp)
     aa2:	ff 75 08             	push   0x8(%ebp)
     aa5:	e8 84 fa ff ff       	call   52e <gettoken>
     aaa:	83 c4 10             	add    $0x10,%esp
     aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ab0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ab4:	0f 84 84 00 00 00    	je     b3e <parseexec+0x10e>
      break;
    if(tok != 'a')
     aba:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     abe:	74 10                	je     ad0 <parseexec+0xa0>
      panic("syntax");
     ac0:	83 ec 0c             	sub    $0xc,%esp
     ac3:	68 e2 14 00 00       	push   $0x14e2
     ac8:	e8 b0 f8 ff ff       	call   37d <panic>
     acd:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     ad0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ad9:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     add:	8b 55 e0             	mov    -0x20(%ebp),%edx
     ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ae3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ae6:	83 c1 08             	add    $0x8,%ecx
     ae9:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     aed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     af1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     af5:	7e 10                	jle    b07 <parseexec+0xd7>
      panic("too many args");
     af7:	83 ec 0c             	sub    $0xc,%esp
     afa:	68 31 15 00 00       	push   $0x1531
     aff:	e8 79 f8 ff ff       	call   37d <panic>
     b04:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b07:	83 ec 04             	sub    $0x4,%esp
     b0a:	ff 75 0c             	push   0xc(%ebp)
     b0d:	ff 75 08             	push   0x8(%ebp)
     b10:	ff 75 f0             	push   -0x10(%ebp)
     b13:	e8 86 fd ff ff       	call   89e <parseredirs>
     b18:	83 c4 10             	add    $0x10,%esp
     b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b1e:	83 ec 04             	sub    $0x4,%esp
     b21:	68 3f 15 00 00       	push   $0x153f
     b26:	ff 75 0c             	push   0xc(%ebp)
     b29:	ff 75 08             	push   0x8(%ebp)
     b2c:	e8 4e fb ff ff       	call   67f <peek>
     b31:	83 c4 10             	add    $0x10,%esp
     b34:	85 c0                	test   %eax,%eax
     b36:	0f 84 5b ff ff ff    	je     a97 <parseexec+0x67>
     b3c:	eb 01                	jmp    b3f <parseexec+0x10f>
      break;
     b3e:	90                   	nop
  }
  cmd->argv[argc] = 0;
     b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b45:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b4c:	00 
  cmd->eargv[argc] = 0;
     b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b53:	83 c2 08             	add    $0x8,%edx
     b56:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b5d:	00 
  return ret;
     b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b61:	c9                   	leave  
     b62:	c3                   	ret    

00000b63 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b63:	55                   	push   %ebp
     b64:	89 e5                	mov    %esp,%ebp
     b66:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b6d:	75 0a                	jne    b79 <nulterminate+0x16>
    return 0;
     b6f:	b8 00 00 00 00       	mov    $0x0,%eax
     b74:	e9 e4 00 00 00       	jmp    c5d <nulterminate+0xfa>

  switch(cmd->type){
     b79:	8b 45 08             	mov    0x8(%ebp),%eax
     b7c:	8b 00                	mov    (%eax),%eax
     b7e:	83 f8 05             	cmp    $0x5,%eax
     b81:	0f 87 d3 00 00 00    	ja     c5a <nulterminate+0xf7>
     b87:	8b 04 85 44 15 00 00 	mov    0x1544(,%eax,4),%eax
     b8e:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     b90:	8b 45 08             	mov    0x8(%ebp),%eax
     b93:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     b96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b9d:	eb 14                	jmp    bb3 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     b9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ba5:	83 c2 08             	add    $0x8,%edx
     ba8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bac:	c6 00 00             	movb   $0x0,(%eax)
    for(i=0; ecmd->argv[i]; i++)
     baf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bb9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bbd:	85 c0                	test   %eax,%eax
     bbf:	75 de                	jne    b9f <nulterminate+0x3c>
    break;
     bc1:	e9 94 00 00 00       	jmp    c5a <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     bc6:	8b 45 08             	mov    0x8(%ebp),%eax
     bc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(rcmd->cmd);
     bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bcf:	8b 40 04             	mov    0x4(%eax),%eax
     bd2:	83 ec 0c             	sub    $0xc,%esp
     bd5:	50                   	push   %eax
     bd6:	e8 88 ff ff ff       	call   b63 <nulterminate>
     bdb:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     be1:	8b 40 0c             	mov    0xc(%eax),%eax
     be4:	c6 00 00             	movb   $0x0,(%eax)
    break;
     be7:	eb 71                	jmp    c5a <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     be9:	8b 45 08             	mov    0x8(%ebp),%eax
     bec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf2:	8b 40 04             	mov    0x4(%eax),%eax
     bf5:	83 ec 0c             	sub    $0xc,%esp
     bf8:	50                   	push   %eax
     bf9:	e8 65 ff ff ff       	call   b63 <nulterminate>
     bfe:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c04:	8b 40 08             	mov    0x8(%eax),%eax
     c07:	83 ec 0c             	sub    $0xc,%esp
     c0a:	50                   	push   %eax
     c0b:	e8 53 ff ff ff       	call   b63 <nulterminate>
     c10:	83 c4 10             	add    $0x10,%esp
    break;
     c13:	eb 45                	jmp    c5a <nulterminate+0xf7>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c15:	8b 45 08             	mov    0x8(%ebp),%eax
     c18:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c1e:	8b 40 04             	mov    0x4(%eax),%eax
     c21:	83 ec 0c             	sub    $0xc,%esp
     c24:	50                   	push   %eax
     c25:	e8 39 ff ff ff       	call   b63 <nulterminate>
     c2a:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c30:	8b 40 08             	mov    0x8(%eax),%eax
     c33:	83 ec 0c             	sub    $0xc,%esp
     c36:	50                   	push   %eax
     c37:	e8 27 ff ff ff       	call   b63 <nulterminate>
     c3c:	83 c4 10             	add    $0x10,%esp
    break;
     c3f:	eb 19                	jmp    c5a <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c41:	8b 45 08             	mov    0x8(%ebp),%eax
     c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(bcmd->cmd);
     c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c4a:	8b 40 04             	mov    0x4(%eax),%eax
     c4d:	83 ec 0c             	sub    $0xc,%esp
     c50:	50                   	push   %eax
     c51:	e8 0d ff ff ff       	call   b63 <nulterminate>
     c56:	83 c4 10             	add    $0x10,%esp
    break;
     c59:	90                   	nop
  }
  return cmd;
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c5d:	c9                   	leave  
     c5e:	c3                   	ret    

00000c5f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c5f:	55                   	push   %ebp
     c60:	89 e5                	mov    %esp,%ebp
     c62:	57                   	push   %edi
     c63:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c64:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c67:	8b 55 10             	mov    0x10(%ebp),%edx
     c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c6d:	89 cb                	mov    %ecx,%ebx
     c6f:	89 df                	mov    %ebx,%edi
     c71:	89 d1                	mov    %edx,%ecx
     c73:	fc                   	cld    
     c74:	f3 aa                	rep stos %al,%es:(%edi)
     c76:	89 ca                	mov    %ecx,%edx
     c78:	89 fb                	mov    %edi,%ebx
     c7a:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c7d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     c80:	90                   	nop
     c81:	5b                   	pop    %ebx
     c82:	5f                   	pop    %edi
     c83:	5d                   	pop    %ebp
     c84:	c3                   	ret    

00000c85 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     c85:	55                   	push   %ebp
     c86:	89 e5                	mov    %esp,%ebp
     c88:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     c8b:	8b 45 08             	mov    0x8(%ebp),%eax
     c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     c91:	90                   	nop
     c92:	8b 55 0c             	mov    0xc(%ebp),%edx
     c95:	8d 42 01             	lea    0x1(%edx),%eax
     c98:	89 45 0c             	mov    %eax,0xc(%ebp)
     c9b:	8b 45 08             	mov    0x8(%ebp),%eax
     c9e:	8d 48 01             	lea    0x1(%eax),%ecx
     ca1:	89 4d 08             	mov    %ecx,0x8(%ebp)
     ca4:	0f b6 12             	movzbl (%edx),%edx
     ca7:	88 10                	mov    %dl,(%eax)
     ca9:	0f b6 00             	movzbl (%eax),%eax
     cac:	84 c0                	test   %al,%al
     cae:	75 e2                	jne    c92 <strcpy+0xd>
    ;
  return os;
     cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cb3:	c9                   	leave  
     cb4:	c3                   	ret    

00000cb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cb5:	55                   	push   %ebp
     cb6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cb8:	eb 08                	jmp    cc2 <strcmp+0xd>
    p++, q++;
     cba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     cbe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
     cc2:	8b 45 08             	mov    0x8(%ebp),%eax
     cc5:	0f b6 00             	movzbl (%eax),%eax
     cc8:	84 c0                	test   %al,%al
     cca:	74 10                	je     cdc <strcmp+0x27>
     ccc:	8b 45 08             	mov    0x8(%ebp),%eax
     ccf:	0f b6 10             	movzbl (%eax),%edx
     cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd5:	0f b6 00             	movzbl (%eax),%eax
     cd8:	38 c2                	cmp    %al,%dl
     cda:	74 de                	je     cba <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
     cdc:	8b 45 08             	mov    0x8(%ebp),%eax
     cdf:	0f b6 00             	movzbl (%eax),%eax
     ce2:	0f b6 d0             	movzbl %al,%edx
     ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ce8:	0f b6 00             	movzbl (%eax),%eax
     ceb:	0f b6 c0             	movzbl %al,%eax
     cee:	29 c2                	sub    %eax,%edx
     cf0:	89 d0                	mov    %edx,%eax
}
     cf2:	5d                   	pop    %ebp
     cf3:	c3                   	ret    

00000cf4 <strlen>:

uint
strlen(const char *s)
{
     cf4:	55                   	push   %ebp
     cf5:	89 e5                	mov    %esp,%ebp
     cf7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     cfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d01:	eb 04                	jmp    d07 <strlen+0x13>
     d03:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d07:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d0a:	8b 45 08             	mov    0x8(%ebp),%eax
     d0d:	01 d0                	add    %edx,%eax
     d0f:	0f b6 00             	movzbl (%eax),%eax
     d12:	84 c0                	test   %al,%al
     d14:	75 ed                	jne    d03 <strlen+0xf>
    ;
  return n;
     d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d19:	c9                   	leave  
     d1a:	c3                   	ret    

00000d1b <memset>:

void*
memset(void *dst, int c, uint n)
{
     d1b:	55                   	push   %ebp
     d1c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d1e:	8b 45 10             	mov    0x10(%ebp),%eax
     d21:	50                   	push   %eax
     d22:	ff 75 0c             	push   0xc(%ebp)
     d25:	ff 75 08             	push   0x8(%ebp)
     d28:	e8 32 ff ff ff       	call   c5f <stosb>
     d2d:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d30:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d33:	c9                   	leave  
     d34:	c3                   	ret    

00000d35 <strchr>:

char*
strchr(const char *s, char c)
{
     d35:	55                   	push   %ebp
     d36:	89 e5                	mov    %esp,%ebp
     d38:	83 ec 04             	sub    $0x4,%esp
     d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
     d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d41:	eb 14                	jmp    d57 <strchr+0x22>
    if(*s == c)
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
     d46:	0f b6 00             	movzbl (%eax),%eax
     d49:	38 45 fc             	cmp    %al,-0x4(%ebp)
     d4c:	75 05                	jne    d53 <strchr+0x1e>
      return (char*)s;
     d4e:	8b 45 08             	mov    0x8(%ebp),%eax
     d51:	eb 13                	jmp    d66 <strchr+0x31>
  for(; *s; s++)
     d53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d57:	8b 45 08             	mov    0x8(%ebp),%eax
     d5a:	0f b6 00             	movzbl (%eax),%eax
     d5d:	84 c0                	test   %al,%al
     d5f:	75 e2                	jne    d43 <strchr+0xe>
  return 0;
     d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d66:	c9                   	leave  
     d67:	c3                   	ret    

00000d68 <gets>:

char*
gets(char *buf, int max)
{
     d68:	55                   	push   %ebp
     d69:	89 e5                	mov    %esp,%ebp
     d6b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d75:	eb 42                	jmp    db9 <gets+0x51>
    cc = read(0, &c, 1);
     d77:	83 ec 04             	sub    $0x4,%esp
     d7a:	6a 01                	push   $0x1
     d7c:	8d 45 ef             	lea    -0x11(%ebp),%eax
     d7f:	50                   	push   %eax
     d80:	6a 00                	push   $0x0
     d82:	e8 83 01 00 00       	call   f0a <read>
     d87:	83 c4 10             	add    $0x10,%esp
     d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d91:	7e 33                	jle    dc6 <gets+0x5e>
      break;
    buf[i++] = c;
     d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d96:	8d 50 01             	lea    0x1(%eax),%edx
     d99:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d9c:	89 c2                	mov    %eax,%edx
     d9e:	8b 45 08             	mov    0x8(%ebp),%eax
     da1:	01 c2                	add    %eax,%edx
     da3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     da7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     da9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dad:	3c 0a                	cmp    $0xa,%al
     daf:	74 16                	je     dc7 <gets+0x5f>
     db1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     db5:	3c 0d                	cmp    $0xd,%al
     db7:	74 0e                	je     dc7 <gets+0x5f>
  for(i=0; i+1 < max; ){
     db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dbc:	83 c0 01             	add    $0x1,%eax
     dbf:	39 45 0c             	cmp    %eax,0xc(%ebp)
     dc2:	7f b3                	jg     d77 <gets+0xf>
     dc4:	eb 01                	jmp    dc7 <gets+0x5f>
      break;
     dc6:	90                   	nop
      break;
  }
  buf[i] = '\0';
     dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dca:	8b 45 08             	mov    0x8(%ebp),%eax
     dcd:	01 d0                	add    %edx,%eax
     dcf:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     dd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dd5:	c9                   	leave  
     dd6:	c3                   	ret    

00000dd7 <stat>:

int
stat(const char *n, struct stat *st)
{
     dd7:	55                   	push   %ebp
     dd8:	89 e5                	mov    %esp,%ebp
     dda:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ddd:	83 ec 08             	sub    $0x8,%esp
     de0:	6a 00                	push   $0x0
     de2:	ff 75 08             	push   0x8(%ebp)
     de5:	e8 48 01 00 00       	call   f32 <open>
     dea:	83 c4 10             	add    $0x10,%esp
     ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     df4:	79 07                	jns    dfd <stat+0x26>
    return -1;
     df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dfb:	eb 25                	jmp    e22 <stat+0x4b>
  r = fstat(fd, st);
     dfd:	83 ec 08             	sub    $0x8,%esp
     e00:	ff 75 0c             	push   0xc(%ebp)
     e03:	ff 75 f4             	push   -0xc(%ebp)
     e06:	e8 3f 01 00 00       	call   f4a <fstat>
     e0b:	83 c4 10             	add    $0x10,%esp
     e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e11:	83 ec 0c             	sub    $0xc,%esp
     e14:	ff 75 f4             	push   -0xc(%ebp)
     e17:	e8 fe 00 00 00       	call   f1a <close>
     e1c:	83 c4 10             	add    $0x10,%esp
  return r;
     e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e22:	c9                   	leave  
     e23:	c3                   	ret    

00000e24 <atoi>:

int
atoi(const char *s)
{
     e24:	55                   	push   %ebp
     e25:	89 e5                	mov    %esp,%ebp
     e27:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e31:	eb 25                	jmp    e58 <atoi+0x34>
    n = n*10 + *s++ - '0';
     e33:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e36:	89 d0                	mov    %edx,%eax
     e38:	c1 e0 02             	shl    $0x2,%eax
     e3b:	01 d0                	add    %edx,%eax
     e3d:	01 c0                	add    %eax,%eax
     e3f:	89 c1                	mov    %eax,%ecx
     e41:	8b 45 08             	mov    0x8(%ebp),%eax
     e44:	8d 50 01             	lea    0x1(%eax),%edx
     e47:	89 55 08             	mov    %edx,0x8(%ebp)
     e4a:	0f b6 00             	movzbl (%eax),%eax
     e4d:	0f be c0             	movsbl %al,%eax
     e50:	01 c8                	add    %ecx,%eax
     e52:	83 e8 30             	sub    $0x30,%eax
     e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e58:	8b 45 08             	mov    0x8(%ebp),%eax
     e5b:	0f b6 00             	movzbl (%eax),%eax
     e5e:	3c 2f                	cmp    $0x2f,%al
     e60:	7e 0a                	jle    e6c <atoi+0x48>
     e62:	8b 45 08             	mov    0x8(%ebp),%eax
     e65:	0f b6 00             	movzbl (%eax),%eax
     e68:	3c 39                	cmp    $0x39,%al
     e6a:	7e c7                	jle    e33 <atoi+0xf>
  return n;
     e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e6f:	c9                   	leave  
     e70:	c3                   	ret    

00000e71 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e71:	55                   	push   %ebp
     e72:	89 e5                	mov    %esp,%ebp
     e74:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e80:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     e83:	eb 17                	jmp    e9c <memmove+0x2b>
    *dst++ = *src++;
     e85:	8b 55 f8             	mov    -0x8(%ebp),%edx
     e88:	8d 42 01             	lea    0x1(%edx),%eax
     e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
     e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e91:	8d 48 01             	lea    0x1(%eax),%ecx
     e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
     e97:	0f b6 12             	movzbl (%edx),%edx
     e9a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
     e9c:	8b 45 10             	mov    0x10(%ebp),%eax
     e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
     ea2:	89 55 10             	mov    %edx,0x10(%ebp)
     ea5:	85 c0                	test   %eax,%eax
     ea7:	7f dc                	jg     e85 <memmove+0x14>
  return vdst;
     ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     eac:	c9                   	leave  
     ead:	c3                   	ret    

00000eae <initiateLock>:

/////////// New additions for Parts D and E of threads lab/////////
void initiateLock(struct lock* l) {
     eae:	55                   	push   %ebp
     eaf:	89 e5                	mov    %esp,%ebp

}
     eb1:	90                   	nop
     eb2:	5d                   	pop    %ebp
     eb3:	c3                   	ret    

00000eb4 <acquireLock>:

void acquireLock(struct lock* l) {
     eb4:	55                   	push   %ebp
     eb5:	89 e5                	mov    %esp,%ebp

}
     eb7:	90                   	nop
     eb8:	5d                   	pop    %ebp
     eb9:	c3                   	ret    

00000eba <releaseLock>:

void releaseLock(struct lock* l) {
     eba:	55                   	push   %ebp
     ebb:	89 e5                	mov    %esp,%ebp

}
     ebd:	90                   	nop
     ebe:	5d                   	pop    %ebp
     ebf:	c3                   	ret    

00000ec0 <initiateCondVar>:

void initiateCondVar(struct condvar* cv) {
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp

}
     ec3:	90                   	nop
     ec4:	5d                   	pop    %ebp
     ec5:	c3                   	ret    

00000ec6 <condWait>:

void condWait(struct condvar* cv, struct lock* l) {
     ec6:	55                   	push   %ebp
     ec7:	89 e5                	mov    %esp,%ebp

}
     ec9:	90                   	nop
     eca:	5d                   	pop    %ebp
     ecb:	c3                   	ret    

00000ecc <broadcast>:

void broadcast(struct condvar* cv) {
     ecc:	55                   	push   %ebp
     ecd:	89 e5                	mov    %esp,%ebp

}
     ecf:	90                   	nop
     ed0:	5d                   	pop    %ebp
     ed1:	c3                   	ret    

00000ed2 <signal>:

void signal(struct condvar* cv) {
     ed2:	55                   	push   %ebp
     ed3:	89 e5                	mov    %esp,%ebp

}
     ed5:	90                   	nop
     ed6:	5d                   	pop    %ebp
     ed7:	c3                   	ret    

00000ed8 <semInit>:

void semInit(struct semaphore* s, int initVal) {
     ed8:	55                   	push   %ebp
     ed9:	89 e5                	mov    %esp,%ebp

}
     edb:	90                   	nop
     edc:	5d                   	pop    %ebp
     edd:	c3                   	ret    

00000ede <semUp>:

void semUp(struct semaphore* s) {
     ede:	55                   	push   %ebp
     edf:	89 e5                	mov    %esp,%ebp

}
     ee1:	90                   	nop
     ee2:	5d                   	pop    %ebp
     ee3:	c3                   	ret    

00000ee4 <semDown>:

void semDown(struct semaphore* s) {
     ee4:	55                   	push   %ebp
     ee5:	89 e5                	mov    %esp,%ebp

}
     ee7:	90                   	nop
     ee8:	5d                   	pop    %ebp
     ee9:	c3                   	ret    

00000eea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     eea:	b8 01 00 00 00       	mov    $0x1,%eax
     eef:	cd 40                	int    $0x40
     ef1:	c3                   	ret    

00000ef2 <exit>:
SYSCALL(exit)
     ef2:	b8 02 00 00 00       	mov    $0x2,%eax
     ef7:	cd 40                	int    $0x40
     ef9:	c3                   	ret    

00000efa <wait>:
SYSCALL(wait)
     efa:	b8 03 00 00 00       	mov    $0x3,%eax
     eff:	cd 40                	int    $0x40
     f01:	c3                   	ret    

00000f02 <pipe>:
SYSCALL(pipe)
     f02:	b8 04 00 00 00       	mov    $0x4,%eax
     f07:	cd 40                	int    $0x40
     f09:	c3                   	ret    

00000f0a <read>:
SYSCALL(read)
     f0a:	b8 05 00 00 00       	mov    $0x5,%eax
     f0f:	cd 40                	int    $0x40
     f11:	c3                   	ret    

00000f12 <write>:
SYSCALL(write)
     f12:	b8 10 00 00 00       	mov    $0x10,%eax
     f17:	cd 40                	int    $0x40
     f19:	c3                   	ret    

00000f1a <close>:
SYSCALL(close)
     f1a:	b8 15 00 00 00       	mov    $0x15,%eax
     f1f:	cd 40                	int    $0x40
     f21:	c3                   	ret    

00000f22 <kill>:
SYSCALL(kill)
     f22:	b8 06 00 00 00       	mov    $0x6,%eax
     f27:	cd 40                	int    $0x40
     f29:	c3                   	ret    

00000f2a <exec>:
SYSCALL(exec)
     f2a:	b8 07 00 00 00       	mov    $0x7,%eax
     f2f:	cd 40                	int    $0x40
     f31:	c3                   	ret    

00000f32 <open>:
SYSCALL(open)
     f32:	b8 0f 00 00 00       	mov    $0xf,%eax
     f37:	cd 40                	int    $0x40
     f39:	c3                   	ret    

00000f3a <mknod>:
SYSCALL(mknod)
     f3a:	b8 11 00 00 00       	mov    $0x11,%eax
     f3f:	cd 40                	int    $0x40
     f41:	c3                   	ret    

00000f42 <unlink>:
SYSCALL(unlink)
     f42:	b8 12 00 00 00       	mov    $0x12,%eax
     f47:	cd 40                	int    $0x40
     f49:	c3                   	ret    

00000f4a <fstat>:
SYSCALL(fstat)
     f4a:	b8 08 00 00 00       	mov    $0x8,%eax
     f4f:	cd 40                	int    $0x40
     f51:	c3                   	ret    

00000f52 <link>:
SYSCALL(link)
     f52:	b8 13 00 00 00       	mov    $0x13,%eax
     f57:	cd 40                	int    $0x40
     f59:	c3                   	ret    

00000f5a <mkdir>:
SYSCALL(mkdir)
     f5a:	b8 14 00 00 00       	mov    $0x14,%eax
     f5f:	cd 40                	int    $0x40
     f61:	c3                   	ret    

00000f62 <chdir>:
SYSCALL(chdir)
     f62:	b8 09 00 00 00       	mov    $0x9,%eax
     f67:	cd 40                	int    $0x40
     f69:	c3                   	ret    

00000f6a <dup>:
SYSCALL(dup)
     f6a:	b8 0a 00 00 00       	mov    $0xa,%eax
     f6f:	cd 40                	int    $0x40
     f71:	c3                   	ret    

00000f72 <getpid>:
SYSCALL(getpid)
     f72:	b8 0b 00 00 00       	mov    $0xb,%eax
     f77:	cd 40                	int    $0x40
     f79:	c3                   	ret    

00000f7a <sbrk>:
SYSCALL(sbrk)
     f7a:	b8 0c 00 00 00       	mov    $0xc,%eax
     f7f:	cd 40                	int    $0x40
     f81:	c3                   	ret    

00000f82 <sleep>:
SYSCALL(sleep)
     f82:	b8 0d 00 00 00       	mov    $0xd,%eax
     f87:	cd 40                	int    $0x40
     f89:	c3                   	ret    

00000f8a <uptime>:
SYSCALL(uptime)
     f8a:	b8 0e 00 00 00       	mov    $0xe,%eax
     f8f:	cd 40                	int    $0x40
     f91:	c3                   	ret    

00000f92 <thread_create>:
SYSCALL(thread_create)
     f92:	b8 16 00 00 00       	mov    $0x16,%eax
     f97:	cd 40                	int    $0x40
     f99:	c3                   	ret    

00000f9a <thread_exit>:
SYSCALL(thread_exit)
     f9a:	b8 17 00 00 00       	mov    $0x17,%eax
     f9f:	cd 40                	int    $0x40
     fa1:	c3                   	ret    

00000fa2 <thread_join>:
SYSCALL(thread_join)
     fa2:	b8 18 00 00 00       	mov    $0x18,%eax
     fa7:	cd 40                	int    $0x40
     fa9:	c3                   	ret    

00000faa <waitpid>:
SYSCALL(waitpid)
     faa:	b8 1e 00 00 00       	mov    $0x1e,%eax
     faf:	cd 40                	int    $0x40
     fb1:	c3                   	ret    

00000fb2 <barrier_init>:
SYSCALL(barrier_init)
     fb2:	b8 1f 00 00 00       	mov    $0x1f,%eax
     fb7:	cd 40                	int    $0x40
     fb9:	c3                   	ret    

00000fba <barrier_check>:
SYSCALL(barrier_check)
     fba:	b8 20 00 00 00       	mov    $0x20,%eax
     fbf:	cd 40                	int    $0x40
     fc1:	c3                   	ret    

00000fc2 <sleepChan>:
SYSCALL(sleepChan)
     fc2:	b8 24 00 00 00       	mov    $0x24,%eax
     fc7:	cd 40                	int    $0x40
     fc9:	c3                   	ret    

00000fca <getChannel>:
SYSCALL(getChannel)
     fca:	b8 25 00 00 00       	mov    $0x25,%eax
     fcf:	cd 40                	int    $0x40
     fd1:	c3                   	ret    

00000fd2 <sigChan>:
SYSCALL(sigChan)
     fd2:	b8 26 00 00 00       	mov    $0x26,%eax
     fd7:	cd 40                	int    $0x40
     fd9:	c3                   	ret    

00000fda <sigOneChan>:
     fda:	b8 27 00 00 00       	mov    $0x27,%eax
     fdf:	cd 40                	int    $0x40
     fe1:	c3                   	ret    

00000fe2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     fe2:	55                   	push   %ebp
     fe3:	89 e5                	mov    %esp,%ebp
     fe5:	83 ec 18             	sub    $0x18,%esp
     fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
     feb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     fee:	83 ec 04             	sub    $0x4,%esp
     ff1:	6a 01                	push   $0x1
     ff3:	8d 45 f4             	lea    -0xc(%ebp),%eax
     ff6:	50                   	push   %eax
     ff7:	ff 75 08             	push   0x8(%ebp)
     ffa:	e8 13 ff ff ff       	call   f12 <write>
     fff:	83 c4 10             	add    $0x10,%esp
}
    1002:	90                   	nop
    1003:	c9                   	leave  
    1004:	c3                   	ret    

00001005 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1005:	55                   	push   %ebp
    1006:	89 e5                	mov    %esp,%ebp
    1008:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    100b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1012:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1016:	74 17                	je     102f <printint+0x2a>
    1018:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    101c:	79 11                	jns    102f <printint+0x2a>
    neg = 1;
    101e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1025:	8b 45 0c             	mov    0xc(%ebp),%eax
    1028:	f7 d8                	neg    %eax
    102a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    102d:	eb 06                	jmp    1035 <printint+0x30>
  } else {
    x = xx;
    102f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1032:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1035:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    103c:	8b 4d 10             	mov    0x10(%ebp),%ecx
    103f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1042:	ba 00 00 00 00       	mov    $0x0,%edx
    1047:	f7 f1                	div    %ecx
    1049:	89 d1                	mov    %edx,%ecx
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	8d 50 01             	lea    0x1(%eax),%edx
    1051:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1054:	0f b6 91 34 1b 00 00 	movzbl 0x1b34(%ecx),%edx
    105b:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    105f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1062:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1065:	ba 00 00 00 00       	mov    $0x0,%edx
    106a:	f7 f1                	div    %ecx
    106c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    106f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1073:	75 c7                	jne    103c <printint+0x37>
  if(neg)
    1075:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1079:	74 2d                	je     10a8 <printint+0xa3>
    buf[i++] = '-';
    107b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107e:	8d 50 01             	lea    0x1(%eax),%edx
    1081:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1084:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1089:	eb 1d                	jmp    10a8 <printint+0xa3>
    putc(fd, buf[i]);
    108b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    108e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1091:	01 d0                	add    %edx,%eax
    1093:	0f b6 00             	movzbl (%eax),%eax
    1096:	0f be c0             	movsbl %al,%eax
    1099:	83 ec 08             	sub    $0x8,%esp
    109c:	50                   	push   %eax
    109d:	ff 75 08             	push   0x8(%ebp)
    10a0:	e8 3d ff ff ff       	call   fe2 <putc>
    10a5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    10a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10b0:	79 d9                	jns    108b <printint+0x86>
}
    10b2:	90                   	nop
    10b3:	c9                   	leave  
    10b4:	c3                   	ret    

000010b5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    10b5:	55                   	push   %ebp
    10b6:	89 e5                	mov    %esp,%ebp
    10b8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10c2:	8d 45 0c             	lea    0xc(%ebp),%eax
    10c5:	83 c0 04             	add    $0x4,%eax
    10c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10d2:	e9 59 01 00 00       	jmp    1230 <printf+0x17b>
    c = fmt[i] & 0xff;
    10d7:	8b 55 0c             	mov    0xc(%ebp),%edx
    10da:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10dd:	01 d0                	add    %edx,%eax
    10df:	0f b6 00             	movzbl (%eax),%eax
    10e2:	0f be c0             	movsbl %al,%eax
    10e5:	25 ff 00 00 00       	and    $0xff,%eax
    10ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    10ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10f1:	75 2c                	jne    111f <printf+0x6a>
      if(c == '%'){
    10f3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10f7:	75 0c                	jne    1105 <printf+0x50>
        state = '%';
    10f9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1100:	e9 27 01 00 00       	jmp    122c <printf+0x177>
      } else {
        putc(fd, c);
    1105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1108:	0f be c0             	movsbl %al,%eax
    110b:	83 ec 08             	sub    $0x8,%esp
    110e:	50                   	push   %eax
    110f:	ff 75 08             	push   0x8(%ebp)
    1112:	e8 cb fe ff ff       	call   fe2 <putc>
    1117:	83 c4 10             	add    $0x10,%esp
    111a:	e9 0d 01 00 00       	jmp    122c <printf+0x177>
      }
    } else if(state == '%'){
    111f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1123:	0f 85 03 01 00 00    	jne    122c <printf+0x177>
      if(c == 'd'){
    1129:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    112d:	75 1e                	jne    114d <printf+0x98>
        printint(fd, *ap, 10, 1);
    112f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1132:	8b 00                	mov    (%eax),%eax
    1134:	6a 01                	push   $0x1
    1136:	6a 0a                	push   $0xa
    1138:	50                   	push   %eax
    1139:	ff 75 08             	push   0x8(%ebp)
    113c:	e8 c4 fe ff ff       	call   1005 <printint>
    1141:	83 c4 10             	add    $0x10,%esp
        ap++;
    1144:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1148:	e9 d8 00 00 00       	jmp    1225 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    114d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1151:	74 06                	je     1159 <printf+0xa4>
    1153:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1157:	75 1e                	jne    1177 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1159:	8b 45 e8             	mov    -0x18(%ebp),%eax
    115c:	8b 00                	mov    (%eax),%eax
    115e:	6a 00                	push   $0x0
    1160:	6a 10                	push   $0x10
    1162:	50                   	push   %eax
    1163:	ff 75 08             	push   0x8(%ebp)
    1166:	e8 9a fe ff ff       	call   1005 <printint>
    116b:	83 c4 10             	add    $0x10,%esp
        ap++;
    116e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1172:	e9 ae 00 00 00       	jmp    1225 <printf+0x170>
      } else if(c == 's'){
    1177:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    117b:	75 43                	jne    11c0 <printf+0x10b>
        s = (char*)*ap;
    117d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1180:	8b 00                	mov    (%eax),%eax
    1182:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1185:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    118d:	75 25                	jne    11b4 <printf+0xff>
          s = "(null)";
    118f:	c7 45 f4 5c 15 00 00 	movl   $0x155c,-0xc(%ebp)
        while(*s != 0){
    1196:	eb 1c                	jmp    11b4 <printf+0xff>
          putc(fd, *s);
    1198:	8b 45 f4             	mov    -0xc(%ebp),%eax
    119b:	0f b6 00             	movzbl (%eax),%eax
    119e:	0f be c0             	movsbl %al,%eax
    11a1:	83 ec 08             	sub    $0x8,%esp
    11a4:	50                   	push   %eax
    11a5:	ff 75 08             	push   0x8(%ebp)
    11a8:	e8 35 fe ff ff       	call   fe2 <putc>
    11ad:	83 c4 10             	add    $0x10,%esp
          s++;
    11b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    11b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b7:	0f b6 00             	movzbl (%eax),%eax
    11ba:	84 c0                	test   %al,%al
    11bc:	75 da                	jne    1198 <printf+0xe3>
    11be:	eb 65                	jmp    1225 <printf+0x170>
        }
      } else if(c == 'c'){
    11c0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    11c4:	75 1d                	jne    11e3 <printf+0x12e>
        putc(fd, *ap);
    11c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11c9:	8b 00                	mov    (%eax),%eax
    11cb:	0f be c0             	movsbl %al,%eax
    11ce:	83 ec 08             	sub    $0x8,%esp
    11d1:	50                   	push   %eax
    11d2:	ff 75 08             	push   0x8(%ebp)
    11d5:	e8 08 fe ff ff       	call   fe2 <putc>
    11da:	83 c4 10             	add    $0x10,%esp
        ap++;
    11dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11e1:	eb 42                	jmp    1225 <printf+0x170>
      } else if(c == '%'){
    11e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11e7:	75 17                	jne    1200 <printf+0x14b>
        putc(fd, c);
    11e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11ec:	0f be c0             	movsbl %al,%eax
    11ef:	83 ec 08             	sub    $0x8,%esp
    11f2:	50                   	push   %eax
    11f3:	ff 75 08             	push   0x8(%ebp)
    11f6:	e8 e7 fd ff ff       	call   fe2 <putc>
    11fb:	83 c4 10             	add    $0x10,%esp
    11fe:	eb 25                	jmp    1225 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1200:	83 ec 08             	sub    $0x8,%esp
    1203:	6a 25                	push   $0x25
    1205:	ff 75 08             	push   0x8(%ebp)
    1208:	e8 d5 fd ff ff       	call   fe2 <putc>
    120d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1213:	0f be c0             	movsbl %al,%eax
    1216:	83 ec 08             	sub    $0x8,%esp
    1219:	50                   	push   %eax
    121a:	ff 75 08             	push   0x8(%ebp)
    121d:	e8 c0 fd ff ff       	call   fe2 <putc>
    1222:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1225:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    122c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1230:	8b 55 0c             	mov    0xc(%ebp),%edx
    1233:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1236:	01 d0                	add    %edx,%eax
    1238:	0f b6 00             	movzbl (%eax),%eax
    123b:	84 c0                	test   %al,%al
    123d:	0f 85 94 fe ff ff    	jne    10d7 <printf+0x22>
    }
  }
}
    1243:	90                   	nop
    1244:	c9                   	leave  
    1245:	c3                   	ret    

00001246 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1246:	55                   	push   %ebp
    1247:	89 e5                	mov    %esp,%ebp
    1249:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	83 e8 08             	sub    $0x8,%eax
    1252:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1255:	a1 cc 1b 00 00       	mov    0x1bcc,%eax
    125a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    125d:	eb 24                	jmp    1283 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1262:	8b 00                	mov    (%eax),%eax
    1264:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    1267:	72 12                	jb     127b <free+0x35>
    1269:	8b 45 f8             	mov    -0x8(%ebp),%eax
    126c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    126f:	77 24                	ja     1295 <free+0x4f>
    1271:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1274:	8b 00                	mov    (%eax),%eax
    1276:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1279:	72 1a                	jb     1295 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    127b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127e:	8b 00                	mov    (%eax),%eax
    1280:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1283:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1286:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1289:	76 d4                	jbe    125f <free+0x19>
    128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    128e:	8b 00                	mov    (%eax),%eax
    1290:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1293:	73 ca                	jae    125f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1295:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1298:	8b 40 04             	mov    0x4(%eax),%eax
    129b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12a5:	01 c2                	add    %eax,%edx
    12a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12aa:	8b 00                	mov    (%eax),%eax
    12ac:	39 c2                	cmp    %eax,%edx
    12ae:	75 24                	jne    12d4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    12b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12b3:	8b 50 04             	mov    0x4(%eax),%edx
    12b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b9:	8b 00                	mov    (%eax),%eax
    12bb:	8b 40 04             	mov    0x4(%eax),%eax
    12be:	01 c2                	add    %eax,%edx
    12c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12c3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    12c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c9:	8b 00                	mov    (%eax),%eax
    12cb:	8b 10                	mov    (%eax),%edx
    12cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d0:	89 10                	mov    %edx,(%eax)
    12d2:	eb 0a                	jmp    12de <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    12d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d7:	8b 10                	mov    (%eax),%edx
    12d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12dc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    12de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e1:	8b 40 04             	mov    0x4(%eax),%eax
    12e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ee:	01 d0                	add    %edx,%eax
    12f0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    12f3:	75 20                	jne    1315 <free+0xcf>
    p->s.size += bp->s.size;
    12f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12f8:	8b 50 04             	mov    0x4(%eax),%edx
    12fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12fe:	8b 40 04             	mov    0x4(%eax),%eax
    1301:	01 c2                	add    %eax,%edx
    1303:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1306:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1309:	8b 45 f8             	mov    -0x8(%ebp),%eax
    130c:	8b 10                	mov    (%eax),%edx
    130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1311:	89 10                	mov    %edx,(%eax)
    1313:	eb 08                	jmp    131d <free+0xd7>
  } else
    p->s.ptr = bp;
    1315:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1318:	8b 55 f8             	mov    -0x8(%ebp),%edx
    131b:	89 10                	mov    %edx,(%eax)
  freep = p;
    131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1320:	a3 cc 1b 00 00       	mov    %eax,0x1bcc
}
    1325:	90                   	nop
    1326:	c9                   	leave  
    1327:	c3                   	ret    

00001328 <morecore>:

static Header*
morecore(uint nu)
{
    1328:	55                   	push   %ebp
    1329:	89 e5                	mov    %esp,%ebp
    132b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    132e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1335:	77 07                	ja     133e <morecore+0x16>
    nu = 4096;
    1337:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    133e:	8b 45 08             	mov    0x8(%ebp),%eax
    1341:	c1 e0 03             	shl    $0x3,%eax
    1344:	83 ec 0c             	sub    $0xc,%esp
    1347:	50                   	push   %eax
    1348:	e8 2d fc ff ff       	call   f7a <sbrk>
    134d:	83 c4 10             	add    $0x10,%esp
    1350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1353:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1357:	75 07                	jne    1360 <morecore+0x38>
    return 0;
    1359:	b8 00 00 00 00       	mov    $0x0,%eax
    135e:	eb 26                	jmp    1386 <morecore+0x5e>
  hp = (Header*)p;
    1360:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1363:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1366:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1369:	8b 55 08             	mov    0x8(%ebp),%edx
    136c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1372:	83 c0 08             	add    $0x8,%eax
    1375:	83 ec 0c             	sub    $0xc,%esp
    1378:	50                   	push   %eax
    1379:	e8 c8 fe ff ff       	call   1246 <free>
    137e:	83 c4 10             	add    $0x10,%esp
  return freep;
    1381:	a1 cc 1b 00 00       	mov    0x1bcc,%eax
}
    1386:	c9                   	leave  
    1387:	c3                   	ret    

00001388 <malloc>:

void*
malloc(uint nbytes)
{
    1388:	55                   	push   %ebp
    1389:	89 e5                	mov    %esp,%ebp
    138b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    138e:	8b 45 08             	mov    0x8(%ebp),%eax
    1391:	83 c0 07             	add    $0x7,%eax
    1394:	c1 e8 03             	shr    $0x3,%eax
    1397:	83 c0 01             	add    $0x1,%eax
    139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    139d:	a1 cc 1b 00 00       	mov    0x1bcc,%eax
    13a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13a9:	75 23                	jne    13ce <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13ab:	c7 45 f0 c4 1b 00 00 	movl   $0x1bc4,-0x10(%ebp)
    13b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b5:	a3 cc 1b 00 00       	mov    %eax,0x1bcc
    13ba:	a1 cc 1b 00 00       	mov    0x1bcc,%eax
    13bf:	a3 c4 1b 00 00       	mov    %eax,0x1bc4
    base.s.size = 0;
    13c4:	c7 05 c8 1b 00 00 00 	movl   $0x0,0x1bc8
    13cb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13d1:	8b 00                	mov    (%eax),%eax
    13d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    13d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d9:	8b 40 04             	mov    0x4(%eax),%eax
    13dc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    13df:	77 4d                	ja     142e <malloc+0xa6>
      if(p->s.size == nunits)
    13e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13e4:	8b 40 04             	mov    0x4(%eax),%eax
    13e7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    13ea:	75 0c                	jne    13f8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    13ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ef:	8b 10                	mov    (%eax),%edx
    13f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13f4:	89 10                	mov    %edx,(%eax)
    13f6:	eb 26                	jmp    141e <malloc+0x96>
      else {
        p->s.size -= nunits;
    13f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fb:	8b 40 04             	mov    0x4(%eax),%eax
    13fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1401:	89 c2                	mov    %eax,%edx
    1403:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1406:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1409:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140c:	8b 40 04             	mov    0x4(%eax),%eax
    140f:	c1 e0 03             	shl    $0x3,%eax
    1412:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1415:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1418:	8b 55 ec             	mov    -0x14(%ebp),%edx
    141b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    141e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1421:	a3 cc 1b 00 00       	mov    %eax,0x1bcc
      return (void*)(p + 1);
    1426:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1429:	83 c0 08             	add    $0x8,%eax
    142c:	eb 3b                	jmp    1469 <malloc+0xe1>
    }
    if(p == freep)
    142e:	a1 cc 1b 00 00       	mov    0x1bcc,%eax
    1433:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1436:	75 1e                	jne    1456 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1438:	83 ec 0c             	sub    $0xc,%esp
    143b:	ff 75 ec             	push   -0x14(%ebp)
    143e:	e8 e5 fe ff ff       	call   1328 <morecore>
    1443:	83 c4 10             	add    $0x10,%esp
    1446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    144d:	75 07                	jne    1456 <malloc+0xce>
        return 0;
    144f:	b8 00 00 00 00       	mov    $0x0,%eax
    1454:	eb 13                	jmp    1469 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1456:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1459:	89 45 f0             	mov    %eax,-0x10(%ebp)
    145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145f:	8b 00                	mov    (%eax),%eax
    1461:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1464:	e9 6d ff ff ff       	jmp    13d6 <malloc+0x4e>
  }
}
    1469:	c9                   	leave  
    146a:	c3                   	ret    
