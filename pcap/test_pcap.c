#include <sys/time.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <pcap/pcap.h>

static char errbuf[PCAP_ERRBUF_SIZE];
static char inputFile[]="input.pcap";
static char outputFile[]="output.pcap";

u_int16_t cksum(void* buf, int len)
{
}

int main(int argc, const char* argv[])
{
  pcap_t *p;
  int r;
  pcap_dumper_t *pd;

  struct pcap_pkthdr *h = malloc(sizeof(struct pcap_pkthdr));
  int pkt_size = 256;
  u_char *sp0 = malloc(pkt_size);
  u_char *sp;
  u_char *ip;

#ifdef OFFLINE
  p = pcap_open_offline(inputFile,errbuf);
  if(p==NULL) { fprintf(stderr,"Can't open input file %s : %s\n",inputFile,errbuf); exit(1); };
#endif

#ifdef INETDEVICE
  p = pcap_create("lo",errbuf);
  if(p==NULL) { fprintf(stderr,"Can't create pcap handle : %s\n",inputFile,errbuf); exit(1); };
  r = pcap_activate(p);
  if (r) { fprintf(stderr,"Can't activate pcap handle : %s\n",pcap_statustostr(r)); exit(1); };
#endif

#ifdef DUMMY
// emulate pcap_activate()
  p = malloc(sizeof(*p));
	memset(p, 0, sizeof(*p));

// end of pcap_activate
#endif

  pd = pcap_dump_open(p,outputFile);
  if(p==NULL) { fprintf(stderr,"Can't open output file %s:%s\n",outputFile,pcap_geterr(p)); exit(1); };

	gettimeofday(&h->ts,NULL);
	h->caplen=pkt_size;
	h->len=pkt_size;

	sp = sp0;

#define	ETHER_ADDR_LEN		6
	struct	ether_header 
	{
		u_int8_t	ether_dhost[ETHER_ADDR_LEN];
		u_int8_t	ether_shost[ETHER_ADDR_LEN];
		u_int16_t	ether_type;
	} eth = { {0x10,0x00,0x00,0x00,0x00,0x10},
          {0x10,0x00,0x00,0x00,0x00,0x20}, 8};

	memcpy(sp,&eth,sizeof(eth)); sp+=sizeof(eth);

	struct ip_header
	{ 
		u_int8_t ip_ver_hlen;
		u_int8_t tos;
		u_int16_t total_len;
		u_int16_t packet_id;
		#define	IP_DF 0x4000			/* dont fragment flag */
		u_int16_t fflags_offs;
		u_int8_t ttl;
		u_int8_t proto;
		u_int16_t hdr_chk;
		u_int32_t src;
		u_int32_t dst;
	} ip_hdr = {
	.ip_ver_hlen=0x45,
	.tos = 0x00,
	/* total_length */
	.packet_id=0x1245,
	.fflags_offs=0x4000,
	.ttl = 0x40,
	.proto = 0x06,
	/* hdr_chk */
	};

	memcpy(sp,&ip_hdr,sizeof(struct ip_header)); 
	ip=sp;
	sp+=sizeof(struct ip_header);
	
	((struct ip_header*)ip)->total_len = pkt_size;
	((struct ip_header*)ip)->hdr_chk = 0;
	((struct ip_header*)ip)->hdr_chk = cksum(ip,sizeof(struct ip_header));
	
	pcap_dump((u_char*)pd,h,sp0);
  
}
