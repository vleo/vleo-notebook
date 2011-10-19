#ifndef PCAP_IO
#define PCAP_IO


#define	ETHER_ADDR_LEN		6

	struct	ether_header 
	{
		u_int8_t	ether_dhost[ETHER_ADDR_LEN];
		u_int8_t	ether_shost[ETHER_ADDR_LEN];
		u_int16_t	ether_type;
	};

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
	};

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
	};

#endif // PCAP_IO
