int[] list = new int[100];
for(int i=0; i<list.length; i++) {
  list[i] = (int) random(1000);
  }

int i, j;
int max, index, tmp;

println(list.length);

for(i=0; i<list.length; i++) {
  println(list[i], " ");
}

println();

for(i=0; i<list.length-1; i++) {
  max = index = -1;
  
  for(j=0; j<list.length-i; j++) {
    if(max < list[j]) {
      max = list[j];
      index = j;
    }
  }

  if(index != -1) {
    tmp = list[list.length-1-i];
    list[list.length-1-i] = max;
    list[index] = tmp;
  }
}

for(i=0; i<list.length; i++) {
  print(list[i], " ");
}

line(0, 0, 100, 100);
