// Start from A and grow one connected tree.
int[][] edges = {
  {0, 1, 4}, {0, 2, 3}, {1, 2, 2}, {1, 3, 6},
  {2, 4, 8}, {3, 4, 7}, {3, 5, 1}, {4, 5, 5}
};
boolean[] inTree = new boolean[6];
boolean[] chosen = new boolean[edges.length];
int selected, total, active;

void advance() {
  int best = -1;
  for (int i = 0; i < edges.length; i++) {
    int[] edge = edges[i];
    if (crossesCut(edge)
        && (best == -1 || edge[2] < edges[best][2])) {
      best = i;
    }
  }
  if (best == -1) {
    finished = true;
    status = "No crossing edges. The graph is disconnected.";
    return;
  }
  int[] edge = edges[best];
  inTree[edge[0]] = inTree[edge[1]] = true;
  active = best;
  chosen[best] = true;
  total += edge[2];
  selected++;
  finished = selected == inTree.length - 1;
  String name = label(edge[0]) + "–" + label(edge[1]);
  status = "Add " + name + (finished
    ? ". Minimum spanning tree complete."
    : ". It is the lightest crossing edge.");
}

boolean crossesCut(int[] edge) {
  return inTree[edge[0]] != inTree[edge[1]];
}

void start() {
  java.util.Arrays.fill(inTree, false);
  java.util.Arrays.fill(chosen, false);
  inTree[0] = true;
  selected = total = 0;
  active = -1;
  finished = false;
  status = "Start at A. Gold edges cross the boundary of the tree.";
}

color edgeColor(int i) {
  if (chosen[i]) return teal;
  if (crossesCut(edges[i])) return amber;
  return neutral;
}

void drawGraph() {
  for (int i = 0; i < edges.length; i++) {
    int[] edge = edges[i];
    float weight = i == active ? 4 : chosen[i] ? 3 : 1.5;
    connection(edge[0], edge[1], edgeColor(i), weight);
  }
  for (int i = 0; i < edges.length; i++) {
    int[] edge = edges[i];
    float x = (positions[edge[0]][0] + positions[edge[1]][0]) / 2;
    float y = (positions[edge[0]][1] + positions[edge[1]][1]) / 2;
    noStroke();
    fill(panel);
    circle(x, y, 24);
    textSize(16);
    textAlign(CENTER, CENTER);
    fill(chosen[i] || crossesCut(edge) ? edgeColor(i) : ink);
    text(edge[2], x, y - 1);
  }
  for (int v = 0; v < inTree.length; v++) {
    vertex(v, inTree[v] ? teal : neutral, inTree[v] ? #163C36 : panel);
  }
}

void drawDetails() {
  textAlign(LEFT, CENTER);
  fill(muted);
  textSize(16);
  text("Edges selected", 30, 405);
  text("Total weight", 30, 436);
  fill(teal);
  textSize(19);
  text(selected + " / " + (inTree.length - 1), 177, 405);
  text(total, 177, 436);
}

float[][] positions = {
  {77, 233}, {193, 164}, {211, 308},
  {430, 164}, {408, 308}, {548, 233}
};

color ink = #DBE9F5, muted = #9FB3CA, panel = #142334;
color teal = #30E0AD, amber = #FFD078, neutral = #435A73;
boolean paused, finished;
int nextStep;
String status;

void setup() {
  size(630, 484);
  textFont(createFont("SansSerif", 19, true));
  replay();
}

void replay() {
  start();
  nextStep = millis() + 1450;
}

void draw() {
  if (!paused && !finished && millis() >= nextStep) {
    advance();
    nextStep = millis() + 1550;
  }
  background(#0D1723);
  textAlign(LEFT, TOP);
  fill(teal);
  textSize(14);
  text("GRAPH ALGORITHMS", 30, 20);
  fill(ink);
  textSize(32);
  text("Minimum spanning tree", 30, 42);
  fill(muted);
  textSize(16);
  text("Prim's algorithm · grow the tree via the lightest crossing edge.", 30, 86);

  noStroke();
  fill(panel);
  rect(26, 117, 578, 230, 12);
  drawGraph();

  textAlign(LEFT, CENTER);
  fill(finished ? teal : ink);
  textSize(18);
  text(status, 30, 365);
  drawDetails();

  textAlign(LEFT, CENTER);
  fill(muted);
  textSize(13);
  text("SPACE  Pause  /  resume       RIGHT  Step       R  Replay", 30, 465);
}

void vertex(int i, color accent, color surface) {
  float x = positions[i][0], y = positions[i][1];
  stroke(accent);
  strokeWeight(2);
  fill(surface);
  circle(x, y, 43);
  fill(ink);
  textAlign(CENTER, CENTER);
  textSize(21);
  text(label(i), x, y - 2);
}

void connection(int u, int v, color accent, float weight) {
  stroke(accent);
  strokeWeight(weight);
  line(positions[u][0], positions[u][1], positions[v][0], positions[v][1]);
}

String label(int v) {
  return str((char) ('A' + v));
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
    nextStep = millis() + 1550;
  } else if (key == CODED && keyCode == RIGHT && !finished) {
    paused = true;
    advance();
  } else if (key == 'r' || key == 'R') {
    paused = false;
    replay();
  }
}
