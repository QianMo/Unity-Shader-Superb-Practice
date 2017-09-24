//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/02-Adjust Color"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		float4 _Color;
		struct Input 
		{
			float4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = _Color;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
