//http://wiki.unity3d.com/index.php?title=Anisotropic_Highlight_Shader

Shader "ShaderSuperb/Session6/13-Accessing Vertex Data"
{
	Properties
	{
		_MainTint("Global Color Tint", Color) = (1,1,1,1)
	}

	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0

		float4 _MainTint;

		struct Input
		{
			float2 uv_MainTex;
			float4 vertColor;
		};


		/*appdata_full定义于UnityCG.cginc中
		struct appdata_full 
		{  
			float4 vertex : POSITION;  
			float4 tangent : TANGENT;  
			float3 normal : NORMAL;  
			float4 texcoord : TEXCOORD0;  
			float4 texcoord1 : TEXCOORD1;  
			fixed4 color : COLOR;  
		}; 

		*/

		void vert(inout appdata_full v, out Input o)
		{
			//solve" 'vert': output parameter 'o' not completely initialized "error
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.vertColor = v.vertex;
			//o.vertColor.rgb = v.normal.xyz;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = IN.vertColor.rgb;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
