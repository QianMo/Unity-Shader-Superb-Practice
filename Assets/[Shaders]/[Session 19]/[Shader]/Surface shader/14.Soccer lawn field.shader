//A soccer lawn field made with a texture

Shader "ShaderSuperb/Session19/Surface shader/SoccerLawnField" {
    Properties {
      _MainTex ("Texture", 2D) = "white" {}
      _BumpMap ("Bumpmap", 2D) = "bump" {}
	  _ColorMain ("Main color", Color) = (1, 1, 1, 1)
	  _ColorSec ("Secondary color", Color) = (1, 1, 1, 1)
	  _Width ("Width", float) = 10
	  _Offset ("Offset", float) = 0
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert

      struct Input {
        float2 uv_MainTex;
        float2 uv_BumpMap;
		float3 modelPos;
      };

      sampler2D _MainTex;
      sampler2D _BumpMap;
	  fixed4 _ColorSec;
	  fixed4 _ColorMain;
	  fixed _Width;
	  fixed _Offset;

	  void vert(inout appdata_full v, out Input o) {
		UNITY_INITIALIZE_OUTPUT(Input, o);
		o.modelPos = v.vertex;
	  }

      void surf (Input IN, inout SurfaceOutput o) {

		fixed val = ceil(frac(floor((IN.modelPos.x - _Offset) / _Width)/ 2));
		fixed3 col1 = tex2D(_MainTex, IN.uv_MainTex).rgb;
        o.Albedo = lerp(col1 * _ColorMain, col1 * _ColorSec, val);
		o.Alpha = 1;
        o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
      }

      ENDCG
    } 
    Fallback "Diffuse"
  }