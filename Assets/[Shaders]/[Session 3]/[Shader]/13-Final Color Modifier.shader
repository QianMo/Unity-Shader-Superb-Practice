//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/13-Final Color Modifier"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert finalcolor:mycolor

		sampler2D _MainTex;
		fixed4 _ColorTint;

		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float3 customColor;
		};

		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
		{
			color *= _ColorTint;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
