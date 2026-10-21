// Press g for a simple repeatable demonstration.
boolean demo=false;
int demoStep=0, demoTime=0;
String demoText="";
ArrayList<Node> visiting=new ArrayList<Node>();
int visitIndex=0;

void startDemo() {
  demo=true;
  demoStep=0;
  demoTime=millis()+500;
  tree.clear();
  visiting.clear();
  drawTree();
}

void collectDemo(Node curr) {
  if(curr==null) return;
  if(traversal==1) visiting.add(curr);
  collectDemo(curr.left);
  if(traversal==0) visiting.add(curr);
  collectDemo(curr.right);
  if(traversal==2) visiting.add(curr);
}

void playDemo() {
  if(!demo || millis()<demoTime) return;
  demoTime=millis()+650;
  if(!visiting.isEmpty() && visitIndex<visiting.size()) {
    Node curr=visiting.get(visitIndex);
    fill(0,0,255);
    text(visitIndex,(int)(curr.x*xstep+width/2-radius/2-2),
      (int)(curr.y*ystep+radius-radius/2-2));
    visitIndex++;
    return;
  }
  int[] values={50,30,70,20,40,60,80,65};
  if(demoStep<8) {
    tree.insert(values[demoStep]);
    demoText="insert "+values[demoStep];
    drawTree();
  }
  else if(demoStep<11) {
    traversal=demoStep-8;
    drawTree();
    visiting.clear();
    collectDemo(tree.root);
    visitIndex=0;
    demoText=traversal==0?"inorder":traversal==1?"preorder":"postorder";
  }
  else if(demoStep<14) {
    int[] removeValues={20,60,50};
    int v=removeValues[demoStep-11];
    tree.remove(v);
    demoText="delete "+v;
    drawTree();
    demoTime=millis()+1500;
  }
  else {
    demo=false;
    demoText="done";
  }
  noStroke(); fill(200); rect(10,height-110,width-20,40);
  fill(0); textAlign(LEFT,CENTER); textFont(font,20);
  text(demoText,20,height-90);
  stroke(192,0,0); textFont(font,16); textAlign(CENTER,CENTER);
  demoStep++;
}
