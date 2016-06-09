import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

String studentDataFile = "Nation_And_Programx.csv"; 
ArrayList<Student> students = new ArrayList(); // create an array of objects
int maxStudents= 0;

UnfoldingMap currentMap;
UnfoldingMap map1;

SimplePointMarker berlinMarker;
 
void setup() {
    size(770, 700);
 
    map1 = new UnfoldingMap(this, new Google.GoogleMapProvider());
   
    MapUtils.createDefaultEventDispatcher(this, map1);
    map1.setTweening(true);
    /*Location berlinLocation = new Location(52.5, 13.4);
    berlinMarker = new SimplePointMarker(berlinLocation);*/
 
    currentMap = map1;
    
    Table studentDataCSV = loadTable(studentDataFile, "header, csv"); //creating a table loading data from csv
    for (TableRow studentRow : studentDataCSV.rows())
    {
      Student studentObj = new Student();
      
      //read data from CSV
      
    studentObj.CITZ_NATION = studentRow.getString("CITZ_NATION");
    //studentObj.PROGRAM = studentRow.getString("PROGRAM");
    studentObj.STUDENT_COUNT = studentRow.getInt("STUDENT_COUNT");
    float lat = studentRow.getFloat("LATITUDE");
    float lng = studentRow.getFloat("LONGITUDE");
    studentObj.location = new Location(lat, lng);
    
   
    // Add to list of all students
    students.add(studentObj);  
    
   println("Added " + studentObj.CITZ_NATION + " at" + studentObj.location); 
   maxStudents = max(maxStudents, studentObj.STUDENT_COUNT);
    }
    
   println("Loaded " + students.size() + "records. Max no. of students: " + maxStudents); 
    
}
 
void draw() {
    currentMap.draw();
    map1.setZoomRange(1, 5);
    
    noStroke();
    for(Student studentObj : students)
    {
      ScreenPosition pos = map1.getScreenPosition(studentObj.location);
      if (studentObj.STUDENT_COUNT<600)
      {
      float s = map(studentObj.STUDENT_COUNT, 0, maxStudents, 1, 7000);
      fill(234,106,32,230);
      ellipse(pos.x, pos.y, s, s);
      
      }
    else if (studentObj.STUDENT_COUNT>600 && studentObj.STUDENT_COUNT<3000)
   {
        fill(234,106,32,230);
     ellipse(pos.x, pos.y, 50, 50);
     }
       else if (studentObj.STUDENT_COUNT>3000)
      {
         fill(234,106,32,230);
      ellipse(pos.x, pos.y, 100, 100);
      }
      
      if (studentObj.showLabel) {
      fill(82,45,128);
      textSize(40);
      text(studentObj.STUDENT_COUNT, (pos.x) - textWidth(str(studentObj.STUDENT_COUNT))/2, (pos.y));
    }
      
    }
    
 
}


void mouseClicked() {
  // Simple way of displaying bike station names. Use markers for single station selection.
  for (Student studentObj : students) {
    studentObj.showLabel = false;
    ScreenPosition pos = map1.getScreenPosition(studentObj.location);
    if (dist(pos.x, pos.y, mouseX, mouseY) < 10) {
      studentObj.showLabel = true;
    }
  }
}

 

