int[] arr;

void setup() {
  intArr(16);
  printArr();
  heapSorting();
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

void heapSorting() {
  int i;

  // 최대 힙 만들기
  for (i = arr.length / 2 - 1; i >= 0; i--) {
    heapify(arr.length, i);
  }

  // 가장 큰 값을 뒤로 보내기
  for (i = arr.length - 1; i > 0; i--) {
    swap(0, i);
    heapify(i, 0);
  }
}

void heapify(int n, int i) {
  int largest;
  int left;
  int right;

  largest = i;
  left = i * 2 + 1;
  right = i * 2 + 2;

  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }

  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }

  if (largest != i) {
    swap(i, largest);
    heapify(n, largest);
  }
}

void swap(int a, int b) {
  int tmp;

  tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}
