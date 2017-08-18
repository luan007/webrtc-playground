// file="index.html"

uniform float iGlobalTime;
uniform sampler2D iChannel0;
uniform vec2 iResolution;
varying vec2 vUv;
void main() {
	vec2 uv = vUv.xy;
	gl_FragColor = texture2D(iChannel0, uv);
}