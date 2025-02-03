shader_type spatial;

uniform float wave_speed : hint_range(0, 10) = 1.0;
uniform float wave_amplitude : hint_range(0, 1) = 0.1;
uniform float wave_frequency : hint_range(0, 10) = 2.0;

void fragment() {
    vec2 wave_uv = UV + vec2(0.0, TIME * wave_speed);
    float wave = sin(wave_uv.x * wave_frequency) * cos(wave_uv.y * wave_frequency);
    ALBEDO = vec3(0.2, 0.5, 0.7); // Warna air
    ALPHA = 0.6; // Transparansi
    NORMAL = vec3(0.0, 0.0, 1.0 + wave * wave_amplitude); // Distorsi permukaan
}
