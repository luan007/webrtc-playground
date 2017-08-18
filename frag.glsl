// file="index.html"
uniform float iGlobalTime;
uniform sampler2D iChannel0;
uniform vec2 iResolution;
varying vec2 vUv;
const float t = 0.1;
uniform float ax[16];
uniform float ay[16];


//const float[] ax = float[] (0.0,   1.0,  2.0,  3.0, 3.0, 3.0, 2.0, 1.0, 0.0, -1.0, -2.0, -3.0, -3.0, -3.0, -2.0, -1.0);
//const float[] ay = float[] (-3.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 3.0,  3.0,  2.0,  1.0,  0.0, -1.0, -2.0, -3.0);

float gray(in vec4 color)
{
  return 0.299 * color.x + 0.587 * color.y + 0.114 * color.z;
}

float ggray(in vec2 fragCoord)
{
  vec4 cur = texture2D(iChannel0, fragCoord.xy / iResolution.xy);
  return gray(cur);
}

float corner(in vec2 fragCoord)
{
  float x = fragCoord.x;
  float y = fragCoord.y;

  float b = (ggray(vec2(x, y)) + ggray(vec2(1.0 + x, y)) + ggray(vec2(x - 1.0, y)) + ggray(vec2(x, y - 1.0)) + ggray(vec2(x, y + 1.0))) / 5.0;

  for (float i = 0.0; i < 16.0; i++)
  {
    bool darker = true;
    bool brighter = true;

    for (float j = 0.0; j < 10.0; j++)
    {
      float cx = ax[int(mod((i + j), 15.0))];
      float cy = ay[int(mod((i + j), 15.0))];

      vec4 n = texture2D(iChannel0, vec2(x + cx, y + cy) / iResolution.xy);
      float b2 = gray(n);
      if (b + t < b2)
      {
        brighter = false;
        if (darker == false)
        {
          break;
        }
      }

      if (b - t > b2)
      {
        darker = false;
        if (brighter == false)
        {
          break;
        }
      }
    }

    if (brighter || darker)
    {
      return 1.0;
    }
  }
  return 0.0;
}

void main(void)
{
  vec2 fragCoord = vUv.xy * iResolution.xy;
  float g = corner(fragCoord);
  // gl_FragColor = vec4(g, g, g, 1.0);
  gl_FragColor = texture2D(iChannel0, vUv.xy);
  
}
