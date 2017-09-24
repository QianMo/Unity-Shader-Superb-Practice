//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/08-Cubemap Reflection"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_Cube ("Cubemap", CUBE) = "" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		samplerCUBE _Cube;


		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float3 worldRefl;
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Emission = texCUBE (_Cube, IN.worldRefl).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
