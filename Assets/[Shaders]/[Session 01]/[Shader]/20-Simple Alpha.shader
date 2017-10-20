Shader "ShaderSuperb/Session1/20-Simple Alpha"
{
	Properties
	{
		_Color("Color",Color)=(1,1,1,1) //float4

	}

	//=========================================================================
	SubShader
	{
		//透明shader. Step 1. 设置混合运算类型
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			//透明shader. Step 2. 设置合理的tags 
			Tags{ "RenderType"="Transparent" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			float4 _Color;
			//=============================================
			//SV_POSITION-剪裁空间中的顶点坐标
			//此函数需完成顶点坐标从模型空间到裁剪空间的变换
			float4 vert(float4 v:POSITION):SV_POSITION
			{
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				return UnityObjectToClipPos(v);
			}

			//=============================================
			//此函数需返回对应屏幕上该像素的颜色值
			//SV_Target- Multiple Render Targets,MRT,渲染目标的语义
			float4 frag():SV_Target
			{
				//透明shader. Step 3. 返回小于1的alpha通道
				return _Color;
			}



			ENDCG
		}

	}
}
