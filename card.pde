class Card {
  int x;
  int y;
  boolean isFlipped;
  PImage pimg = null;
  boolean found;
  
  int r = 127;
  int b = 127;
  
  public void show(int w, int h){
   if(this.found){
      return;
   }
   else if(this.isFlipped){
     image(this.pimg,this.x,this.y,width/w,height/h);
   } else {
     fill(r,127,b); 
     rect(this.x,this.y,width/w,height/h);
   }
  }
  
  public void flip(){  
   if (this.isFlipped){
    this.isFlipped = false;
   } else {
    this.isFlipped = true; 
   }
   
  }
  
  Card(int w,int h){
    this.x = w;
    this.y = h;
  }
}
