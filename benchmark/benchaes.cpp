#define _XOPEN_SOURCE 500
#define __STDC_FORMAT_MACROS 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <malloc.h>
#include <stdint.h>
#include <inttypes.h>
#include <getopt.h>
#include <vector>
#include <algorithm>
#include <signal.h>
#include <assert.h>
#include <zlib.h>
#include <openssl/aes.h>
#include <dlfcn.h>

#define PAGE_SIZE 4096

void print_usage()
{
	fprintf(stderr, "usage:\n");
	fprintf(stderr, "  [options] <loop_number> <total_request>\n");
	fprintf(stderr, "  -v                  verbose\n");
	fprintf(stderr, "\n");
}

struct TestCaseDesc {
	unsigned thr_number;
	unsigned long long total_io;
	int verbose;
};

struct iorequest {
	int io_op;
	int flags;
	off64_t io_off;
	size_t io_size;
};

bool iorequest_less(const iorequest& a, const iorequest& b)
{
	return a.io_off < b.io_off;
}

struct ioqueue {
	std::vector<iorequest> data;
	size_t pos;
};

#define IO_TYPES 4

struct routine_context {
	int id;
	const TestCaseDesc* testcase;
	ioqueue* queue;

	// for stat
	timeval begin, end;
	uint64_t io_count[IO_TYPES];
	uint64_t io_sum[IO_TYPES];
};

volatile bool g_quit = false;

void sig_doquit_handler(int) {
	g_quit = true;
}

static void do_cpu(const TestCaseDesc& testcase, const iorequest* req, void* const buf,  void* const jobbuf)
{
	// fill data
	const uintmax_t tmp = req->io_off / 257;
	for (size_t i = 0; i < req->io_size; i+= sizeof(uintmax_t) ) {
		((uintmax_t*)buf)[i/sizeof(uintmax_t)] = (i + tmp) & 0xf00fff;
	}
	AES_KEY key = {};
	uint8_t iv[AES_BLOCK_SIZE] = {}; 
	AES_set_encrypt_key((const uint8_t*)"hollyshitgodfather", 128, &key);
	AES_cbc_encrypt((const uint8_t*)buf, (uint8_t*)jobbuf, req->io_size, &key, iv, AES_ENCRYPT);
	uint32_t c = crc32(0, (const uint8_t*)jobbuf, req->io_size);
	fprintf(stdout, "%llu %u\n", req->io_off, c);
}

void* io_routine(void* _arg)
{
	routine_context* arg = (routine_context*) _arg;
	const TestCaseDesc testcase = *arg->testcase;
	const size_t ringbuf_caps = 5*1024*1024ul;
	void* const ringbuf = memalign(PAGE_SIZE, ringbuf_caps);
	void* buf = ringbuf;
	void* const jobbuf = memalign(PAGE_SIZE, ringbuf_caps);

	gettimeofday(&arg->begin, NULL);
	while (!g_quit) {
		// adjust buf
		(uint8_t*&)buf += PAGE_SIZE;
		// get pos
		size_t pos;
		pos = arg->queue->pos;
		if (pos < arg->queue->data.size()) {
			arg->queue->pos += 1;
		}
		if (pos >=  arg->queue->data.size())
			break;
		// run io request
		const iorequest* req = &arg->queue->data[pos];
		if ((uint8_t*)buf + req->io_size > (uint8_t*)ringbuf + ringbuf_caps)
		{
			buf = ringbuf;
		}
		arg->io_count[req->io_op] += 1;
		arg->io_sum[req->io_op] += req->io_size;

		do_cpu(testcase, req, buf, jobbuf);

	}
	gettimeofday(&arg->end, NULL);
}

void process_arguments(int argc, char* argv[], TestCaseDesc* result)
{
	TestCaseDesc testcase = { };
	int c;
	bool opt_flag[256] = { };
	char* perr_strto = NULL;
	while (	-1 != (c = getopt(argc, argv, "v")) ) {
		opt_flag[c] = true;
		switch (c) {
		case 'v':
			testcase.verbose += 1;
			break;
		default:
			fprintf(stderr, "Invalid: -%c %s\n", c, optarg);
			print_usage();
			exit(1);
		}
		if (perr_strto && *perr_strto) {
			fprintf(stderr, "Invalid number: %s\n", optarg);
			print_usage();
			exit(1);
		}
	}

	if (argc - optind != 2) {
		print_usage();
		exit(1);
	}

	testcase.thr_number = strtoul(argv[optind++], NULL, 0);
	testcase.total_io = strtoull(argv[optind++], NULL, 0);

	*result = testcase;
}

void generate_requests(const TestCaseDesc& testcase, routine_context context[], ioqueue** pqueue)
{
	ioqueue* queue;
	queue = new ioqueue[testcase.thr_number];
	queue[0].data.reserve(testcase.total_io);
	for (int i = 0; i < testcase.thr_number; ++i) {
		context[i].queue = &queue[i];
	}

	*pqueue = queue;

	off64_t off = 0;
	for (int j = 0; j < testcase.total_io; ++j) {
		int i = j % testcase.thr_number;
		iorequest req = {0, 0, off, 32768};
		off += 32768;
		context[i].queue->data.push_back(req);
	}
	for (int i = 0; i < testcase.thr_number; ++i) {
		std::sort(queue[i].data.begin(), queue[i].data.end(), iorequest_less);
	}
}

int main(int argc, char* argv[])
{
	int rt;

	TestCaseDesc testcase = { };
	process_arguments(argc, argv, &testcase);

	// initializer io_routine context

	routine_context context0 = { };
	routine_context* context = new routine_context[testcase.thr_number];
	ioqueue* queue = NULL;
	for (int i = 0; i < testcase.thr_number; ++i) {
		context[i].testcase = &testcase;
		context[i].id = i;
	}
	generate_requests(testcase, context, &queue);
	
	fprintf(stdout, "all requests generated\n");

	signal(SIGINT, &sig_doquit_handler);
	signal(SIGTERM, &sig_doquit_handler);
	signal(SIGQUIT, SIG_IGN);

	// start io_routine
	for (int i = 0; i < testcase.thr_number; ++i) {
		io_routine(&context[i]);
	}
	// wait for all io_routine

	gettimeofday(&context0.begin, NULL);
	gettimeofday(&context0.end, NULL);

	delete[] queue;
	if (testcase.verbose > 0)
		fprintf(stderr, "[] main done\n");
}
