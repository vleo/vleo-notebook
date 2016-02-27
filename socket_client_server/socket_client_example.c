#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

#define MAXLINE 4096 /*max text line length*/
#define SERV_PORT 15828 /*port*/

int
main(int argc, char **argv)
{
 int sockfd;
 struct sockaddr_in servaddr;
 char sendLine[MAXLINE], recvline[MAXLINE];
 int n;

 //basic check of the arguments
 //additional checks can be inserted
 if (argc !=2) {
  fprintf(stderr,"Usage: TCPClient <IP address of the server>\n");
  exit(12);
 }

 //Create a socket for the client
 //If sockfd<0 there was an error in the creation of the socket
 if ((sockfd = socket (AF_INET, SOCK_STREAM, 0)) <0) {
  perror("Problem in creating the socket");
  exit(2);
 }

 //Creation of the socket
 memset(&servaddr, 0, sizeof(servaddr));
 servaddr.sin_family = AF_INET;
 servaddr.sin_addr.s_addr= inet_addr(argv[1]);
 servaddr.sin_port =  htons(SERV_PORT); //convert to big-endian order

 //Connection of the client to the socket
 if (connect(sockfd, (struct sockaddr *) &servaddr, sizeof(servaddr))<0) {
  perror("Problem in connecting to the server");
  exit(3);
 }

 strncpy(sendLine,"1",MAXLINE);
 send(sockfd,sendLine,strlen(sendLine),0);

 while (printf("waiting for incoming msg\n"),n=recv(sockfd, recvline, MAXLINE,0), n>0){
   if (n<0) {
   //error: server terminated prematurely
   perror("The server terminated prematurely\n");
   exit(4);
   }
 printf("String [%d] received %s\n",n, recvline);
 }
 printf("n= [%d]\n",n);


 exit(0);
}

