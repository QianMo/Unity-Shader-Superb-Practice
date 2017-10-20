

Shader "ShaderSuperb/Session1/16-Texture with Tiling and Offset"
{
	Properties
	{
		_MainTex("Main Texture",2D)="gray"{} 
	}

	//=========================================================================
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;

			//---------------------------------
			//顶点输入结构体
			struct a2v
			{
				float4 vertex:POSITION;//从Unity获取顶点位置
				float4 texcoord:TEXCOORD0;//从Unity获取第一组纹理坐标
			};

			//---------------------------------
			//顶点输出，片元输入结构体
			struct v2f
			{
				//裁剪空间中顶点坐标
				float4 position:SV_POSITION;
				//纹理uv坐标
				float2 uv :TEXCOORD0;

			};

			//=============================================
			//vertex函数需至少完成顶点坐标从模型空间到裁剪空间的变换
			v2f vert(a2v v)
			{
				v2f o;
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				o.position = UnityObjectToClipPos(v.vertex);
				//传递纹理uv坐标
				//TRANSFORM_TEX定义在UnityCG.cginc里：
				//Transforms 2D UV by scale/bias property
				//#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

				return o;
			}

			//=============================================
			//fragment函数需返回对应屏幕上该像素的颜色值
			float4 frag(v2f i):SV_Target
			{
				float4 texData = tex2D(_MainTex, i.uv);
				return texData;
			}

			ENDCG
		}

	}
}
