// turns the screen black and white to test color blind accessibility
// if the game cannot be played in black and white, something needs to change!
shader_type canvas_item;


uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;


void fragment() {

	vec4 col = texture( screen_texture, SCREEN_UV );

	float total = ( col.r + col.g + col.b ) / 3.0;
	col = vec4( total, total, total, col.a );

	COLOR = col;

}
