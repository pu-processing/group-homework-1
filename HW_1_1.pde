float x,y,x_1,y_1,x_2,y_2;
float boomH,boomX,boomY,boomR,boomSpeedX,boomSpeedY;
int txtLine;
int[][] blockXY;
int[] blockR,randN,tempN;
boolean isBoom;
int size;
int i,j,tempi,life;
float dist;
String str1;
String[] lines;
void pointdis(float x_1,float y_1,float x_2,float y_2){
  dist=sqrt(sq(x_1-x_2)+sq(y_1-y_2));
}

void setup() {
  PFont font = createFont("標楷體", 16);
  textFont(font);
  lines = loadStrings("list.txt");
  txtLine=lines.length;
  blockXY = new int[txtLine][2];
  blockR = new int[txtLine];
  tempN = new int[txtLine];
  randN = new int[txtLine];
  size(1024,512);
  background(128);
  boomH=10;
  boomR=25;
  isBoom=false;
  x_1=width/2;
  y_1=height-boomH;
  x_2=mouseX;
  y_2=mouseY;
  size=15;
  for (i = 0; i < txtLine; i++) {
    blockR[i]=size*2;
    blockXY[i][0]=int(random(blockR[i],width-blockR[i]));
    for (j=0;j<i;j++){
      if(abs(blockXY[i][0]-blockXY[j][0])<size*1.5){
        blockXY[i][0]=int(random(blockR[i],width-blockR[i]));
        i=0;
      }
    }
    blockXY[i][1]=2*blockR[i];
    tempN[i]=i+1;
  }
  for (i=0;i<txtLine;i++){
    j=int(random(tempN.length));
    randN=splice(randN, tempN[j], 0);
    subset(tempN, tempN[j]);
  }
  tempi=0;
  life=txtLine;
}
void mousePressed() {
  if (mouseButton == LEFT) {
    isBoom=true;
  }else if (mouseButton == RIGHT) {
    loop();
    for (i = 0; i < txtLine; i++) {
      blockR[i]=size*2;
      blockXY[i][0]=int(random(blockR[i],width-blockR[i]));
      for (j=0;j<i;j++){
      if(abs(blockXY[i][0]-blockXY[j][0])<size*2){
        blockXY[i][0]=int(random(blockR[i],width-blockR[i]));
        i=0;
      }
    }
      blockXY[i][1]=int(random(blockR[i],1.5*blockR[i]));
    }
    tempi=0;
    life=txtLine;
    lines = loadStrings("list.txt");
    isBoom=false;
  }
}
void draw() {
  background(128);
  y=height-boomH-50;
  x=(y*(x_1-x_2)-(x_1*y_2-x_2*y_1))/(y_1-y_2);
  line(x_1, y_1, x, y);
  if (isBoom){
    fill(255);
    circle(boomX,boomY, boomR);
    for (i = 0; i < txtLine; i++) {
      pointdis(boomX,boomY,blockXY[i][0],blockXY[i][1]);
      if (dist<(boomR+blockR[i])/2){
         blockR[i]=0;
         blockXY[i][0]=width;
         blockXY[i][1]=height;
         lines[i]="";
         isBoom=false;
         life--;
         if (i==tempi){
           tempi++;
         }else{
           text("Game Over",width/2,height/2);
           noLoop();
         }
         break;
      }
    }
    if (boomY<boomR/2){
      isBoom=false;
      life--;
    }
    if (boomX<boomR/2 || boomX>width-boomR/2){
      boomSpeedX=-boomSpeedX;
    }
    boomX=boomX+boomSpeedX;
    boomY=boomY+boomSpeedY;
  }else{
    x_2=mouseX;
    y_2=mouseY;
    boomSpeedX=(x-x_1)/5;
    boomSpeedY=(y-y_1)/5;
    boomX=x;
    boomY=y;
    fill(255);
    circle(boomX,boomY, boomR);
  }
  fill(255);
  square(width/2-boomH/2,height-boomH, boomH);
  for (i = 0; i < txtLine; i++) {
    fill(200,100,0);
    circle(blockXY[i][0],blockXY[i][1], blockR[i]);
    line(blockXY[i][0],blockXY[i][1]+blockR[i]/2,blockXY[i][0],blockXY[i][1]+randN[i]*blockR[i]);
    fill(100,200,0);
    ellipse(blockXY[i][0],blockXY[i][1]+randN[i]*blockR[i], blockR[i]*5,blockR[i]);
    str1=lines[i];
    //str1=""+i;
    textSize(size);
    fill(0);
    text(str1, blockXY[i][0]-textWidth(str1)/2, blockXY[i][1]+size/2+randN[i]*blockR[i]);
    
  }
  str1="Life:"+life;
  textSize(size);
  fill(0);
  text(str1, textWidth(str1)/2, height-size/2);
}
