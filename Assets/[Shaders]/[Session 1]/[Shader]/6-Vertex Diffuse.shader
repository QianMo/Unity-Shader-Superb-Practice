

Shader "ShaderSuperb/Session1/6-Vertex Diffuse"
{
	Properties
	{
		_Diffuse("Diffuse Color",Color) = (1,1,1,1)
	}

	//=========================================================================
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Diffuse;
			//要用内置的光照颜色，定义uniform float4 _LightColor0或#include "Lighting.cginc" ;
			uniform float4 _LightColor0;


			//---------------------------------
			//顶点输入结构体
			struct a2v
			{
				float4 vertex:POSITION;//从Unity获取顶点位置
				float3 normal:NORMAL;//从Unity获取法线坐标
			};

			//---------------------------------
			//顶点输出，片元输入结构体
			struct v2f
			{
				//裁剪空间中顶点坐标
				float4 position:SV_POSITION;
				//COLOR0和COLOR1等，可作为顶点和片段的输入输出的语义，是精度低，0–1范围内的数据（如简单的颜色值）可选为1维，二维，三维，四维的float，fixed，half
				float4 color:COLOR0;

			};

			//=============================================
			//vertex函数需至少完成顶点坐标从模型空间到裁剪空间的变换
			v2f vert(a2v v)
			{
				v2f o;
				//模型空间的坐标转换为世界空间中坐标||float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				o.position=UnityObjectToClipPos(v.vertex);

				//世界空间中法线方向
				fixed3 normalDirection = normalize( mul( float4(v.normal,0.0),unity_WorldToObject).xyz );

				//平行光源的光线方向
				fixed3 lightDirection =  -normalize( _WorldSpaceLightPos0.xyz);

				//漫反射的颜色=i_diffuse * i_incoming * k_diffuse *max(0,N*L)
				fixed3 diffuse = _Diffuse.rgb * _LightColor0.rgb * max(0,dot(normalDirection, lightDirection));

				//环境光颜色
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				//最终颜色
				o.color = float4(diffuse + ambient,1.0);

				return o;
			}

			//=============================================
			//fragment函数需返回对应屏幕上该像素的颜色值
			float4 frag(v2f i):SV_Target
			{
				//直接使用顶点输出的颜色
				return i.color;
			}

			ENDCG
		}

	}
}
