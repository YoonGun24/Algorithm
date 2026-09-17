int[] arr;

void setup() {
  intArr(16);
  printArr();
  quickSorting(0, arr.length - 1);
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

void quickSorting(int left, int right) {
  int i, j;
  int pivot;

  i = left;
  j = right;
  pivot = arr[(left + right) / 2];

  while (i <= j) {

    while (arr[i] < pivot) {
      i++;
    }

    while (arr[j] > pivot) {
      j--;
    }

    if (i <= j) {
      swap(i, j);
      i++;
      j--;
    }
  }

  if (left < j) {
    quickSorting(left, j);
  }

  if (i < right) {
    quickSorting(i, right);
  }
}

void swap(int a, int b) {
  int tmp;

  tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}
