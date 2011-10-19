#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <pcap/pcap.h>

#pragma pack(1)

static char errbuf[PCAP_ERRBUF_SIZE];
static char inputFile[]="input.pcap";
static char outputFile[]="output.pcap";

#define PKT_SIZE 256
//#define RTP_DATA "Quick Brown Fox Jumped Over the Lazy Dog 1234567890 times";
#define RTP_DATA "AAAA";

#define OFFLINE
#define UDP_LEN 38        // position of UDP Header UDP Length field

#define IP_LIVE 22        // position of IP Header Time to Live field

#define IP_CHECKSUM 24        // position of IP Header IP Checksum field


////////////////////////////////////////////////////////////////////////////
// pointer to the header filled by winpcap for each captured packet
// struct pcap_pkthdr    *pHeader;
// pointer to the buffer containing the packet captured by winpcap

// u_char            *pPkt_data;
// UDPchecksum routine
//   expects pHeader to point to the winpcap pcap_pkthdr structure
//   expects pPkt_data to point to the captured packet buffer
//   returns true if the UDP portion of the packet has a valid checksum

uint16_t UDPchecksum(struct pcap_pkthdr *pHeader, uint8_t *pPkt_data)
{
    // a 64 bit accumulator
    uint64_t qwSum = 0;
    int nSize;

    // a byte pointer to allow pointing anywhere in the buffer
    // pHeader->caplen doesn't include the ethernet 
    // FCS and filler (4+ bytes at end)

    unsigned char *pB = (unsigned char *)(pPkt_data + pHeader->caplen);
    // pDW is a pointer to dwords for grouping bytes

    // initialize to point to the FCS (or filler if packet length < 46) 

    // after UDP

    uint32_t *pDW  = (uint32_t *)(pB);

    // The 4+ bytes received after UDP are ethernet FCS and 
    // filler - ok to mangle.
    // Put 0's after UDP for groupings of leftover bytes < 4 at
    // the end of UDP
    // (adding one, two, or three bytes == 0 into checksum will not 
    // affect the result)

    *pDW = 0;

    // construct the pseudo header starting at 22
    // (IP Source & Dest Addresses are already in place)

    *(pPkt_data + IP_LIVE) = 0;
    *(pPkt_data + IP_CHECKSUM + 1) = *(pPkt_data + UDP_LEN + 1);
    *(pPkt_data + IP_CHECKSUM) = *(pPkt_data + UDP_LEN);

    // point pDW to beginning of pseudo header

    pB = (pPkt_data + 22);
    pDW = (uint32_t *)(pB);

    // set the size of bytes to inspect to the size of the UDP portion

    // plus the pseudo header starting at the IP header 'Time to Live' byte.

    nSize = pHeader->caplen - IP_LIVE;

    while( nSize > 0 )  {
        // Add DWORDs into the accumulator
        // This loop should be 'unfolded' to increase speed

        qwSum +=  (uint32_t) *pDW++;
        nSize -= 4;
    }
    //  Fold 64-bit sum to 16 bits

    while (qwSum >> 16)
       qwSum = (qwSum & 0xffff) + (qwSum >> 16);
    
    // a correct checksum result is 0xFFFF (at the receiving end)

    return ~qwSum;
}

// IP checksum ---- BEGIN --------------------------------------
/// Test vectors for cksum() function
static uint8_t cksum_TestVector[] =  { 0x03, 0xf4, 0xf5, 0xf6, 0xf7 };
static uint8_t cksum_TestVector1[] =  { 0x03, 0xf4 };
static uint8_t cksum_TestVector2[] =  { 0xf5, 0xf6, 0xf7 };
#define cksum_TestVector_RESULT 0x140f

/// IP checksum function
/// @param addr buffer pointer
/// @param cnt  buffer size (bytes)
/// @param cksum_inv inverted (~) checksum of previous block
u_int16_t cksum(void* addr, int cnt, u_int16_t cksum_inv)
{
	long sum = cksum_inv;
  uint16_t b; 
	//printf("cnt=%d\n",cnt);

	while ( cnt > 1 )
	{
		/*  This is the inner loop */
		b =  *(uint16_t*)addr;
		sum +=  b;
		//printf("x2 0x%04x 0x%04x\n",b,sum);
		cnt -= 2;
		addr += 2;
	}

	if( cnt > 0 )
	{
		b = *(uint8_t *) addr;
		sum += b;
		//printf("x1 0x%04x 0x%04x\n",b,sum);
	}

	/*  Fold 32-bit sum to 16 bits */
	while (sum>>16)
		sum = (sum & 0xffff) + (sum >> 16);

	return ~sum;
}
// IP checksum ---- END --------------------------------------

int main(int argc, const char* argv[])
{
  pcap_t *p;
  int r;
  pcap_dumper_t *pd;

  struct pcap_pkthdr *h = malloc(sizeof(struct pcap_pkthdr));

  int pkt_size = PKT_SIZE;
  u_char *sp0 = malloc(pkt_size);
	sp0[pkt_size-5]=0x12;

  u_char *sp;

  u_char *ip;
  u_char *udp;
  u_char *rtp;
	uint8_t rtp_data[] = RTP_DATA;
	printf("rtp data len = %d\n", sizeof(rtp_data));


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
	} eth_hdr = { {0x22,0x00,0x00,0x00,0x00,0x10},
            {0x11,0x00,0x00,0x00,0x00,0x10}, 8};


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
	} ip_hdr;

	struct udp_header
	{
		struct udp_pseudo_header
		{
			u_int32_t src;
			u_int32_t dst;
			u_int8_t zeroes;
			u_int8_t proto;
			u_int16_t udp_size;
		} pseudo;
		/* real header */
		struct udp_real_header
		{
			uint16_t src_port;
			uint16_t dst_port;
			uint16_t udp_size;
			uint16_t udp_cksum;
		} real;
	} udp_hdr;


	/*
	printf("TestVector 0x%04x 0x%04x\n", cksum(cksum_TestVector,sizeof(cksum_TestVector),0),cksum_TestVector_RESULT);
	uint16_t cksum1 =  cksum(cksum_TestVector1,sizeof(cksum_TestVector1),0);
	printf("TestVector2 0x%04x 0x%04x\n", cksum(cksum_TestVector2,sizeof(cksum_TestVector2),~cksum1),cksum_TestVector_RESULT);
	*/

	ip_hdr.ip_ver_hlen=0x40 | sizeof(struct ip_header)/4;
	ip_hdr.tos = 0x00;
	ip_hdr.total_len = htons(pkt_size);
	ip_hdr.packet_id=htons(0x1234);
	ip_hdr.fflags_offs=htons(0x4000 | 0);
	ip_hdr.ttl = 0x40;
	ip_hdr.proto = 0x11; /* UDP */

	ip_hdr.hdr_chk = 0;
	ip_hdr.src = 0x0302010A;
	ip_hdr.dst = 0x0605040A;
//	ip_hdr.src = 0x0;
//	ip_hdr.dst = 0x0;
	ip_hdr.hdr_chk = cksum(&ip_hdr,sizeof(struct ip_header),0);

	// UDP pseudo
	uint16_t cksum0;
	udp_hdr.pseudo.src =  ip_hdr.src;
	udp_hdr.pseudo.dst =  ip_hdr.dst;
	udp_hdr.pseudo.zeroes = 0;
	udp_hdr.pseudo.proto = ip_hdr.proto;
	udp_hdr.pseudo.udp_size = htons(pkt_size-sizeof(eth_hdr)-sizeof(ip_hdr));

	// UDP real
	udp_hdr.real.udp_cksum = 0;
	udp_hdr.real.src_port = htons(16666);
	udp_hdr.real.dst_port = htons(26666);
	udp_hdr.real.udp_size = htons(sizeof(struct udp_real_header)+sizeof(rtp_data));

	cksum0 = cksum(&udp_hdr,sizeof(struct udp_header),0);
	udp_hdr.real.udp_cksum = cksum(rtp_data,sizeof(rtp_data),~cksum0);
	printf("cksum1= 0x%04x cksum=0x%04x\n",cksum0,udp_hdr.real.udp_cksum);
	printf("~cksum1= 0x%04x ~cksum=0x%04x\n",~cksum0,~udp_hdr.real.udp_cksum);

// copy ETH header
	memcpy(sp,&eth_hdr,sizeof(eth_hdr)); sp+=sizeof(eth_hdr);

// copy IP header
	ip=sp;
	memcpy(ip,&ip_hdr,sizeof(struct ip_header)); 
	sp+=sizeof(struct ip_header);

// copy real UDP header
	udp=sp;
	memcpy(udp,&udp_hdr.real,sizeof(struct udp_real_header));
	sp+=sizeof(struct udp_real_header);

// copy RTP data
	rtp=sp;
	memcpy(rtp,rtp_data,sizeof(rtp_data));


	pcap_dump((u_char*)pd,h,sp0);
	printf("UDPchecksum=0x%04x\n",UDPchecksum(h,sp0));
  
}
