
Shader "ShaderSuperb/Session6/01-Standard Diffuse"
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		//_MainTex ("Albedo (RGB)", 2D) = "white" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		//_Metallic ("Metallic", Range(0,1)) = 0.0
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		//sampler2D _MainTex;

		//--------------------------------------------------------
		//https://docs.unity3d.com/Manual/SL-SurfaceShaders.html
		//Surface shader的Input中可以使用的其他变量：
		//纹理坐标(Texture coordinates)必须被命名为“uv”后接纹理(texture)名字。(或者uv2开始，使用第二纹理坐标集)
		//float3 viewDir - 视图方向( view direction)值。为了计算视差效果(Parallax effects)，边缘光照(rim lighting)等，需要包含视图方向( view direction)值。
		//float4 COLOR semantic -每个顶点(per-vertex)颜色的插值。
		//float4 screenPos - 屏幕空间中的位置。 为了得到反射效果，需要包含屏幕空间中的位置信息.
		//float3 worldPos - 世界空间中的位置。
		//float3 worldRefl - 世界空间中的反射向量。如果表面着色器(surface shader)不写入法线(o.Normal)参数，将包含这个参数
		//float3 worldNormal - 世界空间中的法线向量(normal vector)。如果表面着色器(surface shader)不写入法线(o.Normal)参数，将包含这个参数。
		//float3 worldRefl; INTERNAL_DATA - 世界空间中的反射向量。如果表面着色器(surface shader)不写入法线(o.Normal)参数，将包含这个参数。
		//					为了获得基于每个顶点法线贴图( per-pixel normal map)的反射向量(reflection vector)需要使用世界反射向量(WorldReflectionVector (IN, o.Normal))。
		//float3 worldNormal; INTERNAL_DATA -世界空间中的法线向量(normal vector)。如果表面着色器(surface shader)不写入法线(o.Normal)参数，将包含这个参数。
		//					为了获得基于每个顶点法线贴图( per-pixel normal map)的法线向量(normal vector)需要使用世界法线向量(WorldNormalVector (IN, o.Normal))。
		struct Input 
		{
			float2 uv_MainTex;
		};

		//half _Glossiness;
		//half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
			o.Albedo = _Color.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = _Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
