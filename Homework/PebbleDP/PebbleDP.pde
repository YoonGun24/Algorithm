// Processing / Java Mode. No external libraries.
// Original four states: top, middle, bottom, top + bottom.
// Each column must use one of these states (empty columns are excluded).
int[][] value = {
  {6, 7, 12, -5, 5, 3},
  {-8, 10, 14, 9, 7, 13},
  {11, 12, 7, 4, 8, 9}
};
int[] mask = {1, 2, 4, 5};
String[] names = {"TOP", "MIDDLE", "BOTTOM", "TOP + BOTTOM"};
int[][] previous = {{1, 2}, {0, 2, 3}, {0, 1}, {1}};
long[][] dp;
int[][] parent;
int[] path;
int n, bestState, tick = 0;
int stepFrames = 12;
boolean paused = false;
boolean exporting = Boolean.getBoolean("pebble.export");
boolean batch = exporting;
int ink, muted, teal, gold;

void setup() {
  size(1120, 800);
  frameRate(exporting ? 120 : 15);
  textFont(createFont("SansSerif", 18));
  ink = color(226, 234, 246);
  muted = color(145, 162, 184);
  teal = color(62, 220, 187);
  gold = color(255, 200, 99);
  solve();
  println("Maximum sum: " + dp[bestState][n-1]);
}

void solve() {
  if (value.length != 3 || value[0].length == 0)
    throw new RuntimeException("Use three nonempty rows.");
  n = value[0].length;
  for (int r = 1; r < 3; r++)
    if (value[r].length != n) throw new RuntimeException("Row lengths differ.");
  dp = new long[4][n];
  parent = new int[4][n];
  path = new int[n];
  for (int s = 0; s < 4; s++) dp[s][0] = weight(s, 0);
  for (int c = 1; c < n; c++) {
    for (int s = 0; s < 4; s++) {
      int winner = previous[s][0];
      for (int p : previous[s])
        if (dp[p][c-1] > dp[winner][c-1]) winner = p;
      dp[s][c] = dp[winner][c-1] + weight(s, c);
      parent[s][c] = winner;
    }
  }
  bestState = 0;
  for (int s = 1; s < 4; s++)
    if (dp[s][n-1] > dp[bestState][n-1]) bestState = s;
  path[n-1] = bestState;
  for (int c = n-1; c > 0; c--) path[c-1] = parent[path[c]][c];
}

long weight(int s, int c) {
  long sum = 0;
  for (int r = 0; r < 3; r++) if ((mask[s] & (1 << r)) != 0) sum += value[r][c];
  return sum;
}

void draw() {
  int stage = tick / stepFrames;
  int totalSteps = 1 + 4 * (n-1);
  boolean done = stage >= totalSteps;
  int col = stage == 0 ? 0 : min(n-1, 1 + (stage-1)/4);
  int state = stage == 0 ? -1 : (stage-1)%4;
  background(12, 20, 34);
  fill(teal); textSize(13); text("DYNAMIC PROGRAMMING  /  03", 44, 35);
  fill(ink); textSize(36); text("Pebble placement", 44, 81);
  fill(muted); textSize(16);
  text("No horizontal or vertical neighbors. Diagonal placements are allowed.", 44, 112);
  fill(done ? teal : gold); textAlign(RIGHT);
  textSize(18); text(done ? "OPTIMAL SUM  " + dp[bestState][n-1] : "COLUMN  " + (col+1) + " / " + n, 1076, 78);
  textAlign(LEFT);
  float cellW = min(114, 700.0f/n);
  float x0 = 218;
  fill(muted); textSize(13); text("BOARD / VALUES", 44, 157);
  for (int c = 0; c < n; c++) {
    fill(c == col && !done ? gold : muted); textAlign(CENTER);
    text("C"+(c+1), x0+c*cellW+cellW/2, 158);
    for (int r = 0; r < 3; r++) {
      float x = x0+c*cellW, y = 174+r*56;
      boolean selected = done ? (mask[path[c]] & (1<<r)) != 0 :
        c == col && state >= 0 && (mask[state] & (1<<r)) != 0;
      stroke(selected ? teal : color(43, 59, 80)); strokeWeight(selected ? 2 : 1);
      fill(selected ? color(24, 76, 72) : color(23, 36, 55));
      rect(x+3, y, cellW-6, 48, 9);
      fill(selected ? teal : ink); textSize(20); text(value[r][c], x+cellW/2, y+31);
    }
  }
  textAlign(LEFT); noStroke(); fill(muted); textSize(14);
  text("TOP", 44, 205); text("MIDDLE", 44, 261); text("BOTTOM", 44, 317);
  textSize(13); text("FOUR STATES", 954, 157);
  for (int s = 0; s < 4; s++) {
    fill(s == state && !done ? gold : muted); textSize(12); text("S"+(s+1), 958, 192+s*41);
    for (int r = 0; r < 3; r++) {
      fill((mask[s] & (1<<r)) != 0 ? teal : color(42, 57, 77));
      ellipse(1000+r*23, 188+s*41, 13, 13);
    }
  }
  fill(ink); textSize(19); text("Best sum ending in each state", 44, 390);
  fill(muted); textSize(13); text("A cell combines the best compatible predecessor with this column's value.", 44, 416);
  for (int s = 0; s < 4; s++) {
    fill(s == state && !done ? gold : muted); textSize(13);
    text("S"+(s+1)+"  "+names[s], 44, 461+s*45);
    for (int c = 0; c < n; c++) {
      boolean revealed = done || c == 0 || (c-1)*4+s+1 <= stage;
      boolean active = !done && c == col && s == state;
      boolean chosen = done && path[c] == s;
      boolean candidate = false;
      if (!done && state >= 0 && c == col-1)
        for (int p : previous[state]) if (p == s) candidate = true;
      stroke(active ? gold : chosen ? teal : candidate ? color(100, 130, 166) : color(36, 50, 71));
      strokeWeight(active || chosen ? 2 : 1);
      fill(active ? color(73, 59, 37) : chosen ? color(24, 76, 72) : color(21, 32, 49));
      rect(x0+c*cellW+3, 436+s*45, cellW-6, 36, 7);
      textAlign(CENTER); fill(active ? gold : chosen ? teal : revealed ? ink : muted);
      textSize(18); text(revealed ? ""+dp[s][c] : "-", x0+c*cellW+cellW/2, 461+s*45);
      textAlign(LEFT);
    }
  }
  noStroke(); fill(23, 36, 55); rect(44, 638, 1032, 96, 12);
  fill(done ? teal : gold); textSize(18);
  if (done) {
    text("Maximum sum = " + dp[bestState][n-1], 64, 671);
    fill(ink); textSize(15); String route = "Optimal states:  ";
    for (int c = 0; c < n; c++) route += (c == 0 ? "" : "  >  ") + "S"+(path[c]+1);
    text(route, 64, 705);
  } else if (stage == 0) {
    text("Initialize column 1", 64, 671);
    fill(ink); textSize(15); text("DP[s][1] = the value of state s in column 1", 64, 705);
  } else {
    String terms = "";
    for (int p : previous[state]) terms += (terms.length() == 0 ? "" : ", ") + dp[p][col-1];
    text("S"+(state+1)+" / "+names[state]+" at column "+(col+1), 64, 671);
    fill(ink); textSize(16);
    text("max("+terms+") + ("+weight(state,col)+") = "+dp[state][col], 64, 705);
  }
  fill(muted); textSize(13); text("SPACE  Pause     RIGHT  Next step     R  Replay     G  Export PNG frames", 44, 772);
  fill(teal); rect(44, 749, 1032 * min(1.0f, tick/(float)(totalSteps*stepFrames)), 3);
  if (exporting) {
    String dir = System.getProperty("pebble.frames", sketchPath("frames"));
    saveFrame(dir + "/pebble-" + nf(tick, 4) + ".png");
  }
  if (!paused || exporting) tick++;
  if (tick >= totalSteps*stepFrames+45) {
    if (exporting) {
      exporting = false;
      frameRate(15);
      println("Frame export complete.");
      if (batch) exit();
    }
    paused = true;
  }
}

void keyPressed() {
  if (key == ' ') paused = !paused;
  if (key == 'r' || key == 'R') { tick = 0; paused = false; }
  if (key == CODED && keyCode == RIGHT) { tick = (tick/stepFrames+1)*stepFrames; paused = true; }
  if (key == 'g' || key == 'G') { tick = 0; exporting = true; paused = false; frameRate(120); }
}
