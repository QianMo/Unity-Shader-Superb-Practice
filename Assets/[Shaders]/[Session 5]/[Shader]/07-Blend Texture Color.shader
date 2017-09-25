//https://docs.unity3d.com/Manual/SL-SetTexture.html

Shader "ShaderSuperb/Session5/07-Blend Texture Color"
{

	Properties 
	{
		_MainTex ("Texture", 2D) = "black" {}  
		_Color ("Main Color", Color) = (1,1,1,0)    
	}

	SubShader 
	{
		Tags { "Queue" = "Transparent" }
		Pass 
		{
			//光照 打开/关闭
			Lighting Off

			//Simple Additive
			//Blend One One
			//常见混合类型
			//Blend SrcAlpha OneMinusSrcAlpha     // Alpha blending
			//Blend One One                       // Additive
			Blend One OneMinusDstColor          // Soft Additive
			//Blend DstColor Zero                 // Multiplicative
			//Blend DstColor SrcColor             // 2x Multiplicative

			SetTexture [_MainTex]  
			{   
				// 使颜色属性进入混合器    
				constantColor [_Color]    
				// 使用纹理的alpha通道插值混合顶点颜色    
				combine texture * constant 
			} 
		}
	}
	Fallback "Diffuse"
}
