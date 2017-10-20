//https://docs.unity3d.com/Manual/SL-SurfaceShaderTessellation.html

// Phong Tessellation modifies positions of the subdivided faces so that the resulting surface follows the mesh normals a bit. 
// It’s quite an effective way of making low-poly meshes become more smooth.

// Unity’s surface shaders can compute Phong tessellation automatically using tessphong:VariableName compilation directive. Here’s an example shader:

Shader "ShaderSuperb/Session4/11-Phong Tessellation"
{
	Properties 
	{
		_EdgeLength ("Edge length", Range(2,50)) = 5
		_Phong ("Phong Strengh", Range(0,1)) = 0.5
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", color) = (1,1,1,0)
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf Lambert vertex:dispNone tessellate:tessEdge tessphong:_Phong nolightmap
		#include "Tessellation.cginc"

		struct appdata 
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		void dispNone (inout appdata v) { }

		float _Phong;
		float _EdgeLength;

		float4 tessEdge (appdata v0, appdata v1, appdata v2)
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
