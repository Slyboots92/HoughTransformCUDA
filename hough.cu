#include "imagestruct.h"
#include <cuda_runtime.h>

__global__ void
threshold(const int *image, int *result, int number, int sizeOfRow)
{
    int i = blockIdx.x*sizeOfRow;
	int j = threadIdx.x;

    if (image[i+j] > number)
        result[i+j]=1;
	else
		result[i+j]=0;
}

int
main(void)
{
	ImageStruct imageInfo;
	int i,j;
	cudaError_t err = cudaSuccess;
	imageInfo.width=512;
	imageInfo.height=512;
	imageInfo.scale=256;
	size_t size = (imageInfo.height+2)*(imageInfo.width+2)*sizeof(int));
	imageInfo.image=(int*)malloc(size);
	int *d_image = NULL;
    err = cudaMalloc((void **)&d_image, size);
	int *result = NULL;
	err = cudaMalloc((void **)&result, size);
	for(i=0;i<=imageInfo.width+1;i++)
	{
		for(j=0;j<=imageInfo.height+1;j++)
		{
			imageInfo.image[i*imageInfo.width+j]=rand()%imageInfo.scale;
		}
	}
	err = cudaMemcpy(d_image, imageInfo.image, size, cudaMemcpyHostToDevice);
	threshold<<<512, 512>>>(d_image, result, 100,512);
	err = cudaMemcpy(imageInfo.image, d_image, size, cudaMemcpyDeviceToHost);
	for(i=0;i<=imageInfo.width+1;i++)
	{
		for(j=0;j<=imageInfo.height+1;j++)
		{
			printf("%i",imageInfo.image[i*imageInfo.width+j]);
		}
	}
	
/*
	for(i=0;i<=imageInfo.height+1;i++)
	{
		free(imageInfo.image[i]);
		free(result[i]);
	}
	free(imageInfo.image);
	free(result);*/
	return 0;
}
