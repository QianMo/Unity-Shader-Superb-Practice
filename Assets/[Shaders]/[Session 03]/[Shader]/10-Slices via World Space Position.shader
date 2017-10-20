//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/10-Slices via World Space Position"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			clip (frac((IN.worldPos.y+IN.worldPos.z*0.1) * 5) - 0.5);
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
		}

		ENDCG
	}
	Fallback "Diffuse"
}
