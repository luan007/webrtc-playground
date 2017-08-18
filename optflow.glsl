// file="index.html"

uniform float iGlobalTime;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec2 iResolution;
varying vec2 vUv;
vec2 scale = vec2(1.0, 1.0);
uniform float offsetX;
uniform float lambda;
void main() {
    vec2 fragCoord = vUv.xy * iResolution.xy;
	vec2 uv = vUv.xy;
	vec4 a = texture2D(iChannel0, uv);
	vec4 b = texture2D(iChannel1, uv);
	vec2 offset = offsetX / iResolution.xy;
	vec2 x1 = vec2(offset.x, 0.0);
	vec2 y1 = vec2(0.0, offset.y);
	vec4 curdif = b - a;
	vec4 gradx = texture2D(iChannel0, uv + x1) - texture2D(iChannel0, uv - x1);
	gradx += texture2D(iChannel1, uv + x1) - texture2D(iChannel1, uv - x1);
	vec4 grady = texture2D(iChannel0, uv + y1) - texture2D(iChannel0, uv - y1);
	grady += texture2D(iChannel1, uv + y1) - texture2D(iChannel1, uv - y1);
	vec4 gradmag = sqrt((gradx * gradx) + (grady * grady) + vec4(lambda));
	vec4 vx = curdif * (gradx / gradmag);
	float vxd = vx.r;
	vec2 xout = vec2(max(vxd, 0.0), abs(min(vxd, 0.0))) * scale.x;
	vec4 vy = curdif * (grady / gradmag);
	float vyd = vy.r;
	vec2 yout = vec2(max(vyd, 0.0), abs(min(vyd, 0.0))) * scale.y;
	gl_FragColor = clamp(vec4(xout.xy, yout.xy), 0.0, 1.0);
	gl_FragColor.a = 1.0;
}