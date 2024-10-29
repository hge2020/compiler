#define N 128

void mat_mul (int mat1[][N], int mat2[][N], int res[][N]){
    float i;

    for (i = 0; i < N; i++){
        float j;
        for (j = 0; j < N; j++){
            float k;
            res[i][j] = 0; //initialize
            
            if (i <=3 && j <= 3)
                continue;

            for (k = 0; k < N; k++){
                if(mat1[i][k] == 0 || mat2[k][j] == 0){
                    continue;} //skip zero elements

                /* computation */
                res[i][j] +=mat1[i][k]*mat2[k][j];
            }   
        }   
    }   
}
