int main(){
  int inputInt, int lcount = 0, int hcount = 0;
  inputInt = readInt
  // Checking first 16
  for(int i = 0; i < 15; i++){
    if(inputInt % 2 == 0) lcount++;
    inputInt / 2;
  }
  //Now Check second 16 for 1s 
  for(int i = 0; i < 15; i++){
    if(inputInt % 2 == 1) hcount++;
    inputInt / 2;
  }

//Highest power of 4
while(inputInt % 4 == 0){
  pcount++
  inputInt / 4;
}

//Smallest Decimal Digit
int min = 9;
while(inputInt != 0) {
  if(inputInt % 10 < min) min = inputInt % 10;
    inputInt /= 10;
}

}
