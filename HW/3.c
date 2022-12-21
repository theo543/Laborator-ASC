#include <stdio.h>
int mat[100 * 100], tmp1[100 * 100], tmp2[100 * 100];
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
	scanf("%d", &req);
	if(req != 1 && req != 2) return 1;
	scanf("%d", &size);
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

