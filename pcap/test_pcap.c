#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <pcap/pcap.h>

#include "pcap_io.h"

#pragma pack(1)

static char errbuf[PCAP_ERRBUF_SIZE];
static char inputFile[]="input.pcap";
static char outputFile[]="output.pcap";

#define PKT_SIZE 256
//#define RTP_DATA "Quick Brown Fox Jumped Over the Lazy Dog 1234567890 times";
#define RTP_DATA "AAAA";

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
  pcap_t *pcapHandle;
  int res;
  pcap_dumper_t *pcapDumper;

  struct pcap_pkthdr *pcapHdr = malloc(sizeof(struct pcap_pkthdr));

  int pktSize = PKT_SIZE;
  u_char *pcapPkt_ptr = malloc(pktSize);
	pcapPkt_ptr[pktSize-5]=0x12;

  u_char *currentPktLayer;

  u_char *ipPkt;
  u_char *udpPkt;
  u_char *rtpPkt;
	uint8_t rtpData[] = RTP_DATA;
	printf("rtp data len = %d\n", sizeof(rtpData));

// construct pcap handler
  pcapHandle = pcap_open_offline(inputFile,errbuf);
  if(pcapHandle==NULL) { fprintf(stderr,"Can't open input file %s : %s\n",inputFile,errbuf); exit(1); };
// end of pcap_activate

  pcapDumper = pcap_dump_open(pcapHandle,outputFile);
  if(pcapHandle==NULL) { fprintf(stderr,"Can't open output file %s:%s\n",outputFile,pcap_geterr(pcapHandle)); exit(1); };

	gettimeofday(&pcapHdr->ts,NULL);
	pcapHdr->caplen=pktSize;
	pcapHdr->len=pktSize;

	currentPktLayer = pcapPkt_ptr;

	struct	ether_header  eth_hdr = { 
						{0x22,0x00,0x00,0x00,0x00,0x10},
            {0x11,0x00,0x00,0x00,0x00,0x10}, 
						8 };

	struct ip_header ip_hdr;

	struct udp_header udp_hdr;


	ip_hdr.ip_ver_hlen=0x40 | sizeof(struct ip_header)/4;
	ip_hdr.tos = 0x00;
	ip_hdr.total_len = htons(pktSize);
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
	uint16_t chkSum1;
	udp_hdr.pseudo.src =  ip_hdr.src;
	udp_hdr.pseudo.dst =  ip_hdr.dst;
	udp_hdr.pseudo.zeroes = 0;
	udp_hdr.pseudo.proto = ip_hdr.proto;
	udp_hdr.pseudo.udp_size = htons(pktSize-sizeof(eth_hdr)-sizeof(ip_hdr));

	// UDP real
	udp_hdr.real.udp_cksum = 0;
	udp_hdr.real.src_port = htons(16666);
	udp_hdr.real.dst_port = htons(26666);
	udp_hdr.real.udp_size = htons(sizeof(struct udp_real_header)+sizeof(rtpData));

	chkSum1 = cksum(&udp_hdr,sizeof(struct udp_header),0);
	udp_hdr.real.udp_cksum = cksum(rtpData,sizeof(rtpData),~chkSum1);
	printf("cksum1= 0x%04x cksum=0x%04x\n",chkSum1,udp_hdr.real.udp_cksum);
	printf("~cksum1= 0x%04x ~cksum=0x%04x\n",~chkSum1,~udp_hdr.real.udp_cksum);

// copy ETH header
	memcpy(currentPktLayer,&eth_hdr,sizeof(eth_hdr)); currentPktLayer+=sizeof(eth_hdr);

// copy IP header
	ipPkt=currentPktLayer;
	memcpy(ipPkt,&ip_hdr,sizeof(struct ip_header)); 
	currentPktLayer+=sizeof(struct ip_header);

// copy real UDP header
	udpPkt=currentPktLayer;
	memcpy(udpPkt,&udp_hdr.real,sizeof(struct udp_real_header));
	currentPktLayer+=sizeof(struct udp_real_header);

// copy RTP data
	rtpPkt=currentPktLayer;
	memcpy(rtpPkt,rtpData,sizeof(rtpData));


	pcap_dump((u_char*)pcapDumper,pcapHdr,pcapPkt_ptr);
	printf("UDPchecksum=0x%04x\n",UDPchecksum(pcapHdr,pcapPkt_ptr));
  
}
