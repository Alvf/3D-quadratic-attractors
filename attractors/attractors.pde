    //the goal: give a random set of coefficients for a general linear
  //3D attracting system and graph it to see how cool it looks given
  //some random starting points
  import peasy.*;
  
  ArrayList<PVector>[] points  = (ArrayList<PVector>[])new ArrayList[4];
  float[] xdiff = {0,0,0,0};
  float[] ydiff = {0,0,0,0};
  float[] zdiff = {0,0,0,0};
  float[] xi = {random(-10,10),random(-10,10),random(-10,10),random(-10,10)};
  float[] yi = {random(-10,10),random(-10,10),random(-10,10),random(-10,10)};
  float[] zi = {0,0,0,0};
  color[] colors = {#FFFFFF,#3EB600,#603EFF,#E10837};
  float dt = 0.01;
  
  //random coefficients; there are eighteen; 3+3+3 for each d(x,y,z)/dt
  float[] c = new float[27];


PeasyCam cam;

void setup(){
  size(750,750,P3D);
  background(0,0,0);
  for(int k =0 ;k<colors.length;k++){
  points[k] = new ArrayList<PVector>();
  }
  
  //for(int j = 0; j<c.length;j++){
  //  c[j] = random(-10,10);
  //}
  
  c[0] = -10 ;
  c[1] = -c[0];
  c[2] = c[3] = c[4] = c[5] = c[6] = c[7] = c[8] = 0;
  c[10] = c[16] = -1;
  c[9] = 28;
  c[11] = c[12] = c[13] = c[14] = c[15] = c[17] = 0;
  c[20] = -8/3;
  c[24] = 1;
  c[18] = c[19] = c[21] = c[22] =c[23] = c[25] = c[26] = 0;
  
  
  while(!isinteresting(c,10000,100000,0.02)){
    
    for(int j = 0; j<c.length;j++){
    c[j] = random(-10,10);
  }
  
  }
  
  cam = new PeasyCam(this, 500);
}

public float[] iterate(float x0,float y0,float z0,float[] c){
  float dx = 0;
  float dy = 0;
  float dz = 0;
  
  dx = (c[0]*x0+c[1]*y0+c[2]*z0
  +c[3]*x0*x0+c[4]*y0*y0+c[5]*z0*z0
  +c[6]*x0*y0+c[7]*x0*z0+c[8]*y0*z0)*dt;
  
  dy = (c[9]*x0+c[10]*y0+c[11]*z0
  +c[12]*x0*x0+c[13]*y0*y0+c[14]*z0*z0
  +c[15]*x0*y0+c[16]*x0*z0+c[17]*y0*z0)*dt;
  
  dz = (c[18]*x0+c[19]*y0+c[20]*z0
  +c[21]*x0*x0+c[22]*y0*y0+c[23]*z0*z0
  +c[24]*x0*y0+c[25]*x0*z0+c[26]*y0*z0)*dt;
  
  x0 += dx;
  y0 += dy;
  z0 += dz;
  
  float[] coords = {x0,y0,z0};
  return coords;
  
}

boolean isinteresting(float[] c,float bounds,int iterations,float close){
for(int n = 0; n<3;n++){
  float maxvec =0;
  ArrayList<PVector> testrun = new ArrayList<PVector>();
  ArrayList<PVector> testrun2 = new ArrayList<PVector>();
  float x0 = random(-10,10);
  float y0 = random(-10,10);
  float z0 = random(-10,10);
  
  float x1 = x0 + random(-0.5,0.5);
  float y1 = y0 + random(-0.5,0.5);
  float z1 = z0 + random(-0.5,0.5);
  
  for(int l = 0; l<iterations; l++){
    testrun.add(new PVector(x0,y0,z0));
    x0 = iterate(x0,y0,z0,c)[0];
    y0 = iterate(x0,y0,z0,c)[1];
    z0 = iterate(x0,y0,z0,c)[2];
    testrun2.add(new PVector(x1,y1,z1));
    x1 = iterate(x1,y1,z1,c)[0];
    y1 = iterate(x1,y1,z1,c)[1];
    z1 = iterate(x1,y1,z1,c)[2];
  }
  
  for(int k = 0; k<testrun.size();k++){
    
    if (testrun.get(k).mag()>maxvec){
      maxvec = testrun.get(k).mag(); 
    }
    else if (testrun2.get(k).mag()>maxvec){
      maxvec = testrun2.get(k).mag();
    }
    if(Double.isNaN(testrun.get(k).mag())|| Double.isNaN(testrun2.get(k).mag())){
      System.out.println("blowing up is boring");
      return false;
    }
  }
  if(maxvec> bounds){
    return false;
  }
  
  if(PVector.sub(testrun.get(testrun.size()-2),testrun.get(testrun.size()-1)).mag()<close
  || PVector.sub(testrun2.get(testrun2.size()-2),testrun2.get(testrun2.size()-1)).mag()<close){
    System.out.println("point attractors are boring");
    return false;
  }
  
  float finalclose = PVector.sub(testrun.get(testrun.size()-1),testrun2.get(testrun2.size()-1)).mag(); 
  if(finalclose<close){
    System.out.println("orbits are boring");
    return false;
  }
}
  
  
  return true;
}

//actually draw the strange attractor
void draw()
{
  background(0);
  //translate(width/2,height/2,0);
 
  //calculate the stepwise differential equations
  
  for(int i = 0;i<colors.length;i++){
  points[i].add(new PVector(xi[i],yi[i],zi[i]));
  System.out.println(Float.toString(new PVector(xi[i],yi[i],zi[i]).mag()));
  stroke(colors[i]);
  noFill();
  beginShape();
  for(PVector v: points[i]){
  vertex(v.x*10,v.y*10,v.z*10);
  }
  endShape();
  
  xi[i] = iterate(xi[i],yi[i],zi[i],c)[0];
  yi[i] = iterate(xi[i],yi[i],zi[i],c)[1];
  zi[i] = iterate(xi[i],yi[i],zi[i],c)[2];
  
  //xdiff[i] = (c[0]*xi[i]+c[1]*yi[i]+c[2]*zi[i]
  //+c[3]*xi[i]*xi[i]+c[4]*yi[i]*yi[i]+c[5]*zi[i]*zi[i]
  //+c[6]*xi[i]*yi[i]+c[7]*xi[i]*zi[i]+c[8]*yi[i]*zi[i])*dt;
  
  //ydiff[i] = (c[9]*xi[i]+c[10]*yi[i]+c[11]*zi[i]
  //+c[12]*xi[i]*xi[i]+c[13]*yi[i]*yi[i]+c[14]*zi[i]*zi[i]
  //+c[15]*xi[i]*yi[i]+c[16]*xi[i]*zi[i]+c[17]*yi[i]*zi[i])*dt;
  
  //zdiff[i] = (c[18]*xi[i]+c[19]*yi[i]+c[20]*zi[i]
  //+c[21]*xi[i]*xi[i]+c[22]*yi[i]*yi[i]+c[23]*zi[i]*zi[i]
  //+c[24]*xi[i]*yi[i]+c[25]*xi[i]*zi[i]+c[26]*yi[i]*zi[i])*dt;
  
  //xi[i] += xdiff[i];
  //yi[i]+= ydiff[i];
  //zi[i]+= zdiff[i];
  }
}
