// PRUSA Mendel
// LM8UU-Bearing X-Carriage
// Used for sliding on X axis
// GNU GPL v2
// Simon Kühling <mail@simonkuehling.de>
// Derived from
//	- "Lm8uu X Carriage with Fan Mount for Prusa Mendel" by Greg Frost
//	  http://www.thingiverse.com/thing:9869
//	- "Slim LM8UU Holder Parametric" by Jonas Kühling
//	  http://www.thingiverse.com/thing:16158

// Gregs configuration file
include <configuration.scad>

include <lm8uu-holder-slim_V1-1.scad>

SupportThickness=4.9; 
ClampWidth = 12;
ClampSeporation = 40;
xWidth = 140;
yWidth = 100;
height = 14;

belt_width=7.25;
belt_thickness=1.5; 
tooth_height=1;

belt_clamp_thickness=3; 
belt_clamp_spacing=8; //16;	// The spacing between the belt clamps
belt_clamp_hole_separation=15;
belt_clamp_clamp_height=tooth_height+belt_clamp_thickness*2;


//m3_diameter = screw_thread_dia;
belt_clamp_length = belt_clamp_hole_separation + m3_diameter + 2 * belt_clamp_thickness;
belt_clamp_width = m3_diameter + 3 * belt_clamp_thickness + 2;
belt_clamp_height = m3_diameter + 2 * belt_clamp_thickness;

//// from lm8uu
//// LM8UU/rod dimensions
//LM8UU_dia = 16;
//LM8UU_length = 25.1;
//rod_dia = 8;
//
////screw/nut dimensions (M3) - hexagon socket head cap screw ISO 4762, hexagon nut ISO 4032
//screw_thread_dia_iso = 3.5;
//screw_head_dia_iso = 6.5;
//nut_wrench_size_iso = 5.5;
//
//
//// screw/nut dimensions for use (plus clearance for fitting purpose)
//clearance_dia = 0.5;
//screw_thread_dia = screw_thread_dia_iso + clearance_dia;
//screw_head_dia = screw_head_dia_iso + clearance_dia;
//nut_wrench_size = nut_wrench_size_iso + clearance_dia;
//nut_dia_perimeter = (nut_wrench_size/cos(30));
//nut_dia = nut_dia_perimeter;
//nut_surround_thickness = 2;
//
//// main body dimensions
//body_wall_thickness = 3;
//body_width = LM8UU_dia + (2*body_wall_thickness);
//body_height = body_width;
//body_length = LM8UU_length;
//gap_width = rod_dia + 2;
//screw_bushing_space = 1;
//screw_elevation = LM8UU_dia + body_wall_thickness + (screw_thread_dia/2) +screw_bushing_space;

main();

module main()
	{
	difference()
		{
		structure();
		holes();
		}
	}

module structure()
	{
	// LM8UU Holders
	for(i=[-1,1])
		{
		translate([i*((xWidth / 2) + (body_width / 2) - (SupportThickness / 2)), 0, (SupportThickness / 2)])
			cube([SupportThickness, yWidth + body_length, SupportThickness], center = true);

		translate([i*((xWidth / 2) - (body_width / 2) + (SupportThickness / 2)), 0, (SupportThickness / 2)])
			cube([SupportThickness, yWidth + body_length, SupportThickness], center = true);

		translate([0, i * 20, (SupportThickness / 2)])
			cube([2 * ((xWidth / 2) + (body_width / 2)/* + (SupportThickness / 2)*/), ClampWidth, SupportThickness], center = true);

		translate([i * (ClampSeporation / 2), 0, (SupportThickness / 2)])
			cube([ClampWidth, ClampSeporation, SupportThickness], center = true);

		translate([0, i * (ClampSeporation / 2), 0])
			rotate([0, 0, 180 * sign(i - 1)])
				belt_clamp_socket();

		translate([xWidth/2,i*(yWidth/2),0])
			rotate([0,0,180])
				lm8uu_holder();

		translate([-xWidth/2,i*(yWidth/2),0])
			lm8uu_holder();				
		
		translate([ClampSeporation, i * ClampSeporation, 0])
			belt_clamp();

		translate([-ClampSeporation, i * ClampSeporation, 0])
			belt_ram();
		}

	}

module holes()
	{
	for(i=[-1,1])
		{
		translate([0, i * ClampSeporation / 2, 0])
			rotate([0, 0, 180 * sign(i - 1)])
				belt_clamp_holes();
		translate([ClampSeporation, i * ClampSeporation / 2, 0])
			cylinder(r=m3_diameter/2,h=belt_clamp_height+2,center=true,$fn=8);
		translate([-ClampSeporation, i * ClampSeporation / 2, 0])
			cylinder(r=m3_diameter/2,h=belt_clamp_height+2,center=true,$fn=8);
		}
	}

module belt_clamp_holes()
{
	translate([0,0,belt_clamp_height/2])
	{
		for(i=[-1,1])
			translate([i*belt_clamp_hole_separation/2,0,0])
				{
				cylinder(r=m3_diameter/2,h=belt_clamp_height+2,center=true,$fn=8);
				translate([0,0,-belt_clamp_height/2])
					rotate([0,0,30])
						cylinder(r=nut_dia/2  ,h=3.4,$fn=6);
				}

		rotate([90,0,0])
		rotate(360/16)
		cylinder(r=m3_diameter/2  ,h=belt_clamp_width+2,center=true,$fn=8);

		rotate([90,0,0]) 
		translate([0,0,belt_clamp_width/2])
		cylinder(r=nut_dia/2  ,h=3.4, center=true,$fn=6);

	}
	translate([0,0,belt_thickness/2])
	cube([belt_width, belt_clamp_width + 2, belt_thickness], center=true);
}

module belt_clamp_socket()
	{
	difference()
		{
		translate([0, 0, belt_clamp_height / 2])
			union()
				{
				//translate([0, 0, -1])
				cube([belt_clamp_hole_separation, belt_clamp_width, belt_clamp_height], center=true);
				for(i = [-1, 1])
					translate([i * belt_clamp_hole_separation / 2, 0, 0])
						cylinder(r = belt_clamp_width/2, h = belt_clamp_height, center = true);
				for(i=[0:7])
					{
					translate([-belt_width / 2, (-belt_clamp_width / 2) + (2 * i), (belt_clamp_height - tooth_height) / 2])
						translate([0,.5,.5])		
							rotate(a=[0, 90, 0]) cylinder(r = .5, h = belt_width, $fn=20);
					}

				}
		belt_clamp_holes();
		for(i=[0:6])
			{
			translate([-belt_width / 2, (-belt_clamp_width / 2) + (2 * i), (belt_clamp_height) - tooth_height / 2])
				translate([0,1.5,.5])		
					rotate(a=[0, 90, 0]) cylinder(r = .5, h = belt_width, $fn=20);		
			}
		}
	}

module belt_clamp()
	{
	difference()
		{
		translate([0, 0, belt_clamp_clamp_height / 2])
			union()
				{
				cube([belt_clamp_hole_separation, belt_clamp_width, belt_clamp_clamp_height], center = true);
				for(i = [-1, 1])
					translate([i * belt_clamp_hole_separation / 2, 0, 0])
						cylinder(r = belt_clamp_width / 2, h = belt_clamp_clamp_height, center = true);
				}

		for(i=[-1, 1])
			translate([i * belt_clamp_hole_separation / 2, 0, -1])
				rotate(360 / 16)
					cylinder(r = m3_diameter / 2, h = belt_clamp_clamp_height + 2, $fn = 8);
		}
	}

module belt_ram()
	{
	difference()
		{
		union()
			{
			translate([0, -nut_wrench_size / 2, 0])
				cube([nut_wrench_size, nut_wrench_size, nut_wrench_size]);
			translate([0, 0, nut_wrench_size])
				rotate([0, 90, 0])
					cylinder(r = nut_wrench_size / 2, h = nut_wrench_size, $fn = 8);
			}
		translate([nut_wrench_size / 2, 0, 0])
			cylinder(r = screw_thread_dia / 2, h = nut_wrench_size, $fn = 8);
		}
	}