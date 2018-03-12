//To Simulate snow on a model only with a white color.


Shader "ShaderSuperb/Session19/Surface shader/SnowEffect" {
	Properties {
		_SnowColor ("Snow color", Color) = (1, 1, 1, 1)
		_MainTex ("MainTexture", 2D) = "white" {}
		_Bump ("BumpTex", 2D) = "bump" {}
		_SnowDirection ("Snow direction", Vector) = (0, 1, 0)
		_SnowLevel ("Amount of Snow", Range(1, -1)) = 0
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		half4 _SnowColor;
		sampler2D _MainTex;
		sampler2D _Bump;
		half3 _SnowDirection;
		fixed _SnowLevel;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal (tex2D(_Bump, IN.uv_Bump));
			if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection) >= _SnowLevel)
			{
				o.Albedo = _SnowColor.rgb;
			}
			else
			{
				o.Albedo = tex.rgb;
			}
		}
		ENDCG
	}
}