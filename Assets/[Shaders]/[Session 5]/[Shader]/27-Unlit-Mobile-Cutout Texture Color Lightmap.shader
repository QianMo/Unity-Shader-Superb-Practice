
Shader "ShaderSuperb/Session5/26-Unlit-Mobile-Cutout Lightmapped"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1) 
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		// Non-lightmapped
		Pass 
		{
			Tags { "LightMode" = "Vertex" }
			Lighting Off
			SetTexture [_MainTex] 
			{ 
			constantColor [_Color]
			combine texture*constant
			} 
		}

		// Lightmapped, encoded as dLDR
		Pass 
		{
			Tags { "LightMode" = "VertexLM" }

			Lighting Off
			
			BindChannels 
			{
				Bind "Vertex", vertex
				Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
				Bind "texcoord", texcoord1 // main uses 1st uv
			}

			SetTexture [unity_Lightmap] 
			{
				matrix [unity_LightmapMatrix]
				constantColor [_Color]
				combine texture * constant
			}

			SetTexture [_MainTex] 
			{
				combine texture * previous DOUBLE, texture * primary
			}
		}

		// Lightmapped, encoded as RGBM
		Pass 
		{
			Tags { "LightMode" = "VertexLMRGBM" }

			Lighting Off
			BindChannels 
			{
				Bind "Vertex", vertex
				Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
				Bind "texcoord", texcoord1 // main uses 1st uv
			}

			SetTexture [unity_Lightmap] 
			{
				matrix [unity_LightmapMatrix]
				combine texture * texture alpha DOUBLE
			}

			SetTexture [_MainTex] 
			{
				constantColor [_Color]
				combine constant * previous
			}

			SetTexture [_MainTex] 
			{
				combine texture * previous QUAD, texture * primary
			} 
		}	
	}
}