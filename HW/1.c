#include <stdio.h>
int mat[100 * 100];
int n;
int req;
int nodelens[100];
int main(){
	scanf("%d", &req);
	if(req != 1) return 1;
	scanf("%d", &n);
	for(int x = 0;x<n;x++)
		scanf("%d", &nodelens[x]);
	for(int x = 0;x<n;x++){
		for(int y = 0;y<nodelens[x];y++){
			int node;
			scanf("%d", &node);
			mat[x * n + node] = 1;
		}
	}
	for(int x = 0;x<n;x++){
		for(int y = 0;y<n;y++){
			printf("%d ", mat[x * n + y]);
		}
		printf("\n");
	}
	return 0;
}

