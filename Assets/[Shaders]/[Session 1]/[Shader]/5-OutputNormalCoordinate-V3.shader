

Shader "ShaderSuperb/Session1/5-OutputNormalCoordinate-V3"
{
	Properties
	{
		_factor("factor",Range(0,1))=0.5 //float4
	}

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
				float4 vertex:POSITION;//从Unity获取顶点位置
				float3 normal:NORMAL;//从Unity获取法线坐标
				float4 texcoord:TEXCOORD0;//从Unity获取第一组纹理坐标
			};

			//---------------------------------
			//顶点输出，片元输入结构体
			struct v2f
			{
				//裁剪空间中顶点坐标
				float4 position:SV_POSITION;
				//COLOR0和COLOR1等，可作为顶点和片段的输入输出的语义，是精度低，0–1范围内的数据（如简单的颜色值）可选为1维，二维，三维，四维的float，fixed，half
				float normal:COLOR0;

			};

			//=============================================
			//vertex函数需完成顶点坐标从模型空间到裁剪空间的变换
			v2f vert(a2v v)
			{
				v2f o;
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				o.position=UnityObjectToClipPos(v.vertex);
				o.normal=float4(v.normal,1);
				return o;
			}

			//=============================================
			//fragment函数需返回对应屏幕上该像素的颜色值
			float4 frag(v2f i):SV_Target
			{
				return _factor*float4(i.normal,1,1,1);
			}

			ENDCG
		}

	}
}
