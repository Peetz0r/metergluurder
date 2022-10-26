$fn = 32;

pcb_width = 30.0;
pcb_length = 70.0;

pcb_hole_d = 2.0;
pcb_hole_offset = 1.5;
screw_length = 16;

sensor_length = 10.2;
sensor_width = 5.6;
sensor_x = 15.5;
sensor_y = 2.0;

usb_length = 12.0;
usb_height = 8.0;
usb_x = 47.0;
usb_z = 10.0;

serial_length = 14.4;
serial_height = 4.0;
serial_y = 3.3;
serial_z = 2.0;

inner_width = 37.0;
inner_length = 77.0;

height_below_pcb = 4.0;
height_above_pcb = 18.0;
height_pcb_thickness = 1.6;


w = 1.6;

inner_height = height_below_pcb + height_above_pcb + height_pcb_thickness;

pcb_offset_x = (inner_width -  pcb_width )/2;
pcb_offset_y = (inner_length - pcb_length)/2;

module case() {
    difference() {
        translate([-w, -w, -w]) {
            cube([inner_length + w*2, inner_width + w*2, inner_height + w]);
        }
        cube([inner_length, inner_width, inner_height]);
        translate([pcb_offset_x + sensor_x, pcb_offset_y + sensor_y, -w]) {
            cube([sensor_length, sensor_width, w]);
        }
        translate([pcb_offset_x + usb_x, inner_width, height_above_pcb - usb_z - usb_height]) {
            cube([usb_length, w, usb_height]);
        }
        translate([-w, inner_width - pcb_offset_y - serial_length - serial_y, 0]) {
            cube([w, serial_length, serial_height]);
        }
    }

    difference() {
        for(x=[pcb_offset_x + pcb_hole_offset + pcb_hole_d/2, inner_length - pcb_offset_x - pcb_hole_offset - pcb_hole_d/2]) {
            for(y=[pcb_offset_y + pcb_hole_offset + pcb_hole_d/2, inner_width - pcb_offset_y - pcb_hole_offset - pcb_hole_d/2]) {
                translate([x, y, 0]) difference() {
                    cylinder(d=(pcb_hole_d + 2*w), h=height_above_pcb);
                    translate([0, 0, height_above_pcb - screw_length])  #cylinder(d=pcb_hole_d, h=screw_length);
                }
            }
        }
        translate([0, inner_width - pcb_offset_y - serial_length - serial_y, 0]) {
            #cube([10, serial_length, serial_height]);
        }
    }
}

module lid() {
    difference() {
        union() {
            translate([-w, -w, -w/2]) cube([inner_length + w*2, inner_width + w*2, w/2]);
            cube([inner_length, inner_width, w/2]);            
        }
        translate([71, 16, -w/2]) mirror([1, 0, 0]) #linear_extrude(height = 0.2) text("metergluurder", font="Fira Code", size=6);

        for(x=[pcb_offset_x + pcb_hole_offset + pcb_hole_d/2, inner_length - pcb_offset_x - pcb_hole_offset - pcb_hole_d/2]) {
            for(y=[pcb_offset_y + pcb_hole_offset + pcb_hole_d/2, inner_width - pcb_offset_y - pcb_hole_offset - pcb_hole_d/2]) {
                translate([x, y, 0]) difference() {
                    translate([0, 0, -w])  #cylinder(d=pcb_hole_d*1.2, h=w*2);
                }
            }
        }
    }    
}

case();
translate([0, -60, 0]) lid();
//lid();