Shader "ShaderSuperb/Session1/3-OutputNormalCoordinate"
{

	//=========================================================================
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform float _factor;

			//---------------------------------
			//顶点输入结构体
			//更多语义semantics可参考https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
			struct a2v
			{
				float4 vertex:POSITION;//从Unity获取模型空间的顶点位置
				float3 normal:NORMAL;//从Unity获取法模型空间的线坐标
			};

			//---------------------------------
			//顶点输出，片元输入结构体
			struct v2f
			{
				float4 position:SV_POSITION;
				float3 normal:COLOR0;
			};

			//=============================================
			//vertex函数需至少完成顶点坐标从模型空间到裁剪空间的变换
			v2f vert(a2v v)
			{
				v2f o;
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				o.position=UnityObjectToClipPos(v.vertex);
				o.normal=v.normal;
				return o;
			}

			//=============================================
			//fragment函数需返回对应屏幕上该像素的颜色值
			//更多语义可参考https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
			float4 frag(v2f i):SV_Target
			{
				return float4(i.normal,1);
			}

			ENDCG
		}

	}
}
