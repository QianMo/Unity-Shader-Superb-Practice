
Shader "ShaderSuperb/Session5/26-Unlit-Mobile-Cutout Lightmapped"
{
	Properties 
	{
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutoff"}

		// Non-lightmapped
		Pass 
		{
			Tags { "LightMode" = "Vertex" }

			Alphatest Greater [_Cutoff]

			Lighting Off

			SetTexture [_MainTex] 
			{ 
				constantColor [_Color]
				combine texture*constant
			} 
		}

		// Lightmapped, encoded as RGBM
		Pass 
		{
			Tags { "LightMode" = "VertexLMRGBM" }

			Alphatest Greater [_Cutoff]
			
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

		// Lightmapped, encoded as dLDR
		Pass 
		{
			Tags { "LightMode" = "VertexLM" }

			Alphatest Greater [_Cutoff]

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
	}
}