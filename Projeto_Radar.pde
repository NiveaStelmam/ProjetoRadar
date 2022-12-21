import processing.serial.*; // importa biblioteca para comunicação serial
import java.awt.event.KeyEvent; // biblioteca de importações para ler os dados da porta serial
import java.io.IOException;

Serial myPort; // define os objetos serial
// variáveis
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;

void setup() {
  
 size (1366, 768); // mudar de acordo com a resolução da tela
 smooth();
 myPort = new Serial(this,"COM4", 9600); // inicia a comunicação serial
 myPort.bufferUntil('.'); // lê os dados da porta serial até o caractere '.' Então, na verdade, lê isto: ângulo, distância.
 orcFont = loadFont("AgencyFB-Reg-30.vlw");
}

void draw() { // função principal que chama rodas as outras funções
  
  fill(98,245,31); 
  textFont(orcFont);
  // simulando desfoque de movimento e desbotamento lento da linha em movimento
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); // cor verde
  // chama as funções para desenhar o radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}


// Recebe os valores de ângulo e a distância medida pelo sensor da placa e envia para o processing // LE OS DADOS DA PORTA SERIAL QUE FOI ENVIADA PELO ARDUINO

void serialEvent (Serial myPort) { // começa a ler dados da porta serial
  // lê os dados da porta serial até o caractere '.' e coloca na variável String "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // encontre o caractere ',' e coloque-o na variável "index1"
  angle= data.substring(0, index1); // leia os dados da posição "0" para a posição da variável index1 ou seja o valor do ângulo que a placa Arduino enviou para a porta serial
  distance= data.substring(index1+1, data.length()); // ler os dados da posição "index1" para o final dos dados pr thats o valor da distância
  

// ESSAS VARIAVEIS SERAO USADAS PARA DESENHAR O RADAR DE LINHAS (VERDE)
  // converte as string em inteiros
  iAngle = int(angle);  
  iDistance = int(distance);
}

// DESENHAR O RADAR DE LINHAS VERDES

void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.074); // move as coordenadas iniciais para o novo local
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // desenha as linhas do arco
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI); // FUNÇÕES DE ARCO
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // desenha as linhas angulares
  line(-width/2,0,width/2,0); // FUNÇÕES DE LINHA
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}


//FUNÇÃO QUE DESENHA O OBJETO DETECTADO PELO SENSOR ULTRASSONICO
void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.074); // move as coordenadas iniciais para o novo local
  strokeWeight(9);
  stroke(255,10,10); // cor vermelha
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // transforma a distância do sensor ultrassonico em pixels
  // limitando o alcance a 40 cms
  if(iDistance<40){
    // desenha o objeto de acordo com o ângulo e a distância
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

// DESENHA A LINHA QUE SE MOVE
void drawLine() {
  pushMatrix();
  strokeWeight(9); // LARGURA TRAÇADA
  stroke(30,250,60);
  translate(width/2,height-height*0.074); // move as coordenadas iniciais para o novo local
  line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); // desenha a linha de acordo com o ângulo
  popMatrix();
}

void drawText() { // desenha os textos na tela
  
  pushMatrix();
  if(iDistance>40) {
  noObject = "Fora do Radar";
  }
  else {
  noObject = "Objeto Detectado";
  }
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98,245,31);
  textSize(25);
  
  text("10cm",width-width*0.3854,height-height*0.0833);
  text("20cm",width-width*0.281,height-height*0.0833);
  text("30cm",width-width*0.177,height-height*0.0833);
  text("40cm",width-width*0.0729,height-height*0.0833);
  textSize(40);
  text("Objeto: " + noObject, width-width*0.875, height-height*0.0277);
  text("Anglo: " + iAngle +" °", width-width*0.48, height-height*0.0277);
  text("Distancia: ", width-width*0.26, height-height*0.0277);
  if(iDistance<40) {
  text("        " + iDistance +" cm", width-width*0.225, height-height*0.0277);
  }
  textSize(25);
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
