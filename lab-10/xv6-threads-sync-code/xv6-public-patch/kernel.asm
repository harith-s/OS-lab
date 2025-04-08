
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 4b 38 10 80       	mov    $0x8010384b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 b0 8b 10 80       	push   $0x80108bb0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 0d 55 00 00       	call   80105559 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 cc 1d 11 80 7c 	movl   $0x80111d7c,0x80111dcc
80100056:	1d 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d0 1d 11 80 7c 	movl   $0x80111d7c,0x80111dd0
80100060:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 b7 8b 10 80       	push   $0x80108bb7
80100090:	50                   	push   %eax
80100091:	e8 40 53 00 00       	call   801053d6 <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 7c 1d 11 80       	mov    $0x80111d7c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
  }
}
801000bd:	90                   	nop
801000be:	c9                   	leave  
801000bf:	c3                   	ret    

801000c0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c6:	83 ec 0c             	sub    $0xc,%esp
801000c9:	68 80 d6 10 80       	push   $0x8010d680
801000ce:	e8 a8 54 00 00       	call   8010557b <acquire>
801000d3:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d6:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000de:	eb 58                	jmp    80100138 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e3:	8b 40 04             	mov    0x4(%eax),%eax
801000e6:	39 45 08             	cmp    %eax,0x8(%ebp)
801000e9:	75 44                	jne    8010012f <bget+0x6f>
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	8b 40 08             	mov    0x8(%eax),%eax
801000f1:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000f4:	75 39                	jne    8010012f <bget+0x6f>
      b->refcnt++;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fc:	8d 50 01             	lea    0x1(%eax),%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 80 d6 10 80       	push   $0x8010d680
8010010d:	e8 d7 54 00 00       	call   801055e9 <release>
80100112:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	83 c0 0c             	add    $0xc,%eax
8010011b:	83 ec 0c             	sub    $0xc,%esp
8010011e:	50                   	push   %eax
8010011f:	e8 ee 52 00 00       	call   80105412 <acquiresleep>
80100124:	83 c4 10             	add    $0x10,%esp
      return b;
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	e9 9d 00 00 00       	jmp    801001cc <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 54             	mov    0x54(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
8010013f:	75 9f                	jne    801000e0 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 cc 1d 11 80       	mov    0x80111dcc,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 6b                	jmp    801001b6 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100151:	85 c0                	test   %eax,%eax
80100153:	75 58                	jne    801001ad <bget+0xed>
80100155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100158:	8b 00                	mov    (%eax),%eax
8010015a:	83 e0 04             	and    $0x4,%eax
8010015d:	85 c0                	test   %eax,%eax
8010015f:	75 4c                	jne    801001ad <bget+0xed>
      b->dev = dev;
80100161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100164:	8b 55 08             	mov    0x8(%ebp),%edx
80100167:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100170:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100186:	83 ec 0c             	sub    $0xc,%esp
80100189:	68 80 d6 10 80       	push   $0x8010d680
8010018e:	e8 56 54 00 00       	call   801055e9 <release>
80100193:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	83 c0 0c             	add    $0xc,%eax
8010019c:	83 ec 0c             	sub    $0xc,%esp
8010019f:	50                   	push   %eax
801001a0:	e8 6d 52 00 00       	call   80105412 <acquiresleep>
801001a5:	83 c4 10             	add    $0x10,%esp
      return b;
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	eb 1f                	jmp    801001cc <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b0:	8b 40 50             	mov    0x50(%eax),%eax
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801001bd:	75 8c                	jne    8010014b <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001bf:	83 ec 0c             	sub    $0xc,%esp
801001c2:	68 be 8b 10 80       	push   $0x80108bbe
801001c7:	e8 d0 03 00 00       	call   8010059c <panic>
}
801001cc:	c9                   	leave  
801001cd:	c3                   	ret    

801001ce <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001ce:	55                   	push   %ebp
801001cf:	89 e5                	mov    %esp,%ebp
801001d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d4:	83 ec 08             	sub    $0x8,%esp
801001d7:	ff 75 0c             	push   0xc(%ebp)
801001da:	ff 75 08             	push   0x8(%ebp)
801001dd:	e8 de fe ff ff       	call   801000c0 <bget>
801001e2:	83 c4 10             	add    $0x10,%esp
801001e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 00                	mov    (%eax),%eax
801001ed:	83 e0 02             	and    $0x2,%eax
801001f0:	85 c0                	test   %eax,%eax
801001f2:	75 0e                	jne    80100202 <bread+0x34>
    iderw(b);
801001f4:	83 ec 0c             	sub    $0xc,%esp
801001f7:	ff 75 f4             	push   -0xc(%ebp)
801001fa:	e8 49 27 00 00       	call   80102948 <iderw>
801001ff:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100205:	c9                   	leave  
80100206:	c3                   	ret    

80100207 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100207:	55                   	push   %ebp
80100208:	89 e5                	mov    %esp,%ebp
8010020a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	83 c0 0c             	add    $0xc,%eax
80100213:	83 ec 0c             	sub    $0xc,%esp
80100216:	50                   	push   %eax
80100217:	e8 a8 52 00 00       	call   801054c4 <holdingsleep>
8010021c:	83 c4 10             	add    $0x10,%esp
8010021f:	85 c0                	test   %eax,%eax
80100221:	75 0d                	jne    80100230 <bwrite+0x29>
    panic("bwrite");
80100223:	83 ec 0c             	sub    $0xc,%esp
80100226:	68 cf 8b 10 80       	push   $0x80108bcf
8010022b:	e8 6c 03 00 00       	call   8010059c <panic>
  b->flags |= B_DIRTY;
80100230:	8b 45 08             	mov    0x8(%ebp),%eax
80100233:	8b 00                	mov    (%eax),%eax
80100235:	83 c8 04             	or     $0x4,%eax
80100238:	89 c2                	mov    %eax,%edx
8010023a:	8b 45 08             	mov    0x8(%ebp),%eax
8010023d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	ff 75 08             	push   0x8(%ebp)
80100245:	e8 fe 26 00 00       	call   80102948 <iderw>
8010024a:	83 c4 10             	add    $0x10,%esp
}
8010024d:	90                   	nop
8010024e:	c9                   	leave  
8010024f:	c3                   	ret    

80100250 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100256:	8b 45 08             	mov    0x8(%ebp),%eax
80100259:	83 c0 0c             	add    $0xc,%eax
8010025c:	83 ec 0c             	sub    $0xc,%esp
8010025f:	50                   	push   %eax
80100260:	e8 5f 52 00 00       	call   801054c4 <holdingsleep>
80100265:	83 c4 10             	add    $0x10,%esp
80100268:	85 c0                	test   %eax,%eax
8010026a:	75 0d                	jne    80100279 <brelse+0x29>
    panic("brelse");
8010026c:	83 ec 0c             	sub    $0xc,%esp
8010026f:	68 d6 8b 10 80       	push   $0x80108bd6
80100274:	e8 23 03 00 00       	call   8010059c <panic>

  releasesleep(&b->lock);
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	83 c0 0c             	add    $0xc,%eax
8010027f:	83 ec 0c             	sub    $0xc,%esp
80100282:	50                   	push   %eax
80100283:	e8 ee 51 00 00       	call   80105476 <releasesleep>
80100288:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028b:	83 ec 0c             	sub    $0xc,%esp
8010028e:	68 80 d6 10 80       	push   $0x8010d680
80100293:	e8 e3 52 00 00       	call   8010557b <acquire>
80100298:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029b:	8b 45 08             	mov    0x8(%ebp),%eax
8010029e:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002aa:	8b 45 08             	mov    0x8(%ebp),%eax
801002ad:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 47                	jne    801002fb <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b4:	8b 45 08             	mov    0x8(%ebp),%eax
801002b7:	8b 40 54             	mov    0x54(%eax),%eax
801002ba:	8b 55 08             	mov    0x8(%ebp),%edx
801002bd:	8b 52 50             	mov    0x50(%edx),%edx
801002c0:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	8b 40 50             	mov    0x50(%eax),%eax
801002c9:	8b 55 08             	mov    0x8(%ebp),%edx
801002cc:	8b 52 54             	mov    0x54(%edx),%edx
801002cf:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d2:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002e8:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0
  }
  
  release(&bcache.lock);
801002fb:	83 ec 0c             	sub    $0xc,%esp
801002fe:	68 80 d6 10 80       	push   $0x8010d680
80100303:	e8 e1 52 00 00       	call   801055e9 <release>
80100308:	83 c4 10             	add    $0x10,%esp
}
8010030b:	90                   	nop
8010030c:	c9                   	leave  
8010030d:	c3                   	ret    

8010030e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030e:	55                   	push   %ebp
8010030f:	89 e5                	mov    %esp,%ebp
80100311:	83 ec 14             	sub    $0x14,%esp
80100314:	8b 45 08             	mov    0x8(%ebp),%eax
80100317:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010031f:	89 c2                	mov    %eax,%edx
80100321:	ec                   	in     (%dx),%al
80100322:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100325:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100329:	c9                   	leave  
8010032a:	c3                   	ret    

8010032b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032b:	55                   	push   %ebp
8010032c:	89 e5                	mov    %esp,%ebp
8010032e:	83 ec 08             	sub    $0x8,%esp
80100331:	8b 55 08             	mov    0x8(%ebp),%edx
80100334:	8b 45 0c             	mov    0xc(%ebp),%eax
80100337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100342:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100346:	ee                   	out    %al,(%dx)
}
80100347:	90                   	nop
80100348:	c9                   	leave  
80100349:	c3                   	ret    

8010034a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034a:	55                   	push   %ebp
8010034b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034d:	fa                   	cli    
}
8010034e:	90                   	nop
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
80100354:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100357:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035b:	74 1c                	je     80100379 <printint+0x28>
8010035d:	8b 45 08             	mov    0x8(%ebp),%eax
80100360:	c1 e8 1f             	shr    $0x1f,%eax
80100363:	0f b6 c0             	movzbl %al,%eax
80100366:	89 45 10             	mov    %eax,0x10(%ebp)
80100369:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036d:	74 0a                	je     80100379 <printint+0x28>
    x = -xx;
8010036f:	8b 45 08             	mov    0x8(%ebp),%eax
80100372:	f7 d8                	neg    %eax
80100374:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100377:	eb 06                	jmp    8010037f <printint+0x2e>
  else
    x = xx;
80100379:	8b 45 08             	mov    0x8(%ebp),%eax
8010037c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010037f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010038c:	ba 00 00 00 00       	mov    $0x0,%edx
80100391:	f7 f1                	div    %ecx
80100393:	89 d1                	mov    %edx,%ecx
80100395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100398:	8d 50 01             	lea    0x1(%eax),%edx
8010039b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010039e:	0f b6 91 04 a0 10 80 	movzbl -0x7fef5ffc(%ecx),%edx
801003a5:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003af:	ba 00 00 00 00       	mov    $0x0,%edx
801003b4:	f7 f1                	div    %ecx
801003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003bd:	75 c7                	jne    80100386 <printint+0x35>

  if(sign)
801003bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c3:	74 2a                	je     801003ef <printint+0x9e>
    buf[i++] = '-';
801003c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c8:	8d 50 01             	lea    0x1(%eax),%edx
801003cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003ce:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d3:	eb 1a                	jmp    801003ef <printint+0x9e>
    consputc(buf[i]);
801003d5:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003db:	01 d0                	add    %edx,%eax
801003dd:	0f b6 00             	movzbl (%eax),%eax
801003e0:	0f be c0             	movsbl %al,%eax
801003e3:	83 ec 0c             	sub    $0xc,%esp
801003e6:	50                   	push   %eax
801003e7:	e8 dd 03 00 00       	call   801007c9 <consputc>
801003ec:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003ef:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f7:	79 dc                	jns    801003d5 <printint+0x84>
}
801003f9:	90                   	nop
801003fa:	c9                   	leave  
801003fb:	c3                   	ret    

801003fc <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003fc:	55                   	push   %ebp
801003fd:	89 e5                	mov    %esp,%ebp
801003ff:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100402:	a1 14 c6 10 80       	mov    0x8010c614,%eax
80100407:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010040e:	74 10                	je     80100420 <cprintf+0x24>
    acquire(&cons.lock);
80100410:	83 ec 0c             	sub    $0xc,%esp
80100413:	68 e0 c5 10 80       	push   $0x8010c5e0
80100418:	e8 5e 51 00 00       	call   8010557b <acquire>
8010041d:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100420:	8b 45 08             	mov    0x8(%ebp),%eax
80100423:	85 c0                	test   %eax,%eax
80100425:	75 0d                	jne    80100434 <cprintf+0x38>
    panic("null fmt");
80100427:	83 ec 0c             	sub    $0xc,%esp
8010042a:	68 dd 8b 10 80       	push   $0x80108bdd
8010042f:	e8 68 01 00 00       	call   8010059c <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100434:	8d 45 0c             	lea    0xc(%ebp),%eax
80100437:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100441:	e9 1a 01 00 00       	jmp    80100560 <cprintf+0x164>
    if(c != '%'){
80100446:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044a:	74 13                	je     8010045f <cprintf+0x63>
      consputc(c);
8010044c:	83 ec 0c             	sub    $0xc,%esp
8010044f:	ff 75 e4             	push   -0x1c(%ebp)
80100452:	e8 72 03 00 00       	call   801007c9 <consputc>
80100457:	83 c4 10             	add    $0x10,%esp
      continue;
8010045a:	e9 fd 00 00 00       	jmp    8010055c <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
8010045f:	8b 55 08             	mov    0x8(%ebp),%edx
80100462:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100469:	01 d0                	add    %edx,%eax
8010046b:	0f b6 00             	movzbl (%eax),%eax
8010046e:	0f be c0             	movsbl %al,%eax
80100471:	25 ff 00 00 00       	and    $0xff,%eax
80100476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100479:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010047d:	0f 84 ff 00 00 00    	je     80100582 <cprintf+0x186>
      break;
    switch(c){
80100483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100486:	83 f8 70             	cmp    $0x70,%eax
80100489:	74 47                	je     801004d2 <cprintf+0xd6>
8010048b:	83 f8 70             	cmp    $0x70,%eax
8010048e:	7f 13                	jg     801004a3 <cprintf+0xa7>
80100490:	83 f8 25             	cmp    $0x25,%eax
80100493:	0f 84 98 00 00 00    	je     80100531 <cprintf+0x135>
80100499:	83 f8 64             	cmp    $0x64,%eax
8010049c:	74 14                	je     801004b2 <cprintf+0xb6>
8010049e:	e9 9d 00 00 00       	jmp    80100540 <cprintf+0x144>
801004a3:	83 f8 73             	cmp    $0x73,%eax
801004a6:	74 47                	je     801004ef <cprintf+0xf3>
801004a8:	83 f8 78             	cmp    $0x78,%eax
801004ab:	74 25                	je     801004d2 <cprintf+0xd6>
801004ad:	e9 8e 00 00 00       	jmp    80100540 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
801004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b5:	8d 50 04             	lea    0x4(%eax),%edx
801004b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bb:	8b 00                	mov    (%eax),%eax
801004bd:	83 ec 04             	sub    $0x4,%esp
801004c0:	6a 01                	push   $0x1
801004c2:	6a 0a                	push   $0xa
801004c4:	50                   	push   %eax
801004c5:	e8 87 fe ff ff       	call   80100351 <printint>
801004ca:	83 c4 10             	add    $0x10,%esp
      break;
801004cd:	e9 8a 00 00 00       	jmp    8010055c <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d5:	8d 50 04             	lea    0x4(%eax),%edx
801004d8:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004db:	8b 00                	mov    (%eax),%eax
801004dd:	83 ec 04             	sub    $0x4,%esp
801004e0:	6a 00                	push   $0x0
801004e2:	6a 10                	push   $0x10
801004e4:	50                   	push   %eax
801004e5:	e8 67 fe ff ff       	call   80100351 <printint>
801004ea:	83 c4 10             	add    $0x10,%esp
      break;
801004ed:	eb 6d                	jmp    8010055c <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f2:	8d 50 04             	lea    0x4(%eax),%edx
801004f5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f8:	8b 00                	mov    (%eax),%eax
801004fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100501:	75 22                	jne    80100525 <cprintf+0x129>
        s = "(null)";
80100503:	c7 45 ec e6 8b 10 80 	movl   $0x80108be6,-0x14(%ebp)
      for(; *s; s++)
8010050a:	eb 19                	jmp    80100525 <cprintf+0x129>
        consputc(*s);
8010050c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010050f:	0f b6 00             	movzbl (%eax),%eax
80100512:	0f be c0             	movsbl %al,%eax
80100515:	83 ec 0c             	sub    $0xc,%esp
80100518:	50                   	push   %eax
80100519:	e8 ab 02 00 00       	call   801007c9 <consputc>
8010051e:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100521:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100528:	0f b6 00             	movzbl (%eax),%eax
8010052b:	84 c0                	test   %al,%al
8010052d:	75 dd                	jne    8010050c <cprintf+0x110>
      break;
8010052f:	eb 2b                	jmp    8010055c <cprintf+0x160>
    case '%':
      consputc('%');
80100531:	83 ec 0c             	sub    $0xc,%esp
80100534:	6a 25                	push   $0x25
80100536:	e8 8e 02 00 00       	call   801007c9 <consputc>
8010053b:	83 c4 10             	add    $0x10,%esp
      break;
8010053e:	eb 1c                	jmp    8010055c <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100540:	83 ec 0c             	sub    $0xc,%esp
80100543:	6a 25                	push   $0x25
80100545:	e8 7f 02 00 00       	call   801007c9 <consputc>
8010054a:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	ff 75 e4             	push   -0x1c(%ebp)
80100553:	e8 71 02 00 00       	call   801007c9 <consputc>
80100558:	83 c4 10             	add    $0x10,%esp
      break;
8010055b:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010055c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100560:	8b 55 08             	mov    0x8(%ebp),%edx
80100563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100566:	01 d0                	add    %edx,%eax
80100568:	0f b6 00             	movzbl (%eax),%eax
8010056b:	0f be c0             	movsbl %al,%eax
8010056e:	25 ff 00 00 00       	and    $0xff,%eax
80100573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010057a:	0f 85 c6 fe ff ff    	jne    80100446 <cprintf+0x4a>
80100580:	eb 01                	jmp    80100583 <cprintf+0x187>
      break;
80100582:	90                   	nop
    }
  }

  if(locking)
80100583:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100587:	74 10                	je     80100599 <cprintf+0x19d>
    release(&cons.lock);
80100589:	83 ec 0c             	sub    $0xc,%esp
8010058c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100591:	e8 53 50 00 00       	call   801055e9 <release>
80100596:	83 c4 10             	add    $0x10,%esp
}
80100599:	90                   	nop
8010059a:	c9                   	leave  
8010059b:	c3                   	ret    

8010059c <panic>:

void
panic(char *s)
{
8010059c:	55                   	push   %ebp
8010059d:	89 e5                	mov    %esp,%ebp
8010059f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005a2:	e8 a3 fd ff ff       	call   8010034a <cli>
  cons.locking = 0;
801005a7:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
801005ae:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005b1:	e8 21 2a 00 00       	call   80102fd7 <lapicid>
801005b6:	83 ec 08             	sub    $0x8,%esp
801005b9:	50                   	push   %eax
801005ba:	68 ed 8b 10 80       	push   $0x80108bed
801005bf:	e8 38 fe ff ff       	call   801003fc <cprintf>
801005c4:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005c7:	8b 45 08             	mov    0x8(%ebp),%eax
801005ca:	83 ec 0c             	sub    $0xc,%esp
801005cd:	50                   	push   %eax
801005ce:	e8 29 fe ff ff       	call   801003fc <cprintf>
801005d3:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005d6:	83 ec 0c             	sub    $0xc,%esp
801005d9:	68 01 8c 10 80       	push   $0x80108c01
801005de:	e8 19 fe ff ff       	call   801003fc <cprintf>
801005e3:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005e6:	83 ec 08             	sub    $0x8,%esp
801005e9:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005ec:	50                   	push   %eax
801005ed:	8d 45 08             	lea    0x8(%ebp),%eax
801005f0:	50                   	push   %eax
801005f1:	e8 45 50 00 00       	call   8010563b <getcallerpcs>
801005f6:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100600:	eb 1c                	jmp    8010061e <panic+0x82>
    cprintf(" %p", pcs[i]);
80100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100605:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100609:	83 ec 08             	sub    $0x8,%esp
8010060c:	50                   	push   %eax
8010060d:	68 03 8c 10 80       	push   $0x80108c03
80100612:	e8 e5 fd ff ff       	call   801003fc <cprintf>
80100617:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010061a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010061e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100622:	7e de                	jle    80100602 <panic+0x66>
  panicked = 1; // freeze other CPU
80100624:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
8010062b:	00 00 00 
  for(;;)
8010062e:	eb fe                	jmp    8010062e <panic+0x92>

80100630 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	53                   	push   %ebx
80100634:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100637:	6a 0e                	push   $0xe
80100639:	68 d4 03 00 00       	push   $0x3d4
8010063e:	e8 e8 fc ff ff       	call   8010032b <outb>
80100643:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100646:	68 d5 03 00 00       	push   $0x3d5
8010064b:	e8 be fc ff ff       	call   8010030e <inb>
80100650:	83 c4 04             	add    $0x4,%esp
80100653:	0f b6 c0             	movzbl %al,%eax
80100656:	c1 e0 08             	shl    $0x8,%eax
80100659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010065c:	6a 0f                	push   $0xf
8010065e:	68 d4 03 00 00       	push   $0x3d4
80100663:	e8 c3 fc ff ff       	call   8010032b <outb>
80100668:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010066b:	68 d5 03 00 00       	push   $0x3d5
80100670:	e8 99 fc ff ff       	call   8010030e <inb>
80100675:	83 c4 04             	add    $0x4,%esp
80100678:	0f b6 c0             	movzbl %al,%eax
8010067b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010067e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100682:	75 30                	jne    801006b4 <cgaputc+0x84>
    pos += 80 - pos%80;
80100684:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100687:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010068c:	89 c8                	mov    %ecx,%eax
8010068e:	f7 ea                	imul   %edx
80100690:	c1 fa 05             	sar    $0x5,%edx
80100693:	89 c8                	mov    %ecx,%eax
80100695:	c1 f8 1f             	sar    $0x1f,%eax
80100698:	29 c2                	sub    %eax,%edx
8010069a:	89 d0                	mov    %edx,%eax
8010069c:	c1 e0 02             	shl    $0x2,%eax
8010069f:	01 d0                	add    %edx,%eax
801006a1:	c1 e0 04             	shl    $0x4,%eax
801006a4:	29 c1                	sub    %eax,%ecx
801006a6:	89 ca                	mov    %ecx,%edx
801006a8:	b8 50 00 00 00       	mov    $0x50,%eax
801006ad:	29 d0                	sub    %edx,%eax
801006af:	01 45 f4             	add    %eax,-0xc(%ebp)
801006b2:	eb 38                	jmp    801006ec <cgaputc+0xbc>
  else if(c == BACKSPACE){
801006b4:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006bb:	75 0c                	jne    801006c9 <cgaputc+0x99>
    if(pos > 0) --pos;
801006bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c1:	7e 29                	jle    801006ec <cgaputc+0xbc>
801006c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006c7:	eb 23                	jmp    801006ec <cgaputc+0xbc>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	0f b6 c0             	movzbl %al,%eax
801006cf:	80 cc 07             	or     $0x7,%ah
801006d2:	89 c3                	mov    %eax,%ebx
801006d4:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006dd:	8d 50 01             	lea    0x1(%eax),%edx
801006e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006e3:	01 c0                	add    %eax,%eax
801006e5:	01 c8                	add    %ecx,%eax
801006e7:	89 da                	mov    %ebx,%edx
801006e9:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006f0:	78 09                	js     801006fb <cgaputc+0xcb>
801006f2:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006f9:	7e 0d                	jle    80100708 <cgaputc+0xd8>
    panic("pos under/overflow");
801006fb:	83 ec 0c             	sub    $0xc,%esp
801006fe:	68 07 8c 10 80       	push   $0x80108c07
80100703:	e8 94 fe ff ff       	call   8010059c <panic>

  if((pos/80) >= 24){  // Scroll up.
80100708:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010070f:	7e 4c                	jle    8010075d <cgaputc+0x12d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100711:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100716:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010071c:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100721:	83 ec 04             	sub    $0x4,%esp
80100724:	68 60 0e 00 00       	push   $0xe60
80100729:	52                   	push   %edx
8010072a:	50                   	push   %eax
8010072b:	e8 91 51 00 00       	call   801058c1 <memmove>
80100730:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100733:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100737:	b8 80 07 00 00       	mov    $0x780,%eax
8010073c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010073f:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100742:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100747:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010074a:	01 c9                	add    %ecx,%ecx
8010074c:	01 c8                	add    %ecx,%eax
8010074e:	83 ec 04             	sub    $0x4,%esp
80100751:	52                   	push   %edx
80100752:	6a 00                	push   $0x0
80100754:	50                   	push   %eax
80100755:	e8 a8 50 00 00       	call   80105802 <memset>
8010075a:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
8010075d:	83 ec 08             	sub    $0x8,%esp
80100760:	6a 0e                	push   $0xe
80100762:	68 d4 03 00 00       	push   $0x3d4
80100767:	e8 bf fb ff ff       	call   8010032b <outb>
8010076c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100772:	c1 f8 08             	sar    $0x8,%eax
80100775:	0f b6 c0             	movzbl %al,%eax
80100778:	83 ec 08             	sub    $0x8,%esp
8010077b:	50                   	push   %eax
8010077c:	68 d5 03 00 00       	push   $0x3d5
80100781:	e8 a5 fb ff ff       	call   8010032b <outb>
80100786:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100789:	83 ec 08             	sub    $0x8,%esp
8010078c:	6a 0f                	push   $0xf
8010078e:	68 d4 03 00 00       	push   $0x3d4
80100793:	e8 93 fb ff ff       	call   8010032b <outb>
80100798:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010079b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010079e:	0f b6 c0             	movzbl %al,%eax
801007a1:	83 ec 08             	sub    $0x8,%esp
801007a4:	50                   	push   %eax
801007a5:	68 d5 03 00 00       	push   $0x3d5
801007aa:	e8 7c fb ff ff       	call   8010032b <outb>
801007af:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007b2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007ba:	01 d2                	add    %edx,%edx
801007bc:	01 d0                	add    %edx,%eax
801007be:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007c3:	90                   	nop
801007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007c7:	c9                   	leave  
801007c8:	c3                   	ret    

801007c9 <consputc>:

void
consputc(int c)
{
801007c9:	55                   	push   %ebp
801007ca:	89 e5                	mov    %esp,%ebp
801007cc:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007cf:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
801007d4:	85 c0                	test   %eax,%eax
801007d6:	74 07                	je     801007df <consputc+0x16>
    cli();
801007d8:	e8 6d fb ff ff       	call   8010034a <cli>
    for(;;)
801007dd:	eb fe                	jmp    801007dd <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007df:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007e6:	75 29                	jne    80100811 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	6a 08                	push   $0x8
801007ed:	e8 4a 6a 00 00       	call   8010723c <uartputc>
801007f2:	83 c4 10             	add    $0x10,%esp
801007f5:	83 ec 0c             	sub    $0xc,%esp
801007f8:	6a 20                	push   $0x20
801007fa:	e8 3d 6a 00 00       	call   8010723c <uartputc>
801007ff:	83 c4 10             	add    $0x10,%esp
80100802:	83 ec 0c             	sub    $0xc,%esp
80100805:	6a 08                	push   $0x8
80100807:	e8 30 6a 00 00       	call   8010723c <uartputc>
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	eb 0e                	jmp    8010081f <consputc+0x56>
  } else
    uartputc(c);
80100811:	83 ec 0c             	sub    $0xc,%esp
80100814:	ff 75 08             	push   0x8(%ebp)
80100817:	e8 20 6a 00 00       	call   8010723c <uartputc>
8010081c:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010081f:	83 ec 0c             	sub    $0xc,%esp
80100822:	ff 75 08             	push   0x8(%ebp)
80100825:	e8 06 fe ff ff       	call   80100630 <cgaputc>
8010082a:	83 c4 10             	add    $0x10,%esp
}
8010082d:	90                   	nop
8010082e:	c9                   	leave  
8010082f:	c3                   	ret    

80100830 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
8010083d:	83 ec 0c             	sub    $0xc,%esp
80100840:	68 e0 c5 10 80       	push   $0x8010c5e0
80100845:	e8 31 4d 00 00       	call   8010557b <acquire>
8010084a:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010084d:	e9 44 01 00 00       	jmp    80100996 <consoleintr+0x166>
    switch(c){
80100852:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100855:	83 f8 10             	cmp    $0x10,%eax
80100858:	74 1e                	je     80100878 <consoleintr+0x48>
8010085a:	83 f8 10             	cmp    $0x10,%eax
8010085d:	7f 0a                	jg     80100869 <consoleintr+0x39>
8010085f:	83 f8 08             	cmp    $0x8,%eax
80100862:	74 6b                	je     801008cf <consoleintr+0x9f>
80100864:	e9 9b 00 00 00       	jmp    80100904 <consoleintr+0xd4>
80100869:	83 f8 15             	cmp    $0x15,%eax
8010086c:	74 33                	je     801008a1 <consoleintr+0x71>
8010086e:	83 f8 7f             	cmp    $0x7f,%eax
80100871:	74 5c                	je     801008cf <consoleintr+0x9f>
80100873:	e9 8c 00 00 00       	jmp    80100904 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100878:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010087f:	e9 12 01 00 00       	jmp    80100996 <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100884:	a1 68 20 11 80       	mov    0x80112068,%eax
80100889:	83 e8 01             	sub    $0x1,%eax
8010088c:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
80100891:	83 ec 0c             	sub    $0xc,%esp
80100894:	68 00 01 00 00       	push   $0x100
80100899:	e8 2b ff ff ff       	call   801007c9 <consputc>
8010089e:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008a1:	8b 15 68 20 11 80    	mov    0x80112068,%edx
801008a7:	a1 64 20 11 80       	mov    0x80112064,%eax
801008ac:	39 c2                	cmp    %eax,%edx
801008ae:	0f 84 e2 00 00 00    	je     80100996 <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b4:	a1 68 20 11 80       	mov    0x80112068,%eax
801008b9:	83 e8 01             	sub    $0x1,%eax
801008bc:	83 e0 7f             	and    $0x7f,%eax
801008bf:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
      while(input.e != input.w &&
801008c6:	3c 0a                	cmp    $0xa,%al
801008c8:	75 ba                	jne    80100884 <consoleintr+0x54>
      }
      break;
801008ca:	e9 c7 00 00 00       	jmp    80100996 <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008cf:	8b 15 68 20 11 80    	mov    0x80112068,%edx
801008d5:	a1 64 20 11 80       	mov    0x80112064,%eax
801008da:	39 c2                	cmp    %eax,%edx
801008dc:	0f 84 b4 00 00 00    	je     80100996 <consoleintr+0x166>
        input.e--;
801008e2:	a1 68 20 11 80       	mov    0x80112068,%eax
801008e7:	83 e8 01             	sub    $0x1,%eax
801008ea:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
801008ef:	83 ec 0c             	sub    $0xc,%esp
801008f2:	68 00 01 00 00       	push   $0x100
801008f7:	e8 cd fe ff ff       	call   801007c9 <consputc>
801008fc:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008ff:	e9 92 00 00 00       	jmp    80100996 <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100908:	0f 84 87 00 00 00    	je     80100995 <consoleintr+0x165>
8010090e:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100914:	a1 60 20 11 80       	mov    0x80112060,%eax
80100919:	29 c2                	sub    %eax,%edx
8010091b:	89 d0                	mov    %edx,%eax
8010091d:	83 f8 7f             	cmp    $0x7f,%eax
80100920:	77 73                	ja     80100995 <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
80100922:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100926:	74 05                	je     8010092d <consoleintr+0xfd>
80100928:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010092b:	eb 05                	jmp    80100932 <consoleintr+0x102>
8010092d:	b8 0a 00 00 00       	mov    $0xa,%eax
80100932:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100935:	a1 68 20 11 80       	mov    0x80112068,%eax
8010093a:	8d 50 01             	lea    0x1(%eax),%edx
8010093d:	89 15 68 20 11 80    	mov    %edx,0x80112068
80100943:	83 e0 7f             	and    $0x7f,%eax
80100946:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100949:	88 90 e0 1f 11 80    	mov    %dl,-0x7feee020(%eax)
        consputc(c);
8010094f:	83 ec 0c             	sub    $0xc,%esp
80100952:	ff 75 f0             	push   -0x10(%ebp)
80100955:	e8 6f fe ff ff       	call   801007c9 <consputc>
8010095a:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010095d:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100961:	74 18                	je     8010097b <consoleintr+0x14b>
80100963:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100967:	74 12                	je     8010097b <consoleintr+0x14b>
80100969:	a1 68 20 11 80       	mov    0x80112068,%eax
8010096e:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100974:	83 ea 80             	sub    $0xffffff80,%edx
80100977:	39 d0                	cmp    %edx,%eax
80100979:	75 1a                	jne    80100995 <consoleintr+0x165>
          input.w = input.e;
8010097b:	a1 68 20 11 80       	mov    0x80112068,%eax
80100980:	a3 64 20 11 80       	mov    %eax,0x80112064
          wakeup(&input.r);
80100985:	83 ec 0c             	sub    $0xc,%esp
80100988:	68 60 20 11 80       	push   $0x80112060
8010098d:	e8 49 43 00 00       	call   80104cdb <wakeup>
80100992:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100995:	90                   	nop
  while((c = getc()) >= 0){
80100996:	8b 45 08             	mov    0x8(%ebp),%eax
80100999:	ff d0                	call   *%eax
8010099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010099e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009a2:	0f 89 aa fe ff ff    	jns    80100852 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009a8:	83 ec 0c             	sub    $0xc,%esp
801009ab:	68 e0 c5 10 80       	push   $0x8010c5e0
801009b0:	e8 34 4c 00 00       	call   801055e9 <release>
801009b5:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009bc:	74 05                	je     801009c3 <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
801009be:	e8 d3 43 00 00       	call   80104d96 <procdump>
  }
}
801009c3:	90                   	nop
801009c4:	c9                   	leave  
801009c5:	c3                   	ret    

801009c6 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c6:	55                   	push   %ebp
801009c7:	89 e5                	mov    %esp,%ebp
801009c9:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	ff 75 08             	push   0x8(%ebp)
801009d2:	e8 3d 11 00 00       	call   80101b14 <iunlock>
801009d7:	83 c4 10             	add    $0x10,%esp
  target = n;
801009da:	8b 45 10             	mov    0x10(%ebp),%eax
801009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009e0:	83 ec 0c             	sub    $0xc,%esp
801009e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801009e8:	e8 8e 4b 00 00       	call   8010557b <acquire>
801009ed:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009f0:	e9 ab 00 00 00       	jmp    80100aa0 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009f5:	e8 7f 38 00 00       	call   80104279 <myproc>
801009fa:	8b 40 24             	mov    0x24(%eax),%eax
801009fd:	85 c0                	test   %eax,%eax
801009ff:	74 28                	je     80100a29 <consoleread+0x63>
        release(&cons.lock);
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a09:	e8 db 4b 00 00       	call   801055e9 <release>
80100a0e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a11:	83 ec 0c             	sub    $0xc,%esp
80100a14:	ff 75 08             	push   0x8(%ebp)
80100a17:	e8 e5 0f 00 00       	call   80101a01 <ilock>
80100a1c:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a24:	e9 ab 00 00 00       	jmp    80100ad4 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a29:	83 ec 08             	sub    $0x8,%esp
80100a2c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a31:	68 60 20 11 80       	push   $0x80112060
80100a36:	e8 ba 41 00 00       	call   80104bf5 <sleep>
80100a3b:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a3e:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100a44:	a1 64 20 11 80       	mov    0x80112064,%eax
80100a49:	39 c2                	cmp    %eax,%edx
80100a4b:	74 a8                	je     801009f5 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a4d:	a1 60 20 11 80       	mov    0x80112060,%eax
80100a52:	8d 50 01             	lea    0x1(%eax),%edx
80100a55:	89 15 60 20 11 80    	mov    %edx,0x80112060
80100a5b:	83 e0 7f             	and    $0x7f,%eax
80100a5e:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
80100a65:	0f be c0             	movsbl %al,%eax
80100a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a6b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a6f:	75 17                	jne    80100a88 <consoleread+0xc2>
      if(n < target){
80100a71:	8b 45 10             	mov    0x10(%ebp),%eax
80100a74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a77:	76 2f                	jbe    80100aa8 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a79:	a1 60 20 11 80       	mov    0x80112060,%eax
80100a7e:	83 e8 01             	sub    $0x1,%eax
80100a81:	a3 60 20 11 80       	mov    %eax,0x80112060
      }
      break;
80100a86:	eb 20                	jmp    80100aa8 <consoleread+0xe2>
    }
    *dst++ = c;
80100a88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a8b:	8d 50 01             	lea    0x1(%eax),%edx
80100a8e:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a94:	88 10                	mov    %dl,(%eax)
    --n;
80100a96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a9a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a9e:	74 0b                	je     80100aab <consoleread+0xe5>
  while(n > 0){
80100aa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aa4:	7f 98                	jg     80100a3e <consoleread+0x78>
80100aa6:	eb 04                	jmp    80100aac <consoleread+0xe6>
      break;
80100aa8:	90                   	nop
80100aa9:	eb 01                	jmp    80100aac <consoleread+0xe6>
      break;
80100aab:	90                   	nop
  }
  release(&cons.lock);
80100aac:	83 ec 0c             	sub    $0xc,%esp
80100aaf:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ab4:	e8 30 4b 00 00       	call   801055e9 <release>
80100ab9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100abc:	83 ec 0c             	sub    $0xc,%esp
80100abf:	ff 75 08             	push   0x8(%ebp)
80100ac2:	e8 3a 0f 00 00       	call   80101a01 <ilock>
80100ac7:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100aca:	8b 45 10             	mov    0x10(%ebp),%eax
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	29 c2                	sub    %eax,%edx
80100ad2:	89 d0                	mov    %edx,%eax
}
80100ad4:	c9                   	leave  
80100ad5:	c3                   	ret    

80100ad6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ad6:	55                   	push   %ebp
80100ad7:	89 e5                	mov    %esp,%ebp
80100ad9:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100adc:	83 ec 0c             	sub    $0xc,%esp
80100adf:	ff 75 08             	push   0x8(%ebp)
80100ae2:	e8 2d 10 00 00       	call   80101b14 <iunlock>
80100ae7:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aea:	83 ec 0c             	sub    $0xc,%esp
80100aed:	68 e0 c5 10 80       	push   $0x8010c5e0
80100af2:	e8 84 4a 00 00       	call   8010557b <acquire>
80100af7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b01:	eb 21                	jmp    80100b24 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b06:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b09:	01 d0                	add    %edx,%eax
80100b0b:	0f b6 00             	movzbl (%eax),%eax
80100b0e:	0f be c0             	movsbl %al,%eax
80100b11:	0f b6 c0             	movzbl %al,%eax
80100b14:	83 ec 0c             	sub    $0xc,%esp
80100b17:	50                   	push   %eax
80100b18:	e8 ac fc ff ff       	call   801007c9 <consputc>
80100b1d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b27:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b2a:	7c d7                	jl     80100b03 <consolewrite+0x2d>
  release(&cons.lock);
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b34:	e8 b0 4a 00 00       	call   801055e9 <release>
80100b39:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	push   0x8(%ebp)
80100b42:	e8 ba 0e 00 00       	call   80101a01 <ilock>
80100b47:	83 c4 10             	add    $0x10,%esp

  return n;
80100b4a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b4d:	c9                   	leave  
80100b4e:	c3                   	ret    

80100b4f <consoleinit>:

void
consoleinit(void)
{
80100b4f:	55                   	push   %ebp
80100b50:	89 e5                	mov    %esp,%ebp
80100b52:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b55:	83 ec 08             	sub    $0x8,%esp
80100b58:	68 1a 8c 10 80       	push   $0x80108c1a
80100b5d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b62:	e8 f2 49 00 00       	call   80105559 <initlock>
80100b67:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b6a:	c7 05 2c 2a 11 80 d6 	movl   $0x80100ad6,0x80112a2c
80100b71:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b74:	c7 05 28 2a 11 80 c6 	movl   $0x801009c6,0x80112a28
80100b7b:	09 10 80 
  cons.locking = 1;
80100b7e:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b85:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b88:	83 ec 08             	sub    $0x8,%esp
80100b8b:	6a 00                	push   $0x0
80100b8d:	6a 01                	push   $0x1
80100b8f:	e8 7c 1f 00 00       	call   80102b10 <ioapicenable>
80100b94:	83 c4 10             	add    $0x10,%esp
}
80100b97:	90                   	nop
80100b98:	c9                   	leave  
80100b99:	c3                   	ret    

80100b9a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b9a:	55                   	push   %ebp
80100b9b:	89 e5                	mov    %esp,%ebp
80100b9d:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100ba3:	e8 d1 36 00 00       	call   80104279 <myproc>
80100ba8:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bab:	e8 73 29 00 00       	call   80103523 <begin_op>

  if((ip = namei(path)) == 0){
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 08             	push   0x8(%ebp)
80100bb6:	e8 81 19 00 00       	call   8010253c <namei>
80100bbb:	83 c4 10             	add    $0x10,%esp
80100bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bc5:	75 1f                	jne    80100be6 <exec+0x4c>
    end_op();
80100bc7:	e8 e3 29 00 00       	call   801035af <end_op>
    cprintf("exec: fail\n");
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	68 22 8c 10 80       	push   $0x80108c22
80100bd4:	e8 23 f8 ff ff       	call   801003fc <cprintf>
80100bd9:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be1:	e9 f1 03 00 00       	jmp    80100fd7 <exec+0x43d>
  }
  ilock(ip);
80100be6:	83 ec 0c             	sub    $0xc,%esp
80100be9:	ff 75 d8             	push   -0x28(%ebp)
80100bec:	e8 10 0e 00 00       	call   80101a01 <ilock>
80100bf1:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bf4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bfb:	6a 34                	push   $0x34
80100bfd:	6a 00                	push   $0x0
80100bff:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c05:	50                   	push   %eax
80100c06:	ff 75 d8             	push   -0x28(%ebp)
80100c09:	e8 df 12 00 00       	call   80101eed <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 34             	cmp    $0x34,%eax
80100c14:	0f 85 66 03 00 00    	jne    80100f80 <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c1a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c20:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c25:	0f 85 58 03 00 00    	jne    80100f83 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c2b:	e8 6c 76 00 00       	call   8010829c <setupkvm>
80100c30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c37:	0f 84 49 03 00 00    	je     80100f86 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c4b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c51:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c54:	e9 de 00 00 00       	jmp    80100d37 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5c:	6a 20                	push   $0x20
80100c5e:	50                   	push   %eax
80100c5f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c65:	50                   	push   %eax
80100c66:	ff 75 d8             	push   -0x28(%ebp)
80100c69:	e8 7f 12 00 00       	call   80101eed <readi>
80100c6e:	83 c4 10             	add    $0x10,%esp
80100c71:	83 f8 20             	cmp    $0x20,%eax
80100c74:	0f 85 0f 03 00 00    	jne    80100f89 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c7a:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c80:	83 f8 01             	cmp    $0x1,%eax
80100c83:	0f 85 a0 00 00 00    	jne    80100d29 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c89:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8f:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c95:	39 c2                	cmp    %eax,%edx
80100c97:	0f 82 ef 02 00 00    	jb     80100f8c <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c9d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca3:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ca9:	01 c2                	add    %eax,%edx
80100cab:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cb1:	39 c2                	cmp    %eax,%edx
80100cb3:	0f 82 d6 02 00 00    	jb     80100f8f <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cbf:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cc5:	01 d0                	add    %edx,%eax
80100cc7:	83 ec 04             	sub    $0x4,%esp
80100cca:	50                   	push   %eax
80100ccb:	ff 75 e0             	push   -0x20(%ebp)
80100cce:	ff 75 d4             	push   -0x2c(%ebp)
80100cd1:	e8 6e 79 00 00       	call   80108644 <allocuvm>
80100cd6:	83 c4 10             	add    $0x10,%esp
80100cd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cdc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ce0:	0f 84 ac 02 00 00    	je     80100f92 <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ce6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cec:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cf1:	85 c0                	test   %eax,%eax
80100cf3:	0f 85 9c 02 00 00    	jne    80100f95 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf9:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100cff:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d0b:	83 ec 0c             	sub    $0xc,%esp
80100d0e:	52                   	push   %edx
80100d0f:	50                   	push   %eax
80100d10:	ff 75 d8             	push   -0x28(%ebp)
80100d13:	51                   	push   %ecx
80100d14:	ff 75 d4             	push   -0x2c(%ebp)
80100d17:	e8 5b 78 00 00       	call   80108577 <loaduvm>
80100d1c:	83 c4 20             	add    $0x20,%esp
80100d1f:	85 c0                	test   %eax,%eax
80100d21:	0f 88 71 02 00 00    	js     80100f98 <exec+0x3fe>
80100d27:	eb 01                	jmp    80100d2a <exec+0x190>
      continue;
80100d29:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d31:	83 c0 20             	add    $0x20,%eax
80100d34:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d37:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d3e:	0f b7 c0             	movzwl %ax,%eax
80100d41:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d44:	0f 8c 0f ff ff ff    	jl     80100c59 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	ff 75 d8             	push   -0x28(%ebp)
80100d50:	e8 dd 0e 00 00       	call   80101c32 <iunlockput>
80100d55:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d58:	e8 52 28 00 00       	call   801035af <end_op>
  ip = 0;
80100d5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d67:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d77:	05 00 20 00 00       	add    $0x2000,%eax
80100d7c:	83 ec 04             	sub    $0x4,%esp
80100d7f:	50                   	push   %eax
80100d80:	ff 75 e0             	push   -0x20(%ebp)
80100d83:	ff 75 d4             	push   -0x2c(%ebp)
80100d86:	e8 b9 78 00 00       	call   80108644 <allocuvm>
80100d8b:	83 c4 10             	add    $0x10,%esp
80100d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d95:	0f 84 00 02 00 00    	je     80100f9b <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100da3:	83 ec 08             	sub    $0x8,%esp
80100da6:	50                   	push   %eax
80100da7:	ff 75 d4             	push   -0x2c(%ebp)
80100daa:	e8 f7 7a 00 00       	call   801088a6 <clearpteu>
80100daf:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dbf:	e9 96 00 00 00       	jmp    80100e5a <exec+0x2c0>
    if(argc >= MAXARG)
80100dc4:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dc8:	0f 87 d0 01 00 00    	ja     80100f9e <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ddb:	01 d0                	add    %edx,%eax
80100ddd:	8b 00                	mov    (%eax),%eax
80100ddf:	83 ec 0c             	sub    $0xc,%esp
80100de2:	50                   	push   %eax
80100de3:	e8 67 4c 00 00       	call   80105a4f <strlen>
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	89 c2                	mov    %eax,%edx
80100ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100df0:	29 d0                	sub    %edx,%eax
80100df2:	83 e8 01             	sub    $0x1,%eax
80100df5:	83 e0 fc             	and    $0xfffffffc,%eax
80100df8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e08:	01 d0                	add    %edx,%eax
80100e0a:	8b 00                	mov    (%eax),%eax
80100e0c:	83 ec 0c             	sub    $0xc,%esp
80100e0f:	50                   	push   %eax
80100e10:	e8 3a 4c 00 00       	call   80105a4f <strlen>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	83 c0 01             	add    $0x1,%eax
80100e1b:	89 c1                	mov    %eax,%ecx
80100e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e2a:	01 d0                	add    %edx,%eax
80100e2c:	8b 00                	mov    (%eax),%eax
80100e2e:	51                   	push   %ecx
80100e2f:	50                   	push   %eax
80100e30:	ff 75 dc             	push   -0x24(%ebp)
80100e33:	ff 75 d4             	push   -0x2c(%ebp)
80100e36:	e8 17 7c 00 00       	call   80108a52 <copyout>
80100e3b:	83 c4 10             	add    $0x10,%esp
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	0f 88 5b 01 00 00    	js     80100fa1 <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e49:	8d 50 03             	lea    0x3(%eax),%edx
80100e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e4f:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e56:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e67:	01 d0                	add    %edx,%eax
80100e69:	8b 00                	mov    (%eax),%eax
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	0f 85 51 ff ff ff    	jne    80100dc4 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e76:	83 c0 03             	add    $0x3,%eax
80100e79:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e80:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e84:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e8b:	ff ff ff 
  ustack[1] = argc;
80100e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e91:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e9a:	83 c0 01             	add    $0x1,%eax
80100e9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea7:	29 d0                	sub    %edx,%eax
80100ea9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb2:	83 c0 04             	add    $0x4,%eax
80100eb5:	c1 e0 02             	shl    $0x2,%eax
80100eb8:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebe:	83 c0 04             	add    $0x4,%eax
80100ec1:	c1 e0 02             	shl    $0x2,%eax
80100ec4:	50                   	push   %eax
80100ec5:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ecb:	50                   	push   %eax
80100ecc:	ff 75 dc             	push   -0x24(%ebp)
80100ecf:	ff 75 d4             	push   -0x2c(%ebp)
80100ed2:	e8 7b 7b 00 00       	call   80108a52 <copyout>
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	0f 88 c2 00 00 00    	js     80100fa4 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eee:	eb 17                	jmp    80100f07 <exec+0x36d>
    if(*s == '/')
80100ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef3:	0f b6 00             	movzbl (%eax),%eax
80100ef6:	3c 2f                	cmp    $0x2f,%al
80100ef8:	75 09                	jne    80100f03 <exec+0x369>
      last = s+1;
80100efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efd:	83 c0 01             	add    $0x1,%eax
80100f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f0a:	0f b6 00             	movzbl (%eax),%eax
80100f0d:	84 c0                	test   %al,%al
80100f0f:	75 df                	jne    80100ef0 <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f11:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f14:	83 c0 6c             	add    $0x6c,%eax
80100f17:	83 ec 04             	sub    $0x4,%esp
80100f1a:	6a 10                	push   $0x10
80100f1c:	ff 75 f0             	push   -0x10(%ebp)
80100f1f:	50                   	push   %eax
80100f20:	e8 e0 4a 00 00       	call   80105a05 <safestrcpy>
80100f25:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2b:	8b 40 04             	mov    0x4(%eax),%eax
80100f2e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f31:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f34:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f37:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f40:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f42:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f45:	8b 40 18             	mov    0x18(%eax),%eax
80100f48:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f4e:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f51:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f54:	8b 40 18             	mov    0x18(%eax),%eax
80100f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f5a:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 d0             	push   -0x30(%ebp)
80100f63:	e8 fe 73 00 00       	call   80108366 <switchuvm>
80100f68:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f6b:	83 ec 0c             	sub    $0xc,%esp
80100f6e:	ff 75 cc             	push   -0x34(%ebp)
80100f71:	e8 97 78 00 00       	call   8010880d <freevm>
80100f76:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f79:	b8 00 00 00 00       	mov    $0x0,%eax
80100f7e:	eb 57                	jmp    80100fd7 <exec+0x43d>
    goto bad;
80100f80:	90                   	nop
80100f81:	eb 22                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f83:	90                   	nop
80100f84:	eb 1f                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f86:	90                   	nop
80100f87:	eb 1c                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f89:	90                   	nop
80100f8a:	eb 19                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f8c:	90                   	nop
80100f8d:	eb 16                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f8f:	90                   	nop
80100f90:	eb 13                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f92:	90                   	nop
80100f93:	eb 10                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f95:	90                   	nop
80100f96:	eb 0d                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f98:	90                   	nop
80100f99:	eb 0a                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f9b:	90                   	nop
80100f9c:	eb 07                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f9e:	90                   	nop
80100f9f:	eb 04                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100fa1:	90                   	nop
80100fa2:	eb 01                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100fa4:	90                   	nop

 bad:
  if(pgdir)
80100fa5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fa9:	74 0e                	je     80100fb9 <exec+0x41f>
    freevm(pgdir);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	ff 75 d4             	push   -0x2c(%ebp)
80100fb1:	e8 57 78 00 00       	call   8010880d <freevm>
80100fb6:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fb9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fbd:	74 13                	je     80100fd2 <exec+0x438>
    iunlockput(ip);
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	ff 75 d8             	push   -0x28(%ebp)
80100fc5:	e8 68 0c 00 00       	call   80101c32 <iunlockput>
80100fca:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fcd:	e8 dd 25 00 00       	call   801035af <end_op>
  }
  return -1;
80100fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd7:	c9                   	leave  
80100fd8:	c3                   	ret    

80100fd9 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fd9:	55                   	push   %ebp
80100fda:	89 e5                	mov    %esp,%ebp
80100fdc:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fdf:	83 ec 08             	sub    $0x8,%esp
80100fe2:	68 2e 8c 10 80       	push   $0x80108c2e
80100fe7:	68 80 20 11 80       	push   $0x80112080
80100fec:	e8 68 45 00 00       	call   80105559 <initlock>
80100ff1:	83 c4 10             	add    $0x10,%esp
}
80100ff4:	90                   	nop
80100ff5:	c9                   	leave  
80100ff6:	c3                   	ret    

80100ff7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ff7:	55                   	push   %ebp
80100ff8:	89 e5                	mov    %esp,%ebp
80100ffa:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ffd:	83 ec 0c             	sub    $0xc,%esp
80101000:	68 80 20 11 80       	push   $0x80112080
80101005:	e8 71 45 00 00       	call   8010557b <acquire>
8010100a:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010100d:	c7 45 f4 b4 20 11 80 	movl   $0x801120b4,-0xc(%ebp)
80101014:	eb 2d                	jmp    80101043 <filealloc+0x4c>
    if(f->ref == 0){
80101016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	75 1f                	jne    8010103f <filealloc+0x48>
      f->ref = 1;
80101020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101023:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	68 80 20 11 80       	push   $0x80112080
80101032:	e8 b2 45 00 00       	call   801055e9 <release>
80101037:	83 c4 10             	add    $0x10,%esp
      return f;
8010103a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010103d:	eb 23                	jmp    80101062 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101043:	b8 14 2a 11 80       	mov    $0x80112a14,%eax
80101048:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010104b:	72 c9                	jb     80101016 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010104d:	83 ec 0c             	sub    $0xc,%esp
80101050:	68 80 20 11 80       	push   $0x80112080
80101055:	e8 8f 45 00 00       	call   801055e9 <release>
8010105a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010105d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101062:	c9                   	leave  
80101063:	c3                   	ret    

80101064 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101064:	55                   	push   %ebp
80101065:	89 e5                	mov    %esp,%ebp
80101067:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 80 20 11 80       	push   $0x80112080
80101072:	e8 04 45 00 00       	call   8010557b <acquire>
80101077:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010107a:	8b 45 08             	mov    0x8(%ebp),%eax
8010107d:	8b 40 04             	mov    0x4(%eax),%eax
80101080:	85 c0                	test   %eax,%eax
80101082:	7f 0d                	jg     80101091 <filedup+0x2d>
    panic("filedup");
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	68 35 8c 10 80       	push   $0x80108c35
8010108c:	e8 0b f5 ff ff       	call   8010059c <panic>
  f->ref++;
80101091:	8b 45 08             	mov    0x8(%ebp),%eax
80101094:	8b 40 04             	mov    0x4(%eax),%eax
80101097:	8d 50 01             	lea    0x1(%eax),%edx
8010109a:	8b 45 08             	mov    0x8(%ebp),%eax
8010109d:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 80 20 11 80       	push   $0x80112080
801010a8:	e8 3c 45 00 00       	call   801055e9 <release>
801010ad:	83 c4 10             	add    $0x10,%esp
  return f;
801010b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010b3:	c9                   	leave  
801010b4:	c3                   	ret    

801010b5 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010b5:	55                   	push   %ebp
801010b6:	89 e5                	mov    %esp,%ebp
801010b8:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 80 20 11 80       	push   $0x80112080
801010c3:	e8 b3 44 00 00       	call   8010557b <acquire>
801010c8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010cb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ce:	8b 40 04             	mov    0x4(%eax),%eax
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7f 0d                	jg     801010e2 <fileclose+0x2d>
    panic("fileclose");
801010d5:	83 ec 0c             	sub    $0xc,%esp
801010d8:	68 3d 8c 10 80       	push   $0x80108c3d
801010dd:	e8 ba f4 ff ff       	call   8010059c <panic>
  if(--f->ref > 0){
801010e2:	8b 45 08             	mov    0x8(%ebp),%eax
801010e5:	8b 40 04             	mov    0x4(%eax),%eax
801010e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801010eb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ee:	89 50 04             	mov    %edx,0x4(%eax)
801010f1:	8b 45 08             	mov    0x8(%ebp),%eax
801010f4:	8b 40 04             	mov    0x4(%eax),%eax
801010f7:	85 c0                	test   %eax,%eax
801010f9:	7e 15                	jle    80101110 <fileclose+0x5b>
    release(&ftable.lock);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	68 80 20 11 80       	push   $0x80112080
80101103:	e8 e1 44 00 00       	call   801055e9 <release>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	e9 8b 00 00 00       	jmp    8010119b <fileclose+0xe6>
    return;
  }
  ff = *f;
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 10                	mov    (%eax),%edx
80101115:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101118:	8b 50 04             	mov    0x4(%eax),%edx
8010111b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010111e:	8b 50 08             	mov    0x8(%eax),%edx
80101121:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101124:	8b 50 0c             	mov    0xc(%eax),%edx
80101127:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010112a:	8b 50 10             	mov    0x10(%eax),%edx
8010112d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101130:	8b 40 14             	mov    0x14(%eax),%eax
80101133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101149:	83 ec 0c             	sub    $0xc,%esp
8010114c:	68 80 20 11 80       	push   $0x80112080
80101151:	e8 93 44 00 00       	call   801055e9 <release>
80101156:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101159:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010115c:	83 f8 01             	cmp    $0x1,%eax
8010115f:	75 19                	jne    8010117a <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101161:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101165:	0f be d0             	movsbl %al,%edx
80101168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010116b:	83 ec 08             	sub    $0x8,%esp
8010116e:	52                   	push   %edx
8010116f:	50                   	push   %eax
80101170:	e8 8e 2d 00 00       	call   80103f03 <pipeclose>
80101175:	83 c4 10             	add    $0x10,%esp
80101178:	eb 21                	jmp    8010119b <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010117a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010117d:	83 f8 02             	cmp    $0x2,%eax
80101180:	75 19                	jne    8010119b <fileclose+0xe6>
    begin_op();
80101182:	e8 9c 23 00 00       	call   80103523 <begin_op>
    iput(ff.ip);
80101187:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	50                   	push   %eax
8010118e:	e8 cf 09 00 00       	call   80101b62 <iput>
80101193:	83 c4 10             	add    $0x10,%esp
    end_op();
80101196:	e8 14 24 00 00       	call   801035af <end_op>
  }
}
8010119b:	c9                   	leave  
8010119c:	c3                   	ret    

8010119d <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010119d:	55                   	push   %ebp
8010119e:	89 e5                	mov    %esp,%ebp
801011a0:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011a3:	8b 45 08             	mov    0x8(%ebp),%eax
801011a6:	8b 00                	mov    (%eax),%eax
801011a8:	83 f8 02             	cmp    $0x2,%eax
801011ab:	75 40                	jne    801011ed <filestat+0x50>
    ilock(f->ip);
801011ad:	8b 45 08             	mov    0x8(%ebp),%eax
801011b0:	8b 40 10             	mov    0x10(%eax),%eax
801011b3:	83 ec 0c             	sub    $0xc,%esp
801011b6:	50                   	push   %eax
801011b7:	e8 45 08 00 00       	call   80101a01 <ilock>
801011bc:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011bf:	8b 45 08             	mov    0x8(%ebp),%eax
801011c2:	8b 40 10             	mov    0x10(%eax),%eax
801011c5:	83 ec 08             	sub    $0x8,%esp
801011c8:	ff 75 0c             	push   0xc(%ebp)
801011cb:	50                   	push   %eax
801011cc:	e8 d6 0c 00 00       	call   80101ea7 <stati>
801011d1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 40 10             	mov    0x10(%eax),%eax
801011da:	83 ec 0c             	sub    $0xc,%esp
801011dd:	50                   	push   %eax
801011de:	e8 31 09 00 00       	call   80101b14 <iunlock>
801011e3:	83 c4 10             	add    $0x10,%esp
    return 0;
801011e6:	b8 00 00 00 00       	mov    $0x0,%eax
801011eb:	eb 05                	jmp    801011f2 <filestat+0x55>
  }
  return -1;
801011ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011f2:	c9                   	leave  
801011f3:	c3                   	ret    

801011f4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011f4:	55                   	push   %ebp
801011f5:	89 e5                	mov    %esp,%ebp
801011f7:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101201:	84 c0                	test   %al,%al
80101203:	75 0a                	jne    8010120f <fileread+0x1b>
    return -1;
80101205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010120a:	e9 9b 00 00 00       	jmp    801012aa <fileread+0xb6>
  if(f->type == FD_PIPE)
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 00                	mov    (%eax),%eax
80101214:	83 f8 01             	cmp    $0x1,%eax
80101217:	75 1a                	jne    80101233 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 40 0c             	mov    0xc(%eax),%eax
8010121f:	83 ec 04             	sub    $0x4,%esp
80101222:	ff 75 10             	push   0x10(%ebp)
80101225:	ff 75 0c             	push   0xc(%ebp)
80101228:	50                   	push   %eax
80101229:	e8 81 2e 00 00       	call   801040af <piperead>
8010122e:	83 c4 10             	add    $0x10,%esp
80101231:	eb 77                	jmp    801012aa <fileread+0xb6>
  if(f->type == FD_INODE){
80101233:	8b 45 08             	mov    0x8(%ebp),%eax
80101236:	8b 00                	mov    (%eax),%eax
80101238:	83 f8 02             	cmp    $0x2,%eax
8010123b:	75 60                	jne    8010129d <fileread+0xa9>
    ilock(f->ip);
8010123d:	8b 45 08             	mov    0x8(%ebp),%eax
80101240:	8b 40 10             	mov    0x10(%eax),%eax
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	50                   	push   %eax
80101247:	e8 b5 07 00 00       	call   80101a01 <ilock>
8010124c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010124f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 50 14             	mov    0x14(%eax),%edx
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	8b 40 10             	mov    0x10(%eax),%eax
8010125e:	51                   	push   %ecx
8010125f:	52                   	push   %edx
80101260:	ff 75 0c             	push   0xc(%ebp)
80101263:	50                   	push   %eax
80101264:	e8 84 0c 00 00       	call   80101eed <readi>
80101269:	83 c4 10             	add    $0x10,%esp
8010126c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010126f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101273:	7e 11                	jle    80101286 <fileread+0x92>
      f->off += r;
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 50 14             	mov    0x14(%eax),%edx
8010127b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010127e:	01 c2                	add    %eax,%edx
80101280:	8b 45 08             	mov    0x8(%ebp),%eax
80101283:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	8b 40 10             	mov    0x10(%eax),%eax
8010128c:	83 ec 0c             	sub    $0xc,%esp
8010128f:	50                   	push   %eax
80101290:	e8 7f 08 00 00       	call   80101b14 <iunlock>
80101295:	83 c4 10             	add    $0x10,%esp
    return r;
80101298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010129b:	eb 0d                	jmp    801012aa <fileread+0xb6>
  }
  panic("fileread");
8010129d:	83 ec 0c             	sub    $0xc,%esp
801012a0:	68 47 8c 10 80       	push   $0x80108c47
801012a5:	e8 f2 f2 ff ff       	call   8010059c <panic>
}
801012aa:	c9                   	leave  
801012ab:	c3                   	ret    

801012ac <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012ac:	55                   	push   %ebp
801012ad:	89 e5                	mov    %esp,%ebp
801012af:	53                   	push   %ebx
801012b0:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012ba:	84 c0                	test   %al,%al
801012bc:	75 0a                	jne    801012c8 <filewrite+0x1c>
    return -1;
801012be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012c3:	e9 1b 01 00 00       	jmp    801013e3 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 00                	mov    (%eax),%eax
801012cd:	83 f8 01             	cmp    $0x1,%eax
801012d0:	75 1d                	jne    801012ef <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	8b 40 0c             	mov    0xc(%eax),%eax
801012d8:	83 ec 04             	sub    $0x4,%esp
801012db:	ff 75 10             	push   0x10(%ebp)
801012de:	ff 75 0c             	push   0xc(%ebp)
801012e1:	50                   	push   %eax
801012e2:	e8 c6 2c 00 00       	call   80103fad <pipewrite>
801012e7:	83 c4 10             	add    $0x10,%esp
801012ea:	e9 f4 00 00 00       	jmp    801013e3 <filewrite+0x137>
  if(f->type == FD_INODE){
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 00                	mov    (%eax),%eax
801012f4:	83 f8 02             	cmp    $0x2,%eax
801012f7:	0f 85 d9 00 00 00    	jne    801013d6 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012fd:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010130b:	e9 a3 00 00 00       	jmp    801013b3 <filewrite+0x107>
      int n1 = n - i;
80101310:	8b 45 10             	mov    0x10(%ebp),%eax
80101313:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101316:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010131c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010131f:	7e 06                	jle    80101327 <filewrite+0x7b>
        n1 = max;
80101321:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101324:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101327:	e8 f7 21 00 00       	call   80103523 <begin_op>
      ilock(f->ip);
8010132c:	8b 45 08             	mov    0x8(%ebp),%eax
8010132f:	8b 40 10             	mov    0x10(%eax),%eax
80101332:	83 ec 0c             	sub    $0xc,%esp
80101335:	50                   	push   %eax
80101336:	e8 c6 06 00 00       	call   80101a01 <ilock>
8010133b:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010133e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101341:	8b 45 08             	mov    0x8(%ebp),%eax
80101344:	8b 50 14             	mov    0x14(%eax),%edx
80101347:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010134a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010134d:	01 c3                	add    %eax,%ebx
8010134f:	8b 45 08             	mov    0x8(%ebp),%eax
80101352:	8b 40 10             	mov    0x10(%eax),%eax
80101355:	51                   	push   %ecx
80101356:	52                   	push   %edx
80101357:	53                   	push   %ebx
80101358:	50                   	push   %eax
80101359:	e8 e6 0c 00 00       	call   80102044 <writei>
8010135e:	83 c4 10             	add    $0x10,%esp
80101361:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101364:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101368:	7e 11                	jle    8010137b <filewrite+0xcf>
        f->off += r;
8010136a:	8b 45 08             	mov    0x8(%ebp),%eax
8010136d:	8b 50 14             	mov    0x14(%eax),%edx
80101370:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101373:	01 c2                	add    %eax,%edx
80101375:	8b 45 08             	mov    0x8(%ebp),%eax
80101378:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010137b:	8b 45 08             	mov    0x8(%ebp),%eax
8010137e:	8b 40 10             	mov    0x10(%eax),%eax
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	50                   	push   %eax
80101385:	e8 8a 07 00 00       	call   80101b14 <iunlock>
8010138a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010138d:	e8 1d 22 00 00       	call   801035af <end_op>

      if(r < 0)
80101392:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101396:	78 29                	js     801013c1 <filewrite+0x115>
        break;
      if(r != n1)
80101398:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010139b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010139e:	74 0d                	je     801013ad <filewrite+0x101>
        panic("short filewrite");
801013a0:	83 ec 0c             	sub    $0xc,%esp
801013a3:	68 50 8c 10 80       	push   $0x80108c50
801013a8:	e8 ef f1 ff ff       	call   8010059c <panic>
      i += r;
801013ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b0:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b9:	0f 8c 51 ff ff ff    	jl     80101310 <filewrite+0x64>
801013bf:	eb 01                	jmp    801013c2 <filewrite+0x116>
        break;
801013c1:	90                   	nop
    }
    return i == n ? n : -1;
801013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801013c8:	75 05                	jne    801013cf <filewrite+0x123>
801013ca:	8b 45 10             	mov    0x10(%ebp),%eax
801013cd:	eb 14                	jmp    801013e3 <filewrite+0x137>
801013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013d4:	eb 0d                	jmp    801013e3 <filewrite+0x137>
  }
  panic("filewrite");
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	68 60 8c 10 80       	push   $0x80108c60
801013de:	e8 b9 f1 ff ff       	call   8010059c <panic>
}
801013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013e6:	c9                   	leave  
801013e7:	c3                   	ret    

801013e8 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e8:	55                   	push   %ebp
801013e9:	89 e5                	mov    %esp,%ebp
801013eb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013ee:	8b 45 08             	mov    0x8(%ebp),%eax
801013f1:	83 ec 08             	sub    $0x8,%esp
801013f4:	6a 01                	push   $0x1
801013f6:	50                   	push   %eax
801013f7:	e8 d2 ed ff ff       	call   801001ce <bread>
801013fc:	83 c4 10             	add    $0x10,%esp
801013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101405:	83 c0 5c             	add    $0x5c,%eax
80101408:	83 ec 04             	sub    $0x4,%esp
8010140b:	6a 1c                	push   $0x1c
8010140d:	50                   	push   %eax
8010140e:	ff 75 0c             	push   0xc(%ebp)
80101411:	e8 ab 44 00 00       	call   801058c1 <memmove>
80101416:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101419:	83 ec 0c             	sub    $0xc,%esp
8010141c:	ff 75 f4             	push   -0xc(%ebp)
8010141f:	e8 2c ee ff ff       	call   80100250 <brelse>
80101424:	83 c4 10             	add    $0x10,%esp
}
80101427:	90                   	nop
80101428:	c9                   	leave  
80101429:	c3                   	ret    

8010142a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101430:	8b 55 0c             	mov    0xc(%ebp),%edx
80101433:	8b 45 08             	mov    0x8(%ebp),%eax
80101436:	83 ec 08             	sub    $0x8,%esp
80101439:	52                   	push   %edx
8010143a:	50                   	push   %eax
8010143b:	e8 8e ed ff ff       	call   801001ce <bread>
80101440:	83 c4 10             	add    $0x10,%esp
80101443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101449:	83 c0 5c             	add    $0x5c,%eax
8010144c:	83 ec 04             	sub    $0x4,%esp
8010144f:	68 00 02 00 00       	push   $0x200
80101454:	6a 00                	push   $0x0
80101456:	50                   	push   %eax
80101457:	e8 a6 43 00 00       	call   80105802 <memset>
8010145c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	ff 75 f4             	push   -0xc(%ebp)
80101465:	e8 f1 22 00 00       	call   8010375b <log_write>
8010146a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	ff 75 f4             	push   -0xc(%ebp)
80101473:	e8 d8 ed ff ff       	call   80100250 <brelse>
80101478:	83 c4 10             	add    $0x10,%esp
}
8010147b:	90                   	nop
8010147c:	c9                   	leave  
8010147d:	c3                   	ret    

8010147e <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010147e:	55                   	push   %ebp
8010147f:	89 e5                	mov    %esp,%ebp
80101481:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101484:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010148b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101492:	e9 13 01 00 00       	jmp    801015aa <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010149a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014a0:	85 c0                	test   %eax,%eax
801014a2:	0f 48 c2             	cmovs  %edx,%eax
801014a5:	c1 f8 0c             	sar    $0xc,%eax
801014a8:	89 c2                	mov    %eax,%edx
801014aa:	a1 98 2a 11 80       	mov    0x80112a98,%eax
801014af:	01 d0                	add    %edx,%eax
801014b1:	83 ec 08             	sub    $0x8,%esp
801014b4:	50                   	push   %eax
801014b5:	ff 75 08             	push   0x8(%ebp)
801014b8:	e8 11 ed ff ff       	call   801001ce <bread>
801014bd:	83 c4 10             	add    $0x10,%esp
801014c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014ca:	e9 a6 00 00 00       	jmp    80101575 <balloc+0xf7>
      m = 1 << (bi % 8);
801014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d2:	99                   	cltd   
801014d3:	c1 ea 1d             	shr    $0x1d,%edx
801014d6:	01 d0                	add    %edx,%eax
801014d8:	83 e0 07             	and    $0x7,%eax
801014db:	29 d0                	sub    %edx,%eax
801014dd:	ba 01 00 00 00       	mov    $0x1,%edx
801014e2:	89 c1                	mov    %eax,%ecx
801014e4:	d3 e2                	shl    %cl,%edx
801014e6:	89 d0                	mov    %edx,%eax
801014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ee:	8d 50 07             	lea    0x7(%eax),%edx
801014f1:	85 c0                	test   %eax,%eax
801014f3:	0f 48 c2             	cmovs  %edx,%eax
801014f6:	c1 f8 03             	sar    $0x3,%eax
801014f9:	89 c2                	mov    %eax,%edx
801014fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014fe:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101503:	0f b6 c0             	movzbl %al,%eax
80101506:	23 45 e8             	and    -0x18(%ebp),%eax
80101509:	85 c0                	test   %eax,%eax
8010150b:	75 64                	jne    80101571 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101510:	8d 50 07             	lea    0x7(%eax),%edx
80101513:	85 c0                	test   %eax,%eax
80101515:	0f 48 c2             	cmovs  %edx,%eax
80101518:	c1 f8 03             	sar    $0x3,%eax
8010151b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010151e:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101523:	89 d1                	mov    %edx,%ecx
80101525:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101528:	09 ca                	or     %ecx,%edx
8010152a:	89 d1                	mov    %edx,%ecx
8010152c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010152f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101533:	83 ec 0c             	sub    $0xc,%esp
80101536:	ff 75 ec             	push   -0x14(%ebp)
80101539:	e8 1d 22 00 00       	call   8010375b <log_write>
8010153e:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101541:	83 ec 0c             	sub    $0xc,%esp
80101544:	ff 75 ec             	push   -0x14(%ebp)
80101547:	e8 04 ed ff ff       	call   80100250 <brelse>
8010154c:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	01 c2                	add    %eax,%edx
80101557:	8b 45 08             	mov    0x8(%ebp),%eax
8010155a:	83 ec 08             	sub    $0x8,%esp
8010155d:	52                   	push   %edx
8010155e:	50                   	push   %eax
8010155f:	e8 c6 fe ff ff       	call   8010142a <bzero>
80101564:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	01 d0                	add    %edx,%eax
8010156f:	eb 57                	jmp    801015c8 <balloc+0x14a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101571:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101575:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010157c:	7f 17                	jg     80101595 <balloc+0x117>
8010157e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101584:	01 d0                	add    %edx,%eax
80101586:	89 c2                	mov    %eax,%edx
80101588:	a1 80 2a 11 80       	mov    0x80112a80,%eax
8010158d:	39 c2                	cmp    %eax,%edx
8010158f:	0f 82 3a ff ff ff    	jb     801014cf <balloc+0x51>
      }
    }
    brelse(bp);
80101595:	83 ec 0c             	sub    $0xc,%esp
80101598:	ff 75 ec             	push   -0x14(%ebp)
8010159b:	e8 b0 ec ff ff       	call   80100250 <brelse>
801015a0:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015a3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015aa:	8b 15 80 2a 11 80    	mov    0x80112a80,%edx
801015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015b3:	39 c2                	cmp    %eax,%edx
801015b5:	0f 87 dc fe ff ff    	ja     80101497 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015bb:	83 ec 0c             	sub    $0xc,%esp
801015be:	68 6c 8c 10 80       	push   $0x80108c6c
801015c3:	e8 d4 ef ff ff       	call   8010059c <panic>
}
801015c8:	c9                   	leave  
801015c9:	c3                   	ret    

801015ca <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015ca:	55                   	push   %ebp
801015cb:	89 e5                	mov    %esp,%ebp
801015cd:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d3:	c1 e8 0c             	shr    $0xc,%eax
801015d6:	89 c2                	mov    %eax,%edx
801015d8:	a1 98 2a 11 80       	mov    0x80112a98,%eax
801015dd:	01 c2                	add    %eax,%edx
801015df:	8b 45 08             	mov    0x8(%ebp),%eax
801015e2:	83 ec 08             	sub    $0x8,%esp
801015e5:	52                   	push   %edx
801015e6:	50                   	push   %eax
801015e7:	e8 e2 eb ff ff       	call   801001ce <bread>
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f5:	25 ff 0f 00 00       	and    $0xfff,%eax
801015fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101600:	99                   	cltd   
80101601:	c1 ea 1d             	shr    $0x1d,%edx
80101604:	01 d0                	add    %edx,%eax
80101606:	83 e0 07             	and    $0x7,%eax
80101609:	29 d0                	sub    %edx,%eax
8010160b:	ba 01 00 00 00       	mov    $0x1,%edx
80101610:	89 c1                	mov    %eax,%ecx
80101612:	d3 e2                	shl    %cl,%edx
80101614:	89 d0                	mov    %edx,%eax
80101616:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010161c:	8d 50 07             	lea    0x7(%eax),%edx
8010161f:	85 c0                	test   %eax,%eax
80101621:	0f 48 c2             	cmovs  %edx,%eax
80101624:	c1 f8 03             	sar    $0x3,%eax
80101627:	89 c2                	mov    %eax,%edx
80101629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010162c:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101631:	0f b6 c0             	movzbl %al,%eax
80101634:	23 45 ec             	and    -0x14(%ebp),%eax
80101637:	85 c0                	test   %eax,%eax
80101639:	75 0d                	jne    80101648 <bfree+0x7e>
    panic("freeing free block");
8010163b:	83 ec 0c             	sub    $0xc,%esp
8010163e:	68 82 8c 10 80       	push   $0x80108c82
80101643:	e8 54 ef ff ff       	call   8010059c <panic>
  bp->data[bi/8] &= ~m;
80101648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164b:	8d 50 07             	lea    0x7(%eax),%edx
8010164e:	85 c0                	test   %eax,%eax
80101650:	0f 48 c2             	cmovs  %edx,%eax
80101653:	c1 f8 03             	sar    $0x3,%eax
80101656:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101659:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010165e:	89 d1                	mov    %edx,%ecx
80101660:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101663:	f7 d2                	not    %edx
80101665:	21 ca                	and    %ecx,%edx
80101667:	89 d1                	mov    %edx,%ecx
80101669:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166c:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	ff 75 f4             	push   -0xc(%ebp)
80101676:	e8 e0 20 00 00       	call   8010375b <log_write>
8010167b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	ff 75 f4             	push   -0xc(%ebp)
80101684:	e8 c7 eb ff ff       	call   80100250 <brelse>
80101689:	83 c4 10             	add    $0x10,%esp
}
8010168c:	90                   	nop
8010168d:	c9                   	leave  
8010168e:	c3                   	ret    

8010168f <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010168f:	55                   	push   %ebp
80101690:	89 e5                	mov    %esp,%ebp
80101692:	57                   	push   %edi
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101698:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010169f:	83 ec 08             	sub    $0x8,%esp
801016a2:	68 95 8c 10 80       	push   $0x80108c95
801016a7:	68 a0 2a 11 80       	push   $0x80112aa0
801016ac:	e8 a8 3e 00 00       	call   80105559 <initlock>
801016b1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016bb:	eb 2d                	jmp    801016ea <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016c0:	89 d0                	mov    %edx,%eax
801016c2:	c1 e0 03             	shl    $0x3,%eax
801016c5:	01 d0                	add    %edx,%eax
801016c7:	c1 e0 04             	shl    $0x4,%eax
801016ca:	83 c0 30             	add    $0x30,%eax
801016cd:	05 a0 2a 11 80       	add    $0x80112aa0,%eax
801016d2:	83 c0 10             	add    $0x10,%eax
801016d5:	83 ec 08             	sub    $0x8,%esp
801016d8:	68 9c 8c 10 80       	push   $0x80108c9c
801016dd:	50                   	push   %eax
801016de:	e8 f3 3c 00 00       	call   801053d6 <initsleeplock>
801016e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016e6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016ea:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016ee:	7e cd                	jle    801016bd <iinit+0x2e>
  }

  readsb(dev, &sb);
801016f0:	83 ec 08             	sub    $0x8,%esp
801016f3:	68 80 2a 11 80       	push   $0x80112a80
801016f8:	ff 75 08             	push   0x8(%ebp)
801016fb:	e8 e8 fc ff ff       	call   801013e8 <readsb>
80101700:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101703:	a1 98 2a 11 80       	mov    0x80112a98,%eax
80101708:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010170b:	8b 3d 94 2a 11 80    	mov    0x80112a94,%edi
80101711:	8b 35 90 2a 11 80    	mov    0x80112a90,%esi
80101717:	8b 1d 8c 2a 11 80    	mov    0x80112a8c,%ebx
8010171d:	8b 0d 88 2a 11 80    	mov    0x80112a88,%ecx
80101723:	8b 15 84 2a 11 80    	mov    0x80112a84,%edx
80101729:	a1 80 2a 11 80       	mov    0x80112a80,%eax
8010172e:	ff 75 d4             	push   -0x2c(%ebp)
80101731:	57                   	push   %edi
80101732:	56                   	push   %esi
80101733:	53                   	push   %ebx
80101734:	51                   	push   %ecx
80101735:	52                   	push   %edx
80101736:	50                   	push   %eax
80101737:	68 a4 8c 10 80       	push   $0x80108ca4
8010173c:	e8 bb ec ff ff       	call   801003fc <cprintf>
80101741:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101744:	90                   	nop
80101745:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101748:	5b                   	pop    %ebx
80101749:	5e                   	pop    %esi
8010174a:	5f                   	pop    %edi
8010174b:	5d                   	pop    %ebp
8010174c:	c3                   	ret    

8010174d <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010174d:	55                   	push   %ebp
8010174e:	89 e5                	mov    %esp,%ebp
80101750:	83 ec 28             	sub    $0x28,%esp
80101753:	8b 45 0c             	mov    0xc(%ebp),%eax
80101756:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010175a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101761:	e9 9e 00 00 00       	jmp    80101804 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101769:	c1 e8 03             	shr    $0x3,%eax
8010176c:	89 c2                	mov    %eax,%edx
8010176e:	a1 94 2a 11 80       	mov    0x80112a94,%eax
80101773:	01 d0                	add    %edx,%eax
80101775:	83 ec 08             	sub    $0x8,%esp
80101778:	50                   	push   %eax
80101779:	ff 75 08             	push   0x8(%ebp)
8010177c:	e8 4d ea ff ff       	call   801001ce <bread>
80101781:	83 c4 10             	add    $0x10,%esp
80101784:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101790:	83 e0 07             	and    $0x7,%eax
80101793:	c1 e0 06             	shl    $0x6,%eax
80101796:	01 d0                	add    %edx,%eax
80101798:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010179b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010179e:	0f b7 00             	movzwl (%eax),%eax
801017a1:	66 85 c0             	test   %ax,%ax
801017a4:	75 4c                	jne    801017f2 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017a6:	83 ec 04             	sub    $0x4,%esp
801017a9:	6a 40                	push   $0x40
801017ab:	6a 00                	push   $0x0
801017ad:	ff 75 ec             	push   -0x14(%ebp)
801017b0:	e8 4d 40 00 00       	call   80105802 <memset>
801017b5:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017bb:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017bf:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017c2:	83 ec 0c             	sub    $0xc,%esp
801017c5:	ff 75 f0             	push   -0x10(%ebp)
801017c8:	e8 8e 1f 00 00       	call   8010375b <log_write>
801017cd:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017d0:	83 ec 0c             	sub    $0xc,%esp
801017d3:	ff 75 f0             	push   -0x10(%ebp)
801017d6:	e8 75 ea ff ff       	call   80100250 <brelse>
801017db:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e1:	83 ec 08             	sub    $0x8,%esp
801017e4:	50                   	push   %eax
801017e5:	ff 75 08             	push   0x8(%ebp)
801017e8:	e8 f8 00 00 00       	call   801018e5 <iget>
801017ed:	83 c4 10             	add    $0x10,%esp
801017f0:	eb 30                	jmp    80101822 <ialloc+0xd5>
    }
    brelse(bp);
801017f2:	83 ec 0c             	sub    $0xc,%esp
801017f5:	ff 75 f0             	push   -0x10(%ebp)
801017f8:	e8 53 ea ff ff       	call   80100250 <brelse>
801017fd:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101800:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101804:	8b 15 88 2a 11 80    	mov    0x80112a88,%edx
8010180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180d:	39 c2                	cmp    %eax,%edx
8010180f:	0f 87 51 ff ff ff    	ja     80101766 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101815:	83 ec 0c             	sub    $0xc,%esp
80101818:	68 f7 8c 10 80       	push   $0x80108cf7
8010181d:	e8 7a ed ff ff       	call   8010059c <panic>
}
80101822:	c9                   	leave  
80101823:	c3                   	ret    

80101824 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101824:	55                   	push   %ebp
80101825:	89 e5                	mov    %esp,%ebp
80101827:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	8b 40 04             	mov    0x4(%eax),%eax
80101830:	c1 e8 03             	shr    $0x3,%eax
80101833:	89 c2                	mov    %eax,%edx
80101835:	a1 94 2a 11 80       	mov    0x80112a94,%eax
8010183a:	01 c2                	add    %eax,%edx
8010183c:	8b 45 08             	mov    0x8(%ebp),%eax
8010183f:	8b 00                	mov    (%eax),%eax
80101841:	83 ec 08             	sub    $0x8,%esp
80101844:	52                   	push   %edx
80101845:	50                   	push   %eax
80101846:	e8 83 e9 ff ff       	call   801001ce <bread>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101854:	8d 50 5c             	lea    0x5c(%eax),%edx
80101857:	8b 45 08             	mov    0x8(%ebp),%eax
8010185a:	8b 40 04             	mov    0x4(%eax),%eax
8010185d:	83 e0 07             	and    $0x7,%eax
80101860:	c1 e0 06             	shl    $0x6,%eax
80101863:	01 d0                	add    %edx,%eax
80101865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101868:	8b 45 08             	mov    0x8(%ebp),%eax
8010186b:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101872:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101875:	8b 45 08             	mov    0x8(%ebp),%eax
80101878:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187f:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101883:	8b 45 08             	mov    0x8(%ebp),%eax
80101886:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188d:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101891:	8b 45 08             	mov    0x8(%ebp),%eax
80101894:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189b:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010189f:	8b 45 08             	mov    0x8(%ebp),%eax
801018a2:	8b 50 58             	mov    0x58(%eax),%edx
801018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a8:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ab:	8b 45 08             	mov    0x8(%ebp),%eax
801018ae:	8d 50 5c             	lea    0x5c(%eax),%edx
801018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b4:	83 c0 0c             	add    $0xc,%eax
801018b7:	83 ec 04             	sub    $0x4,%esp
801018ba:	6a 34                	push   $0x34
801018bc:	52                   	push   %edx
801018bd:	50                   	push   %eax
801018be:	e8 fe 3f 00 00       	call   801058c1 <memmove>
801018c3:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018c6:	83 ec 0c             	sub    $0xc,%esp
801018c9:	ff 75 f4             	push   -0xc(%ebp)
801018cc:	e8 8a 1e 00 00       	call   8010375b <log_write>
801018d1:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018d4:	83 ec 0c             	sub    $0xc,%esp
801018d7:	ff 75 f4             	push   -0xc(%ebp)
801018da:	e8 71 e9 ff ff       	call   80100250 <brelse>
801018df:	83 c4 10             	add    $0x10,%esp
}
801018e2:	90                   	nop
801018e3:	c9                   	leave  
801018e4:	c3                   	ret    

801018e5 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018e5:	55                   	push   %ebp
801018e6:	89 e5                	mov    %esp,%ebp
801018e8:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018eb:	83 ec 0c             	sub    $0xc,%esp
801018ee:	68 a0 2a 11 80       	push   $0x80112aa0
801018f3:	e8 83 3c 00 00       	call   8010557b <acquire>
801018f8:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101902:	c7 45 f4 d4 2a 11 80 	movl   $0x80112ad4,-0xc(%ebp)
80101909:	eb 60                	jmp    8010196b <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190e:	8b 40 08             	mov    0x8(%eax),%eax
80101911:	85 c0                	test   %eax,%eax
80101913:	7e 39                	jle    8010194e <iget+0x69>
80101915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101918:	8b 00                	mov    (%eax),%eax
8010191a:	39 45 08             	cmp    %eax,0x8(%ebp)
8010191d:	75 2f                	jne    8010194e <iget+0x69>
8010191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101922:	8b 40 04             	mov    0x4(%eax),%eax
80101925:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101928:	75 24                	jne    8010194e <iget+0x69>
      ip->ref++;
8010192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192d:	8b 40 08             	mov    0x8(%eax),%eax
80101930:	8d 50 01             	lea    0x1(%eax),%edx
80101933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101936:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101939:	83 ec 0c             	sub    $0xc,%esp
8010193c:	68 a0 2a 11 80       	push   $0x80112aa0
80101941:	e8 a3 3c 00 00       	call   801055e9 <release>
80101946:	83 c4 10             	add    $0x10,%esp
      return ip;
80101949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194c:	eb 77                	jmp    801019c5 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010194e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101952:	75 10                	jne    80101964 <iget+0x7f>
80101954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101957:	8b 40 08             	mov    0x8(%eax),%eax
8010195a:	85 c0                	test   %eax,%eax
8010195c:	75 06                	jne    80101964 <iget+0x7f>
      empty = ip;
8010195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101964:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010196b:	81 7d f4 f4 46 11 80 	cmpl   $0x801146f4,-0xc(%ebp)
80101972:	72 97                	jb     8010190b <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101978:	75 0d                	jne    80101987 <iget+0xa2>
    panic("iget: no inodes");
8010197a:	83 ec 0c             	sub    $0xc,%esp
8010197d:	68 09 8d 10 80       	push   $0x80108d09
80101982:	e8 15 ec ff ff       	call   8010059c <panic>

  ip = empty;
80101987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101990:	8b 55 08             	mov    0x8(%ebp),%edx
80101993:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101998:	8b 55 0c             	mov    0xc(%ebp),%edx
8010199b:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019b2:	83 ec 0c             	sub    $0xc,%esp
801019b5:	68 a0 2a 11 80       	push   $0x80112aa0
801019ba:	e8 2a 3c 00 00       	call   801055e9 <release>
801019bf:	83 c4 10             	add    $0x10,%esp

  return ip;
801019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019c5:	c9                   	leave  
801019c6:	c3                   	ret    

801019c7 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019c7:	55                   	push   %ebp
801019c8:	89 e5                	mov    %esp,%ebp
801019ca:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019cd:	83 ec 0c             	sub    $0xc,%esp
801019d0:	68 a0 2a 11 80       	push   $0x80112aa0
801019d5:	e8 a1 3b 00 00       	call   8010557b <acquire>
801019da:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019dd:	8b 45 08             	mov    0x8(%ebp),%eax
801019e0:	8b 40 08             	mov    0x8(%eax),%eax
801019e3:	8d 50 01             	lea    0x1(%eax),%edx
801019e6:	8b 45 08             	mov    0x8(%ebp),%eax
801019e9:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019ec:	83 ec 0c             	sub    $0xc,%esp
801019ef:	68 a0 2a 11 80       	push   $0x80112aa0
801019f4:	e8 f0 3b 00 00       	call   801055e9 <release>
801019f9:	83 c4 10             	add    $0x10,%esp
  return ip;
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019ff:	c9                   	leave  
80101a00:	c3                   	ret    

80101a01 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a01:	55                   	push   %ebp
80101a02:	89 e5                	mov    %esp,%ebp
80101a04:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a0b:	74 0a                	je     80101a17 <ilock+0x16>
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	8b 40 08             	mov    0x8(%eax),%eax
80101a13:	85 c0                	test   %eax,%eax
80101a15:	7f 0d                	jg     80101a24 <ilock+0x23>
    panic("ilock");
80101a17:	83 ec 0c             	sub    $0xc,%esp
80101a1a:	68 19 8d 10 80       	push   $0x80108d19
80101a1f:	e8 78 eb ff ff       	call   8010059c <panic>

  acquiresleep(&ip->lock);
80101a24:	8b 45 08             	mov    0x8(%ebp),%eax
80101a27:	83 c0 0c             	add    $0xc,%eax
80101a2a:	83 ec 0c             	sub    $0xc,%esp
80101a2d:	50                   	push   %eax
80101a2e:	e8 df 39 00 00       	call   80105412 <acquiresleep>
80101a33:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a3c:	85 c0                	test   %eax,%eax
80101a3e:	0f 85 cd 00 00 00    	jne    80101b11 <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a44:	8b 45 08             	mov    0x8(%ebp),%eax
80101a47:	8b 40 04             	mov    0x4(%eax),%eax
80101a4a:	c1 e8 03             	shr    $0x3,%eax
80101a4d:	89 c2                	mov    %eax,%edx
80101a4f:	a1 94 2a 11 80       	mov    0x80112a94,%eax
80101a54:	01 c2                	add    %eax,%edx
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	8b 00                	mov    (%eax),%eax
80101a5b:	83 ec 08             	sub    $0x8,%esp
80101a5e:	52                   	push   %edx
80101a5f:	50                   	push   %eax
80101a60:	e8 69 e7 ff ff       	call   801001ce <bread>
80101a65:	83 c4 10             	add    $0x10,%esp
80101a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 40 04             	mov    0x4(%eax),%eax
80101a77:	83 e0 07             	and    $0x7,%eax
80101a7a:	c1 e0 06             	shl    $0x6,%eax
80101a7d:	01 d0                	add    %edx,%eax
80101a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a85:	0f b7 10             	movzwl (%eax),%edx
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a92:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aae:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abc:	8b 50 08             	mov    0x8(%eax),%edx
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac8:	8d 50 0c             	lea    0xc(%eax),%edx
80101acb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ace:	83 c0 5c             	add    $0x5c,%eax
80101ad1:	83 ec 04             	sub    $0x4,%esp
80101ad4:	6a 34                	push   $0x34
80101ad6:	52                   	push   %edx
80101ad7:	50                   	push   %eax
80101ad8:	e8 e4 3d 00 00       	call   801058c1 <memmove>
80101add:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ae0:	83 ec 0c             	sub    $0xc,%esp
80101ae3:	ff 75 f4             	push   -0xc(%ebp)
80101ae6:	e8 65 e7 ff ff       	call   80100250 <brelse>
80101aeb:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101af8:	8b 45 08             	mov    0x8(%ebp),%eax
80101afb:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101aff:	66 85 c0             	test   %ax,%ax
80101b02:	75 0d                	jne    80101b11 <ilock+0x110>
      panic("ilock: no type");
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	68 1f 8d 10 80       	push   $0x80108d1f
80101b0c:	e8 8b ea ff ff       	call   8010059c <panic>
  }
}
80101b11:	90                   	nop
80101b12:	c9                   	leave  
80101b13:	c3                   	ret    

80101b14 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b14:	55                   	push   %ebp
80101b15:	89 e5                	mov    %esp,%ebp
80101b17:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b1e:	74 20                	je     80101b40 <iunlock+0x2c>
80101b20:	8b 45 08             	mov    0x8(%ebp),%eax
80101b23:	83 c0 0c             	add    $0xc,%eax
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	50                   	push   %eax
80101b2a:	e8 95 39 00 00       	call   801054c4 <holdingsleep>
80101b2f:	83 c4 10             	add    $0x10,%esp
80101b32:	85 c0                	test   %eax,%eax
80101b34:	74 0a                	je     80101b40 <iunlock+0x2c>
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	8b 40 08             	mov    0x8(%eax),%eax
80101b3c:	85 c0                	test   %eax,%eax
80101b3e:	7f 0d                	jg     80101b4d <iunlock+0x39>
    panic("iunlock");
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	68 2e 8d 10 80       	push   $0x80108d2e
80101b48:	e8 4f ea ff ff       	call   8010059c <panic>

  releasesleep(&ip->lock);
80101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b50:	83 c0 0c             	add    $0xc,%eax
80101b53:	83 ec 0c             	sub    $0xc,%esp
80101b56:	50                   	push   %eax
80101b57:	e8 1a 39 00 00       	call   80105476 <releasesleep>
80101b5c:	83 c4 10             	add    $0x10,%esp
}
80101b5f:	90                   	nop
80101b60:	c9                   	leave  
80101b61:	c3                   	ret    

80101b62 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b62:	55                   	push   %ebp
80101b63:	89 e5                	mov    %esp,%ebp
80101b65:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	83 c0 0c             	add    $0xc,%eax
80101b6e:	83 ec 0c             	sub    $0xc,%esp
80101b71:	50                   	push   %eax
80101b72:	e8 9b 38 00 00       	call   80105412 <acquiresleep>
80101b77:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b80:	85 c0                	test   %eax,%eax
80101b82:	74 6a                	je     80101bee <iput+0x8c>
80101b84:	8b 45 08             	mov    0x8(%ebp),%eax
80101b87:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b8b:	66 85 c0             	test   %ax,%ax
80101b8e:	75 5e                	jne    80101bee <iput+0x8c>
    acquire(&icache.lock);
80101b90:	83 ec 0c             	sub    $0xc,%esp
80101b93:	68 a0 2a 11 80       	push   $0x80112aa0
80101b98:	e8 de 39 00 00       	call   8010557b <acquire>
80101b9d:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba3:	8b 40 08             	mov    0x8(%eax),%eax
80101ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	68 a0 2a 11 80       	push   $0x80112aa0
80101bb1:	e8 33 3a 00 00       	call   801055e9 <release>
80101bb6:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101bb9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bbd:	75 2f                	jne    80101bee <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	ff 75 08             	push   0x8(%ebp)
80101bc5:	e8 ad 01 00 00       	call   80101d77 <itrunc>
80101bca:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	ff 75 08             	push   0x8(%ebp)
80101bdc:	e8 43 fc ff ff       	call   80101824 <iupdate>
80101be1:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101be4:	8b 45 08             	mov    0x8(%ebp),%eax
80101be7:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bee:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf1:	83 c0 0c             	add    $0xc,%eax
80101bf4:	83 ec 0c             	sub    $0xc,%esp
80101bf7:	50                   	push   %eax
80101bf8:	e8 79 38 00 00       	call   80105476 <releasesleep>
80101bfd:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c00:	83 ec 0c             	sub    $0xc,%esp
80101c03:	68 a0 2a 11 80       	push   $0x80112aa0
80101c08:	e8 6e 39 00 00       	call   8010557b <acquire>
80101c0d:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	8b 40 08             	mov    0x8(%eax),%eax
80101c16:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c1f:	83 ec 0c             	sub    $0xc,%esp
80101c22:	68 a0 2a 11 80       	push   $0x80112aa0
80101c27:	e8 bd 39 00 00       	call   801055e9 <release>
80101c2c:	83 c4 10             	add    $0x10,%esp
}
80101c2f:	90                   	nop
80101c30:	c9                   	leave  
80101c31:	c3                   	ret    

80101c32 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c32:	55                   	push   %ebp
80101c33:	89 e5                	mov    %esp,%ebp
80101c35:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	ff 75 08             	push   0x8(%ebp)
80101c3e:	e8 d1 fe ff ff       	call   80101b14 <iunlock>
80101c43:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c46:	83 ec 0c             	sub    $0xc,%esp
80101c49:	ff 75 08             	push   0x8(%ebp)
80101c4c:	e8 11 ff ff ff       	call   80101b62 <iput>
80101c51:	83 c4 10             	add    $0x10,%esp
}
80101c54:	90                   	nop
80101c55:	c9                   	leave  
80101c56:	c3                   	ret    

80101c57 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c57:	55                   	push   %ebp
80101c58:	89 e5                	mov    %esp,%ebp
80101c5a:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c5d:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c61:	77 42                	ja     80101ca5 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c63:	8b 45 08             	mov    0x8(%ebp),%eax
80101c66:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c69:	83 c2 14             	add    $0x14,%edx
80101c6c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c77:	75 24                	jne    80101c9d <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	8b 00                	mov    (%eax),%eax
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	50                   	push   %eax
80101c82:	e8 f7 f7 ff ff       	call   8010147e <balloc>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c90:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c93:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c99:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ca0:	e9 d0 00 00 00       	jmp    80101d75 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101ca5:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101ca9:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cad:	0f 87 b5 00 00 00    	ja     80101d68 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc3:	75 20                	jne    80101ce5 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc8:	8b 00                	mov    (%eax),%eax
80101cca:	83 ec 0c             	sub    $0xc,%esp
80101ccd:	50                   	push   %eax
80101cce:	e8 ab f7 ff ff       	call   8010147e <balloc>
80101cd3:	83 c4 10             	add    $0x10,%esp
80101cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cdf:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce8:	8b 00                	mov    (%eax),%eax
80101cea:	83 ec 08             	sub    $0x8,%esp
80101ced:	ff 75 f4             	push   -0xc(%ebp)
80101cf0:	50                   	push   %eax
80101cf1:	e8 d8 e4 ff ff       	call   801001ce <bread>
80101cf6:	83 c4 10             	add    $0x10,%esp
80101cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cff:	83 c0 5c             	add    $0x5c,%eax
80101d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d05:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d12:	01 d0                	add    %edx,%eax
80101d14:	8b 00                	mov    (%eax),%eax
80101d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d1d:	75 36                	jne    80101d55 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d22:	8b 00                	mov    (%eax),%eax
80101d24:	83 ec 0c             	sub    $0xc,%esp
80101d27:	50                   	push   %eax
80101d28:	e8 51 f7 ff ff       	call   8010147e <balloc>
80101d2d:	83 c4 10             	add    $0x10,%esp
80101d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d40:	01 c2                	add    %eax,%edx
80101d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d45:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	ff 75 f0             	push   -0x10(%ebp)
80101d4d:	e8 09 1a 00 00       	call   8010375b <log_write>
80101d52:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d55:	83 ec 0c             	sub    $0xc,%esp
80101d58:	ff 75 f0             	push   -0x10(%ebp)
80101d5b:	e8 f0 e4 ff ff       	call   80100250 <brelse>
80101d60:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d66:	eb 0d                	jmp    80101d75 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d68:	83 ec 0c             	sub    $0xc,%esp
80101d6b:	68 36 8d 10 80       	push   $0x80108d36
80101d70:	e8 27 e8 ff ff       	call   8010059c <panic>
}
80101d75:	c9                   	leave  
80101d76:	c3                   	ret    

80101d77 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d77:	55                   	push   %ebp
80101d78:	89 e5                	mov    %esp,%ebp
80101d7a:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d84:	eb 45                	jmp    80101dcb <itrunc+0x54>
    if(ip->addrs[i]){
80101d86:	8b 45 08             	mov    0x8(%ebp),%eax
80101d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8c:	83 c2 14             	add    $0x14,%edx
80101d8f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 30                	je     80101dc7 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d97:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9d:	83 c2 14             	add    $0x14,%edx
80101da0:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101da4:	8b 55 08             	mov    0x8(%ebp),%edx
80101da7:	8b 12                	mov    (%edx),%edx
80101da9:	83 ec 08             	sub    $0x8,%esp
80101dac:	50                   	push   %eax
80101dad:	52                   	push   %edx
80101dae:	e8 17 f8 ff ff       	call   801015ca <bfree>
80101db3:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dbc:	83 c2 14             	add    $0x14,%edx
80101dbf:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dc6:	00 
  for(i = 0; i < NDIRECT; i++){
80101dc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dcb:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dcf:	7e b5                	jle    80101d86 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dda:	85 c0                	test   %eax,%eax
80101ddc:	0f 84 aa 00 00 00    	je     80101e8c <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101de2:	8b 45 08             	mov    0x8(%ebp),%eax
80101de5:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101deb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dee:	8b 00                	mov    (%eax),%eax
80101df0:	83 ec 08             	sub    $0x8,%esp
80101df3:	52                   	push   %edx
80101df4:	50                   	push   %eax
80101df5:	e8 d4 e3 ff ff       	call   801001ce <bread>
80101dfa:	83 c4 10             	add    $0x10,%esp
80101dfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e03:	83 c0 5c             	add    $0x5c,%eax
80101e06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e10:	eb 3c                	jmp    80101e4e <itrunc+0xd7>
      if(a[j])
80101e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e1f:	01 d0                	add    %edx,%eax
80101e21:	8b 00                	mov    (%eax),%eax
80101e23:	85 c0                	test   %eax,%eax
80101e25:	74 23                	je     80101e4a <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e31:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e34:	01 d0                	add    %edx,%eax
80101e36:	8b 00                	mov    (%eax),%eax
80101e38:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3b:	8b 12                	mov    (%edx),%edx
80101e3d:	83 ec 08             	sub    $0x8,%esp
80101e40:	50                   	push   %eax
80101e41:	52                   	push   %edx
80101e42:	e8 83 f7 ff ff       	call   801015ca <bfree>
80101e47:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e4a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e51:	83 f8 7f             	cmp    $0x7f,%eax
80101e54:	76 bc                	jbe    80101e12 <itrunc+0x9b>
    }
    brelse(bp);
80101e56:	83 ec 0c             	sub    $0xc,%esp
80101e59:	ff 75 ec             	push   -0x14(%ebp)
80101e5c:	e8 ef e3 ff ff       	call   80100250 <brelse>
80101e61:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80101e70:	8b 12                	mov    (%edx),%edx
80101e72:	83 ec 08             	sub    $0x8,%esp
80101e75:	50                   	push   %eax
80101e76:	52                   	push   %edx
80101e77:	e8 4e f7 ff ff       	call   801015ca <bfree>
80101e7c:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e89:	00 00 00 
  }

  ip->size = 0;
80101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8f:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	ff 75 08             	push   0x8(%ebp)
80101e9c:	e8 83 f9 ff ff       	call   80101824 <iupdate>
80101ea1:	83 c4 10             	add    $0x10,%esp
}
80101ea4:	90                   	nop
80101ea5:	c9                   	leave  
80101ea6:	c3                   	ret    

80101ea7 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ea7:	55                   	push   %ebp
80101ea8:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ead:	8b 00                	mov    (%eax),%eax
80101eaf:	89 c2                	mov    %eax,%edx
80101eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb4:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eba:	8b 50 04             	mov    0x4(%eax),%edx
80101ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec0:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101eca:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecd:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eda:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	8b 50 58             	mov    0x58(%eax),%edx
80101ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee7:	89 50 10             	mov    %edx,0x10(%eax)
}
80101eea:	90                   	nop
80101eeb:	5d                   	pop    %ebp
80101eec:	c3                   	ret    

80101eed <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101eed:	55                   	push   %ebp
80101eee:	89 e5                	mov    %esp,%ebp
80101ef0:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef6:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101efa:	66 83 f8 03          	cmp    $0x3,%ax
80101efe:	75 5c                	jne    80101f5c <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f00:	8b 45 08             	mov    0x8(%ebp),%eax
80101f03:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f07:	66 85 c0             	test   %ax,%ax
80101f0a:	78 20                	js     80101f2c <readi+0x3f>
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f13:	66 83 f8 09          	cmp    $0x9,%ax
80101f17:	7f 13                	jg     80101f2c <readi+0x3f>
80101f19:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f20:	98                   	cwtl   
80101f21:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
80101f28:	85 c0                	test   %eax,%eax
80101f2a:	75 0a                	jne    80101f36 <readi+0x49>
      return -1;
80101f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f31:	e9 0c 01 00 00       	jmp    80102042 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f36:	8b 45 08             	mov    0x8(%ebp),%eax
80101f39:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f3d:	98                   	cwtl   
80101f3e:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
80101f45:	8b 55 14             	mov    0x14(%ebp),%edx
80101f48:	83 ec 04             	sub    $0x4,%esp
80101f4b:	52                   	push   %edx
80101f4c:	ff 75 0c             	push   0xc(%ebp)
80101f4f:	ff 75 08             	push   0x8(%ebp)
80101f52:	ff d0                	call   *%eax
80101f54:	83 c4 10             	add    $0x10,%esp
80101f57:	e9 e6 00 00 00       	jmp    80102042 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	8b 40 58             	mov    0x58(%eax),%eax
80101f62:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f65:	77 0d                	ja     80101f74 <readi+0x87>
80101f67:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6d:	01 d0                	add    %edx,%eax
80101f6f:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f72:	76 0a                	jbe    80101f7e <readi+0x91>
    return -1;
80101f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f79:	e9 c4 00 00 00       	jmp    80102042 <readi+0x155>
  if(off + n > ip->size)
80101f7e:	8b 55 10             	mov    0x10(%ebp),%edx
80101f81:	8b 45 14             	mov    0x14(%ebp),%eax
80101f84:	01 c2                	add    %eax,%edx
80101f86:	8b 45 08             	mov    0x8(%ebp),%eax
80101f89:	8b 40 58             	mov    0x58(%eax),%eax
80101f8c:	39 c2                	cmp    %eax,%edx
80101f8e:	76 0c                	jbe    80101f9c <readi+0xaf>
    n = ip->size - off;
80101f90:	8b 45 08             	mov    0x8(%ebp),%eax
80101f93:	8b 40 58             	mov    0x58(%eax),%eax
80101f96:	2b 45 10             	sub    0x10(%ebp),%eax
80101f99:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fa3:	e9 8b 00 00 00       	jmp    80102033 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa8:	8b 45 10             	mov    0x10(%ebp),%eax
80101fab:	c1 e8 09             	shr    $0x9,%eax
80101fae:	83 ec 08             	sub    $0x8,%esp
80101fb1:	50                   	push   %eax
80101fb2:	ff 75 08             	push   0x8(%ebp)
80101fb5:	e8 9d fc ff ff       	call   80101c57 <bmap>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	89 c2                	mov    %eax,%edx
80101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc2:	8b 00                	mov    (%eax),%eax
80101fc4:	83 ec 08             	sub    $0x8,%esp
80101fc7:	52                   	push   %edx
80101fc8:	50                   	push   %eax
80101fc9:	e8 00 e2 ff ff       	call   801001ce <bread>
80101fce:	83 c4 10             	add    $0x10,%esp
80101fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd4:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fdc:	ba 00 02 00 00       	mov    $0x200,%edx
80101fe1:	29 c2                	sub    %eax,%edx
80101fe3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fe6:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fe9:	39 c2                	cmp    %eax,%edx
80101feb:	0f 46 c2             	cmovbe %edx,%eax
80101fee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff4:	8d 50 5c             	lea    0x5c(%eax),%edx
80101ff7:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffa:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fff:	01 d0                	add    %edx,%eax
80102001:	83 ec 04             	sub    $0x4,%esp
80102004:	ff 75 ec             	push   -0x14(%ebp)
80102007:	50                   	push   %eax
80102008:	ff 75 0c             	push   0xc(%ebp)
8010200b:	e8 b1 38 00 00       	call   801058c1 <memmove>
80102010:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102013:	83 ec 0c             	sub    $0xc,%esp
80102016:	ff 75 f0             	push   -0x10(%ebp)
80102019:	e8 32 e2 ff ff       	call   80100250 <brelse>
8010201e:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102021:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102024:	01 45 f4             	add    %eax,-0xc(%ebp)
80102027:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202a:	01 45 10             	add    %eax,0x10(%ebp)
8010202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102030:	01 45 0c             	add    %eax,0xc(%ebp)
80102033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102036:	3b 45 14             	cmp    0x14(%ebp),%eax
80102039:	0f 82 69 ff ff ff    	jb     80101fa8 <readi+0xbb>
  }
  return n;
8010203f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102042:	c9                   	leave  
80102043:	c3                   	ret    

80102044 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102044:	55                   	push   %ebp
80102045:	89 e5                	mov    %esp,%ebp
80102047:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010204a:	8b 45 08             	mov    0x8(%ebp),%eax
8010204d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102051:	66 83 f8 03          	cmp    $0x3,%ax
80102055:	75 5c                	jne    801020b3 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102057:	8b 45 08             	mov    0x8(%ebp),%eax
8010205a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010205e:	66 85 c0             	test   %ax,%ax
80102061:	78 20                	js     80102083 <writei+0x3f>
80102063:	8b 45 08             	mov    0x8(%ebp),%eax
80102066:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010206a:	66 83 f8 09          	cmp    $0x9,%ax
8010206e:	7f 13                	jg     80102083 <writei+0x3f>
80102070:	8b 45 08             	mov    0x8(%ebp),%eax
80102073:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102077:	98                   	cwtl   
80102078:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
8010207f:	85 c0                	test   %eax,%eax
80102081:	75 0a                	jne    8010208d <writei+0x49>
      return -1;
80102083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102088:	e9 3d 01 00 00       	jmp    801021ca <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010208d:	8b 45 08             	mov    0x8(%ebp),%eax
80102090:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102094:	98                   	cwtl   
80102095:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
8010209c:	8b 55 14             	mov    0x14(%ebp),%edx
8010209f:	83 ec 04             	sub    $0x4,%esp
801020a2:	52                   	push   %edx
801020a3:	ff 75 0c             	push   0xc(%ebp)
801020a6:	ff 75 08             	push   0x8(%ebp)
801020a9:	ff d0                	call   *%eax
801020ab:	83 c4 10             	add    $0x10,%esp
801020ae:	e9 17 01 00 00       	jmp    801021ca <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020b3:	8b 45 08             	mov    0x8(%ebp),%eax
801020b6:	8b 40 58             	mov    0x58(%eax),%eax
801020b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801020bc:	77 0d                	ja     801020cb <writei+0x87>
801020be:	8b 55 10             	mov    0x10(%ebp),%edx
801020c1:	8b 45 14             	mov    0x14(%ebp),%eax
801020c4:	01 d0                	add    %edx,%eax
801020c6:	39 45 10             	cmp    %eax,0x10(%ebp)
801020c9:	76 0a                	jbe    801020d5 <writei+0x91>
    return -1;
801020cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d0:	e9 f5 00 00 00       	jmp    801021ca <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020d5:	8b 55 10             	mov    0x10(%ebp),%edx
801020d8:	8b 45 14             	mov    0x14(%ebp),%eax
801020db:	01 d0                	add    %edx,%eax
801020dd:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020e2:	76 0a                	jbe    801020ee <writei+0xaa>
    return -1;
801020e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e9:	e9 dc 00 00 00       	jmp    801021ca <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020f5:	e9 99 00 00 00       	jmp    80102193 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020fa:	8b 45 10             	mov    0x10(%ebp),%eax
801020fd:	c1 e8 09             	shr    $0x9,%eax
80102100:	83 ec 08             	sub    $0x8,%esp
80102103:	50                   	push   %eax
80102104:	ff 75 08             	push   0x8(%ebp)
80102107:	e8 4b fb ff ff       	call   80101c57 <bmap>
8010210c:	83 c4 10             	add    $0x10,%esp
8010210f:	89 c2                	mov    %eax,%edx
80102111:	8b 45 08             	mov    0x8(%ebp),%eax
80102114:	8b 00                	mov    (%eax),%eax
80102116:	83 ec 08             	sub    $0x8,%esp
80102119:	52                   	push   %edx
8010211a:	50                   	push   %eax
8010211b:	e8 ae e0 ff ff       	call   801001ce <bread>
80102120:	83 c4 10             	add    $0x10,%esp
80102123:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102126:	8b 45 10             	mov    0x10(%ebp),%eax
80102129:	25 ff 01 00 00       	and    $0x1ff,%eax
8010212e:	ba 00 02 00 00       	mov    $0x200,%edx
80102133:	29 c2                	sub    %eax,%edx
80102135:	8b 45 14             	mov    0x14(%ebp),%eax
80102138:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010213b:	39 c2                	cmp    %eax,%edx
8010213d:	0f 46 c2             	cmovbe %edx,%eax
80102140:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102143:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102146:	8d 50 5c             	lea    0x5c(%eax),%edx
80102149:	8b 45 10             	mov    0x10(%ebp),%eax
8010214c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102151:	01 d0                	add    %edx,%eax
80102153:	83 ec 04             	sub    $0x4,%esp
80102156:	ff 75 ec             	push   -0x14(%ebp)
80102159:	ff 75 0c             	push   0xc(%ebp)
8010215c:	50                   	push   %eax
8010215d:	e8 5f 37 00 00       	call   801058c1 <memmove>
80102162:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	ff 75 f0             	push   -0x10(%ebp)
8010216b:	e8 eb 15 00 00       	call   8010375b <log_write>
80102170:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102173:	83 ec 0c             	sub    $0xc,%esp
80102176:	ff 75 f0             	push   -0x10(%ebp)
80102179:	e8 d2 e0 ff ff       	call   80100250 <brelse>
8010217e:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102181:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102184:	01 45 f4             	add    %eax,-0xc(%ebp)
80102187:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010218a:	01 45 10             	add    %eax,0x10(%ebp)
8010218d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102190:	01 45 0c             	add    %eax,0xc(%ebp)
80102193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102196:	3b 45 14             	cmp    0x14(%ebp),%eax
80102199:	0f 82 5b ff ff ff    	jb     801020fa <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010219f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021a3:	74 22                	je     801021c7 <writei+0x183>
801021a5:	8b 45 08             	mov    0x8(%ebp),%eax
801021a8:	8b 40 58             	mov    0x58(%eax),%eax
801021ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801021ae:	76 17                	jbe    801021c7 <writei+0x183>
    ip->size = off;
801021b0:	8b 45 08             	mov    0x8(%ebp),%eax
801021b3:	8b 55 10             	mov    0x10(%ebp),%edx
801021b6:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021b9:	83 ec 0c             	sub    $0xc,%esp
801021bc:	ff 75 08             	push   0x8(%ebp)
801021bf:	e8 60 f6 ff ff       	call   80101824 <iupdate>
801021c4:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021c7:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021ca:	c9                   	leave  
801021cb:	c3                   	ret    

801021cc <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021cc:	55                   	push   %ebp
801021cd:	89 e5                	mov    %esp,%ebp
801021cf:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021d2:	83 ec 04             	sub    $0x4,%esp
801021d5:	6a 0e                	push   $0xe
801021d7:	ff 75 0c             	push   0xc(%ebp)
801021da:	ff 75 08             	push   0x8(%ebp)
801021dd:	e8 75 37 00 00       	call   80105957 <strncmp>
801021e2:	83 c4 10             	add    $0x10,%esp
}
801021e5:	c9                   	leave  
801021e6:	c3                   	ret    

801021e7 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021e7:	55                   	push   %ebp
801021e8:	89 e5                	mov    %esp,%ebp
801021ea:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ed:	8b 45 08             	mov    0x8(%ebp),%eax
801021f0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021f4:	66 83 f8 01          	cmp    $0x1,%ax
801021f8:	74 0d                	je     80102207 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021fa:	83 ec 0c             	sub    $0xc,%esp
801021fd:	68 49 8d 10 80       	push   $0x80108d49
80102202:	e8 95 e3 ff ff       	call   8010059c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010220e:	eb 7b                	jmp    8010228b <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102210:	6a 10                	push   $0x10
80102212:	ff 75 f4             	push   -0xc(%ebp)
80102215:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102218:	50                   	push   %eax
80102219:	ff 75 08             	push   0x8(%ebp)
8010221c:	e8 cc fc ff ff       	call   80101eed <readi>
80102221:	83 c4 10             	add    $0x10,%esp
80102224:	83 f8 10             	cmp    $0x10,%eax
80102227:	74 0d                	je     80102236 <dirlookup+0x4f>
      panic("dirlookup read");
80102229:	83 ec 0c             	sub    $0xc,%esp
8010222c:	68 5b 8d 10 80       	push   $0x80108d5b
80102231:	e8 66 e3 ff ff       	call   8010059c <panic>
    if(de.inum == 0)
80102236:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010223a:	66 85 c0             	test   %ax,%ax
8010223d:	74 47                	je     80102286 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010223f:	83 ec 08             	sub    $0x8,%esp
80102242:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102245:	83 c0 02             	add    $0x2,%eax
80102248:	50                   	push   %eax
80102249:	ff 75 0c             	push   0xc(%ebp)
8010224c:	e8 7b ff ff ff       	call   801021cc <namecmp>
80102251:	83 c4 10             	add    $0x10,%esp
80102254:	85 c0                	test   %eax,%eax
80102256:	75 2f                	jne    80102287 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010225c:	74 08                	je     80102266 <dirlookup+0x7f>
        *poff = off;
8010225e:	8b 45 10             	mov    0x10(%ebp),%eax
80102261:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102264:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102266:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010226a:	0f b7 c0             	movzwl %ax,%eax
8010226d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102270:	8b 45 08             	mov    0x8(%ebp),%eax
80102273:	8b 00                	mov    (%eax),%eax
80102275:	83 ec 08             	sub    $0x8,%esp
80102278:	ff 75 f0             	push   -0x10(%ebp)
8010227b:	50                   	push   %eax
8010227c:	e8 64 f6 ff ff       	call   801018e5 <iget>
80102281:	83 c4 10             	add    $0x10,%esp
80102284:	eb 19                	jmp    8010229f <dirlookup+0xb8>
      continue;
80102286:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102287:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010228b:	8b 45 08             	mov    0x8(%ebp),%eax
8010228e:	8b 40 58             	mov    0x58(%eax),%eax
80102291:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102294:	0f 82 76 ff ff ff    	jb     80102210 <dirlookup+0x29>
    }
  }

  return 0;
8010229a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010229f:	c9                   	leave  
801022a0:	c3                   	ret    

801022a1 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022a1:	55                   	push   %ebp
801022a2:	89 e5                	mov    %esp,%ebp
801022a4:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022a7:	83 ec 04             	sub    $0x4,%esp
801022aa:	6a 00                	push   $0x0
801022ac:	ff 75 0c             	push   0xc(%ebp)
801022af:	ff 75 08             	push   0x8(%ebp)
801022b2:	e8 30 ff ff ff       	call   801021e7 <dirlookup>
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022c1:	74 18                	je     801022db <dirlink+0x3a>
    iput(ip);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	ff 75 f0             	push   -0x10(%ebp)
801022c9:	e8 94 f8 ff ff       	call   80101b62 <iput>
801022ce:	83 c4 10             	add    $0x10,%esp
    return -1;
801022d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d6:	e9 9c 00 00 00       	jmp    80102377 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022e2:	eb 39                	jmp    8010231d <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e7:	6a 10                	push   $0x10
801022e9:	50                   	push   %eax
801022ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ed:	50                   	push   %eax
801022ee:	ff 75 08             	push   0x8(%ebp)
801022f1:	e8 f7 fb ff ff       	call   80101eed <readi>
801022f6:	83 c4 10             	add    $0x10,%esp
801022f9:	83 f8 10             	cmp    $0x10,%eax
801022fc:	74 0d                	je     8010230b <dirlink+0x6a>
      panic("dirlink read");
801022fe:	83 ec 0c             	sub    $0xc,%esp
80102301:	68 6a 8d 10 80       	push   $0x80108d6a
80102306:	e8 91 e2 ff ff       	call   8010059c <panic>
    if(de.inum == 0)
8010230b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010230f:	66 85 c0             	test   %ax,%ax
80102312:	74 18                	je     8010232c <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102317:	83 c0 10             	add    $0x10,%eax
8010231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010231d:	8b 45 08             	mov    0x8(%ebp),%eax
80102320:	8b 50 58             	mov    0x58(%eax),%edx
80102323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102326:	39 c2                	cmp    %eax,%edx
80102328:	77 ba                	ja     801022e4 <dirlink+0x43>
8010232a:	eb 01                	jmp    8010232d <dirlink+0x8c>
      break;
8010232c:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010232d:	83 ec 04             	sub    $0x4,%esp
80102330:	6a 0e                	push   $0xe
80102332:	ff 75 0c             	push   0xc(%ebp)
80102335:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102338:	83 c0 02             	add    $0x2,%eax
8010233b:	50                   	push   %eax
8010233c:	e8 6c 36 00 00       	call   801059ad <strncpy>
80102341:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102344:	8b 45 10             	mov    0x10(%ebp),%eax
80102347:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234e:	6a 10                	push   $0x10
80102350:	50                   	push   %eax
80102351:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102354:	50                   	push   %eax
80102355:	ff 75 08             	push   0x8(%ebp)
80102358:	e8 e7 fc ff ff       	call   80102044 <writei>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	83 f8 10             	cmp    $0x10,%eax
80102363:	74 0d                	je     80102372 <dirlink+0xd1>
    panic("dirlink");
80102365:	83 ec 0c             	sub    $0xc,%esp
80102368:	68 77 8d 10 80       	push   $0x80108d77
8010236d:	e8 2a e2 ff ff       	call   8010059c <panic>

  return 0;
80102372:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102377:	c9                   	leave  
80102378:	c3                   	ret    

80102379 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102379:	55                   	push   %ebp
8010237a:	89 e5                	mov    %esp,%ebp
8010237c:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010237f:	eb 04                	jmp    80102385 <skipelem+0xc>
    path++;
80102381:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
80102388:	0f b6 00             	movzbl (%eax),%eax
8010238b:	3c 2f                	cmp    $0x2f,%al
8010238d:	74 f2                	je     80102381 <skipelem+0x8>
  if(*path == 0)
8010238f:	8b 45 08             	mov    0x8(%ebp),%eax
80102392:	0f b6 00             	movzbl (%eax),%eax
80102395:	84 c0                	test   %al,%al
80102397:	75 07                	jne    801023a0 <skipelem+0x27>
    return 0;
80102399:	b8 00 00 00 00       	mov    $0x0,%eax
8010239e:	eb 7b                	jmp    8010241b <skipelem+0xa2>
  s = path;
801023a0:	8b 45 08             	mov    0x8(%ebp),%eax
801023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023a6:	eb 04                	jmp    801023ac <skipelem+0x33>
    path++;
801023a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801023ac:	8b 45 08             	mov    0x8(%ebp),%eax
801023af:	0f b6 00             	movzbl (%eax),%eax
801023b2:	3c 2f                	cmp    $0x2f,%al
801023b4:	74 0a                	je     801023c0 <skipelem+0x47>
801023b6:	8b 45 08             	mov    0x8(%ebp),%eax
801023b9:	0f b6 00             	movzbl (%eax),%eax
801023bc:	84 c0                	test   %al,%al
801023be:	75 e8                	jne    801023a8 <skipelem+0x2f>
  len = path - s;
801023c0:	8b 55 08             	mov    0x8(%ebp),%edx
801023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c6:	29 c2                	sub    %eax,%edx
801023c8:	89 d0                	mov    %edx,%eax
801023ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023cd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023d1:	7e 15                	jle    801023e8 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023d3:	83 ec 04             	sub    $0x4,%esp
801023d6:	6a 0e                	push   $0xe
801023d8:	ff 75 f4             	push   -0xc(%ebp)
801023db:	ff 75 0c             	push   0xc(%ebp)
801023de:	e8 de 34 00 00       	call   801058c1 <memmove>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	eb 26                	jmp    8010240e <skipelem+0x95>
  else {
    memmove(name, s, len);
801023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023eb:	83 ec 04             	sub    $0x4,%esp
801023ee:	50                   	push   %eax
801023ef:	ff 75 f4             	push   -0xc(%ebp)
801023f2:	ff 75 0c             	push   0xc(%ebp)
801023f5:	e8 c7 34 00 00       	call   801058c1 <memmove>
801023fa:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102400:	8b 45 0c             	mov    0xc(%ebp),%eax
80102403:	01 d0                	add    %edx,%eax
80102405:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102408:	eb 04                	jmp    8010240e <skipelem+0x95>
    path++;
8010240a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b6 00             	movzbl (%eax),%eax
80102414:	3c 2f                	cmp    $0x2f,%al
80102416:	74 f2                	je     8010240a <skipelem+0x91>
  return path;
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010241b:	c9                   	leave  
8010241c:	c3                   	ret    

8010241d <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010241d:	55                   	push   %ebp
8010241e:	89 e5                	mov    %esp,%ebp
80102420:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102423:	8b 45 08             	mov    0x8(%ebp),%eax
80102426:	0f b6 00             	movzbl (%eax),%eax
80102429:	3c 2f                	cmp    $0x2f,%al
8010242b:	75 17                	jne    80102444 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010242d:	83 ec 08             	sub    $0x8,%esp
80102430:	6a 01                	push   $0x1
80102432:	6a 01                	push   $0x1
80102434:	e8 ac f4 ff ff       	call   801018e5 <iget>
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010243f:	e9 ba 00 00 00       	jmp    801024fe <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102444:	e8 30 1e 00 00       	call   80104279 <myproc>
80102449:	8b 40 68             	mov    0x68(%eax),%eax
8010244c:	83 ec 0c             	sub    $0xc,%esp
8010244f:	50                   	push   %eax
80102450:	e8 72 f5 ff ff       	call   801019c7 <idup>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010245b:	e9 9e 00 00 00       	jmp    801024fe <namex+0xe1>
    ilock(ip);
80102460:	83 ec 0c             	sub    $0xc,%esp
80102463:	ff 75 f4             	push   -0xc(%ebp)
80102466:	e8 96 f5 ff ff       	call   80101a01 <ilock>
8010246b:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102471:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102475:	66 83 f8 01          	cmp    $0x1,%ax
80102479:	74 18                	je     80102493 <namex+0x76>
      iunlockput(ip);
8010247b:	83 ec 0c             	sub    $0xc,%esp
8010247e:	ff 75 f4             	push   -0xc(%ebp)
80102481:	e8 ac f7 ff ff       	call   80101c32 <iunlockput>
80102486:	83 c4 10             	add    $0x10,%esp
      return 0;
80102489:	b8 00 00 00 00       	mov    $0x0,%eax
8010248e:	e9 a7 00 00 00       	jmp    8010253a <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
80102493:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102497:	74 20                	je     801024b9 <namex+0x9c>
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
8010249c:	0f b6 00             	movzbl (%eax),%eax
8010249f:	84 c0                	test   %al,%al
801024a1:	75 16                	jne    801024b9 <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
801024a3:	83 ec 0c             	sub    $0xc,%esp
801024a6:	ff 75 f4             	push   -0xc(%ebp)
801024a9:	e8 66 f6 ff ff       	call   80101b14 <iunlock>
801024ae:	83 c4 10             	add    $0x10,%esp
      return ip;
801024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024b4:	e9 81 00 00 00       	jmp    8010253a <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024b9:	83 ec 04             	sub    $0x4,%esp
801024bc:	6a 00                	push   $0x0
801024be:	ff 75 10             	push   0x10(%ebp)
801024c1:	ff 75 f4             	push   -0xc(%ebp)
801024c4:	e8 1e fd ff ff       	call   801021e7 <dirlookup>
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024d3:	75 15                	jne    801024ea <namex+0xcd>
      iunlockput(ip);
801024d5:	83 ec 0c             	sub    $0xc,%esp
801024d8:	ff 75 f4             	push   -0xc(%ebp)
801024db:	e8 52 f7 ff ff       	call   80101c32 <iunlockput>
801024e0:	83 c4 10             	add    $0x10,%esp
      return 0;
801024e3:	b8 00 00 00 00       	mov    $0x0,%eax
801024e8:	eb 50                	jmp    8010253a <namex+0x11d>
    }
    iunlockput(ip);
801024ea:	83 ec 0c             	sub    $0xc,%esp
801024ed:	ff 75 f4             	push   -0xc(%ebp)
801024f0:	e8 3d f7 ff ff       	call   80101c32 <iunlockput>
801024f5:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024fe:	83 ec 08             	sub    $0x8,%esp
80102501:	ff 75 10             	push   0x10(%ebp)
80102504:	ff 75 08             	push   0x8(%ebp)
80102507:	e8 6d fe ff ff       	call   80102379 <skipelem>
8010250c:	83 c4 10             	add    $0x10,%esp
8010250f:	89 45 08             	mov    %eax,0x8(%ebp)
80102512:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102516:	0f 85 44 ff ff ff    	jne    80102460 <namex+0x43>
  }
  if(nameiparent){
8010251c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102520:	74 15                	je     80102537 <namex+0x11a>
    iput(ip);
80102522:	83 ec 0c             	sub    $0xc,%esp
80102525:	ff 75 f4             	push   -0xc(%ebp)
80102528:	e8 35 f6 ff ff       	call   80101b62 <iput>
8010252d:	83 c4 10             	add    $0x10,%esp
    return 0;
80102530:	b8 00 00 00 00       	mov    $0x0,%eax
80102535:	eb 03                	jmp    8010253a <namex+0x11d>
  }
  return ip;
80102537:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010253a:	c9                   	leave  
8010253b:	c3                   	ret    

8010253c <namei>:

struct inode*
namei(char *path)
{
8010253c:	55                   	push   %ebp
8010253d:	89 e5                	mov    %esp,%ebp
8010253f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102542:	83 ec 04             	sub    $0x4,%esp
80102545:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102548:	50                   	push   %eax
80102549:	6a 00                	push   $0x0
8010254b:	ff 75 08             	push   0x8(%ebp)
8010254e:	e8 ca fe ff ff       	call   8010241d <namex>
80102553:	83 c4 10             	add    $0x10,%esp
}
80102556:	c9                   	leave  
80102557:	c3                   	ret    

80102558 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010255e:	83 ec 04             	sub    $0x4,%esp
80102561:	ff 75 0c             	push   0xc(%ebp)
80102564:	6a 01                	push   $0x1
80102566:	ff 75 08             	push   0x8(%ebp)
80102569:	e8 af fe ff ff       	call   8010241d <namex>
8010256e:	83 c4 10             	add    $0x10,%esp
}
80102571:	c9                   	leave  
80102572:	c3                   	ret    

80102573 <inb>:
{
80102573:	55                   	push   %ebp
80102574:	89 e5                	mov    %esp,%ebp
80102576:	83 ec 14             	sub    $0x14,%esp
80102579:	8b 45 08             	mov    0x8(%ebp),%eax
8010257c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102580:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102584:	89 c2                	mov    %eax,%edx
80102586:	ec                   	in     (%dx),%al
80102587:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010258a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010258e:	c9                   	leave  
8010258f:	c3                   	ret    

80102590 <insl>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102595:	8b 55 08             	mov    0x8(%ebp),%edx
80102598:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010259b:	8b 45 10             	mov    0x10(%ebp),%eax
8010259e:	89 cb                	mov    %ecx,%ebx
801025a0:	89 df                	mov    %ebx,%edi
801025a2:	89 c1                	mov    %eax,%ecx
801025a4:	fc                   	cld    
801025a5:	f3 6d                	rep insl (%dx),%es:(%edi)
801025a7:	89 c8                	mov    %ecx,%eax
801025a9:	89 fb                	mov    %edi,%ebx
801025ab:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025ae:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025b1:	90                   	nop
801025b2:	5b                   	pop    %ebx
801025b3:	5f                   	pop    %edi
801025b4:	5d                   	pop    %ebp
801025b5:	c3                   	ret    

801025b6 <outb>:
{
801025b6:	55                   	push   %ebp
801025b7:	89 e5                	mov    %esp,%ebp
801025b9:	83 ec 08             	sub    $0x8,%esp
801025bc:	8b 55 08             	mov    0x8(%ebp),%edx
801025bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801025c2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025c6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025cd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025d1:	ee                   	out    %al,(%dx)
}
801025d2:	90                   	nop
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    

801025d5 <outsl>:
{
801025d5:	55                   	push   %ebp
801025d6:	89 e5                	mov    %esp,%ebp
801025d8:	56                   	push   %esi
801025d9:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025da:	8b 55 08             	mov    0x8(%ebp),%edx
801025dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025e0:	8b 45 10             	mov    0x10(%ebp),%eax
801025e3:	89 cb                	mov    %ecx,%ebx
801025e5:	89 de                	mov    %ebx,%esi
801025e7:	89 c1                	mov    %eax,%ecx
801025e9:	fc                   	cld    
801025ea:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ec:	89 c8                	mov    %ecx,%eax
801025ee:	89 f3                	mov    %esi,%ebx
801025f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025f3:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025f6:	90                   	nop
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret    

801025fb <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025fb:	55                   	push   %ebp
801025fc:	89 e5                	mov    %esp,%ebp
801025fe:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102601:	90                   	nop
80102602:	68 f7 01 00 00       	push   $0x1f7
80102607:	e8 67 ff ff ff       	call   80102573 <inb>
8010260c:	83 c4 04             	add    $0x4,%esp
8010260f:	0f b6 c0             	movzbl %al,%eax
80102612:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102615:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102618:	25 c0 00 00 00       	and    $0xc0,%eax
8010261d:	83 f8 40             	cmp    $0x40,%eax
80102620:	75 e0                	jne    80102602 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102622:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102626:	74 11                	je     80102639 <idewait+0x3e>
80102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262b:	83 e0 21             	and    $0x21,%eax
8010262e:	85 c0                	test   %eax,%eax
80102630:	74 07                	je     80102639 <idewait+0x3e>
    return -1;
80102632:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102637:	eb 05                	jmp    8010263e <idewait+0x43>
  return 0;
80102639:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010263e:	c9                   	leave  
8010263f:	c3                   	ret    

80102640 <ideinit>:

void
ideinit(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102646:	83 ec 08             	sub    $0x8,%esp
80102649:	68 7f 8d 10 80       	push   $0x80108d7f
8010264e:	68 20 c6 10 80       	push   $0x8010c620
80102653:	e8 01 2f 00 00       	call   80105559 <initlock>
80102658:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010265b:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80102660:	83 e8 01             	sub    $0x1,%eax
80102663:	83 ec 08             	sub    $0x8,%esp
80102666:	50                   	push   %eax
80102667:	6a 0e                	push   $0xe
80102669:	e8 a2 04 00 00       	call   80102b10 <ioapicenable>
8010266e:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102671:	83 ec 0c             	sub    $0xc,%esp
80102674:	6a 00                	push   $0x0
80102676:	e8 80 ff ff ff       	call   801025fb <idewait>
8010267b:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010267e:	83 ec 08             	sub    $0x8,%esp
80102681:	68 f0 00 00 00       	push   $0xf0
80102686:	68 f6 01 00 00       	push   $0x1f6
8010268b:	e8 26 ff ff ff       	call   801025b6 <outb>
80102690:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010269a:	eb 24                	jmp    801026c0 <ideinit+0x80>
    if(inb(0x1f7) != 0){
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	68 f7 01 00 00       	push   $0x1f7
801026a4:	e8 ca fe ff ff       	call   80102573 <inb>
801026a9:	83 c4 10             	add    $0x10,%esp
801026ac:	84 c0                	test   %al,%al
801026ae:	74 0c                	je     801026bc <ideinit+0x7c>
      havedisk1 = 1;
801026b0:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801026b7:	00 00 00 
      break;
801026ba:	eb 0d                	jmp    801026c9 <ideinit+0x89>
  for(i=0; i<1000; i++){
801026bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026c0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026c7:	7e d3                	jle    8010269c <ideinit+0x5c>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026c9:	83 ec 08             	sub    $0x8,%esp
801026cc:	68 e0 00 00 00       	push   $0xe0
801026d1:	68 f6 01 00 00       	push   $0x1f6
801026d6:	e8 db fe ff ff       	call   801025b6 <outb>
801026db:	83 c4 10             	add    $0x10,%esp
}
801026de:	90                   	nop
801026df:	c9                   	leave  
801026e0:	c3                   	ret    

801026e1 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026e1:	55                   	push   %ebp
801026e2:	89 e5                	mov    %esp,%ebp
801026e4:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026eb:	75 0d                	jne    801026fa <idestart+0x19>
    panic("idestart");
801026ed:	83 ec 0c             	sub    $0xc,%esp
801026f0:	68 83 8d 10 80       	push   $0x80108d83
801026f5:	e8 a2 de ff ff       	call   8010059c <panic>
  if(b->blockno >= FSSIZE)
801026fa:	8b 45 08             	mov    0x8(%ebp),%eax
801026fd:	8b 40 08             	mov    0x8(%eax),%eax
80102700:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102705:	76 0d                	jbe    80102714 <idestart+0x33>
    panic("incorrect blockno");
80102707:	83 ec 0c             	sub    $0xc,%esp
8010270a:	68 8c 8d 10 80       	push   $0x80108d8c
8010270f:	e8 88 de ff ff       	call   8010059c <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102714:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010271b:	8b 45 08             	mov    0x8(%ebp),%eax
8010271e:	8b 50 08             	mov    0x8(%eax),%edx
80102721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102724:	0f af c2             	imul   %edx,%eax
80102727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010272a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010272e:	75 07                	jne    80102737 <idestart+0x56>
80102730:	b8 20 00 00 00       	mov    $0x20,%eax
80102735:	eb 05                	jmp    8010273c <idestart+0x5b>
80102737:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010273c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010273f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102743:	75 07                	jne    8010274c <idestart+0x6b>
80102745:	b8 30 00 00 00       	mov    $0x30,%eax
8010274a:	eb 05                	jmp    80102751 <idestart+0x70>
8010274c:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102751:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102754:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102758:	7e 0d                	jle    80102767 <idestart+0x86>
8010275a:	83 ec 0c             	sub    $0xc,%esp
8010275d:	68 83 8d 10 80       	push   $0x80108d83
80102762:	e8 35 de ff ff       	call   8010059c <panic>

  idewait(0);
80102767:	83 ec 0c             	sub    $0xc,%esp
8010276a:	6a 00                	push   $0x0
8010276c:	e8 8a fe ff ff       	call   801025fb <idewait>
80102771:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102774:	83 ec 08             	sub    $0x8,%esp
80102777:	6a 00                	push   $0x0
80102779:	68 f6 03 00 00       	push   $0x3f6
8010277e:	e8 33 fe ff ff       	call   801025b6 <outb>
80102783:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102789:	0f b6 c0             	movzbl %al,%eax
8010278c:	83 ec 08             	sub    $0x8,%esp
8010278f:	50                   	push   %eax
80102790:	68 f2 01 00 00       	push   $0x1f2
80102795:	e8 1c fe ff ff       	call   801025b6 <outb>
8010279a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a0:	0f b6 c0             	movzbl %al,%eax
801027a3:	83 ec 08             	sub    $0x8,%esp
801027a6:	50                   	push   %eax
801027a7:	68 f3 01 00 00       	push   $0x1f3
801027ac:	e8 05 fe ff ff       	call   801025b6 <outb>
801027b1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b7:	c1 f8 08             	sar    $0x8,%eax
801027ba:	0f b6 c0             	movzbl %al,%eax
801027bd:	83 ec 08             	sub    $0x8,%esp
801027c0:	50                   	push   %eax
801027c1:	68 f4 01 00 00       	push   $0x1f4
801027c6:	e8 eb fd ff ff       	call   801025b6 <outb>
801027cb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027d1:	c1 f8 10             	sar    $0x10,%eax
801027d4:	0f b6 c0             	movzbl %al,%eax
801027d7:	83 ec 08             	sub    $0x8,%esp
801027da:	50                   	push   %eax
801027db:	68 f5 01 00 00       	push   $0x1f5
801027e0:	e8 d1 fd ff ff       	call   801025b6 <outb>
801027e5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027e8:	8b 45 08             	mov    0x8(%ebp),%eax
801027eb:	8b 40 04             	mov    0x4(%eax),%eax
801027ee:	c1 e0 04             	shl    $0x4,%eax
801027f1:	83 e0 10             	and    $0x10,%eax
801027f4:	89 c2                	mov    %eax,%edx
801027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027f9:	c1 f8 18             	sar    $0x18,%eax
801027fc:	83 e0 0f             	and    $0xf,%eax
801027ff:	09 d0                	or     %edx,%eax
80102801:	83 c8 e0             	or     $0xffffffe0,%eax
80102804:	0f b6 c0             	movzbl %al,%eax
80102807:	83 ec 08             	sub    $0x8,%esp
8010280a:	50                   	push   %eax
8010280b:	68 f6 01 00 00       	push   $0x1f6
80102810:	e8 a1 fd ff ff       	call   801025b6 <outb>
80102815:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102818:	8b 45 08             	mov    0x8(%ebp),%eax
8010281b:	8b 00                	mov    (%eax),%eax
8010281d:	83 e0 04             	and    $0x4,%eax
80102820:	85 c0                	test   %eax,%eax
80102822:	74 35                	je     80102859 <idestart+0x178>
    outb(0x1f7, write_cmd);
80102824:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102827:	0f b6 c0             	movzbl %al,%eax
8010282a:	83 ec 08             	sub    $0x8,%esp
8010282d:	50                   	push   %eax
8010282e:	68 f7 01 00 00       	push   $0x1f7
80102833:	e8 7e fd ff ff       	call   801025b6 <outb>
80102838:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010283b:	8b 45 08             	mov    0x8(%ebp),%eax
8010283e:	83 c0 5c             	add    $0x5c,%eax
80102841:	83 ec 04             	sub    $0x4,%esp
80102844:	68 80 00 00 00       	push   $0x80
80102849:	50                   	push   %eax
8010284a:	68 f0 01 00 00       	push   $0x1f0
8010284f:	e8 81 fd ff ff       	call   801025d5 <outsl>
80102854:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102857:	eb 17                	jmp    80102870 <idestart+0x18f>
    outb(0x1f7, read_cmd);
80102859:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010285c:	0f b6 c0             	movzbl %al,%eax
8010285f:	83 ec 08             	sub    $0x8,%esp
80102862:	50                   	push   %eax
80102863:	68 f7 01 00 00       	push   $0x1f7
80102868:	e8 49 fd ff ff       	call   801025b6 <outb>
8010286d:	83 c4 10             	add    $0x10,%esp
}
80102870:	90                   	nop
80102871:	c9                   	leave  
80102872:	c3                   	ret    

80102873 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102873:	55                   	push   %ebp
80102874:	89 e5                	mov    %esp,%ebp
80102876:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102879:	83 ec 0c             	sub    $0xc,%esp
8010287c:	68 20 c6 10 80       	push   $0x8010c620
80102881:	e8 f5 2c 00 00       	call   8010557b <acquire>
80102886:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
80102889:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010288e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102895:	75 15                	jne    801028ac <ideintr+0x39>
    release(&idelock);
80102897:	83 ec 0c             	sub    $0xc,%esp
8010289a:	68 20 c6 10 80       	push   $0x8010c620
8010289f:	e8 45 2d 00 00       	call   801055e9 <release>
801028a4:	83 c4 10             	add    $0x10,%esp
    return;
801028a7:	e9 9a 00 00 00       	jmp    80102946 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028af:	8b 40 58             	mov    0x58(%eax),%eax
801028b2:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ba:	8b 00                	mov    (%eax),%eax
801028bc:	83 e0 04             	and    $0x4,%eax
801028bf:	85 c0                	test   %eax,%eax
801028c1:	75 2d                	jne    801028f0 <ideintr+0x7d>
801028c3:	83 ec 0c             	sub    $0xc,%esp
801028c6:	6a 01                	push   $0x1
801028c8:	e8 2e fd ff ff       	call   801025fb <idewait>
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	85 c0                	test   %eax,%eax
801028d2:	78 1c                	js     801028f0 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d7:	83 c0 5c             	add    $0x5c,%eax
801028da:	83 ec 04             	sub    $0x4,%esp
801028dd:	68 80 00 00 00       	push   $0x80
801028e2:	50                   	push   %eax
801028e3:	68 f0 01 00 00       	push   $0x1f0
801028e8:	e8 a3 fc ff ff       	call   80102590 <insl>
801028ed:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f3:	8b 00                	mov    (%eax),%eax
801028f5:	83 c8 02             	or     $0x2,%eax
801028f8:	89 c2                	mov    %eax,%edx
801028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fd:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102902:	8b 00                	mov    (%eax),%eax
80102904:	83 e0 fb             	and    $0xfffffffb,%eax
80102907:	89 c2                	mov    %eax,%edx
80102909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290c:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	ff 75 f4             	push   -0xc(%ebp)
80102914:	e8 c2 23 00 00       	call   80104cdb <wakeup>
80102919:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010291c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102921:	85 c0                	test   %eax,%eax
80102923:	74 11                	je     80102936 <ideintr+0xc3>
    idestart(idequeue);
80102925:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010292a:	83 ec 0c             	sub    $0xc,%esp
8010292d:	50                   	push   %eax
8010292e:	e8 ae fd ff ff       	call   801026e1 <idestart>
80102933:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102936:	83 ec 0c             	sub    $0xc,%esp
80102939:	68 20 c6 10 80       	push   $0x8010c620
8010293e:	e8 a6 2c 00 00       	call   801055e9 <release>
80102943:	83 c4 10             	add    $0x10,%esp
}
80102946:	c9                   	leave  
80102947:	c3                   	ret    

80102948 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102948:	55                   	push   %ebp
80102949:	89 e5                	mov    %esp,%ebp
8010294b:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010294e:	8b 45 08             	mov    0x8(%ebp),%eax
80102951:	83 c0 0c             	add    $0xc,%eax
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	50                   	push   %eax
80102958:	e8 67 2b 00 00       	call   801054c4 <holdingsleep>
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	85 c0                	test   %eax,%eax
80102962:	75 0d                	jne    80102971 <iderw+0x29>
    panic("iderw: buf not locked");
80102964:	83 ec 0c             	sub    $0xc,%esp
80102967:	68 9e 8d 10 80       	push   $0x80108d9e
8010296c:	e8 2b dc ff ff       	call   8010059c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102971:	8b 45 08             	mov    0x8(%ebp),%eax
80102974:	8b 00                	mov    (%eax),%eax
80102976:	83 e0 06             	and    $0x6,%eax
80102979:	83 f8 02             	cmp    $0x2,%eax
8010297c:	75 0d                	jne    8010298b <iderw+0x43>
    panic("iderw: nothing to do");
8010297e:	83 ec 0c             	sub    $0xc,%esp
80102981:	68 b4 8d 10 80       	push   $0x80108db4
80102986:	e8 11 dc ff ff       	call   8010059c <panic>
  if(b->dev != 0 && !havedisk1)
8010298b:	8b 45 08             	mov    0x8(%ebp),%eax
8010298e:	8b 40 04             	mov    0x4(%eax),%eax
80102991:	85 c0                	test   %eax,%eax
80102993:	74 16                	je     801029ab <iderw+0x63>
80102995:	a1 58 c6 10 80       	mov    0x8010c658,%eax
8010299a:	85 c0                	test   %eax,%eax
8010299c:	75 0d                	jne    801029ab <iderw+0x63>
    panic("iderw: ide disk 1 not present");
8010299e:	83 ec 0c             	sub    $0xc,%esp
801029a1:	68 c9 8d 10 80       	push   $0x80108dc9
801029a6:	e8 f1 db ff ff       	call   8010059c <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029ab:	83 ec 0c             	sub    $0xc,%esp
801029ae:	68 20 c6 10 80       	push   $0x8010c620
801029b3:	e8 c3 2b 00 00       	call   8010557b <acquire>
801029b8:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029bb:	8b 45 08             	mov    0x8(%ebp),%eax
801029be:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029c5:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801029cc:	eb 0b                	jmp    801029d9 <iderw+0x91>
801029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d1:	8b 00                	mov    (%eax),%eax
801029d3:	83 c0 58             	add    $0x58,%eax
801029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029dc:	8b 00                	mov    (%eax),%eax
801029de:	85 c0                	test   %eax,%eax
801029e0:	75 ec                	jne    801029ce <iderw+0x86>
    ;
  *pp = b;
801029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e5:	8b 55 08             	mov    0x8(%ebp),%edx
801029e8:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029ea:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801029ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801029f2:	75 23                	jne    80102a17 <iderw+0xcf>
    idestart(b);
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	ff 75 08             	push   0x8(%ebp)
801029fa:	e8 e2 fc ff ff       	call   801026e1 <idestart>
801029ff:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a02:	eb 13                	jmp    80102a17 <iderw+0xcf>
    sleep(b, &idelock);
80102a04:	83 ec 08             	sub    $0x8,%esp
80102a07:	68 20 c6 10 80       	push   $0x8010c620
80102a0c:	ff 75 08             	push   0x8(%ebp)
80102a0f:	e8 e1 21 00 00       	call   80104bf5 <sleep>
80102a14:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a17:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1a:	8b 00                	mov    (%eax),%eax
80102a1c:	83 e0 06             	and    $0x6,%eax
80102a1f:	83 f8 02             	cmp    $0x2,%eax
80102a22:	75 e0                	jne    80102a04 <iderw+0xbc>
  }


  release(&idelock);
80102a24:	83 ec 0c             	sub    $0xc,%esp
80102a27:	68 20 c6 10 80       	push   $0x8010c620
80102a2c:	e8 b8 2b 00 00       	call   801055e9 <release>
80102a31:	83 c4 10             	add    $0x10,%esp
}
80102a34:	90                   	nop
80102a35:	c9                   	leave  
80102a36:	c3                   	ret    

80102a37 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a37:	55                   	push   %ebp
80102a38:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a3a:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a3f:	8b 55 08             	mov    0x8(%ebp),%edx
80102a42:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a44:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a49:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a4c:	5d                   	pop    %ebp
80102a4d:	c3                   	ret    

80102a4e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a51:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a56:	8b 55 08             	mov    0x8(%ebp),%edx
80102a59:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a5b:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a60:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a63:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a66:	90                   	nop
80102a67:	5d                   	pop    %ebp
80102a68:	c3                   	ret    

80102a69 <ioapicinit>:

void
ioapicinit(void)
{
80102a69:	55                   	push   %ebp
80102a6a:	89 e5                	mov    %esp,%ebp
80102a6c:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a6f:	c7 05 f4 46 11 80 00 	movl   $0xfec00000,0x801146f4
80102a76:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a79:	6a 01                	push   $0x1
80102a7b:	e8 b7 ff ff ff       	call   80102a37 <ioapicread>
80102a80:	83 c4 04             	add    $0x4,%esp
80102a83:	c1 e8 10             	shr    $0x10,%eax
80102a86:	25 ff 00 00 00       	and    $0xff,%eax
80102a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a8e:	6a 00                	push   $0x0
80102a90:	e8 a2 ff ff ff       	call   80102a37 <ioapicread>
80102a95:	83 c4 04             	add    $0x4,%esp
80102a98:	c1 e8 18             	shr    $0x18,%eax
80102a9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a9e:	0f b6 05 20 48 11 80 	movzbl 0x80114820,%eax
80102aa5:	0f b6 c0             	movzbl %al,%eax
80102aa8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102aab:	74 10                	je     80102abd <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102aad:	83 ec 0c             	sub    $0xc,%esp
80102ab0:	68 e8 8d 10 80       	push   $0x80108de8
80102ab5:	e8 42 d9 ff ff       	call   801003fc <cprintf>
80102aba:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ac4:	eb 3f                	jmp    80102b05 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac9:	83 c0 20             	add    $0x20,%eax
80102acc:	0d 00 00 01 00       	or     $0x10000,%eax
80102ad1:	89 c2                	mov    %eax,%edx
80102ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad6:	83 c0 08             	add    $0x8,%eax
80102ad9:	01 c0                	add    %eax,%eax
80102adb:	83 ec 08             	sub    $0x8,%esp
80102ade:	52                   	push   %edx
80102adf:	50                   	push   %eax
80102ae0:	e8 69 ff ff ff       	call   80102a4e <ioapicwrite>
80102ae5:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aeb:	83 c0 08             	add    $0x8,%eax
80102aee:	01 c0                	add    %eax,%eax
80102af0:	83 c0 01             	add    $0x1,%eax
80102af3:	83 ec 08             	sub    $0x8,%esp
80102af6:	6a 00                	push   $0x0
80102af8:	50                   	push   %eax
80102af9:	e8 50 ff ff ff       	call   80102a4e <ioapicwrite>
80102afe:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b01:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b0b:	7e b9                	jle    80102ac6 <ioapicinit+0x5d>
  }
}
80102b0d:	90                   	nop
80102b0e:	c9                   	leave  
80102b0f:	c3                   	ret    

80102b10 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b13:	8b 45 08             	mov    0x8(%ebp),%eax
80102b16:	83 c0 20             	add    $0x20,%eax
80102b19:	89 c2                	mov    %eax,%edx
80102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1e:	83 c0 08             	add    $0x8,%eax
80102b21:	01 c0                	add    %eax,%eax
80102b23:	52                   	push   %edx
80102b24:	50                   	push   %eax
80102b25:	e8 24 ff ff ff       	call   80102a4e <ioapicwrite>
80102b2a:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b30:	c1 e0 18             	shl    $0x18,%eax
80102b33:	89 c2                	mov    %eax,%edx
80102b35:	8b 45 08             	mov    0x8(%ebp),%eax
80102b38:	83 c0 08             	add    $0x8,%eax
80102b3b:	01 c0                	add    %eax,%eax
80102b3d:	83 c0 01             	add    $0x1,%eax
80102b40:	52                   	push   %edx
80102b41:	50                   	push   %eax
80102b42:	e8 07 ff ff ff       	call   80102a4e <ioapicwrite>
80102b47:	83 c4 08             	add    $0x8,%esp
}
80102b4a:	90                   	nop
80102b4b:	c9                   	leave  
80102b4c:	c3                   	ret    

80102b4d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b4d:	55                   	push   %ebp
80102b4e:	89 e5                	mov    %esp,%ebp
80102b50:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b53:	83 ec 08             	sub    $0x8,%esp
80102b56:	68 1a 8e 10 80       	push   $0x80108e1a
80102b5b:	68 00 47 11 80       	push   $0x80114700
80102b60:	e8 f4 29 00 00       	call   80105559 <initlock>
80102b65:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b68:	c7 05 34 47 11 80 00 	movl   $0x0,0x80114734
80102b6f:	00 00 00 
  freerange(vstart, vend);
80102b72:	83 ec 08             	sub    $0x8,%esp
80102b75:	ff 75 0c             	push   0xc(%ebp)
80102b78:	ff 75 08             	push   0x8(%ebp)
80102b7b:	e8 2a 00 00 00       	call   80102baa <freerange>
80102b80:	83 c4 10             	add    $0x10,%esp
}
80102b83:	90                   	nop
80102b84:	c9                   	leave  
80102b85:	c3                   	ret    

80102b86 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b86:	55                   	push   %ebp
80102b87:	89 e5                	mov    %esp,%ebp
80102b89:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b8c:	83 ec 08             	sub    $0x8,%esp
80102b8f:	ff 75 0c             	push   0xc(%ebp)
80102b92:	ff 75 08             	push   0x8(%ebp)
80102b95:	e8 10 00 00 00       	call   80102baa <freerange>
80102b9a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b9d:	c7 05 34 47 11 80 01 	movl   $0x1,0x80114734
80102ba4:	00 00 00 
}
80102ba7:	90                   	nop
80102ba8:	c9                   	leave  
80102ba9:	c3                   	ret    

80102baa <freerange>:

void
freerange(void *vstart, void *vend)
{
80102baa:	55                   	push   %ebp
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb3:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc0:	eb 15                	jmp    80102bd7 <freerange+0x2d>
    kfree(p);
80102bc2:	83 ec 0c             	sub    $0xc,%esp
80102bc5:	ff 75 f4             	push   -0xc(%ebp)
80102bc8:	e8 1a 00 00 00       	call   80102be7 <kfree>
80102bcd:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bda:	05 00 10 00 00       	add    $0x1000,%eax
80102bdf:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102be2:	73 de                	jae    80102bc2 <freerange+0x18>
}
80102be4:	90                   	nop
80102be5:	c9                   	leave  
80102be6:	c3                   	ret    

80102be7 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102be7:	55                   	push   %ebp
80102be8:	89 e5                	mov    %esp,%ebp
80102bea:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bed:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf0:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	75 18                	jne    80102c11 <kfree+0x2a>
80102bf9:	81 7d 08 d8 76 11 80 	cmpl   $0x801176d8,0x8(%ebp)
80102c00:	72 0f                	jb     80102c11 <kfree+0x2a>
80102c02:	8b 45 08             	mov    0x8(%ebp),%eax
80102c05:	05 00 00 00 80       	add    $0x80000000,%eax
80102c0a:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c0f:	76 0d                	jbe    80102c1e <kfree+0x37>
    panic("kfree");
80102c11:	83 ec 0c             	sub    $0xc,%esp
80102c14:	68 1f 8e 10 80       	push   $0x80108e1f
80102c19:	e8 7e d9 ff ff       	call   8010059c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c1e:	83 ec 04             	sub    $0x4,%esp
80102c21:	68 00 10 00 00       	push   $0x1000
80102c26:	6a 01                	push   $0x1
80102c28:	ff 75 08             	push   0x8(%ebp)
80102c2b:	e8 d2 2b 00 00       	call   80105802 <memset>
80102c30:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c33:	a1 34 47 11 80       	mov    0x80114734,%eax
80102c38:	85 c0                	test   %eax,%eax
80102c3a:	74 10                	je     80102c4c <kfree+0x65>
    acquire(&kmem.lock);
80102c3c:	83 ec 0c             	sub    $0xc,%esp
80102c3f:	68 00 47 11 80       	push   $0x80114700
80102c44:	e8 32 29 00 00       	call   8010557b <acquire>
80102c49:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c52:	8b 15 38 47 11 80    	mov    0x80114738,%edx
80102c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5b:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c60:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102c65:	a1 34 47 11 80       	mov    0x80114734,%eax
80102c6a:	85 c0                	test   %eax,%eax
80102c6c:	74 10                	je     80102c7e <kfree+0x97>
    release(&kmem.lock);
80102c6e:	83 ec 0c             	sub    $0xc,%esp
80102c71:	68 00 47 11 80       	push   $0x80114700
80102c76:	e8 6e 29 00 00       	call   801055e9 <release>
80102c7b:	83 c4 10             	add    $0x10,%esp
}
80102c7e:	90                   	nop
80102c7f:	c9                   	leave  
80102c80:	c3                   	ret    

80102c81 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c81:	55                   	push   %ebp
80102c82:	89 e5                	mov    %esp,%ebp
80102c84:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c87:	a1 34 47 11 80       	mov    0x80114734,%eax
80102c8c:	85 c0                	test   %eax,%eax
80102c8e:	74 10                	je     80102ca0 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c90:	83 ec 0c             	sub    $0xc,%esp
80102c93:	68 00 47 11 80       	push   $0x80114700
80102c98:	e8 de 28 00 00       	call   8010557b <acquire>
80102c9d:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102ca0:	a1 38 47 11 80       	mov    0x80114738,%eax
80102ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cac:	74 0a                	je     80102cb8 <kalloc+0x37>
    kmem.freelist = r->next;
80102cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb1:	8b 00                	mov    (%eax),%eax
80102cb3:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102cb8:	a1 34 47 11 80       	mov    0x80114734,%eax
80102cbd:	85 c0                	test   %eax,%eax
80102cbf:	74 10                	je     80102cd1 <kalloc+0x50>
    release(&kmem.lock);
80102cc1:	83 ec 0c             	sub    $0xc,%esp
80102cc4:	68 00 47 11 80       	push   $0x80114700
80102cc9:	e8 1b 29 00 00       	call   801055e9 <release>
80102cce:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102cd4:	c9                   	leave  
80102cd5:	c3                   	ret    

80102cd6 <inb>:
{
80102cd6:	55                   	push   %ebp
80102cd7:	89 e5                	mov    %esp,%ebp
80102cd9:	83 ec 14             	sub    $0x14,%esp
80102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80102cdf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ce7:	89 c2                	mov    %eax,%edx
80102ce9:	ec                   	in     (%dx),%al
80102cea:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ced:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cf1:	c9                   	leave  
80102cf2:	c3                   	ret    

80102cf3 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cf3:	55                   	push   %ebp
80102cf4:	89 e5                	mov    %esp,%ebp
80102cf6:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cf9:	6a 64                	push   $0x64
80102cfb:	e8 d6 ff ff ff       	call   80102cd6 <inb>
80102d00:	83 c4 04             	add    $0x4,%esp
80102d03:	0f b6 c0             	movzbl %al,%eax
80102d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d0c:	83 e0 01             	and    $0x1,%eax
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	75 0a                	jne    80102d1d <kbdgetc+0x2a>
    return -1;
80102d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d18:	e9 23 01 00 00       	jmp    80102e40 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d1d:	6a 60                	push   $0x60
80102d1f:	e8 b2 ff ff ff       	call   80102cd6 <inb>
80102d24:	83 c4 04             	add    $0x4,%esp
80102d27:	0f b6 c0             	movzbl %al,%eax
80102d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d2d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d34:	75 17                	jne    80102d4d <kbdgetc+0x5a>
    shift |= E0ESC;
80102d36:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d3b:	83 c8 40             	or     $0x40,%eax
80102d3e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d43:	b8 00 00 00 00       	mov    $0x0,%eax
80102d48:	e9 f3 00 00 00       	jmp    80102e40 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d50:	25 80 00 00 00       	and    $0x80,%eax
80102d55:	85 c0                	test   %eax,%eax
80102d57:	74 45                	je     80102d9e <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d59:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d5e:	83 e0 40             	and    $0x40,%eax
80102d61:	85 c0                	test   %eax,%eax
80102d63:	75 08                	jne    80102d6d <kbdgetc+0x7a>
80102d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d68:	83 e0 7f             	and    $0x7f,%eax
80102d6b:	eb 03                	jmp    80102d70 <kbdgetc+0x7d>
80102d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d70:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d76:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d7b:	0f b6 00             	movzbl (%eax),%eax
80102d7e:	83 c8 40             	or     $0x40,%eax
80102d81:	0f b6 c0             	movzbl %al,%eax
80102d84:	f7 d0                	not    %eax
80102d86:	89 c2                	mov    %eax,%edx
80102d88:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d8d:	21 d0                	and    %edx,%eax
80102d8f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d94:	b8 00 00 00 00       	mov    $0x0,%eax
80102d99:	e9 a2 00 00 00       	jmp    80102e40 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d9e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102da3:	83 e0 40             	and    $0x40,%eax
80102da6:	85 c0                	test   %eax,%eax
80102da8:	74 14                	je     80102dbe <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102daa:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102db1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102db6:	83 e0 bf             	and    $0xffffffbf,%eax
80102db9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc1:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dc6:	0f b6 00             	movzbl (%eax),%eax
80102dc9:	0f b6 d0             	movzbl %al,%edx
80102dcc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dd1:	09 d0                	or     %edx,%eax
80102dd3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ddb:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102de0:	0f b6 00             	movzbl (%eax),%eax
80102de3:	0f b6 d0             	movzbl %al,%edx
80102de6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102deb:	31 d0                	xor    %edx,%eax
80102ded:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102df2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102df7:	83 e0 03             	and    $0x3,%eax
80102dfa:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e04:	01 d0                	add    %edx,%eax
80102e06:	0f b6 00             	movzbl (%eax),%eax
80102e09:	0f b6 c0             	movzbl %al,%eax
80102e0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e0f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e14:	83 e0 08             	and    $0x8,%eax
80102e17:	85 c0                	test   %eax,%eax
80102e19:	74 22                	je     80102e3d <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e1b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e1f:	76 0c                	jbe    80102e2d <kbdgetc+0x13a>
80102e21:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e25:	77 06                	ja     80102e2d <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e27:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e2b:	eb 10                	jmp    80102e3d <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e2d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e31:	76 0a                	jbe    80102e3d <kbdgetc+0x14a>
80102e33:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e37:	77 04                	ja     80102e3d <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e39:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e40:	c9                   	leave  
80102e41:	c3                   	ret    

80102e42 <kbdintr>:

void
kbdintr(void)
{
80102e42:	55                   	push   %ebp
80102e43:	89 e5                	mov    %esp,%ebp
80102e45:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	68 f3 2c 10 80       	push   $0x80102cf3
80102e50:	e8 db d9 ff ff       	call   80100830 <consoleintr>
80102e55:	83 c4 10             	add    $0x10,%esp
}
80102e58:	90                   	nop
80102e59:	c9                   	leave  
80102e5a:	c3                   	ret    

80102e5b <inb>:
{
80102e5b:	55                   	push   %ebp
80102e5c:	89 e5                	mov    %esp,%ebp
80102e5e:	83 ec 14             	sub    $0x14,%esp
80102e61:	8b 45 08             	mov    0x8(%ebp),%eax
80102e64:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e68:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	ec                   	in     (%dx),%al
80102e6f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e72:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e76:	c9                   	leave  
80102e77:	c3                   	ret    

80102e78 <outb>:
{
80102e78:	55                   	push   %ebp
80102e79:	89 e5                	mov    %esp,%ebp
80102e7b:	83 ec 08             	sub    $0x8,%esp
80102e7e:	8b 55 08             	mov    0x8(%ebp),%edx
80102e81:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e84:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e88:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e8b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e8f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e93:	ee                   	out    %al,(%dx)
}
80102e94:	90                   	nop
80102e95:	c9                   	leave  
80102e96:	c3                   	ret    

80102e97 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102e97:	55                   	push   %ebp
80102e98:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e9a:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102e9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102ea2:	c1 e2 02             	shl    $0x2,%edx
80102ea5:	01 c2                	add    %eax,%edx
80102ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eaa:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102eac:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102eb1:	83 c0 20             	add    $0x20,%eax
80102eb4:	8b 00                	mov    (%eax),%eax
}
80102eb6:	90                   	nop
80102eb7:	5d                   	pop    %ebp
80102eb8:	c3                   	ret    

80102eb9 <lapicinit>:

void
lapicinit(void)
{
80102eb9:	55                   	push   %ebp
80102eba:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ebc:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102ec1:	85 c0                	test   %eax,%eax
80102ec3:	0f 84 0b 01 00 00    	je     80102fd4 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ec9:	68 3f 01 00 00       	push   $0x13f
80102ece:	6a 3c                	push   $0x3c
80102ed0:	e8 c2 ff ff ff       	call   80102e97 <lapicw>
80102ed5:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ed8:	6a 0b                	push   $0xb
80102eda:	68 f8 00 00 00       	push   $0xf8
80102edf:	e8 b3 ff ff ff       	call   80102e97 <lapicw>
80102ee4:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102ee7:	68 20 00 02 00       	push   $0x20020
80102eec:	68 c8 00 00 00       	push   $0xc8
80102ef1:	e8 a1 ff ff ff       	call   80102e97 <lapicw>
80102ef6:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102ef9:	68 80 96 98 00       	push   $0x989680
80102efe:	68 e0 00 00 00       	push   $0xe0
80102f03:	e8 8f ff ff ff       	call   80102e97 <lapicw>
80102f08:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f0b:	68 00 00 01 00       	push   $0x10000
80102f10:	68 d4 00 00 00       	push   $0xd4
80102f15:	e8 7d ff ff ff       	call   80102e97 <lapicw>
80102f1a:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f1d:	68 00 00 01 00       	push   $0x10000
80102f22:	68 d8 00 00 00       	push   $0xd8
80102f27:	e8 6b ff ff ff       	call   80102e97 <lapicw>
80102f2c:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f2f:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102f34:	83 c0 30             	add    $0x30,%eax
80102f37:	8b 00                	mov    (%eax),%eax
80102f39:	c1 e8 10             	shr    $0x10,%eax
80102f3c:	0f b6 c0             	movzbl %al,%eax
80102f3f:	83 f8 03             	cmp    $0x3,%eax
80102f42:	76 12                	jbe    80102f56 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f44:	68 00 00 01 00       	push   $0x10000
80102f49:	68 d0 00 00 00       	push   $0xd0
80102f4e:	e8 44 ff ff ff       	call   80102e97 <lapicw>
80102f53:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f56:	6a 33                	push   $0x33
80102f58:	68 dc 00 00 00       	push   $0xdc
80102f5d:	e8 35 ff ff ff       	call   80102e97 <lapicw>
80102f62:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f65:	6a 00                	push   $0x0
80102f67:	68 a0 00 00 00       	push   $0xa0
80102f6c:	e8 26 ff ff ff       	call   80102e97 <lapicw>
80102f71:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f74:	6a 00                	push   $0x0
80102f76:	68 a0 00 00 00       	push   $0xa0
80102f7b:	e8 17 ff ff ff       	call   80102e97 <lapicw>
80102f80:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f83:	6a 00                	push   $0x0
80102f85:	6a 2c                	push   $0x2c
80102f87:	e8 0b ff ff ff       	call   80102e97 <lapicw>
80102f8c:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f8f:	6a 00                	push   $0x0
80102f91:	68 c4 00 00 00       	push   $0xc4
80102f96:	e8 fc fe ff ff       	call   80102e97 <lapicw>
80102f9b:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f9e:	68 00 85 08 00       	push   $0x88500
80102fa3:	68 c0 00 00 00       	push   $0xc0
80102fa8:	e8 ea fe ff ff       	call   80102e97 <lapicw>
80102fad:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fb0:	90                   	nop
80102fb1:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102fb6:	05 00 03 00 00       	add    $0x300,%eax
80102fbb:	8b 00                	mov    (%eax),%eax
80102fbd:	25 00 10 00 00       	and    $0x1000,%eax
80102fc2:	85 c0                	test   %eax,%eax
80102fc4:	75 eb                	jne    80102fb1 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fc6:	6a 00                	push   $0x0
80102fc8:	6a 20                	push   $0x20
80102fca:	e8 c8 fe ff ff       	call   80102e97 <lapicw>
80102fcf:	83 c4 08             	add    $0x8,%esp
80102fd2:	eb 01                	jmp    80102fd5 <lapicinit+0x11c>
    return;
80102fd4:	90                   	nop
}
80102fd5:	c9                   	leave  
80102fd6:	c3                   	ret    

80102fd7 <lapicid>:

int
lapicid(void)
{
80102fd7:	55                   	push   %ebp
80102fd8:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fda:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102fdf:	85 c0                	test   %eax,%eax
80102fe1:	75 07                	jne    80102fea <lapicid+0x13>
    return 0;
80102fe3:	b8 00 00 00 00       	mov    $0x0,%eax
80102fe8:	eb 0d                	jmp    80102ff7 <lapicid+0x20>
  return lapic[ID] >> 24;
80102fea:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102fef:	83 c0 20             	add    $0x20,%eax
80102ff2:	8b 00                	mov    (%eax),%eax
80102ff4:	c1 e8 18             	shr    $0x18,%eax
}
80102ff7:	5d                   	pop    %ebp
80102ff8:	c3                   	ret    

80102ff9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ff9:	55                   	push   %ebp
80102ffa:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ffc:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103001:	85 c0                	test   %eax,%eax
80103003:	74 0c                	je     80103011 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103005:	6a 00                	push   $0x0
80103007:	6a 2c                	push   $0x2c
80103009:	e8 89 fe ff ff       	call   80102e97 <lapicw>
8010300e:	83 c4 08             	add    $0x8,%esp
}
80103011:	90                   	nop
80103012:	c9                   	leave  
80103013:	c3                   	ret    

80103014 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
}
80103017:	90                   	nop
80103018:	5d                   	pop    %ebp
80103019:	c3                   	ret    

8010301a <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010301a:	55                   	push   %ebp
8010301b:	89 e5                	mov    %esp,%ebp
8010301d:	83 ec 14             	sub    $0x14,%esp
80103020:	8b 45 08             	mov    0x8(%ebp),%eax
80103023:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103026:	6a 0f                	push   $0xf
80103028:	6a 70                	push   $0x70
8010302a:	e8 49 fe ff ff       	call   80102e78 <outb>
8010302f:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103032:	6a 0a                	push   $0xa
80103034:	6a 71                	push   $0x71
80103036:	e8 3d fe ff ff       	call   80102e78 <outb>
8010303b:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010303e:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103045:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103048:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010304d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103050:	c1 e8 04             	shr    $0x4,%eax
80103053:	89 c2                	mov    %eax,%edx
80103055:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103058:	83 c0 02             	add    $0x2,%eax
8010305b:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010305e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103062:	c1 e0 18             	shl    $0x18,%eax
80103065:	50                   	push   %eax
80103066:	68 c4 00 00 00       	push   $0xc4
8010306b:	e8 27 fe ff ff       	call   80102e97 <lapicw>
80103070:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103073:	68 00 c5 00 00       	push   $0xc500
80103078:	68 c0 00 00 00       	push   $0xc0
8010307d:	e8 15 fe ff ff       	call   80102e97 <lapicw>
80103082:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103085:	68 c8 00 00 00       	push   $0xc8
8010308a:	e8 85 ff ff ff       	call   80103014 <microdelay>
8010308f:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103092:	68 00 85 00 00       	push   $0x8500
80103097:	68 c0 00 00 00       	push   $0xc0
8010309c:	e8 f6 fd ff ff       	call   80102e97 <lapicw>
801030a1:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030a4:	6a 64                	push   $0x64
801030a6:	e8 69 ff ff ff       	call   80103014 <microdelay>
801030ab:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030b5:	eb 3d                	jmp    801030f4 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
801030b7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030bb:	c1 e0 18             	shl    $0x18,%eax
801030be:	50                   	push   %eax
801030bf:	68 c4 00 00 00       	push   $0xc4
801030c4:	e8 ce fd ff ff       	call   80102e97 <lapicw>
801030c9:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801030cf:	c1 e8 0c             	shr    $0xc,%eax
801030d2:	80 cc 06             	or     $0x6,%ah
801030d5:	50                   	push   %eax
801030d6:	68 c0 00 00 00       	push   $0xc0
801030db:	e8 b7 fd ff ff       	call   80102e97 <lapicw>
801030e0:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030e3:	68 c8 00 00 00       	push   $0xc8
801030e8:	e8 27 ff ff ff       	call   80103014 <microdelay>
801030ed:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801030f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030f8:	7e bd                	jle    801030b7 <lapicstartap+0x9d>
  }
}
801030fa:	90                   	nop
801030fb:	c9                   	leave  
801030fc:	c3                   	ret    

801030fd <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
801030fd:	55                   	push   %ebp
801030fe:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103100:	8b 45 08             	mov    0x8(%ebp),%eax
80103103:	0f b6 c0             	movzbl %al,%eax
80103106:	50                   	push   %eax
80103107:	6a 70                	push   $0x70
80103109:	e8 6a fd ff ff       	call   80102e78 <outb>
8010310e:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103111:	68 c8 00 00 00       	push   $0xc8
80103116:	e8 f9 fe ff ff       	call   80103014 <microdelay>
8010311b:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010311e:	6a 71                	push   $0x71
80103120:	e8 36 fd ff ff       	call   80102e5b <inb>
80103125:	83 c4 04             	add    $0x4,%esp
80103128:	0f b6 c0             	movzbl %al,%eax
}
8010312b:	c9                   	leave  
8010312c:	c3                   	ret    

8010312d <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
8010312d:	55                   	push   %ebp
8010312e:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103130:	6a 00                	push   $0x0
80103132:	e8 c6 ff ff ff       	call   801030fd <cmos_read>
80103137:	83 c4 04             	add    $0x4,%esp
8010313a:	89 c2                	mov    %eax,%edx
8010313c:	8b 45 08             	mov    0x8(%ebp),%eax
8010313f:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103141:	6a 02                	push   $0x2
80103143:	e8 b5 ff ff ff       	call   801030fd <cmos_read>
80103148:	83 c4 04             	add    $0x4,%esp
8010314b:	89 c2                	mov    %eax,%edx
8010314d:	8b 45 08             	mov    0x8(%ebp),%eax
80103150:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103153:	6a 04                	push   $0x4
80103155:	e8 a3 ff ff ff       	call   801030fd <cmos_read>
8010315a:	83 c4 04             	add    $0x4,%esp
8010315d:	89 c2                	mov    %eax,%edx
8010315f:	8b 45 08             	mov    0x8(%ebp),%eax
80103162:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103165:	6a 07                	push   $0x7
80103167:	e8 91 ff ff ff       	call   801030fd <cmos_read>
8010316c:	83 c4 04             	add    $0x4,%esp
8010316f:	89 c2                	mov    %eax,%edx
80103171:	8b 45 08             	mov    0x8(%ebp),%eax
80103174:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103177:	6a 08                	push   $0x8
80103179:	e8 7f ff ff ff       	call   801030fd <cmos_read>
8010317e:	83 c4 04             	add    $0x4,%esp
80103181:	89 c2                	mov    %eax,%edx
80103183:	8b 45 08             	mov    0x8(%ebp),%eax
80103186:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103189:	6a 09                	push   $0x9
8010318b:	e8 6d ff ff ff       	call   801030fd <cmos_read>
80103190:	83 c4 04             	add    $0x4,%esp
80103193:	89 c2                	mov    %eax,%edx
80103195:	8b 45 08             	mov    0x8(%ebp),%eax
80103198:	89 50 14             	mov    %edx,0x14(%eax)
}
8010319b:	90                   	nop
8010319c:	c9                   	leave  
8010319d:	c3                   	ret    

8010319e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010319e:	55                   	push   %ebp
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031a4:	6a 0b                	push   $0xb
801031a6:	e8 52 ff ff ff       	call   801030fd <cmos_read>
801031ab:	83 c4 04             	add    $0x4,%esp
801031ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031b4:	83 e0 04             	and    $0x4,%eax
801031b7:	85 c0                	test   %eax,%eax
801031b9:	0f 94 c0             	sete   %al
801031bc:	0f b6 c0             	movzbl %al,%eax
801031bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031c2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031c5:	50                   	push   %eax
801031c6:	e8 62 ff ff ff       	call   8010312d <fill_rtcdate>
801031cb:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031ce:	6a 0a                	push   $0xa
801031d0:	e8 28 ff ff ff       	call   801030fd <cmos_read>
801031d5:	83 c4 04             	add    $0x4,%esp
801031d8:	25 80 00 00 00       	and    $0x80,%eax
801031dd:	85 c0                	test   %eax,%eax
801031df:	75 27                	jne    80103208 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031e1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e4:	50                   	push   %eax
801031e5:	e8 43 ff ff ff       	call   8010312d <fill_rtcdate>
801031ea:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031ed:	83 ec 04             	sub    $0x4,%esp
801031f0:	6a 18                	push   $0x18
801031f2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f5:	50                   	push   %eax
801031f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031f9:	50                   	push   %eax
801031fa:	e8 6a 26 00 00       	call   80105869 <memcmp>
801031ff:	83 c4 10             	add    $0x10,%esp
80103202:	85 c0                	test   %eax,%eax
80103204:	74 05                	je     8010320b <cmostime+0x6d>
80103206:	eb ba                	jmp    801031c2 <cmostime+0x24>
        continue;
80103208:	90                   	nop
    fill_rtcdate(&t1);
80103209:	eb b7                	jmp    801031c2 <cmostime+0x24>
      break;
8010320b:	90                   	nop
  }

  // convert
  if(bcd) {
8010320c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103210:	0f 84 b4 00 00 00    	je     801032ca <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103216:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103219:	c1 e8 04             	shr    $0x4,%eax
8010321c:	89 c2                	mov    %eax,%edx
8010321e:	89 d0                	mov    %edx,%eax
80103220:	c1 e0 02             	shl    $0x2,%eax
80103223:	01 d0                	add    %edx,%eax
80103225:	01 c0                	add    %eax,%eax
80103227:	89 c2                	mov    %eax,%edx
80103229:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010322c:	83 e0 0f             	and    $0xf,%eax
8010322f:	01 d0                	add    %edx,%eax
80103231:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103234:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103237:	c1 e8 04             	shr    $0x4,%eax
8010323a:	89 c2                	mov    %eax,%edx
8010323c:	89 d0                	mov    %edx,%eax
8010323e:	c1 e0 02             	shl    $0x2,%eax
80103241:	01 d0                	add    %edx,%eax
80103243:	01 c0                	add    %eax,%eax
80103245:	89 c2                	mov    %eax,%edx
80103247:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010324a:	83 e0 0f             	and    $0xf,%eax
8010324d:	01 d0                	add    %edx,%eax
8010324f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103252:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103255:	c1 e8 04             	shr    $0x4,%eax
80103258:	89 c2                	mov    %eax,%edx
8010325a:	89 d0                	mov    %edx,%eax
8010325c:	c1 e0 02             	shl    $0x2,%eax
8010325f:	01 d0                	add    %edx,%eax
80103261:	01 c0                	add    %eax,%eax
80103263:	89 c2                	mov    %eax,%edx
80103265:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103268:	83 e0 0f             	and    $0xf,%eax
8010326b:	01 d0                	add    %edx,%eax
8010326d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103273:	c1 e8 04             	shr    $0x4,%eax
80103276:	89 c2                	mov    %eax,%edx
80103278:	89 d0                	mov    %edx,%eax
8010327a:	c1 e0 02             	shl    $0x2,%eax
8010327d:	01 d0                	add    %edx,%eax
8010327f:	01 c0                	add    %eax,%eax
80103281:	89 c2                	mov    %eax,%edx
80103283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103286:	83 e0 0f             	and    $0xf,%eax
80103289:	01 d0                	add    %edx,%eax
8010328b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103291:	c1 e8 04             	shr    $0x4,%eax
80103294:	89 c2                	mov    %eax,%edx
80103296:	89 d0                	mov    %edx,%eax
80103298:	c1 e0 02             	shl    $0x2,%eax
8010329b:	01 d0                	add    %edx,%eax
8010329d:	01 c0                	add    %eax,%eax
8010329f:	89 c2                	mov    %eax,%edx
801032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a4:	83 e0 0f             	and    $0xf,%eax
801032a7:	01 d0                	add    %edx,%eax
801032a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032af:	c1 e8 04             	shr    $0x4,%eax
801032b2:	89 c2                	mov    %eax,%edx
801032b4:	89 d0                	mov    %edx,%eax
801032b6:	c1 e0 02             	shl    $0x2,%eax
801032b9:	01 d0                	add    %edx,%eax
801032bb:	01 c0                	add    %eax,%eax
801032bd:	89 c2                	mov    %eax,%edx
801032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c2:	83 e0 0f             	and    $0xf,%eax
801032c5:	01 d0                	add    %edx,%eax
801032c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032ca:	8b 45 08             	mov    0x8(%ebp),%eax
801032cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032d0:	89 10                	mov    %edx,(%eax)
801032d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032d5:	89 50 04             	mov    %edx,0x4(%eax)
801032d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032db:	89 50 08             	mov    %edx,0x8(%eax)
801032de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032e1:	89 50 0c             	mov    %edx,0xc(%eax)
801032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032e7:	89 50 10             	mov    %edx,0x10(%eax)
801032ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032ed:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032f0:	8b 45 08             	mov    0x8(%ebp),%eax
801032f3:	8b 40 14             	mov    0x14(%eax),%eax
801032f6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032fc:	8b 45 08             	mov    0x8(%ebp),%eax
801032ff:	89 50 14             	mov    %edx,0x14(%eax)
}
80103302:	90                   	nop
80103303:	c9                   	leave  
80103304:	c3                   	ret    

80103305 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103305:	55                   	push   %ebp
80103306:	89 e5                	mov    %esp,%ebp
80103308:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010330b:	83 ec 08             	sub    $0x8,%esp
8010330e:	68 25 8e 10 80       	push   $0x80108e25
80103313:	68 40 47 11 80       	push   $0x80114740
80103318:	e8 3c 22 00 00       	call   80105559 <initlock>
8010331d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103320:	83 ec 08             	sub    $0x8,%esp
80103323:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103326:	50                   	push   %eax
80103327:	ff 75 08             	push   0x8(%ebp)
8010332a:	e8 b9 e0 ff ff       	call   801013e8 <readsb>
8010332f:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103332:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103335:	a3 74 47 11 80       	mov    %eax,0x80114774
  log.size = sb.nlog;
8010333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010333d:	a3 78 47 11 80       	mov    %eax,0x80114778
  log.dev = dev;
80103342:	8b 45 08             	mov    0x8(%ebp),%eax
80103345:	a3 84 47 11 80       	mov    %eax,0x80114784
  recover_from_log();
8010334a:	e8 b2 01 00 00       	call   80103501 <recover_from_log>
}
8010334f:	90                   	nop
80103350:	c9                   	leave  
80103351:	c3                   	ret    

80103352 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103352:	55                   	push   %ebp
80103353:	89 e5                	mov    %esp,%ebp
80103355:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010335f:	e9 95 00 00 00       	jmp    801033f9 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103364:	8b 15 74 47 11 80    	mov    0x80114774,%edx
8010336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010336d:	01 d0                	add    %edx,%eax
8010336f:	83 c0 01             	add    $0x1,%eax
80103372:	89 c2                	mov    %eax,%edx
80103374:	a1 84 47 11 80       	mov    0x80114784,%eax
80103379:	83 ec 08             	sub    $0x8,%esp
8010337c:	52                   	push   %edx
8010337d:	50                   	push   %eax
8010337e:	e8 4b ce ff ff       	call   801001ce <bread>
80103383:	83 c4 10             	add    $0x10,%esp
80103386:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010338c:	83 c0 10             	add    $0x10,%eax
8010338f:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103396:	89 c2                	mov    %eax,%edx
80103398:	a1 84 47 11 80       	mov    0x80114784,%eax
8010339d:	83 ec 08             	sub    $0x8,%esp
801033a0:	52                   	push   %edx
801033a1:	50                   	push   %eax
801033a2:	e8 27 ce ff ff       	call   801001ce <bread>
801033a7:	83 c4 10             	add    $0x10,%esp
801033aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b0:	8d 50 5c             	lea    0x5c(%eax),%edx
801033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b6:	83 c0 5c             	add    $0x5c,%eax
801033b9:	83 ec 04             	sub    $0x4,%esp
801033bc:	68 00 02 00 00       	push   $0x200
801033c1:	52                   	push   %edx
801033c2:	50                   	push   %eax
801033c3:	e8 f9 24 00 00       	call   801058c1 <memmove>
801033c8:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	ff 75 ec             	push   -0x14(%ebp)
801033d1:	e8 31 ce ff ff       	call   80100207 <bwrite>
801033d6:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801033d9:	83 ec 0c             	sub    $0xc,%esp
801033dc:	ff 75 f0             	push   -0x10(%ebp)
801033df:	e8 6c ce ff ff       	call   80100250 <brelse>
801033e4:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033e7:	83 ec 0c             	sub    $0xc,%esp
801033ea:	ff 75 ec             	push   -0x14(%ebp)
801033ed:	e8 5e ce ff ff       	call   80100250 <brelse>
801033f2:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801033f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f9:	a1 88 47 11 80       	mov    0x80114788,%eax
801033fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103401:	0f 8c 5d ff ff ff    	jl     80103364 <install_trans+0x12>
  }
}
80103407:	90                   	nop
80103408:	c9                   	leave  
80103409:	c3                   	ret    

8010340a <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010340a:	55                   	push   %ebp
8010340b:	89 e5                	mov    %esp,%ebp
8010340d:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103410:	a1 74 47 11 80       	mov    0x80114774,%eax
80103415:	89 c2                	mov    %eax,%edx
80103417:	a1 84 47 11 80       	mov    0x80114784,%eax
8010341c:	83 ec 08             	sub    $0x8,%esp
8010341f:	52                   	push   %edx
80103420:	50                   	push   %eax
80103421:	e8 a8 cd ff ff       	call   801001ce <bread>
80103426:	83 c4 10             	add    $0x10,%esp
80103429:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010342f:	83 c0 5c             	add    $0x5c,%eax
80103432:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103435:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103438:	8b 00                	mov    (%eax),%eax
8010343a:	a3 88 47 11 80       	mov    %eax,0x80114788
  for (i = 0; i < log.lh.n; i++) {
8010343f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103446:	eb 1b                	jmp    80103463 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103448:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010344b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010344e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103452:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103455:	83 c2 10             	add    $0x10,%edx
80103458:	89 04 95 4c 47 11 80 	mov    %eax,-0x7feeb8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010345f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103463:	a1 88 47 11 80       	mov    0x80114788,%eax
80103468:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010346b:	7c db                	jl     80103448 <read_head+0x3e>
  }
  brelse(buf);
8010346d:	83 ec 0c             	sub    $0xc,%esp
80103470:	ff 75 f0             	push   -0x10(%ebp)
80103473:	e8 d8 cd ff ff       	call   80100250 <brelse>
80103478:	83 c4 10             	add    $0x10,%esp
}
8010347b:	90                   	nop
8010347c:	c9                   	leave  
8010347d:	c3                   	ret    

8010347e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010347e:	55                   	push   %ebp
8010347f:	89 e5                	mov    %esp,%ebp
80103481:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103484:	a1 74 47 11 80       	mov    0x80114774,%eax
80103489:	89 c2                	mov    %eax,%edx
8010348b:	a1 84 47 11 80       	mov    0x80114784,%eax
80103490:	83 ec 08             	sub    $0x8,%esp
80103493:	52                   	push   %edx
80103494:	50                   	push   %eax
80103495:	e8 34 cd ff ff       	call   801001ce <bread>
8010349a:	83 c4 10             	add    $0x10,%esp
8010349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a3:	83 c0 5c             	add    $0x5c,%eax
801034a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034a9:	8b 15 88 47 11 80    	mov    0x80114788,%edx
801034af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b2:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034bb:	eb 1b                	jmp    801034d8 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c0:	83 c0 10             	add    $0x10,%eax
801034c3:	8b 0c 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%ecx
801034ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034d8:	a1 88 47 11 80       	mov    0x80114788,%eax
801034dd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034e0:	7c db                	jl     801034bd <write_head+0x3f>
  }
  bwrite(buf);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	ff 75 f0             	push   -0x10(%ebp)
801034e8:	e8 1a cd ff ff       	call   80100207 <bwrite>
801034ed:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	ff 75 f0             	push   -0x10(%ebp)
801034f6:	e8 55 cd ff ff       	call   80100250 <brelse>
801034fb:	83 c4 10             	add    $0x10,%esp
}
801034fe:	90                   	nop
801034ff:	c9                   	leave  
80103500:	c3                   	ret    

80103501 <recover_from_log>:

static void
recover_from_log(void)
{
80103501:	55                   	push   %ebp
80103502:	89 e5                	mov    %esp,%ebp
80103504:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103507:	e8 fe fe ff ff       	call   8010340a <read_head>
  install_trans(); // if committed, copy from log to disk
8010350c:	e8 41 fe ff ff       	call   80103352 <install_trans>
  log.lh.n = 0;
80103511:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
80103518:	00 00 00 
  write_head(); // clear the log
8010351b:	e8 5e ff ff ff       	call   8010347e <write_head>
}
80103520:	90                   	nop
80103521:	c9                   	leave  
80103522:	c3                   	ret    

80103523 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103523:	55                   	push   %ebp
80103524:	89 e5                	mov    %esp,%ebp
80103526:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103529:	83 ec 0c             	sub    $0xc,%esp
8010352c:	68 40 47 11 80       	push   $0x80114740
80103531:	e8 45 20 00 00       	call   8010557b <acquire>
80103536:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103539:	a1 80 47 11 80       	mov    0x80114780,%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	74 17                	je     80103559 <begin_op+0x36>
      sleep(&log, &log.lock);
80103542:	83 ec 08             	sub    $0x8,%esp
80103545:	68 40 47 11 80       	push   $0x80114740
8010354a:	68 40 47 11 80       	push   $0x80114740
8010354f:	e8 a1 16 00 00       	call   80104bf5 <sleep>
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	eb e0                	jmp    80103539 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103559:	8b 0d 88 47 11 80    	mov    0x80114788,%ecx
8010355f:	a1 7c 47 11 80       	mov    0x8011477c,%eax
80103564:	8d 50 01             	lea    0x1(%eax),%edx
80103567:	89 d0                	mov    %edx,%eax
80103569:	c1 e0 02             	shl    $0x2,%eax
8010356c:	01 d0                	add    %edx,%eax
8010356e:	01 c0                	add    %eax,%eax
80103570:	01 c8                	add    %ecx,%eax
80103572:	83 f8 1e             	cmp    $0x1e,%eax
80103575:	7e 17                	jle    8010358e <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103577:	83 ec 08             	sub    $0x8,%esp
8010357a:	68 40 47 11 80       	push   $0x80114740
8010357f:	68 40 47 11 80       	push   $0x80114740
80103584:	e8 6c 16 00 00       	call   80104bf5 <sleep>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb ab                	jmp    80103539 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010358e:	a1 7c 47 11 80       	mov    0x8011477c,%eax
80103593:	83 c0 01             	add    $0x1,%eax
80103596:	a3 7c 47 11 80       	mov    %eax,0x8011477c
      release(&log.lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	68 40 47 11 80       	push   $0x80114740
801035a3:	e8 41 20 00 00       	call   801055e9 <release>
801035a8:	83 c4 10             	add    $0x10,%esp
      break;
801035ab:	90                   	nop
    }
  }
}
801035ac:	90                   	nop
801035ad:	c9                   	leave  
801035ae:	c3                   	ret    

801035af <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035af:	55                   	push   %ebp
801035b0:	89 e5                	mov    %esp,%ebp
801035b2:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035bc:	83 ec 0c             	sub    $0xc,%esp
801035bf:	68 40 47 11 80       	push   $0x80114740
801035c4:	e8 b2 1f 00 00       	call   8010557b <acquire>
801035c9:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035cc:	a1 7c 47 11 80       	mov    0x8011477c,%eax
801035d1:	83 e8 01             	sub    $0x1,%eax
801035d4:	a3 7c 47 11 80       	mov    %eax,0x8011477c
  if(log.committing)
801035d9:	a1 80 47 11 80       	mov    0x80114780,%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 0d                	je     801035ef <end_op+0x40>
    panic("log.committing");
801035e2:	83 ec 0c             	sub    $0xc,%esp
801035e5:	68 29 8e 10 80       	push   $0x80108e29
801035ea:	e8 ad cf ff ff       	call   8010059c <panic>
  if(log.outstanding == 0){
801035ef:	a1 7c 47 11 80       	mov    0x8011477c,%eax
801035f4:	85 c0                	test   %eax,%eax
801035f6:	75 13                	jne    8010360b <end_op+0x5c>
    do_commit = 1;
801035f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035ff:	c7 05 80 47 11 80 01 	movl   $0x1,0x80114780
80103606:	00 00 00 
80103609:	eb 10                	jmp    8010361b <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	68 40 47 11 80       	push   $0x80114740
80103613:	e8 c3 16 00 00       	call   80104cdb <wakeup>
80103618:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010361b:	83 ec 0c             	sub    $0xc,%esp
8010361e:	68 40 47 11 80       	push   $0x80114740
80103623:	e8 c1 1f 00 00       	call   801055e9 <release>
80103628:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010362b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010362f:	74 3f                	je     80103670 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103631:	e8 f5 00 00 00       	call   8010372b <commit>
    acquire(&log.lock);
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	68 40 47 11 80       	push   $0x80114740
8010363e:	e8 38 1f 00 00       	call   8010557b <acquire>
80103643:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103646:	c7 05 80 47 11 80 00 	movl   $0x0,0x80114780
8010364d:	00 00 00 
    wakeup(&log);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 40 47 11 80       	push   $0x80114740
80103658:	e8 7e 16 00 00       	call   80104cdb <wakeup>
8010365d:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	68 40 47 11 80       	push   $0x80114740
80103668:	e8 7c 1f 00 00       	call   801055e9 <release>
8010366d:	83 c4 10             	add    $0x10,%esp
  }
}
80103670:	90                   	nop
80103671:	c9                   	leave  
80103672:	c3                   	ret    

80103673 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103673:	55                   	push   %ebp
80103674:	89 e5                	mov    %esp,%ebp
80103676:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103680:	e9 95 00 00 00       	jmp    8010371a <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103685:	8b 15 74 47 11 80    	mov    0x80114774,%edx
8010368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010368e:	01 d0                	add    %edx,%eax
80103690:	83 c0 01             	add    $0x1,%eax
80103693:	89 c2                	mov    %eax,%edx
80103695:	a1 84 47 11 80       	mov    0x80114784,%eax
8010369a:	83 ec 08             	sub    $0x8,%esp
8010369d:	52                   	push   %edx
8010369e:	50                   	push   %eax
8010369f:	e8 2a cb ff ff       	call   801001ce <bread>
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ad:	83 c0 10             	add    $0x10,%eax
801036b0:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
801036b7:	89 c2                	mov    %eax,%edx
801036b9:	a1 84 47 11 80       	mov    0x80114784,%eax
801036be:	83 ec 08             	sub    $0x8,%esp
801036c1:	52                   	push   %edx
801036c2:	50                   	push   %eax
801036c3:	e8 06 cb ff ff       	call   801001ce <bread>
801036c8:	83 c4 10             	add    $0x10,%esp
801036cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d1:	8d 50 5c             	lea    0x5c(%eax),%edx
801036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d7:	83 c0 5c             	add    $0x5c,%eax
801036da:	83 ec 04             	sub    $0x4,%esp
801036dd:	68 00 02 00 00       	push   $0x200
801036e2:	52                   	push   %edx
801036e3:	50                   	push   %eax
801036e4:	e8 d8 21 00 00       	call   801058c1 <memmove>
801036e9:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036ec:	83 ec 0c             	sub    $0xc,%esp
801036ef:	ff 75 f0             	push   -0x10(%ebp)
801036f2:	e8 10 cb ff ff       	call   80100207 <bwrite>
801036f7:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801036fa:	83 ec 0c             	sub    $0xc,%esp
801036fd:	ff 75 ec             	push   -0x14(%ebp)
80103700:	e8 4b cb ff ff       	call   80100250 <brelse>
80103705:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	ff 75 f0             	push   -0x10(%ebp)
8010370e:	e8 3d cb ff ff       	call   80100250 <brelse>
80103713:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103716:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010371a:	a1 88 47 11 80       	mov    0x80114788,%eax
8010371f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103722:	0f 8c 5d ff ff ff    	jl     80103685 <write_log+0x12>
  }
}
80103728:	90                   	nop
80103729:	c9                   	leave  
8010372a:	c3                   	ret    

8010372b <commit>:

static void
commit()
{
8010372b:	55                   	push   %ebp
8010372c:	89 e5                	mov    %esp,%ebp
8010372e:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103731:	a1 88 47 11 80       	mov    0x80114788,%eax
80103736:	85 c0                	test   %eax,%eax
80103738:	7e 1e                	jle    80103758 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010373a:	e8 34 ff ff ff       	call   80103673 <write_log>
    write_head();    // Write header to disk -- the real commit
8010373f:	e8 3a fd ff ff       	call   8010347e <write_head>
    install_trans(); // Now install writes to home locations
80103744:	e8 09 fc ff ff       	call   80103352 <install_trans>
    log.lh.n = 0;
80103749:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
80103750:	00 00 00 
    write_head();    // Erase the transaction from the log
80103753:	e8 26 fd ff ff       	call   8010347e <write_head>
  }
}
80103758:	90                   	nop
80103759:	c9                   	leave  
8010375a:	c3                   	ret    

8010375b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010375b:	55                   	push   %ebp
8010375c:	89 e5                	mov    %esp,%ebp
8010375e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103761:	a1 88 47 11 80       	mov    0x80114788,%eax
80103766:	83 f8 1d             	cmp    $0x1d,%eax
80103769:	7f 12                	jg     8010377d <log_write+0x22>
8010376b:	a1 88 47 11 80       	mov    0x80114788,%eax
80103770:	8b 15 78 47 11 80    	mov    0x80114778,%edx
80103776:	83 ea 01             	sub    $0x1,%edx
80103779:	39 d0                	cmp    %edx,%eax
8010377b:	7c 0d                	jl     8010378a <log_write+0x2f>
    panic("too big a transaction");
8010377d:	83 ec 0c             	sub    $0xc,%esp
80103780:	68 38 8e 10 80       	push   $0x80108e38
80103785:	e8 12 ce ff ff       	call   8010059c <panic>
  if (log.outstanding < 1)
8010378a:	a1 7c 47 11 80       	mov    0x8011477c,%eax
8010378f:	85 c0                	test   %eax,%eax
80103791:	7f 0d                	jg     801037a0 <log_write+0x45>
    panic("log_write outside of trans");
80103793:	83 ec 0c             	sub    $0xc,%esp
80103796:	68 4e 8e 10 80       	push   $0x80108e4e
8010379b:	e8 fc cd ff ff       	call   8010059c <panic>

  acquire(&log.lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	68 40 47 11 80       	push   $0x80114740
801037a8:	e8 ce 1d 00 00       	call   8010557b <acquire>
801037ad:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037b7:	eb 1d                	jmp    801037d6 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bc:	83 c0 10             	add    $0x10,%eax
801037bf:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
801037c6:	89 c2                	mov    %eax,%edx
801037c8:	8b 45 08             	mov    0x8(%ebp),%eax
801037cb:	8b 40 08             	mov    0x8(%eax),%eax
801037ce:	39 c2                	cmp    %eax,%edx
801037d0:	74 10                	je     801037e2 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801037d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037d6:	a1 88 47 11 80       	mov    0x80114788,%eax
801037db:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037de:	7c d9                	jl     801037b9 <log_write+0x5e>
801037e0:	eb 01                	jmp    801037e3 <log_write+0x88>
      break;
801037e2:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037e3:	8b 45 08             	mov    0x8(%ebp),%eax
801037e6:	8b 40 08             	mov    0x8(%eax),%eax
801037e9:	89 c2                	mov    %eax,%edx
801037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ee:	83 c0 10             	add    $0x10,%eax
801037f1:	89 14 85 4c 47 11 80 	mov    %edx,-0x7feeb8b4(,%eax,4)
  if (i == log.lh.n)
801037f8:	a1 88 47 11 80       	mov    0x80114788,%eax
801037fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103800:	75 0d                	jne    8010380f <log_write+0xb4>
    log.lh.n++;
80103802:	a1 88 47 11 80       	mov    0x80114788,%eax
80103807:	83 c0 01             	add    $0x1,%eax
8010380a:	a3 88 47 11 80       	mov    %eax,0x80114788
  b->flags |= B_DIRTY; // prevent eviction
8010380f:	8b 45 08             	mov    0x8(%ebp),%eax
80103812:	8b 00                	mov    (%eax),%eax
80103814:	83 c8 04             	or     $0x4,%eax
80103817:	89 c2                	mov    %eax,%edx
80103819:	8b 45 08             	mov    0x8(%ebp),%eax
8010381c:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010381e:	83 ec 0c             	sub    $0xc,%esp
80103821:	68 40 47 11 80       	push   $0x80114740
80103826:	e8 be 1d 00 00       	call   801055e9 <release>
8010382b:	83 c4 10             	add    $0x10,%esp
}
8010382e:	90                   	nop
8010382f:	c9                   	leave  
80103830:	c3                   	ret    

80103831 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103831:	55                   	push   %ebp
80103832:	89 e5                	mov    %esp,%ebp
80103834:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103837:	8b 55 08             	mov    0x8(%ebp),%edx
8010383a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010383d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103840:	f0 87 02             	lock xchg %eax,(%edx)
80103843:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103846:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103849:	c9                   	leave  
8010384a:	c3                   	ret    

8010384b <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010384b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010384f:	83 e4 f0             	and    $0xfffffff0,%esp
80103852:	ff 71 fc             	push   -0x4(%ecx)
80103855:	55                   	push   %ebp
80103856:	89 e5                	mov    %esp,%ebp
80103858:	51                   	push   %ecx
80103859:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010385c:	83 ec 08             	sub    $0x8,%esp
8010385f:	68 00 00 40 80       	push   $0x80400000
80103864:	68 d8 76 11 80       	push   $0x801176d8
80103869:	e8 df f2 ff ff       	call   80102b4d <kinit1>
8010386e:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103871:	e8 bf 4a 00 00       	call   80108335 <kvmalloc>
  mpinit();        // detect other processors
80103876:	e8 ba 03 00 00       	call   80103c35 <mpinit>
  lapicinit();     // interrupt controller
8010387b:	e8 39 f6 ff ff       	call   80102eb9 <lapicinit>
  seginit();       // segment descriptors
80103880:	e8 37 45 00 00       	call   80107dbc <seginit>
  picinit();       // disable pic
80103885:	e8 fc 04 00 00       	call   80103d86 <picinit>
  ioapicinit();    // another interrupt controller
8010388a:	e8 da f1 ff ff       	call   80102a69 <ioapicinit>
  consoleinit();   // console hardware
8010388f:	e8 bb d2 ff ff       	call   80100b4f <consoleinit>
  uartinit();      // serial port
80103894:	e8 bc 38 00 00       	call   80107155 <uartinit>
  pinit();         // process table
80103899:	e8 24 09 00 00       	call   801041c2 <pinit>
  tvinit();        // trap vectors
8010389e:	e8 94 34 00 00       	call   80106d37 <tvinit>
  binit();         // buffer cache
801038a3:	e8 8c c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038a8:	e8 2c d7 ff ff       	call   80100fd9 <fileinit>
  ideinit();       // disk 
801038ad:	e8 8e ed ff ff       	call   80102640 <ideinit>
  startothers();   // start other processors
801038b2:	e8 80 00 00 00       	call   80103937 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038b7:	83 ec 08             	sub    $0x8,%esp
801038ba:	68 00 00 00 8e       	push   $0x8e000000
801038bf:	68 00 00 40 80       	push   $0x80400000
801038c4:	e8 bd f2 ff ff       	call   80102b86 <kinit2>
801038c9:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038cc:	e8 d7 0a 00 00       	call   801043a8 <userinit>
  mpmain();        // finish this processor's setup
801038d1:	e8 1a 00 00 00       	call   801038f0 <mpmain>

801038d6 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038d6:	55                   	push   %ebp
801038d7:	89 e5                	mov    %esp,%ebp
801038d9:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038dc:	e8 6c 4a 00 00       	call   8010834d <switchkvm>
  seginit();
801038e1:	e8 d6 44 00 00       	call   80107dbc <seginit>
  lapicinit();
801038e6:	e8 ce f5 ff ff       	call   80102eb9 <lapicinit>
  mpmain();
801038eb:	e8 00 00 00 00       	call   801038f0 <mpmain>

801038f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038f7:	e8 e4 08 00 00       	call   801041e0 <cpuid>
801038fc:	89 c3                	mov    %eax,%ebx
801038fe:	e8 dd 08 00 00       	call   801041e0 <cpuid>
80103903:	83 ec 04             	sub    $0x4,%esp
80103906:	53                   	push   %ebx
80103907:	50                   	push   %eax
80103908:	68 69 8e 10 80       	push   $0x80108e69
8010390d:	e8 ea ca ff ff       	call   801003fc <cprintf>
80103912:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103915:	e8 93 35 00 00       	call   80106ead <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010391a:	e8 e2 08 00 00       	call   80104201 <mycpu>
8010391f:	05 a0 00 00 00       	add    $0xa0,%eax
80103924:	83 ec 08             	sub    $0x8,%esp
80103927:	6a 01                	push   $0x1
80103929:	50                   	push   %eax
8010392a:	e8 02 ff ff ff       	call   80103831 <xchg>
8010392f:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103932:	e8 cb 10 00 00       	call   80104a02 <scheduler>

80103937 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103937:	55                   	push   %ebp
80103938:	89 e5                	mov    %esp,%ebp
8010393a:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010393d:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103944:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103949:	83 ec 04             	sub    $0x4,%esp
8010394c:	50                   	push   %eax
8010394d:	68 2c c5 10 80       	push   $0x8010c52c
80103952:	ff 75 f0             	push   -0x10(%ebp)
80103955:	e8 67 1f 00 00       	call   801058c1 <memmove>
8010395a:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010395d:	c7 45 f4 40 48 11 80 	movl   $0x80114840,-0xc(%ebp)
80103964:	eb 79                	jmp    801039df <startothers+0xa8>
    if(c == mycpu())  // We've started already.
80103966:	e8 96 08 00 00       	call   80104201 <mycpu>
8010396b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010396e:	74 67                	je     801039d7 <startothers+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103970:	e8 0c f3 ff ff       	call   80102c81 <kalloc>
80103975:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010397b:	83 e8 04             	sub    $0x4,%eax
8010397e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103981:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103987:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398c:	83 e8 08             	sub    $0x8,%eax
8010398f:	c7 00 d6 38 10 80    	movl   $0x801038d6,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103995:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
8010399a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a3:	83 e8 0c             	sub    $0xc,%eax
801039a6:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801039a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039ab:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b4:	0f b6 00             	movzbl (%eax),%eax
801039b7:	0f b6 c0             	movzbl %al,%eax
801039ba:	83 ec 08             	sub    $0x8,%esp
801039bd:	52                   	push   %edx
801039be:	50                   	push   %eax
801039bf:	e8 56 f6 ff ff       	call   8010301a <lapicstartap>
801039c4:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039c7:	90                   	nop
801039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cb:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801039d1:	85 c0                	test   %eax,%eax
801039d3:	74 f3                	je     801039c8 <startothers+0x91>
801039d5:	eb 01                	jmp    801039d8 <startothers+0xa1>
      continue;
801039d7:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801039d8:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801039df:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
801039e4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039ea:	05 40 48 11 80       	add    $0x80114840,%eax
801039ef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039f2:	0f 82 6e ff ff ff    	jb     80103966 <startothers+0x2f>
      ;
  }
}
801039f8:	90                   	nop
801039f9:	c9                   	leave  
801039fa:	c3                   	ret    

801039fb <inb>:
{
801039fb:	55                   	push   %ebp
801039fc:	89 e5                	mov    %esp,%ebp
801039fe:	83 ec 14             	sub    $0x14,%esp
80103a01:	8b 45 08             	mov    0x8(%ebp),%eax
80103a04:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a08:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a0c:	89 c2                	mov    %eax,%edx
80103a0e:	ec                   	in     (%dx),%al
80103a0f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a12:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    

80103a18 <outb>:
{
80103a18:	55                   	push   %ebp
80103a19:	89 e5                	mov    %esp,%ebp
80103a1b:	83 ec 08             	sub    $0x8,%esp
80103a1e:	8b 55 08             	mov    0x8(%ebp),%edx
80103a21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a28:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a33:	ee                   	out    %al,(%dx)
}
80103a34:	90                   	nop
80103a35:	c9                   	leave  
80103a36:	c3                   	ret    

80103a37 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103a37:	55                   	push   %ebp
80103a38:	89 e5                	mov    %esp,%ebp
80103a3a:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103a3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a4b:	eb 15                	jmp    80103a62 <sum+0x2b>
    sum += addr[i];
80103a4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a50:	8b 45 08             	mov    0x8(%ebp),%eax
80103a53:	01 d0                	add    %edx,%eax
80103a55:	0f b6 00             	movzbl (%eax),%eax
80103a58:	0f b6 c0             	movzbl %al,%eax
80103a5b:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a5e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a65:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a68:	7c e3                	jl     80103a4d <sum+0x16>
  return sum;
80103a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a6d:	c9                   	leave  
80103a6e:	c3                   	ret    

80103a6f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a6f:	55                   	push   %ebp
80103a70:	89 e5                	mov    %esp,%ebp
80103a72:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a75:	8b 45 08             	mov    0x8(%ebp),%eax
80103a78:	05 00 00 00 80       	add    $0x80000000,%eax
80103a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a80:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a86:	01 d0                	add    %edx,%eax
80103a88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a91:	eb 36                	jmp    80103ac9 <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a93:	83 ec 04             	sub    $0x4,%esp
80103a96:	6a 04                	push   $0x4
80103a98:	68 80 8e 10 80       	push   $0x80108e80
80103a9d:	ff 75 f4             	push   -0xc(%ebp)
80103aa0:	e8 c4 1d 00 00       	call   80105869 <memcmp>
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	75 19                	jne    80103ac5 <mpsearch1+0x56>
80103aac:	83 ec 08             	sub    $0x8,%esp
80103aaf:	6a 10                	push   $0x10
80103ab1:	ff 75 f4             	push   -0xc(%ebp)
80103ab4:	e8 7e ff ff ff       	call   80103a37 <sum>
80103ab9:	83 c4 10             	add    $0x10,%esp
80103abc:	84 c0                	test   %al,%al
80103abe:	75 05                	jne    80103ac5 <mpsearch1+0x56>
      return (struct mp*)p;
80103ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac3:	eb 11                	jmp    80103ad6 <mpsearch1+0x67>
  for(p = addr; p < e; p += sizeof(struct mp))
80103ac5:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103acc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103acf:	72 c2                	jb     80103a93 <mpsearch1+0x24>
  return 0;
80103ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ad6:	c9                   	leave  
80103ad7:	c3                   	ret    

80103ad8 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ad8:	55                   	push   %ebp
80103ad9:	89 e5                	mov    %esp,%ebp
80103adb:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ade:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae8:	83 c0 0f             	add    $0xf,%eax
80103aeb:	0f b6 00             	movzbl (%eax),%eax
80103aee:	0f b6 c0             	movzbl %al,%eax
80103af1:	c1 e0 08             	shl    $0x8,%eax
80103af4:	89 c2                	mov    %eax,%edx
80103af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af9:	83 c0 0e             	add    $0xe,%eax
80103afc:	0f b6 00             	movzbl (%eax),%eax
80103aff:	0f b6 c0             	movzbl %al,%eax
80103b02:	09 d0                	or     %edx,%eax
80103b04:	c1 e0 04             	shl    $0x4,%eax
80103b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b0e:	74 21                	je     80103b31 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b10:	83 ec 08             	sub    $0x8,%esp
80103b13:	68 00 04 00 00       	push   $0x400
80103b18:	ff 75 f0             	push   -0x10(%ebp)
80103b1b:	e8 4f ff ff ff       	call   80103a6f <mpsearch1>
80103b20:	83 c4 10             	add    $0x10,%esp
80103b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b2a:	74 51                	je     80103b7d <mpsearch+0xa5>
      return mp;
80103b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b2f:	eb 61                	jmp    80103b92 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b34:	83 c0 14             	add    $0x14,%eax
80103b37:	0f b6 00             	movzbl (%eax),%eax
80103b3a:	0f b6 c0             	movzbl %al,%eax
80103b3d:	c1 e0 08             	shl    $0x8,%eax
80103b40:	89 c2                	mov    %eax,%edx
80103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b45:	83 c0 13             	add    $0x13,%eax
80103b48:	0f b6 00             	movzbl (%eax),%eax
80103b4b:	0f b6 c0             	movzbl %al,%eax
80103b4e:	09 d0                	or     %edx,%eax
80103b50:	c1 e0 0a             	shl    $0xa,%eax
80103b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b59:	2d 00 04 00 00       	sub    $0x400,%eax
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	68 00 04 00 00       	push   $0x400
80103b66:	50                   	push   %eax
80103b67:	e8 03 ff ff ff       	call   80103a6f <mpsearch1>
80103b6c:	83 c4 10             	add    $0x10,%esp
80103b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b76:	74 05                	je     80103b7d <mpsearch+0xa5>
      return mp;
80103b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b7b:	eb 15                	jmp    80103b92 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b7d:	83 ec 08             	sub    $0x8,%esp
80103b80:	68 00 00 01 00       	push   $0x10000
80103b85:	68 00 00 0f 00       	push   $0xf0000
80103b8a:	e8 e0 fe ff ff       	call   80103a6f <mpsearch1>
80103b8f:	83 c4 10             	add    $0x10,%esp
}
80103b92:	c9                   	leave  
80103b93:	c3                   	ret    

80103b94 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	83 ec 18             	sub    $0x18,%esp
  struct mpconf * volatile conf ;
  struct mp * volatile mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b9a:	e8 39 ff ff ff       	call   80103ad8 <mpsearch>
80103b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	74 0a                	je     80103bb0 <mpconfig+0x1c>
80103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba9:	8b 40 04             	mov    0x4(%eax),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	75 07                	jne    80103bb7 <mpconfig+0x23>
    return 0;
80103bb0:	b8 00 00 00 00       	mov    $0x0,%eax
80103bb5:	eb 7c                	jmp    80103c33 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bba:	8b 40 04             	mov    0x4(%eax),%eax
80103bbd:	05 00 00 00 80       	add    $0x80000000,%eax
80103bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc8:	83 ec 04             	sub    $0x4,%esp
80103bcb:	6a 04                	push   $0x4
80103bcd:	68 85 8e 10 80       	push   $0x80108e85
80103bd2:	50                   	push   %eax
80103bd3:	e8 91 1c 00 00       	call   80105869 <memcmp>
80103bd8:	83 c4 10             	add    $0x10,%esp
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	74 07                	je     80103be6 <mpconfig+0x52>
    return 0;
80103bdf:	b8 00 00 00 00       	mov    $0x0,%eax
80103be4:	eb 4d                	jmp    80103c33 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be9:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bed:	3c 01                	cmp    $0x1,%al
80103bef:	74 12                	je     80103c03 <mpconfig+0x6f>
80103bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf4:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bf8:	3c 04                	cmp    $0x4,%al
80103bfa:	74 07                	je     80103c03 <mpconfig+0x6f>
    return 0;
80103bfc:	b8 00 00 00 00       	mov    $0x0,%eax
80103c01:	eb 30                	jmp    80103c33 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c06:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c0a:	0f b7 d0             	movzwl %ax,%edx
80103c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c10:	83 ec 08             	sub    $0x8,%esp
80103c13:	52                   	push   %edx
80103c14:	50                   	push   %eax
80103c15:	e8 1d fe ff ff       	call   80103a37 <sum>
80103c1a:	83 c4 10             	add    $0x10,%esp
80103c1d:	84 c0                	test   %al,%al
80103c1f:	74 07                	je     80103c28 <mpconfig+0x94>
    return 0;
80103c21:	b8 00 00 00 00       	mov    $0x0,%eax
80103c26:	eb 0b                	jmp    80103c33 <mpconfig+0x9f>
  *pmp = mp;
80103c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c2e:	89 10                	mov    %edx,(%eax)
  return conf;
80103c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103c33:	c9                   	leave  
80103c34:	c3                   	ret    

80103c35 <mpinit>:

void
mpinit(void)
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
80103c38:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103c3b:	83 ec 0c             	sub    $0xc,%esp
80103c3e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103c41:	50                   	push   %eax
80103c42:	e8 4d ff ff ff       	call   80103b94 <mpconfig>
80103c47:	83 c4 10             	add    $0x10,%esp
80103c4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c51:	75 0d                	jne    80103c60 <mpinit+0x2b>
    panic("Expect to run on an SMP");
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	68 8a 8e 10 80       	push   $0x80108e8a
80103c5b:	e8 3c c9 ff ff       	call   8010059c <panic>
  ismp = 1;
80103c60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c6a:	8b 40 24             	mov    0x24(%eax),%eax
80103c6d:	a3 3c 47 11 80       	mov    %eax,0x8011473c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c75:	83 c0 2c             	add    $0x2c,%eax
80103c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c7e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c82:	0f b7 d0             	movzwl %ax,%edx
80103c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c88:	01 d0                	add    %edx,%eax
80103c8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103c8d:	eb 7b                	jmp    80103d0a <mpinit+0xd5>
    switch(*p){
80103c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c92:	0f b6 00             	movzbl (%eax),%eax
80103c95:	0f b6 c0             	movzbl %al,%eax
80103c98:	83 f8 04             	cmp    $0x4,%eax
80103c9b:	77 65                	ja     80103d02 <mpinit+0xcd>
80103c9d:	8b 04 85 c4 8e 10 80 	mov    -0x7fef713c(,%eax,4),%eax
80103ca4:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103cac:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80103cb1:	83 f8 07             	cmp    $0x7,%eax
80103cb4:	7f 28                	jg     80103cde <mpinit+0xa9>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103cb6:	8b 15 c0 4d 11 80    	mov    0x80114dc0,%edx
80103cbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103cbf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cc3:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103cc9:	81 c2 40 48 11 80    	add    $0x80114840,%edx
80103ccf:	88 02                	mov    %al,(%edx)
        ncpu++;
80103cd1:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80103cd6:	83 c0 01             	add    $0x1,%eax
80103cd9:	a3 c0 4d 11 80       	mov    %eax,0x80114dc0
      }
      p += sizeof(struct mpproc);
80103cde:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ce2:	eb 26                	jmp    80103d0a <mpinit+0xd5>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ced:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cf1:	a2 20 48 11 80       	mov    %al,0x80114820
      p += sizeof(struct mpioapic);
80103cf6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cfa:	eb 0e                	jmp    80103d0a <mpinit+0xd5>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cfc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d00:	eb 08                	jmp    80103d0a <mpinit+0xd5>
    default:
      ismp = 0;
80103d02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103d09:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103d10:	0f 82 79 ff ff ff    	jb     80103c8f <mpinit+0x5a>
    }
  }
  if(!ismp)
80103d16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d1a:	75 0d                	jne    80103d29 <mpinit+0xf4>
    panic("Didn't find a suitable machine");
80103d1c:	83 ec 0c             	sub    $0xc,%esp
80103d1f:	68 a4 8e 10 80       	push   $0x80108ea4
80103d24:	e8 73 c8 ff ff       	call   8010059c <panic>

  if(mp->imcrp){
80103d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d2c:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d30:	84 c0                	test   %al,%al
80103d32:	74 30                	je     80103d64 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d34:	83 ec 08             	sub    $0x8,%esp
80103d37:	6a 70                	push   $0x70
80103d39:	6a 22                	push   $0x22
80103d3b:	e8 d8 fc ff ff       	call   80103a18 <outb>
80103d40:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d43:	83 ec 0c             	sub    $0xc,%esp
80103d46:	6a 23                	push   $0x23
80103d48:	e8 ae fc ff ff       	call   801039fb <inb>
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	83 c8 01             	or     $0x1,%eax
80103d53:	0f b6 c0             	movzbl %al,%eax
80103d56:	83 ec 08             	sub    $0x8,%esp
80103d59:	50                   	push   %eax
80103d5a:	6a 23                	push   $0x23
80103d5c:	e8 b7 fc ff ff       	call   80103a18 <outb>
80103d61:	83 c4 10             	add    $0x10,%esp
  }
}
80103d64:	90                   	nop
80103d65:	c9                   	leave  
80103d66:	c3                   	ret    

80103d67 <outb>:
{
80103d67:	55                   	push   %ebp
80103d68:	89 e5                	mov    %esp,%ebp
80103d6a:	83 ec 08             	sub    $0x8,%esp
80103d6d:	8b 55 08             	mov    0x8(%ebp),%edx
80103d70:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d73:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d77:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d7a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d7e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d82:	ee                   	out    %al,(%dx)
}
80103d83:	90                   	nop
80103d84:	c9                   	leave  
80103d85:	c3                   	ret    

80103d86 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103d89:	68 ff 00 00 00       	push   $0xff
80103d8e:	6a 21                	push   $0x21
80103d90:	e8 d2 ff ff ff       	call   80103d67 <outb>
80103d95:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103d98:	68 ff 00 00 00       	push   $0xff
80103d9d:	68 a1 00 00 00       	push   $0xa1
80103da2:	e8 c0 ff ff ff       	call   80103d67 <outb>
80103da7:	83 c4 08             	add    $0x8,%esp
}
80103daa:	90                   	nop
80103dab:	c9                   	leave  
80103dac:	c3                   	ret    

80103dad <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103dad:	55                   	push   %ebp
80103dae:	89 e5                	mov    %esp,%ebp
80103db0:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103db3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103dba:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dc6:	8b 10                	mov    (%eax),%edx
80103dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcb:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103dcd:	e8 25 d2 ff ff       	call   80100ff7 <filealloc>
80103dd2:	89 c2                	mov    %eax,%edx
80103dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd7:	89 10                	mov    %edx,(%eax)
80103dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddc:	8b 00                	mov    (%eax),%eax
80103dde:	85 c0                	test   %eax,%eax
80103de0:	0f 84 ca 00 00 00    	je     80103eb0 <pipealloc+0x103>
80103de6:	e8 0c d2 ff ff       	call   80100ff7 <filealloc>
80103deb:	89 c2                	mov    %eax,%edx
80103ded:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df0:	89 10                	mov    %edx,(%eax)
80103df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df5:	8b 00                	mov    (%eax),%eax
80103df7:	85 c0                	test   %eax,%eax
80103df9:	0f 84 b1 00 00 00    	je     80103eb0 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103dff:	e8 7d ee ff ff       	call   80102c81 <kalloc>
80103e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e0b:	0f 84 a2 00 00 00    	je     80103eb3 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80103e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e14:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103e1b:	00 00 00 
  p->writeopen = 1;
80103e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e21:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103e28:	00 00 00 
  p->nwrite = 0;
80103e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e2e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103e35:	00 00 00 
  p->nread = 0;
80103e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103e42:	00 00 00 
  initlock(&p->lock, "pipe");
80103e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e48:	83 ec 08             	sub    $0x8,%esp
80103e4b:	68 d8 8e 10 80       	push   $0x80108ed8
80103e50:	50                   	push   %eax
80103e51:	e8 03 17 00 00       	call   80105559 <initlock>
80103e56:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103e59:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5c:	8b 00                	mov    (%eax),%eax
80103e5e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e64:	8b 45 08             	mov    0x8(%ebp),%eax
80103e67:	8b 00                	mov    (%eax),%eax
80103e69:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e70:	8b 00                	mov    (%eax),%eax
80103e72:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e76:	8b 45 08             	mov    0x8(%ebp),%eax
80103e79:	8b 00                	mov    (%eax),%eax
80103e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e7e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e81:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e84:	8b 00                	mov    (%eax),%eax
80103e86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e8f:	8b 00                	mov    (%eax),%eax
80103e91:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e98:	8b 00                	mov    (%eax),%eax
80103e9a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ea1:	8b 00                	mov    (%eax),%eax
80103ea3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ea6:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ea9:	b8 00 00 00 00       	mov    $0x0,%eax
80103eae:	eb 51                	jmp    80103f01 <pipealloc+0x154>

//PAGEBREAK: 20
 bad:
80103eb0:	90                   	nop
80103eb1:	eb 01                	jmp    80103eb4 <pipealloc+0x107>
    goto bad;
80103eb3:	90                   	nop
  if(p)
80103eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103eb8:	74 0e                	je     80103ec8 <pipealloc+0x11b>
    kfree((char*)p);
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	ff 75 f4             	push   -0xc(%ebp)
80103ec0:	e8 22 ed ff ff       	call   80102be7 <kfree>
80103ec5:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecb:	8b 00                	mov    (%eax),%eax
80103ecd:	85 c0                	test   %eax,%eax
80103ecf:	74 11                	je     80103ee2 <pipealloc+0x135>
    fileclose(*f0);
80103ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed4:	8b 00                	mov    (%eax),%eax
80103ed6:	83 ec 0c             	sub    $0xc,%esp
80103ed9:	50                   	push   %eax
80103eda:	e8 d6 d1 ff ff       	call   801010b5 <fileclose>
80103edf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ee5:	8b 00                	mov    (%eax),%eax
80103ee7:	85 c0                	test   %eax,%eax
80103ee9:	74 11                	je     80103efc <pipealloc+0x14f>
    fileclose(*f1);
80103eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eee:	8b 00                	mov    (%eax),%eax
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	50                   	push   %eax
80103ef4:	e8 bc d1 ff ff       	call   801010b5 <fileclose>
80103ef9:	83 c4 10             	add    $0x10,%esp
  return -1;
80103efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f01:	c9                   	leave  
80103f02:	c3                   	ret    

80103f03 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f03:	55                   	push   %ebp
80103f04:	89 e5                	mov    %esp,%ebp
80103f06:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103f09:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	50                   	push   %eax
80103f10:	e8 66 16 00 00       	call   8010557b <acquire>
80103f15:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103f18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103f1c:	74 23                	je     80103f41 <pipeclose+0x3e>
    p->writeopen = 0;
80103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f21:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103f28:	00 00 00 
    wakeup(&p->nread);
80103f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2e:	05 34 02 00 00       	add    $0x234,%eax
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	50                   	push   %eax
80103f37:	e8 9f 0d 00 00       	call   80104cdb <wakeup>
80103f3c:	83 c4 10             	add    $0x10,%esp
80103f3f:	eb 21                	jmp    80103f62 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103f41:	8b 45 08             	mov    0x8(%ebp),%eax
80103f44:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103f4b:	00 00 00 
    wakeup(&p->nwrite);
80103f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f51:	05 38 02 00 00       	add    $0x238,%eax
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	50                   	push   %eax
80103f5a:	e8 7c 0d 00 00       	call   80104cdb <wakeup>
80103f5f:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f62:	8b 45 08             	mov    0x8(%ebp),%eax
80103f65:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f6b:	85 c0                	test   %eax,%eax
80103f6d:	75 2c                	jne    80103f9b <pipeclose+0x98>
80103f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f72:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f78:	85 c0                	test   %eax,%eax
80103f7a:	75 1f                	jne    80103f9b <pipeclose+0x98>
    release(&p->lock);
80103f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7f:	83 ec 0c             	sub    $0xc,%esp
80103f82:	50                   	push   %eax
80103f83:	e8 61 16 00 00       	call   801055e9 <release>
80103f88:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103f8b:	83 ec 0c             	sub    $0xc,%esp
80103f8e:	ff 75 08             	push   0x8(%ebp)
80103f91:	e8 51 ec ff ff       	call   80102be7 <kfree>
80103f96:	83 c4 10             	add    $0x10,%esp
80103f99:	eb 0f                	jmp    80103faa <pipeclose+0xa7>
  } else
    release(&p->lock);
80103f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	50                   	push   %eax
80103fa2:	e8 42 16 00 00       	call   801055e9 <release>
80103fa7:	83 c4 10             	add    $0x10,%esp
}
80103faa:	90                   	nop
80103fab:	c9                   	leave  
80103fac:	c3                   	ret    

80103fad <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103fad:	55                   	push   %ebp
80103fae:	89 e5                	mov    %esp,%ebp
80103fb0:	53                   	push   %ebx
80103fb1:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	83 ec 0c             	sub    $0xc,%esp
80103fba:	50                   	push   %eax
80103fbb:	e8 bb 15 00 00       	call   8010557b <acquire>
80103fc0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103fc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fca:	e9 ad 00 00 00       	jmp    8010407c <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103fd8:	85 c0                	test   %eax,%eax
80103fda:	74 0c                	je     80103fe8 <pipewrite+0x3b>
80103fdc:	e8 98 02 00 00       	call   80104279 <myproc>
80103fe1:	8b 40 24             	mov    0x24(%eax),%eax
80103fe4:	85 c0                	test   %eax,%eax
80103fe6:	74 19                	je     80104001 <pipewrite+0x54>
        release(&p->lock);
80103fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80103feb:	83 ec 0c             	sub    $0xc,%esp
80103fee:	50                   	push   %eax
80103fef:	e8 f5 15 00 00       	call   801055e9 <release>
80103ff4:	83 c4 10             	add    $0x10,%esp
        return -1;
80103ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ffc:	e9 a9 00 00 00       	jmp    801040aa <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80104001:	8b 45 08             	mov    0x8(%ebp),%eax
80104004:	05 34 02 00 00       	add    $0x234,%eax
80104009:	83 ec 0c             	sub    $0xc,%esp
8010400c:	50                   	push   %eax
8010400d:	e8 c9 0c 00 00       	call   80104cdb <wakeup>
80104012:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104015:	8b 45 08             	mov    0x8(%ebp),%eax
80104018:	8b 55 08             	mov    0x8(%ebp),%edx
8010401b:	81 c2 38 02 00 00    	add    $0x238,%edx
80104021:	83 ec 08             	sub    $0x8,%esp
80104024:	50                   	push   %eax
80104025:	52                   	push   %edx
80104026:	e8 ca 0b 00 00       	call   80104bf5 <sleep>
8010402b:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010402e:	8b 45 08             	mov    0x8(%ebp),%eax
80104031:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104037:	8b 45 08             	mov    0x8(%ebp),%eax
8010403a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104040:	05 00 02 00 00       	add    $0x200,%eax
80104045:	39 c2                	cmp    %eax,%edx
80104047:	74 86                	je     80103fcf <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104049:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010404c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104052:	8b 45 08             	mov    0x8(%ebp),%eax
80104055:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010405b:	8d 48 01             	lea    0x1(%eax),%ecx
8010405e:	8b 55 08             	mov    0x8(%ebp),%edx
80104061:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104067:	25 ff 01 00 00       	and    $0x1ff,%eax
8010406c:	89 c1                	mov    %eax,%ecx
8010406e:	0f b6 13             	movzbl (%ebx),%edx
80104071:	8b 45 08             	mov    0x8(%ebp),%eax
80104074:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104078:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407f:	3b 45 10             	cmp    0x10(%ebp),%eax
80104082:	7c aa                	jl     8010402e <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	05 34 02 00 00       	add    $0x234,%eax
8010408c:	83 ec 0c             	sub    $0xc,%esp
8010408f:	50                   	push   %eax
80104090:	e8 46 0c 00 00       	call   80104cdb <wakeup>
80104095:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104098:	8b 45 08             	mov    0x8(%ebp),%eax
8010409b:	83 ec 0c             	sub    $0xc,%esp
8010409e:	50                   	push   %eax
8010409f:	e8 45 15 00 00       	call   801055e9 <release>
801040a4:	83 c4 10             	add    $0x10,%esp
  return n;
801040a7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801040aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ad:	c9                   	leave  
801040ae:	c3                   	ret    

801040af <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801040af:	55                   	push   %ebp
801040b0:	89 e5                	mov    %esp,%ebp
801040b2:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801040b5:	8b 45 08             	mov    0x8(%ebp),%eax
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	50                   	push   %eax
801040bc:	e8 ba 14 00 00       	call   8010557b <acquire>
801040c1:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801040c4:	eb 3e                	jmp    80104104 <piperead+0x55>
    if(myproc()->killed){
801040c6:	e8 ae 01 00 00       	call   80104279 <myproc>
801040cb:	8b 40 24             	mov    0x24(%eax),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	74 19                	je     801040eb <piperead+0x3c>
      release(&p->lock);
801040d2:	8b 45 08             	mov    0x8(%ebp),%eax
801040d5:	83 ec 0c             	sub    $0xc,%esp
801040d8:	50                   	push   %eax
801040d9:	e8 0b 15 00 00       	call   801055e9 <release>
801040de:	83 c4 10             	add    $0x10,%esp
      return -1;
801040e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e6:	e9 be 00 00 00       	jmp    801041a9 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	8b 55 08             	mov    0x8(%ebp),%edx
801040f1:	81 c2 34 02 00 00    	add    $0x234,%edx
801040f7:	83 ec 08             	sub    $0x8,%esp
801040fa:	50                   	push   %eax
801040fb:	52                   	push   %edx
801040fc:	e8 f4 0a 00 00       	call   80104bf5 <sleep>
80104101:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104104:	8b 45 08             	mov    0x8(%ebp),%eax
80104107:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104116:	39 c2                	cmp    %eax,%edx
80104118:	75 0d                	jne    80104127 <piperead+0x78>
8010411a:	8b 45 08             	mov    0x8(%ebp),%eax
8010411d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104123:	85 c0                	test   %eax,%eax
80104125:	75 9f                	jne    801040c6 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010412e:	eb 48                	jmp    80104178 <piperead+0xc9>
    if(p->nread == p->nwrite)
80104130:	8b 45 08             	mov    0x8(%ebp),%eax
80104133:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104139:	8b 45 08             	mov    0x8(%ebp),%eax
8010413c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104142:	39 c2                	cmp    %eax,%edx
80104144:	74 3c                	je     80104182 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104146:	8b 45 08             	mov    0x8(%ebp),%eax
80104149:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010414f:	8d 48 01             	lea    0x1(%eax),%ecx
80104152:	8b 55 08             	mov    0x8(%ebp),%edx
80104155:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010415b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104160:	89 c1                	mov    %eax,%ecx
80104162:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104165:	8b 45 0c             	mov    0xc(%ebp),%eax
80104168:	01 c2                	add    %eax,%edx
8010416a:	8b 45 08             	mov    0x8(%ebp),%eax
8010416d:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80104172:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104174:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010417e:	7c b0                	jl     80104130 <piperead+0x81>
80104180:	eb 01                	jmp    80104183 <piperead+0xd4>
      break;
80104182:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
80104186:	05 38 02 00 00       	add    $0x238,%eax
8010418b:	83 ec 0c             	sub    $0xc,%esp
8010418e:	50                   	push   %eax
8010418f:	e8 47 0b 00 00       	call   80104cdb <wakeup>
80104194:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104197:	8b 45 08             	mov    0x8(%ebp),%eax
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	50                   	push   %eax
8010419e:	e8 46 14 00 00       	call   801055e9 <release>
801041a3:	83 c4 10             	add    $0x10,%esp
  return i;
801041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041a9:	c9                   	leave  
801041aa:	c3                   	ret    

801041ab <readeflags>:
{
801041ab:	55                   	push   %ebp
801041ac:	89 e5                	mov    %esp,%ebp
801041ae:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b1:	9c                   	pushf  
801041b2:	58                   	pop    %eax
801041b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801041b9:	c9                   	leave  
801041ba:	c3                   	ret    

801041bb <sti>:
{
801041bb:	55                   	push   %ebp
801041bc:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801041be:	fb                   	sti    
}
801041bf:	90                   	nop
801041c0:	5d                   	pop    %ebp
801041c1:	c3                   	ret    

801041c2 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801041c2:	55                   	push   %ebp
801041c3:	89 e5                	mov    %esp,%ebp
801041c5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801041c8:	83 ec 08             	sub    $0x8,%esp
801041cb:	68 e0 8e 10 80       	push   $0x80108ee0
801041d0:	68 e0 4d 11 80       	push   $0x80114de0
801041d5:	e8 7f 13 00 00       	call   80105559 <initlock>
801041da:	83 c4 10             	add    $0x10,%esp
}
801041dd:	90                   	nop
801041de:	c9                   	leave  
801041df:	c3                   	ret    

801041e0 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801041e6:	e8 16 00 00 00       	call   80104201 <mycpu>
801041eb:	89 c2                	mov    %eax,%edx
801041ed:	b8 40 48 11 80       	mov    $0x80114840,%eax
801041f2:	29 c2                	sub    %eax,%edx
801041f4:	89 d0                	mov    %edx,%eax
801041f6:	c1 f8 04             	sar    $0x4,%eax
801041f9:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041ff:	c9                   	leave  
80104200:	c3                   	ret    

80104201 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104201:	55                   	push   %ebp
80104202:	89 e5                	mov    %esp,%ebp
80104204:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
80104207:	e8 9f ff ff ff       	call   801041ab <readeflags>
8010420c:	25 00 02 00 00       	and    $0x200,%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	74 0d                	je     80104222 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80104215:	83 ec 0c             	sub    $0xc,%esp
80104218:	68 e8 8e 10 80       	push   $0x80108ee8
8010421d:	e8 7a c3 ff ff       	call   8010059c <panic>
  
  apicid = lapicid();
80104222:	e8 b0 ed ff ff       	call   80102fd7 <lapicid>
80104227:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010422a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104231:	eb 2d                	jmp    80104260 <mycpu+0x5f>
    if (cpus[i].apicid == apicid)
80104233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104236:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010423c:	05 40 48 11 80       	add    $0x80114840,%eax
80104241:	0f b6 00             	movzbl (%eax),%eax
80104244:	0f b6 c0             	movzbl %al,%eax
80104247:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010424a:	75 10                	jne    8010425c <mycpu+0x5b>
      return &cpus[i];
8010424c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104255:	05 40 48 11 80       	add    $0x80114840,%eax
8010425a:	eb 1b                	jmp    80104277 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
8010425c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104260:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80104265:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104268:	7c c9                	jl     80104233 <mycpu+0x32>
  }
  panic("unknown apicid\n");
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 0e 8f 10 80       	push   $0x80108f0e
80104272:	e8 25 c3 ff ff       	call   8010059c <panic>
}
80104277:	c9                   	leave  
80104278:	c3                   	ret    

80104279 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104279:	55                   	push   %ebp
8010427a:	89 e5                	mov    %esp,%ebp
8010427c:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
8010427f:	e8 72 14 00 00       	call   801056f6 <pushcli>
  c = mycpu();
80104284:	e8 78 ff ff ff       	call   80104201 <mycpu>
80104289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010428c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104295:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104298:	e8 a7 14 00 00       	call   80105744 <popcli>
  return p;
8010429d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801042a0:	c9                   	leave  
801042a1:	c3                   	ret    

801042a2 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801042a2:	55                   	push   %ebp
801042a3:	89 e5                	mov    %esp,%ebp
801042a5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 e0 4d 11 80       	push   $0x80114de0
801042b0:	e8 c6 12 00 00       	call   8010557b <acquire>
801042b5:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042b8:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
801042bf:	eb 0e                	jmp    801042cf <allocproc+0x2d>
    if(p->state == UNUSED)
801042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c4:	8b 40 0c             	mov    0xc(%eax),%eax
801042c7:	85 c0                	test   %eax,%eax
801042c9:	74 27                	je     801042f2 <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042cb:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801042cf:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
801042d6:	72 e9                	jb     801042c1 <allocproc+0x1f>
      goto found;

  release(&ptable.lock);
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 e0 4d 11 80       	push   $0x80114de0
801042e0:	e8 04 13 00 00       	call   801055e9 <release>
801042e5:	83 c4 10             	add    $0x10,%esp
  return 0;
801042e8:	b8 00 00 00 00       	mov    $0x0,%eax
801042ed:	e9 b4 00 00 00       	jmp    801043a6 <allocproc+0x104>
      goto found;
801042f2:	90                   	nop

found:
  p->state = EMBRYO;
801042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f6:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801042fd:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104302:	8d 50 01             	lea    0x1(%eax),%edx
80104305:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
8010430b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010430e:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104311:	83 ec 0c             	sub    $0xc,%esp
80104314:	68 e0 4d 11 80       	push   $0x80114de0
80104319:	e8 cb 12 00 00       	call   801055e9 <release>
8010431e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104321:	e8 5b e9 ff ff       	call   80102c81 <kalloc>
80104326:	89 c2                	mov    %eax,%edx
80104328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432b:	89 50 08             	mov    %edx,0x8(%eax)
8010432e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104331:	8b 40 08             	mov    0x8(%eax),%eax
80104334:	85 c0                	test   %eax,%eax
80104336:	75 11                	jne    80104349 <allocproc+0xa7>
    p->state = UNUSED;
80104338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104342:	b8 00 00 00 00       	mov    $0x0,%eax
80104347:	eb 5d                	jmp    801043a6 <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	8b 40 08             	mov    0x8(%eax),%eax
8010434f:	05 00 10 00 00       	add    $0x1000,%eax
80104354:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104357:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010435b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104361:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104364:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104368:	ba f1 6c 10 80       	mov    $0x80106cf1,%edx
8010436d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104370:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104372:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104379:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010437c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010437f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104382:	8b 40 1c             	mov    0x1c(%eax),%eax
80104385:	83 ec 04             	sub    $0x4,%esp
80104388:	6a 14                	push   $0x14
8010438a:	6a 00                	push   $0x0
8010438c:	50                   	push   %eax
8010438d:	e8 70 14 00 00       	call   80105802 <memset>
80104392:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	8b 40 1c             	mov    0x1c(%eax),%eax
8010439b:	ba af 4b 10 80       	mov    $0x80104baf,%edx
801043a0:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801043a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043a6:	c9                   	leave  
801043a7:	c3                   	ret    

801043a8 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801043a8:	55                   	push   %ebp
801043a9:	89 e5                	mov    %esp,%ebp
801043ab:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801043ae:	e8 ef fe ff ff       	call   801042a2 <allocproc>
801043b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b9:	a3 60 c6 10 80       	mov    %eax,0x8010c660
  if((p->pgdir = setupkvm()) == 0)
801043be:	e8 d9 3e 00 00       	call   8010829c <setupkvm>
801043c3:	89 c2                	mov    %eax,%edx
801043c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c8:	89 50 04             	mov    %edx,0x4(%eax)
801043cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ce:	8b 40 04             	mov    0x4(%eax),%eax
801043d1:	85 c0                	test   %eax,%eax
801043d3:	75 0d                	jne    801043e2 <userinit+0x3a>
    panic("userinit: out of memory?");
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	68 1e 8f 10 80       	push   $0x80108f1e
801043dd:	e8 ba c1 ff ff       	call   8010059c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801043e2:	ba 2c 00 00 00       	mov    $0x2c,%edx
801043e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ea:	8b 40 04             	mov    0x4(%eax),%eax
801043ed:	83 ec 04             	sub    $0x4,%esp
801043f0:	52                   	push   %edx
801043f1:	68 00 c5 10 80       	push   $0x8010c500
801043f6:	50                   	push   %eax
801043f7:	e8 0b 41 00 00       	call   80108507 <inituvm>
801043fc:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104402:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440b:	8b 40 18             	mov    0x18(%eax),%eax
8010440e:	83 ec 04             	sub    $0x4,%esp
80104411:	6a 4c                	push   $0x4c
80104413:	6a 00                	push   $0x0
80104415:	50                   	push   %eax
80104416:	e8 e7 13 00 00       	call   80105802 <memset>
8010441b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104421:	8b 40 18             	mov    0x18(%eax),%eax
80104424:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442d:	8b 40 18             	mov    0x18(%eax),%eax
80104430:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104439:	8b 50 18             	mov    0x18(%eax),%edx
8010443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443f:	8b 40 18             	mov    0x18(%eax),%eax
80104442:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104446:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010444a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444d:	8b 50 18             	mov    0x18(%eax),%edx
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	8b 40 18             	mov    0x18(%eax),%eax
80104456:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010445a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010445e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104461:	8b 40 18             	mov    0x18(%eax),%eax
80104464:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010446b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446e:	8b 40 18             	mov    0x18(%eax),%eax
80104471:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447b:	8b 40 18             	mov    0x18(%eax),%eax
8010447e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104488:	83 c0 6c             	add    $0x6c,%eax
8010448b:	83 ec 04             	sub    $0x4,%esp
8010448e:	6a 10                	push   $0x10
80104490:	68 37 8f 10 80       	push   $0x80108f37
80104495:	50                   	push   %eax
80104496:	e8 6a 15 00 00       	call   80105a05 <safestrcpy>
8010449b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 40 8f 10 80       	push   $0x80108f40
801044a6:	e8 91 e0 ff ff       	call   8010253c <namei>
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	89 c2                	mov    %eax,%edx
801044b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b3:	89 50 68             	mov    %edx,0x68(%eax)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	68 e0 4d 11 80       	push   $0x80114de0
801044be:	e8 b8 10 00 00       	call   8010557b <acquire>
801044c3:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	68 e0 4d 11 80       	push   $0x80114de0
801044d8:	e8 0c 11 00 00       	call   801055e9 <release>
801044dd:	83 c4 10             	add    $0x10,%esp
}
801044e0:	90                   	nop
801044e1:	c9                   	leave  
801044e2:	c3                   	ret    

801044e3 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801044e3:	55                   	push   %ebp
801044e4:	89 e5                	mov    %esp,%ebp
801044e6:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
801044e9:	e8 8b fd ff ff       	call   80104279 <myproc>
801044ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801044f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044f4:	8b 00                	mov    (%eax),%eax
801044f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801044f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801044fd:	7e 2e                	jle    8010452d <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801044ff:	8b 55 08             	mov    0x8(%ebp),%edx
80104502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104505:	01 c2                	add    %eax,%edx
80104507:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010450a:	8b 40 04             	mov    0x4(%eax),%eax
8010450d:	83 ec 04             	sub    $0x4,%esp
80104510:	52                   	push   %edx
80104511:	ff 75 f4             	push   -0xc(%ebp)
80104514:	50                   	push   %eax
80104515:	e8 2a 41 00 00       	call   80108644 <allocuvm>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104524:	75 3b                	jne    80104561 <growproc+0x7e>
      return -1;
80104526:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010452b:	eb 4f                	jmp    8010457c <growproc+0x99>
  } else if(n < 0){
8010452d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104531:	79 2e                	jns    80104561 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104533:	8b 55 08             	mov    0x8(%ebp),%edx
80104536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104539:	01 c2                	add    %eax,%edx
8010453b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010453e:	8b 40 04             	mov    0x4(%eax),%eax
80104541:	83 ec 04             	sub    $0x4,%esp
80104544:	52                   	push   %edx
80104545:	ff 75 f4             	push   -0xc(%ebp)
80104548:	50                   	push   %eax
80104549:	e8 fb 41 00 00       	call   80108749 <deallocuvm>
8010454e:	83 c4 10             	add    $0x10,%esp
80104551:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104558:	75 07                	jne    80104561 <growproc+0x7e>
      return -1;
8010455a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010455f:	eb 1b                	jmp    8010457c <growproc+0x99>
  }
  curproc->sz = sz;
80104561:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104564:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104567:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104569:	83 ec 0c             	sub    $0xc,%esp
8010456c:	ff 75 f0             	push   -0x10(%ebp)
8010456f:	e8 f2 3d 00 00       	call   80108366 <switchuvm>
80104574:	83 c4 10             	add    $0x10,%esp
  return 0;
80104577:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010457c:	c9                   	leave  
8010457d:	c3                   	ret    

8010457e <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010457e:	55                   	push   %ebp
8010457f:	89 e5                	mov    %esp,%ebp
80104581:	57                   	push   %edi
80104582:	56                   	push   %esi
80104583:	53                   	push   %ebx
80104584:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104587:	e8 ed fc ff ff       	call   80104279 <myproc>
8010458c:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
8010458f:	e8 0e fd ff ff       	call   801042a2 <allocproc>
80104594:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104597:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010459b:	75 0a                	jne    801045a7 <fork+0x29>
    return -1;
8010459d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a2:	e9 57 01 00 00       	jmp    801046fe <fork+0x180>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801045a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045aa:	8b 10                	mov    (%eax),%edx
801045ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045af:	8b 40 04             	mov    0x4(%eax),%eax
801045b2:	83 ec 08             	sub    $0x8,%esp
801045b5:	52                   	push   %edx
801045b6:	50                   	push   %eax
801045b7:	e8 2b 43 00 00       	call   801088e7 <copyuvm>
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	89 c2                	mov    %eax,%edx
801045c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045c4:	89 50 04             	mov    %edx,0x4(%eax)
801045c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ca:	8b 40 04             	mov    0x4(%eax),%eax
801045cd:	85 c0                	test   %eax,%eax
801045cf:	75 30                	jne    80104601 <fork+0x83>
    kfree(np->kstack);
801045d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045d4:	8b 40 08             	mov    0x8(%eax),%eax
801045d7:	83 ec 0c             	sub    $0xc,%esp
801045da:	50                   	push   %eax
801045db:	e8 07 e6 ff ff       	call   80102be7 <kfree>
801045e0:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801045e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801045ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801045f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fc:	e9 fd 00 00 00       	jmp    801046fe <fork+0x180>
  }
  np->sz = curproc->sz;
80104601:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104604:	8b 10                	mov    (%eax),%edx
80104606:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104609:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010460b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010460e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104611:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104614:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104617:	8b 48 18             	mov    0x18(%eax),%ecx
8010461a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010461d:	8b 40 18             	mov    0x18(%eax),%eax
80104620:	89 c2                	mov    %eax,%edx
80104622:	89 cb                	mov    %ecx,%ebx
80104624:	b8 13 00 00 00       	mov    $0x13,%eax
80104629:	89 d7                	mov    %edx,%edi
8010462b:	89 de                	mov    %ebx,%esi
8010462d:	89 c1                	mov    %eax,%ecx
8010462f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104631:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104634:	8b 40 18             	mov    0x18(%eax),%eax
80104637:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010463e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104645:	eb 3d                	jmp    80104684 <fork+0x106>
    if(curproc->ofile[i])
80104647:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010464a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010464d:	83 c2 08             	add    $0x8,%edx
80104650:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104654:	85 c0                	test   %eax,%eax
80104656:	74 28                	je     80104680 <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104658:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010465b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010465e:	83 c2 08             	add    $0x8,%edx
80104661:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104665:	83 ec 0c             	sub    $0xc,%esp
80104668:	50                   	push   %eax
80104669:	e8 f6 c9 ff ff       	call   80101064 <filedup>
8010466e:	83 c4 10             	add    $0x10,%esp
80104671:	89 c1                	mov    %eax,%ecx
80104673:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104676:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104679:	83 c2 08             	add    $0x8,%edx
8010467c:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
80104680:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104684:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104688:	7e bd                	jle    80104647 <fork+0xc9>
  np->cwd = idup(curproc->cwd);
8010468a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010468d:	8b 40 68             	mov    0x68(%eax),%eax
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	50                   	push   %eax
80104694:	e8 2e d3 ff ff       	call   801019c7 <idup>
80104699:	83 c4 10             	add    $0x10,%esp
8010469c:	89 c2                	mov    %eax,%edx
8010469e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046a1:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a7:	8d 50 6c             	lea    0x6c(%eax),%edx
801046aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ad:	83 c0 6c             	add    $0x6c,%eax
801046b0:	83 ec 04             	sub    $0x4,%esp
801046b3:	6a 10                	push   $0x10
801046b5:	52                   	push   %edx
801046b6:	50                   	push   %eax
801046b7:	e8 49 13 00 00       	call   80105a05 <safestrcpy>
801046bc:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801046bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046c2:	8b 40 10             	mov    0x10(%eax),%eax
801046c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  np->main_thread = np;
801046c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046ce:	89 50 7c             	mov    %edx,0x7c(%eax)

  acquire(&ptable.lock);
801046d1:	83 ec 0c             	sub    $0xc,%esp
801046d4:	68 e0 4d 11 80       	push   $0x80114de0
801046d9:	e8 9d 0e 00 00       	call   8010557b <acquire>
801046de:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
801046e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046e4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801046eb:	83 ec 0c             	sub    $0xc,%esp
801046ee:	68 e0 4d 11 80       	push   $0x80114de0
801046f3:	e8 f1 0e 00 00       	call   801055e9 <release>
801046f8:	83 c4 10             	add    $0x10,%esp

  return pid;
801046fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
801046fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104701:	5b                   	pop    %ebx
80104702:	5e                   	pop    %esi
80104703:	5f                   	pop    %edi
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    

80104706 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104706:	55                   	push   %ebp
80104707:	89 e5                	mov    %esp,%ebp
80104709:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010470c:	e8 68 fb ff ff       	call   80104279 <myproc>
80104711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if (curproc != curproc->main_thread){
80104714:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104717:	8b 40 7c             	mov    0x7c(%eax),%eax
8010471a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010471d:	74 0a                	je     80104729 <exit+0x23>
    thread_exit();
8010471f:	e8 58 0a 00 00       	call   8010517c <thread_exit>
    return;
80104724:	e9 12 01 00 00       	jmp    8010483b <exit+0x135>
  }
    
  if(curproc == initproc)
80104729:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010472e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104731:	75 0d                	jne    80104740 <exit+0x3a>
    panic("init exiting");
80104733:	83 ec 0c             	sub    $0xc,%esp
80104736:	68 42 8f 10 80       	push   $0x80108f42
8010473b:	e8 5c be ff ff       	call   8010059c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104740:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104747:	eb 3f                	jmp    80104788 <exit+0x82>
    if(curproc->ofile[fd]){
80104749:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010474c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010474f:	83 c2 08             	add    $0x8,%edx
80104752:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104756:	85 c0                	test   %eax,%eax
80104758:	74 2a                	je     80104784 <exit+0x7e>
      fileclose(curproc->ofile[fd]);
8010475a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010475d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104760:	83 c2 08             	add    $0x8,%edx
80104763:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104767:	83 ec 0c             	sub    $0xc,%esp
8010476a:	50                   	push   %eax
8010476b:	e8 45 c9 ff ff       	call   801010b5 <fileclose>
80104770:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104773:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104776:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104779:	83 c2 08             	add    $0x8,%edx
8010477c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104783:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104784:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104788:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010478c:	7e bb                	jle    80104749 <exit+0x43>
    }
  }

  begin_op();
8010478e:	e8 90 ed ff ff       	call   80103523 <begin_op>
  iput(curproc->cwd);
80104793:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104796:	8b 40 68             	mov    0x68(%eax),%eax
80104799:	83 ec 0c             	sub    $0xc,%esp
8010479c:	50                   	push   %eax
8010479d:	e8 c0 d3 ff ff       	call   80101b62 <iput>
801047a2:	83 c4 10             	add    $0x10,%esp
  end_op();
801047a5:	e8 05 ee ff ff       	call   801035af <end_op>
  curproc->cwd = 0;
801047aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ad:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 e0 4d 11 80       	push   $0x80114de0
801047bc:	e8 ba 0d 00 00       	call   8010557b <acquire>
801047c1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801047c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c7:	8b 40 14             	mov    0x14(%eax),%eax
801047ca:	83 ec 0c             	sub    $0xc,%esp
801047cd:	50                   	push   %eax
801047ce:	e8 c9 04 00 00       	call   80104c9c <wakeup1>
801047d3:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d6:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
801047dd:	eb 37                	jmp    80104816 <exit+0x110>
    if(p->parent == curproc){
801047df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e2:	8b 40 14             	mov    0x14(%eax),%eax
801047e5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801047e8:	75 28                	jne    80104812 <exit+0x10c>
      p->parent = initproc;
801047ea:	8b 15 60 c6 10 80    	mov    0x8010c660,%edx
801047f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801047f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f9:	8b 40 0c             	mov    0xc(%eax),%eax
801047fc:	83 f8 05             	cmp    $0x5,%eax
801047ff:	75 11                	jne    80104812 <exit+0x10c>
        wakeup1(initproc);
80104801:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80104806:	83 ec 0c             	sub    $0xc,%esp
80104809:	50                   	push   %eax
8010480a:	e8 8d 04 00 00       	call   80104c9c <wakeup1>
8010480f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104812:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104816:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
8010481d:	72 c0                	jb     801047df <exit+0xd9>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010481f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104822:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104829:	e8 8c 02 00 00       	call   80104aba <sched>
  panic("zombie exit");
8010482e:	83 ec 0c             	sub    $0xc,%esp
80104831:	68 4f 8f 10 80       	push   $0x80108f4f
80104836:	e8 61 bd ff ff       	call   8010059c <panic>
}
8010483b:	c9                   	leave  
8010483c:	c3                   	ret    

8010483d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010483d:	55                   	push   %ebp
8010483e:	89 e5                	mov    %esp,%ebp
80104840:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104843:	e8 31 fa ff ff       	call   80104279 <myproc>
80104848:	89 45 e8             	mov    %eax,-0x18(%ebp)

  struct proc * t;
  
  acquire(&ptable.lock);
8010484b:	83 ec 0c             	sub    $0xc,%esp
8010484e:	68 e0 4d 11 80       	push   $0x80114de0
80104853:	e8 23 0d 00 00       	call   8010557b <acquire>
80104858:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010485b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104862:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
80104869:	e9 46 01 00 00       	jmp    801049b4 <wait+0x177>
      if(p->parent != curproc || p->main_thread != p)
8010486e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104871:	8b 40 14             	mov    0x14(%eax),%eax
80104874:	39 45 e8             	cmp    %eax,-0x18(%ebp)
80104877:	0f 85 32 01 00 00    	jne    801049af <wait+0x172>
8010487d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104880:	8b 40 7c             	mov    0x7c(%eax),%eax
80104883:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104886:	0f 85 23 01 00 00    	jne    801049af <wait+0x172>
        continue;
      havekids = 1;
8010488c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104896:	8b 40 0c             	mov    0xc(%eax),%eax
80104899:	83 f8 05             	cmp    $0x5,%eax
8010489c:	0f 85 0e 01 00 00    	jne    801049b0 <wait+0x173>
        // Found one.
        for(t = ptable.proc; t < &ptable.proc[NPROC]; t++){
801048a2:	c7 45 ec 14 4e 11 80 	movl   $0x80114e14,-0x14(%ebp)
801048a9:	eb 7c                	jmp    80104927 <wait+0xea>
          if (t->main_thread == p && p->main_thread != p){
801048ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048ae:	8b 40 7c             	mov    0x7c(%eax),%eax
801048b1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801048b4:	75 6d                	jne    80104923 <wait+0xe6>
801048b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b9:	8b 40 7c             	mov    0x7c(%eax),%eax
801048bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801048bf:	74 62                	je     80104923 <wait+0xe6>
            cprintf("Reaped thread %d\n", t->pid);
801048c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048c4:	8b 40 10             	mov    0x10(%eax),%eax
801048c7:	83 ec 08             	sub    $0x8,%esp
801048ca:	50                   	push   %eax
801048cb:	68 5b 8f 10 80       	push   $0x80108f5b
801048d0:	e8 27 bb ff ff       	call   801003fc <cprintf>
801048d5:	83 c4 10             	add    $0x10,%esp
            kfree(t->kstack);
801048d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048db:	8b 40 08             	mov    0x8(%eax),%eax
801048de:	83 ec 0c             	sub    $0xc,%esp
801048e1:	50                   	push   %eax
801048e2:	e8 00 e3 ff ff       	call   80102be7 <kfree>
801048e7:	83 c4 10             	add    $0x10,%esp
            t->kstack = 0;
801048ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            t->pid = 0;
801048f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048f7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            t->parent = 0;
801048fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104901:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
            t->name[0] = 0;
80104908:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010490b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
            t->killed = 0;
8010490f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104912:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
            t->state = UNUSED;
80104919:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010491c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        for(t = ptable.proc; t < &ptable.proc[NPROC]; t++){
80104923:	83 6d ec 80          	subl   $0xffffff80,-0x14(%ebp)
80104927:	81 7d ec 14 6e 11 80 	cmpl   $0x80116e14,-0x14(%ebp)
8010492e:	0f 82 77 ff ff ff    	jb     801048ab <wait+0x6e>
          }
        }
        // cprintf("Reaped %d\n", p->pid);
        
        pid = p->pid;
80104934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104937:	8b 40 10             	mov    0x10(%eax),%eax
8010493a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(p->kstack);
8010493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104940:	8b 40 08             	mov    0x8(%eax),%eax
80104943:	83 ec 0c             	sub    $0xc,%esp
80104946:	50                   	push   %eax
80104947:	e8 9b e2 ff ff       	call   80102be7 <kfree>
8010494c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495c:	8b 40 04             	mov    0x4(%eax),%eax
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	50                   	push   %eax
80104963:	e8 a5 3e 00 00       	call   8010880d <freevm>
80104968:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104978:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010497f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104982:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104989:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

        release(&ptable.lock);
8010499a:	83 ec 0c             	sub    $0xc,%esp
8010499d:	68 e0 4d 11 80       	push   $0x80114de0
801049a2:	e8 42 0c 00 00       	call   801055e9 <release>
801049a7:	83 c4 10             	add    $0x10,%esp

        return pid;
801049aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049ad:	eb 51                	jmp    80104a00 <wait+0x1c3>
        continue;
801049af:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b0:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801049b4:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
801049bb:	0f 82 ad fe ff ff    	jb     8010486e <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801049c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801049c5:	74 0a                	je     801049d1 <wait+0x194>
801049c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049ca:	8b 40 24             	mov    0x24(%eax),%eax
801049cd:	85 c0                	test   %eax,%eax
801049cf:	74 17                	je     801049e8 <wait+0x1ab>
      release(&ptable.lock);
801049d1:	83 ec 0c             	sub    $0xc,%esp
801049d4:	68 e0 4d 11 80       	push   $0x80114de0
801049d9:	e8 0b 0c 00 00       	call   801055e9 <release>
801049de:	83 c4 10             	add    $0x10,%esp
      return -1;
801049e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e6:	eb 18                	jmp    80104a00 <wait+0x1c3>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801049e8:	83 ec 08             	sub    $0x8,%esp
801049eb:	68 e0 4d 11 80       	push   $0x80114de0
801049f0:	ff 75 e8             	push   -0x18(%ebp)
801049f3:	e8 fd 01 00 00       	call   80104bf5 <sleep>
801049f8:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801049fb:	e9 5b fe ff ff       	jmp    8010485b <wait+0x1e>
  }
}
80104a00:	c9                   	leave  
80104a01:	c3                   	ret    

80104a02 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a02:	55                   	push   %ebp
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104a08:	e8 f4 f7 ff ff       	call   80104201 <mycpu>
80104a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a1a:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a1d:	e8 99 f7 ff ff       	call   801041bb <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a22:	83 ec 0c             	sub    $0xc,%esp
80104a25:	68 e0 4d 11 80       	push   $0x80114de0
80104a2a:	e8 4c 0b 00 00       	call   8010557b <acquire>
80104a2f:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a32:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
80104a39:	eb 61                	jmp    80104a9c <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a41:	83 f8 03             	cmp    $0x3,%eax
80104a44:	75 51                	jne    80104a97 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	ff 75 f4             	push   -0xc(%ebp)
80104a58:	e8 09 39 00 00       	call   80108366 <switchuvm>
80104a5d:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a63:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a70:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a73:	83 c2 04             	add    $0x4,%edx
80104a76:	83 ec 08             	sub    $0x8,%esp
80104a79:	50                   	push   %eax
80104a7a:	52                   	push   %edx
80104a7b:	e8 f6 0f 00 00       	call   80105a76 <swtch>
80104a80:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104a83:	e8 c5 38 00 00       	call   8010834d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a92:	00 00 00 
80104a95:	eb 01                	jmp    80104a98 <scheduler+0x96>
        continue;
80104a97:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a98:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104a9c:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
80104aa3:	72 96                	jb     80104a3b <scheduler+0x39>
    }
    release(&ptable.lock);
80104aa5:	83 ec 0c             	sub    $0xc,%esp
80104aa8:	68 e0 4d 11 80       	push   $0x80114de0
80104aad:	e8 37 0b 00 00       	call   801055e9 <release>
80104ab2:	83 c4 10             	add    $0x10,%esp
    sti();
80104ab5:	e9 63 ff ff ff       	jmp    80104a1d <scheduler+0x1b>

80104aba <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104aba:	55                   	push   %ebp
80104abb:	89 e5                	mov    %esp,%ebp
80104abd:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104ac0:	e8 b4 f7 ff ff       	call   80104279 <myproc>
80104ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104ac8:	83 ec 0c             	sub    $0xc,%esp
80104acb:	68 e0 4d 11 80       	push   $0x80114de0
80104ad0:	e8 e0 0b 00 00       	call   801056b5 <holding>
80104ad5:	83 c4 10             	add    $0x10,%esp
80104ad8:	85 c0                	test   %eax,%eax
80104ada:	75 0d                	jne    80104ae9 <sched+0x2f>
    panic("sched ptable.lock");
80104adc:	83 ec 0c             	sub    $0xc,%esp
80104adf:	68 6d 8f 10 80       	push   $0x80108f6d
80104ae4:	e8 b3 ba ff ff       	call   8010059c <panic>
  if(mycpu()->ncli != 1)
80104ae9:	e8 13 f7 ff ff       	call   80104201 <mycpu>
80104aee:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af4:	83 f8 01             	cmp    $0x1,%eax
80104af7:	74 0d                	je     80104b06 <sched+0x4c>
    panic("sched locks");
80104af9:	83 ec 0c             	sub    $0xc,%esp
80104afc:	68 7f 8f 10 80       	push   $0x80108f7f
80104b01:	e8 96 ba ff ff       	call   8010059c <panic>
  if(p->state == RUNNING)
80104b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b09:	8b 40 0c             	mov    0xc(%eax),%eax
80104b0c:	83 f8 04             	cmp    $0x4,%eax
80104b0f:	75 0d                	jne    80104b1e <sched+0x64>
    panic("sched running");
80104b11:	83 ec 0c             	sub    $0xc,%esp
80104b14:	68 8b 8f 10 80       	push   $0x80108f8b
80104b19:	e8 7e ba ff ff       	call   8010059c <panic>
  if(readeflags()&FL_IF)
80104b1e:	e8 88 f6 ff ff       	call   801041ab <readeflags>
80104b23:	25 00 02 00 00       	and    $0x200,%eax
80104b28:	85 c0                	test   %eax,%eax
80104b2a:	74 0d                	je     80104b39 <sched+0x7f>
    panic("sched interruptible");
80104b2c:	83 ec 0c             	sub    $0xc,%esp
80104b2f:	68 99 8f 10 80       	push   $0x80108f99
80104b34:	e8 63 ba ff ff       	call   8010059c <panic>
  intena = mycpu()->intena;
80104b39:	e8 c3 f6 ff ff       	call   80104201 <mycpu>
80104b3e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104b47:	e8 b5 f6 ff ff       	call   80104201 <mycpu>
80104b4c:	8b 40 04             	mov    0x4(%eax),%eax
80104b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b52:	83 c2 1c             	add    $0x1c,%edx
80104b55:	83 ec 08             	sub    $0x8,%esp
80104b58:	50                   	push   %eax
80104b59:	52                   	push   %edx
80104b5a:	e8 17 0f 00 00       	call   80105a76 <swtch>
80104b5f:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104b62:	e8 9a f6 ff ff       	call   80104201 <mycpu>
80104b67:	89 c2                	mov    %eax,%edx
80104b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6c:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
}
80104b72:	90                   	nop
80104b73:	c9                   	leave  
80104b74:	c3                   	ret    

80104b75 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104b75:	55                   	push   %ebp
80104b76:	89 e5                	mov    %esp,%ebp
80104b78:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104b7b:	83 ec 0c             	sub    $0xc,%esp
80104b7e:	68 e0 4d 11 80       	push   $0x80114de0
80104b83:	e8 f3 09 00 00       	call   8010557b <acquire>
80104b88:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104b8b:	e8 e9 f6 ff ff       	call   80104279 <myproc>
80104b90:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104b97:	e8 1e ff ff ff       	call   80104aba <sched>
  release(&ptable.lock);
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	68 e0 4d 11 80       	push   $0x80114de0
80104ba4:	e8 40 0a 00 00       	call   801055e9 <release>
80104ba9:	83 c4 10             	add    $0x10,%esp
}
80104bac:	90                   	nop
80104bad:	c9                   	leave  
80104bae:	c3                   	ret    

80104baf <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104baf:	55                   	push   %ebp
80104bb0:	89 e5                	mov    %esp,%ebp
80104bb2:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104bb5:	83 ec 0c             	sub    $0xc,%esp
80104bb8:	68 e0 4d 11 80       	push   $0x80114de0
80104bbd:	e8 27 0a 00 00       	call   801055e9 <release>
80104bc2:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104bc5:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	74 24                	je     80104bf2 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104bce:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104bd5:	00 00 00 
    iinit(ROOTDEV);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	6a 01                	push   $0x1
80104bdd:	e8 ad ca ff ff       	call   8010168f <iinit>
80104be2:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104be5:	83 ec 0c             	sub    $0xc,%esp
80104be8:	6a 01                	push   $0x1
80104bea:	e8 16 e7 ff ff       	call   80103305 <initlog>
80104bef:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104bf2:	90                   	nop
80104bf3:	c9                   	leave  
80104bf4:	c3                   	ret    

80104bf5 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104bf5:	55                   	push   %ebp
80104bf6:	89 e5                	mov    %esp,%ebp
80104bf8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104bfb:	e8 79 f6 ff ff       	call   80104279 <myproc>
80104c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c07:	75 0d                	jne    80104c16 <sleep+0x21>
    panic("sleep");
80104c09:	83 ec 0c             	sub    $0xc,%esp
80104c0c:	68 ad 8f 10 80       	push   $0x80108fad
80104c11:	e8 86 b9 ff ff       	call   8010059c <panic>

  if(lk == 0)
80104c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c1a:	75 0d                	jne    80104c29 <sleep+0x34>
    panic("sleep without lk");
80104c1c:	83 ec 0c             	sub    $0xc,%esp
80104c1f:	68 b3 8f 10 80       	push   $0x80108fb3
80104c24:	e8 73 b9 ff ff       	call   8010059c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104c29:	81 7d 0c e0 4d 11 80 	cmpl   $0x80114de0,0xc(%ebp)
80104c30:	74 1e                	je     80104c50 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 e0 4d 11 80       	push   $0x80114de0
80104c3a:	e8 3c 09 00 00       	call   8010557b <acquire>
80104c3f:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104c42:	83 ec 0c             	sub    $0xc,%esp
80104c45:	ff 75 0c             	push   0xc(%ebp)
80104c48:	e8 9c 09 00 00       	call   801055e9 <release>
80104c4d:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c53:	8b 55 08             	mov    0x8(%ebp),%edx
80104c56:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104c63:	e8 52 fe ff ff       	call   80104aba <sched>

  // Tidy up.
  p->chan = 0;
80104c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c72:	81 7d 0c e0 4d 11 80 	cmpl   $0x80114de0,0xc(%ebp)
80104c79:	74 1e                	je     80104c99 <sleep+0xa4>
    release(&ptable.lock);
80104c7b:	83 ec 0c             	sub    $0xc,%esp
80104c7e:	68 e0 4d 11 80       	push   $0x80114de0
80104c83:	e8 61 09 00 00       	call   801055e9 <release>
80104c88:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	ff 75 0c             	push   0xc(%ebp)
80104c91:	e8 e5 08 00 00       	call   8010557b <acquire>
80104c96:	83 c4 10             	add    $0x10,%esp
  }
}
80104c99:	90                   	nop
80104c9a:	c9                   	leave  
80104c9b:	c3                   	ret    

80104c9c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104c9c:	55                   	push   %ebp
80104c9d:	89 e5                	mov    %esp,%ebp
80104c9f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ca2:	c7 45 fc 14 4e 11 80 	movl   $0x80114e14,-0x4(%ebp)
80104ca9:	eb 24                	jmp    80104ccf <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cae:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb1:	83 f8 02             	cmp    $0x2,%eax
80104cb4:	75 15                	jne    80104ccb <wakeup1+0x2f>
80104cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cb9:	8b 40 20             	mov    0x20(%eax),%eax
80104cbc:	39 45 08             	cmp    %eax,0x8(%ebp)
80104cbf:	75 0a                	jne    80104ccb <wakeup1+0x2f>
      p->state = RUNNABLE;
80104cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cc4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ccb:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104ccf:	81 7d fc 14 6e 11 80 	cmpl   $0x80116e14,-0x4(%ebp)
80104cd6:	72 d3                	jb     80104cab <wakeup1+0xf>
}
80104cd8:	90                   	nop
80104cd9:	c9                   	leave  
80104cda:	c3                   	ret    

80104cdb <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cdb:	55                   	push   %ebp
80104cdc:	89 e5                	mov    %esp,%ebp
80104cde:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ce1:	83 ec 0c             	sub    $0xc,%esp
80104ce4:	68 e0 4d 11 80       	push   $0x80114de0
80104ce9:	e8 8d 08 00 00       	call   8010557b <acquire>
80104cee:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104cf1:	83 ec 0c             	sub    $0xc,%esp
80104cf4:	ff 75 08             	push   0x8(%ebp)
80104cf7:	e8 a0 ff ff ff       	call   80104c9c <wakeup1>
80104cfc:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104cff:	83 ec 0c             	sub    $0xc,%esp
80104d02:	68 e0 4d 11 80       	push   $0x80114de0
80104d07:	e8 dd 08 00 00       	call   801055e9 <release>
80104d0c:	83 c4 10             	add    $0x10,%esp
}
80104d0f:	90                   	nop
80104d10:	c9                   	leave  
80104d11:	c3                   	ret    

80104d12 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d12:	55                   	push   %ebp
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	68 e0 4d 11 80       	push   $0x80114de0
80104d20:	e8 56 08 00 00       	call   8010557b <acquire>
80104d25:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d28:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
80104d2f:	eb 45                	jmp    80104d76 <kill+0x64>
    if(p->pid == pid){
80104d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d34:	8b 40 10             	mov    0x10(%eax),%eax
80104d37:	39 45 08             	cmp    %eax,0x8(%ebp)
80104d3a:	75 36                	jne    80104d72 <kill+0x60>
      p->killed = 1;
80104d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d49:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4c:	83 f8 02             	cmp    $0x2,%eax
80104d4f:	75 0a                	jne    80104d5b <kill+0x49>
        p->state = RUNNABLE;
80104d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d54:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d5b:	83 ec 0c             	sub    $0xc,%esp
80104d5e:	68 e0 4d 11 80       	push   $0x80114de0
80104d63:	e8 81 08 00 00       	call   801055e9 <release>
80104d68:	83 c4 10             	add    $0x10,%esp
      return 0;
80104d6b:	b8 00 00 00 00       	mov    $0x0,%eax
80104d70:	eb 22                	jmp    80104d94 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d72:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104d76:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
80104d7d:	72 b2                	jb     80104d31 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104d7f:	83 ec 0c             	sub    $0xc,%esp
80104d82:	68 e0 4d 11 80       	push   $0x80114de0
80104d87:	e8 5d 08 00 00       	call   801055e9 <release>
80104d8c:	83 c4 10             	add    $0x10,%esp
  return -1;
80104d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d94:	c9                   	leave  
80104d95:	c3                   	ret    

80104d96 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d96:	55                   	push   %ebp
80104d97:	89 e5                	mov    %esp,%ebp
80104d99:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d9c:	c7 45 f0 14 4e 11 80 	movl   $0x80114e14,-0x10(%ebp)
80104da3:	e9 d7 00 00 00       	jmp    80104e7f <procdump+0xe9>
    if(p->state == UNUSED)
80104da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dab:	8b 40 0c             	mov    0xc(%eax),%eax
80104dae:	85 c0                	test   %eax,%eax
80104db0:	0f 84 c4 00 00 00    	je     80104e7a <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db9:	8b 40 0c             	mov    0xc(%eax),%eax
80104dbc:	83 f8 05             	cmp    $0x5,%eax
80104dbf:	77 23                	ja     80104de4 <procdump+0x4e>
80104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dc4:	8b 40 0c             	mov    0xc(%eax),%eax
80104dc7:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104dce:	85 c0                	test   %eax,%eax
80104dd0:	74 12                	je     80104de4 <procdump+0x4e>
      state = states[p->state];
80104dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dd5:	8b 40 0c             	mov    0xc(%eax),%eax
80104dd8:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104de2:	eb 07                	jmp    80104deb <procdump+0x55>
    else
      state = "???";
80104de4:	c7 45 ec c4 8f 10 80 	movl   $0x80108fc4,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dee:	8d 50 6c             	lea    0x6c(%eax),%edx
80104df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104df4:	8b 40 10             	mov    0x10(%eax),%eax
80104df7:	52                   	push   %edx
80104df8:	ff 75 ec             	push   -0x14(%ebp)
80104dfb:	50                   	push   %eax
80104dfc:	68 c8 8f 10 80       	push   $0x80108fc8
80104e01:	e8 f6 b5 ff ff       	call   801003fc <cprintf>
80104e06:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e0c:	8b 40 0c             	mov    0xc(%eax),%eax
80104e0f:	83 f8 02             	cmp    $0x2,%eax
80104e12:	75 54                	jne    80104e68 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e17:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e1a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1d:	83 c0 08             	add    $0x8,%eax
80104e20:	89 c2                	mov    %eax,%edx
80104e22:	83 ec 08             	sub    $0x8,%esp
80104e25:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e28:	50                   	push   %eax
80104e29:	52                   	push   %edx
80104e2a:	e8 0c 08 00 00       	call   8010563b <getcallerpcs>
80104e2f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104e32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104e39:	eb 1c                	jmp    80104e57 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e42:	83 ec 08             	sub    $0x8,%esp
80104e45:	50                   	push   %eax
80104e46:	68 d1 8f 10 80       	push   $0x80108fd1
80104e4b:	e8 ac b5 ff ff       	call   801003fc <cprintf>
80104e50:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104e53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e57:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e5b:	7f 0b                	jg     80104e68 <procdump+0xd2>
80104e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e60:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e64:	85 c0                	test   %eax,%eax
80104e66:	75 d3                	jne    80104e3b <procdump+0xa5>
    }
    cprintf("\n");
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	68 d5 8f 10 80       	push   $0x80108fd5
80104e70:	e8 87 b5 ff ff       	call   801003fc <cprintf>
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	eb 01                	jmp    80104e7b <procdump+0xe5>
      continue;
80104e7a:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e7b:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104e7f:	81 7d f0 14 6e 11 80 	cmpl   $0x80116e14,-0x10(%ebp)
80104e86:	0f 82 1c ff ff ff    	jb     80104da8 <procdump+0x12>
  }
}
80104e8c:	90                   	nop
80104e8d:	c9                   	leave  
80104e8e:	c3                   	ret    

80104e8f <waitpid>:


int waitpid(int child_pid){
80104e8f:	55                   	push   %ebp
80104e90:	89 e5                	mov    %esp,%ebp
80104e92:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104e95:	e8 df f3 ff ff       	call   80104279 <myproc>
80104e9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	68 e0 4d 11 80       	push   $0x80114de0
80104ea5:	e8 d1 06 00 00       	call   8010557b <acquire>
80104eaa:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104ead:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eb4:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
80104ebb:	e9 a1 00 00 00       	jmp    80104f61 <waitpid+0xd2>
      if(p->pid != child_pid)
80104ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec3:	8b 40 10             	mov    0x10(%eax),%eax
80104ec6:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ec9:	0f 85 8d 00 00 00    	jne    80104f5c <waitpid+0xcd>
        continue;
      havekids = 1;
80104ecf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed9:	8b 40 0c             	mov    0xc(%eax),%eax
80104edc:	83 f8 05             	cmp    $0x5,%eax
80104edf:	75 7c                	jne    80104f5d <waitpid+0xce>
        // Found the pid
        pid = p->pid;
80104ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee4:	8b 40 10             	mov    0x10(%eax),%eax
80104ee7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eed:	8b 40 08             	mov    0x8(%eax),%eax
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	50                   	push   %eax
80104ef4:	e8 ee dc ff ff       	call   80102be7 <kfree>
80104ef9:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f09:	8b 40 04             	mov    0x4(%eax),%eax
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	50                   	push   %eax
80104f10:	e8 f8 38 00 00       	call   8010880d <freevm>
80104f15:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f25:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f36:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f40:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104f47:	83 ec 0c             	sub    $0xc,%esp
80104f4a:	68 e0 4d 11 80       	push   $0x80114de0
80104f4f:	e8 95 06 00 00       	call   801055e9 <release>
80104f54:	83 c4 10             	add    $0x10,%esp
        return pid;
80104f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104f5a:	eb 51                	jmp    80104fad <waitpid+0x11e>
        continue;
80104f5c:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f5d:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104f61:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
80104f68:	0f 82 52 ff ff ff    	jb     80104ec0 <waitpid+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f72:	74 0a                	je     80104f7e <waitpid+0xef>
80104f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f77:	8b 40 24             	mov    0x24(%eax),%eax
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	74 17                	je     80104f95 <waitpid+0x106>
      release(&ptable.lock);
80104f7e:	83 ec 0c             	sub    $0xc,%esp
80104f81:	68 e0 4d 11 80       	push   $0x80114de0
80104f86:	e8 5e 06 00 00       	call   801055e9 <release>
80104f8b:	83 c4 10             	add    $0x10,%esp
      return -1;
80104f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f93:	eb 18                	jmp    80104fad <waitpid+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104f95:	83 ec 08             	sub    $0x8,%esp
80104f98:	68 e0 4d 11 80       	push   $0x80114de0
80104f9d:	ff 75 ec             	push   -0x14(%ebp)
80104fa0:	e8 50 fc ff ff       	call   80104bf5 <sleep>
80104fa5:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104fa8:	e9 00 ff ff ff       	jmp    80104ead <waitpid+0x1e>
  }
}
80104fad:	c9                   	leave  
80104fae:	c3                   	ret    

80104faf <thread_create>:

int thread_create(uint* tid, void* func_ptr, void * arg_ptr){
80104faf:	55                   	push   %ebp
80104fb0:	89 e5                	mov    %esp,%ebp
80104fb2:	57                   	push   %edi
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	83 ec 2c             	sub    $0x2c,%esp
  int * val = (int*)arg_ptr;
80104fb8:	8b 45 10             	mov    0x10(%ebp),%eax
80104fbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104fbe:	e8 b6 f2 ff ff       	call   80104279 <myproc>
80104fc3:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104fc6:	e8 d7 f2 ff ff       	call   801042a2 <allocproc>
80104fcb:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104fce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104fd2:	75 0a                	jne    80104fde <thread_create+0x2f>
    return -1;
80104fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd9:	e9 96 01 00 00       	jmp    80105174 <thread_create+0x1c5>
  }
  np->main_thread = myproc();
80104fde:	e8 96 f2 ff ff       	call   80104279 <myproc>
80104fe3:	89 c2                	mov    %eax,%edx
80104fe5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104fe8:	89 50 7c             	mov    %edx,0x7c(%eax)
  uint mem = (uint)curproc->sz;
80104feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104fee:	8b 00                	mov    (%eax),%eax
80104ff0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  // map
  // map_stack(curproc->pgdir, (void *)curproc->sz, mem, PTE_W | PTE_U);
  curproc->sz = allocuvm(curproc->pgdir, mem, mem + PGSIZE);
80104ff3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ff6:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80104ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104fff:	8b 40 04             	mov    0x4(%eax),%eax
80105002:	83 ec 04             	sub    $0x4,%esp
80105005:	52                   	push   %edx
80105006:	ff 75 d4             	push   -0x2c(%ebp)
80105009:	50                   	push   %eax
8010500a:	e8 35 36 00 00       	call   80108644 <allocuvm>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	89 c2                	mov    %eax,%edx
80105014:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105017:	89 10                	mov    %edx,(%eax)
  
  np->pgdir = curproc->pgdir; 
80105019:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010501c:	8b 50 04             	mov    0x4(%eax),%edx
8010501f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105022:	89 50 04             	mov    %edx,0x4(%eax)
  
  np->sz = curproc->sz;
80105025:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105028:	8b 10                	mov    (%eax),%edx
8010502a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010502d:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010502f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105032:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105035:	89 50 14             	mov    %edx,0x14(%eax)
  
  *np->tf = *curproc->tf;
80105038:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010503b:	8b 48 18             	mov    0x18(%eax),%ecx
8010503e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105041:	8b 40 18             	mov    0x18(%eax),%eax
80105044:	89 c2                	mov    %eax,%edx
80105046:	89 cb                	mov    %ecx,%ebx
80105048:	b8 13 00 00 00       	mov    $0x13,%eax
8010504d:	89 d7                	mov    %edx,%edi
8010504f:	89 de                	mov    %ebx,%esi
80105051:	89 c1                	mov    %eax,%ecx
80105053:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->esp = mem + PGSIZE;
80105055:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105058:	8b 40 18             	mov    0x18(%eax),%eax
8010505b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010505e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80105064:	89 50 44             	mov    %edx,0x44(%eax)
  np->tf->eip = (uint)func_ptr;
80105067:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010506a:	8b 40 18             	mov    0x18(%eax),%eax
8010506d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105070:	89 50 38             	mov    %edx,0x38(%eax)

  np->tf->esp -= 2 * sizeof(void*);
80105073:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105076:	8b 40 18             	mov    0x18(%eax),%eax
80105079:	8b 50 44             	mov    0x44(%eax),%edx
8010507c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010507f:	8b 40 18             	mov    0x18(%eax),%eax
80105082:	83 ea 08             	sub    $0x8,%edx
80105085:	89 50 44             	mov    %edx,0x44(%eax)
  uint * sptr = (uint *)np->tf->esp;
80105088:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010508b:	8b 40 18             	mov    0x18(%eax),%eax
8010508e:	8b 40 44             	mov    0x44(%eax),%eax
80105091:	89 45 d0             	mov    %eax,-0x30(%ebp)
  sptr[0] = 0xffffffff;
80105094:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105097:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  sptr[1] = (uint)arg_ptr;
8010509d:	8b 45 d0             	mov    -0x30(%ebp),%eax
801050a0:	8d 50 04             	lea    0x4(%eax),%edx
801050a3:	8b 45 10             	mov    0x10(%ebp),%eax
801050a6:	89 02                	mov    %eax,(%edx)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801050a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801050ab:	8b 40 18             	mov    0x18(%eax),%eax
801050ae:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801050b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801050bc:	eb 3d                	jmp    801050fb <thread_create+0x14c>
    if(curproc->ofile[i])
801050be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801050c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050c4:	83 c2 08             	add    $0x8,%edx
801050c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050cb:	85 c0                	test   %eax,%eax
801050cd:	74 28                	je     801050f7 <thread_create+0x148>
      np->ofile[i] = filedup(curproc->ofile[i]);
801050cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801050d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050d5:	83 c2 08             	add    $0x8,%edx
801050d8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050dc:	83 ec 0c             	sub    $0xc,%esp
801050df:	50                   	push   %eax
801050e0:	e8 7f bf ff ff       	call   80101064 <filedup>
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	89 c1                	mov    %eax,%ecx
801050ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
801050ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050f0:	83 c2 08             	add    $0x8,%edx
801050f3:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
801050f7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801050fb:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801050ff:	7e bd                	jle    801050be <thread_create+0x10f>
  np->cwd = idup(curproc->cwd);
80105101:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105104:	8b 40 68             	mov    0x68(%eax),%eax
80105107:	83 ec 0c             	sub    $0xc,%esp
8010510a:	50                   	push   %eax
8010510b:	e8 b7 c8 ff ff       	call   801019c7 <idup>
80105110:	83 c4 10             	add    $0x10,%esp
80105113:	89 c2                	mov    %eax,%edx
80105115:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105118:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010511b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010511e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105121:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105124:	83 c0 6c             	add    $0x6c,%eax
80105127:	83 ec 04             	sub    $0x4,%esp
8010512a:	6a 10                	push   $0x10
8010512c:	52                   	push   %edx
8010512d:	50                   	push   %eax
8010512e:	e8 d2 08 00 00       	call   80105a05 <safestrcpy>
80105133:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80105136:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105139:	8b 40 10             	mov    0x10(%eax),%eax
8010513c:	89 45 cc             	mov    %eax,-0x34(%ebp)

  acquire(&ptable.lock);
8010513f:	83 ec 0c             	sub    $0xc,%esp
80105142:	68 e0 4d 11 80       	push   $0x80114de0
80105147:	e8 2f 04 00 00       	call   8010557b <acquire>
8010514c:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
8010514f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105152:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	68 e0 4d 11 80       	push   $0x80114de0
80105161:	e8 83 04 00 00       	call   801055e9 <release>
80105166:	83 c4 10             	add    $0x10,%esp
  *tid = pid;
80105169:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010516c:	8b 45 08             	mov    0x8(%ebp),%eax
8010516f:	89 10                	mov    %edx,(%eax)
  return pid;
80105171:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
80105174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105177:	5b                   	pop    %ebx
80105178:	5e                   	pop    %esi
80105179:	5f                   	pop    %edi
8010517a:	5d                   	pop    %ebp
8010517b:	c3                   	ret    

8010517c <thread_exit>:


int thread_exit(void){
8010517c:	55                   	push   %ebp
8010517d:	89 e5                	mov    %esp,%ebp
8010517f:	53                   	push   %ebx
80105180:	83 ec 14             	sub    $0x14,%esp
  // cprintf("thread exit called\n");
  if (myproc()->main_thread == myproc()){
80105183:	e8 f1 f0 ff ff       	call   80104279 <myproc>
80105188:	8b 58 7c             	mov    0x7c(%eax),%ebx
8010518b:	e8 e9 f0 ff ff       	call   80104279 <myproc>
80105190:	39 c3                	cmp    %eax,%ebx
80105192:	75 0a                	jne    8010519e <thread_exit+0x22>
    return -1;
80105194:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105199:	e9 1a 01 00 00       	jmp    801052b8 <thread_exit+0x13c>
  }
  
  struct proc *curproc = myproc();
8010519e:	e8 d6 f0 ff ff       	call   80104279 <myproc>
801051a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
801051a6:	a1 60 c6 10 80       	mov    0x8010c660,%eax
801051ab:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801051ae:	75 0d                	jne    801051bd <thread_exit+0x41>
    panic("init exiting");
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	68 42 8f 10 80       	push   $0x80108f42
801051b8:	e8 df b3 ff ff       	call   8010059c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801051bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801051c4:	eb 3f                	jmp    80105205 <thread_exit+0x89>
    if(curproc->ofile[fd]){
801051c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051cc:	83 c2 08             	add    $0x8,%edx
801051cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051d3:	85 c0                	test   %eax,%eax
801051d5:	74 2a                	je     80105201 <thread_exit+0x85>
      fileclose(curproc->ofile[fd]);
801051d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051da:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051dd:	83 c2 08             	add    $0x8,%edx
801051e0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	50                   	push   %eax
801051e8:	e8 c8 be ff ff       	call   801010b5 <fileclose>
801051ed:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801051f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051f6:	83 c2 08             	add    $0x8,%edx
801051f9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105200:	00 
  for(fd = 0; fd < NOFILE; fd++){
80105201:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105205:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105209:	7e bb                	jle    801051c6 <thread_exit+0x4a>
    }
  }

  begin_op();
8010520b:	e8 13 e3 ff ff       	call   80103523 <begin_op>
  iput(curproc->cwd);
80105210:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105213:	8b 40 68             	mov    0x68(%eax),%eax
80105216:	83 ec 0c             	sub    $0xc,%esp
80105219:	50                   	push   %eax
8010521a:	e8 43 c9 ff ff       	call   80101b62 <iput>
8010521f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105222:	e8 88 e3 ff ff       	call   801035af <end_op>
  curproc->cwd = 0;
80105227:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010522a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80105231:	83 ec 0c             	sub    $0xc,%esp
80105234:	68 e0 4d 11 80       	push   $0x80114de0
80105239:	e8 3d 03 00 00       	call   8010557b <acquire>
8010523e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80105241:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105244:	8b 40 14             	mov    0x14(%eax),%eax
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	50                   	push   %eax
8010524b:	e8 4c fa ff ff       	call   80104c9c <wakeup1>
80105250:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105253:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
8010525a:	eb 37                	jmp    80105293 <thread_exit+0x117>
    if(p->parent == curproc){
8010525c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525f:	8b 40 14             	mov    0x14(%eax),%eax
80105262:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80105265:	75 28                	jne    8010528f <thread_exit+0x113>
      p->parent = initproc;
80105267:	8b 15 60 c6 10 80    	mov    0x8010c660,%edx
8010526d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105270:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80105273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105276:	8b 40 0c             	mov    0xc(%eax),%eax
80105279:	83 f8 05             	cmp    $0x5,%eax
8010527c:	75 11                	jne    8010528f <thread_exit+0x113>
        wakeup1(initproc);
8010527e:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	50                   	push   %eax
80105287:	e8 10 fa ff ff       	call   80104c9c <wakeup1>
8010528c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010528f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80105293:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
8010529a:	72 c0                	jb     8010525c <thread_exit+0xe0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010529c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010529f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  // cprintf("Thread %d exitting\n", curproc->pid);
  sched();
801052a6:	e8 0f f8 ff ff       	call   80104aba <sched>
  panic("zombie exit");
801052ab:	83 ec 0c             	sub    $0xc,%esp
801052ae:	68 4f 8f 10 80       	push   $0x80108f4f
801052b3:	e8 e4 b2 ff ff       	call   8010059c <panic>

}
801052b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052bb:	c9                   	leave  
801052bc:	c3                   	ret    

801052bd <thread_join>:

int thread_join(uint tid){
801052bd:	55                   	push   %ebp
801052be:	89 e5                	mov    %esp,%ebp
801052c0:	83 ec 18             	sub    $0x18,%esp
  
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801052c3:	e8 b1 ef ff ff       	call   80104279 <myproc>
801052c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	68 e0 4d 11 80       	push   $0x80114de0
801052d3:	e8 a3 02 00 00       	call   8010557b <acquire>
801052d8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801052db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052e2:	c7 45 f4 14 4e 11 80 	movl   $0x80114e14,-0xc(%ebp)
801052e9:	e9 9a 00 00 00       	jmp    80105388 <thread_join+0xcb>
      if(p->pid != tid || p->main_thread != curproc)
801052ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f1:	8b 40 10             	mov    0x10(%eax),%eax
801052f4:	39 45 08             	cmp    %eax,0x8(%ebp)
801052f7:	0f 85 86 00 00 00    	jne    80105383 <thread_join+0xc6>
801052fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105300:	8b 40 7c             	mov    0x7c(%eax),%eax
80105303:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80105306:	75 7b                	jne    80105383 <thread_join+0xc6>
        continue;
      havekids = 1;
80105308:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010530f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105312:	8b 40 0c             	mov    0xc(%eax),%eax
80105315:	83 f8 05             	cmp    $0x5,%eax
80105318:	75 6a                	jne    80105384 <thread_join+0xc7>
        // Found the pid
        pid = p->pid;
8010531a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531d:	8b 40 10             	mov    0x10(%eax),%eax
80105320:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105326:	8b 40 08             	mov    0x8(%eax),%eax
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 b5 d8 ff ff       	call   80102be7 <kfree>
80105332:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        p->pid = 0;
8010533f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105342:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80105349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80105353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105356:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535d:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80105364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105367:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010536e:	83 ec 0c             	sub    $0xc,%esp
80105371:	68 e0 4d 11 80       	push   $0x80114de0
80105376:	e8 6e 02 00 00       	call   801055e9 <release>
8010537b:	83 c4 10             	add    $0x10,%esp
        return pid;
8010537e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105381:	eb 51                	jmp    801053d4 <thread_join+0x117>
        continue;
80105383:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105384:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80105388:	81 7d f4 14 6e 11 80 	cmpl   $0x80116e14,-0xc(%ebp)
8010538f:	0f 82 59 ff ff ff    	jb     801052ee <thread_join+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80105395:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105399:	74 0a                	je     801053a5 <thread_join+0xe8>
8010539b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010539e:	8b 40 24             	mov    0x24(%eax),%eax
801053a1:	85 c0                	test   %eax,%eax
801053a3:	74 17                	je     801053bc <thread_join+0xff>
      release(&ptable.lock);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	68 e0 4d 11 80       	push   $0x80114de0
801053ad:	e8 37 02 00 00       	call   801055e9 <release>
801053b2:	83 c4 10             	add    $0x10,%esp
      return -1;
801053b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ba:	eb 18                	jmp    801053d4 <thread_join+0x117>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801053bc:	83 ec 08             	sub    $0x8,%esp
801053bf:	68 e0 4d 11 80       	push   $0x80114de0
801053c4:	ff 75 ec             	push   -0x14(%ebp)
801053c7:	e8 29 f8 ff ff       	call   80104bf5 <sleep>
801053cc:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801053cf:	e9 07 ff ff ff       	jmp    801052db <thread_join+0x1e>
  }
801053d4:	c9                   	leave  
801053d5:	c3                   	ret    

801053d6 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801053d6:	55                   	push   %ebp
801053d7:	89 e5                	mov    %esp,%ebp
801053d9:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801053dc:	8b 45 08             	mov    0x8(%ebp),%eax
801053df:	83 c0 04             	add    $0x4,%eax
801053e2:	83 ec 08             	sub    $0x8,%esp
801053e5:	68 01 90 10 80       	push   $0x80109001
801053ea:	50                   	push   %eax
801053eb:	e8 69 01 00 00       	call   80105559 <initlock>
801053f0:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801053f3:	8b 45 08             	mov    0x8(%ebp),%eax
801053f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801053f9:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801053fc:	8b 45 08             	mov    0x8(%ebp),%eax
801053ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105405:	8b 45 08             	mov    0x8(%ebp),%eax
80105408:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010540f:	90                   	nop
80105410:	c9                   	leave  
80105411:	c3                   	ret    

80105412 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105412:	55                   	push   %ebp
80105413:	89 e5                	mov    %esp,%ebp
80105415:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105418:	8b 45 08             	mov    0x8(%ebp),%eax
8010541b:	83 c0 04             	add    $0x4,%eax
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	50                   	push   %eax
80105422:	e8 54 01 00 00       	call   8010557b <acquire>
80105427:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010542a:	eb 15                	jmp    80105441 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
8010542c:	8b 45 08             	mov    0x8(%ebp),%eax
8010542f:	83 c0 04             	add    $0x4,%eax
80105432:	83 ec 08             	sub    $0x8,%esp
80105435:	50                   	push   %eax
80105436:	ff 75 08             	push   0x8(%ebp)
80105439:	e8 b7 f7 ff ff       	call   80104bf5 <sleep>
8010543e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105441:	8b 45 08             	mov    0x8(%ebp),%eax
80105444:	8b 00                	mov    (%eax),%eax
80105446:	85 c0                	test   %eax,%eax
80105448:	75 e2                	jne    8010542c <acquiresleep+0x1a>
  }
  lk->locked = 1;
8010544a:	8b 45 08             	mov    0x8(%ebp),%eax
8010544d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80105453:	e8 21 ee ff ff       	call   80104279 <myproc>
80105458:	8b 50 10             	mov    0x10(%eax),%edx
8010545b:	8b 45 08             	mov    0x8(%ebp),%eax
8010545e:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105461:	8b 45 08             	mov    0x8(%ebp),%eax
80105464:	83 c0 04             	add    $0x4,%eax
80105467:	83 ec 0c             	sub    $0xc,%esp
8010546a:	50                   	push   %eax
8010546b:	e8 79 01 00 00       	call   801055e9 <release>
80105470:	83 c4 10             	add    $0x10,%esp
}
80105473:	90                   	nop
80105474:	c9                   	leave  
80105475:	c3                   	ret    

80105476 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105476:	55                   	push   %ebp
80105477:	89 e5                	mov    %esp,%ebp
80105479:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010547c:	8b 45 08             	mov    0x8(%ebp),%eax
8010547f:	83 c0 04             	add    $0x4,%eax
80105482:	83 ec 0c             	sub    $0xc,%esp
80105485:	50                   	push   %eax
80105486:	e8 f0 00 00 00       	call   8010557b <acquire>
8010548b:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
8010548e:	8b 45 08             	mov    0x8(%ebp),%eax
80105491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105497:	8b 45 08             	mov    0x8(%ebp),%eax
8010549a:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	ff 75 08             	push   0x8(%ebp)
801054a7:	e8 2f f8 ff ff       	call   80104cdb <wakeup>
801054ac:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801054af:	8b 45 08             	mov    0x8(%ebp),%eax
801054b2:	83 c0 04             	add    $0x4,%eax
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	50                   	push   %eax
801054b9:	e8 2b 01 00 00       	call   801055e9 <release>
801054be:	83 c4 10             	add    $0x10,%esp
}
801054c1:	90                   	nop
801054c2:	c9                   	leave  
801054c3:	c3                   	ret    

801054c4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801054c4:	55                   	push   %ebp
801054c5:	89 e5                	mov    %esp,%ebp
801054c7:	53                   	push   %ebx
801054c8:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
801054cb:	8b 45 08             	mov    0x8(%ebp),%eax
801054ce:	83 c0 04             	add    $0x4,%eax
801054d1:	83 ec 0c             	sub    $0xc,%esp
801054d4:	50                   	push   %eax
801054d5:	e8 a1 00 00 00       	call   8010557b <acquire>
801054da:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
801054dd:	8b 45 08             	mov    0x8(%ebp),%eax
801054e0:	8b 00                	mov    (%eax),%eax
801054e2:	85 c0                	test   %eax,%eax
801054e4:	74 19                	je     801054ff <holdingsleep+0x3b>
801054e6:	8b 45 08             	mov    0x8(%ebp),%eax
801054e9:	8b 58 3c             	mov    0x3c(%eax),%ebx
801054ec:	e8 88 ed ff ff       	call   80104279 <myproc>
801054f1:	8b 40 10             	mov    0x10(%eax),%eax
801054f4:	39 c3                	cmp    %eax,%ebx
801054f6:	75 07                	jne    801054ff <holdingsleep+0x3b>
801054f8:	b8 01 00 00 00       	mov    $0x1,%eax
801054fd:	eb 05                	jmp    80105504 <holdingsleep+0x40>
801054ff:	b8 00 00 00 00       	mov    $0x0,%eax
80105504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105507:	8b 45 08             	mov    0x8(%ebp),%eax
8010550a:	83 c0 04             	add    $0x4,%eax
8010550d:	83 ec 0c             	sub    $0xc,%esp
80105510:	50                   	push   %eax
80105511:	e8 d3 00 00 00       	call   801055e9 <release>
80105516:	83 c4 10             	add    $0x10,%esp
  return r;
80105519:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010551c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010551f:	c9                   	leave  
80105520:	c3                   	ret    

80105521 <readeflags>:
{
80105521:	55                   	push   %ebp
80105522:	89 e5                	mov    %esp,%ebp
80105524:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105527:	9c                   	pushf  
80105528:	58                   	pop    %eax
80105529:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010552c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010552f:	c9                   	leave  
80105530:	c3                   	ret    

80105531 <cli>:
{
80105531:	55                   	push   %ebp
80105532:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105534:	fa                   	cli    
}
80105535:	90                   	nop
80105536:	5d                   	pop    %ebp
80105537:	c3                   	ret    

80105538 <sti>:
{
80105538:	55                   	push   %ebp
80105539:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010553b:	fb                   	sti    
}
8010553c:	90                   	nop
8010553d:	5d                   	pop    %ebp
8010553e:	c3                   	ret    

8010553f <xchg>:
{
8010553f:	55                   	push   %ebp
80105540:	89 e5                	mov    %esp,%ebp
80105542:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105545:	8b 55 08             	mov    0x8(%ebp),%edx
80105548:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010554e:	f0 87 02             	lock xchg %eax,(%edx)
80105551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105554:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105557:	c9                   	leave  
80105558:	c3                   	ret    

80105559 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105559:	55                   	push   %ebp
8010555a:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010555c:	8b 45 08             	mov    0x8(%ebp),%eax
8010555f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105562:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105565:	8b 45 08             	mov    0x8(%ebp),%eax
80105568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010556e:	8b 45 08             	mov    0x8(%ebp),%eax
80105571:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105578:	90                   	nop
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    

8010557b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010557b:	55                   	push   %ebp
8010557c:	89 e5                	mov    %esp,%ebp
8010557e:	53                   	push   %ebx
8010557f:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105582:	e8 6f 01 00 00       	call   801056f6 <pushcli>
  if(holding(lk))
80105587:	8b 45 08             	mov    0x8(%ebp),%eax
8010558a:	83 ec 0c             	sub    $0xc,%esp
8010558d:	50                   	push   %eax
8010558e:	e8 22 01 00 00       	call   801056b5 <holding>
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	74 0d                	je     801055a7 <acquire+0x2c>
    panic("acquire");
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	68 0c 90 10 80       	push   $0x8010900c
801055a2:	e8 f5 af ff ff       	call   8010059c <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801055a7:	90                   	nop
801055a8:	8b 45 08             	mov    0x8(%ebp),%eax
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	6a 01                	push   $0x1
801055b0:	50                   	push   %eax
801055b1:	e8 89 ff ff ff       	call   8010553f <xchg>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	75 eb                	jne    801055a8 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801055bd:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801055c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055c5:	e8 37 ec ff ff       	call   80104201 <mycpu>
801055ca:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801055cd:	8b 45 08             	mov    0x8(%ebp),%eax
801055d0:	83 c0 0c             	add    $0xc,%eax
801055d3:	83 ec 08             	sub    $0x8,%esp
801055d6:	50                   	push   %eax
801055d7:	8d 45 08             	lea    0x8(%ebp),%eax
801055da:	50                   	push   %eax
801055db:	e8 5b 00 00 00       	call   8010563b <getcallerpcs>
801055e0:	83 c4 10             	add    $0x10,%esp
}
801055e3:	90                   	nop
801055e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e7:	c9                   	leave  
801055e8:	c3                   	ret    

801055e9 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055e9:	55                   	push   %ebp
801055ea:	89 e5                	mov    %esp,%ebp
801055ec:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801055ef:	83 ec 0c             	sub    $0xc,%esp
801055f2:	ff 75 08             	push   0x8(%ebp)
801055f5:	e8 bb 00 00 00       	call   801056b5 <holding>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	75 0d                	jne    8010560e <release+0x25>
    panic("release");
80105601:	83 ec 0c             	sub    $0xc,%esp
80105604:	68 14 90 10 80       	push   $0x80109014
80105609:	e8 8e af ff ff       	call   8010059c <panic>

  lk->pcs[0] = 0;
8010560e:	8b 45 08             	mov    0x8(%ebp),%eax
80105611:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105618:	8b 45 08             	mov    0x8(%ebp),%eax
8010561b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105622:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105627:	8b 45 08             	mov    0x8(%ebp),%eax
8010562a:	8b 55 08             	mov    0x8(%ebp),%edx
8010562d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105633:	e8 0c 01 00 00       	call   80105744 <popcli>
}
80105638:	90                   	nop
80105639:	c9                   	leave  
8010563a:	c3                   	ret    

8010563b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010563b:	55                   	push   %ebp
8010563c:	89 e5                	mov    %esp,%ebp
8010563e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105641:	8b 45 08             	mov    0x8(%ebp),%eax
80105644:	83 e8 08             	sub    $0x8,%eax
80105647:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010564a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105651:	eb 38                	jmp    8010568b <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105653:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105657:	74 53                	je     801056ac <getcallerpcs+0x71>
80105659:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105660:	76 4a                	jbe    801056ac <getcallerpcs+0x71>
80105662:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105666:	74 44                	je     801056ac <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105668:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010566b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105672:	8b 45 0c             	mov    0xc(%ebp),%eax
80105675:	01 c2                	add    %eax,%edx
80105677:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010567a:	8b 40 04             	mov    0x4(%eax),%eax
8010567d:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010567f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105682:	8b 00                	mov    (%eax),%eax
80105684:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105687:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010568b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010568f:	7e c2                	jle    80105653 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105691:	eb 19                	jmp    801056ac <getcallerpcs+0x71>
    pcs[i] = 0;
80105693:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010569d:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a0:	01 d0                	add    %edx,%eax
801056a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056a8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056ac:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056b0:	7e e1                	jle    80105693 <getcallerpcs+0x58>
}
801056b2:	90                   	nop
801056b3:	c9                   	leave  
801056b4:	c3                   	ret    

801056b5 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056b5:	55                   	push   %ebp
801056b6:	89 e5                	mov    %esp,%ebp
801056b8:	53                   	push   %ebx
801056b9:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801056bc:	e8 35 00 00 00       	call   801056f6 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801056c1:	8b 45 08             	mov    0x8(%ebp),%eax
801056c4:	8b 00                	mov    (%eax),%eax
801056c6:	85 c0                	test   %eax,%eax
801056c8:	74 16                	je     801056e0 <holding+0x2b>
801056ca:	8b 45 08             	mov    0x8(%ebp),%eax
801056cd:	8b 58 08             	mov    0x8(%eax),%ebx
801056d0:	e8 2c eb ff ff       	call   80104201 <mycpu>
801056d5:	39 c3                	cmp    %eax,%ebx
801056d7:	75 07                	jne    801056e0 <holding+0x2b>
801056d9:	b8 01 00 00 00       	mov    $0x1,%eax
801056de:	eb 05                	jmp    801056e5 <holding+0x30>
801056e0:	b8 00 00 00 00       	mov    $0x0,%eax
801056e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
801056e8:	e8 57 00 00 00       	call   80105744 <popcli>
  return r;
801056ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801056f0:	83 c4 14             	add    $0x14,%esp
801056f3:	5b                   	pop    %ebx
801056f4:	5d                   	pop    %ebp
801056f5:	c3                   	ret    

801056f6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056f6:	55                   	push   %ebp
801056f7:	89 e5                	mov    %esp,%ebp
801056f9:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801056fc:	e8 20 fe ff ff       	call   80105521 <readeflags>
80105701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105704:	e8 28 fe ff ff       	call   80105531 <cli>
  if(mycpu()->ncli == 0)
80105709:	e8 f3 ea ff ff       	call   80104201 <mycpu>
8010570e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105714:	85 c0                	test   %eax,%eax
80105716:	75 15                	jne    8010572d <pushcli+0x37>
    mycpu()->intena = eflags & FL_IF;
80105718:	e8 e4 ea ff ff       	call   80104201 <mycpu>
8010571d:	89 c2                	mov    %eax,%edx
8010571f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105722:	25 00 02 00 00       	and    $0x200,%eax
80105727:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
  mycpu()->ncli += 1;
8010572d:	e8 cf ea ff ff       	call   80104201 <mycpu>
80105732:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105738:	83 c2 01             	add    $0x1,%edx
8010573b:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105741:	90                   	nop
80105742:	c9                   	leave  
80105743:	c3                   	ret    

80105744 <popcli>:

void
popcli(void)
{
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010574a:	e8 d2 fd ff ff       	call   80105521 <readeflags>
8010574f:	25 00 02 00 00       	and    $0x200,%eax
80105754:	85 c0                	test   %eax,%eax
80105756:	74 0d                	je     80105765 <popcli+0x21>
    panic("popcli - interruptible");
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	68 1c 90 10 80       	push   $0x8010901c
80105760:	e8 37 ae ff ff       	call   8010059c <panic>
  if(--mycpu()->ncli < 0)
80105765:	e8 97 ea ff ff       	call   80104201 <mycpu>
8010576a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105770:	83 ea 01             	sub    $0x1,%edx
80105773:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105779:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010577f:	85 c0                	test   %eax,%eax
80105781:	79 0d                	jns    80105790 <popcli+0x4c>
    panic("popcli");
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	68 33 90 10 80       	push   $0x80109033
8010578b:	e8 0c ae ff ff       	call   8010059c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105790:	e8 6c ea ff ff       	call   80104201 <mycpu>
80105795:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010579b:	85 c0                	test   %eax,%eax
8010579d:	75 14                	jne    801057b3 <popcli+0x6f>
8010579f:	e8 5d ea ff ff       	call   80104201 <mycpu>
801057a4:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057aa:	85 c0                	test   %eax,%eax
801057ac:	74 05                	je     801057b3 <popcli+0x6f>
    sti();
801057ae:	e8 85 fd ff ff       	call   80105538 <sti>
}
801057b3:	90                   	nop
801057b4:	c9                   	leave  
801057b5:	c3                   	ret    

801057b6 <stosb>:
{
801057b6:	55                   	push   %ebp
801057b7:	89 e5                	mov    %esp,%ebp
801057b9:	57                   	push   %edi
801057ba:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057be:	8b 55 10             	mov    0x10(%ebp),%edx
801057c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c4:	89 cb                	mov    %ecx,%ebx
801057c6:	89 df                	mov    %ebx,%edi
801057c8:	89 d1                	mov    %edx,%ecx
801057ca:	fc                   	cld    
801057cb:	f3 aa                	rep stos %al,%es:(%edi)
801057cd:	89 ca                	mov    %ecx,%edx
801057cf:	89 fb                	mov    %edi,%ebx
801057d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057d4:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057d7:	90                   	nop
801057d8:	5b                   	pop    %ebx
801057d9:	5f                   	pop    %edi
801057da:	5d                   	pop    %ebp
801057db:	c3                   	ret    

801057dc <stosl>:
{
801057dc:	55                   	push   %ebp
801057dd:	89 e5                	mov    %esp,%ebp
801057df:	57                   	push   %edi
801057e0:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057e4:	8b 55 10             	mov    0x10(%ebp),%edx
801057e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ea:	89 cb                	mov    %ecx,%ebx
801057ec:	89 df                	mov    %ebx,%edi
801057ee:	89 d1                	mov    %edx,%ecx
801057f0:	fc                   	cld    
801057f1:	f3 ab                	rep stos %eax,%es:(%edi)
801057f3:	89 ca                	mov    %ecx,%edx
801057f5:	89 fb                	mov    %edi,%ebx
801057f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057fa:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057fd:	90                   	nop
801057fe:	5b                   	pop    %ebx
801057ff:	5f                   	pop    %edi
80105800:	5d                   	pop    %ebp
80105801:	c3                   	ret    

80105802 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105802:	55                   	push   %ebp
80105803:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105805:	8b 45 08             	mov    0x8(%ebp),%eax
80105808:	83 e0 03             	and    $0x3,%eax
8010580b:	85 c0                	test   %eax,%eax
8010580d:	75 43                	jne    80105852 <memset+0x50>
8010580f:	8b 45 10             	mov    0x10(%ebp),%eax
80105812:	83 e0 03             	and    $0x3,%eax
80105815:	85 c0                	test   %eax,%eax
80105817:	75 39                	jne    80105852 <memset+0x50>
    c &= 0xFF;
80105819:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105820:	8b 45 10             	mov    0x10(%ebp),%eax
80105823:	c1 e8 02             	shr    $0x2,%eax
80105826:	89 c1                	mov    %eax,%ecx
80105828:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582b:	c1 e0 18             	shl    $0x18,%eax
8010582e:	89 c2                	mov    %eax,%edx
80105830:	8b 45 0c             	mov    0xc(%ebp),%eax
80105833:	c1 e0 10             	shl    $0x10,%eax
80105836:	09 c2                	or     %eax,%edx
80105838:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583b:	c1 e0 08             	shl    $0x8,%eax
8010583e:	09 d0                	or     %edx,%eax
80105840:	0b 45 0c             	or     0xc(%ebp),%eax
80105843:	51                   	push   %ecx
80105844:	50                   	push   %eax
80105845:	ff 75 08             	push   0x8(%ebp)
80105848:	e8 8f ff ff ff       	call   801057dc <stosl>
8010584d:	83 c4 0c             	add    $0xc,%esp
80105850:	eb 12                	jmp    80105864 <memset+0x62>
  } else
    stosb(dst, c, n);
80105852:	8b 45 10             	mov    0x10(%ebp),%eax
80105855:	50                   	push   %eax
80105856:	ff 75 0c             	push   0xc(%ebp)
80105859:	ff 75 08             	push   0x8(%ebp)
8010585c:	e8 55 ff ff ff       	call   801057b6 <stosb>
80105861:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105864:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105867:	c9                   	leave  
80105868:	c3                   	ret    

80105869 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105869:	55                   	push   %ebp
8010586a:	89 e5                	mov    %esp,%ebp
8010586c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010586f:	8b 45 08             	mov    0x8(%ebp),%eax
80105872:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105875:	8b 45 0c             	mov    0xc(%ebp),%eax
80105878:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010587b:	eb 30                	jmp    801058ad <memcmp+0x44>
    if(*s1 != *s2)
8010587d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105880:	0f b6 10             	movzbl (%eax),%edx
80105883:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105886:	0f b6 00             	movzbl (%eax),%eax
80105889:	38 c2                	cmp    %al,%dl
8010588b:	74 18                	je     801058a5 <memcmp+0x3c>
      return *s1 - *s2;
8010588d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105890:	0f b6 00             	movzbl (%eax),%eax
80105893:	0f b6 d0             	movzbl %al,%edx
80105896:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105899:	0f b6 00             	movzbl (%eax),%eax
8010589c:	0f b6 c0             	movzbl %al,%eax
8010589f:	29 c2                	sub    %eax,%edx
801058a1:	89 d0                	mov    %edx,%eax
801058a3:	eb 1a                	jmp    801058bf <memcmp+0x56>
    s1++, s2++;
801058a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058a9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801058ad:	8b 45 10             	mov    0x10(%ebp),%eax
801058b0:	8d 50 ff             	lea    -0x1(%eax),%edx
801058b3:	89 55 10             	mov    %edx,0x10(%ebp)
801058b6:	85 c0                	test   %eax,%eax
801058b8:	75 c3                	jne    8010587d <memcmp+0x14>
  }

  return 0;
801058ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    

801058c1 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058c1:	55                   	push   %ebp
801058c2:	89 e5                	mov    %esp,%ebp
801058c4:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058cd:	8b 45 08             	mov    0x8(%ebp),%eax
801058d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058d9:	73 54                	jae    8010592f <memmove+0x6e>
801058db:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058de:	8b 45 10             	mov    0x10(%ebp),%eax
801058e1:	01 d0                	add    %edx,%eax
801058e3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801058e6:	73 47                	jae    8010592f <memmove+0x6e>
    s += n;
801058e8:	8b 45 10             	mov    0x10(%ebp),%eax
801058eb:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058ee:	8b 45 10             	mov    0x10(%ebp),%eax
801058f1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801058f4:	eb 13                	jmp    80105909 <memmove+0x48>
      *--d = *--s;
801058f6:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801058fa:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801058fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105901:	0f b6 10             	movzbl (%eax),%edx
80105904:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105907:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105909:	8b 45 10             	mov    0x10(%ebp),%eax
8010590c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010590f:	89 55 10             	mov    %edx,0x10(%ebp)
80105912:	85 c0                	test   %eax,%eax
80105914:	75 e0                	jne    801058f6 <memmove+0x35>
  if(s < d && s + n > d){
80105916:	eb 24                	jmp    8010593c <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105918:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010591b:	8d 42 01             	lea    0x1(%edx),%eax
8010591e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105921:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105924:	8d 48 01             	lea    0x1(%eax),%ecx
80105927:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010592a:	0f b6 12             	movzbl (%edx),%edx
8010592d:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010592f:	8b 45 10             	mov    0x10(%ebp),%eax
80105932:	8d 50 ff             	lea    -0x1(%eax),%edx
80105935:	89 55 10             	mov    %edx,0x10(%ebp)
80105938:	85 c0                	test   %eax,%eax
8010593a:	75 dc                	jne    80105918 <memmove+0x57>

  return dst;
8010593c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010593f:	c9                   	leave  
80105940:	c3                   	ret    

80105941 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105941:	55                   	push   %ebp
80105942:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105944:	ff 75 10             	push   0x10(%ebp)
80105947:	ff 75 0c             	push   0xc(%ebp)
8010594a:	ff 75 08             	push   0x8(%ebp)
8010594d:	e8 6f ff ff ff       	call   801058c1 <memmove>
80105952:	83 c4 0c             	add    $0xc,%esp
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    

80105957 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105957:	55                   	push   %ebp
80105958:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010595a:	eb 0c                	jmp    80105968 <strncmp+0x11>
    n--, p++, q++;
8010595c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105960:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105964:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010596c:	74 1a                	je     80105988 <strncmp+0x31>
8010596e:	8b 45 08             	mov    0x8(%ebp),%eax
80105971:	0f b6 00             	movzbl (%eax),%eax
80105974:	84 c0                	test   %al,%al
80105976:	74 10                	je     80105988 <strncmp+0x31>
80105978:	8b 45 08             	mov    0x8(%ebp),%eax
8010597b:	0f b6 10             	movzbl (%eax),%edx
8010597e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105981:	0f b6 00             	movzbl (%eax),%eax
80105984:	38 c2                	cmp    %al,%dl
80105986:	74 d4                	je     8010595c <strncmp+0x5>
  if(n == 0)
80105988:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010598c:	75 07                	jne    80105995 <strncmp+0x3e>
    return 0;
8010598e:	b8 00 00 00 00       	mov    $0x0,%eax
80105993:	eb 16                	jmp    801059ab <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105995:	8b 45 08             	mov    0x8(%ebp),%eax
80105998:	0f b6 00             	movzbl (%eax),%eax
8010599b:	0f b6 d0             	movzbl %al,%edx
8010599e:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a1:	0f b6 00             	movzbl (%eax),%eax
801059a4:	0f b6 c0             	movzbl %al,%eax
801059a7:	29 c2                	sub    %eax,%edx
801059a9:	89 d0                	mov    %edx,%eax
}
801059ab:	5d                   	pop    %ebp
801059ac:	c3                   	ret    

801059ad <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059ad:	55                   	push   %ebp
801059ae:	89 e5                	mov    %esp,%ebp
801059b0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801059b3:	8b 45 08             	mov    0x8(%ebp),%eax
801059b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059b9:	90                   	nop
801059ba:	8b 45 10             	mov    0x10(%ebp),%eax
801059bd:	8d 50 ff             	lea    -0x1(%eax),%edx
801059c0:	89 55 10             	mov    %edx,0x10(%ebp)
801059c3:	85 c0                	test   %eax,%eax
801059c5:	7e 2c                	jle    801059f3 <strncpy+0x46>
801059c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801059ca:	8d 42 01             	lea    0x1(%edx),%eax
801059cd:	89 45 0c             	mov    %eax,0xc(%ebp)
801059d0:	8b 45 08             	mov    0x8(%ebp),%eax
801059d3:	8d 48 01             	lea    0x1(%eax),%ecx
801059d6:	89 4d 08             	mov    %ecx,0x8(%ebp)
801059d9:	0f b6 12             	movzbl (%edx),%edx
801059dc:	88 10                	mov    %dl,(%eax)
801059de:	0f b6 00             	movzbl (%eax),%eax
801059e1:	84 c0                	test   %al,%al
801059e3:	75 d5                	jne    801059ba <strncpy+0xd>
    ;
  while(n-- > 0)
801059e5:	eb 0c                	jmp    801059f3 <strncpy+0x46>
    *s++ = 0;
801059e7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ea:	8d 50 01             	lea    0x1(%eax),%edx
801059ed:	89 55 08             	mov    %edx,0x8(%ebp)
801059f0:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
801059f3:	8b 45 10             	mov    0x10(%ebp),%eax
801059f6:	8d 50 ff             	lea    -0x1(%eax),%edx
801059f9:	89 55 10             	mov    %edx,0x10(%ebp)
801059fc:	85 c0                	test   %eax,%eax
801059fe:	7f e7                	jg     801059e7 <strncpy+0x3a>
  return os;
80105a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a03:	c9                   	leave  
80105a04:	c3                   	ret    

80105a05 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a05:	55                   	push   %ebp
80105a06:	89 e5                	mov    %esp,%ebp
80105a08:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a15:	7f 05                	jg     80105a1c <safestrcpy+0x17>
    return os;
80105a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a1a:	eb 31                	jmp    80105a4d <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a1c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a24:	7e 1e                	jle    80105a44 <safestrcpy+0x3f>
80105a26:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a29:	8d 42 01             	lea    0x1(%edx),%eax
80105a2c:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a32:	8d 48 01             	lea    0x1(%eax),%ecx
80105a35:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a38:	0f b6 12             	movzbl (%edx),%edx
80105a3b:	88 10                	mov    %dl,(%eax)
80105a3d:	0f b6 00             	movzbl (%eax),%eax
80105a40:	84 c0                	test   %al,%al
80105a42:	75 d8                	jne    80105a1c <safestrcpy+0x17>
    ;
  *s = 0;
80105a44:	8b 45 08             	mov    0x8(%ebp),%eax
80105a47:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a4d:	c9                   	leave  
80105a4e:	c3                   	ret    

80105a4f <strlen>:

int
strlen(const char *s)
{
80105a4f:	55                   	push   %ebp
80105a50:	89 e5                	mov    %esp,%ebp
80105a52:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a5c:	eb 04                	jmp    80105a62 <strlen+0x13>
80105a5e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a62:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a65:	8b 45 08             	mov    0x8(%ebp),%eax
80105a68:	01 d0                	add    %edx,%eax
80105a6a:	0f b6 00             	movzbl (%eax),%eax
80105a6d:	84 c0                	test   %al,%al
80105a6f:	75 ed                	jne    80105a5e <strlen+0xf>
    ;
  return n;
80105a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a74:	c9                   	leave  
80105a75:	c3                   	ret    

80105a76 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a76:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a7a:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105a7e:	55                   	push   %ebp
  pushl %ebx
80105a7f:	53                   	push   %ebx
  pushl %esi
80105a80:	56                   	push   %esi
  pushl %edi
80105a81:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a82:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a84:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105a86:	5f                   	pop    %edi
  popl %esi
80105a87:	5e                   	pop    %esi
  popl %ebx
80105a88:	5b                   	pop    %ebx
  popl %ebp
80105a89:	5d                   	pop    %ebp
  ret
80105a8a:	c3                   	ret    

80105a8b <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a8b:	55                   	push   %ebp
80105a8c:	89 e5                	mov    %esp,%ebp
80105a8e:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105a91:	e8 e3 e7 ff ff       	call   80104279 <myproc>
80105a96:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9c:	8b 00                	mov    (%eax),%eax
80105a9e:	39 45 08             	cmp    %eax,0x8(%ebp)
80105aa1:	73 0f                	jae    80105ab2 <fetchint+0x27>
80105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa6:	8d 50 04             	lea    0x4(%eax),%edx
80105aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aac:	8b 00                	mov    (%eax),%eax
80105aae:	39 c2                	cmp    %eax,%edx
80105ab0:	76 07                	jbe    80105ab9 <fetchint+0x2e>
    return -1;
80105ab2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab7:	eb 0f                	jmp    80105ac8 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80105abc:	8b 10                	mov    (%eax),%edx
80105abe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ac1:	89 10                	mov    %edx,(%eax)
  return 0;
80105ac3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    

80105aca <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105aca:	55                   	push   %ebp
80105acb:	89 e5                	mov    %esp,%ebp
80105acd:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105ad0:	e8 a4 e7 ff ff       	call   80104279 <myproc>
80105ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adb:	8b 00                	mov    (%eax),%eax
80105add:	39 45 08             	cmp    %eax,0x8(%ebp)
80105ae0:	72 07                	jb     80105ae9 <fetchstr+0x1f>
    return -1;
80105ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae7:	eb 43                	jmp    80105b2c <fetchstr+0x62>
  *pp = (char*)addr;
80105ae9:	8b 55 08             	mov    0x8(%ebp),%edx
80105aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aef:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af4:	8b 00                	mov    (%eax),%eax
80105af6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105afc:	8b 00                	mov    (%eax),%eax
80105afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b01:	eb 1c                	jmp    80105b1f <fetchstr+0x55>
    if(*s == 0)
80105b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b06:	0f b6 00             	movzbl (%eax),%eax
80105b09:	84 c0                	test   %al,%al
80105b0b:	75 0e                	jne    80105b1b <fetchstr+0x51>
      return s - *pp;
80105b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b10:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b13:	8b 00                	mov    (%eax),%eax
80105b15:	29 c2                	sub    %eax,%edx
80105b17:	89 d0                	mov    %edx,%eax
80105b19:	eb 11                	jmp    80105b2c <fetchstr+0x62>
  for(s = *pp; s < ep; s++){
80105b1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105b25:	72 dc                	jb     80105b03 <fetchstr+0x39>
  }
  return -1;
80105b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b2c:	c9                   	leave  
80105b2d:	c3                   	ret    

80105b2e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b2e:	55                   	push   %ebp
80105b2f:	89 e5                	mov    %esp,%ebp
80105b31:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b34:	e8 40 e7 ff ff       	call   80104279 <myproc>
80105b39:	8b 40 18             	mov    0x18(%eax),%eax
80105b3c:	8b 40 44             	mov    0x44(%eax),%eax
80105b3f:	8b 55 08             	mov    0x8(%ebp),%edx
80105b42:	c1 e2 02             	shl    $0x2,%edx
80105b45:	01 d0                	add    %edx,%eax
80105b47:	83 c0 04             	add    $0x4,%eax
80105b4a:	83 ec 08             	sub    $0x8,%esp
80105b4d:	ff 75 0c             	push   0xc(%ebp)
80105b50:	50                   	push   %eax
80105b51:	e8 35 ff ff ff       	call   80105a8b <fetchint>
80105b56:	83 c4 10             	add    $0x10,%esp
}
80105b59:	c9                   	leave  
80105b5a:	c3                   	ret    

80105b5b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b5b:	55                   	push   %ebp
80105b5c:	89 e5                	mov    %esp,%ebp
80105b5e:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105b61:	e8 13 e7 ff ff       	call   80104279 <myproc>
80105b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105b69:	83 ec 08             	sub    $0x8,%esp
80105b6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b6f:	50                   	push   %eax
80105b70:	ff 75 08             	push   0x8(%ebp)
80105b73:	e8 b6 ff ff ff       	call   80105b2e <argint>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	79 07                	jns    80105b86 <argptr+0x2b>
    return -1;
80105b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b84:	eb 3b                	jmp    80105bc1 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b8a:	78 1f                	js     80105bab <argptr+0x50>
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	8b 00                	mov    (%eax),%eax
80105b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b94:	39 d0                	cmp    %edx,%eax
80105b96:	76 13                	jbe    80105bab <argptr+0x50>
80105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9b:	89 c2                	mov    %eax,%edx
80105b9d:	8b 45 10             	mov    0x10(%ebp),%eax
80105ba0:	01 c2                	add    %eax,%edx
80105ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba5:	8b 00                	mov    (%eax),%eax
80105ba7:	39 c2                	cmp    %eax,%edx
80105ba9:	76 07                	jbe    80105bb2 <argptr+0x57>
    return -1;
80105bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb0:	eb 0f                	jmp    80105bc1 <argptr+0x66>
  *pp = (char*)i;
80105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb5:	89 c2                	mov    %eax,%edx
80105bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bba:	89 10                	mov    %edx,(%eax)
  return 0;
80105bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bc1:	c9                   	leave  
80105bc2:	c3                   	ret    

80105bc3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bc3:	55                   	push   %ebp
80105bc4:	89 e5                	mov    %esp,%ebp
80105bc6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bcf:	50                   	push   %eax
80105bd0:	ff 75 08             	push   0x8(%ebp)
80105bd3:	e8 56 ff ff ff       	call   80105b2e <argint>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	85 c0                	test   %eax,%eax
80105bdd:	79 07                	jns    80105be6 <argstr+0x23>
    return -1;
80105bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be4:	eb 12                	jmp    80105bf8 <argstr+0x35>
  return fetchstr(addr, pp);
80105be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be9:	83 ec 08             	sub    $0x8,%esp
80105bec:	ff 75 0c             	push   0xc(%ebp)
80105bef:	50                   	push   %eax
80105bf0:	e8 d5 fe ff ff       	call   80105aca <fetchstr>
80105bf5:	83 c4 10             	add    $0x10,%esp
}
80105bf8:	c9                   	leave  
80105bf9:	c3                   	ret    

80105bfa <syscall>:

};

void
syscall(void)
{
80105bfa:	55                   	push   %ebp
80105bfb:	89 e5                	mov    %esp,%ebp
80105bfd:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105c00:	e8 74 e6 ff ff       	call   80104279 <myproc>
80105c05:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c0b:	8b 40 18             	mov    0x18(%eax),%eax
80105c0e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c18:	7e 2f                	jle    80105c49 <syscall+0x4f>
80105c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1d:	83 f8 27             	cmp    $0x27,%eax
80105c20:	77 27                	ja     80105c49 <syscall+0x4f>
80105c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c25:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105c2c:	85 c0                	test   %eax,%eax
80105c2e:	74 19                	je     80105c49 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c33:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105c3a:	ff d0                	call   *%eax
80105c3c:	89 c2                	mov    %eax,%edx
80105c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c41:	8b 40 18             	mov    0x18(%eax),%eax
80105c44:	89 50 1c             	mov    %edx,0x1c(%eax)
80105c47:	eb 2b                	jmp    80105c74 <syscall+0x7a>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4c:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c52:	8b 40 10             	mov    0x10(%eax),%eax
80105c55:	ff 75 f0             	push   -0x10(%ebp)
80105c58:	52                   	push   %edx
80105c59:	50                   	push   %eax
80105c5a:	68 3a 90 10 80       	push   $0x8010903a
80105c5f:	e8 98 a7 ff ff       	call   801003fc <cprintf>
80105c64:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6a:	8b 40 18             	mov    0x18(%eax),%eax
80105c6d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105c74:	90                   	nop
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    

80105c77 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105c77:	55                   	push   %ebp
80105c78:	89 e5                	mov    %esp,%ebp
80105c7a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105c7d:	83 ec 08             	sub    $0x8,%esp
80105c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c83:	50                   	push   %eax
80105c84:	ff 75 08             	push   0x8(%ebp)
80105c87:	e8 a2 fe ff ff       	call   80105b2e <argint>
80105c8c:	83 c4 10             	add    $0x10,%esp
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	79 07                	jns    80105c9a <argfd+0x23>
    return -1;
80105c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c98:	eb 51                	jmp    80105ceb <argfd+0x74>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	78 22                	js     80105cc3 <argfd+0x4c>
80105ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca4:	83 f8 0f             	cmp    $0xf,%eax
80105ca7:	7f 1a                	jg     80105cc3 <argfd+0x4c>
80105ca9:	e8 cb e5 ff ff       	call   80104279 <myproc>
80105cae:	89 c2                	mov    %eax,%edx
80105cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb3:	83 c0 08             	add    $0x8,%eax
80105cb6:	8b 44 82 08          	mov    0x8(%edx,%eax,4),%eax
80105cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc1:	75 07                	jne    80105cca <argfd+0x53>
    return -1;
80105cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc8:	eb 21                	jmp    80105ceb <argfd+0x74>
  if(pfd)
80105cca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105cce:	74 08                	je     80105cd8 <argfd+0x61>
    *pfd = fd;
80105cd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cd6:	89 10                	mov    %edx,(%eax)
  if(pf)
80105cd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105cdc:	74 08                	je     80105ce6 <argfd+0x6f>
    *pf = f;
80105cde:	8b 45 10             	mov    0x10(%ebp),%eax
80105ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ce4:	89 10                	mov    %edx,(%eax)
  return 0;
80105ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ceb:	c9                   	leave  
80105cec:	c3                   	ret    

80105ced <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105ced:	55                   	push   %ebp
80105cee:	89 e5                	mov    %esp,%ebp
80105cf0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105cf3:	e8 81 e5 ff ff       	call   80104279 <myproc>
80105cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105cfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d02:	eb 2a                	jmp    80105d2e <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d0a:	83 c2 08             	add    $0x8,%edx
80105d0d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d11:	85 c0                	test   %eax,%eax
80105d13:	75 15                	jne    80105d2a <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d1b:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d1e:	8b 55 08             	mov    0x8(%ebp),%edx
80105d21:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d28:	eb 0f                	jmp    80105d39 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105d2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d32:	7e d0                	jle    80105d04 <fdalloc+0x17>
    }
  }
  return -1;
80105d34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d39:	c9                   	leave  
80105d3a:	c3                   	ret    

80105d3b <sys_dup>:

int
sys_dup(void)
{
80105d3b:	55                   	push   %ebp
80105d3c:	89 e5                	mov    %esp,%ebp
80105d3e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105d41:	83 ec 04             	sub    $0x4,%esp
80105d44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d47:	50                   	push   %eax
80105d48:	6a 00                	push   $0x0
80105d4a:	6a 00                	push   $0x0
80105d4c:	e8 26 ff ff ff       	call   80105c77 <argfd>
80105d51:	83 c4 10             	add    $0x10,%esp
80105d54:	85 c0                	test   %eax,%eax
80105d56:	79 07                	jns    80105d5f <sys_dup+0x24>
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5d:	eb 31                	jmp    80105d90 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d62:	83 ec 0c             	sub    $0xc,%esp
80105d65:	50                   	push   %eax
80105d66:	e8 82 ff ff ff       	call   80105ced <fdalloc>
80105d6b:	83 c4 10             	add    $0x10,%esp
80105d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d75:	79 07                	jns    80105d7e <sys_dup+0x43>
    return -1;
80105d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7c:	eb 12                	jmp    80105d90 <sys_dup+0x55>
  filedup(f);
80105d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d81:	83 ec 0c             	sub    $0xc,%esp
80105d84:	50                   	push   %eax
80105d85:	e8 da b2 ff ff       	call   80101064 <filedup>
80105d8a:	83 c4 10             	add    $0x10,%esp
  return fd;
80105d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d90:	c9                   	leave  
80105d91:	c3                   	ret    

80105d92 <sys_read>:

int
sys_read(void)
{
80105d92:	55                   	push   %ebp
80105d93:	89 e5                	mov    %esp,%ebp
80105d95:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d98:	83 ec 04             	sub    $0x4,%esp
80105d9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d9e:	50                   	push   %eax
80105d9f:	6a 00                	push   $0x0
80105da1:	6a 00                	push   $0x0
80105da3:	e8 cf fe ff ff       	call   80105c77 <argfd>
80105da8:	83 c4 10             	add    $0x10,%esp
80105dab:	85 c0                	test   %eax,%eax
80105dad:	78 2e                	js     80105ddd <sys_read+0x4b>
80105daf:	83 ec 08             	sub    $0x8,%esp
80105db2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db5:	50                   	push   %eax
80105db6:	6a 02                	push   $0x2
80105db8:	e8 71 fd ff ff       	call   80105b2e <argint>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	78 19                	js     80105ddd <sys_read+0x4b>
80105dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc7:	83 ec 04             	sub    $0x4,%esp
80105dca:	50                   	push   %eax
80105dcb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dce:	50                   	push   %eax
80105dcf:	6a 01                	push   $0x1
80105dd1:	e8 85 fd ff ff       	call   80105b5b <argptr>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	79 07                	jns    80105de4 <sys_read+0x52>
    return -1;
80105ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de2:	eb 17                	jmp    80105dfb <sys_read+0x69>
  return fileread(f, p, n);
80105de4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105de7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ded:	83 ec 04             	sub    $0x4,%esp
80105df0:	51                   	push   %ecx
80105df1:	52                   	push   %edx
80105df2:	50                   	push   %eax
80105df3:	e8 fc b3 ff ff       	call   801011f4 <fileread>
80105df8:	83 c4 10             	add    $0x10,%esp
}
80105dfb:	c9                   	leave  
80105dfc:	c3                   	ret    

80105dfd <sys_write>:

int
sys_write(void)
{
80105dfd:	55                   	push   %ebp
80105dfe:	89 e5                	mov    %esp,%ebp
80105e00:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e03:	83 ec 04             	sub    $0x4,%esp
80105e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e09:	50                   	push   %eax
80105e0a:	6a 00                	push   $0x0
80105e0c:	6a 00                	push   $0x0
80105e0e:	e8 64 fe ff ff       	call   80105c77 <argfd>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	78 2e                	js     80105e48 <sys_write+0x4b>
80105e1a:	83 ec 08             	sub    $0x8,%esp
80105e1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e20:	50                   	push   %eax
80105e21:	6a 02                	push   $0x2
80105e23:	e8 06 fd ff ff       	call   80105b2e <argint>
80105e28:	83 c4 10             	add    $0x10,%esp
80105e2b:	85 c0                	test   %eax,%eax
80105e2d:	78 19                	js     80105e48 <sys_write+0x4b>
80105e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e32:	83 ec 04             	sub    $0x4,%esp
80105e35:	50                   	push   %eax
80105e36:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e39:	50                   	push   %eax
80105e3a:	6a 01                	push   $0x1
80105e3c:	e8 1a fd ff ff       	call   80105b5b <argptr>
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	85 c0                	test   %eax,%eax
80105e46:	79 07                	jns    80105e4f <sys_write+0x52>
    return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4d:	eb 17                	jmp    80105e66 <sys_write+0x69>
  return filewrite(f, p, n);
80105e4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e52:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e58:	83 ec 04             	sub    $0x4,%esp
80105e5b:	51                   	push   %ecx
80105e5c:	52                   	push   %edx
80105e5d:	50                   	push   %eax
80105e5e:	e8 49 b4 ff ff       	call   801012ac <filewrite>
80105e63:	83 c4 10             	add    $0x10,%esp
}
80105e66:	c9                   	leave  
80105e67:	c3                   	ret    

80105e68 <sys_close>:

int
sys_close(void)
{
80105e68:	55                   	push   %ebp
80105e69:	89 e5                	mov    %esp,%ebp
80105e6b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105e6e:	83 ec 04             	sub    $0x4,%esp
80105e71:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e74:	50                   	push   %eax
80105e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e78:	50                   	push   %eax
80105e79:	6a 00                	push   $0x0
80105e7b:	e8 f7 fd ff ff       	call   80105c77 <argfd>
80105e80:	83 c4 10             	add    $0x10,%esp
80105e83:	85 c0                	test   %eax,%eax
80105e85:	79 07                	jns    80105e8e <sys_close+0x26>
    return -1;
80105e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8c:	eb 29                	jmp    80105eb7 <sys_close+0x4f>
  myproc()->ofile[fd] = 0;
80105e8e:	e8 e6 e3 ff ff       	call   80104279 <myproc>
80105e93:	89 c2                	mov    %eax,%edx
80105e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e98:	83 c0 08             	add    $0x8,%eax
80105e9b:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
80105ea2:	00 
  fileclose(f);
80105ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea6:	83 ec 0c             	sub    $0xc,%esp
80105ea9:	50                   	push   %eax
80105eaa:	e8 06 b2 ff ff       	call   801010b5 <fileclose>
80105eaf:	83 c4 10             	add    $0x10,%esp
  return 0;
80105eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105eb7:	c9                   	leave  
80105eb8:	c3                   	ret    

80105eb9 <sys_fstat>:

int
sys_fstat(void)
{
80105eb9:	55                   	push   %ebp
80105eba:	89 e5                	mov    %esp,%ebp
80105ebc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ebf:	83 ec 04             	sub    $0x4,%esp
80105ec2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ec5:	50                   	push   %eax
80105ec6:	6a 00                	push   $0x0
80105ec8:	6a 00                	push   $0x0
80105eca:	e8 a8 fd ff ff       	call   80105c77 <argfd>
80105ecf:	83 c4 10             	add    $0x10,%esp
80105ed2:	85 c0                	test   %eax,%eax
80105ed4:	78 17                	js     80105eed <sys_fstat+0x34>
80105ed6:	83 ec 04             	sub    $0x4,%esp
80105ed9:	6a 14                	push   $0x14
80105edb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ede:	50                   	push   %eax
80105edf:	6a 01                	push   $0x1
80105ee1:	e8 75 fc ff ff       	call   80105b5b <argptr>
80105ee6:	83 c4 10             	add    $0x10,%esp
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	79 07                	jns    80105ef4 <sys_fstat+0x3b>
    return -1;
80105eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef2:	eb 13                	jmp    80105f07 <sys_fstat+0x4e>
  return filestat(f, st);
80105ef4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efa:	83 ec 08             	sub    $0x8,%esp
80105efd:	52                   	push   %edx
80105efe:	50                   	push   %eax
80105eff:	e8 99 b2 ff ff       	call   8010119d <filestat>
80105f04:	83 c4 10             	add    $0x10,%esp
}
80105f07:	c9                   	leave  
80105f08:	c3                   	ret    

80105f09 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105f09:	55                   	push   %ebp
80105f0a:	89 e5                	mov    %esp,%ebp
80105f0c:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f0f:	83 ec 08             	sub    $0x8,%esp
80105f12:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f15:	50                   	push   %eax
80105f16:	6a 00                	push   $0x0
80105f18:	e8 a6 fc ff ff       	call   80105bc3 <argstr>
80105f1d:	83 c4 10             	add    $0x10,%esp
80105f20:	85 c0                	test   %eax,%eax
80105f22:	78 15                	js     80105f39 <sys_link+0x30>
80105f24:	83 ec 08             	sub    $0x8,%esp
80105f27:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f2a:	50                   	push   %eax
80105f2b:	6a 01                	push   $0x1
80105f2d:	e8 91 fc ff ff       	call   80105bc3 <argstr>
80105f32:	83 c4 10             	add    $0x10,%esp
80105f35:	85 c0                	test   %eax,%eax
80105f37:	79 0a                	jns    80105f43 <sys_link+0x3a>
    return -1;
80105f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3e:	e9 68 01 00 00       	jmp    801060ab <sys_link+0x1a2>

  begin_op();
80105f43:	e8 db d5 ff ff       	call   80103523 <begin_op>
  if((ip = namei(old)) == 0){
80105f48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f4b:	83 ec 0c             	sub    $0xc,%esp
80105f4e:	50                   	push   %eax
80105f4f:	e8 e8 c5 ff ff       	call   8010253c <namei>
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f5e:	75 0f                	jne    80105f6f <sys_link+0x66>
    end_op();
80105f60:	e8 4a d6 ff ff       	call   801035af <end_op>
    return -1;
80105f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6a:	e9 3c 01 00 00       	jmp    801060ab <sys_link+0x1a2>
  }

  ilock(ip);
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	ff 75 f4             	push   -0xc(%ebp)
80105f75:	e8 87 ba ff ff       	call   80101a01 <ilock>
80105f7a:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f80:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f84:	66 83 f8 01          	cmp    $0x1,%ax
80105f88:	75 1d                	jne    80105fa7 <sys_link+0x9e>
    iunlockput(ip);
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	ff 75 f4             	push   -0xc(%ebp)
80105f90:	e8 9d bc ff ff       	call   80101c32 <iunlockput>
80105f95:	83 c4 10             	add    $0x10,%esp
    end_op();
80105f98:	e8 12 d6 ff ff       	call   801035af <end_op>
    return -1;
80105f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa2:	e9 04 01 00 00       	jmp    801060ab <sys_link+0x1a2>
  }

  ip->nlink++;
80105fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105faa:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105fae:	83 c0 01             	add    $0x1,%eax
80105fb1:	89 c2                	mov    %eax,%edx
80105fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb6:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105fba:	83 ec 0c             	sub    $0xc,%esp
80105fbd:	ff 75 f4             	push   -0xc(%ebp)
80105fc0:	e8 5f b8 ff ff       	call   80101824 <iupdate>
80105fc5:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	ff 75 f4             	push   -0xc(%ebp)
80105fce:	e8 41 bb ff ff       	call   80101b14 <iunlock>
80105fd3:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fd9:	83 ec 08             	sub    $0x8,%esp
80105fdc:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105fdf:	52                   	push   %edx
80105fe0:	50                   	push   %eax
80105fe1:	e8 72 c5 ff ff       	call   80102558 <nameiparent>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ff0:	74 71                	je     80106063 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105ff2:	83 ec 0c             	sub    $0xc,%esp
80105ff5:	ff 75 f0             	push   -0x10(%ebp)
80105ff8:	e8 04 ba ff ff       	call   80101a01 <ilock>
80105ffd:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106003:	8b 10                	mov    (%eax),%edx
80106005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106008:	8b 00                	mov    (%eax),%eax
8010600a:	39 c2                	cmp    %eax,%edx
8010600c:	75 1d                	jne    8010602b <sys_link+0x122>
8010600e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106011:	8b 40 04             	mov    0x4(%eax),%eax
80106014:	83 ec 04             	sub    $0x4,%esp
80106017:	50                   	push   %eax
80106018:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010601b:	50                   	push   %eax
8010601c:	ff 75 f0             	push   -0x10(%ebp)
8010601f:	e8 7d c2 ff ff       	call   801022a1 <dirlink>
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	85 c0                	test   %eax,%eax
80106029:	79 10                	jns    8010603b <sys_link+0x132>
    iunlockput(dp);
8010602b:	83 ec 0c             	sub    $0xc,%esp
8010602e:	ff 75 f0             	push   -0x10(%ebp)
80106031:	e8 fc bb ff ff       	call   80101c32 <iunlockput>
80106036:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106039:	eb 29                	jmp    80106064 <sys_link+0x15b>
  }
  iunlockput(dp);
8010603b:	83 ec 0c             	sub    $0xc,%esp
8010603e:	ff 75 f0             	push   -0x10(%ebp)
80106041:	e8 ec bb ff ff       	call   80101c32 <iunlockput>
80106046:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	ff 75 f4             	push   -0xc(%ebp)
8010604f:	e8 0e bb ff ff       	call   80101b62 <iput>
80106054:	83 c4 10             	add    $0x10,%esp

  end_op();
80106057:	e8 53 d5 ff ff       	call   801035af <end_op>

  return 0;
8010605c:	b8 00 00 00 00       	mov    $0x0,%eax
80106061:	eb 48                	jmp    801060ab <sys_link+0x1a2>
    goto bad;
80106063:	90                   	nop

bad:
  ilock(ip);
80106064:	83 ec 0c             	sub    $0xc,%esp
80106067:	ff 75 f4             	push   -0xc(%ebp)
8010606a:	e8 92 b9 ff ff       	call   80101a01 <ilock>
8010606f:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106075:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106079:	83 e8 01             	sub    $0x1,%eax
8010607c:	89 c2                	mov    %eax,%edx
8010607e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106081:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106085:	83 ec 0c             	sub    $0xc,%esp
80106088:	ff 75 f4             	push   -0xc(%ebp)
8010608b:	e8 94 b7 ff ff       	call   80101824 <iupdate>
80106090:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106093:	83 ec 0c             	sub    $0xc,%esp
80106096:	ff 75 f4             	push   -0xc(%ebp)
80106099:	e8 94 bb ff ff       	call   80101c32 <iunlockput>
8010609e:	83 c4 10             	add    $0x10,%esp
  end_op();
801060a1:	e8 09 d5 ff ff       	call   801035af <end_op>
  return -1;
801060a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ab:	c9                   	leave  
801060ac:	c3                   	ret    

801060ad <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801060ad:	55                   	push   %ebp
801060ae:	89 e5                	mov    %esp,%ebp
801060b0:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801060b3:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801060ba:	eb 40                	jmp    801060fc <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bf:	6a 10                	push   $0x10
801060c1:	50                   	push   %eax
801060c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060c5:	50                   	push   %eax
801060c6:	ff 75 08             	push   0x8(%ebp)
801060c9:	e8 1f be ff ff       	call   80101eed <readi>
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	83 f8 10             	cmp    $0x10,%eax
801060d4:	74 0d                	je     801060e3 <isdirempty+0x36>
      panic("isdirempty: readi");
801060d6:	83 ec 0c             	sub    $0xc,%esp
801060d9:	68 56 90 10 80       	push   $0x80109056
801060de:	e8 b9 a4 ff ff       	call   8010059c <panic>
    if(de.inum != 0)
801060e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801060e7:	66 85 c0             	test   %ax,%ax
801060ea:	74 07                	je     801060f3 <isdirempty+0x46>
      return 0;
801060ec:	b8 00 00 00 00       	mov    $0x0,%eax
801060f1:	eb 1b                	jmp    8010610e <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801060f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f6:	83 c0 10             	add    $0x10,%eax
801060f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060fc:	8b 45 08             	mov    0x8(%ebp),%eax
801060ff:	8b 50 58             	mov    0x58(%eax),%edx
80106102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106105:	39 c2                	cmp    %eax,%edx
80106107:	77 b3                	ja     801060bc <isdirempty+0xf>
  }
  return 1;
80106109:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010610e:	c9                   	leave  
8010610f:	c3                   	ret    

80106110 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106116:	83 ec 08             	sub    $0x8,%esp
80106119:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010611c:	50                   	push   %eax
8010611d:	6a 00                	push   $0x0
8010611f:	e8 9f fa ff ff       	call   80105bc3 <argstr>
80106124:	83 c4 10             	add    $0x10,%esp
80106127:	85 c0                	test   %eax,%eax
80106129:	79 0a                	jns    80106135 <sys_unlink+0x25>
    return -1;
8010612b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106130:	e9 bf 01 00 00       	jmp    801062f4 <sys_unlink+0x1e4>

  begin_op();
80106135:	e8 e9 d3 ff ff       	call   80103523 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010613a:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010613d:	83 ec 08             	sub    $0x8,%esp
80106140:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106143:	52                   	push   %edx
80106144:	50                   	push   %eax
80106145:	e8 0e c4 ff ff       	call   80102558 <nameiparent>
8010614a:	83 c4 10             	add    $0x10,%esp
8010614d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106154:	75 0f                	jne    80106165 <sys_unlink+0x55>
    end_op();
80106156:	e8 54 d4 ff ff       	call   801035af <end_op>
    return -1;
8010615b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106160:	e9 8f 01 00 00       	jmp    801062f4 <sys_unlink+0x1e4>
  }

  ilock(dp);
80106165:	83 ec 0c             	sub    $0xc,%esp
80106168:	ff 75 f4             	push   -0xc(%ebp)
8010616b:	e8 91 b8 ff ff       	call   80101a01 <ilock>
80106170:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106173:	83 ec 08             	sub    $0x8,%esp
80106176:	68 68 90 10 80       	push   $0x80109068
8010617b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010617e:	50                   	push   %eax
8010617f:	e8 48 c0 ff ff       	call   801021cc <namecmp>
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	85 c0                	test   %eax,%eax
80106189:	0f 84 49 01 00 00    	je     801062d8 <sys_unlink+0x1c8>
8010618f:	83 ec 08             	sub    $0x8,%esp
80106192:	68 6a 90 10 80       	push   $0x8010906a
80106197:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010619a:	50                   	push   %eax
8010619b:	e8 2c c0 ff ff       	call   801021cc <namecmp>
801061a0:	83 c4 10             	add    $0x10,%esp
801061a3:	85 c0                	test   %eax,%eax
801061a5:	0f 84 2d 01 00 00    	je     801062d8 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801061ab:	83 ec 04             	sub    $0x4,%esp
801061ae:	8d 45 c8             	lea    -0x38(%ebp),%eax
801061b1:	50                   	push   %eax
801061b2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061b5:	50                   	push   %eax
801061b6:	ff 75 f4             	push   -0xc(%ebp)
801061b9:	e8 29 c0 ff ff       	call   801021e7 <dirlookup>
801061be:	83 c4 10             	add    $0x10,%esp
801061c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c8:	0f 84 0d 01 00 00    	je     801062db <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801061ce:	83 ec 0c             	sub    $0xc,%esp
801061d1:	ff 75 f0             	push   -0x10(%ebp)
801061d4:	e8 28 b8 ff ff       	call   80101a01 <ilock>
801061d9:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801061dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061df:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801061e3:	66 85 c0             	test   %ax,%ax
801061e6:	7f 0d                	jg     801061f5 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801061e8:	83 ec 0c             	sub    $0xc,%esp
801061eb:	68 6d 90 10 80       	push   $0x8010906d
801061f0:	e8 a7 a3 ff ff       	call   8010059c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801061f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f8:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801061fc:	66 83 f8 01          	cmp    $0x1,%ax
80106200:	75 25                	jne    80106227 <sys_unlink+0x117>
80106202:	83 ec 0c             	sub    $0xc,%esp
80106205:	ff 75 f0             	push   -0x10(%ebp)
80106208:	e8 a0 fe ff ff       	call   801060ad <isdirempty>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	75 13                	jne    80106227 <sys_unlink+0x117>
    iunlockput(ip);
80106214:	83 ec 0c             	sub    $0xc,%esp
80106217:	ff 75 f0             	push   -0x10(%ebp)
8010621a:	e8 13 ba ff ff       	call   80101c32 <iunlockput>
8010621f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106222:	e9 b5 00 00 00       	jmp    801062dc <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80106227:	83 ec 04             	sub    $0x4,%esp
8010622a:	6a 10                	push   $0x10
8010622c:	6a 00                	push   $0x0
8010622e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106231:	50                   	push   %eax
80106232:	e8 cb f5 ff ff       	call   80105802 <memset>
80106237:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010623a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010623d:	6a 10                	push   $0x10
8010623f:	50                   	push   %eax
80106240:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106243:	50                   	push   %eax
80106244:	ff 75 f4             	push   -0xc(%ebp)
80106247:	e8 f8 bd ff ff       	call   80102044 <writei>
8010624c:	83 c4 10             	add    $0x10,%esp
8010624f:	83 f8 10             	cmp    $0x10,%eax
80106252:	74 0d                	je     80106261 <sys_unlink+0x151>
    panic("unlink: writei");
80106254:	83 ec 0c             	sub    $0xc,%esp
80106257:	68 7f 90 10 80       	push   $0x8010907f
8010625c:	e8 3b a3 ff ff       	call   8010059c <panic>
  if(ip->type == T_DIR){
80106261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106264:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106268:	66 83 f8 01          	cmp    $0x1,%ax
8010626c:	75 21                	jne    8010628f <sys_unlink+0x17f>
    dp->nlink--;
8010626e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106271:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106275:	83 e8 01             	sub    $0x1,%eax
80106278:	89 c2                	mov    %eax,%edx
8010627a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106281:	83 ec 0c             	sub    $0xc,%esp
80106284:	ff 75 f4             	push   -0xc(%ebp)
80106287:	e8 98 b5 ff ff       	call   80101824 <iupdate>
8010628c:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010628f:	83 ec 0c             	sub    $0xc,%esp
80106292:	ff 75 f4             	push   -0xc(%ebp)
80106295:	e8 98 b9 ff ff       	call   80101c32 <iunlockput>
8010629a:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010629d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801062a4:	83 e8 01             	sub    $0x1,%eax
801062a7:	89 c2                	mov    %eax,%edx
801062a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ac:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	ff 75 f0             	push   -0x10(%ebp)
801062b6:	e8 69 b5 ff ff       	call   80101824 <iupdate>
801062bb:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801062be:	83 ec 0c             	sub    $0xc,%esp
801062c1:	ff 75 f0             	push   -0x10(%ebp)
801062c4:	e8 69 b9 ff ff       	call   80101c32 <iunlockput>
801062c9:	83 c4 10             	add    $0x10,%esp

  end_op();
801062cc:	e8 de d2 ff ff       	call   801035af <end_op>

  return 0;
801062d1:	b8 00 00 00 00       	mov    $0x0,%eax
801062d6:	eb 1c                	jmp    801062f4 <sys_unlink+0x1e4>

bad:
801062d8:	90                   	nop
801062d9:	eb 01                	jmp    801062dc <sys_unlink+0x1cc>
    goto bad;
801062db:	90                   	nop
  iunlockput(dp);
801062dc:	83 ec 0c             	sub    $0xc,%esp
801062df:	ff 75 f4             	push   -0xc(%ebp)
801062e2:	e8 4b b9 ff ff       	call   80101c32 <iunlockput>
801062e7:	83 c4 10             	add    $0x10,%esp
  end_op();
801062ea:	e8 c0 d2 ff ff       	call   801035af <end_op>
  return -1;
801062ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f4:	c9                   	leave  
801062f5:	c3                   	ret    

801062f6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801062f6:	55                   	push   %ebp
801062f7:	89 e5                	mov    %esp,%ebp
801062f9:	83 ec 38             	sub    $0x38,%esp
801062fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801062ff:	8b 55 10             	mov    0x10(%ebp),%edx
80106302:	8b 45 14             	mov    0x14(%ebp),%eax
80106305:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106309:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010630d:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106311:	83 ec 08             	sub    $0x8,%esp
80106314:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106317:	50                   	push   %eax
80106318:	ff 75 08             	push   0x8(%ebp)
8010631b:	e8 38 c2 ff ff       	call   80102558 <nameiparent>
80106320:	83 c4 10             	add    $0x10,%esp
80106323:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010632a:	75 0a                	jne    80106336 <create+0x40>
    return 0;
8010632c:	b8 00 00 00 00       	mov    $0x0,%eax
80106331:	e9 8e 01 00 00       	jmp    801064c4 <create+0x1ce>
  ilock(dp);
80106336:	83 ec 0c             	sub    $0xc,%esp
80106339:	ff 75 f4             	push   -0xc(%ebp)
8010633c:	e8 c0 b6 ff ff       	call   80101a01 <ilock>
80106341:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
80106344:	83 ec 04             	sub    $0x4,%esp
80106347:	6a 00                	push   $0x0
80106349:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010634c:	50                   	push   %eax
8010634d:	ff 75 f4             	push   -0xc(%ebp)
80106350:	e8 92 be ff ff       	call   801021e7 <dirlookup>
80106355:	83 c4 10             	add    $0x10,%esp
80106358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010635b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010635f:	74 50                	je     801063b1 <create+0xbb>
    iunlockput(dp);
80106361:	83 ec 0c             	sub    $0xc,%esp
80106364:	ff 75 f4             	push   -0xc(%ebp)
80106367:	e8 c6 b8 ff ff       	call   80101c32 <iunlockput>
8010636c:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010636f:	83 ec 0c             	sub    $0xc,%esp
80106372:	ff 75 f0             	push   -0x10(%ebp)
80106375:	e8 87 b6 ff ff       	call   80101a01 <ilock>
8010637a:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010637d:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106382:	75 15                	jne    80106399 <create+0xa3>
80106384:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106387:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010638b:	66 83 f8 02          	cmp    $0x2,%ax
8010638f:	75 08                	jne    80106399 <create+0xa3>
      return ip;
80106391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106394:	e9 2b 01 00 00       	jmp    801064c4 <create+0x1ce>
    iunlockput(ip);
80106399:	83 ec 0c             	sub    $0xc,%esp
8010639c:	ff 75 f0             	push   -0x10(%ebp)
8010639f:	e8 8e b8 ff ff       	call   80101c32 <iunlockput>
801063a4:	83 c4 10             	add    $0x10,%esp
    return 0;
801063a7:	b8 00 00 00 00       	mov    $0x0,%eax
801063ac:	e9 13 01 00 00       	jmp    801064c4 <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801063b1:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801063b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b8:	8b 00                	mov    (%eax),%eax
801063ba:	83 ec 08             	sub    $0x8,%esp
801063bd:	52                   	push   %edx
801063be:	50                   	push   %eax
801063bf:	e8 89 b3 ff ff       	call   8010174d <ialloc>
801063c4:	83 c4 10             	add    $0x10,%esp
801063c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063ce:	75 0d                	jne    801063dd <create+0xe7>
    panic("create: ialloc");
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	68 8e 90 10 80       	push   $0x8010908e
801063d8:	e8 bf a1 ff ff       	call   8010059c <panic>

  ilock(ip);
801063dd:	83 ec 0c             	sub    $0xc,%esp
801063e0:	ff 75 f0             	push   -0x10(%ebp)
801063e3:	e8 19 b6 ff ff       	call   80101a01 <ilock>
801063e8:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801063eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ee:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801063f2:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801063f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f9:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801063fd:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80106401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106404:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010640a:	83 ec 0c             	sub    $0xc,%esp
8010640d:	ff 75 f0             	push   -0x10(%ebp)
80106410:	e8 0f b4 ff ff       	call   80101824 <iupdate>
80106415:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106418:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010641d:	75 6a                	jne    80106489 <create+0x193>
    dp->nlink++;  // for ".."
8010641f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106422:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106426:	83 c0 01             	add    $0x1,%eax
80106429:	89 c2                	mov    %eax,%edx
8010642b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642e:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106432:	83 ec 0c             	sub    $0xc,%esp
80106435:	ff 75 f4             	push   -0xc(%ebp)
80106438:	e8 e7 b3 ff ff       	call   80101824 <iupdate>
8010643d:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106440:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106443:	8b 40 04             	mov    0x4(%eax),%eax
80106446:	83 ec 04             	sub    $0x4,%esp
80106449:	50                   	push   %eax
8010644a:	68 68 90 10 80       	push   $0x80109068
8010644f:	ff 75 f0             	push   -0x10(%ebp)
80106452:	e8 4a be ff ff       	call   801022a1 <dirlink>
80106457:	83 c4 10             	add    $0x10,%esp
8010645a:	85 c0                	test   %eax,%eax
8010645c:	78 1e                	js     8010647c <create+0x186>
8010645e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106461:	8b 40 04             	mov    0x4(%eax),%eax
80106464:	83 ec 04             	sub    $0x4,%esp
80106467:	50                   	push   %eax
80106468:	68 6a 90 10 80       	push   $0x8010906a
8010646d:	ff 75 f0             	push   -0x10(%ebp)
80106470:	e8 2c be ff ff       	call   801022a1 <dirlink>
80106475:	83 c4 10             	add    $0x10,%esp
80106478:	85 c0                	test   %eax,%eax
8010647a:	79 0d                	jns    80106489 <create+0x193>
      panic("create dots");
8010647c:	83 ec 0c             	sub    $0xc,%esp
8010647f:	68 9d 90 10 80       	push   $0x8010909d
80106484:	e8 13 a1 ff ff       	call   8010059c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010648c:	8b 40 04             	mov    0x4(%eax),%eax
8010648f:	83 ec 04             	sub    $0x4,%esp
80106492:	50                   	push   %eax
80106493:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106496:	50                   	push   %eax
80106497:	ff 75 f4             	push   -0xc(%ebp)
8010649a:	e8 02 be ff ff       	call   801022a1 <dirlink>
8010649f:	83 c4 10             	add    $0x10,%esp
801064a2:	85 c0                	test   %eax,%eax
801064a4:	79 0d                	jns    801064b3 <create+0x1bd>
    panic("create: dirlink");
801064a6:	83 ec 0c             	sub    $0xc,%esp
801064a9:	68 a9 90 10 80       	push   $0x801090a9
801064ae:	e8 e9 a0 ff ff       	call   8010059c <panic>

  iunlockput(dp);
801064b3:	83 ec 0c             	sub    $0xc,%esp
801064b6:	ff 75 f4             	push   -0xc(%ebp)
801064b9:	e8 74 b7 ff ff       	call   80101c32 <iunlockput>
801064be:	83 c4 10             	add    $0x10,%esp

  return ip;
801064c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801064c4:	c9                   	leave  
801064c5:	c3                   	ret    

801064c6 <sys_open>:

int
sys_open(void)
{
801064c6:	55                   	push   %ebp
801064c7:	89 e5                	mov    %esp,%ebp
801064c9:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064cc:	83 ec 08             	sub    $0x8,%esp
801064cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064d2:	50                   	push   %eax
801064d3:	6a 00                	push   $0x0
801064d5:	e8 e9 f6 ff ff       	call   80105bc3 <argstr>
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	85 c0                	test   %eax,%eax
801064df:	78 15                	js     801064f6 <sys_open+0x30>
801064e1:	83 ec 08             	sub    $0x8,%esp
801064e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064e7:	50                   	push   %eax
801064e8:	6a 01                	push   $0x1
801064ea:	e8 3f f6 ff ff       	call   80105b2e <argint>
801064ef:	83 c4 10             	add    $0x10,%esp
801064f2:	85 c0                	test   %eax,%eax
801064f4:	79 0a                	jns    80106500 <sys_open+0x3a>
    return -1;
801064f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fb:	e9 61 01 00 00       	jmp    80106661 <sys_open+0x19b>

  begin_op();
80106500:	e8 1e d0 ff ff       	call   80103523 <begin_op>

  if(omode & O_CREATE){
80106505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106508:	25 00 02 00 00       	and    $0x200,%eax
8010650d:	85 c0                	test   %eax,%eax
8010650f:	74 2a                	je     8010653b <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106511:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106514:	6a 00                	push   $0x0
80106516:	6a 00                	push   $0x0
80106518:	6a 02                	push   $0x2
8010651a:	50                   	push   %eax
8010651b:	e8 d6 fd ff ff       	call   801062f6 <create>
80106520:	83 c4 10             	add    $0x10,%esp
80106523:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010652a:	75 75                	jne    801065a1 <sys_open+0xdb>
      end_op();
8010652c:	e8 7e d0 ff ff       	call   801035af <end_op>
      return -1;
80106531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106536:	e9 26 01 00 00       	jmp    80106661 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010653b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010653e:	83 ec 0c             	sub    $0xc,%esp
80106541:	50                   	push   %eax
80106542:	e8 f5 bf ff ff       	call   8010253c <namei>
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010654d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106551:	75 0f                	jne    80106562 <sys_open+0x9c>
      end_op();
80106553:	e8 57 d0 ff ff       	call   801035af <end_op>
      return -1;
80106558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655d:	e9 ff 00 00 00       	jmp    80106661 <sys_open+0x19b>
    }
    ilock(ip);
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	ff 75 f4             	push   -0xc(%ebp)
80106568:	e8 94 b4 ff ff       	call   80101a01 <ilock>
8010656d:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106573:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106577:	66 83 f8 01          	cmp    $0x1,%ax
8010657b:	75 24                	jne    801065a1 <sys_open+0xdb>
8010657d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106580:	85 c0                	test   %eax,%eax
80106582:	74 1d                	je     801065a1 <sys_open+0xdb>
      iunlockput(ip);
80106584:	83 ec 0c             	sub    $0xc,%esp
80106587:	ff 75 f4             	push   -0xc(%ebp)
8010658a:	e8 a3 b6 ff ff       	call   80101c32 <iunlockput>
8010658f:	83 c4 10             	add    $0x10,%esp
      end_op();
80106592:	e8 18 d0 ff ff       	call   801035af <end_op>
      return -1;
80106597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010659c:	e9 c0 00 00 00       	jmp    80106661 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801065a1:	e8 51 aa ff ff       	call   80100ff7 <filealloc>
801065a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065ad:	74 17                	je     801065c6 <sys_open+0x100>
801065af:	83 ec 0c             	sub    $0xc,%esp
801065b2:	ff 75 f0             	push   -0x10(%ebp)
801065b5:	e8 33 f7 ff ff       	call   80105ced <fdalloc>
801065ba:	83 c4 10             	add    $0x10,%esp
801065bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801065c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801065c4:	79 2e                	jns    801065f4 <sys_open+0x12e>
    if(f)
801065c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065ca:	74 0e                	je     801065da <sys_open+0x114>
      fileclose(f);
801065cc:	83 ec 0c             	sub    $0xc,%esp
801065cf:	ff 75 f0             	push   -0x10(%ebp)
801065d2:	e8 de aa ff ff       	call   801010b5 <fileclose>
801065d7:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801065da:	83 ec 0c             	sub    $0xc,%esp
801065dd:	ff 75 f4             	push   -0xc(%ebp)
801065e0:	e8 4d b6 ff ff       	call   80101c32 <iunlockput>
801065e5:	83 c4 10             	add    $0x10,%esp
    end_op();
801065e8:	e8 c2 cf ff ff       	call   801035af <end_op>
    return -1;
801065ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f2:	eb 6d                	jmp    80106661 <sys_open+0x19b>
  }
  iunlock(ip);
801065f4:	83 ec 0c             	sub    $0xc,%esp
801065f7:	ff 75 f4             	push   -0xc(%ebp)
801065fa:	e8 15 b5 ff ff       	call   80101b14 <iunlock>
801065ff:	83 c4 10             	add    $0x10,%esp
  end_op();
80106602:	e8 a8 cf ff ff       	call   801035af <end_op>

  f->type = FD_INODE;
80106607:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010660a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106610:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106613:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106616:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010661c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106626:	83 e0 01             	and    $0x1,%eax
80106629:	85 c0                	test   %eax,%eax
8010662b:	0f 94 c0             	sete   %al
8010662e:	89 c2                	mov    %eax,%edx
80106630:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106633:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106639:	83 e0 01             	and    $0x1,%eax
8010663c:	85 c0                	test   %eax,%eax
8010663e:	75 0a                	jne    8010664a <sys_open+0x184>
80106640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106643:	83 e0 02             	and    $0x2,%eax
80106646:	85 c0                	test   %eax,%eax
80106648:	74 07                	je     80106651 <sys_open+0x18b>
8010664a:	b8 01 00 00 00       	mov    $0x1,%eax
8010664f:	eb 05                	jmp    80106656 <sys_open+0x190>
80106651:	b8 00 00 00 00       	mov    $0x0,%eax
80106656:	89 c2                	mov    %eax,%edx
80106658:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010665b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010665e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106661:	c9                   	leave  
80106662:	c3                   	ret    

80106663 <sys_mkdir>:

int
sys_mkdir(void)
{
80106663:	55                   	push   %ebp
80106664:	89 e5                	mov    %esp,%ebp
80106666:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106669:	e8 b5 ce ff ff       	call   80103523 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010666e:	83 ec 08             	sub    $0x8,%esp
80106671:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106674:	50                   	push   %eax
80106675:	6a 00                	push   $0x0
80106677:	e8 47 f5 ff ff       	call   80105bc3 <argstr>
8010667c:	83 c4 10             	add    $0x10,%esp
8010667f:	85 c0                	test   %eax,%eax
80106681:	78 1b                	js     8010669e <sys_mkdir+0x3b>
80106683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106686:	6a 00                	push   $0x0
80106688:	6a 00                	push   $0x0
8010668a:	6a 01                	push   $0x1
8010668c:	50                   	push   %eax
8010668d:	e8 64 fc ff ff       	call   801062f6 <create>
80106692:	83 c4 10             	add    $0x10,%esp
80106695:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010669c:	75 0c                	jne    801066aa <sys_mkdir+0x47>
    end_op();
8010669e:	e8 0c cf ff ff       	call   801035af <end_op>
    return -1;
801066a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a8:	eb 18                	jmp    801066c2 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801066aa:	83 ec 0c             	sub    $0xc,%esp
801066ad:	ff 75 f4             	push   -0xc(%ebp)
801066b0:	e8 7d b5 ff ff       	call   80101c32 <iunlockput>
801066b5:	83 c4 10             	add    $0x10,%esp
  end_op();
801066b8:	e8 f2 ce ff ff       	call   801035af <end_op>
  return 0;
801066bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066c2:	c9                   	leave  
801066c3:	c3                   	ret    

801066c4 <sys_mknod>:

int
sys_mknod(void)
{
801066c4:	55                   	push   %ebp
801066c5:	89 e5                	mov    %esp,%ebp
801066c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801066ca:	e8 54 ce ff ff       	call   80103523 <begin_op>
  if((argstr(0, &path)) < 0 ||
801066cf:	83 ec 08             	sub    $0x8,%esp
801066d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066d5:	50                   	push   %eax
801066d6:	6a 00                	push   $0x0
801066d8:	e8 e6 f4 ff ff       	call   80105bc3 <argstr>
801066dd:	83 c4 10             	add    $0x10,%esp
801066e0:	85 c0                	test   %eax,%eax
801066e2:	78 4f                	js     80106733 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801066e4:	83 ec 08             	sub    $0x8,%esp
801066e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066ea:	50                   	push   %eax
801066eb:	6a 01                	push   $0x1
801066ed:	e8 3c f4 ff ff       	call   80105b2e <argint>
801066f2:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801066f5:	85 c0                	test   %eax,%eax
801066f7:	78 3a                	js     80106733 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
801066f9:	83 ec 08             	sub    $0x8,%esp
801066fc:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066ff:	50                   	push   %eax
80106700:	6a 02                	push   $0x2
80106702:	e8 27 f4 ff ff       	call   80105b2e <argint>
80106707:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010670a:	85 c0                	test   %eax,%eax
8010670c:	78 25                	js     80106733 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010670e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106711:	0f bf c8             	movswl %ax,%ecx
80106714:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106717:	0f bf d0             	movswl %ax,%edx
8010671a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
8010671d:	51                   	push   %ecx
8010671e:	52                   	push   %edx
8010671f:	6a 03                	push   $0x3
80106721:	50                   	push   %eax
80106722:	e8 cf fb ff ff       	call   801062f6 <create>
80106727:	83 c4 10             	add    $0x10,%esp
8010672a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010672d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106731:	75 0c                	jne    8010673f <sys_mknod+0x7b>
    end_op();
80106733:	e8 77 ce ff ff       	call   801035af <end_op>
    return -1;
80106738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673d:	eb 18                	jmp    80106757 <sys_mknod+0x93>
  }
  iunlockput(ip);
8010673f:	83 ec 0c             	sub    $0xc,%esp
80106742:	ff 75 f4             	push   -0xc(%ebp)
80106745:	e8 e8 b4 ff ff       	call   80101c32 <iunlockput>
8010674a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010674d:	e8 5d ce ff ff       	call   801035af <end_op>
  return 0;
80106752:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106757:	c9                   	leave  
80106758:	c3                   	ret    

80106759 <sys_chdir>:

int
sys_chdir(void)
{
80106759:	55                   	push   %ebp
8010675a:	89 e5                	mov    %esp,%ebp
8010675c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010675f:	e8 15 db ff ff       	call   80104279 <myproc>
80106764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106767:	e8 b7 cd ff ff       	call   80103523 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010676c:	83 ec 08             	sub    $0x8,%esp
8010676f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106772:	50                   	push   %eax
80106773:	6a 00                	push   $0x0
80106775:	e8 49 f4 ff ff       	call   80105bc3 <argstr>
8010677a:	83 c4 10             	add    $0x10,%esp
8010677d:	85 c0                	test   %eax,%eax
8010677f:	78 18                	js     80106799 <sys_chdir+0x40>
80106781:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106784:	83 ec 0c             	sub    $0xc,%esp
80106787:	50                   	push   %eax
80106788:	e8 af bd ff ff       	call   8010253c <namei>
8010678d:	83 c4 10             	add    $0x10,%esp
80106790:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106797:	75 0c                	jne    801067a5 <sys_chdir+0x4c>
    end_op();
80106799:	e8 11 ce ff ff       	call   801035af <end_op>
    return -1;
8010679e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a3:	eb 68                	jmp    8010680d <sys_chdir+0xb4>
  }
  ilock(ip);
801067a5:	83 ec 0c             	sub    $0xc,%esp
801067a8:	ff 75 f0             	push   -0x10(%ebp)
801067ab:	e8 51 b2 ff ff       	call   80101a01 <ilock>
801067b0:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801067b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b6:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801067ba:	66 83 f8 01          	cmp    $0x1,%ax
801067be:	74 1a                	je     801067da <sys_chdir+0x81>
    iunlockput(ip);
801067c0:	83 ec 0c             	sub    $0xc,%esp
801067c3:	ff 75 f0             	push   -0x10(%ebp)
801067c6:	e8 67 b4 ff ff       	call   80101c32 <iunlockput>
801067cb:	83 c4 10             	add    $0x10,%esp
    end_op();
801067ce:	e8 dc cd ff ff       	call   801035af <end_op>
    return -1;
801067d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d8:	eb 33                	jmp    8010680d <sys_chdir+0xb4>
  }
  iunlock(ip);
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	ff 75 f0             	push   -0x10(%ebp)
801067e0:	e8 2f b3 ff ff       	call   80101b14 <iunlock>
801067e5:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801067e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067eb:	8b 40 68             	mov    0x68(%eax),%eax
801067ee:	83 ec 0c             	sub    $0xc,%esp
801067f1:	50                   	push   %eax
801067f2:	e8 6b b3 ff ff       	call   80101b62 <iput>
801067f7:	83 c4 10             	add    $0x10,%esp
  end_op();
801067fa:	e8 b0 cd ff ff       	call   801035af <end_op>
  curproc->cwd = ip;
801067ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106802:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106805:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106808:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010680d:	c9                   	leave  
8010680e:	c3                   	ret    

8010680f <sys_exec>:

int
sys_exec(void)
{
8010680f:	55                   	push   %ebp
80106810:	89 e5                	mov    %esp,%ebp
80106812:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106818:	83 ec 08             	sub    $0x8,%esp
8010681b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010681e:	50                   	push   %eax
8010681f:	6a 00                	push   $0x0
80106821:	e8 9d f3 ff ff       	call   80105bc3 <argstr>
80106826:	83 c4 10             	add    $0x10,%esp
80106829:	85 c0                	test   %eax,%eax
8010682b:	78 18                	js     80106845 <sys_exec+0x36>
8010682d:	83 ec 08             	sub    $0x8,%esp
80106830:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106836:	50                   	push   %eax
80106837:	6a 01                	push   $0x1
80106839:	e8 f0 f2 ff ff       	call   80105b2e <argint>
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	85 c0                	test   %eax,%eax
80106843:	79 0a                	jns    8010684f <sys_exec+0x40>
    return -1;
80106845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684a:	e9 c6 00 00 00       	jmp    80106915 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010684f:	83 ec 04             	sub    $0x4,%esp
80106852:	68 80 00 00 00       	push   $0x80
80106857:	6a 00                	push   $0x0
80106859:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010685f:	50                   	push   %eax
80106860:	e8 9d ef ff ff       	call   80105802 <memset>
80106865:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010686f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106872:	83 f8 1f             	cmp    $0x1f,%eax
80106875:	76 0a                	jbe    80106881 <sys_exec+0x72>
      return -1;
80106877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010687c:	e9 94 00 00 00       	jmp    80106915 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106884:	c1 e0 02             	shl    $0x2,%eax
80106887:	89 c2                	mov    %eax,%edx
80106889:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010688f:	01 c2                	add    %eax,%edx
80106891:	83 ec 08             	sub    $0x8,%esp
80106894:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010689a:	50                   	push   %eax
8010689b:	52                   	push   %edx
8010689c:	e8 ea f1 ff ff       	call   80105a8b <fetchint>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	85 c0                	test   %eax,%eax
801068a6:	79 07                	jns    801068af <sys_exec+0xa0>
      return -1;
801068a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ad:	eb 66                	jmp    80106915 <sys_exec+0x106>
    if(uarg == 0){
801068af:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801068b5:	85 c0                	test   %eax,%eax
801068b7:	75 27                	jne    801068e0 <sys_exec+0xd1>
      argv[i] = 0;
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801068c3:	00 00 00 00 
      break;
801068c7:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801068c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068cb:	83 ec 08             	sub    $0x8,%esp
801068ce:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801068d4:	52                   	push   %edx
801068d5:	50                   	push   %eax
801068d6:	e8 bf a2 ff ff       	call   80100b9a <exec>
801068db:	83 c4 10             	add    $0x10,%esp
801068de:	eb 35                	jmp    80106915 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
801068e0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801068e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068e9:	c1 e2 02             	shl    $0x2,%edx
801068ec:	01 c2                	add    %eax,%edx
801068ee:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801068f4:	83 ec 08             	sub    $0x8,%esp
801068f7:	52                   	push   %edx
801068f8:	50                   	push   %eax
801068f9:	e8 cc f1 ff ff       	call   80105aca <fetchstr>
801068fe:	83 c4 10             	add    $0x10,%esp
80106901:	85 c0                	test   %eax,%eax
80106903:	79 07                	jns    8010690c <sys_exec+0xfd>
      return -1;
80106905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690a:	eb 09                	jmp    80106915 <sys_exec+0x106>
  for(i=0;; i++){
8010690c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106910:	e9 5a ff ff ff       	jmp    8010686f <sys_exec+0x60>
}
80106915:	c9                   	leave  
80106916:	c3                   	ret    

80106917 <sys_pipe>:

int
sys_pipe(void)
{
80106917:	55                   	push   %ebp
80106918:	89 e5                	mov    %esp,%ebp
8010691a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010691d:	83 ec 04             	sub    $0x4,%esp
80106920:	6a 08                	push   $0x8
80106922:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106925:	50                   	push   %eax
80106926:	6a 00                	push   $0x0
80106928:	e8 2e f2 ff ff       	call   80105b5b <argptr>
8010692d:	83 c4 10             	add    $0x10,%esp
80106930:	85 c0                	test   %eax,%eax
80106932:	79 0a                	jns    8010693e <sys_pipe+0x27>
    return -1;
80106934:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106939:	e9 b0 00 00 00       	jmp    801069ee <sys_pipe+0xd7>
  if(pipealloc(&rf, &wf) < 0)
8010693e:	83 ec 08             	sub    $0x8,%esp
80106941:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106944:	50                   	push   %eax
80106945:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106948:	50                   	push   %eax
80106949:	e8 5f d4 ff ff       	call   80103dad <pipealloc>
8010694e:	83 c4 10             	add    $0x10,%esp
80106951:	85 c0                	test   %eax,%eax
80106953:	79 0a                	jns    8010695f <sys_pipe+0x48>
    return -1;
80106955:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695a:	e9 8f 00 00 00       	jmp    801069ee <sys_pipe+0xd7>
  fd0 = -1;
8010695f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106966:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106969:	83 ec 0c             	sub    $0xc,%esp
8010696c:	50                   	push   %eax
8010696d:	e8 7b f3 ff ff       	call   80105ced <fdalloc>
80106972:	83 c4 10             	add    $0x10,%esp
80106975:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010697c:	78 18                	js     80106996 <sys_pipe+0x7f>
8010697e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106981:	83 ec 0c             	sub    $0xc,%esp
80106984:	50                   	push   %eax
80106985:	e8 63 f3 ff ff       	call   80105ced <fdalloc>
8010698a:	83 c4 10             	add    $0x10,%esp
8010698d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106990:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106994:	79 40                	jns    801069d6 <sys_pipe+0xbf>
    if(fd0 >= 0)
80106996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010699a:	78 15                	js     801069b1 <sys_pipe+0x9a>
      myproc()->ofile[fd0] = 0;
8010699c:	e8 d8 d8 ff ff       	call   80104279 <myproc>
801069a1:	89 c2                	mov    %eax,%edx
801069a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a6:	83 c0 08             	add    $0x8,%eax
801069a9:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
801069b0:	00 
    fileclose(rf);
801069b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069b4:	83 ec 0c             	sub    $0xc,%esp
801069b7:	50                   	push   %eax
801069b8:	e8 f8 a6 ff ff       	call   801010b5 <fileclose>
801069bd:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801069c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069c3:	83 ec 0c             	sub    $0xc,%esp
801069c6:	50                   	push   %eax
801069c7:	e8 e9 a6 ff ff       	call   801010b5 <fileclose>
801069cc:	83 c4 10             	add    $0x10,%esp
    return -1;
801069cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d4:	eb 18                	jmp    801069ee <sys_pipe+0xd7>
  }
  fd[0] = fd0;
801069d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069dc:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801069de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069e1:	8d 50 04             	lea    0x4(%eax),%edx
801069e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069e7:	89 02                	mov    %eax,(%edx)
  return 0;
801069e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069ee:	c9                   	leave  
801069ef:	c3                   	ret    

801069f0 <sys_fork>:
#include "barrier.h"
/////////////////// End of new addition ///////////////////////

int
sys_fork(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	83 ec 08             	sub    $0x8,%esp
  return fork();
801069f6:	e8 83 db ff ff       	call   8010457e <fork>
}
801069fb:	c9                   	leave  
801069fc:	c3                   	ret    

801069fd <sys_exit>:

int
sys_exit(void)
{
801069fd:	55                   	push   %ebp
801069fe:	89 e5                	mov    %esp,%ebp
80106a00:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a03:	e8 fe dc ff ff       	call   80104706 <exit>
  return 0;  // not reached
80106a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a0d:	c9                   	leave  
80106a0e:	c3                   	ret    

80106a0f <sys_wait>:

int
sys_wait(void)
{
80106a0f:	55                   	push   %ebp
80106a10:	89 e5                	mov    %esp,%ebp
80106a12:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a15:	e8 23 de ff ff       	call   8010483d <wait>
}
80106a1a:	c9                   	leave  
80106a1b:	c3                   	ret    

80106a1c <sys_kill>:

int
sys_kill(void)
{
80106a1c:	55                   	push   %ebp
80106a1d:	89 e5                	mov    %esp,%ebp
80106a1f:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a22:	83 ec 08             	sub    $0x8,%esp
80106a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a28:	50                   	push   %eax
80106a29:	6a 00                	push   $0x0
80106a2b:	e8 fe f0 ff ff       	call   80105b2e <argint>
80106a30:	83 c4 10             	add    $0x10,%esp
80106a33:	85 c0                	test   %eax,%eax
80106a35:	79 07                	jns    80106a3e <sys_kill+0x22>
    return -1;
80106a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3c:	eb 0f                	jmp    80106a4d <sys_kill+0x31>
  return kill(pid);
80106a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a41:	83 ec 0c             	sub    $0xc,%esp
80106a44:	50                   	push   %eax
80106a45:	e8 c8 e2 ff ff       	call   80104d12 <kill>
80106a4a:	83 c4 10             	add    $0x10,%esp
}
80106a4d:	c9                   	leave  
80106a4e:	c3                   	ret    

80106a4f <sys_getpid>:

int
sys_getpid(void)
{
80106a4f:	55                   	push   %ebp
80106a50:	89 e5                	mov    %esp,%ebp
80106a52:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106a55:	e8 1f d8 ff ff       	call   80104279 <myproc>
80106a5a:	8b 40 10             	mov    0x10(%eax),%eax
}
80106a5d:	c9                   	leave  
80106a5e:	c3                   	ret    

80106a5f <sys_sbrk>:

int
sys_sbrk(void)
{
80106a5f:	55                   	push   %ebp
80106a60:	89 e5                	mov    %esp,%ebp
80106a62:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a65:	83 ec 08             	sub    $0x8,%esp
80106a68:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a6b:	50                   	push   %eax
80106a6c:	6a 00                	push   $0x0
80106a6e:	e8 bb f0 ff ff       	call   80105b2e <argint>
80106a73:	83 c4 10             	add    $0x10,%esp
80106a76:	85 c0                	test   %eax,%eax
80106a78:	79 07                	jns    80106a81 <sys_sbrk+0x22>
    return -1;
80106a7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7f:	eb 27                	jmp    80106aa8 <sys_sbrk+0x49>
  addr = myproc()->sz;
80106a81:	e8 f3 d7 ff ff       	call   80104279 <myproc>
80106a86:	8b 00                	mov    (%eax),%eax
80106a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a8e:	83 ec 0c             	sub    $0xc,%esp
80106a91:	50                   	push   %eax
80106a92:	e8 4c da ff ff       	call   801044e3 <growproc>
80106a97:	83 c4 10             	add    $0x10,%esp
80106a9a:	85 c0                	test   %eax,%eax
80106a9c:	79 07                	jns    80106aa5 <sys_sbrk+0x46>
    return -1;
80106a9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa3:	eb 03                	jmp    80106aa8 <sys_sbrk+0x49>
  return addr;
80106aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106aa8:	c9                   	leave  
80106aa9:	c3                   	ret    

80106aaa <sys_sleep>:

int
sys_sleep(void)
{
80106aaa:	55                   	push   %ebp
80106aab:	89 e5                	mov    %esp,%ebp
80106aad:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106ab0:	83 ec 08             	sub    $0x8,%esp
80106ab3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ab6:	50                   	push   %eax
80106ab7:	6a 00                	push   $0x0
80106ab9:	e8 70 f0 ff ff       	call   80105b2e <argint>
80106abe:	83 c4 10             	add    $0x10,%esp
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	79 07                	jns    80106acc <sys_sleep+0x22>
    return -1;
80106ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aca:	eb 76                	jmp    80106b42 <sys_sleep+0x98>
  acquire(&tickslock);
80106acc:	83 ec 0c             	sub    $0xc,%esp
80106acf:	68 20 6e 11 80       	push   $0x80116e20
80106ad4:	e8 a2 ea ff ff       	call   8010557b <acquire>
80106ad9:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106adc:	a1 60 76 11 80       	mov    0x80117660,%eax
80106ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106ae4:	eb 38                	jmp    80106b1e <sys_sleep+0x74>
    if(myproc()->killed){
80106ae6:	e8 8e d7 ff ff       	call   80104279 <myproc>
80106aeb:	8b 40 24             	mov    0x24(%eax),%eax
80106aee:	85 c0                	test   %eax,%eax
80106af0:	74 17                	je     80106b09 <sys_sleep+0x5f>
      release(&tickslock);
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	68 20 6e 11 80       	push   $0x80116e20
80106afa:	e8 ea ea ff ff       	call   801055e9 <release>
80106aff:	83 c4 10             	add    $0x10,%esp
      return -1;
80106b02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b07:	eb 39                	jmp    80106b42 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80106b09:	83 ec 08             	sub    $0x8,%esp
80106b0c:	68 20 6e 11 80       	push   $0x80116e20
80106b11:	68 60 76 11 80       	push   $0x80117660
80106b16:	e8 da e0 ff ff       	call   80104bf5 <sleep>
80106b1b:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106b1e:	a1 60 76 11 80       	mov    0x80117660,%eax
80106b23:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b29:	39 d0                	cmp    %edx,%eax
80106b2b:	72 b9                	jb     80106ae6 <sys_sleep+0x3c>
  }
  release(&tickslock);
80106b2d:	83 ec 0c             	sub    $0xc,%esp
80106b30:	68 20 6e 11 80       	push   $0x80116e20
80106b35:	e8 af ea ff ff       	call   801055e9 <release>
80106b3a:	83 c4 10             	add    $0x10,%esp
  return 0;
80106b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b42:	c9                   	leave  
80106b43:	c3                   	ret    

80106b44 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106b44:	55                   	push   %ebp
80106b45:	89 e5                	mov    %esp,%ebp
80106b47:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 20 6e 11 80       	push   $0x80116e20
80106b52:	e8 24 ea ff ff       	call   8010557b <acquire>
80106b57:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106b5a:	a1 60 76 11 80       	mov    0x80117660,%eax
80106b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106b62:	83 ec 0c             	sub    $0xc,%esp
80106b65:	68 20 6e 11 80       	push   $0x80116e20
80106b6a:	e8 7a ea ff ff       	call   801055e9 <release>
80106b6f:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b75:	c9                   	leave  
80106b76:	c3                   	ret    

80106b77 <sys_thread_create>:

/////////////////// New addition ///////////////////////
int sys_thread_create(void){
80106b77:	55                   	push   %ebp
80106b78:	89 e5                	mov    %esp,%ebp
80106b7a:	83 ec 28             	sub    $0x28,%esp
  char* ptid;
  char* fptr;
  char* pargs;
  int pos = 0;
80106b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  argptr(0, &ptid, sizeof(int*));
80106b84:	83 ec 04             	sub    $0x4,%esp
80106b87:	6a 04                	push   $0x4
80106b89:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b8c:	50                   	push   %eax
80106b8d:	6a 00                	push   $0x0
80106b8f:	e8 c7 ef ff ff       	call   80105b5b <argptr>
80106b94:	83 c4 10             	add    $0x10,%esp
  pos += sizeof(int*) / 4;
80106b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9a:	83 c0 01             	add    $0x1,%eax
80106b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  argptr(pos, &fptr, sizeof(void*));
80106ba0:	83 ec 04             	sub    $0x4,%esp
80106ba3:	6a 04                	push   $0x4
80106ba5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ba8:	50                   	push   %eax
80106ba9:	ff 75 f4             	push   -0xc(%ebp)
80106bac:	e8 aa ef ff ff       	call   80105b5b <argptr>
80106bb1:	83 c4 10             	add    $0x10,%esp
  pos += sizeof(void*) / 4;
80106bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb7:	83 c0 01             	add    $0x1,%eax
80106bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  argptr(pos, &pargs, sizeof(void *));
80106bbd:	83 ec 04             	sub    $0x4,%esp
80106bc0:	6a 04                	push   $0x4
80106bc2:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106bc5:	50                   	push   %eax
80106bc6:	ff 75 f4             	push   -0xc(%ebp)
80106bc9:	e8 8d ef ff ff       	call   80105b5b <argptr>
80106bce:	83 c4 10             	add    $0x10,%esp

  uint * tid = (uint *) ptid;
80106bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  void * func_ptr = (void *)fptr;
80106bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  void * arg_ptr = (void *)pargs;
80106bdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106be0:	89 45 e8             	mov    %eax,-0x18(%ebp)

  thread_create(tid, func_ptr, arg_ptr);
80106be3:	83 ec 04             	sub    $0x4,%esp
80106be6:	ff 75 e8             	push   -0x18(%ebp)
80106be9:	ff 75 ec             	push   -0x14(%ebp)
80106bec:	ff 75 f0             	push   -0x10(%ebp)
80106bef:	e8 bb e3 ff ff       	call   80104faf <thread_create>
80106bf4:	83 c4 10             	add    $0x10,%esp
  return -1;
80106bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bfc:	c9                   	leave  
80106bfd:	c3                   	ret    

80106bfe <sys_thread_exit>:

int sys_thread_exit(void){
80106bfe:	55                   	push   %ebp
80106bff:	89 e5                	mov    %esp,%ebp
80106c01:	83 ec 08             	sub    $0x8,%esp
  return thread_exit();
80106c04:	e8 73 e5 ff ff       	call   8010517c <thread_exit>
}
80106c09:	c9                   	leave  
80106c0a:	c3                   	ret    

80106c0b <sys_thread_join>:

int sys_thread_join(void){
80106c0b:	55                   	push   %ebp
80106c0c:	89 e5                	mov    %esp,%ebp
80106c0e:	83 ec 18             	sub    $0x18,%esp
  int tid;
  if (argint(0, &tid) < 0)
80106c11:	83 ec 08             	sub    $0x8,%esp
80106c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c17:	50                   	push   %eax
80106c18:	6a 00                	push   $0x0
80106c1a:	e8 0f ef ff ff       	call   80105b2e <argint>
80106c1f:	83 c4 10             	add    $0x10,%esp
80106c22:	85 c0                	test   %eax,%eax
80106c24:	79 07                	jns    80106c2d <sys_thread_join+0x22>
    return -1;
80106c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c2b:	eb 0f                	jmp    80106c3c <sys_thread_join+0x31>
  // cprintf("here\n");
  return thread_join((uint)tid);
80106c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	50                   	push   %eax
80106c34:	e8 84 e6 ff ff       	call   801052bd <thread_join>
80106c39:	83 c4 10             	add    $0x10,%esp
  // return 0;
}
80106c3c:	c9                   	leave  
80106c3d:	c3                   	ret    

80106c3e <sys_barrier_init>:

int sys_barrier_init(void)
{
80106c3e:	55                   	push   %ebp
80106c3f:	89 e5                	mov    %esp,%ebp
80106c41:	83 ec 18             	sub    $0x18,%esp
  int n;
  if (argint(0, &n) < 0)
80106c44:	83 ec 08             	sub    $0x8,%esp
80106c47:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c4a:	50                   	push   %eax
80106c4b:	6a 00                	push   $0x0
80106c4d:	e8 dc ee ff ff       	call   80105b2e <argint>
80106c52:	83 c4 10             	add    $0x10,%esp
80106c55:	85 c0                	test   %eax,%eax
80106c57:	79 07                	jns    80106c60 <sys_barrier_init+0x22>
    return -1;
80106c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5e:	eb 0f                	jmp    80106c6f <sys_barrier_init+0x31>
  
  return barrier_init(n);
80106c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c63:	83 ec 0c             	sub    $0xc,%esp
80106c66:	50                   	push   %eax
80106c67:	e8 84 1e 00 00       	call   80108af0 <barrier_init>
80106c6c:	83 c4 10             	add    $0x10,%esp
}
80106c6f:	c9                   	leave  
80106c70:	c3                   	ret    

80106c71 <sys_barrier_check>:

int sys_barrier_check(void)
{
80106c71:	55                   	push   %ebp
80106c72:	89 e5                	mov    %esp,%ebp
80106c74:	83 ec 08             	sub    $0x8,%esp
  return barrier_check();
80106c77:	e8 a6 1e 00 00       	call   80108b22 <barrier_check>
}
80106c7c:	c9                   	leave  
80106c7d:	c3                   	ret    

80106c7e <sys_waitpid>:

int sys_waitpid(void)
{
80106c7e:	55                   	push   %ebp
80106c7f:	89 e5                	mov    %esp,%ebp
80106c81:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if (argint(0, &pid) < 0){
80106c84:	83 ec 08             	sub    $0x8,%esp
80106c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c8a:	50                   	push   %eax
80106c8b:	6a 00                	push   $0x0
80106c8d:	e8 9c ee ff ff       	call   80105b2e <argint>
80106c92:	83 c4 10             	add    $0x10,%esp
80106c95:	85 c0                	test   %eax,%eax
80106c97:	79 07                	jns    80106ca0 <sys_waitpid+0x22>
    return -1;
80106c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c9e:	eb 0f                	jmp    80106caf <sys_waitpid+0x31>
  }

  return waitpid(pid);
80106ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ca3:	83 ec 0c             	sub    $0xc,%esp
80106ca6:	50                   	push   %eax
80106ca7:	e8 e3 e1 ff ff       	call   80104e8f <waitpid>
80106cac:	83 c4 10             	add    $0x10,%esp
}
80106caf:	c9                   	leave  
80106cb0:	c3                   	ret    

80106cb1 <sys_sleepChan>:

////////////////// End of new addition /////////////////
/////////// Parts D and E of threads lab/////////
int sys_sleepChan(void) {
80106cb1:	55                   	push   %ebp
80106cb2:	89 e5                	mov    %esp,%ebp
  return -1;
80106cb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cb9:	5d                   	pop    %ebp
80106cba:	c3                   	ret    

80106cbb <sys_getChannel>:

int sys_getChannel(void) {
80106cbb:	55                   	push   %ebp
80106cbc:	89 e5                	mov    %esp,%ebp
  return -1;
80106cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc3:	5d                   	pop    %ebp
80106cc4:	c3                   	ret    

80106cc5 <sys_sigChan>:

int sys_sigChan(void) {
80106cc5:	55                   	push   %ebp
80106cc6:	89 e5                	mov    %esp,%ebp
  return -1;
80106cc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ccd:	5d                   	pop    %ebp
80106cce:	c3                   	ret    

80106ccf <sys_sigOneChan>:

int sys_sigOneChan(void) {
80106ccf:	55                   	push   %ebp
80106cd0:	89 e5                	mov    %esp,%ebp
  return -1;
80106cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd7:	5d                   	pop    %ebp
80106cd8:	c3                   	ret    

80106cd9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106cd9:	1e                   	push   %ds
  pushl %es
80106cda:	06                   	push   %es
  pushl %fs
80106cdb:	0f a0                	push   %fs
  pushl %gs
80106cdd:	0f a8                	push   %gs
  pushal
80106cdf:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106ce0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106ce4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106ce6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106ce8:	54                   	push   %esp
  call trap
80106ce9:	e8 d7 01 00 00       	call   80106ec5 <trap>
  addl $4, %esp
80106cee:	83 c4 04             	add    $0x4,%esp

80106cf1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106cf1:	61                   	popa   
  popl %gs
80106cf2:	0f a9                	pop    %gs
  popl %fs
80106cf4:	0f a1                	pop    %fs
  popl %es
80106cf6:	07                   	pop    %es
  popl %ds
80106cf7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106cf8:	83 c4 08             	add    $0x8,%esp
  iret
80106cfb:	cf                   	iret   

80106cfc <lidt>:
{
80106cfc:	55                   	push   %ebp
80106cfd:	89 e5                	mov    %esp,%ebp
80106cff:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d05:	83 e8 01             	sub    $0x1,%eax
80106d08:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d13:	8b 45 08             	mov    0x8(%ebp),%eax
80106d16:	c1 e8 10             	shr    $0x10,%eax
80106d19:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106d1d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d20:	0f 01 18             	lidtl  (%eax)
}
80106d23:	90                   	nop
80106d24:	c9                   	leave  
80106d25:	c3                   	ret    

80106d26 <rcr2>:

static inline uint
rcr2(void)
{
80106d26:	55                   	push   %ebp
80106d27:	89 e5                	mov    %esp,%ebp
80106d29:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d2c:	0f 20 d0             	mov    %cr2,%eax
80106d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d35:	c9                   	leave  
80106d36:	c3                   	ret    

80106d37 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106d37:	55                   	push   %ebp
80106d38:	89 e5                	mov    %esp,%ebp
80106d3a:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d44:	e9 c3 00 00 00       	jmp    80106e0c <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d4c:	8b 04 85 c0 c0 10 80 	mov    -0x7fef3f40(,%eax,4),%eax
80106d53:	89 c2                	mov    %eax,%edx
80106d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d58:	66 89 14 c5 60 6e 11 	mov    %dx,-0x7fee91a0(,%eax,8)
80106d5f:	80 
80106d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d63:	66 c7 04 c5 62 6e 11 	movw   $0x8,-0x7fee919e(,%eax,8)
80106d6a:	80 08 00 
80106d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d70:	0f b6 14 c5 64 6e 11 	movzbl -0x7fee919c(,%eax,8),%edx
80106d77:	80 
80106d78:	83 e2 e0             	and    $0xffffffe0,%edx
80106d7b:	88 14 c5 64 6e 11 80 	mov    %dl,-0x7fee919c(,%eax,8)
80106d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d85:	0f b6 14 c5 64 6e 11 	movzbl -0x7fee919c(,%eax,8),%edx
80106d8c:	80 
80106d8d:	83 e2 1f             	and    $0x1f,%edx
80106d90:	88 14 c5 64 6e 11 80 	mov    %dl,-0x7fee919c(,%eax,8)
80106d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9a:	0f b6 14 c5 65 6e 11 	movzbl -0x7fee919b(,%eax,8),%edx
80106da1:	80 
80106da2:	83 e2 f0             	and    $0xfffffff0,%edx
80106da5:	83 ca 0e             	or     $0xe,%edx
80106da8:	88 14 c5 65 6e 11 80 	mov    %dl,-0x7fee919b(,%eax,8)
80106daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db2:	0f b6 14 c5 65 6e 11 	movzbl -0x7fee919b(,%eax,8),%edx
80106db9:	80 
80106dba:	83 e2 ef             	and    $0xffffffef,%edx
80106dbd:	88 14 c5 65 6e 11 80 	mov    %dl,-0x7fee919b(,%eax,8)
80106dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc7:	0f b6 14 c5 65 6e 11 	movzbl -0x7fee919b(,%eax,8),%edx
80106dce:	80 
80106dcf:	83 e2 9f             	and    $0xffffff9f,%edx
80106dd2:	88 14 c5 65 6e 11 80 	mov    %dl,-0x7fee919b(,%eax,8)
80106dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ddc:	0f b6 14 c5 65 6e 11 	movzbl -0x7fee919b(,%eax,8),%edx
80106de3:	80 
80106de4:	83 ca 80             	or     $0xffffff80,%edx
80106de7:	88 14 c5 65 6e 11 80 	mov    %dl,-0x7fee919b(,%eax,8)
80106dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df1:	8b 04 85 c0 c0 10 80 	mov    -0x7fef3f40(,%eax,4),%eax
80106df8:	c1 e8 10             	shr    $0x10,%eax
80106dfb:	89 c2                	mov    %eax,%edx
80106dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e00:	66 89 14 c5 66 6e 11 	mov    %dx,-0x7fee919a(,%eax,8)
80106e07:	80 
  for(i = 0; i < 256; i++)
80106e08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e0c:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e13:	0f 8e 30 ff ff ff    	jle    80106d49 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e19:	a1 c0 c1 10 80       	mov    0x8010c1c0,%eax
80106e1e:	66 a3 60 70 11 80    	mov    %ax,0x80117060
80106e24:	66 c7 05 62 70 11 80 	movw   $0x8,0x80117062
80106e2b:	08 00 
80106e2d:	0f b6 05 64 70 11 80 	movzbl 0x80117064,%eax
80106e34:	83 e0 e0             	and    $0xffffffe0,%eax
80106e37:	a2 64 70 11 80       	mov    %al,0x80117064
80106e3c:	0f b6 05 64 70 11 80 	movzbl 0x80117064,%eax
80106e43:	83 e0 1f             	and    $0x1f,%eax
80106e46:	a2 64 70 11 80       	mov    %al,0x80117064
80106e4b:	0f b6 05 65 70 11 80 	movzbl 0x80117065,%eax
80106e52:	83 c8 0f             	or     $0xf,%eax
80106e55:	a2 65 70 11 80       	mov    %al,0x80117065
80106e5a:	0f b6 05 65 70 11 80 	movzbl 0x80117065,%eax
80106e61:	83 e0 ef             	and    $0xffffffef,%eax
80106e64:	a2 65 70 11 80       	mov    %al,0x80117065
80106e69:	0f b6 05 65 70 11 80 	movzbl 0x80117065,%eax
80106e70:	83 c8 60             	or     $0x60,%eax
80106e73:	a2 65 70 11 80       	mov    %al,0x80117065
80106e78:	0f b6 05 65 70 11 80 	movzbl 0x80117065,%eax
80106e7f:	83 c8 80             	or     $0xffffff80,%eax
80106e82:	a2 65 70 11 80       	mov    %al,0x80117065
80106e87:	a1 c0 c1 10 80       	mov    0x8010c1c0,%eax
80106e8c:	c1 e8 10             	shr    $0x10,%eax
80106e8f:	66 a3 66 70 11 80    	mov    %ax,0x80117066

  initlock(&tickslock, "time");
80106e95:	83 ec 08             	sub    $0x8,%esp
80106e98:	68 bc 90 10 80       	push   $0x801090bc
80106e9d:	68 20 6e 11 80       	push   $0x80116e20
80106ea2:	e8 b2 e6 ff ff       	call   80105559 <initlock>
80106ea7:	83 c4 10             	add    $0x10,%esp
}
80106eaa:	90                   	nop
80106eab:	c9                   	leave  
80106eac:	c3                   	ret    

80106ead <idtinit>:

void
idtinit(void)
{
80106ead:	55                   	push   %ebp
80106eae:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106eb0:	68 00 08 00 00       	push   $0x800
80106eb5:	68 60 6e 11 80       	push   $0x80116e60
80106eba:	e8 3d fe ff ff       	call   80106cfc <lidt>
80106ebf:	83 c4 08             	add    $0x8,%esp
}
80106ec2:	90                   	nop
80106ec3:	c9                   	leave  
80106ec4:	c3                   	ret    

80106ec5 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ec5:	55                   	push   %ebp
80106ec6:	89 e5                	mov    %esp,%ebp
80106ec8:	57                   	push   %edi
80106ec9:	56                   	push   %esi
80106eca:	53                   	push   %ebx
80106ecb:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106ece:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed1:	8b 40 30             	mov    0x30(%eax),%eax
80106ed4:	83 f8 40             	cmp    $0x40,%eax
80106ed7:	75 3d                	jne    80106f16 <trap+0x51>
    if(myproc()->killed)
80106ed9:	e8 9b d3 ff ff       	call   80104279 <myproc>
80106ede:	8b 40 24             	mov    0x24(%eax),%eax
80106ee1:	85 c0                	test   %eax,%eax
80106ee3:	74 05                	je     80106eea <trap+0x25>
      exit();
80106ee5:	e8 1c d8 ff ff       	call   80104706 <exit>
    myproc()->tf = tf;
80106eea:	e8 8a d3 ff ff       	call   80104279 <myproc>
80106eef:	89 c2                	mov    %eax,%edx
80106ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef4:	89 42 18             	mov    %eax,0x18(%edx)
    syscall();
80106ef7:	e8 fe ec ff ff       	call   80105bfa <syscall>
    if(myproc()->killed)
80106efc:	e8 78 d3 ff ff       	call   80104279 <myproc>
80106f01:	8b 40 24             	mov    0x24(%eax),%eax
80106f04:	85 c0                	test   %eax,%eax
80106f06:	0f 84 04 02 00 00    	je     80107110 <trap+0x24b>
      exit();
80106f0c:	e8 f5 d7 ff ff       	call   80104706 <exit>
    return;
80106f11:	e9 fa 01 00 00       	jmp    80107110 <trap+0x24b>
  }

  switch(tf->trapno){
80106f16:	8b 45 08             	mov    0x8(%ebp),%eax
80106f19:	8b 40 30             	mov    0x30(%eax),%eax
80106f1c:	83 e8 20             	sub    $0x20,%eax
80106f1f:	83 f8 1f             	cmp    $0x1f,%eax
80106f22:	0f 87 b5 00 00 00    	ja     80106fdd <trap+0x118>
80106f28:	8b 04 85 64 91 10 80 	mov    -0x7fef6e9c(,%eax,4),%eax
80106f2f:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106f31:	e8 aa d2 ff ff       	call   801041e0 <cpuid>
80106f36:	85 c0                	test   %eax,%eax
80106f38:	75 3d                	jne    80106f77 <trap+0xb2>
      acquire(&tickslock);
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 20 6e 11 80       	push   $0x80116e20
80106f42:	e8 34 e6 ff ff       	call   8010557b <acquire>
80106f47:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106f4a:	a1 60 76 11 80       	mov    0x80117660,%eax
80106f4f:	83 c0 01             	add    $0x1,%eax
80106f52:	a3 60 76 11 80       	mov    %eax,0x80117660
      wakeup(&ticks);
80106f57:	83 ec 0c             	sub    $0xc,%esp
80106f5a:	68 60 76 11 80       	push   $0x80117660
80106f5f:	e8 77 dd ff ff       	call   80104cdb <wakeup>
80106f64:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106f67:	83 ec 0c             	sub    $0xc,%esp
80106f6a:	68 20 6e 11 80       	push   $0x80116e20
80106f6f:	e8 75 e6 ff ff       	call   801055e9 <release>
80106f74:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106f77:	e8 7d c0 ff ff       	call   80102ff9 <lapiceoi>
    break;
80106f7c:	e9 0f 01 00 00       	jmp    80107090 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106f81:	e8 ed b8 ff ff       	call   80102873 <ideintr>
    lapiceoi();
80106f86:	e8 6e c0 ff ff       	call   80102ff9 <lapiceoi>
    break;
80106f8b:	e9 00 01 00 00       	jmp    80107090 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106f90:	e8 ad be ff ff       	call   80102e42 <kbdintr>
    lapiceoi();
80106f95:	e8 5f c0 ff ff       	call   80102ff9 <lapiceoi>
    break;
80106f9a:	e9 f1 00 00 00       	jmp    80107090 <trap+0x1cb>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106f9f:	e8 40 03 00 00       	call   801072e4 <uartintr>
    lapiceoi();
80106fa4:	e8 50 c0 ff ff       	call   80102ff9 <lapiceoi>
    break;
80106fa9:	e9 e2 00 00 00       	jmp    80107090 <trap+0x1cb>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fae:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb1:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fbb:	0f b7 d8             	movzwl %ax,%ebx
80106fbe:	e8 1d d2 ff ff       	call   801041e0 <cpuid>
80106fc3:	56                   	push   %esi
80106fc4:	53                   	push   %ebx
80106fc5:	50                   	push   %eax
80106fc6:	68 c4 90 10 80       	push   $0x801090c4
80106fcb:	e8 2c 94 ff ff       	call   801003fc <cprintf>
80106fd0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106fd3:	e8 21 c0 ff ff       	call   80102ff9 <lapiceoi>
    break;
80106fd8:	e9 b3 00 00 00       	jmp    80107090 <trap+0x1cb>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106fdd:	e8 97 d2 ff ff       	call   80104279 <myproc>
80106fe2:	85 c0                	test   %eax,%eax
80106fe4:	74 11                	je     80106ff7 <trap+0x132>
80106fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fed:	0f b7 c0             	movzwl %ax,%eax
80106ff0:	83 e0 03             	and    $0x3,%eax
80106ff3:	85 c0                	test   %eax,%eax
80106ff5:	75 3b                	jne    80107032 <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ff7:	e8 2a fd ff ff       	call   80106d26 <rcr2>
80106ffc:	89 c6                	mov    %eax,%esi
80106ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80107001:	8b 58 38             	mov    0x38(%eax),%ebx
80107004:	e8 d7 d1 ff ff       	call   801041e0 <cpuid>
80107009:	89 c2                	mov    %eax,%edx
8010700b:	8b 45 08             	mov    0x8(%ebp),%eax
8010700e:	8b 40 30             	mov    0x30(%eax),%eax
80107011:	83 ec 0c             	sub    $0xc,%esp
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	52                   	push   %edx
80107017:	50                   	push   %eax
80107018:	68 e8 90 10 80       	push   $0x801090e8
8010701d:	e8 da 93 ff ff       	call   801003fc <cprintf>
80107022:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80107025:	83 ec 0c             	sub    $0xc,%esp
80107028:	68 1a 91 10 80       	push   $0x8010911a
8010702d:	e8 6a 95 ff ff       	call   8010059c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107032:	e8 ef fc ff ff       	call   80106d26 <rcr2>
80107037:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010703a:	8b 45 08             	mov    0x8(%ebp),%eax
8010703d:	8b 78 38             	mov    0x38(%eax),%edi
80107040:	e8 9b d1 ff ff       	call   801041e0 <cpuid>
80107045:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107048:	8b 45 08             	mov    0x8(%ebp),%eax
8010704b:	8b 70 34             	mov    0x34(%eax),%esi
8010704e:	8b 45 08             	mov    0x8(%ebp),%eax
80107051:	8b 58 30             	mov    0x30(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80107054:	e8 20 d2 ff ff       	call   80104279 <myproc>
80107059:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010705c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010705f:	e8 15 d2 ff ff       	call   80104279 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107064:	8b 40 10             	mov    0x10(%eax),%eax
80107067:	ff 75 e4             	push   -0x1c(%ebp)
8010706a:	57                   	push   %edi
8010706b:	ff 75 e0             	push   -0x20(%ebp)
8010706e:	56                   	push   %esi
8010706f:	53                   	push   %ebx
80107070:	ff 75 dc             	push   -0x24(%ebp)
80107073:	50                   	push   %eax
80107074:	68 20 91 10 80       	push   $0x80109120
80107079:	e8 7e 93 ff ff       	call   801003fc <cprintf>
8010707e:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80107081:	e8 f3 d1 ff ff       	call   80104279 <myproc>
80107086:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010708d:	eb 01                	jmp    80107090 <trap+0x1cb>
    break;
8010708f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107090:	e8 e4 d1 ff ff       	call   80104279 <myproc>
80107095:	85 c0                	test   %eax,%eax
80107097:	74 23                	je     801070bc <trap+0x1f7>
80107099:	e8 db d1 ff ff       	call   80104279 <myproc>
8010709e:	8b 40 24             	mov    0x24(%eax),%eax
801070a1:	85 c0                	test   %eax,%eax
801070a3:	74 17                	je     801070bc <trap+0x1f7>
801070a5:	8b 45 08             	mov    0x8(%ebp),%eax
801070a8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070ac:	0f b7 c0             	movzwl %ax,%eax
801070af:	83 e0 03             	and    $0x3,%eax
801070b2:	83 f8 03             	cmp    $0x3,%eax
801070b5:	75 05                	jne    801070bc <trap+0x1f7>
    exit();
801070b7:	e8 4a d6 ff ff       	call   80104706 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801070bc:	e8 b8 d1 ff ff       	call   80104279 <myproc>
801070c1:	85 c0                	test   %eax,%eax
801070c3:	74 1d                	je     801070e2 <trap+0x21d>
801070c5:	e8 af d1 ff ff       	call   80104279 <myproc>
801070ca:	8b 40 0c             	mov    0xc(%eax),%eax
801070cd:	83 f8 04             	cmp    $0x4,%eax
801070d0:	75 10                	jne    801070e2 <trap+0x21d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801070d2:	8b 45 08             	mov    0x8(%ebp),%eax
801070d5:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801070d8:	83 f8 20             	cmp    $0x20,%eax
801070db:	75 05                	jne    801070e2 <trap+0x21d>
    yield();
801070dd:	e8 93 da ff ff       	call   80104b75 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801070e2:	e8 92 d1 ff ff       	call   80104279 <myproc>
801070e7:	85 c0                	test   %eax,%eax
801070e9:	74 26                	je     80107111 <trap+0x24c>
801070eb:	e8 89 d1 ff ff       	call   80104279 <myproc>
801070f0:	8b 40 24             	mov    0x24(%eax),%eax
801070f3:	85 c0                	test   %eax,%eax
801070f5:	74 1a                	je     80107111 <trap+0x24c>
801070f7:	8b 45 08             	mov    0x8(%ebp),%eax
801070fa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070fe:	0f b7 c0             	movzwl %ax,%eax
80107101:	83 e0 03             	and    $0x3,%eax
80107104:	83 f8 03             	cmp    $0x3,%eax
80107107:	75 08                	jne    80107111 <trap+0x24c>
    exit();
80107109:	e8 f8 d5 ff ff       	call   80104706 <exit>
8010710e:	eb 01                	jmp    80107111 <trap+0x24c>
    return;
80107110:	90                   	nop
}
80107111:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107114:	5b                   	pop    %ebx
80107115:	5e                   	pop    %esi
80107116:	5f                   	pop    %edi
80107117:	5d                   	pop    %ebp
80107118:	c3                   	ret    

80107119 <inb>:
{
80107119:	55                   	push   %ebp
8010711a:	89 e5                	mov    %esp,%ebp
8010711c:	83 ec 14             	sub    $0x14,%esp
8010711f:	8b 45 08             	mov    0x8(%ebp),%eax
80107122:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107126:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010712a:	89 c2                	mov    %eax,%edx
8010712c:	ec                   	in     (%dx),%al
8010712d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107130:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107134:	c9                   	leave  
80107135:	c3                   	ret    

80107136 <outb>:
{
80107136:	55                   	push   %ebp
80107137:	89 e5                	mov    %esp,%ebp
80107139:	83 ec 08             	sub    $0x8,%esp
8010713c:	8b 55 08             	mov    0x8(%ebp),%edx
8010713f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107142:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107146:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107149:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010714d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107151:	ee                   	out    %al,(%dx)
}
80107152:	90                   	nop
80107153:	c9                   	leave  
80107154:	c3                   	ret    

80107155 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107155:	55                   	push   %ebp
80107156:	89 e5                	mov    %esp,%ebp
80107158:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010715b:	6a 00                	push   $0x0
8010715d:	68 fa 03 00 00       	push   $0x3fa
80107162:	e8 cf ff ff ff       	call   80107136 <outb>
80107167:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010716a:	68 80 00 00 00       	push   $0x80
8010716f:	68 fb 03 00 00       	push   $0x3fb
80107174:	e8 bd ff ff ff       	call   80107136 <outb>
80107179:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010717c:	6a 0c                	push   $0xc
8010717e:	68 f8 03 00 00       	push   $0x3f8
80107183:	e8 ae ff ff ff       	call   80107136 <outb>
80107188:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010718b:	6a 00                	push   $0x0
8010718d:	68 f9 03 00 00       	push   $0x3f9
80107192:	e8 9f ff ff ff       	call   80107136 <outb>
80107197:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010719a:	6a 03                	push   $0x3
8010719c:	68 fb 03 00 00       	push   $0x3fb
801071a1:	e8 90 ff ff ff       	call   80107136 <outb>
801071a6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801071a9:	6a 00                	push   $0x0
801071ab:	68 fc 03 00 00       	push   $0x3fc
801071b0:	e8 81 ff ff ff       	call   80107136 <outb>
801071b5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801071b8:	6a 01                	push   $0x1
801071ba:	68 f9 03 00 00       	push   $0x3f9
801071bf:	e8 72 ff ff ff       	call   80107136 <outb>
801071c4:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801071c7:	68 fd 03 00 00       	push   $0x3fd
801071cc:	e8 48 ff ff ff       	call   80107119 <inb>
801071d1:	83 c4 04             	add    $0x4,%esp
801071d4:	3c ff                	cmp    $0xff,%al
801071d6:	74 61                	je     80107239 <uartinit+0xe4>
    return;
  uart = 1;
801071d8:	c7 05 64 c6 10 80 01 	movl   $0x1,0x8010c664
801071df:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801071e2:	68 fa 03 00 00       	push   $0x3fa
801071e7:	e8 2d ff ff ff       	call   80107119 <inb>
801071ec:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801071ef:	68 f8 03 00 00       	push   $0x3f8
801071f4:	e8 20 ff ff ff       	call   80107119 <inb>
801071f9:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801071fc:	83 ec 08             	sub    $0x8,%esp
801071ff:	6a 00                	push   $0x0
80107201:	6a 04                	push   $0x4
80107203:	e8 08 b9 ff ff       	call   80102b10 <ioapicenable>
80107208:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010720b:	c7 45 f4 e4 91 10 80 	movl   $0x801091e4,-0xc(%ebp)
80107212:	eb 19                	jmp    8010722d <uartinit+0xd8>
    uartputc(*p);
80107214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107217:	0f b6 00             	movzbl (%eax),%eax
8010721a:	0f be c0             	movsbl %al,%eax
8010721d:	83 ec 0c             	sub    $0xc,%esp
80107220:	50                   	push   %eax
80107221:	e8 16 00 00 00       	call   8010723c <uartputc>
80107226:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107229:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010722d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107230:	0f b6 00             	movzbl (%eax),%eax
80107233:	84 c0                	test   %al,%al
80107235:	75 dd                	jne    80107214 <uartinit+0xbf>
80107237:	eb 01                	jmp    8010723a <uartinit+0xe5>
    return;
80107239:	90                   	nop
}
8010723a:	c9                   	leave  
8010723b:	c3                   	ret    

8010723c <uartputc>:

void
uartputc(int c)
{
8010723c:	55                   	push   %ebp
8010723d:	89 e5                	mov    %esp,%ebp
8010723f:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107242:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80107247:	85 c0                	test   %eax,%eax
80107249:	74 53                	je     8010729e <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010724b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107252:	eb 11                	jmp    80107265 <uartputc+0x29>
    microdelay(10);
80107254:	83 ec 0c             	sub    $0xc,%esp
80107257:	6a 0a                	push   $0xa
80107259:	e8 b6 bd ff ff       	call   80103014 <microdelay>
8010725e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107261:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107265:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107269:	7f 1a                	jg     80107285 <uartputc+0x49>
8010726b:	83 ec 0c             	sub    $0xc,%esp
8010726e:	68 fd 03 00 00       	push   $0x3fd
80107273:	e8 a1 fe ff ff       	call   80107119 <inb>
80107278:	83 c4 10             	add    $0x10,%esp
8010727b:	0f b6 c0             	movzbl %al,%eax
8010727e:	83 e0 20             	and    $0x20,%eax
80107281:	85 c0                	test   %eax,%eax
80107283:	74 cf                	je     80107254 <uartputc+0x18>
  outb(COM1+0, c);
80107285:	8b 45 08             	mov    0x8(%ebp),%eax
80107288:	0f b6 c0             	movzbl %al,%eax
8010728b:	83 ec 08             	sub    $0x8,%esp
8010728e:	50                   	push   %eax
8010728f:	68 f8 03 00 00       	push   $0x3f8
80107294:	e8 9d fe ff ff       	call   80107136 <outb>
80107299:	83 c4 10             	add    $0x10,%esp
8010729c:	eb 01                	jmp    8010729f <uartputc+0x63>
    return;
8010729e:	90                   	nop
}
8010729f:	c9                   	leave  
801072a0:	c3                   	ret    

801072a1 <uartgetc>:

static int
uartgetc(void)
{
801072a1:	55                   	push   %ebp
801072a2:	89 e5                	mov    %esp,%ebp
  if(!uart)
801072a4:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801072a9:	85 c0                	test   %eax,%eax
801072ab:	75 07                	jne    801072b4 <uartgetc+0x13>
    return -1;
801072ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072b2:	eb 2e                	jmp    801072e2 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801072b4:	68 fd 03 00 00       	push   $0x3fd
801072b9:	e8 5b fe ff ff       	call   80107119 <inb>
801072be:	83 c4 04             	add    $0x4,%esp
801072c1:	0f b6 c0             	movzbl %al,%eax
801072c4:	83 e0 01             	and    $0x1,%eax
801072c7:	85 c0                	test   %eax,%eax
801072c9:	75 07                	jne    801072d2 <uartgetc+0x31>
    return -1;
801072cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072d0:	eb 10                	jmp    801072e2 <uartgetc+0x41>
  return inb(COM1+0);
801072d2:	68 f8 03 00 00       	push   $0x3f8
801072d7:	e8 3d fe ff ff       	call   80107119 <inb>
801072dc:	83 c4 04             	add    $0x4,%esp
801072df:	0f b6 c0             	movzbl %al,%eax
}
801072e2:	c9                   	leave  
801072e3:	c3                   	ret    

801072e4 <uartintr>:

void
uartintr(void)
{
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801072ea:	83 ec 0c             	sub    $0xc,%esp
801072ed:	68 a1 72 10 80       	push   $0x801072a1
801072f2:	e8 39 95 ff ff       	call   80100830 <consoleintr>
801072f7:	83 c4 10             	add    $0x10,%esp
}
801072fa:	90                   	nop
801072fb:	c9                   	leave  
801072fc:	c3                   	ret    

801072fd <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $0
801072ff:	6a 00                	push   $0x0
  jmp alltraps
80107301:	e9 d3 f9 ff ff       	jmp    80106cd9 <alltraps>

80107306 <vector1>:
.globl vector1
vector1:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $1
80107308:	6a 01                	push   $0x1
  jmp alltraps
8010730a:	e9 ca f9 ff ff       	jmp    80106cd9 <alltraps>

8010730f <vector2>:
.globl vector2
vector2:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $2
80107311:	6a 02                	push   $0x2
  jmp alltraps
80107313:	e9 c1 f9 ff ff       	jmp    80106cd9 <alltraps>

80107318 <vector3>:
.globl vector3
vector3:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $3
8010731a:	6a 03                	push   $0x3
  jmp alltraps
8010731c:	e9 b8 f9 ff ff       	jmp    80106cd9 <alltraps>

80107321 <vector4>:
.globl vector4
vector4:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $4
80107323:	6a 04                	push   $0x4
  jmp alltraps
80107325:	e9 af f9 ff ff       	jmp    80106cd9 <alltraps>

8010732a <vector5>:
.globl vector5
vector5:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $5
8010732c:	6a 05                	push   $0x5
  jmp alltraps
8010732e:	e9 a6 f9 ff ff       	jmp    80106cd9 <alltraps>

80107333 <vector6>:
.globl vector6
vector6:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $6
80107335:	6a 06                	push   $0x6
  jmp alltraps
80107337:	e9 9d f9 ff ff       	jmp    80106cd9 <alltraps>

8010733c <vector7>:
.globl vector7
vector7:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $7
8010733e:	6a 07                	push   $0x7
  jmp alltraps
80107340:	e9 94 f9 ff ff       	jmp    80106cd9 <alltraps>

80107345 <vector8>:
.globl vector8
vector8:
  pushl $8
80107345:	6a 08                	push   $0x8
  jmp alltraps
80107347:	e9 8d f9 ff ff       	jmp    80106cd9 <alltraps>

8010734c <vector9>:
.globl vector9
vector9:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $9
8010734e:	6a 09                	push   $0x9
  jmp alltraps
80107350:	e9 84 f9 ff ff       	jmp    80106cd9 <alltraps>

80107355 <vector10>:
.globl vector10
vector10:
  pushl $10
80107355:	6a 0a                	push   $0xa
  jmp alltraps
80107357:	e9 7d f9 ff ff       	jmp    80106cd9 <alltraps>

8010735c <vector11>:
.globl vector11
vector11:
  pushl $11
8010735c:	6a 0b                	push   $0xb
  jmp alltraps
8010735e:	e9 76 f9 ff ff       	jmp    80106cd9 <alltraps>

80107363 <vector12>:
.globl vector12
vector12:
  pushl $12
80107363:	6a 0c                	push   $0xc
  jmp alltraps
80107365:	e9 6f f9 ff ff       	jmp    80106cd9 <alltraps>

8010736a <vector13>:
.globl vector13
vector13:
  pushl $13
8010736a:	6a 0d                	push   $0xd
  jmp alltraps
8010736c:	e9 68 f9 ff ff       	jmp    80106cd9 <alltraps>

80107371 <vector14>:
.globl vector14
vector14:
  pushl $14
80107371:	6a 0e                	push   $0xe
  jmp alltraps
80107373:	e9 61 f9 ff ff       	jmp    80106cd9 <alltraps>

80107378 <vector15>:
.globl vector15
vector15:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $15
8010737a:	6a 0f                	push   $0xf
  jmp alltraps
8010737c:	e9 58 f9 ff ff       	jmp    80106cd9 <alltraps>

80107381 <vector16>:
.globl vector16
vector16:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $16
80107383:	6a 10                	push   $0x10
  jmp alltraps
80107385:	e9 4f f9 ff ff       	jmp    80106cd9 <alltraps>

8010738a <vector17>:
.globl vector17
vector17:
  pushl $17
8010738a:	6a 11                	push   $0x11
  jmp alltraps
8010738c:	e9 48 f9 ff ff       	jmp    80106cd9 <alltraps>

80107391 <vector18>:
.globl vector18
vector18:
  pushl $0
80107391:	6a 00                	push   $0x0
  pushl $18
80107393:	6a 12                	push   $0x12
  jmp alltraps
80107395:	e9 3f f9 ff ff       	jmp    80106cd9 <alltraps>

8010739a <vector19>:
.globl vector19
vector19:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $19
8010739c:	6a 13                	push   $0x13
  jmp alltraps
8010739e:	e9 36 f9 ff ff       	jmp    80106cd9 <alltraps>

801073a3 <vector20>:
.globl vector20
vector20:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $20
801073a5:	6a 14                	push   $0x14
  jmp alltraps
801073a7:	e9 2d f9 ff ff       	jmp    80106cd9 <alltraps>

801073ac <vector21>:
.globl vector21
vector21:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $21
801073ae:	6a 15                	push   $0x15
  jmp alltraps
801073b0:	e9 24 f9 ff ff       	jmp    80106cd9 <alltraps>

801073b5 <vector22>:
.globl vector22
vector22:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $22
801073b7:	6a 16                	push   $0x16
  jmp alltraps
801073b9:	e9 1b f9 ff ff       	jmp    80106cd9 <alltraps>

801073be <vector23>:
.globl vector23
vector23:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $23
801073c0:	6a 17                	push   $0x17
  jmp alltraps
801073c2:	e9 12 f9 ff ff       	jmp    80106cd9 <alltraps>

801073c7 <vector24>:
.globl vector24
vector24:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $24
801073c9:	6a 18                	push   $0x18
  jmp alltraps
801073cb:	e9 09 f9 ff ff       	jmp    80106cd9 <alltraps>

801073d0 <vector25>:
.globl vector25
vector25:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $25
801073d2:	6a 19                	push   $0x19
  jmp alltraps
801073d4:	e9 00 f9 ff ff       	jmp    80106cd9 <alltraps>

801073d9 <vector26>:
.globl vector26
vector26:
  pushl $0
801073d9:	6a 00                	push   $0x0
  pushl $26
801073db:	6a 1a                	push   $0x1a
  jmp alltraps
801073dd:	e9 f7 f8 ff ff       	jmp    80106cd9 <alltraps>

801073e2 <vector27>:
.globl vector27
vector27:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $27
801073e4:	6a 1b                	push   $0x1b
  jmp alltraps
801073e6:	e9 ee f8 ff ff       	jmp    80106cd9 <alltraps>

801073eb <vector28>:
.globl vector28
vector28:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $28
801073ed:	6a 1c                	push   $0x1c
  jmp alltraps
801073ef:	e9 e5 f8 ff ff       	jmp    80106cd9 <alltraps>

801073f4 <vector29>:
.globl vector29
vector29:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $29
801073f6:	6a 1d                	push   $0x1d
  jmp alltraps
801073f8:	e9 dc f8 ff ff       	jmp    80106cd9 <alltraps>

801073fd <vector30>:
.globl vector30
vector30:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $30
801073ff:	6a 1e                	push   $0x1e
  jmp alltraps
80107401:	e9 d3 f8 ff ff       	jmp    80106cd9 <alltraps>

80107406 <vector31>:
.globl vector31
vector31:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $31
80107408:	6a 1f                	push   $0x1f
  jmp alltraps
8010740a:	e9 ca f8 ff ff       	jmp    80106cd9 <alltraps>

8010740f <vector32>:
.globl vector32
vector32:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $32
80107411:	6a 20                	push   $0x20
  jmp alltraps
80107413:	e9 c1 f8 ff ff       	jmp    80106cd9 <alltraps>

80107418 <vector33>:
.globl vector33
vector33:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $33
8010741a:	6a 21                	push   $0x21
  jmp alltraps
8010741c:	e9 b8 f8 ff ff       	jmp    80106cd9 <alltraps>

80107421 <vector34>:
.globl vector34
vector34:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $34
80107423:	6a 22                	push   $0x22
  jmp alltraps
80107425:	e9 af f8 ff ff       	jmp    80106cd9 <alltraps>

8010742a <vector35>:
.globl vector35
vector35:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $35
8010742c:	6a 23                	push   $0x23
  jmp alltraps
8010742e:	e9 a6 f8 ff ff       	jmp    80106cd9 <alltraps>

80107433 <vector36>:
.globl vector36
vector36:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $36
80107435:	6a 24                	push   $0x24
  jmp alltraps
80107437:	e9 9d f8 ff ff       	jmp    80106cd9 <alltraps>

8010743c <vector37>:
.globl vector37
vector37:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $37
8010743e:	6a 25                	push   $0x25
  jmp alltraps
80107440:	e9 94 f8 ff ff       	jmp    80106cd9 <alltraps>

80107445 <vector38>:
.globl vector38
vector38:
  pushl $0
80107445:	6a 00                	push   $0x0
  pushl $38
80107447:	6a 26                	push   $0x26
  jmp alltraps
80107449:	e9 8b f8 ff ff       	jmp    80106cd9 <alltraps>

8010744e <vector39>:
.globl vector39
vector39:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $39
80107450:	6a 27                	push   $0x27
  jmp alltraps
80107452:	e9 82 f8 ff ff       	jmp    80106cd9 <alltraps>

80107457 <vector40>:
.globl vector40
vector40:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $40
80107459:	6a 28                	push   $0x28
  jmp alltraps
8010745b:	e9 79 f8 ff ff       	jmp    80106cd9 <alltraps>

80107460 <vector41>:
.globl vector41
vector41:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $41
80107462:	6a 29                	push   $0x29
  jmp alltraps
80107464:	e9 70 f8 ff ff       	jmp    80106cd9 <alltraps>

80107469 <vector42>:
.globl vector42
vector42:
  pushl $0
80107469:	6a 00                	push   $0x0
  pushl $42
8010746b:	6a 2a                	push   $0x2a
  jmp alltraps
8010746d:	e9 67 f8 ff ff       	jmp    80106cd9 <alltraps>

80107472 <vector43>:
.globl vector43
vector43:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $43
80107474:	6a 2b                	push   $0x2b
  jmp alltraps
80107476:	e9 5e f8 ff ff       	jmp    80106cd9 <alltraps>

8010747b <vector44>:
.globl vector44
vector44:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $44
8010747d:	6a 2c                	push   $0x2c
  jmp alltraps
8010747f:	e9 55 f8 ff ff       	jmp    80106cd9 <alltraps>

80107484 <vector45>:
.globl vector45
vector45:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $45
80107486:	6a 2d                	push   $0x2d
  jmp alltraps
80107488:	e9 4c f8 ff ff       	jmp    80106cd9 <alltraps>

8010748d <vector46>:
.globl vector46
vector46:
  pushl $0
8010748d:	6a 00                	push   $0x0
  pushl $46
8010748f:	6a 2e                	push   $0x2e
  jmp alltraps
80107491:	e9 43 f8 ff ff       	jmp    80106cd9 <alltraps>

80107496 <vector47>:
.globl vector47
vector47:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $47
80107498:	6a 2f                	push   $0x2f
  jmp alltraps
8010749a:	e9 3a f8 ff ff       	jmp    80106cd9 <alltraps>

8010749f <vector48>:
.globl vector48
vector48:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $48
801074a1:	6a 30                	push   $0x30
  jmp alltraps
801074a3:	e9 31 f8 ff ff       	jmp    80106cd9 <alltraps>

801074a8 <vector49>:
.globl vector49
vector49:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $49
801074aa:	6a 31                	push   $0x31
  jmp alltraps
801074ac:	e9 28 f8 ff ff       	jmp    80106cd9 <alltraps>

801074b1 <vector50>:
.globl vector50
vector50:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $50
801074b3:	6a 32                	push   $0x32
  jmp alltraps
801074b5:	e9 1f f8 ff ff       	jmp    80106cd9 <alltraps>

801074ba <vector51>:
.globl vector51
vector51:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $51
801074bc:	6a 33                	push   $0x33
  jmp alltraps
801074be:	e9 16 f8 ff ff       	jmp    80106cd9 <alltraps>

801074c3 <vector52>:
.globl vector52
vector52:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $52
801074c5:	6a 34                	push   $0x34
  jmp alltraps
801074c7:	e9 0d f8 ff ff       	jmp    80106cd9 <alltraps>

801074cc <vector53>:
.globl vector53
vector53:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $53
801074ce:	6a 35                	push   $0x35
  jmp alltraps
801074d0:	e9 04 f8 ff ff       	jmp    80106cd9 <alltraps>

801074d5 <vector54>:
.globl vector54
vector54:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $54
801074d7:	6a 36                	push   $0x36
  jmp alltraps
801074d9:	e9 fb f7 ff ff       	jmp    80106cd9 <alltraps>

801074de <vector55>:
.globl vector55
vector55:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $55
801074e0:	6a 37                	push   $0x37
  jmp alltraps
801074e2:	e9 f2 f7 ff ff       	jmp    80106cd9 <alltraps>

801074e7 <vector56>:
.globl vector56
vector56:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $56
801074e9:	6a 38                	push   $0x38
  jmp alltraps
801074eb:	e9 e9 f7 ff ff       	jmp    80106cd9 <alltraps>

801074f0 <vector57>:
.globl vector57
vector57:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $57
801074f2:	6a 39                	push   $0x39
  jmp alltraps
801074f4:	e9 e0 f7 ff ff       	jmp    80106cd9 <alltraps>

801074f9 <vector58>:
.globl vector58
vector58:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $58
801074fb:	6a 3a                	push   $0x3a
  jmp alltraps
801074fd:	e9 d7 f7 ff ff       	jmp    80106cd9 <alltraps>

80107502 <vector59>:
.globl vector59
vector59:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $59
80107504:	6a 3b                	push   $0x3b
  jmp alltraps
80107506:	e9 ce f7 ff ff       	jmp    80106cd9 <alltraps>

8010750b <vector60>:
.globl vector60
vector60:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $60
8010750d:	6a 3c                	push   $0x3c
  jmp alltraps
8010750f:	e9 c5 f7 ff ff       	jmp    80106cd9 <alltraps>

80107514 <vector61>:
.globl vector61
vector61:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $61
80107516:	6a 3d                	push   $0x3d
  jmp alltraps
80107518:	e9 bc f7 ff ff       	jmp    80106cd9 <alltraps>

8010751d <vector62>:
.globl vector62
vector62:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $62
8010751f:	6a 3e                	push   $0x3e
  jmp alltraps
80107521:	e9 b3 f7 ff ff       	jmp    80106cd9 <alltraps>

80107526 <vector63>:
.globl vector63
vector63:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $63
80107528:	6a 3f                	push   $0x3f
  jmp alltraps
8010752a:	e9 aa f7 ff ff       	jmp    80106cd9 <alltraps>

8010752f <vector64>:
.globl vector64
vector64:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $64
80107531:	6a 40                	push   $0x40
  jmp alltraps
80107533:	e9 a1 f7 ff ff       	jmp    80106cd9 <alltraps>

80107538 <vector65>:
.globl vector65
vector65:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $65
8010753a:	6a 41                	push   $0x41
  jmp alltraps
8010753c:	e9 98 f7 ff ff       	jmp    80106cd9 <alltraps>

80107541 <vector66>:
.globl vector66
vector66:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $66
80107543:	6a 42                	push   $0x42
  jmp alltraps
80107545:	e9 8f f7 ff ff       	jmp    80106cd9 <alltraps>

8010754a <vector67>:
.globl vector67
vector67:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $67
8010754c:	6a 43                	push   $0x43
  jmp alltraps
8010754e:	e9 86 f7 ff ff       	jmp    80106cd9 <alltraps>

80107553 <vector68>:
.globl vector68
vector68:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $68
80107555:	6a 44                	push   $0x44
  jmp alltraps
80107557:	e9 7d f7 ff ff       	jmp    80106cd9 <alltraps>

8010755c <vector69>:
.globl vector69
vector69:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $69
8010755e:	6a 45                	push   $0x45
  jmp alltraps
80107560:	e9 74 f7 ff ff       	jmp    80106cd9 <alltraps>

80107565 <vector70>:
.globl vector70
vector70:
  pushl $0
80107565:	6a 00                	push   $0x0
  pushl $70
80107567:	6a 46                	push   $0x46
  jmp alltraps
80107569:	e9 6b f7 ff ff       	jmp    80106cd9 <alltraps>

8010756e <vector71>:
.globl vector71
vector71:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $71
80107570:	6a 47                	push   $0x47
  jmp alltraps
80107572:	e9 62 f7 ff ff       	jmp    80106cd9 <alltraps>

80107577 <vector72>:
.globl vector72
vector72:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $72
80107579:	6a 48                	push   $0x48
  jmp alltraps
8010757b:	e9 59 f7 ff ff       	jmp    80106cd9 <alltraps>

80107580 <vector73>:
.globl vector73
vector73:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $73
80107582:	6a 49                	push   $0x49
  jmp alltraps
80107584:	e9 50 f7 ff ff       	jmp    80106cd9 <alltraps>

80107589 <vector74>:
.globl vector74
vector74:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $74
8010758b:	6a 4a                	push   $0x4a
  jmp alltraps
8010758d:	e9 47 f7 ff ff       	jmp    80106cd9 <alltraps>

80107592 <vector75>:
.globl vector75
vector75:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $75
80107594:	6a 4b                	push   $0x4b
  jmp alltraps
80107596:	e9 3e f7 ff ff       	jmp    80106cd9 <alltraps>

8010759b <vector76>:
.globl vector76
vector76:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $76
8010759d:	6a 4c                	push   $0x4c
  jmp alltraps
8010759f:	e9 35 f7 ff ff       	jmp    80106cd9 <alltraps>

801075a4 <vector77>:
.globl vector77
vector77:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $77
801075a6:	6a 4d                	push   $0x4d
  jmp alltraps
801075a8:	e9 2c f7 ff ff       	jmp    80106cd9 <alltraps>

801075ad <vector78>:
.globl vector78
vector78:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $78
801075af:	6a 4e                	push   $0x4e
  jmp alltraps
801075b1:	e9 23 f7 ff ff       	jmp    80106cd9 <alltraps>

801075b6 <vector79>:
.globl vector79
vector79:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $79
801075b8:	6a 4f                	push   $0x4f
  jmp alltraps
801075ba:	e9 1a f7 ff ff       	jmp    80106cd9 <alltraps>

801075bf <vector80>:
.globl vector80
vector80:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $80
801075c1:	6a 50                	push   $0x50
  jmp alltraps
801075c3:	e9 11 f7 ff ff       	jmp    80106cd9 <alltraps>

801075c8 <vector81>:
.globl vector81
vector81:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $81
801075ca:	6a 51                	push   $0x51
  jmp alltraps
801075cc:	e9 08 f7 ff ff       	jmp    80106cd9 <alltraps>

801075d1 <vector82>:
.globl vector82
vector82:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $82
801075d3:	6a 52                	push   $0x52
  jmp alltraps
801075d5:	e9 ff f6 ff ff       	jmp    80106cd9 <alltraps>

801075da <vector83>:
.globl vector83
vector83:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $83
801075dc:	6a 53                	push   $0x53
  jmp alltraps
801075de:	e9 f6 f6 ff ff       	jmp    80106cd9 <alltraps>

801075e3 <vector84>:
.globl vector84
vector84:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $84
801075e5:	6a 54                	push   $0x54
  jmp alltraps
801075e7:	e9 ed f6 ff ff       	jmp    80106cd9 <alltraps>

801075ec <vector85>:
.globl vector85
vector85:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $85
801075ee:	6a 55                	push   $0x55
  jmp alltraps
801075f0:	e9 e4 f6 ff ff       	jmp    80106cd9 <alltraps>

801075f5 <vector86>:
.globl vector86
vector86:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $86
801075f7:	6a 56                	push   $0x56
  jmp alltraps
801075f9:	e9 db f6 ff ff       	jmp    80106cd9 <alltraps>

801075fe <vector87>:
.globl vector87
vector87:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $87
80107600:	6a 57                	push   $0x57
  jmp alltraps
80107602:	e9 d2 f6 ff ff       	jmp    80106cd9 <alltraps>

80107607 <vector88>:
.globl vector88
vector88:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $88
80107609:	6a 58                	push   $0x58
  jmp alltraps
8010760b:	e9 c9 f6 ff ff       	jmp    80106cd9 <alltraps>

80107610 <vector89>:
.globl vector89
vector89:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $89
80107612:	6a 59                	push   $0x59
  jmp alltraps
80107614:	e9 c0 f6 ff ff       	jmp    80106cd9 <alltraps>

80107619 <vector90>:
.globl vector90
vector90:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $90
8010761b:	6a 5a                	push   $0x5a
  jmp alltraps
8010761d:	e9 b7 f6 ff ff       	jmp    80106cd9 <alltraps>

80107622 <vector91>:
.globl vector91
vector91:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $91
80107624:	6a 5b                	push   $0x5b
  jmp alltraps
80107626:	e9 ae f6 ff ff       	jmp    80106cd9 <alltraps>

8010762b <vector92>:
.globl vector92
vector92:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $92
8010762d:	6a 5c                	push   $0x5c
  jmp alltraps
8010762f:	e9 a5 f6 ff ff       	jmp    80106cd9 <alltraps>

80107634 <vector93>:
.globl vector93
vector93:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $93
80107636:	6a 5d                	push   $0x5d
  jmp alltraps
80107638:	e9 9c f6 ff ff       	jmp    80106cd9 <alltraps>

8010763d <vector94>:
.globl vector94
vector94:
  pushl $0
8010763d:	6a 00                	push   $0x0
  pushl $94
8010763f:	6a 5e                	push   $0x5e
  jmp alltraps
80107641:	e9 93 f6 ff ff       	jmp    80106cd9 <alltraps>

80107646 <vector95>:
.globl vector95
vector95:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $95
80107648:	6a 5f                	push   $0x5f
  jmp alltraps
8010764a:	e9 8a f6 ff ff       	jmp    80106cd9 <alltraps>

8010764f <vector96>:
.globl vector96
vector96:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $96
80107651:	6a 60                	push   $0x60
  jmp alltraps
80107653:	e9 81 f6 ff ff       	jmp    80106cd9 <alltraps>

80107658 <vector97>:
.globl vector97
vector97:
  pushl $0
80107658:	6a 00                	push   $0x0
  pushl $97
8010765a:	6a 61                	push   $0x61
  jmp alltraps
8010765c:	e9 78 f6 ff ff       	jmp    80106cd9 <alltraps>

80107661 <vector98>:
.globl vector98
vector98:
  pushl $0
80107661:	6a 00                	push   $0x0
  pushl $98
80107663:	6a 62                	push   $0x62
  jmp alltraps
80107665:	e9 6f f6 ff ff       	jmp    80106cd9 <alltraps>

8010766a <vector99>:
.globl vector99
vector99:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $99
8010766c:	6a 63                	push   $0x63
  jmp alltraps
8010766e:	e9 66 f6 ff ff       	jmp    80106cd9 <alltraps>

80107673 <vector100>:
.globl vector100
vector100:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $100
80107675:	6a 64                	push   $0x64
  jmp alltraps
80107677:	e9 5d f6 ff ff       	jmp    80106cd9 <alltraps>

8010767c <vector101>:
.globl vector101
vector101:
  pushl $0
8010767c:	6a 00                	push   $0x0
  pushl $101
8010767e:	6a 65                	push   $0x65
  jmp alltraps
80107680:	e9 54 f6 ff ff       	jmp    80106cd9 <alltraps>

80107685 <vector102>:
.globl vector102
vector102:
  pushl $0
80107685:	6a 00                	push   $0x0
  pushl $102
80107687:	6a 66                	push   $0x66
  jmp alltraps
80107689:	e9 4b f6 ff ff       	jmp    80106cd9 <alltraps>

8010768e <vector103>:
.globl vector103
vector103:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $103
80107690:	6a 67                	push   $0x67
  jmp alltraps
80107692:	e9 42 f6 ff ff       	jmp    80106cd9 <alltraps>

80107697 <vector104>:
.globl vector104
vector104:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $104
80107699:	6a 68                	push   $0x68
  jmp alltraps
8010769b:	e9 39 f6 ff ff       	jmp    80106cd9 <alltraps>

801076a0 <vector105>:
.globl vector105
vector105:
  pushl $0
801076a0:	6a 00                	push   $0x0
  pushl $105
801076a2:	6a 69                	push   $0x69
  jmp alltraps
801076a4:	e9 30 f6 ff ff       	jmp    80106cd9 <alltraps>

801076a9 <vector106>:
.globl vector106
vector106:
  pushl $0
801076a9:	6a 00                	push   $0x0
  pushl $106
801076ab:	6a 6a                	push   $0x6a
  jmp alltraps
801076ad:	e9 27 f6 ff ff       	jmp    80106cd9 <alltraps>

801076b2 <vector107>:
.globl vector107
vector107:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $107
801076b4:	6a 6b                	push   $0x6b
  jmp alltraps
801076b6:	e9 1e f6 ff ff       	jmp    80106cd9 <alltraps>

801076bb <vector108>:
.globl vector108
vector108:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $108
801076bd:	6a 6c                	push   $0x6c
  jmp alltraps
801076bf:	e9 15 f6 ff ff       	jmp    80106cd9 <alltraps>

801076c4 <vector109>:
.globl vector109
vector109:
  pushl $0
801076c4:	6a 00                	push   $0x0
  pushl $109
801076c6:	6a 6d                	push   $0x6d
  jmp alltraps
801076c8:	e9 0c f6 ff ff       	jmp    80106cd9 <alltraps>

801076cd <vector110>:
.globl vector110
vector110:
  pushl $0
801076cd:	6a 00                	push   $0x0
  pushl $110
801076cf:	6a 6e                	push   $0x6e
  jmp alltraps
801076d1:	e9 03 f6 ff ff       	jmp    80106cd9 <alltraps>

801076d6 <vector111>:
.globl vector111
vector111:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $111
801076d8:	6a 6f                	push   $0x6f
  jmp alltraps
801076da:	e9 fa f5 ff ff       	jmp    80106cd9 <alltraps>

801076df <vector112>:
.globl vector112
vector112:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $112
801076e1:	6a 70                	push   $0x70
  jmp alltraps
801076e3:	e9 f1 f5 ff ff       	jmp    80106cd9 <alltraps>

801076e8 <vector113>:
.globl vector113
vector113:
  pushl $0
801076e8:	6a 00                	push   $0x0
  pushl $113
801076ea:	6a 71                	push   $0x71
  jmp alltraps
801076ec:	e9 e8 f5 ff ff       	jmp    80106cd9 <alltraps>

801076f1 <vector114>:
.globl vector114
vector114:
  pushl $0
801076f1:	6a 00                	push   $0x0
  pushl $114
801076f3:	6a 72                	push   $0x72
  jmp alltraps
801076f5:	e9 df f5 ff ff       	jmp    80106cd9 <alltraps>

801076fa <vector115>:
.globl vector115
vector115:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $115
801076fc:	6a 73                	push   $0x73
  jmp alltraps
801076fe:	e9 d6 f5 ff ff       	jmp    80106cd9 <alltraps>

80107703 <vector116>:
.globl vector116
vector116:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $116
80107705:	6a 74                	push   $0x74
  jmp alltraps
80107707:	e9 cd f5 ff ff       	jmp    80106cd9 <alltraps>

8010770c <vector117>:
.globl vector117
vector117:
  pushl $0
8010770c:	6a 00                	push   $0x0
  pushl $117
8010770e:	6a 75                	push   $0x75
  jmp alltraps
80107710:	e9 c4 f5 ff ff       	jmp    80106cd9 <alltraps>

80107715 <vector118>:
.globl vector118
vector118:
  pushl $0
80107715:	6a 00                	push   $0x0
  pushl $118
80107717:	6a 76                	push   $0x76
  jmp alltraps
80107719:	e9 bb f5 ff ff       	jmp    80106cd9 <alltraps>

8010771e <vector119>:
.globl vector119
vector119:
  pushl $0
8010771e:	6a 00                	push   $0x0
  pushl $119
80107720:	6a 77                	push   $0x77
  jmp alltraps
80107722:	e9 b2 f5 ff ff       	jmp    80106cd9 <alltraps>

80107727 <vector120>:
.globl vector120
vector120:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $120
80107729:	6a 78                	push   $0x78
  jmp alltraps
8010772b:	e9 a9 f5 ff ff       	jmp    80106cd9 <alltraps>

80107730 <vector121>:
.globl vector121
vector121:
  pushl $0
80107730:	6a 00                	push   $0x0
  pushl $121
80107732:	6a 79                	push   $0x79
  jmp alltraps
80107734:	e9 a0 f5 ff ff       	jmp    80106cd9 <alltraps>

80107739 <vector122>:
.globl vector122
vector122:
  pushl $0
80107739:	6a 00                	push   $0x0
  pushl $122
8010773b:	6a 7a                	push   $0x7a
  jmp alltraps
8010773d:	e9 97 f5 ff ff       	jmp    80106cd9 <alltraps>

80107742 <vector123>:
.globl vector123
vector123:
  pushl $0
80107742:	6a 00                	push   $0x0
  pushl $123
80107744:	6a 7b                	push   $0x7b
  jmp alltraps
80107746:	e9 8e f5 ff ff       	jmp    80106cd9 <alltraps>

8010774b <vector124>:
.globl vector124
vector124:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $124
8010774d:	6a 7c                	push   $0x7c
  jmp alltraps
8010774f:	e9 85 f5 ff ff       	jmp    80106cd9 <alltraps>

80107754 <vector125>:
.globl vector125
vector125:
  pushl $0
80107754:	6a 00                	push   $0x0
  pushl $125
80107756:	6a 7d                	push   $0x7d
  jmp alltraps
80107758:	e9 7c f5 ff ff       	jmp    80106cd9 <alltraps>

8010775d <vector126>:
.globl vector126
vector126:
  pushl $0
8010775d:	6a 00                	push   $0x0
  pushl $126
8010775f:	6a 7e                	push   $0x7e
  jmp alltraps
80107761:	e9 73 f5 ff ff       	jmp    80106cd9 <alltraps>

80107766 <vector127>:
.globl vector127
vector127:
  pushl $0
80107766:	6a 00                	push   $0x0
  pushl $127
80107768:	6a 7f                	push   $0x7f
  jmp alltraps
8010776a:	e9 6a f5 ff ff       	jmp    80106cd9 <alltraps>

8010776f <vector128>:
.globl vector128
vector128:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $128
80107771:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107776:	e9 5e f5 ff ff       	jmp    80106cd9 <alltraps>

8010777b <vector129>:
.globl vector129
vector129:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $129
8010777d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107782:	e9 52 f5 ff ff       	jmp    80106cd9 <alltraps>

80107787 <vector130>:
.globl vector130
vector130:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $130
80107789:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010778e:	e9 46 f5 ff ff       	jmp    80106cd9 <alltraps>

80107793 <vector131>:
.globl vector131
vector131:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $131
80107795:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010779a:	e9 3a f5 ff ff       	jmp    80106cd9 <alltraps>

8010779f <vector132>:
.globl vector132
vector132:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $132
801077a1:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801077a6:	e9 2e f5 ff ff       	jmp    80106cd9 <alltraps>

801077ab <vector133>:
.globl vector133
vector133:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $133
801077ad:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801077b2:	e9 22 f5 ff ff       	jmp    80106cd9 <alltraps>

801077b7 <vector134>:
.globl vector134
vector134:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $134
801077b9:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801077be:	e9 16 f5 ff ff       	jmp    80106cd9 <alltraps>

801077c3 <vector135>:
.globl vector135
vector135:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $135
801077c5:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801077ca:	e9 0a f5 ff ff       	jmp    80106cd9 <alltraps>

801077cf <vector136>:
.globl vector136
vector136:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $136
801077d1:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801077d6:	e9 fe f4 ff ff       	jmp    80106cd9 <alltraps>

801077db <vector137>:
.globl vector137
vector137:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $137
801077dd:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801077e2:	e9 f2 f4 ff ff       	jmp    80106cd9 <alltraps>

801077e7 <vector138>:
.globl vector138
vector138:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $138
801077e9:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801077ee:	e9 e6 f4 ff ff       	jmp    80106cd9 <alltraps>

801077f3 <vector139>:
.globl vector139
vector139:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $139
801077f5:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801077fa:	e9 da f4 ff ff       	jmp    80106cd9 <alltraps>

801077ff <vector140>:
.globl vector140
vector140:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $140
80107801:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107806:	e9 ce f4 ff ff       	jmp    80106cd9 <alltraps>

8010780b <vector141>:
.globl vector141
vector141:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $141
8010780d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107812:	e9 c2 f4 ff ff       	jmp    80106cd9 <alltraps>

80107817 <vector142>:
.globl vector142
vector142:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $142
80107819:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010781e:	e9 b6 f4 ff ff       	jmp    80106cd9 <alltraps>

80107823 <vector143>:
.globl vector143
vector143:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $143
80107825:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010782a:	e9 aa f4 ff ff       	jmp    80106cd9 <alltraps>

8010782f <vector144>:
.globl vector144
vector144:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $144
80107831:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107836:	e9 9e f4 ff ff       	jmp    80106cd9 <alltraps>

8010783b <vector145>:
.globl vector145
vector145:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $145
8010783d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107842:	e9 92 f4 ff ff       	jmp    80106cd9 <alltraps>

80107847 <vector146>:
.globl vector146
vector146:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $146
80107849:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010784e:	e9 86 f4 ff ff       	jmp    80106cd9 <alltraps>

80107853 <vector147>:
.globl vector147
vector147:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $147
80107855:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010785a:	e9 7a f4 ff ff       	jmp    80106cd9 <alltraps>

8010785f <vector148>:
.globl vector148
vector148:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $148
80107861:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107866:	e9 6e f4 ff ff       	jmp    80106cd9 <alltraps>

8010786b <vector149>:
.globl vector149
vector149:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $149
8010786d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107872:	e9 62 f4 ff ff       	jmp    80106cd9 <alltraps>

80107877 <vector150>:
.globl vector150
vector150:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $150
80107879:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010787e:	e9 56 f4 ff ff       	jmp    80106cd9 <alltraps>

80107883 <vector151>:
.globl vector151
vector151:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $151
80107885:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010788a:	e9 4a f4 ff ff       	jmp    80106cd9 <alltraps>

8010788f <vector152>:
.globl vector152
vector152:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $152
80107891:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107896:	e9 3e f4 ff ff       	jmp    80106cd9 <alltraps>

8010789b <vector153>:
.globl vector153
vector153:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $153
8010789d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801078a2:	e9 32 f4 ff ff       	jmp    80106cd9 <alltraps>

801078a7 <vector154>:
.globl vector154
vector154:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $154
801078a9:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801078ae:	e9 26 f4 ff ff       	jmp    80106cd9 <alltraps>

801078b3 <vector155>:
.globl vector155
vector155:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $155
801078b5:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801078ba:	e9 1a f4 ff ff       	jmp    80106cd9 <alltraps>

801078bf <vector156>:
.globl vector156
vector156:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $156
801078c1:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801078c6:	e9 0e f4 ff ff       	jmp    80106cd9 <alltraps>

801078cb <vector157>:
.globl vector157
vector157:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $157
801078cd:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801078d2:	e9 02 f4 ff ff       	jmp    80106cd9 <alltraps>

801078d7 <vector158>:
.globl vector158
vector158:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $158
801078d9:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801078de:	e9 f6 f3 ff ff       	jmp    80106cd9 <alltraps>

801078e3 <vector159>:
.globl vector159
vector159:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $159
801078e5:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801078ea:	e9 ea f3 ff ff       	jmp    80106cd9 <alltraps>

801078ef <vector160>:
.globl vector160
vector160:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $160
801078f1:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801078f6:	e9 de f3 ff ff       	jmp    80106cd9 <alltraps>

801078fb <vector161>:
.globl vector161
vector161:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $161
801078fd:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107902:	e9 d2 f3 ff ff       	jmp    80106cd9 <alltraps>

80107907 <vector162>:
.globl vector162
vector162:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $162
80107909:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010790e:	e9 c6 f3 ff ff       	jmp    80106cd9 <alltraps>

80107913 <vector163>:
.globl vector163
vector163:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $163
80107915:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010791a:	e9 ba f3 ff ff       	jmp    80106cd9 <alltraps>

8010791f <vector164>:
.globl vector164
vector164:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $164
80107921:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107926:	e9 ae f3 ff ff       	jmp    80106cd9 <alltraps>

8010792b <vector165>:
.globl vector165
vector165:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $165
8010792d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107932:	e9 a2 f3 ff ff       	jmp    80106cd9 <alltraps>

80107937 <vector166>:
.globl vector166
vector166:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $166
80107939:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010793e:	e9 96 f3 ff ff       	jmp    80106cd9 <alltraps>

80107943 <vector167>:
.globl vector167
vector167:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $167
80107945:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010794a:	e9 8a f3 ff ff       	jmp    80106cd9 <alltraps>

8010794f <vector168>:
.globl vector168
vector168:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $168
80107951:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107956:	e9 7e f3 ff ff       	jmp    80106cd9 <alltraps>

8010795b <vector169>:
.globl vector169
vector169:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $169
8010795d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107962:	e9 72 f3 ff ff       	jmp    80106cd9 <alltraps>

80107967 <vector170>:
.globl vector170
vector170:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $170
80107969:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010796e:	e9 66 f3 ff ff       	jmp    80106cd9 <alltraps>

80107973 <vector171>:
.globl vector171
vector171:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $171
80107975:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010797a:	e9 5a f3 ff ff       	jmp    80106cd9 <alltraps>

8010797f <vector172>:
.globl vector172
vector172:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $172
80107981:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107986:	e9 4e f3 ff ff       	jmp    80106cd9 <alltraps>

8010798b <vector173>:
.globl vector173
vector173:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $173
8010798d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107992:	e9 42 f3 ff ff       	jmp    80106cd9 <alltraps>

80107997 <vector174>:
.globl vector174
vector174:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $174
80107999:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010799e:	e9 36 f3 ff ff       	jmp    80106cd9 <alltraps>

801079a3 <vector175>:
.globl vector175
vector175:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $175
801079a5:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801079aa:	e9 2a f3 ff ff       	jmp    80106cd9 <alltraps>

801079af <vector176>:
.globl vector176
vector176:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $176
801079b1:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801079b6:	e9 1e f3 ff ff       	jmp    80106cd9 <alltraps>

801079bb <vector177>:
.globl vector177
vector177:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $177
801079bd:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801079c2:	e9 12 f3 ff ff       	jmp    80106cd9 <alltraps>

801079c7 <vector178>:
.globl vector178
vector178:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $178
801079c9:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801079ce:	e9 06 f3 ff ff       	jmp    80106cd9 <alltraps>

801079d3 <vector179>:
.globl vector179
vector179:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $179
801079d5:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801079da:	e9 fa f2 ff ff       	jmp    80106cd9 <alltraps>

801079df <vector180>:
.globl vector180
vector180:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $180
801079e1:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801079e6:	e9 ee f2 ff ff       	jmp    80106cd9 <alltraps>

801079eb <vector181>:
.globl vector181
vector181:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $181
801079ed:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801079f2:	e9 e2 f2 ff ff       	jmp    80106cd9 <alltraps>

801079f7 <vector182>:
.globl vector182
vector182:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $182
801079f9:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801079fe:	e9 d6 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a03 <vector183>:
.globl vector183
vector183:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $183
80107a05:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107a0a:	e9 ca f2 ff ff       	jmp    80106cd9 <alltraps>

80107a0f <vector184>:
.globl vector184
vector184:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $184
80107a11:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107a16:	e9 be f2 ff ff       	jmp    80106cd9 <alltraps>

80107a1b <vector185>:
.globl vector185
vector185:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $185
80107a1d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107a22:	e9 b2 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a27 <vector186>:
.globl vector186
vector186:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $186
80107a29:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107a2e:	e9 a6 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a33 <vector187>:
.globl vector187
vector187:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $187
80107a35:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107a3a:	e9 9a f2 ff ff       	jmp    80106cd9 <alltraps>

80107a3f <vector188>:
.globl vector188
vector188:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $188
80107a41:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107a46:	e9 8e f2 ff ff       	jmp    80106cd9 <alltraps>

80107a4b <vector189>:
.globl vector189
vector189:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $189
80107a4d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107a52:	e9 82 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a57 <vector190>:
.globl vector190
vector190:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $190
80107a59:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107a5e:	e9 76 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a63 <vector191>:
.globl vector191
vector191:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $191
80107a65:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107a6a:	e9 6a f2 ff ff       	jmp    80106cd9 <alltraps>

80107a6f <vector192>:
.globl vector192
vector192:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $192
80107a71:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107a76:	e9 5e f2 ff ff       	jmp    80106cd9 <alltraps>

80107a7b <vector193>:
.globl vector193
vector193:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $193
80107a7d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107a82:	e9 52 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a87 <vector194>:
.globl vector194
vector194:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $194
80107a89:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107a8e:	e9 46 f2 ff ff       	jmp    80106cd9 <alltraps>

80107a93 <vector195>:
.globl vector195
vector195:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $195
80107a95:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a9a:	e9 3a f2 ff ff       	jmp    80106cd9 <alltraps>

80107a9f <vector196>:
.globl vector196
vector196:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $196
80107aa1:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107aa6:	e9 2e f2 ff ff       	jmp    80106cd9 <alltraps>

80107aab <vector197>:
.globl vector197
vector197:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $197
80107aad:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107ab2:	e9 22 f2 ff ff       	jmp    80106cd9 <alltraps>

80107ab7 <vector198>:
.globl vector198
vector198:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $198
80107ab9:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107abe:	e9 16 f2 ff ff       	jmp    80106cd9 <alltraps>

80107ac3 <vector199>:
.globl vector199
vector199:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $199
80107ac5:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107aca:	e9 0a f2 ff ff       	jmp    80106cd9 <alltraps>

80107acf <vector200>:
.globl vector200
vector200:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $200
80107ad1:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107ad6:	e9 fe f1 ff ff       	jmp    80106cd9 <alltraps>

80107adb <vector201>:
.globl vector201
vector201:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $201
80107add:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107ae2:	e9 f2 f1 ff ff       	jmp    80106cd9 <alltraps>

80107ae7 <vector202>:
.globl vector202
vector202:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $202
80107ae9:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107aee:	e9 e6 f1 ff ff       	jmp    80106cd9 <alltraps>

80107af3 <vector203>:
.globl vector203
vector203:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $203
80107af5:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107afa:	e9 da f1 ff ff       	jmp    80106cd9 <alltraps>

80107aff <vector204>:
.globl vector204
vector204:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $204
80107b01:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107b06:	e9 ce f1 ff ff       	jmp    80106cd9 <alltraps>

80107b0b <vector205>:
.globl vector205
vector205:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $205
80107b0d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107b12:	e9 c2 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b17 <vector206>:
.globl vector206
vector206:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $206
80107b19:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107b1e:	e9 b6 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b23 <vector207>:
.globl vector207
vector207:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $207
80107b25:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107b2a:	e9 aa f1 ff ff       	jmp    80106cd9 <alltraps>

80107b2f <vector208>:
.globl vector208
vector208:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $208
80107b31:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b36:	e9 9e f1 ff ff       	jmp    80106cd9 <alltraps>

80107b3b <vector209>:
.globl vector209
vector209:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $209
80107b3d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107b42:	e9 92 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b47 <vector210>:
.globl vector210
vector210:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $210
80107b49:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107b4e:	e9 86 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b53 <vector211>:
.globl vector211
vector211:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $211
80107b55:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107b5a:	e9 7a f1 ff ff       	jmp    80106cd9 <alltraps>

80107b5f <vector212>:
.globl vector212
vector212:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $212
80107b61:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107b66:	e9 6e f1 ff ff       	jmp    80106cd9 <alltraps>

80107b6b <vector213>:
.globl vector213
vector213:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $213
80107b6d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107b72:	e9 62 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b77 <vector214>:
.globl vector214
vector214:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $214
80107b79:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107b7e:	e9 56 f1 ff ff       	jmp    80106cd9 <alltraps>

80107b83 <vector215>:
.globl vector215
vector215:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $215
80107b85:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107b8a:	e9 4a f1 ff ff       	jmp    80106cd9 <alltraps>

80107b8f <vector216>:
.globl vector216
vector216:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $216
80107b91:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b96:	e9 3e f1 ff ff       	jmp    80106cd9 <alltraps>

80107b9b <vector217>:
.globl vector217
vector217:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $217
80107b9d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ba2:	e9 32 f1 ff ff       	jmp    80106cd9 <alltraps>

80107ba7 <vector218>:
.globl vector218
vector218:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $218
80107ba9:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107bae:	e9 26 f1 ff ff       	jmp    80106cd9 <alltraps>

80107bb3 <vector219>:
.globl vector219
vector219:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $219
80107bb5:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107bba:	e9 1a f1 ff ff       	jmp    80106cd9 <alltraps>

80107bbf <vector220>:
.globl vector220
vector220:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $220
80107bc1:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107bc6:	e9 0e f1 ff ff       	jmp    80106cd9 <alltraps>

80107bcb <vector221>:
.globl vector221
vector221:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $221
80107bcd:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107bd2:	e9 02 f1 ff ff       	jmp    80106cd9 <alltraps>

80107bd7 <vector222>:
.globl vector222
vector222:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $222
80107bd9:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107bde:	e9 f6 f0 ff ff       	jmp    80106cd9 <alltraps>

80107be3 <vector223>:
.globl vector223
vector223:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $223
80107be5:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107bea:	e9 ea f0 ff ff       	jmp    80106cd9 <alltraps>

80107bef <vector224>:
.globl vector224
vector224:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $224
80107bf1:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107bf6:	e9 de f0 ff ff       	jmp    80106cd9 <alltraps>

80107bfb <vector225>:
.globl vector225
vector225:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $225
80107bfd:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107c02:	e9 d2 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c07 <vector226>:
.globl vector226
vector226:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $226
80107c09:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107c0e:	e9 c6 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c13 <vector227>:
.globl vector227
vector227:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $227
80107c15:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107c1a:	e9 ba f0 ff ff       	jmp    80106cd9 <alltraps>

80107c1f <vector228>:
.globl vector228
vector228:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $228
80107c21:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107c26:	e9 ae f0 ff ff       	jmp    80106cd9 <alltraps>

80107c2b <vector229>:
.globl vector229
vector229:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $229
80107c2d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107c32:	e9 a2 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c37 <vector230>:
.globl vector230
vector230:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $230
80107c39:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107c3e:	e9 96 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c43 <vector231>:
.globl vector231
vector231:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $231
80107c45:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107c4a:	e9 8a f0 ff ff       	jmp    80106cd9 <alltraps>

80107c4f <vector232>:
.globl vector232
vector232:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $232
80107c51:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107c56:	e9 7e f0 ff ff       	jmp    80106cd9 <alltraps>

80107c5b <vector233>:
.globl vector233
vector233:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $233
80107c5d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107c62:	e9 72 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c67 <vector234>:
.globl vector234
vector234:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $234
80107c69:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107c6e:	e9 66 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c73 <vector235>:
.globl vector235
vector235:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $235
80107c75:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107c7a:	e9 5a f0 ff ff       	jmp    80106cd9 <alltraps>

80107c7f <vector236>:
.globl vector236
vector236:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $236
80107c81:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107c86:	e9 4e f0 ff ff       	jmp    80106cd9 <alltraps>

80107c8b <vector237>:
.globl vector237
vector237:
  pushl $0
80107c8b:	6a 00                	push   $0x0
  pushl $237
80107c8d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c92:	e9 42 f0 ff ff       	jmp    80106cd9 <alltraps>

80107c97 <vector238>:
.globl vector238
vector238:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $238
80107c99:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c9e:	e9 36 f0 ff ff       	jmp    80106cd9 <alltraps>

80107ca3 <vector239>:
.globl vector239
vector239:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $239
80107ca5:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107caa:	e9 2a f0 ff ff       	jmp    80106cd9 <alltraps>

80107caf <vector240>:
.globl vector240
vector240:
  pushl $0
80107caf:	6a 00                	push   $0x0
  pushl $240
80107cb1:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107cb6:	e9 1e f0 ff ff       	jmp    80106cd9 <alltraps>

80107cbb <vector241>:
.globl vector241
vector241:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $241
80107cbd:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107cc2:	e9 12 f0 ff ff       	jmp    80106cd9 <alltraps>

80107cc7 <vector242>:
.globl vector242
vector242:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $242
80107cc9:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107cce:	e9 06 f0 ff ff       	jmp    80106cd9 <alltraps>

80107cd3 <vector243>:
.globl vector243
vector243:
  pushl $0
80107cd3:	6a 00                	push   $0x0
  pushl $243
80107cd5:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107cda:	e9 fa ef ff ff       	jmp    80106cd9 <alltraps>

80107cdf <vector244>:
.globl vector244
vector244:
  pushl $0
80107cdf:	6a 00                	push   $0x0
  pushl $244
80107ce1:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ce6:	e9 ee ef ff ff       	jmp    80106cd9 <alltraps>

80107ceb <vector245>:
.globl vector245
vector245:
  pushl $0
80107ceb:	6a 00                	push   $0x0
  pushl $245
80107ced:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107cf2:	e9 e2 ef ff ff       	jmp    80106cd9 <alltraps>

80107cf7 <vector246>:
.globl vector246
vector246:
  pushl $0
80107cf7:	6a 00                	push   $0x0
  pushl $246
80107cf9:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107cfe:	e9 d6 ef ff ff       	jmp    80106cd9 <alltraps>

80107d03 <vector247>:
.globl vector247
vector247:
  pushl $0
80107d03:	6a 00                	push   $0x0
  pushl $247
80107d05:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107d0a:	e9 ca ef ff ff       	jmp    80106cd9 <alltraps>

80107d0f <vector248>:
.globl vector248
vector248:
  pushl $0
80107d0f:	6a 00                	push   $0x0
  pushl $248
80107d11:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107d16:	e9 be ef ff ff       	jmp    80106cd9 <alltraps>

80107d1b <vector249>:
.globl vector249
vector249:
  pushl $0
80107d1b:	6a 00                	push   $0x0
  pushl $249
80107d1d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107d22:	e9 b2 ef ff ff       	jmp    80106cd9 <alltraps>

80107d27 <vector250>:
.globl vector250
vector250:
  pushl $0
80107d27:	6a 00                	push   $0x0
  pushl $250
80107d29:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107d2e:	e9 a6 ef ff ff       	jmp    80106cd9 <alltraps>

80107d33 <vector251>:
.globl vector251
vector251:
  pushl $0
80107d33:	6a 00                	push   $0x0
  pushl $251
80107d35:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107d3a:	e9 9a ef ff ff       	jmp    80106cd9 <alltraps>

80107d3f <vector252>:
.globl vector252
vector252:
  pushl $0
80107d3f:	6a 00                	push   $0x0
  pushl $252
80107d41:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107d46:	e9 8e ef ff ff       	jmp    80106cd9 <alltraps>

80107d4b <vector253>:
.globl vector253
vector253:
  pushl $0
80107d4b:	6a 00                	push   $0x0
  pushl $253
80107d4d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107d52:	e9 82 ef ff ff       	jmp    80106cd9 <alltraps>

80107d57 <vector254>:
.globl vector254
vector254:
  pushl $0
80107d57:	6a 00                	push   $0x0
  pushl $254
80107d59:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107d5e:	e9 76 ef ff ff       	jmp    80106cd9 <alltraps>

80107d63 <vector255>:
.globl vector255
vector255:
  pushl $0
80107d63:	6a 00                	push   $0x0
  pushl $255
80107d65:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107d6a:	e9 6a ef ff ff       	jmp    80106cd9 <alltraps>

80107d6f <lgdt>:
{
80107d6f:	55                   	push   %ebp
80107d70:	89 e5                	mov    %esp,%ebp
80107d72:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107d75:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d78:	83 e8 01             	sub    $0x1,%eax
80107d7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d82:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107d86:	8b 45 08             	mov    0x8(%ebp),%eax
80107d89:	c1 e8 10             	shr    $0x10,%eax
80107d8c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107d90:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d93:	0f 01 10             	lgdtl  (%eax)
}
80107d96:	90                   	nop
80107d97:	c9                   	leave  
80107d98:	c3                   	ret    

80107d99 <ltr>:
{
80107d99:	55                   	push   %ebp
80107d9a:	89 e5                	mov    %esp,%ebp
80107d9c:	83 ec 04             	sub    $0x4,%esp
80107d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80107da2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107da6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107daa:	0f 00 d8             	ltr    %ax
}
80107dad:	90                   	nop
80107dae:	c9                   	leave  
80107daf:	c3                   	ret    

80107db0 <lcr3>:

static inline void
lcr3(uint val)
{
80107db0:	55                   	push   %ebp
80107db1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107db3:	8b 45 08             	mov    0x8(%ebp),%eax
80107db6:	0f 22 d8             	mov    %eax,%cr3
}
80107db9:	90                   	nop
80107dba:	5d                   	pop    %ebp
80107dbb:	c3                   	ret    

80107dbc <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107dbc:	55                   	push   %ebp
80107dbd:	89 e5                	mov    %esp,%ebp
80107dbf:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107dc2:	e8 19 c4 ff ff       	call   801041e0 <cpuid>
80107dc7:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107dcd:	05 40 48 11 80       	add    $0x80114840,%eax
80107dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd8:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de1:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dea:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107df5:	83 e2 f0             	and    $0xfffffff0,%edx
80107df8:	83 ca 0a             	or     $0xa,%edx
80107dfb:	88 50 7d             	mov    %dl,0x7d(%eax)
80107dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e01:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e05:	83 ca 10             	or     $0x10,%edx
80107e08:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e12:	83 e2 9f             	and    $0xffffff9f,%edx
80107e15:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e1f:	83 ca 80             	or     $0xffffff80,%edx
80107e22:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e2c:	83 ca 0f             	or     $0xf,%edx
80107e2f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e35:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e39:	83 e2 ef             	and    $0xffffffef,%edx
80107e3c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e46:	83 e2 df             	and    $0xffffffdf,%edx
80107e49:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e53:	83 ca 40             	or     $0x40,%edx
80107e56:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e60:	83 ca 80             	or     $0xffffff80,%edx
80107e63:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e69:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e70:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107e77:	ff ff 
80107e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7c:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107e83:	00 00 
80107e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e88:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e92:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e99:	83 e2 f0             	and    $0xfffffff0,%edx
80107e9c:	83 ca 02             	or     $0x2,%edx
80107e9f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107eaf:	83 ca 10             	or     $0x10,%edx
80107eb2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ec2:	83 e2 9f             	and    $0xffffff9f,%edx
80107ec5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ece:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ed5:	83 ca 80             	or     $0xffffff80,%edx
80107ed8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ee8:	83 ca 0f             	or     $0xf,%edx
80107eeb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107efb:	83 e2 ef             	and    $0xffffffef,%edx
80107efe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f07:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f0e:	83 e2 df             	and    $0xffffffdf,%edx
80107f11:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f21:	83 ca 40             	or     $0x40,%edx
80107f24:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f34:	83 ca 80             	or     $0xffffff80,%edx
80107f37:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f40:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107f51:	ff ff 
80107f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f56:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107f5d:	00 00 
80107f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f62:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f73:	83 e2 f0             	and    $0xfffffff0,%edx
80107f76:	83 ca 0a             	or     $0xa,%edx
80107f79:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f82:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f89:	83 ca 10             	or     $0x10,%edx
80107f8c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f95:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f9c:	83 ca 60             	or     $0x60,%edx
80107f9f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107faf:	83 ca 80             	or     $0xffffff80,%edx
80107fb2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fc2:	83 ca 0f             	or     $0xf,%edx
80107fc5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fce:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fd5:	83 e2 ef             	and    $0xffffffef,%edx
80107fd8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fe8:	83 e2 df             	and    $0xffffffdf,%edx
80107feb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ffb:	83 ca 40             	or     $0x40,%edx
80107ffe:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108007:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010800e:	83 ca 80             	or     $0xffffff80,%edx
80108011:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801a:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108024:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010802b:	ff ff 
8010802d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108030:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108037:	00 00 
80108039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010804d:	83 e2 f0             	and    $0xfffffff0,%edx
80108050:	83 ca 02             	or     $0x2,%edx
80108053:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108063:	83 ca 10             	or     $0x10,%edx
80108066:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010806c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108076:	83 ca 60             	or     $0x60,%edx
80108079:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010807f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108082:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108089:	83 ca 80             	or     $0xffffff80,%edx
8010808c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108095:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010809c:	83 ca 0f             	or     $0xf,%edx
8010809f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080af:	83 e2 ef             	and    $0xffffffef,%edx
801080b2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080c2:	83 e2 df             	and    $0xffffffdf,%edx
801080c5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080d5:	83 ca 40             	or     $0x40,%edx
801080d8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080e8:	83 ca 80             	or     $0xffffff80,%edx
801080eb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801080fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fe:	83 c0 70             	add    $0x70,%eax
80108101:	83 ec 08             	sub    $0x8,%esp
80108104:	6a 30                	push   $0x30
80108106:	50                   	push   %eax
80108107:	e8 63 fc ff ff       	call   80107d6f <lgdt>
8010810c:	83 c4 10             	add    $0x10,%esp
}
8010810f:	90                   	nop
80108110:	c9                   	leave  
80108111:	c3                   	ret    

80108112 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108112:	55                   	push   %ebp
80108113:	89 e5                	mov    %esp,%ebp
80108115:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108118:	8b 45 0c             	mov    0xc(%ebp),%eax
8010811b:	c1 e8 16             	shr    $0x16,%eax
8010811e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108125:	8b 45 08             	mov    0x8(%ebp),%eax
80108128:	01 d0                	add    %edx,%eax
8010812a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010812d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108130:	8b 00                	mov    (%eax),%eax
80108132:	83 e0 01             	and    $0x1,%eax
80108135:	85 c0                	test   %eax,%eax
80108137:	74 14                	je     8010814d <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010813c:	8b 00                	mov    (%eax),%eax
8010813e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108143:	05 00 00 00 80       	add    $0x80000000,%eax
80108148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010814b:	eb 42                	jmp    8010818f <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010814d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108151:	74 0e                	je     80108161 <walkpgdir+0x4f>
80108153:	e8 29 ab ff ff       	call   80102c81 <kalloc>
80108158:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010815b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010815f:	75 07                	jne    80108168 <walkpgdir+0x56>
      return 0;
80108161:	b8 00 00 00 00       	mov    $0x0,%eax
80108166:	eb 3e                	jmp    801081a6 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108168:	83 ec 04             	sub    $0x4,%esp
8010816b:	68 00 10 00 00       	push   $0x1000
80108170:	6a 00                	push   $0x0
80108172:	ff 75 f4             	push   -0xc(%ebp)
80108175:	e8 88 d6 ff ff       	call   80105802 <memset>
8010817a:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010817d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108180:	05 00 00 00 80       	add    $0x80000000,%eax
80108185:	83 c8 07             	or     $0x7,%eax
80108188:	89 c2                	mov    %eax,%edx
8010818a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010818f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108192:	c1 e8 0c             	shr    $0xc,%eax
80108195:	25 ff 03 00 00       	and    $0x3ff,%eax
8010819a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a4:	01 d0                	add    %edx,%eax
}
801081a6:	c9                   	leave  
801081a7:	c3                   	ret    

801081a8 <map_stack>:

int map_stack(pde_t* pgdir, void * va, uint pa, int perm){
801081a8:	55                   	push   %ebp
801081a9:	89 e5                	mov    %esp,%ebp
801081ab:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  char * a = (char*)PGROUNDDOWN((uint)va);
801081ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801081b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // cprintf("a= %s\n", a);
  // cprintf("va= %p\n", va);

  if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801081b9:	83 ec 04             	sub    $0x4,%esp
801081bc:	6a 01                	push   $0x1
801081be:	ff 75 f4             	push   -0xc(%ebp)
801081c1:	ff 75 08             	push   0x8(%ebp)
801081c4:	e8 49 ff ff ff       	call   80108112 <walkpgdir>
801081c9:	83 c4 10             	add    $0x10,%esp
801081cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081d3:	75 07                	jne    801081dc <map_stack+0x34>
    return -1;
801081d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081da:	eb 2e                	jmp    8010820a <map_stack+0x62>
  if(*pte & PTE_P)
801081dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081df:	8b 00                	mov    (%eax),%eax
801081e1:	83 e0 01             	and    $0x1,%eax
801081e4:	85 c0                	test   %eax,%eax
801081e6:	74 0d                	je     801081f5 <map_stack+0x4d>
    panic("remap");
801081e8:	83 ec 0c             	sub    $0xc,%esp
801081eb:	68 ec 91 10 80       	push   $0x801091ec
801081f0:	e8 a7 83 ff ff       	call   8010059c <panic>
  *pte = pa | perm | PTE_P;
801081f5:	8b 45 14             	mov    0x14(%ebp),%eax
801081f8:	0b 45 10             	or     0x10(%ebp),%eax
801081fb:	83 c8 01             	or     $0x1,%eax
801081fe:	89 c2                	mov    %eax,%edx
80108200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108203:	89 10                	mov    %edx,(%eax)
  return 0;
80108205:	b8 00 00 00 00       	mov    $0x0,%eax
  
}
8010820a:	c9                   	leave  
8010820b:	c3                   	ret    

8010820c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010820c:	55                   	push   %ebp
8010820d:	89 e5                	mov    %esp,%ebp
8010820f:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108212:	8b 45 0c             	mov    0xc(%ebp),%eax
80108215:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010821a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010821d:	8b 55 0c             	mov    0xc(%ebp),%edx
80108220:	8b 45 10             	mov    0x10(%ebp),%eax
80108223:	01 d0                	add    %edx,%eax
80108225:	83 e8 01             	sub    $0x1,%eax
80108228:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010822d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108230:	83 ec 04             	sub    $0x4,%esp
80108233:	6a 01                	push   $0x1
80108235:	ff 75 f4             	push   -0xc(%ebp)
80108238:	ff 75 08             	push   0x8(%ebp)
8010823b:	e8 d2 fe ff ff       	call   80108112 <walkpgdir>
80108240:	83 c4 10             	add    $0x10,%esp
80108243:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108246:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010824a:	75 07                	jne    80108253 <mappages+0x47>
      return -1;
8010824c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108251:	eb 47                	jmp    8010829a <mappages+0x8e>
    if(*pte & PTE_P)
80108253:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108256:	8b 00                	mov    (%eax),%eax
80108258:	83 e0 01             	and    $0x1,%eax
8010825b:	85 c0                	test   %eax,%eax
8010825d:	74 0d                	je     8010826c <mappages+0x60>
      panic("remap");
8010825f:	83 ec 0c             	sub    $0xc,%esp
80108262:	68 ec 91 10 80       	push   $0x801091ec
80108267:	e8 30 83 ff ff       	call   8010059c <panic>
    *pte = pa | perm | PTE_P;
8010826c:	8b 45 18             	mov    0x18(%ebp),%eax
8010826f:	0b 45 14             	or     0x14(%ebp),%eax
80108272:	83 c8 01             	or     $0x1,%eax
80108275:	89 c2                	mov    %eax,%edx
80108277:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010827a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010827c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108282:	74 10                	je     80108294 <mappages+0x88>
      break;
    a += PGSIZE;
80108284:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010828b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108292:	eb 9c                	jmp    80108230 <mappages+0x24>
      break;
80108294:	90                   	nop
  }
  return 0;
80108295:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010829a:	c9                   	leave  
8010829b:	c3                   	ret    

8010829c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010829c:	55                   	push   %ebp
8010829d:	89 e5                	mov    %esp,%ebp
8010829f:	53                   	push   %ebx
801082a0:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801082a3:	e8 d9 a9 ff ff       	call   80102c81 <kalloc>
801082a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082af:	75 07                	jne    801082b8 <setupkvm+0x1c>
    return 0;
801082b1:	b8 00 00 00 00       	mov    $0x0,%eax
801082b6:	eb 78                	jmp    80108330 <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
801082b8:	83 ec 04             	sub    $0x4,%esp
801082bb:	68 00 10 00 00       	push   $0x1000
801082c0:	6a 00                	push   $0x0
801082c2:	ff 75 f0             	push   -0x10(%ebp)
801082c5:	e8 38 d5 ff ff       	call   80105802 <memset>
801082ca:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082cd:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801082d4:	eb 4e                	jmp    80108324 <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801082dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082df:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e5:	8b 58 08             	mov    0x8(%eax),%ebx
801082e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082eb:	8b 40 04             	mov    0x4(%eax),%eax
801082ee:	29 c3                	sub    %eax,%ebx
801082f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f3:	8b 00                	mov    (%eax),%eax
801082f5:	83 ec 0c             	sub    $0xc,%esp
801082f8:	51                   	push   %ecx
801082f9:	52                   	push   %edx
801082fa:	53                   	push   %ebx
801082fb:	50                   	push   %eax
801082fc:	ff 75 f0             	push   -0x10(%ebp)
801082ff:	e8 08 ff ff ff       	call   8010820c <mappages>
80108304:	83 c4 20             	add    $0x20,%esp
80108307:	85 c0                	test   %eax,%eax
80108309:	79 15                	jns    80108320 <setupkvm+0x84>
      freevm(pgdir);
8010830b:	83 ec 0c             	sub    $0xc,%esp
8010830e:	ff 75 f0             	push   -0x10(%ebp)
80108311:	e8 f7 04 00 00       	call   8010880d <freevm>
80108316:	83 c4 10             	add    $0x10,%esp
      return 0;
80108319:	b8 00 00 00 00       	mov    $0x0,%eax
8010831e:	eb 10                	jmp    80108330 <setupkvm+0x94>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108320:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108324:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010832b:	72 a9                	jb     801082d6 <setupkvm+0x3a>
    }
  return pgdir;
8010832d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108333:	c9                   	leave  
80108334:	c3                   	ret    

80108335 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108335:	55                   	push   %ebp
80108336:	89 e5                	mov    %esp,%ebp
80108338:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010833b:	e8 5c ff ff ff       	call   8010829c <setupkvm>
80108340:	a3 64 76 11 80       	mov    %eax,0x80117664
  switchkvm();
80108345:	e8 03 00 00 00       	call   8010834d <switchkvm>
}
8010834a:	90                   	nop
8010834b:	c9                   	leave  
8010834c:	c3                   	ret    

8010834d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010834d:	55                   	push   %ebp
8010834e:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108350:	a1 64 76 11 80       	mov    0x80117664,%eax
80108355:	05 00 00 00 80       	add    $0x80000000,%eax
8010835a:	50                   	push   %eax
8010835b:	e8 50 fa ff ff       	call   80107db0 <lcr3>
80108360:	83 c4 04             	add    $0x4,%esp
}
80108363:	90                   	nop
80108364:	c9                   	leave  
80108365:	c3                   	ret    

80108366 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108366:	55                   	push   %ebp
80108367:	89 e5                	mov    %esp,%ebp
80108369:	56                   	push   %esi
8010836a:	53                   	push   %ebx
8010836b:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010836e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108372:	75 0d                	jne    80108381 <switchuvm+0x1b>
    panic("switchuvm: no process");
80108374:	83 ec 0c             	sub    $0xc,%esp
80108377:	68 f2 91 10 80       	push   $0x801091f2
8010837c:	e8 1b 82 ff ff       	call   8010059c <panic>
  if(p->kstack == 0)
80108381:	8b 45 08             	mov    0x8(%ebp),%eax
80108384:	8b 40 08             	mov    0x8(%eax),%eax
80108387:	85 c0                	test   %eax,%eax
80108389:	75 0d                	jne    80108398 <switchuvm+0x32>
    panic("switchuvm: no kstack");
8010838b:	83 ec 0c             	sub    $0xc,%esp
8010838e:	68 08 92 10 80       	push   $0x80109208
80108393:	e8 04 82 ff ff       	call   8010059c <panic>
  if(p->pgdir == 0)
80108398:	8b 45 08             	mov    0x8(%ebp),%eax
8010839b:	8b 40 04             	mov    0x4(%eax),%eax
8010839e:	85 c0                	test   %eax,%eax
801083a0:	75 0d                	jne    801083af <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801083a2:	83 ec 0c             	sub    $0xc,%esp
801083a5:	68 1d 92 10 80       	push   $0x8010921d
801083aa:	e8 ed 81 ff ff       	call   8010059c <panic>

  pushcli();
801083af:	e8 42 d3 ff ff       	call   801056f6 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801083b4:	e8 48 be ff ff       	call   80104201 <mycpu>
801083b9:	89 c3                	mov    %eax,%ebx
801083bb:	e8 41 be ff ff       	call   80104201 <mycpu>
801083c0:	83 c0 08             	add    $0x8,%eax
801083c3:	89 c6                	mov    %eax,%esi
801083c5:	e8 37 be ff ff       	call   80104201 <mycpu>
801083ca:	83 c0 08             	add    $0x8,%eax
801083cd:	c1 e8 10             	shr    $0x10,%eax
801083d0:	88 45 f7             	mov    %al,-0x9(%ebp)
801083d3:	e8 29 be ff ff       	call   80104201 <mycpu>
801083d8:	83 c0 08             	add    $0x8,%eax
801083db:	c1 e8 18             	shr    $0x18,%eax
801083de:	89 c2                	mov    %eax,%edx
801083e0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801083e7:	67 00 
801083e9:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801083f0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801083f4:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801083fa:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108401:	83 e0 f0             	and    $0xfffffff0,%eax
80108404:	83 c8 09             	or     $0x9,%eax
80108407:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010840d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108414:	83 c8 10             	or     $0x10,%eax
80108417:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010841d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108424:	83 e0 9f             	and    $0xffffff9f,%eax
80108427:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010842d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108434:	83 c8 80             	or     $0xffffff80,%eax
80108437:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010843d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108444:	83 e0 f0             	and    $0xfffffff0,%eax
80108447:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010844d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108454:	83 e0 ef             	and    $0xffffffef,%eax
80108457:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010845d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108464:	83 e0 df             	and    $0xffffffdf,%eax
80108467:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010846d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108474:	83 c8 40             	or     $0x40,%eax
80108477:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010847d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108484:	83 e0 7f             	and    $0x7f,%eax
80108487:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010848d:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108493:	e8 69 bd ff ff       	call   80104201 <mycpu>
80108498:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010849f:	83 e2 ef             	and    $0xffffffef,%edx
801084a2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801084a8:	e8 54 bd ff ff       	call   80104201 <mycpu>
801084ad:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801084b3:	8b 45 08             	mov    0x8(%ebp),%eax
801084b6:	8b 40 08             	mov    0x8(%eax),%eax
801084b9:	89 c3                	mov    %eax,%ebx
801084bb:	e8 41 bd ff ff       	call   80104201 <mycpu>
801084c0:	89 c2                	mov    %eax,%edx
801084c2:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801084c8:	89 42 0c             	mov    %eax,0xc(%edx)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801084cb:	e8 31 bd ff ff       	call   80104201 <mycpu>
801084d0:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801084d6:	83 ec 0c             	sub    $0xc,%esp
801084d9:	6a 28                	push   $0x28
801084db:	e8 b9 f8 ff ff       	call   80107d99 <ltr>
801084e0:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801084e3:	8b 45 08             	mov    0x8(%ebp),%eax
801084e6:	8b 40 04             	mov    0x4(%eax),%eax
801084e9:	05 00 00 00 80       	add    $0x80000000,%eax
801084ee:	83 ec 0c             	sub    $0xc,%esp
801084f1:	50                   	push   %eax
801084f2:	e8 b9 f8 ff ff       	call   80107db0 <lcr3>
801084f7:	83 c4 10             	add    $0x10,%esp
  popcli();
801084fa:	e8 45 d2 ff ff       	call   80105744 <popcli>
}
801084ff:	90                   	nop
80108500:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108503:	5b                   	pop    %ebx
80108504:	5e                   	pop    %esi
80108505:	5d                   	pop    %ebp
80108506:	c3                   	ret    

80108507 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108507:	55                   	push   %ebp
80108508:	89 e5                	mov    %esp,%ebp
8010850a:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010850d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108514:	76 0d                	jbe    80108523 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108516:	83 ec 0c             	sub    $0xc,%esp
80108519:	68 31 92 10 80       	push   $0x80109231
8010851e:	e8 79 80 ff ff       	call   8010059c <panic>
  mem = kalloc();
80108523:	e8 59 a7 ff ff       	call   80102c81 <kalloc>
80108528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010852b:	83 ec 04             	sub    $0x4,%esp
8010852e:	68 00 10 00 00       	push   $0x1000
80108533:	6a 00                	push   $0x0
80108535:	ff 75 f4             	push   -0xc(%ebp)
80108538:	e8 c5 d2 ff ff       	call   80105802 <memset>
8010853d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108543:	05 00 00 00 80       	add    $0x80000000,%eax
80108548:	83 ec 0c             	sub    $0xc,%esp
8010854b:	6a 06                	push   $0x6
8010854d:	50                   	push   %eax
8010854e:	68 00 10 00 00       	push   $0x1000
80108553:	6a 00                	push   $0x0
80108555:	ff 75 08             	push   0x8(%ebp)
80108558:	e8 af fc ff ff       	call   8010820c <mappages>
8010855d:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108560:	83 ec 04             	sub    $0x4,%esp
80108563:	ff 75 10             	push   0x10(%ebp)
80108566:	ff 75 0c             	push   0xc(%ebp)
80108569:	ff 75 f4             	push   -0xc(%ebp)
8010856c:	e8 50 d3 ff ff       	call   801058c1 <memmove>
80108571:	83 c4 10             	add    $0x10,%esp
}
80108574:	90                   	nop
80108575:	c9                   	leave  
80108576:	c3                   	ret    

80108577 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108577:	55                   	push   %ebp
80108578:	89 e5                	mov    %esp,%ebp
8010857a:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010857d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108580:	25 ff 0f 00 00       	and    $0xfff,%eax
80108585:	85 c0                	test   %eax,%eax
80108587:	74 0d                	je     80108596 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108589:	83 ec 0c             	sub    $0xc,%esp
8010858c:	68 4c 92 10 80       	push   $0x8010924c
80108591:	e8 06 80 ff ff       	call   8010059c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010859d:	e9 8f 00 00 00       	jmp    80108631 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801085a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a8:	01 d0                	add    %edx,%eax
801085aa:	83 ec 04             	sub    $0x4,%esp
801085ad:	6a 00                	push   $0x0
801085af:	50                   	push   %eax
801085b0:	ff 75 08             	push   0x8(%ebp)
801085b3:	e8 5a fb ff ff       	call   80108112 <walkpgdir>
801085b8:	83 c4 10             	add    $0x10,%esp
801085bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801085c2:	75 0d                	jne    801085d1 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
801085c4:	83 ec 0c             	sub    $0xc,%esp
801085c7:	68 6f 92 10 80       	push   $0x8010926f
801085cc:	e8 cb 7f ff ff       	call   8010059c <panic>
    pa = PTE_ADDR(*pte);
801085d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085d4:	8b 00                	mov    (%eax),%eax
801085d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085db:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801085de:	8b 45 18             	mov    0x18(%ebp),%eax
801085e1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085e4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801085e9:	77 0b                	ja     801085f6 <loaduvm+0x7f>
      n = sz - i;
801085eb:	8b 45 18             	mov    0x18(%ebp),%eax
801085ee:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085f4:	eb 07                	jmp    801085fd <loaduvm+0x86>
    else
      n = PGSIZE;
801085f6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801085fd:	8b 55 14             	mov    0x14(%ebp),%edx
80108600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108603:	01 d0                	add    %edx,%eax
80108605:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108608:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010860e:	ff 75 f0             	push   -0x10(%ebp)
80108611:	50                   	push   %eax
80108612:	52                   	push   %edx
80108613:	ff 75 10             	push   0x10(%ebp)
80108616:	e8 d2 98 ff ff       	call   80101eed <readi>
8010861b:	83 c4 10             	add    $0x10,%esp
8010861e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108621:	74 07                	je     8010862a <loaduvm+0xb3>
      return -1;
80108623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108628:	eb 18                	jmp    80108642 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
8010862a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108634:	3b 45 18             	cmp    0x18(%ebp),%eax
80108637:	0f 82 65 ff ff ff    	jb     801085a2 <loaduvm+0x2b>
  }
  return 0;
8010863d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108642:	c9                   	leave  
80108643:	c3                   	ret    

80108644 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108644:	55                   	push   %ebp
80108645:	89 e5                	mov    %esp,%ebp
80108647:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010864a:	8b 45 10             	mov    0x10(%ebp),%eax
8010864d:	85 c0                	test   %eax,%eax
8010864f:	79 0a                	jns    8010865b <allocuvm+0x17>
    return 0;
80108651:	b8 00 00 00 00       	mov    $0x0,%eax
80108656:	e9 ec 00 00 00       	jmp    80108747 <allocuvm+0x103>
  if(newsz < oldsz)
8010865b:	8b 45 10             	mov    0x10(%ebp),%eax
8010865e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108661:	73 08                	jae    8010866b <allocuvm+0x27>
    return oldsz;
80108663:	8b 45 0c             	mov    0xc(%ebp),%eax
80108666:	e9 dc 00 00 00       	jmp    80108747 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
8010866b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010866e:	05 ff 0f 00 00       	add    $0xfff,%eax
80108673:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010867b:	e9 b8 00 00 00       	jmp    80108738 <allocuvm+0xf4>
    mem = kalloc();
80108680:	e8 fc a5 ff ff       	call   80102c81 <kalloc>
80108685:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108688:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010868c:	75 2e                	jne    801086bc <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
8010868e:	83 ec 0c             	sub    $0xc,%esp
80108691:	68 8d 92 10 80       	push   $0x8010928d
80108696:	e8 61 7d ff ff       	call   801003fc <cprintf>
8010869b:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010869e:	83 ec 04             	sub    $0x4,%esp
801086a1:	ff 75 0c             	push   0xc(%ebp)
801086a4:	ff 75 10             	push   0x10(%ebp)
801086a7:	ff 75 08             	push   0x8(%ebp)
801086aa:	e8 9a 00 00 00       	call   80108749 <deallocuvm>
801086af:	83 c4 10             	add    $0x10,%esp
      return 0;
801086b2:	b8 00 00 00 00       	mov    $0x0,%eax
801086b7:	e9 8b 00 00 00       	jmp    80108747 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
801086bc:	83 ec 04             	sub    $0x4,%esp
801086bf:	68 00 10 00 00       	push   $0x1000
801086c4:	6a 00                	push   $0x0
801086c6:	ff 75 f0             	push   -0x10(%ebp)
801086c9:	e8 34 d1 ff ff       	call   80105802 <memset>
801086ce:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801086d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086d4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801086da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086dd:	83 ec 0c             	sub    $0xc,%esp
801086e0:	6a 06                	push   $0x6
801086e2:	52                   	push   %edx
801086e3:	68 00 10 00 00       	push   $0x1000
801086e8:	50                   	push   %eax
801086e9:	ff 75 08             	push   0x8(%ebp)
801086ec:	e8 1b fb ff ff       	call   8010820c <mappages>
801086f1:	83 c4 20             	add    $0x20,%esp
801086f4:	85 c0                	test   %eax,%eax
801086f6:	79 39                	jns    80108731 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
801086f8:	83 ec 0c             	sub    $0xc,%esp
801086fb:	68 a5 92 10 80       	push   $0x801092a5
80108700:	e8 f7 7c ff ff       	call   801003fc <cprintf>
80108705:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108708:	83 ec 04             	sub    $0x4,%esp
8010870b:	ff 75 0c             	push   0xc(%ebp)
8010870e:	ff 75 10             	push   0x10(%ebp)
80108711:	ff 75 08             	push   0x8(%ebp)
80108714:	e8 30 00 00 00       	call   80108749 <deallocuvm>
80108719:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
8010871c:	83 ec 0c             	sub    $0xc,%esp
8010871f:	ff 75 f0             	push   -0x10(%ebp)
80108722:	e8 c0 a4 ff ff       	call   80102be7 <kfree>
80108727:	83 c4 10             	add    $0x10,%esp
      return 0;
8010872a:	b8 00 00 00 00       	mov    $0x0,%eax
8010872f:	eb 16                	jmp    80108747 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80108731:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010873e:	0f 82 3c ff ff ff    	jb     80108680 <allocuvm+0x3c>
    }
  }
  return newsz;
80108744:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108747:	c9                   	leave  
80108748:	c3                   	ret    

80108749 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108749:	55                   	push   %ebp
8010874a:	89 e5                	mov    %esp,%ebp
8010874c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010874f:	8b 45 10             	mov    0x10(%ebp),%eax
80108752:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108755:	72 08                	jb     8010875f <deallocuvm+0x16>
    return oldsz;
80108757:	8b 45 0c             	mov    0xc(%ebp),%eax
8010875a:	e9 ac 00 00 00       	jmp    8010880b <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
8010875f:	8b 45 10             	mov    0x10(%ebp),%eax
80108762:	05 ff 0f 00 00       	add    $0xfff,%eax
80108767:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010876c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010876f:	e9 88 00 00 00       	jmp    801087fc <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108777:	83 ec 04             	sub    $0x4,%esp
8010877a:	6a 00                	push   $0x0
8010877c:	50                   	push   %eax
8010877d:	ff 75 08             	push   0x8(%ebp)
80108780:	e8 8d f9 ff ff       	call   80108112 <walkpgdir>
80108785:	83 c4 10             	add    $0x10,%esp
80108788:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010878b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010878f:	75 16                	jne    801087a7 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108794:	c1 e8 16             	shr    $0x16,%eax
80108797:	83 c0 01             	add    $0x1,%eax
8010879a:	c1 e0 16             	shl    $0x16,%eax
8010879d:	2d 00 10 00 00       	sub    $0x1000,%eax
801087a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801087a5:	eb 4e                	jmp    801087f5 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
801087a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087aa:	8b 00                	mov    (%eax),%eax
801087ac:	83 e0 01             	and    $0x1,%eax
801087af:	85 c0                	test   %eax,%eax
801087b1:	74 42                	je     801087f5 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801087b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087b6:	8b 00                	mov    (%eax),%eax
801087b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801087c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087c4:	75 0d                	jne    801087d3 <deallocuvm+0x8a>
        panic("kfree");
801087c6:	83 ec 0c             	sub    $0xc,%esp
801087c9:	68 c1 92 10 80       	push   $0x801092c1
801087ce:	e8 c9 7d ff ff       	call   8010059c <panic>
      char *v = P2V(pa);
801087d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087d6:	05 00 00 00 80       	add    $0x80000000,%eax
801087db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801087de:	83 ec 0c             	sub    $0xc,%esp
801087e1:	ff 75 e8             	push   -0x18(%ebp)
801087e4:	e8 fe a3 ff ff       	call   80102be7 <kfree>
801087e9:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801087ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801087f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108802:	0f 82 6c ff ff ff    	jb     80108774 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108808:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010880b:	c9                   	leave  
8010880c:	c3                   	ret    

8010880d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010880d:	55                   	push   %ebp
8010880e:	89 e5                	mov    %esp,%ebp
80108810:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108813:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108817:	75 0d                	jne    80108826 <freevm+0x19>
    panic("freevm: no pgdir");
80108819:	83 ec 0c             	sub    $0xc,%esp
8010881c:	68 c7 92 10 80       	push   $0x801092c7
80108821:	e8 76 7d ff ff       	call   8010059c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108826:	83 ec 04             	sub    $0x4,%esp
80108829:	6a 00                	push   $0x0
8010882b:	68 00 00 00 80       	push   $0x80000000
80108830:	ff 75 08             	push   0x8(%ebp)
80108833:	e8 11 ff ff ff       	call   80108749 <deallocuvm>
80108838:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010883b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108842:	eb 48                	jmp    8010888c <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80108844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010884e:	8b 45 08             	mov    0x8(%ebp),%eax
80108851:	01 d0                	add    %edx,%eax
80108853:	8b 00                	mov    (%eax),%eax
80108855:	83 e0 01             	and    $0x1,%eax
80108858:	85 c0                	test   %eax,%eax
8010885a:	74 2c                	je     80108888 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108866:	8b 45 08             	mov    0x8(%ebp),%eax
80108869:	01 d0                	add    %edx,%eax
8010886b:	8b 00                	mov    (%eax),%eax
8010886d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108872:	05 00 00 00 80       	add    $0x80000000,%eax
80108877:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010887a:	83 ec 0c             	sub    $0xc,%esp
8010887d:	ff 75 f0             	push   -0x10(%ebp)
80108880:	e8 62 a3 ff ff       	call   80102be7 <kfree>
80108885:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108888:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010888c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108893:	76 af                	jbe    80108844 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108895:	83 ec 0c             	sub    $0xc,%esp
80108898:	ff 75 08             	push   0x8(%ebp)
8010889b:	e8 47 a3 ff ff       	call   80102be7 <kfree>
801088a0:	83 c4 10             	add    $0x10,%esp
}
801088a3:	90                   	nop
801088a4:	c9                   	leave  
801088a5:	c3                   	ret    

801088a6 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088a6:	55                   	push   %ebp
801088a7:	89 e5                	mov    %esp,%ebp
801088a9:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088ac:	83 ec 04             	sub    $0x4,%esp
801088af:	6a 00                	push   $0x0
801088b1:	ff 75 0c             	push   0xc(%ebp)
801088b4:	ff 75 08             	push   0x8(%ebp)
801088b7:	e8 56 f8 ff ff       	call   80108112 <walkpgdir>
801088bc:	83 c4 10             	add    $0x10,%esp
801088bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801088c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088c6:	75 0d                	jne    801088d5 <clearpteu+0x2f>
    panic("clearpteu");
801088c8:	83 ec 0c             	sub    $0xc,%esp
801088cb:	68 d8 92 10 80       	push   $0x801092d8
801088d0:	e8 c7 7c ff ff       	call   8010059c <panic>
  *pte &= ~PTE_U;
801088d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d8:	8b 00                	mov    (%eax),%eax
801088da:	83 e0 fb             	and    $0xfffffffb,%eax
801088dd:	89 c2                	mov    %eax,%edx
801088df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e2:	89 10                	mov    %edx,(%eax)
}
801088e4:	90                   	nop
801088e5:	c9                   	leave  
801088e6:	c3                   	ret    

801088e7 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801088e7:	55                   	push   %ebp
801088e8:	89 e5                	mov    %esp,%ebp
801088ea:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801088ed:	e8 aa f9 ff ff       	call   8010829c <setupkvm>
801088f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088f9:	75 0a                	jne    80108905 <copyuvm+0x1e>
    return 0;
801088fb:	b8 00 00 00 00       	mov    $0x0,%eax
80108900:	e9 f8 00 00 00       	jmp    801089fd <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80108905:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010890c:	e9 c7 00 00 00       	jmp    801089d8 <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108914:	83 ec 04             	sub    $0x4,%esp
80108917:	6a 00                	push   $0x0
80108919:	50                   	push   %eax
8010891a:	ff 75 08             	push   0x8(%ebp)
8010891d:	e8 f0 f7 ff ff       	call   80108112 <walkpgdir>
80108922:	83 c4 10             	add    $0x10,%esp
80108925:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108928:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010892c:	75 0d                	jne    8010893b <copyuvm+0x54>
      panic("copyuvm: pte should exist");
8010892e:	83 ec 0c             	sub    $0xc,%esp
80108931:	68 e2 92 10 80       	push   $0x801092e2
80108936:	e8 61 7c ff ff       	call   8010059c <panic>
    if(!(*pte & PTE_P))
8010893b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010893e:	8b 00                	mov    (%eax),%eax
80108940:	83 e0 01             	and    $0x1,%eax
80108943:	85 c0                	test   %eax,%eax
80108945:	75 0d                	jne    80108954 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80108947:	83 ec 0c             	sub    $0xc,%esp
8010894a:	68 fc 92 10 80       	push   $0x801092fc
8010894f:	e8 48 7c ff ff       	call   8010059c <panic>
    pa = PTE_ADDR(*pte);
80108954:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108957:	8b 00                	mov    (%eax),%eax
80108959:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010895e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108961:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108964:	8b 00                	mov    (%eax),%eax
80108966:	25 ff 0f 00 00       	and    $0xfff,%eax
8010896b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010896e:	e8 0e a3 ff ff       	call   80102c81 <kalloc>
80108973:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108976:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010897a:	74 6d                	je     801089e9 <copyuvm+0x102>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010897c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010897f:	05 00 00 00 80       	add    $0x80000000,%eax
80108984:	83 ec 04             	sub    $0x4,%esp
80108987:	68 00 10 00 00       	push   $0x1000
8010898c:	50                   	push   %eax
8010898d:	ff 75 e0             	push   -0x20(%ebp)
80108990:	e8 2c cf ff ff       	call   801058c1 <memmove>
80108995:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010899b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010899e:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801089a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089a7:	83 ec 0c             	sub    $0xc,%esp
801089aa:	52                   	push   %edx
801089ab:	51                   	push   %ecx
801089ac:	68 00 10 00 00       	push   $0x1000
801089b1:	50                   	push   %eax
801089b2:	ff 75 f0             	push   -0x10(%ebp)
801089b5:	e8 52 f8 ff ff       	call   8010820c <mappages>
801089ba:	83 c4 20             	add    $0x20,%esp
801089bd:	85 c0                	test   %eax,%eax
801089bf:	79 10                	jns    801089d1 <copyuvm+0xea>
      kfree(mem);
801089c1:	83 ec 0c             	sub    $0xc,%esp
801089c4:	ff 75 e0             	push   -0x20(%ebp)
801089c7:	e8 1b a2 ff ff       	call   80102be7 <kfree>
801089cc:	83 c4 10             	add    $0x10,%esp
      goto bad;
801089cf:	eb 19                	jmp    801089ea <copyuvm+0x103>
  for(i = 0; i < sz; i += PGSIZE){
801089d1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089db:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089de:	0f 82 2d ff ff ff    	jb     80108911 <copyuvm+0x2a>
    }
  }
  return d;
801089e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e7:	eb 14                	jmp    801089fd <copyuvm+0x116>
      goto bad;
801089e9:	90                   	nop

bad:
  freevm(d);
801089ea:	83 ec 0c             	sub    $0xc,%esp
801089ed:	ff 75 f0             	push   -0x10(%ebp)
801089f0:	e8 18 fe ff ff       	call   8010880d <freevm>
801089f5:	83 c4 10             	add    $0x10,%esp
  return 0;
801089f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089fd:	c9                   	leave  
801089fe:	c3                   	ret    

801089ff <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801089ff:	55                   	push   %ebp
80108a00:	89 e5                	mov    %esp,%ebp
80108a02:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a05:	83 ec 04             	sub    $0x4,%esp
80108a08:	6a 00                	push   $0x0
80108a0a:	ff 75 0c             	push   0xc(%ebp)
80108a0d:	ff 75 08             	push   0x8(%ebp)
80108a10:	e8 fd f6 ff ff       	call   80108112 <walkpgdir>
80108a15:	83 c4 10             	add    $0x10,%esp
80108a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1e:	8b 00                	mov    (%eax),%eax
80108a20:	83 e0 01             	and    $0x1,%eax
80108a23:	85 c0                	test   %eax,%eax
80108a25:	75 07                	jne    80108a2e <uva2ka+0x2f>
    return 0;
80108a27:	b8 00 00 00 00       	mov    $0x0,%eax
80108a2c:	eb 22                	jmp    80108a50 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80108a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a31:	8b 00                	mov    (%eax),%eax
80108a33:	83 e0 04             	and    $0x4,%eax
80108a36:	85 c0                	test   %eax,%eax
80108a38:	75 07                	jne    80108a41 <uva2ka+0x42>
    return 0;
80108a3a:	b8 00 00 00 00       	mov    $0x0,%eax
80108a3f:	eb 0f                	jmp    80108a50 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80108a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a44:	8b 00                	mov    (%eax),%eax
80108a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a4b:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108a50:	c9                   	leave  
80108a51:	c3                   	ret    

80108a52 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a52:	55                   	push   %ebp
80108a53:	89 e5                	mov    %esp,%ebp
80108a55:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108a58:	8b 45 10             	mov    0x10(%ebp),%eax
80108a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108a5e:	eb 7f                	jmp    80108adf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108a60:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a68:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a6e:	83 ec 08             	sub    $0x8,%esp
80108a71:	50                   	push   %eax
80108a72:	ff 75 08             	push   0x8(%ebp)
80108a75:	e8 85 ff ff ff       	call   801089ff <uva2ka>
80108a7a:	83 c4 10             	add    $0x10,%esp
80108a7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108a80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a84:	75 07                	jne    80108a8d <copyout+0x3b>
      return -1;
80108a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a8b:	eb 61                	jmp    80108aee <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a90:	2b 45 0c             	sub    0xc(%ebp),%eax
80108a93:	05 00 10 00 00       	add    $0x1000,%eax
80108a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a9e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108aa1:	76 06                	jbe    80108aa9 <copyout+0x57>
      n = len;
80108aa3:	8b 45 14             	mov    0x14(%ebp),%eax
80108aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aac:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108aaf:	89 c2                	mov    %eax,%edx
80108ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ab4:	01 d0                	add    %edx,%eax
80108ab6:	83 ec 04             	sub    $0x4,%esp
80108ab9:	ff 75 f0             	push   -0x10(%ebp)
80108abc:	ff 75 f4             	push   -0xc(%ebp)
80108abf:	50                   	push   %eax
80108ac0:	e8 fc cd ff ff       	call   801058c1 <memmove>
80108ac5:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108acb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ad1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad7:	05 00 10 00 00       	add    $0x1000,%eax
80108adc:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108adf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ae3:	0f 85 77 ff ff ff    	jne    80108a60 <copyout+0xe>
  }
  return 0;
80108ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108aee:	c9                   	leave  
80108aef:	c3                   	ret    

80108af0 <barrier_init>:
struct spinlock block;


int
barrier_init(int n)
{
80108af0:	55                   	push   %ebp
80108af1:	89 e5                	mov    %esp,%ebp
80108af3:	83 ec 08             	sub    $0x8,%esp
  barrier_count = n;
80108af6:	8b 45 08             	mov    0x8(%ebp),%eax
80108af9:	a3 d4 76 11 80       	mov    %eax,0x801176d4
  N = n;
80108afe:	8b 45 08             	mov    0x8(%ebp),%eax
80108b01:	a3 80 76 11 80       	mov    %eax,0x80117680
  initlock(&block, "barrier-lock");
80108b06:	83 ec 08             	sub    $0x8,%esp
80108b09:	68 16 93 10 80       	push   $0x80109316
80108b0e:	68 a0 76 11 80       	push   $0x801176a0
80108b13:	e8 41 ca ff ff       	call   80105559 <initlock>
80108b18:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b1b:	b8 00 00 00 00       	mov    $0x0,%eax

}
80108b20:	c9                   	leave  
80108b21:	c3                   	ret    

80108b22 <barrier_check>:

int
barrier_check(void)
{
80108b22:	55                   	push   %ebp
80108b23:	89 e5                	mov    %esp,%ebp
80108b25:	83 ec 18             	sub    $0x18,%esp
  acquire(&block);
80108b28:	83 ec 0c             	sub    $0xc,%esp
80108b2b:	68 a0 76 11 80       	push   $0x801176a0
80108b30:	e8 46 ca ff ff       	call   8010557b <acquire>
80108b35:	83 c4 10             	add    $0x10,%esp
  if (barrier_count == 1){
80108b38:	a1 d4 76 11 80       	mov    0x801176d4,%eax
80108b3d:	83 f8 01             	cmp    $0x1,%eax
80108b40:	75 33                	jne    80108b75 <barrier_check+0x53>
    for (int i = 0; i < N; i++){
80108b42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b49:	eb 14                	jmp    80108b5f <barrier_check+0x3d>
      wakeup(&barrier_count);
80108b4b:	83 ec 0c             	sub    $0xc,%esp
80108b4e:	68 d4 76 11 80       	push   $0x801176d4
80108b53:	e8 83 c1 ff ff       	call   80104cdb <wakeup>
80108b58:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < N; i++){
80108b5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b5f:	a1 80 76 11 80       	mov    0x80117680,%eax
80108b64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80108b67:	7c e2                	jl     80108b4b <barrier_check+0x29>
    } 
    barrier_count = N;
80108b69:	a1 80 76 11 80       	mov    0x80117680,%eax
80108b6e:	a3 d4 76 11 80       	mov    %eax,0x801176d4
80108b73:	eb 22                	jmp    80108b97 <barrier_check+0x75>
  }
  else{
    barrier_count--;
80108b75:	a1 d4 76 11 80       	mov    0x801176d4,%eax
80108b7a:	83 e8 01             	sub    $0x1,%eax
80108b7d:	a3 d4 76 11 80       	mov    %eax,0x801176d4
    sleep(&barrier_count, &block);
80108b82:	83 ec 08             	sub    $0x8,%esp
80108b85:	68 a0 76 11 80       	push   $0x801176a0
80108b8a:	68 d4 76 11 80       	push   $0x801176d4
80108b8f:	e8 61 c0 ff ff       	call   80104bf5 <sleep>
80108b94:	83 c4 10             	add    $0x10,%esp
  }
  release(&block);
80108b97:	83 ec 0c             	sub    $0xc,%esp
80108b9a:	68 a0 76 11 80       	push   $0x801176a0
80108b9f:	e8 45 ca ff ff       	call   801055e9 <release>
80108ba4:	83 c4 10             	add    $0x10,%esp
  return 0;
80108ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bac:	c9                   	leave  
80108bad:	c3                   	ret    
