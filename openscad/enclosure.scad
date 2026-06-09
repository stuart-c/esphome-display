// =========================================================================
// Parametric Enclosure for 3.5" LCD Display ESP32-S3 (ESP32-3248S035C style, 101.5 x 54.5 mm)
// Designed for 3D printing (PLA, 0.4mm nozzle, 0.2mm layer height)
// =========================================================================

// --- Rendering Modes ---
// 0 = Print Layout (both parts side-by-side, oriented for printing)
// 1 = Front Cover only (oriented for printing: front face down)
// 2 = Rear Cover only (oriented for printing: back face down)
// 3 = Assembled/Exploded Preview (3D visualization with translucent case)
// 4 = Front Cover only (assembled orientation: front face up, for preview)
// 5 = Rear Cover only (outside orientation: back face up, for preview)
part_to_render = 3;

// --- Resolution ---
$fn = 64; // High resolution for smooth curves

// --- Board Physical Dimensions (from drawings) ---
pcb_w = 101.50; // PCB width (X)
pcb_h = 54.50;  // PCB height (Y)
pcb_t = 1.60;   // PCB thickness (Z)

// PCB corner radius
pcb_corner_r = 3.50;

// Mounting Hole coordinates (relative to PCB bottom-left corner at [0,0])
hole_offset_x = 3.50;
hole_offset_y = 3.30;
hole_pos = [
    [hole_offset_x, hole_offset_y],                       // Bottom-Left
    [pcb_w - hole_offset_x, hole_offset_y],               // Bottom-Right
    [pcb_w - hole_offset_x, pcb_h - hole_offset_y],       // Top-Right
    [hole_offset_x, pcb_h - hole_offset_y]                // Top-Left
];

// Display Stack Dimensions
ctp_w = 83.00;  // Capacitive Touch Panel width (centered)
ctp_h = 49.96;  // Capacitive Touch Panel height (centered)
ctp_t = 1.00;   // Touch glass thickness
lcd_w = 83.00;  // LCD display backlight width
lcd_h = 54.50;  // LCD display backlight height (extends to top/bottom edges)
lcd_t = 2.20;   // LCD backlight thickness
glue_t = 0.50;  // Glue layer thickness

// The front face height of the display above the PCB surface:
// 0.50 (glue) + 2.20 (lcd) + 1.00 (ctp) = 3.70 mm
front_t = ctp_t + lcd_t + glue_t; // 3.70mm

// --- 3D Printing and Case Tolerances ---
clearance = 0.25;  // General mechanical clearance (0.25mm on all sides)
wall_t = 2.00;     // Main case wall thickness

// --- Internal Height / Standoffs ---
// Tallest back SMD component is 4.70mm. Standoff of 5.00mm provides 0.3mm clearance.
standoff_h = 5.00; 
standoff_od = 8.00; // Standoff outer diameter
standoff_id = 3.40; // Internal hole (3.4mm clearance for M3 screw)

// --- Fasteners (Low-profile M3 Bolt & Nut) ---
screw_hole_d = 3.40;   // Clearance hole for M3 screw thread
screw_head_d = 6.30;   // Recess diameter for low-profile M3 head (6.0mm + 0.3mm tolerance)
screw_head_h = 1.20;   // Recess depth (1.0mm head + 0.2mm tolerance)
nut_width = 5.75;      // Hex nut flat-to-flat width (5.5mm + 0.25mm tolerance)
nut_pocket_depth = 4.0; // Hex recess depth (nut is 2.4mm thick, allows screw protrusion)

// --- Connectors & Component cutouts (Relative to PCB bottom-left [0,0]) ---
// USB-C (left edge, Y-centered)
usb_y = pcb_h / 2;     // 27.25
usb_w = 12.00;         // Width of slot (cable overmold clearance)
usb_h = 6.00;          // Height of slot

// Buttons (left area: RST at top, BOOT at bottom, facing the rear)
btn_x = 3.26;          // X position of button centers (3.26mm from left edge)
btn_rst_y = 40.98;     // RST button Y center
btn_boot_y = 13.55;    // BOOT button Y center
btn_rst_d = 2.00;      // RST pinhole diameter (on the back wall)
btn_boot_w = 6.00;     // BOOT button cutout width (along X)
btn_boot_h = 10.00;    // BOOT button cutout height (along Y)
btn_boot_r = 1.50;     // BOOT button cutout corner radius

// TF Card Slot (top edge)
tf_x = 46.67;          // X position of slot center
tf_w = 15.00;          // Card slot width
tf_h = 3.00;           // Card slot height

// RGB LED (back side, estimated position - editable)
rgb_led_x = 72.00;     
rgb_led_y = 6.50;      
rgb_led_hole_d = 1.20;       // RGB LED grill hole diameter
rgb_led_grid_spacing = 1.60; // RGB LED grill spacing

// Microphone (front side, top right)
mic_x = 97.06;
mic_y = 44.68;
mic_hole_d = 1.20;
mic_grid_spacing = 1.60;

// Alignment Lip between Front and Rear parts
lip_h = 1.50;          // Lip height
lip_w = 1.00;          // Lip thickness
lip_clearance = 0.20;  // 3D printing gap clearance

// Explosion distance for assembled preview (mode 3)
// Set to 0 for a fully closed/assembled view, or >0 (e.g., 20) for an exploded view.
preview_explosion = 20;

// Calculated Enclosure Dimensions
case_w = pcb_w + 2 * clearance + 2 * wall_t; // Outer width: 106.00mm
case_h = pcb_h + 2 * clearance + 2 * wall_t; // Outer height: 59.00mm
outer_corner_r = pcb_corner_r + clearance + wall_t; // Outer corner radius: 5.75mm
inner_corner_r = pcb_corner_r + clearance;          // Inner cavity corner radius: 3.75mm

// =========================================================================
// Helper Modules
// =========================================================================

// 2D Rounded Rectangle (used for linear extruding to avoid minkowski performance hit)
module rounded_rect(w, h, r) {
    hull() {
        translate([r, r]) circle(r=r);
        translate([w-r, r]) circle(r=r);
        translate([w-r, h-r]) circle(r=r);
        translate([r, h-r]) circle(r=r);
    }
}

// 3D Rounded Cube
module rounded_cube(w, h, d, r) {
    linear_extrude(height=d) {
        rounded_rect(w, h, r);
    }
}

// =========================================================================
// PCB and Component Mockup (for fit check and visualization)
// =========================================================================
module pcb_mockup() {
    // Green PCB Board
    color("ForestGreen") {
        difference() {
            rounded_cube(pcb_w, pcb_h, pcb_t, pcb_corner_r);
            // 4 corner holes
            for (p = hole_pos) {
                translate([p[0], p[1], -0.5]) 
                    cylinder(h=pcb_t + 1, d=3.2, $fn=32);
            }
        }
    }
    
    // LCD Backlight Frame (sits on PCB)
    color("Silver") {
        translate([9.25, 0, pcb_t]) 
            cube([lcd_w, lcd_h, lcd_t + glue_t]);
    }
    
    // CTP Touch Glass (sits on top of LCD, centered)
    color("Black", 0.7) {
        translate([pcb_w/2 - ctp_w/2, pcb_h/2 - ctp_h/2, pcb_t + lcd_t + glue_t]) 
            cube([ctp_w, ctp_h, ctp_t]);
    }
    
    // USB-C Connector (back side)
    color("DimGray") {
        translate([-1.5, usb_y - 4.5, -3.2]) 
            cube([7.5, 9.0, 3.2]);
    }
    
    // RST and BOOT tactile buttons (back side)
    color("DarkRed") {
        // RST Button
        translate([1.0, btn_rst_y - 2.0, -3.5]) 
            cube([4.0, 4.0, 3.5]);
        // BOOT Button
        translate([1.0, btn_boot_y - 2.0, -3.5]) 
            cube([4.0, 4.0, 3.5]);
    }
    
    // TF Card Slot (back side, top edge)
    color("Goldenrod") {
        translate([tf_x - 7.25, pcb_h - 14.0, -1.8]) 
            cube([14.5, 14.0, 1.8]);
    }
    
    // RGB LED (back side)
    color("Magenta") {
        translate([rgb_led_x - 1.6, rgb_led_y - 1.6, -1.0]) 
            cube([3.2, 3.2, 1.0]);
    }
}

// =========================================================================
// Front Cover Module
// =========================================================================
module front_cover() {
    difference() {
        // Main front plate outer body (Z: from pcb_t to pcb_t + front_t)
        translate([-clearance - wall_t, -clearance - wall_t, pcb_t])
            rounded_cube(case_w, case_h, front_t, outer_corner_r);

        // 1. Cutout for the touch screen glass (CTP)
        // Center-aligned. Goes all the way through the front cover.
        translate([pcb_w/2 - ctp_w/2 - clearance, pcb_h/2 - ctp_h/2 - clearance, pcb_t - 0.5])
            cube([ctp_w + 2*clearance, ctp_h + 2*clearance, front_t + 1]);

        // 2. Pocket on the inside for the LCD backlight
        // Recessed from the back of the cover. Thickness matches lcd_t + glue_t.
        translate([9.25 - clearance, -clearance - 0.1, pcb_t - 0.1])
            cube([lcd_w + 2*clearance, lcd_h + 2*clearance + 0.2, lcd_t + glue_t + 0.1]);

        // 3. Counterbored Screw Holes (front face has low-profile recess)
        for (p = hole_pos) {
            // Thread clearance hole (3.4mm) through the entire cover thickness
            translate([p[0], p[1], pcb_t - 0.5])
                cylinder(h=front_t + 1, d=screw_hole_d, $fn=32);
            // Low profile head recess (6.3mm diameter, 1.2mm deep) on front surface
            translate([p[0], p[1], pcb_t + front_t - screw_head_h])
                cylinder(h=screw_head_h + 0.1, d=screw_head_d, $fn=32);
        }

        // 4. Microphone Grill & Pocket
        // Microphone internal pocket on back of cover to avoid crushing
        translate([mic_x, mic_y, pcb_t - 0.1])
            cylinder(h=2.0 + 0.1, d=4.5, $fn=32);
        // Grid of small sound transmission holes
        for (r = [-1 : 1]) {
            for (c = [-1 : 1]) {
                translate([mic_x + c * mic_grid_spacing, mic_y + r * mic_grid_spacing, pcb_t - 0.5])
                    cylinder(h=front_t + 1, d=mic_hole_d, $fn=16);
            }
        }

        // 5. Alignment Groove for Rear Cover Lip
        // We cut a groove matching the lip dimensions plus clearance
        // Groove coordinates are in the wall region, on the back face (Z = pcb_t)
        difference() {
            // Outer wall boundary of the groove (inside wall)
            translate([-clearance - lip_w - lip_clearance, -clearance - lip_w - lip_clearance, pcb_t - 0.1])
                rounded_cube(
                    pcb_w + 2*clearance + 2*lip_w + 2*lip_clearance, 
                    pcb_h + 2*clearance + 2*lip_w + 2*lip_clearance, 
                    lip_h + lip_clearance + 0.1, 
                    inner_corner_r + lip_w + lip_clearance
                );
            // Inner wall boundary of the groove
            translate([-clearance + lip_clearance, -clearance + lip_clearance, pcb_t - 0.2])
                rounded_cube(
                    pcb_w + 2*clearance - 2*lip_clearance, 
                    pcb_h + 2*clearance - 2*lip_clearance, 
                    lip_h + lip_clearance + 0.3, 
                    inner_corner_r - lip_clearance
                );
        }
    }
}

// =========================================================================
// Rear Cover Module
// =========================================================================
module rear_cover() {
    difference() {
        // Main tub outer shape and corner standoffs (merged)
        union() {
            // Main outer case box (Z: from -standoff_h - wall_t to pcb_t)
            translate([-clearance - wall_t, -clearance - wall_t, -standoff_h - wall_t])
                rounded_cube(case_w, case_h, standoff_h + wall_t + pcb_t, outer_corner_r);

            // Standoff pillars for mounting the PCB (height standoff_h)
            for (p = hole_pos) {
                translate([p[0], p[1], -standoff_h])
                    cylinder(h=standoff_h, d=standoff_od, $fn=32);
            }
            
            // Alignment Lip on top of the walls (starts at Z = pcb_t, height lip_h)
            difference() {
                // Outer edge of the lip
                translate([-clearance - lip_w, -clearance - lip_w, pcb_t])
                    rounded_cube(
                        pcb_w + 2*clearance + 2*lip_w, 
                        pcb_h + 2*clearance + 2*lip_w, 
                        lip_h, 
                        inner_corner_r + lip_w
                    );
                // Inner edge of the lip (lines up with internal cavity wall)
                translate([-clearance, -clearance, pcb_t - 0.1])
                    rounded_cube(
                        pcb_w + 2*clearance, 
                        pcb_h + 2*clearance, 
                        lip_h + 0.2, 
                        inner_corner_r
                    );
            }
        }

        // --- SUBTRACTIONS ---
        
        // 1. Internal Cavity for PCB and components
        // Width = pcb_w + 2*clearance, Height = pcb_h + 2*clearance. Depth starts at -standoff_h.
        translate([-clearance, -clearance, -standoff_h])
            rounded_cube(pcb_w + 2*clearance, pcb_h + 2*clearance, standoff_h + pcb_t + 0.1, inner_corner_r);

        // 2. Bolt holes and hexagonal nut recesses (Nut Traps)
        for (p = hole_pos) {
            // M3 screw clearance hole (diameter 3.4mm, goes completely through bottom)
            translate([p[0], p[1], -standoff_h - wall_t - 0.5])
                cylinder(h=standoff_h + wall_t + pcb_t + 1, d=screw_hole_d, $fn=32);
            
            // Hexagonal nut recess (flat-to-flat width, depth = nut_pocket_depth)
            // Standoff is at Z = -5.0, bottom wall starts at Z = -7.0
            // Recess goes from Z = -7.1 up to -7.1 + 4.0 = -3.1 (well into the standoff)
            translate([p[0], p[1], -standoff_h - wall_t - 0.1])
                rotate([0, 0, 30]) // Align flat faces of hex nut parallel to edges
                    cylinder(h=nut_pocket_depth + 0.1, d=nut_width / cos(30), $fn=6);
        }

        // 3. USB-C Port notch (left edge)
        // Sits on back of PCB (Z: from -3.2 to 0). Cutout is oversized for cable overmold.
        // Opens to the top (Z = pcb_t + lip_h) for easy slide-in assembly.
        translate([-clearance - wall_t - 0.5, usb_y - usb_w/2, -usb_h])
            cube([wall_t + 1.0, usb_w, usb_h + pcb_t + lip_h + 0.5]);

        // 4. RST Button pinhole (back face, bottom-left)
        // Small pinhole through the bottom wall for Reset access.
        translate([btn_x, btn_rst_y, -standoff_h - wall_t - 0.5])
            cylinder(h=wall_t + 1.0, d=btn_rst_d, $fn=16);
 
        // 5. BOOT Button finger cutout (back face, top-left)
        // Pill-shaped rounded rectangular cutout through the bottom wall for Boot button access.
        translate([btn_x - btn_boot_w/2, btn_boot_y - btn_boot_h/2, -standoff_h - wall_t - 0.5])
            rounded_cube(btn_boot_w, btn_boot_h, wall_t + 1.0, btn_boot_r);

        // 6. TF Card Slot notch (top edge)
        // Notch in top wall for card insertion/removal. Open to the top.
        translate([tf_x - tf_w/2, pcb_h + clearance - 0.5, -tf_h])
            cube([tf_w, wall_t + 1.0, tf_h + pcb_t + lip_h + 0.5]);

        // 7. RGB LED Viewport (back face cutout)
        // A grid of small light transmission holes through the bottom wall.
        for (r = [-1 : 1]) {
            for (c = [-1 : 1]) {
                translate([rgb_led_x + c * rgb_led_grid_spacing, rgb_led_y + r * rgb_led_grid_spacing, -standoff_h - wall_t - 0.5])
                    cylinder(h=wall_t + 1.0, d=rgb_led_hole_d, $fn=16);
            }
        }
    }
}

// =========================================================================
// Rendering Selection Logic
// =========================================================================

if (part_to_render == 0) {
    // Print Layout: Both parts side-by-side, oriented for optimal printing.
    // Front cover is printed face-down (Z-flipped, resting on its flat front face).
    // Rear cover is printed face-up (flat back face resting on the bed).
    
    // Front Cover (flipped: front surface Z = pcb_t + front_t becomes Z = 0)
    translate([0, 0, pcb_t + front_t])
        rotate([180, 0, 0])
            front_cover();
            
    // Rear Cover (shifted to the right, sitting flat on Z = 0)
    translate([case_w + 10, 0, standoff_h + wall_t])
        rear_cover();
}
else if (part_to_render == 1) {
    // Front Cover only, ready to print (face-down)
    translate([0, 0, pcb_t + front_t])
        rotate([180, 0, 0])
            color("DimGray", 0.6)
                front_cover();
}
else if (part_to_render == 2) {
    // Rear Cover only, ready to print (back-down)
    translate([0, 0, standoff_h + wall_t])
        color("DimGray", 0.6)
            rear_cover();
}
else if (part_to_render == 3) {
    // Assembled/Exploded Preview
    // Show green PCB and components (always at Z = 0)
    pcb_mockup();
    
    // Show rear cover (translucent gray) shifted downwards by the explosion distance
    translate([0, 0, -preview_explosion])
        color("DimGray", 0.6) 
            rear_cover();
        
    // Show front cover (semi-translucent light blue/gray) shifted upwards by the explosion distance
    translate([0, 0, preview_explosion])
        color("DimGray", 0.6) 
            front_cover();
}
else if (part_to_render == 4) {
    // Front Cover only, assembled orientation (front-up, for preview rendering)
    color("DimGray", 0.6)
        front_cover();
}
else if (part_to_render == 5) {
    // Rear Cover only, outside orientation (back-up, for preview rendering)
    translate([0, 0, -standoff_h - wall_t])
        rotate([180, 0, 0])
            color("DimGray", 0.6)
                rear_cover();
}
