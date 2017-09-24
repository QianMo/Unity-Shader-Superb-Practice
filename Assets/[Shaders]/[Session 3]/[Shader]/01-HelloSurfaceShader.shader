//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/01-HelloSurfaceShader"
{
	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input 
		{
			float4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
