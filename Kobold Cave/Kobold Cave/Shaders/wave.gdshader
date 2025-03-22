shader_type canvas_item;


uniform float amp = 1.0;
uniform float speed = 1.0;


float time_wave() {
	
	return sin( TIME * speed ) * amp;
}


void vertex() {
	
	switch( VERTEX_ID ) {
		
		case 0:
			
			VERTEX.y += time_wave();
			break;
		
		case 2:
		case 3:
			
			VERTEX.y -= time_wave();
			break;
		
	};
	
}

