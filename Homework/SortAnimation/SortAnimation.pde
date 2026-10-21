ArrayList<Array> lists;
Array list, plist, tlist;
int type=3, napTime=100, len=16, index=0, loop=0;
boolean autoFlag=true;
String[] titles = {"selectionSort", "bubbleSort", "insertSort", "mergeSort", "quickSort"};
PFont f;

void setup() {
  size(900, 600);  
  f = createFont("SansSerif", 24);
  textFont(f);
  run(type);
}

void draw() {
  background(200);
  list = lists.get(index);
  list.draw();
  fill(0);
  if(list.i0 <= 0)
    text("("+nf(-list.i0,2)+","+nf(-list.j0,2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  else
    text("("+nf(list.i0,2)+","+nf(list.j0,2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  text(titles[type], 20, 40);
  if(autoFlag) nextStep();
}

void nextStep() {
  if(index==0 || index==loop) delay(10*napTime);
  else delay(napTime);
  if(index<loop) index++;
  else if(demoMode) {
    type=(type+1)%titles.length;
    run(type);
  }
  else index=0;
}

void keyPressed() {
  if(key == 'g') {
    demoMode=true;
    autoFlag=true;
    type=0;
    run(type);
  }
  else if(key == ' ') {
    autoFlag = !autoFlag;
  }
  else if(key == 'a') {
    if(napTime>100)
      napTime -= 100;
  }
  else if(key == 's') {
    napTime += 100;
  }
  else if(key == 'z') {
    if(type>0){
      type--;
      run(type);
    }  
  }
  else if(key == 'x') {
    if(type<titles.length-1) {
      type++;
      run(type);
    }  
  }
  else if (key == CODED) {
    if (keyCode == LEFT) {
      if(index>0) index--;
    } else if (keyCode == RIGHT) {
      if(index<loop) index++;
    } 
  }
}

void mousePressed() {
  if(autoFlag) autoFlag=false;
  if(mouseButton == LEFT) {
    if(index>0) index--;
  }
  else if(mouseButton == RIGHT) {
    if(index<loop) index++;
  }
}

void run(int type) {
  loop = index = 0;
  tlist = new Array(len, 0, -1);
  lists = new ArrayList<Array>();
  lists.add(new Array(len, 0, -1));
  list = lists.get(0);
  list.printArray();
  if (type==0) selectionSort();
  else if (type==1) bubbleSort();
  else if (type==2) insertSort();
  else if (type==3) mergeSort();
  else if (type==4) quickSort();  
  list = lists.get(loop);
  list.printArray();
}

void selectionSort() {
  int i, j, max, index, tlen=len;
  for (i=0; i<len; i++) {
    plist = lists.get(i);
    lists.add(new Array(len, plist.arr, i+1, len-i-1));
    loop++;
    list = lists.get(i+1);    
    max=-1;
    index=-1;
    for (j=0; j<tlen; j++) {
      if (max<list.arr[j]) {
        max=list.arr[j];
        index=j;
      }
    }
    if (index!=-1) swap(list.arr, index, tlen-1);
    tlen--;
  }
}

void bubbleSort() {
  int i, j;
  for (j=0; j<len-1; j++) {
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, j+1, 0));
    loop++;
    for (i=0; i<len-j-1; i++) {
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, j+1, i+1));
      loop++;
      list = lists.get(loop);    
      if (list.arr[i] > list.arr[i+1])
        swap(list.arr, i, i+1);
    }
  }
}

void insertSort() {
  for (int i=1; i<len; i++) {
    int temp = lists.get(loop).arr[i];
    int j=i-1;
    while (j>=0 && temp<lists.get(loop).arr[j]) {
      snapshot(i, j+1);
      list.arr[j+1] = list.arr[j];
      j--;
    }
    snapshot(i, j+1);
    list.arr[j+1] = temp;
  }
}

void mergeSort() {
  mergeSort(0, len-1);
}

void mergeSort(int low, int high) {
  if (low >= high) return;
  int middle = low + (high-low)/2;
  mergeSort(low, middle);
  mergeSort(middle+1, high);
  merge(lists.get(loop), low, middle, high);
}

void merge(Array current, int low, int middle, int high) {
  int[] temp = current.arr.clone();
  int i=low, j=middle+1;
  for (int k=low; k<=high; k++) {
    snapshot(k, high);
    if (i>middle) list.arr[k] = temp[j++];
    else if (j>high) list.arr[k] = temp[i++];
    else if (temp[i]<=temp[j]) list.arr[k] = temp[i++];
    else list.arr[k] = temp[j++];
  }
}



void swap(int[] arr, int i, int j) {
  int tmp=arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}

// Keep a separate array for every animation frame.
void snapshot(int i, int j) {
  plist = lists.get(loop);
  list = new Array(len, plist.arr, i, j);
  lists.add(list);
  loop++;
}

void quickSort() { quickSort(0, len-1); }

void quickSort(int low, int high) {
  int i=low, j=high;
  int pivot=lists.get(loop).arr[low+(high-low)/2];
  while (i<=j) {
    while (lists.get(loop).arr[i]<pivot) i++;
    while (lists.get(loop).arr[j]>pivot) j--;
    if (i<=j) {
      snapshot(i, j);
      swap(list.arr, i, j);
      i++;
      j--;
    }
  }
  if (low<j) quickSort(low, j);
  if (i<high) quickSort(i, high);
}

// g: play all five sorts in order for the demonstration.
boolean demoMode=false;
