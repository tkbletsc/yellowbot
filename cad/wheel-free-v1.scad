$fn=64; 
E=0.02;

wheel_od = 85;
wheel_width = 8;
sprocket_teeth = 64;
shaft_dia = 6 * 1.05;
shaft_flat = 5.5 * 1.05;
flat_portion = 10;

module shaft_form(d,flat) {
    difference() {
        circle(d=d);
        translate([-d,flat-d/2]) square([d*2,d]);
    }
}

difference() {
    union() {
        cylinder(d=wheel_od,h=wheel_width);

        color([0,1,1,0.5]) translate([0,0,8]) {
            gt2_sprocket(sprocket_teeth,7);
            d1 = 36/60 * sprocket_teeth; // experimentally derived due to laziness
            translate([0,0,7-0.6]) cylinder(d1=d1,d2=d1+4,h=1.6);
        }
    }
    translate([0,0,-E]) linear_extrude(flat_portion+2*E) shaft_form(shaft_dia,shaft_flat);
    translate([0,0,flat_portion]) cylinder(d=shaft_dia, h=20);
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


