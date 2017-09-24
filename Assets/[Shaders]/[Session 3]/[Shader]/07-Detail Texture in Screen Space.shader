//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/07-Detail Texture in Screen Space"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_Detail ("Detail", 2D) = "gray" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Detail;


		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 uv_Detail;
			float4 screenPos;
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			if(IN.screenPos.w!=0)
			{
				float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
				screenUV *= float2(8,6);
				o.Albedo *= tex2D (_Detail, screenUV).rgb * 2;
			}
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
		}

		ENDCG
	}
	Fallback "Diffuse"
}
