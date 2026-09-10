
int[] arr;

void setup() {
  intArr(16);
  printArr();
  selectionSorting();
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];

  for (i = 0; i < arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;

  for (i = 0; i < arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void selectionSorting() {
  int i, j, max, index;

  for (i = 0; i < arr.length; i++) {
    max = -1;
    index = -1;

    for (j = 0; j < arr.length - i; j++) {
      if (max < arr[j]) {
        max = arr[j];
        index = j;
      }
    }

    swap(index, arr.length - i - 1);
  }
}

void swap(int a, int b) {
  int tmp;

  tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}
