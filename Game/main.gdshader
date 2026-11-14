
shader_type sky;

// Star settings
uniform float star_density : hint_range(50.0, 500.0) = 250.0;
uniform float star_brightness : hint_range(0.1, 3.0) = 1.5;
uniform bool stars_flicker = true;
uniform float flicker_speed : hint_range(0.1, 5.0) = 1.5;

float rand(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void sky() {
    vec3 dir = normalize(EYEDIR);

    // Spherical sky coordinates
    vec2 uv = vec2(
        atan(dir.z, dir.x) / (2.0 * PI) + 0.5,
        asin(clamp(dir.y, -1.0, 1.0)) / PI + 0.5
    );

    // Black background
    vec3 sky_color = vec3(0.0);

    // Star grid
    vec2 grid = uv * star_density;
    vec2 cell = floor(grid);
    vec2 local = fract(grid);

    float random_value = rand(cell);

    // Random star placement
    if (random_value > 0.94) {
        vec2 star_position = vec2(
            rand(cell + 12.4),
            rand(cell + 45.6)
        );

        float dist = distance(local, star_position);

        float size = mix(0.015, 0.045, rand(cell + 78.9));

        float star = 1.0 - smoothstep(
            0.0,
            size,
            dist
        );

        // Twinkling
        float flicker = stars_flicker
            ? 0.65 + 0.35 * sin(
                TIME * flicker_speed * 2.0
                + random_value * 100.0
            )
            : 1.0;

        float brightness = mix(
            0.5,
            1.0,
            rand(cell + 99.1)
        );

        sky_color += vec3(
            star * flicker * brightness * star_brightness
        );
    }

    COLOR = sky_color;
}
