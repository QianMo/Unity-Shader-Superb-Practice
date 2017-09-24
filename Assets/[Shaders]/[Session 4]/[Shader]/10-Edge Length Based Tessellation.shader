//https://docs.unity3d.com/Manual/SL-SurfaceShaderTessellation.html

//We can also change tessellation level based on distance from the camera. For example, we could define two distance values; 
//distance at which tessellation is at maximum (say, 10 meters), and distance towards which tessellation level gradually decreases (say, 20 meters).

Shader "ShaderSuperb/Session4/10-Edge Length Based Tessellation"
{
	Properties 
	{
		_EdgeLength ("Edge length", Range(2,50)) = 15
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DispTex ("Disp Texture", 2D) = "gray" {}
		_NormalMap ("Normalmap", 2D) = "bump" {}
		_Displacement ("Displacement", Range(0, 1.0)) = 0.3
		_Color ("Color", color) = (1,1,1,0)
		_SpecColor ("Spec color", color) = (0.5,0.5,0.5,0.5)
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessEdge nolightmap
		#pragma target 4.6
		#include "Tessellation.cginc"

		struct appdata 
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		float _EdgeLength;

		float4 tessEdge (appdata v0, appdata v1, appdata v2)
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		sampler2D _DispTex;
		float _Displacement;

		void disp (inout appdata v)
		{
			float d = tex2Dlod(_DispTex, float4(v.texcoord.xy,0,0)).r * _Displacement;
			v.vertex.xyz += v.normal * d;
		}

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _NormalMap;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Specular = 0.2;
			o.Gloss = 1.0;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
		}

		ENDCG
	}
	Fallback "Diffuse"
}
