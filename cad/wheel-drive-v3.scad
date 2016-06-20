$fn=64; 
E=0.02;

wheel_od = 95;
wheel_width = 8;
wheel_side_radius = 2;
bearing_od = 22 * 1.05;
bearing_od_margin = 16; // diameter we can do a flange without hitting nuts
bearing_width = 7;
wheel_width = 8;
screw_dia = 3;
screw_head_dia = 6;
sprocket_teeth = 64;
sprocket_width = 7;
gap_width = 2;
screw_offset = 15;

part1=1;
part2=0;

module washer(od,id,h) {
    linear_extrude(h) difference() {
        circle(d=od);
        circle(d=id);
    }
}

if (part1) difference() {
    /*union() {
        h = wheel_width-bearing_width;
        translate([0,0,0]) washer(od=wheel_od,id=bearing_od_margin,h=h);
        translate([0,0,h]) washer(od=wheel_od,id=bearing_od,h=bearing_width);
    }*/
    union() {
        hull() translate([0,0,wheel_width/2]) rotate_extrude() 
        translate([wheel_od/2,0]) hull() {
            r = wheel_side_radius;
            w = wheel_width;
            translate([-r,-(w/2-r)]) circle(r=r);
            translate([-r,+(w/2-r)]) circle(r=r);
        }        
        
    }
    
    translate([0,0,-E]) 
        cylinder(d=bearing_od_margin,h=wheel_width-bearing_width+2*E);
    translate([0,0,wheel_width-bearing_width]) 
        cylinder(d=bearing_od,h=wheel_width);
    
    
    for (theta = [0:90:360-1]) {
        rotate([0,0,theta]) translate([screw_offset,0,-E]) cylinder(d=screw_dia,h=30,$fn=16);
    }
    
    // these holes are hackey and quick and don't follow the object parameters set at the top
    for (theta = [0:360/8:360-1]) {
        //rotate([0,0,theta]) translate([30,0,-E]) cylinder(d=15,h=20);
        rotate([0,0,theta]) translate([40,0,-E]) cube([25,15,40],center=true);
        //rotate([0,0,theta]) translate([12,0,-E]) cylinder(d=7,h=20);
    }


}    
//color([1,0,0,0.5]) translate([0,0,8]) washer(od=85,id=16,h=1);

if (part2) color([0,1,1,0.5]) translate([0,0,wheel_width]) {
    difference() {
        union() {
            flange_id = 36/60 * sprocket_teeth; // experimentally derived due to laziness
            flange_od = flange_id+4; // experimentally derived due to laziness
                            
            color([0,1,0,0.5]) cylinder(d=flange_od,h=gap_width); // gap
            
            translate([0,0,gap_width]) {
                cylinder(d1=flange_od,d2=flange_id,h=1.6);
                gt2_sprocket(sprocket_teeth,sprocket_width);
                translate([0,0,7-0.6]) cylinder(d1=flange_id,d2=flange_od,h=1.6);
            }
        }
        translate([0,0,-E]) cylinder(d=bearing_od_margin,h=20);
        for (theta = [0:90:360-1]) {
            rotate([0,0,theta]) translate([screw_offset,0,7-3]) cylinder(d=screw_head_dia,h=10,$fn=16);
            rotate([0,0,theta]) translate([screw_offset,0,-E]) cylinder(d=screw_dia,h=10,$fn=16);
        }

    }
}

module gt2_sprocket(number_of_teeth=36,height=7) {
    toothed_part_length = height;
    base_height=0;
    additional_tooth_width = 0.2; //mm
    additional_tooth_depth = 0; //mm
    tooth_width =  1.494 ;
    tooth_depth = 0.764;

    GT2_2mm_pulley_dia = tooth_spacing (2,0.254);
    pulley_OD = GT2_2mm_pulley_dia;


    function tooth_spaceing_curvefit (b,c,d)
        = ((c * pow(number_of_teeth,d)) / (b + pow(number_of_teeth,d))) * number_of_teeth ;

    function tooth_spacing(tooth_pitch,pitch_line_offset)
        = (2*((number_of_teeth*tooth_pitch)/(3.14159265*2)-pitch_line_offset)) ;


    tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
        tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
        tooth_depth_scale = ((tooth_depth + additional_tooth_depth ) / tooth_depth) ;


    difference() {
        //shaft - diameter is outside diameter of pulley
        
        translate([0,0,base_height]) 
        rotate ([0,0,360/(number_of_teeth*4)]) 
        cylinder(r=pulley_OD/2,h=toothed_part_length, $fn=number_of_teeth*4);

        //teeth - cut out of shaft

        for(i=[1:number_of_teeth]) 
        rotate([0,0,i*(360/number_of_teeth)])
        translate([0,-tooth_distance_from_centre,base_height -1]) 
        scale ([ tooth_width_scale , tooth_depth_scale , 1 ]) {
            GT2_2mm(toothed_part_length);
        }

    }
}

module GT2_2mm(h) {
	linear_extrude(height=h+2) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
}


