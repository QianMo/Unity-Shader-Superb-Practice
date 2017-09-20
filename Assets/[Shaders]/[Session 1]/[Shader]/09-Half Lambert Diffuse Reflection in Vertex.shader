

Shader "ShaderSuperb/Session1/9-Half Lambert Diffuse Reflection in Vertex"
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
			//设置为前向渲染路径。保证Unity提供的内置变量值的正确性
			Tags { "LightMode" = "ForwardBase" }
			
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
				float3 normalDirection = normalize( mul( float4(v.normal,0.0),unity_WorldToObject).xyz );

				//平行光源的光线方向
				float3 lightDirection =  normalize( _WorldSpaceLightPos0.xyz);

				// diffuse = max(0,N*L)
				float atten = 1.0;
				float3 diffuseLight = max(0,dot(normalDirection, lightDirection));
				//half lambert = diffuse * 0.5 +0.5;
				float3 halfLambertLight = diffuseLight * 0.5+0.5;
				float3 diffuseReflection = atten *  _Diffuse.rgb * _LightColor0.rgb * halfLambertLight;

				//环境光颜色
				float3 ambient= UNITY_LIGHTMODEL_AMBIENT.rgb;

				//最终颜色
				o.color = float4(diffuseReflection + ambient,1.0);

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
