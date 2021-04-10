#include <stdio.h>


void calc(int *in, int *out) {
	int i,j;

	for(i=0;i<8;i++) {
		for(j=0;j<8;j++) {
			out[(i*8)+j] = in[(j*8)+i];
		}
	}
}

int main(int argc, char ** argv)
{
	int in[32];
	int out[32];

	int i,j;


	printf("in\n");
	for (i=0;i<0x80;i=i+4) {
		in[i/4] = (i>>1) | (((i>>1) + 1) << 16) ;
		printf("%x\n", in[i/4]);
	}
	calc(in, out);

	printf("out\n");
	for (i=0;i<0x20;i=i++) {
		printf("%x\n", out[i]);
	}


	return 0;
}


