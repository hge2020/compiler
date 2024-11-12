#define LOOP 64
#define IN_SIZE 30
#define WGT_SIZE 10
#define OUT_SIZE 100
#define STRIDE 1
#define C_END 30

int in[IN_SIZE] = {};
int wgt[WGT_SIZE] = {};
int out[OUT_SIZE] = {};

__attribute__((optnone)) int loop_test(int bias);

__attribute__((optnone)) void conv(int bias);

__attribute__((optnone)) int main() {
  int bias = 2;
  int i = 0;
  /* intialization */
  for(i = 0; i < IN_SIZE; i++)  in[i] = 3;
  for(i = 0; i < WGT_SIZE; i++)  wgt[i] = 2;
  for(i = 0; i < OUT_SIZE; i++)  out[i] = 0;

  conv(bias);  


  /* loop_test is for HW debugging */
  // loop_test(bias);  
  return 0;
}

__attribute__((optnone))void conv(int bias){
  int i = 0;
  int j = 0;

  for(i = 0; i < C_END; i+=STRIDE){
    for(j = 0; j < WGT_SIZE; j++){
      out[i] = in[i + j] * wgt[j] + out[i];
    }
    out[i] += bias;
  }
}



__attribute__((optnone)) int loop_test(int bias) {
  int result = 1;
  int a[LOOP];

  for (int i = 0; i < LOOP; i += 1)
    a[i] = 10;

  for (int i = 0; i < LOOP; i += 1){
    result = ((result * a[i]) + bias);
  }
  return result;
}
