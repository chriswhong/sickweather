// Trail.pde
// (c) 2012 David Troy (@davetroy)
//
// wrapper for an ArrayList of points that contains individual tweets
// trails belong to a TrailSystem (like a particle belongs to a ParticleSystem)
// a trail starts out with a lifespan (and opacity) of 255.0 and then decays down to 0
// when it reaches 0, it is considered dead and is removed from the trailsystem.
// Every time a new point is added to the trail its lifespan is (arbitrarily) renewed to 255.0.

public class Trail {

  PVector velocity;

  ArrayList<Tweet> points;
  color trailColor;
  float lifespan;
  //lifespan for mid-trail tweets
  float lifespan2;
  Tweet t = null;
  PVector loc = null;
  PVector loc2 = null;
  PVector loc3 = null;
  int nexttweettime;
  int firsttweettime;
  int timediff;
  int isnew;
  int i=0;

  Trail(color col) {
    points = new ArrayList<Tweet>();
    trailColor = col; //color(random(255),random(255),random(255));
    lifespan = 255.0;
  }

  void add(Tweet t) {
    points.add(t);
    lifespan = 255.0;
  }

  void drawPoints() {

    noStroke();
    
    //fill(#9BFFFF, 255);
    Iterator<Tweet> it = points.iterator();
    while (it.hasNext ()) {
      t = it.next();
      loc = t.screenLocation();
      fill(#9BFFFF, t.lifespan);
      //ellipse(loc.x, loc.y, 3, 3);
      textFont(legendFont3);
      //text(t.lifespan, loc.x,loc.y);
      if(t.lifespan==255){
        apply_heat(int(loc.x), int(loc.y), 8, 5);
      
      }
      t.lifespan =0;
      //t.lifespan *=.90;
      
    }
    lifespan *= 0.99;
  }



  void update() {
   
   timediff=nexttweettime-currentTime;
   if (i>=(points.size()-1)) {
      velocity = new PVector(0,0);
    }
   else {
   
   velocity = new PVector((loc2.x-loc.x)/(timediff/66.666666666), (loc2.y-loc.y)/(timediff/66.66666666));
   
   }
    loc.add(velocity);
  }





  void firstdraw() {

    t = points.get(i);


    loc = t.screenLocation();
    loc3 = t.screenLocation();
    lifespan2 = 255;
    firsttweettime = t.timestamp;

    t = points.get(i+1);
    loc2=t.screenLocation();
    nexttweettime = t.timestamp;

    timediff=nexttweettime-firsttweettime;
    //velocity = new PVector((loc2.x-loc.x)/(timediff/66.66),(loc2.y-loc.y)/(timediff/66.66));
    //velocity = new PVector(0,0);
    velocity = new PVector((loc2.x-loc.x)/(timediff/66.666), (loc2.y-loc.y)/(timediff/66.666));
    isnew=1;
    //text("firstdraw ran!",40,550);
  }


  void changevector() {
    i++;
    if (i>=(points.size()-1)) {
   
    }
   else {
     
    
     
     
      t = points.get(i);


      loc = t.screenLocation();
      loc3 = t.screenLocation();
      lifespan2=255;
      firsttweettime = t.timestamp;



      t = points.get(i+1);
      loc2=t.screenLocation();
      nexttweettime = t.timestamp;

      timediff=nexttweettime-firsttweettime;
      //velocity = new PVector((loc2.x-loc.x)/(timediff/66.66),(loc2.y-loc.y)/(timediff/66.66));
      //velocity = new PVector(0,0);
      velocity = new PVector((loc2.x-loc.x)/(timediff/66.666666666), (loc2.y-loc.y)/(timediff/66.66666666));
   // }
  }
}
  void draw() {

   
    if(lifespan2>10){
      lifespan2-=10;
    }
    else{
      lifespan2=0;
    }   
    //sets a minimum speed to display... no slow-movers!
   // if(velocity.x+velocity.y<.75)
    //  lifespan=1;
   // else{
   //   lifespan=255;
   //   }
    
   
    stroke(#FFFF00, lifespan);
    fill(#FFFF00, lifespan);
    ellipse(loc.x, loc.y, 2, 2);
    //ellipse(loc2.x,loc2.y,3,3);
    stroke(#9BFFFF, lifespan2);
   fill(#9BFFFF, lifespan2);
    ellipse(loc3.x,loc3.y,6,6);


    t = points.get(0);
    textFont(legendFont3);
    // text(loc.x + "," +loc.y, loc.x,loc.y);
    //text(loc2.x + "," + loc2.y, loc2.x,loc2.y);
    //text(nexttweettime + " " + i + " " + points.size(),loc.x+10,loc.y+10);
     //fill(#9BFFFF, 255);
     //stroke(#9BFFFF, 255);
   // text(t.screenName,loc.x-1, loc.y-2);
   
    //text(velocity.x,loc.x-1, loc.y-2);
   


    //drawPoints();

    //if (points.size()>1)
    //drawCurve();

    //lifespan *= 0.85;

    // display screen_name at end of trail
    //fill(200, t.lifespan/2.0);
    //text(t.screenName,loc.x-1, loc.y-2);
  }

  boolean isDead() {

    return (points.size()==0 || lifespan<1.0);
  }
}

