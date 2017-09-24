//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/09-Cubemap Bump Reflection"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_Cube ("Cubemap", CUBE) = "" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;


		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldRefl;
			//使用uv_BumpMap，物体的平面法线将被修改，若需要使用它来影响反射。可以通过声明INTERNAL_DATA来访问修改后的法线信息
			//以及使用WorldReflectionVector (IN, o.Normal)去查找Cubemap中对应的反射信息。
			INTERNAL_DATA
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));

			//#define WorldReflectionVector(data,normal) data.worldRefl
			o.Emission = texCUBE (_Cube, WorldReflectionVector(IN, o.Normal)).rgb;
			//o.Emission = texCUBE (_Cube, IN.worldRefl).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
