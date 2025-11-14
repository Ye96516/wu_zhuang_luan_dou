shader_type canvas_item;

// Uniforms
uniform float angle;
//1：1
uniform sampler2D texture_1;
uniform sampler2D texture_2;

uniform float line_distance;
uniform float texture_distance;
uniform float texture_width;
uniform float scroll_speed;
uniform vec4 solid_color:source_color;
uniform vec2 screen_size;

void fragment() {
    float aspect_condition = step(screen_size.x, screen_size.y); // screen_size.x <= screen_size.y时为1.0
    float multi_width_x = mix(screen_size.y / screen_size.x, 1.0, aspect_condition);
    float multi_width_y = mix(1.0, screen_size.x / screen_size.y, aspect_condition);
    
    float uv_x = UV.x / multi_width_x;
    float uv_y = UV.y / multi_width_y;
    
    float real_uv_x = uv_x * cos(angle) + uv_y * sin(angle);
    float real_uv_y = -uv_x * sin(angle) + uv_y * cos(angle);
    
    vec2 real_uv = vec2(real_uv_x, real_uv_y);
    float line_index = floor(real_uv.y / (texture_width + line_distance));
    
    float line_local_y = fract(real_uv.y / (texture_width + line_distance));
    
    float texture_selector = mod(line_index, 2.0);
    float scroll_direction = (texture_selector < 0.5) ? 1.0 : -1.0;
    
    float horizontal_scroll = TIME * scroll_speed * scroll_direction;
    
    float local_x = fract(real_uv.x / (texture_width + texture_distance) + horizontal_scroll);

    vec2 processed_uv = vec2(local_x, line_local_y);

    vec2 texture_uv = processed_uv * vec2(
        (texture_distance + texture_width) / texture_width,
        (texture_width + line_distance) / texture_width
    );
    

    vec4 color;
    if(texture_uv.x > 1.0 || texture_uv.y > 1.0) {
        color = solid_color;
    } else if(texture_selector < 0.5) {
        color = texture(texture_1, texture_uv);
    } else {
        color = texture(texture_2, texture_uv);
    }

    COLOR = (color.a == 0.0) ? solid_color : color;
}