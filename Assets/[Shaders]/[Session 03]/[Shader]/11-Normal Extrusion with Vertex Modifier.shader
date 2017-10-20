//https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "ShaderSuperb/Session3/11-Normal Extrusion with Vertex Modifier"
{
	Properties
	{
		_MainTex("Main Texture" , 2D) = "grey"{}
		_Amount ("Extrusion Amount", Range(-1,1)) = 0.35
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
		void vert (inout appdata_full v) 
		{
			v.vertex.xyz += v.normal * _Amount;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
