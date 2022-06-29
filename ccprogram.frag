#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_uv;

uniform float u_time;

uniform sampler2D mainTexture;
uniform sampler2D noiseTexture;
uniform sampler2D maskTexture;

const vec4 v_mainTilingOffset = vec4(1, 1, 0, 0);
const vec4 v_maskTilingOffset = vec4(1, 1, 0, 0);
const vec4 v_noiseTilingOffset = vec4(1, 1, 0, 0);
const vec4 tintColor = vec4(1, 0, 0, 1);
const vec4 magicVec3 = vec4(0.300000012, 0.589999974, 0.109999999, 1);
const float mainPannerX = 1.0;
const float mainPannerY = 0.0;
const float intensity = 10.0;
const float noiseIntensity = 1.1;
const float noisePannerX = -0.1;
const float noisePannerY = 0.0;
const float maskPannerX = 1.0;
const float maskPannerY = 0.0;

vec4 frag() {

  float mainX = mainPannerX == 0.0 ? 0.0 : mod(u_time, mainPannerX) / mainPannerX;
  float mainY = mainPannerY == 0.0 ? 0.0 : mod(u_time, mainPannerY) / mainPannerY;
  float noiseX = noisePannerX == 0.0 ? 0.0 : mod(u_time, noisePannerX) / noisePannerX;
  float noiseY = noisePannerY == 0.0 ? 0.0 : mod(u_time, noisePannerY) / noisePannerY;
  float maskX = maskPannerX == 0.0 ? 0.0 : mod(u_time, maskPannerX) / maskPannerX;
  float maskY = maskPannerY == 0.0 ? 0.0 : mod(u_time, maskPannerY) / maskPannerY;

  vec4 image = texture2D(mainTexture, v_uv + vec2(mainX, mainY));
  vec4 noise = texture2D(noiseTexture, v_uv + vec2(noiseX, noiseY));
  vec4 mask = texture2D(maskTexture, v_uv + vec2(maskX, maskY));

  image.rgb *= image.rgb * noise.rgb * tintColor.rgb * vec3(intensity, intensity, intensity);

  image.a *= noise.a * mask.r;

  return image;

  // vec2 maskPan = vec2(u_time, u_time) * vec2(maskPannerX, maskPannerY) + v_uv;
  // maskPan = maskPan.xy * v_maskTilingOffset.xy + v_maskTilingOffset.zw;
  // maskPan = mod(maskPan, 1.0);
  // vec4 mask = texture2D(maskTexture, maskPan);

  // vec2 noisePan = vec2(u_time, u_time) * vec2(noisePannerX, noisePannerY) + v_uv;
  // noisePan = noisePan.xy * v_noiseTilingOffset.xy + v_noiseTilingOffset.zw;
  // noisePan = mod(noisePan, 1.0);
  // vec4 noise = texture2D(noiseTexture, noisePan);

  // float u_xlat6 = v_uv.y * noiseIntensity;
  // float mainX = dot(noise.rgb, magicVec3.xyz);
  // vec2 mainPan = vec2(mainX, mainX) * vec2(u_xlat6, u_xlat6) + v_uv;
  // mainPan += vec2(u_time, u_time) * vec2(mainPannerX, mainPannerY);
  // mainPan = mainPan.xy * v_mainTilingOffset.xy + v_mainTilingOffset.zw;

  // mainPan = mod(mainPan, 1.0);
  // vec4 img = texture2D(mainTexture, mainPan);

  // float u_xlat2x = dot(mask.rgb, magicVec3.xyz);
  // u_xlat2x = mask.a * u_xlat2x;
  // float u_xlat4x = img.a * tintColor.a;
  // u_xlat4x *= u_xlat2x;

  // float u_xlat0_d = tintColor.a + tintColor.a;
  // u_xlat0_d -= 1.0;
  // u_xlat0_d = clamp(u_xlat0_d, 0.0, 1.0);
  // u_xlat0_d = img.a * u_xlat0_d;

  // u_xlat0_d = ((u_xlat0_d * u_xlat2x) + (-u_xlat4x));
  // u_xlat0_d = u_xlat0_d + u_xlat4x;

  // img.rgb *= tintColor.rgb;
  // img.rgb *= vec3(intensity, intensity, intensity);
  // img.rgb *= vec3(u_xlat0_d, u_xlat0_d, u_xlat0_d);
  // // img.a *= noise.a * mask.r;

  // return img;
}

void main() {
  gl_FragColor = frag();
}