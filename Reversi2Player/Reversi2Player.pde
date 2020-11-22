//この"//-"の部分を外せば、裏返し処理をコンソールで見れます

//終了処理実装
//誰の手番か描画
//手元に石を描画
//"p"を押すとパスできます（黒と白でそれぞれ続けてパスすると終了）

//固定変数
int MASS_SIZE = 50;
int MASS_NUMBER = 8;
int STONE_SIZE = int(MASS_SIZE*0.8);
int WHITE = 1;
int BLACK = -1;
int NONE = 0;

int[][] mass_state;
boolean black_turn = true;

int white_number;
int black_number;
int pass_count = 0;

void setup() {
  size(550, 400);
  textAlign(CENTER);
  println("--------------------");
  println("BLACK TURN");

  //全てのマスを初期状態に
  mass_state = new int[MASS_NUMBER][MASS_NUMBER];
  for (int i=0; i<MASS_NUMBER; i++) {
    for (int j=0; j<MASS_NUMBER; j++) {
      mass_state[i][j] = 0;
    }
  }

  //偶数マスの場合の初期石設置
  if (MASS_NUMBER%2==0) {
    mass_state[MASS_NUMBER/2-1][MASS_NUMBER/2-1] = 1;
    mass_state[MASS_NUMBER/2-1][MASS_NUMBER/2] = -1;
    mass_state[MASS_NUMBER/2][MASS_NUMBER/2-1] = -1;
    mass_state[MASS_NUMBER/2][MASS_NUMBER/2] = 1;
  }
}

void draw() {
  background(50, 100, 50);

  //線
  for (int i=0; i<=MASS_NUMBER; i++) {
    line(i*MASS_SIZE, 0, i*MASS_SIZE, MASS_SIZE*MASS_NUMBER);
    line(0, i*MASS_SIZE, MASS_SIZE*MASS_NUMBER, i*MASS_SIZE);
  }

  //石の描画
  for (int i=0; i<MASS_NUMBER; i++) {
    for (int j=0; j<MASS_NUMBER; j++) {
      if (mass_state[i][j]==WHITE) {
        fill(255);
        ellipse(i*MASS_SIZE+0.5*MASS_SIZE, j*MASS_SIZE+0.5*MASS_SIZE, STONE_SIZE, STONE_SIZE);
      } else if (mass_state[i][j]==BLACK) {
        fill(0);
        ellipse(i*MASS_SIZE+0.5*MASS_SIZE, j*MASS_SIZE+0.5*MASS_SIZE, STONE_SIZE, STONE_SIZE);
      }
    }
  }

  //石の数カウント
  white_number = 0;
  black_number = 0;
  for (int i=0; i<MASS_NUMBER; i++) {
    for (int j=0; j<MASS_NUMBER; j++) {
      if (mass_state[i][j]==BLACK) {
        black_number++;
      } else if (mass_state[i][j]==WHITE) { 
        white_number++;
      }
    }
  }
  //石の数描画
  textSize(20);
  fill(150,150,100);
  text("WHITE "+white_number, MASS_SIZE*MASS_NUMBER+75, 100);
  text("BLACK "+black_number, MASS_SIZE*MASS_NUMBER+75, 150);

  //手番描画
  textSize(20);
  fill(0);
  if (black_turn) {
    fill(0);
    ellipse(mouseX+10,mouseY+10,STONE_SIZE/2,STONE_SIZE/2);
    text("BLACK TURN ", MASS_SIZE*MASS_NUMBER+75, 50);
  }else{
    fill(255);
    ellipse(mouseX,mouseY,STONE_SIZE/2,STONE_SIZE/2);
    text("WHITE TURN ", MASS_SIZE*MASS_NUMBER+75, 50);
  }

  //片方の石がなくなった時の終了処理
  textSize(25);
  fill(150,150,150);
  if (white_number<1) {
    println("Finish!");
    text("Win BLACK", MASS_SIZE*MASS_NUMBER+75, 250);
    stop();
  } else if (black_number<1) {
    println("Finish!");
    text("Win WHITE", MASS_SIZE*MASS_NUMBER+75, 250);
    stop();
  }
}

void mousePressed() {

  //石を置く処理
  int x = mouseX/MASS_SIZE;
  int y = mouseY/MASS_SIZE;
  if (mouseX>MASS_SIZE*MASS_NUMBER) {
    return;
  }
  //すでに石があったら
  if (mass_state[x][y]!=NONE) {
    //-print("Already stone exists:");
  }
  //石がなかったら
  if (mass_state[x][y]==NONE) {
    if (black_turn) {
      int turn_number = 0;
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (i==0 && j==0) {
            continue;
          }
          if (canTurn(x, y, i, j, 0)==0) {
            //-println("Can't turn any stones:");
          } else {
            turn_number += canTurn(x, y, i, j, 0);
            //-println("Turn-"+canTurn(x, y, i, j, 0)+":");
            int temp = canTurn(x, y, i, j, 0);
            for (int k=0; k<=temp; k++) {
              mass_state[x+k*i][y+k*j]=BLACK;
            }
          }
        }
      }
      //一つ以上返せていたら交代
      if (turn_number>0) {
        println("Turn number="+turn_number);
        pass_count = 0;
        black_turn = !black_turn;
      }
    } else {
      int turn_number = 0;
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (i==0 && j==0) {
            continue;
          }
          if (canTurn(x, y, i, j, 0)==0) {
            //-println("Can't turn any stones:");
          } else {
            turn_number += canTurn(x, y, i, j, 0);
            //-println("Turn-"+canTurn(x, y, i, j, 0)+":");
            int temp = canTurn(x, y, i, j, 0);
            for (int k=0; k<=temp; k++) {
              mass_state[x+k*i][y+k*j]=WHITE;
            }
          }
        }
      }
      //一つ以上返せていたら交代
      if (turn_number>0) {
        println("Total-"+turn_number);
        pass_count = 0;
        black_turn = !black_turn;
      }
    }
  }

  //コンソールにターン表示
  if (black_turn) {
    println("--------------------");
    println("BLACK TURN");
  } else {
    println("--------------------");
    println("WHITE TURN");
  }
}

//石が返せられるかを確認
int canTurn(int ax, int ay, int ai, int aj, int cnt) {
  if (ax+ai<0 || ax+ai>7 || ay+aj<0 || ay+aj>7) {
    //-print("Over field-");
    return 0;
  }
  //返せられるならtrueできないならfalse
  if (black_turn) {
    if (mass_state[ax+ai][ay+aj]==NONE) {
      //-print("No side-");
      return 0;
    } else if (mass_state[ax+ai][ay+aj]==BLACK) {
      if (cnt==0) {
        return 0;
      } else {
        return cnt;
      }
    } else {
      return canTurn(ax+ai, ay+aj, ai, aj, cnt+1);
    }
  } else {
    if (mass_state[ax+ai][ay+aj]==NONE) {
      //-print("No side-");
      return 0;
    } else if (mass_state[ax+ai][ay+aj]==WHITE) {
      if (cnt==0) {
        return 0;
      } else {
        return cnt;
      }
    } else {
      return canTurn(ax+ai, ay+aj, ai, aj, cnt+1);
    }
  }
}

void keyPressed() {
  if (key=='p') {
    println("Pass");
    pass_count++;
    //パスが２回連続した場合の終了処理
    if (pass_count>1) {
      println("Finish!");
      textSize(25);
      fill(150,150,150);
      if (black_number>white_number) {
        text("Win BLACK", MASS_SIZE*MASS_NUMBER+75, 250);
      } else if (white_number>black_number) {
        text("Win WHITE", MASS_SIZE*MASS_NUMBER+75, 250);
      } else {
        text("DRAW", MASS_SIZE*MASS_NUMBER+75, 250);
      }
      stop();
      return;
    }
    black_turn = !black_turn;

    //コンソールにターン表示
    if (black_turn) {
      println("--------------------");
      println("BLACK TURN");
    } else {
      println("--------------------");
      println("WHITE TURN");
    }
  }
}

