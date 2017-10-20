//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/06-Blend Texture"
{

	Properties 
	{
		_MainTex ("Texture to blend", 2D) = "black" {}
	}

	SubShader 
	{
		Tags { "Queue" = "Transparent" }
		Pass 
		{
			//Simple Additive
			Blend One One
			//常见混合类型
			//Blend SrcAlpha OneMinusSrcAlpha     // Alpha blending
			//Blend One One                       // Additive
			//Blend One OneMinusDstColor          // Soft Additive
			//Blend DstColor Zero                 // Multiplicative
			//Blend DstColor SrcColor             // 2x Multiplicative

			SetTexture [_MainTex] { combine texture }
		}
	}
	Fallback "Diffuse"
}
