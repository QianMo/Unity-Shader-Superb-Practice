Shader "ShaderSuperb/Session1/2-ShaderWithVertFunction"
{
	Properties
	{
		_Color("Color",Color)=(1,1,1,1) //float4
		_Vector("Vector",Vector)=(1,2,3,4)//float4
		_Int("Int",Int)=666
		_Float("Float",Float)=666.0
		_Range("Range",Range(1,66))=6
		_2D("Texture",2D)="blue"{}
		_Cube("Cube",Cube)="white"{}
		_3D("Texture",3D)="black"{}
	}

	//=========================================================================
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//=============================================
			//SV_POSITION-剪裁空间下的顶点坐标
			//此函数需完成顶点坐标从模型空间到裁剪空间的变换
			float4 vert(float4 v:POSITION):SV_POSITION
			{
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				return UnityObjectToClipPos(v);
			}

			//=============================================
			//此函数需返回对应屏幕上该像素的颜色值
			//SV_Target- Multiple Render Targets,MRT,渲染目标的语义，表示渲染给那个渲染目标。SV_Target等价于SV_Target0
			//同理还有SV_Target1, SV_Target2, …
			//更多可参考https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
			float4 frag():SV_Target
			{
				return float4(0.6,0.1,0.6,0.6);
			}



			ENDCG
		}

	}
}
