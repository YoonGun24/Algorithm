int[] arr;

void setup() {
  intArr(16);
  printArr();
  mergeSorting(0, arr.length - 1);
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

void mergeSorting(int left, int right) {
  int mid;

  if (left < right) {
    mid = (left + right) / 2;

    mergeSorting(left, mid);
    mergeSorting(mid + 1, right);

    merge(left, mid, right);
  }
}

void merge(int left, int mid, int right) {
  int[] tmp = new int[right - left + 1];

  int i = left;
  int j = mid + 1;
  int k = 0;

  while (i <= mid && j <= right) {
    if (arr[i] <= arr[j]) {
      tmp[k] = arr[i];
      i++;
    } else {
      tmp[k] = arr[j];
      j++;
    }
    k++;
  }

  while (i <= mid) {
    tmp[k] = arr[i];
    i++;
    k++;
  }

  while (j <= right) {
    tmp[k] = arr[j];
    j++;
    k++;
  }

  for (i = 0; i < tmp.length; i++) {
    arr[left + i] = tmp[i];
  }
}
