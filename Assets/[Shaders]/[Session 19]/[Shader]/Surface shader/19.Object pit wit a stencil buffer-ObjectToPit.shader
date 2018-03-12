// The stencil buffer allows to make a part of the object invisible
// Mask :
// https://pastebin.com/7QNAmzAy
// Object to pit :
// https://pastebin.com/XvLSQXdG

Shader "ShaderSuperb/Session19/Surface shader/ObjectToPit" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		Stencil {
			Ref 1
			Comp NotEqual
			Pass keep
		}

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}