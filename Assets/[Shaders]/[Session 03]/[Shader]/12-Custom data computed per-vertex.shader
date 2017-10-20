//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/12-Custom data computed per-vertex"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _Amount;

		struct Input 
		{
			//在surf程序中直接通过访问uv_MainTex来取得这张贴图当前需要计算的点的坐标值
			float2 uv_MainTex;
			float3 customColor;
		};

		/* appdata_full定义于UnityCG.cginc中：
		struct appdata_full 
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};
		*/
		void vert (inout appdata_full v, out Input o) 
		{
			//用于初始化输入参数，HLSLSupport.cginc ：#define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.customColor = abs(v.normal);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			o.Albedo *= IN.customColor;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
