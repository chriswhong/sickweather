// TrailSystem.pde
// (c) 2012 David Troy (@davetroy)
//
// TrailSystem is a wrapper for a Hashtable that tracks trails for individual objects
// in this case, the keys are screenNames associated with tweets. We keep all of the
// active trails in the TrailSystem. When a trail finally fades out and dies, we remove
// it from the system. The system is also responsible for rotating through our color palette.
// (Two palettes provided, courtesy of Friends of the Web, Baltimore -- one dark, one light --
// note that hex colors are provided in 32-bit alpha+rgb order format.)

class TrailSystem {
  Hashtable trails;
  PFont labelFont;

  color[] colors;
  int colorIndex;

  TrailSystem() {


    trails = new Hashtable();
    labelFont = createFont("Helvetica", 12);
  
  }



  Trail findOrCreateTrail(String ailment) {
    Trail trail = (Trail)trails.get(ailment);
    if (trail == null) {
      trail = new Trail();
      trails.put(ailment, trail);
    }
    return trail;
  }





  void addTweets(ArrayList<Tweet> tweets) { 
    
    Iterator<Tweet> it = tweets.iterator();
    while (it.hasNext ()) {
      Tweet t = it.next();
      Trail trail = findOrCreateTrail(t.ailment);
      trail.add(t);
    }
  }

  int size() {
    return trails.size();
  }

  void draw() {

    if (trailSystem.size()==0)
      exit();


    Iterator<Trail> it = trails.values().iterator();
    while (it.hasNext ()) {
      Trail tr = it.next();
      
        tr.drawPoints();
      

     
      if ((tr.points.size()>1) && (tr.i>(tr.points.size()+2))) {
        //it.remove();
        tr.lifespan *= 0.90;
      }
      // remove the trail from the system if it is dead
      if (tr.isDead()) {
        textFont(legendFont);
        //text("DEAD", 3 break;00, 300);
        it.remove();
      }
    }
  }
}

