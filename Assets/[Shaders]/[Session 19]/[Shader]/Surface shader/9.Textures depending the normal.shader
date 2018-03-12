// The texture changes with the orientation of a face.


Shader "ShaderSuperb/Session19/Surface shader/TextureDependingNormal"
{
	Properties
	{
		_FloorTex ("Floor Texture", 2D) = "white" {}
		_WallTex ("Wall Texture", 2D) = "white" {}
		_CeilTex ("Ceil Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }


		CGPROGRAM
		#pragma surface surf Standard

		struct Input {
			float3 worldNormal;
			float2 uv_FloorTex;
			float2 uv_WallTex;
			float2 uv_CeilTex;
		};

		sampler2D _FloorTex;
		sampler2D _WallTex;
		sampler2D _CeilTex;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			// Floor
			if(IN.worldNormal.y > 0.9)
			{
				o.Albedo = tex2D(_FloorTex, IN.uv_FloorTex).rgb;
			}
			// Ceil	
			else if(IN.worldNormal.y < -0.9)
			{
				o.Albedo = tex2D(_CeilTex, IN.uv_CeilTex).rgb;
			}
			// Wall
			else
			{
				o.Albedo = tex2D(_WallTex, IN.uv_WallTex).rgb;
			}
			o.Emission = half3(1, 1, 1) * o.Albedo;
			o.Metallic = 0.0;
			o.Smoothness = 0.5;
		}

		ENDCG
	}
}