//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/16-Decals"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry+1" "ForceNoShadowCasting"="True" }
		LOD 200
		Offset -1, -1

		CGPROGRAM
		#pragma surface surf Lambert decal:blend

		sampler2D _MainTex;

		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
