#include <stdio.h>
#include <sys/mman.h>
int size;
int req;
int nodelens[100];
int len, src, dst;
void matrix_mult(int *m1, int *m2, int *mres, int n){
	for(int x = 0;x<n;x++){
		for(int y = 0;y<n;y++){
			mres[x * n + y] = 0;
			for(int z = 0;z<n;z++){
				mres[x * n + y] += m1[x * n + z] * m2[z * n + y];
			}
		}
	}
}
int main(){
	int *mem, *mat, *tmp1, *tmp2;
	scanf("%d", &req);
	if(req != 1 && req != 3) return 1;
	scanf("%d", &size);
	if(size > 100) return 1;
	if(size < 0) return 1;
	mem = mmap(NULL, sizeof(int) * 3 * size * size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	mat = mem;
	tmp1 = mem + sizeof(int) * size * size;
	tmp2 = mem + sizeof(int) * 2 * size * size;
	for(int x = 0;x<size;x++)
		scanf("%d", &nodelens[x]);
	for(int x = 0;x<size;x++){
		for(int y = 0;y<nodelens[x];y++){
			int node;
			scanf("%d", &node);
			mat[x * size + node] = 1;
		}
	}
	if(req == 1){
		for(int x = 0;x<size;x++){
			for(int y = 0;y<size;y++){
				printf("%d ", mat[x * size + y]);
			}
			printf("\n");
		}
	}else{
		scanf("%d", &len);
		scanf("%d", &src);
		scanf("%d", &dst);
		int *prev = tmp1, *next = tmp2;
		for(int x = 0;x<size;x++)
			prev[x * size + x] = 1;
		for(int x = 0;x<len;x++){
			matrix_mult(prev, mat, next, size);
			int *tmp = prev;
			prev = next;
			next = tmp;
		}
		printf("%d\n", prev[src * size + dst]);
	}
	return 0;
}

