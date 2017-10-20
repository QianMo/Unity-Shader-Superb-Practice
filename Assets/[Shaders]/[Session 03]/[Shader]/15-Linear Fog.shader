//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html
//fog mode 要设为Linear，才会有效果

Shader "ShaderSuperb/Session3/15-Linear Fog"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM

		#pragma surface surf Lambert finalcolor:mycolor vertex:myvert
		#pragma multi_compile_fog

		sampler2D _MainTex;
		uniform half4 unity_FogStart;
		uniform half4 unity_FogEnd;

		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			half fog;
		};

		void myvert (inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input,data);
			float pos = length(UnityObjectToViewPos(v.vertex).xyz);
			float diff = unity_FogEnd.x - unity_FogStart.x;
			float invDiff = 1.0f / diff;
			data.fog = clamp ((unity_FogEnd.x - pos) * invDiff, 0.0, 1.0);
		}

		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
		{
			#ifdef UNITY_PASS_FORWARDADD
			UNITY_APPLY_FOG_COLOR(IN.fog, color, float4(0,0,0,0));
			#else
			UNITY_APPLY_FOG_COLOR(IN.fog, color, unity_FogColor);
			#endif
		}

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
