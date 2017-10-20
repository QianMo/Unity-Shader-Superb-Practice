
Shader "ShaderSuperb/Session5/24-Unlit-Mobile-Trans Color Cutout"
{
	Properties 
	{
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader 
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutoff" }
		Pass 
		{
			Alphatest Greater [_Cutoff]
			Lighting Off
			SetTexture [_MainTex] 
			{
				constantColor [_Color]
				combine texture * constant DOUBLE
			} 
		}
	}
}