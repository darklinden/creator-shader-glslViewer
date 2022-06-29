Shader "src"
{
  Properties
  {
    _MainTex ("MainTex", 2D) = "white" {}
    _TintColor ("Color", Color) = (1,1,1,1)
    _MainPannerX ("Main Panner X", float) = 0
    _MainPannerY ("Main Panner Y", float) = 0
    _Mask ("Mask", 2D) = "white" {}
    _MaskPannerX ("Mask Panner X", float) = 0
    _MaskPannerY ("Mask Panner Y", float) = 0
    _Thresold ("Thresold", Range(0, 2)) = 1
    _Intensity ("Intensity", float) = 1
    [MaterialToggle] _Smooth ("Smooth", float) = 1
    [MaterialToggle] _SmoothColor ("Smooth Color", float) = 0
    _Noise ("Noise", 2D) = "white" {}
    _NoiseIntensity ("Noise Intensity", float) = 0
    _NoisePannerX ("Noise Panner X", float) = 0
    _NoisePannerY ("Noise Panner Y", float) = 0
    [MaterialToggle] _CustomDissolve ("Custom Dissolve", float) = 0
    [MaterialToggle] _CustomUV ("Custom UV", float) = 0
    [MaterialToggle] _CustomMask ("Custom Mask", float) = 0
    [MaterialToggle] _ForceDissolve ("Force Dissolve", float) = 0
    [MaterialToggle] _ForceMask ("Force Mask", float) = 1
    _ForceMaskIntensity ("Force Mask Intensity", float) = 1
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "PreviewType" = "Plane"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "PreviewType" = "Plane"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
        "SHADOWSUPPORT" = "true"
      }
      ZWrite Off
      Cull Off
      Blend One One
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      //uniform float4 _Time;
      uniform float4 _MainTex_ST;
      uniform float4 _TintColor;
      uniform float4 _Mask_ST;
      uniform float _Thresold;
      uniform float _Intensity;
      uniform float4 _Noise_ST;
      uniform float _NoiseIntensity;
      uniform float _NoisePannerX;
      uniform float _NoisePannerY;
      uniform float _CustomDissolve;
      uniform float _CustomUV;
      uniform float _CustomMask;
      uniform float _ForceMask;
      uniform float _ForceMaskIntensity;
      uniform float _ForceDissolve;
      uniform float _SmoothColor;
      uniform float _MainPannerX;
      uniform float _MainPannerY;
      uniform float _MaskPannerX;
      uniform float _MaskPannerY;
      uniform sampler2D _Noise;
      uniform sampler2D _MainTex;
      uniform sampler2D _Mask;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float4 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.texcoord = in_v.texcoord;
          out_v.texcoord1 = in_v.texcoord1;
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float u_xlat0_d;
      float3 u_xlat1_d;
      float4 u_xlat10_1;
      float2 u_xlat2;
      float2 u_xlat4;
      float u_xlat6;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d = (in_f.texcoord1.x + (-in_f.color.w));
          u_xlat0_d = ((_CustomDissolve * u_xlat0_d) + in_f.color.w);
          u_xlat0_d = dot(_TintColor.ww, float2(u_xlat0_d, u_xlat0_d));
          u_xlat2.xy = ((float2(float2(_CustomMask, _CustomMask)) * in_f.texcoord1.zw) + in_f.texcoord.xy);
          u_xlat2.xy = ((_Time.yy * float2(_MaskPannerX, _MaskPannerY)) + u_xlat2.xy);
          u_xlat2.xy = TRANSFORM_TEX(u_xlat2.xy, _Mask);
          u_xlat10_1 = tex2D(_Mask, u_xlat2.xy);
          u_xlat2.x = dot(u_xlat10_1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat2.x = (u_xlat10_1.w * u_xlat2.x);
          u_xlat4.x = ((-_Thresold) + 1);
          u_xlat0_d = ((u_xlat2.x * u_xlat4.x) + u_xlat0_d);
          u_xlat0_d = (u_xlat0_d + (-1));
          u_xlat0_d = clamp(u_xlat0_d, 0, 1);
          u_xlat4.xy = ((_Time.yy * float2(_NoisePannerX, _NoisePannerY)) + in_f.texcoord.xy);
          u_xlat4.xy = TRANSFORM_TEX(u_xlat4.xy, _Noise);
          u_xlat10_1.xyz = tex2D(_Noise, u_xlat4.xy).xyz;
          u_xlat4.x = dot(u_xlat10_1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat1_d.xy = in_f.texcoord.zw;
          u_xlat1_d.xy = ((float2(float2(_CustomUV, _CustomUV)) * u_xlat1_d.xy) + in_f.texcoord.xy);
          u_xlat6 = (in_f.texcoord1.y * _NoiseIntensity);
          u_xlat4.xy = ((u_xlat4.xx * float2(u_xlat6, u_xlat6)) + u_xlat1_d.xy);
          u_xlat4.xy = ((_Time.yy * float2(_MainPannerX, _MainPannerY)) + u_xlat4.xy);
          u_xlat4.xy = TRANSFORM_TEX(u_xlat4.xy, _MainTex);
          u_xlat10_1 = tex2D(_MainTex, u_xlat4.xy);
          u_xlat0_d = ((u_xlat10_1.w * u_xlat0_d) + (-1));
          u_xlat0_d = ((_SmoothColor * u_xlat0_d) + 1);
          u_xlat4.x = (u_xlat10_1.w * _TintColor.w);
          u_xlat1_d.xyz = (u_xlat10_1.xyz * in_f.color.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * _TintColor.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * float3(float3(_Intensity, _Intensity, _Intensity)));
          u_xlat4.x = (u_xlat4.x * in_f.color.w);
          u_xlat4.x = (u_xlat2.x * u_xlat4.x);
          u_xlat2.x = ((u_xlat2.x * _ForceMaskIntensity) + (-1));
          u_xlat2.x = ((_ForceMask * u_xlat2.x) + 1);
          u_xlat0_d = ((u_xlat0_d * u_xlat2.x) + (-u_xlat4.x));
          u_xlat0_d = ((_ForceDissolve * u_xlat0_d) + u_xlat4.x);
          out_f.color.xyz = (float3(u_xlat0_d, u_xlat0_d, u_xlat0_d) * u_xlat1_d.xyz);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
